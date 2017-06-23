#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "mlfq.h"
#include "spinlock.h"

void error(char *message)
{
    cprintf("%s\n",message);
    return ;
}

void initMlfq(struct Mlfq* q)
{
    int i;
    q->front = 0;
    q->rear = 0;
    q->count = 0;
    q->rCount = 0;
    for(i=0; i<MAX_QUEUE_SIZE;i++){
        deleteProcOfQ(&q->queue[i]);
    }
    qOfM[0].level = 0;
    qOfM[1].level = 1;
    qOfM[2].level = 2;
    qOfM[0].timeQuan = Q0_TIME_QUANTUM;
    qOfM[1].timeQuan = Q1_TIME_QUANTUM;
    qOfM[2].timeQuan = Q2_TIME_QUANTUM;
    qOfM[0].timeAllot = Q0_TIME_ALLOT; 
    qOfM[1].timeAllot = Q1_TIME_ALLOT; 
    qOfM[2].timeAllot = Q2_TIME_ALLOT; 
}
//front와 rear가 같을 경우 큐는 empty이다
int is_empty(struct Mlfq* q)
{
    if(q->front == q->rear && q->count == 0 ){
        cprintf("Queue is empty\n");
        return 1;
    }else return 0;

}
//front와 rear+1가 같을 경우 큐는 full이다
int is_full (struct Mlfq* q)
{
    if((q->rear)%MAX_QUEUE_SIZE == q->front && q->count == MAX_QUEUE_SIZE){
        cprintf("Queue is full\n");
        return 1;
    }
    else return 0;
}
// q->rear에 1을 증가 하고 MAX_QUEUE_SIZE로 나눈 값을 q->rear에 다시 넣고
// q->rear에 item을 넣는다.
int enqueue( struct Mlfq* q, struct proc* item )
{
    if(is_full(q)) return -1;
    q->rear = (q->rear + 1)% MAX_QUEUE_SIZE;
    q->queue[q->rear] = item;
    item->qPosi = q->level;
    q->count++;
    //cprintf("           enque %d level : %d\n",item->pid,item->qPosi);
//    mlfqPrint();
    return 0;
}


// q->front에 1을 증가 하고 MAX_QUEUE_SIZE로 나눈 값을 q->front에 다시 넣고
// q->front의 값을 얻어온다.
struct proc* dequeue(struct Mlfq* q)
{
    struct proc* ret;

    if(is_empty(q)) return 0;
    // checks if q is full of SLEEPING of empty
    checkRcount(q);
    if(q->rCount == 0) return 0;

    q->front = (q->front + 1)% MAX_QUEUE_SIZE;
    ret = q->queue[q->front];
    q->count--;
    //cprintf("\n                   deque %d\n",ret->pid);
    deleteProcOfQ(&q->queue[q->front]);
    if(ret->state != RUNNING ){
        //cprintf("       -----state %d\n",ret->state);
        enqueue(q,ret);     //move SLEEPING process to rear
        //cprintf("   -----\n");
        dequeue(q);
    }

    return ret;
}
struct proc* normalDequeue(struct Mlfq* q)
{
    struct proc* ret;

    if(is_empty(q)) return 0;

    q->front = (q->front + 1)% MAX_QUEUE_SIZE;
    ret = q->queue[q->front];
    q->count--;
    deleteProcOfQ(&q->queue[q->front]);

    return ret;
}
void deleteProcOfQ(struct proc** p){
    if(*p) *p=0;
}
struct proc* peekMlfq(struct Mlfq* q)
{
    //if(is_empty(q)) return 0;

    struct proc* ret;
    ret = q->queue[(q->front+1) % MAX_QUEUE_SIZE];
    return ret;
}
    

struct proc* idxPeekMlfq(struct Mlfq* q, int index)
{

    struct proc* ret;
    ret = q->queue[(q->front+1+index) % MAX_QUEUE_SIZE];
    return ret;
}

void checkRcount(struct Mlfq* q){
    int i=0;
    struct proc* p;

    q->rCount = q->count;
    //check q, how many procs are SLEEPING
    for(p = peekMlfq(q);(int)p; p = idxPeekMlfq(q,i)){
        if(p->state != RUNNING && p->state != RUNNABLE){
            q->rCount--;
        }
        i++;
    }
}
void printMlfq(void)
{
    int j=0;

        checkRcount(&qOfM[0]);
        checkRcount(&qOfM[1]);
        checkRcount(&qOfM[2]);
    cprintf("\n curQ : %d -----------------------------------------\n",curQ);
    cprintf("\n ticks : %d -----------------------------------------\n",ticks);
    cprintf(" Q0 -----------------------------------------\n");
    cprintf("                   count : %d\n",qOfM[0].count);
    cprintf("                   rCount: %d\n",qOfM[0].rCount);
    cprintf("                   front : %d\n",qOfM[0].front);
    cprintf("                   rear: %d\n",qOfM[0].rear);
    for(j = qOfM[0].front+1; j <= qOfM[0].rear; j++){
        cprintf("\n                   pid: %d\n",qOfM[0].queue[j]->pid);
        cprintf("                   name : %s\n",qOfM[0].queue[j]->name);
        cprintf("                   state: %d\n",qOfM[0].queue[j]->state);
        cprintf("                   cT: %d\n",qOfM[0].queue[j]->consumedTime);
        cprintf("                   j : %d\n\n",j);
    }
    cprintf(" Q1 -----------------------------------------\n");
    cprintf("                   count : %d\n",qOfM[1].count);
    cprintf("                   rCount: %d\n",qOfM[1].rCount);
    cprintf("                   front : %d\n",qOfM[1].front);
    cprintf("                   rear: %d\n",qOfM[1].rear);
    for(j = qOfM[1].front+1; j <= qOfM[1].rear; j++){
        cprintf("\n                   pid: %d\n",qOfM[1].queue[j]->pid);
        cprintf("                   name : %s\n",qOfM[1].queue[j]->name);
        cprintf("                   state: %d\n",qOfM[1].queue[j]->state);
        cprintf("                   cT: %d\n",qOfM[1].queue[j]->consumedTime);
        cprintf("                   j : %d\n\n",j);
    }

    cprintf(" Q2 -----------------------------------------\n");
    cprintf("                   count : %d\n",qOfM[2].count);
    cprintf("                   rCount: %d\n",qOfM[2].rCount);
    cprintf("                   front : %d\n",qOfM[2].front);
    cprintf("                   rear: %d\n",qOfM[2].rear);
    for(j = qOfM[2].front+1; j <= qOfM[2].rear; j++){
        cprintf("\n                   pid: %d\n",qOfM[2].queue[j]->pid);
        cprintf("                   name : %s\n",qOfM[2].queue[j]->name);
        cprintf("                   state: %d\n",qOfM[2].queue[j]->state);
        cprintf("                   cT: %d\n",qOfM[2].queue[j]->consumedTime);
        cprintf("                   j : %d\n\n",j);
    }
    cprintf(" End -----------------------------------------\n");
}
void boostMlfq(void)
{
    int i = 0, j = 1, h=0;
    int qCount;
    struct proc* p;

    while(j<MAX_QUEUE_NUM){
        qCount = qOfM[j].count;
        for(p = peekMlfq(&qOfM[j]);(int)p; p = idxPeekMlfq(&qOfM[j],i)){
            h = 0;
            if(qCount == 0) break;
            if(p && p->state != UNUSED){
                normalDequeue(&qOfM[j]);
                qCount--;
                while(enqueue(&qOfM[h],p) == -1 && h < MAX_QUEUE_NUM){
                     h++;
                }

            }
            //i++;
        }
            i=0;
         j++;
    }
}


void printMLFQAll(){
    int i=0, j=0;
    for(i=0;i<MAX_QUEUE_NUM;i++){
        cprintf("\nQ%d-------------------------------------\n",i);
        for(j=0;j<MAX_QUEUE_SIZE;j++){
            if(qOfM[i].queue[j])
            cprintf(" pid %d / state %d / cT %d\n",qOfM[i].queue[j]->pid,qOfM[i].queue[j]->state,qOfM[i].queue[j]->consumedTime);

        }
    }

}
