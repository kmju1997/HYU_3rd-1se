#include "types.h" 
#include "defs.h" 
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "mlfq.h"
#include "stride.h"

void initStride(struct Stride* q){
    curStridePor = 0;
    int i;
    q->front = 0;
    q->rear = 0;
    q->count = 0;
    q->rCount = 0;
    for(i=0; i<MAX_QUEUE_SIZE;i++){
        deleteProcOfQS(&q->queue[i]);
    }
 
}
int set_cpu_share(int share){
    int stride;

    if(STRIDE_MAXIMUM_PORTION < curStridePor + share) return -1;

    curStridePor += share;
    stride = STRIDE_LARGE_NUMBER / share;
    if(proc && proc->pid > 2){
        proc->stride = stride;
    }
    
    enqueueS(&qOfS,proc);

    return stride;
    
}
int set_Mlfq_cpu_share(int share){
    int stride;

    if(STRIDE_MAXIMUM_PORTION < curStridePor + share) return -1;

    curStridePor += share;
    stride = STRIDE_LARGE_NUMBER / share;
        MlfqProc.stride = stride;
    
    enqueueS(&qOfS,&MlfqProc);

    return stride;
    
}
int is_emptyS(struct Stride* q)
{
    if(q->front == q->rear && q->count == 0 ){
        cprintf("Queue is empty\n");
        return 1;
    }else return 0;

}
int is_fullS (struct Stride* q)
{
    if((q->rear)%MAX_QUEUE_SIZE == q->front && q->count == MAX_QUEUE_SIZE){
        cprintf("Queue is full\n");
        return 1;
    }
    else return 0;
}
int enqueueS( struct Stride* q, struct proc* item )
{
    if(is_fullS(q)) return -1;
    q->rear = (q->rear + 1)% MAX_QUEUE_SIZE;
    q->queue[q->rear] = item;
    q->count++;
    //cprintf("\n                   enque %d\n",item->pid);
    return 0;
}


struct proc* dequeueS(struct Stride* q)
{
    struct proc* ret;

    if(is_emptyS(q)) return 0;
    // checks if q is full of SLEEPING of empty
    checkRcountS(q);
    if(q->rCount == 0) return 0;

    q->front = (q->front + 1)% MAX_QUEUE_SIZE;
    ret = q->queue[q->front];
    q->count--;
    //cprintf("\n                   deque %d\n",ret->pid);
    deleteProcOfQS(&q->queue[q->front]);
    if(ret->state != RUNNING ){
        //cprintf("       -----state %d\n",ret->state);
        enqueueS(q,ret);     //move SLEEPING process to rear
        //cprintf("   -----\n");
        dequeueS(q);
    }

    return ret;
}
struct proc* normaldequeueS(struct Stride* q)
{
    struct proc* ret;

    if(is_emptyS(q)) return 0;

    q->front = (q->front + 1)% MAX_QUEUE_SIZE;
    ret = q->queue[q->front];
    q->count--;
    deleteProcOfQS(&q->queue[q->front]);

    return ret;
}
void deleteProcOfQS(struct proc** p){
    if(*p) *p=0;
}
struct proc* peekStride(struct Stride* q)
{
    //if(is_emptyS(q)) return 0;

    struct proc* ret;
    ret = q->queue[(q->front+1) % MAX_QUEUE_SIZE];
    return ret;
}
    

struct proc* idxPeekStride(struct Stride* q, int index)
{

    struct proc* ret;
    ret = q->queue[(q->front+1+index) % MAX_QUEUE_SIZE];
    return ret;
}

void checkRcountS(struct Stride* q){
    int i=0;
    struct proc* p;

    q->rCount = q->count;
    //check q, how many procs are SLEEPING
    for(p = peekStride(q);(int)p; p = idxPeekStride(q,i)){
        if(p->state != RUNNING && p->state != RUNNABLE){
            q->rCount--;
        }
        i++;
    }
}
void printStride(void)
{
    int j=0;

        checkRcountS(&qOfS);
    cprintf("\n ticks : %d -----------------------------------------\n",ticks);
    cprintf(" Stride -----------------------------------------\n");
    cprintf("                   count : %d\n",qOfS.count);
    cprintf("                   rCount: %d\n",qOfS.rCount);
    cprintf("                   front : %d\n",qOfS.front);
    cprintf("                   rear: %d\n",qOfS.rear);
    for(j = qOfS.front+1; j <= qOfS.rear; j++){
        cprintf("\n                   pid: %d\n",qOfS.queue[j]->pid);
        cprintf("                   name : %s\n",qOfS.queue[j]->name);
        cprintf("                   state: %d\n",qOfS.queue[j]->state);
        cprintf("                   cT: %d\n",qOfS.queue[j]->consumedTime);
        cprintf("                   j : %d\n\n",j);
    }
    
    cprintf(" End -----------------------------------------\n");
}
void printStrideAll(){
    int j=0;
        cprintf("\nStirde All :-------------------------------------\n");
        cprintf("\nStirde curStridePor :%d-------------------------------------\n",curStridePor);
        for(j=0;j<MAX_QUEUE_SIZE;j++){
            if(qOfS.queue[j])
            cprintf(" pid %d / state %d / cT %d / stride %d / pass %d\n",qOfS.queue[j]->pid,qOfS.queue[j]->state,qOfS.queue[j]->consumedTime, qOfS.queue[j]->stride, qOfS.queue[j]->pass);

        }

}
