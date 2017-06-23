#include <stdio.h>
#include <stdlib.h>

#define MAX_QUEUE_SIZE 5
typedef int element;
typedef struct {
    element queue[MAX_QUEUE_SIZE ];
    int front, rear;
} QueueType;

void init(QueueType *q);
void error(char *message);
int is_empty(QueueType *q);
int is_full (QueueType *q);
void enqueue( QueueType *q, element item );
element dequeue(QueueType *q);
element peek(QueueType *q);


int main(int argc, char *argv[])
{
    char command;
    int key,temp;
    FILE *input;
    QueueType *q;
    QueueType t;
    q = &t;

    init(q);
    printf("init front = 0, rear = 0\n");
    //입력 파일을 지정하지 않았을 경우
    if(argc == 1)
        input = fopen("input.txt", "r");
    //입력 파일을 지정했을 경우
    else if(argc == 2)
        input = fopen(argv[1], "r");
    //아규먼트가 많을 경우
    else error("Usage : HW3 arg\n");
    //파일을 찾을 수 없을경우
    if(input == NULL)
        error("Can't find the file\n");
    //while문 안에서 input파일 내용을 fgetc로 얻어온다
    while(1) {
        command = fgetc(input);
        if(feof(input)) break;
        switch(command) {
            case 'e':
                fscanf(input, "%d", &key);//enqueue할 key값을 얻어온다.
                if(!is_full(q)){
                    enqueue(q,key);
                    printf("enqueue() = %d\n",key);
                    printf("front = %d, rear = %d\n",q->front, q->rear);
                }
                break;
            case 'd'://dequeue 일 경우
                if(!is_empty(q)){
                    temp = dequeue(q);
                    printf("dequeue() = %d\n",temp);
                    printf("front = %d, rear = %d\n",q->front, q->rear);
                }
                break;
            case 'p'://peek일 경우
                if(!is_empty(q)){
                    temp = peek(q);
                    printf("peek() = %d\n",temp);
                    printf("front = %d, rear = %d\n",q->front, q->rear);
                }
                break;
            default :
                ;

        }
    }
    fclose(input);
    return 0;
}

void error(char *message)
{
    fprintf(stderr,"%s\n",message);
    exit(1);
}


void init(QueueType *q)
{
    q->front =0;
    q->rear = 0;
}
//front와 rear가 같을 경우 큐는 empty이다
int is_empty(QueueType *q)
{
    if(q->front == q->rear){
        printf("Queue is empty\n");
        return 1;
    }else return 0;

}
//front와 rear+1가 같을 경우 큐는 full이다
int is_full (QueueType *q)
{
    if((q->rear + 1)%MAX_QUEUE_SIZE == q->front){
        printf("Queue is full\n");
        return 1;
    }
    else return 0;
}
// q->rear에 1을 증가 하고 MAX_QUEUE_SIZE로 나눈 값을 q->rear에 다시 넣고
// q->rear에 item을 넣는다.
void enqueue( QueueType *q, element item )
{
    q->rear = (q->rear + 1)% MAX_QUEUE_SIZE;
    q->queue[q->rear] = item;
}


// q->front에 1을 증가 하고 MAX_QUEUE_SIZE로 나눈 값을 q->front에 다시 넣고
// q->front의 값을 얻어온다.
element dequeue(QueueType *q)
{
    element ret;

    q->front = (q->front + 1)% MAX_QUEUE_SIZE;
    ret = q->queue[q->front];
    return ret;
}

// q->front+1을 MAX_QUEUE_SIZE로 나눈 값을 얻어온다.
element peek(QueueType *q)
{
    element ret;
    ret = q->queue[(q->front+1) % MAX_QUEUE_SIZE];
    return ret;
}

