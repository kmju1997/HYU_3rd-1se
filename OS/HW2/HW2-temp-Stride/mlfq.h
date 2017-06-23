#define MAX_QUEUE_SIZE 64
#define MAX_QUEUE_NUM 3
#define Q0_TIME_QUANTUM 1   //5 ticks
#define Q1_TIME_QUANTUM 1  //10 ticks
#define Q2_TIME_QUANTUM 1  //20 ticks
#define Q0_TIME_ALLOT 5
#define Q1_TIME_ALLOT 10
#define Q2_TIME_ALLOT 20
#define MLFQ_BOOST_TIME 100
typedef struct Mlfq{
    struct proc* queue[MAX_QUEUE_SIZE ];
    ushort level;
    ushort front;
    ushort rear;
    ushort count;
    short rCount;  //count RUNNABLE PROC
    ushort timeQuan;
    ushort timeAllot;
}Mlfq;

struct proc MlfqProc;
struct Mlfq qOfM[3];

uint curQ;

void initMlfq(struct Mlfq* q);
void initMlfqGlobal();
void error(char *message);
int is_empty(struct Mlfq* q);
int is_full (struct Mlfq* q);
int enqueue( struct Mlfq* q, struct proc* item );
struct proc* dequeue(struct Mlfq* q);
struct proc* normalDequeue(struct Mlfq* q);
void deleteProcOfQ(struct proc** p);
struct proc* peekMlfq(struct Mlfq* q);
struct proc* idxPeekMlfq(struct Mlfq* q, int index);
void checkRcount(struct Mlfq* q);
void printMlfq(void);
void boostMlfq(void);
void printMLFQAll();
