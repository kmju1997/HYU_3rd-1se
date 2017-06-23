#define STRIDE_TIME_QUANTUM 15
#define STRIDE_MAXIMUM_PORTION 100
#define STRIDE_LARGE_NUMBER 10000

uint curStridePor;

typedef struct Stride{
    struct proc* queue[MAX_QUEUE_SIZE];
    ushort front;
    ushort rear;
    ushort count;
    short rCount;  //count RUNNABLE PROC
}Stride;

struct Stride qOfS;



void initStride(struct Stride* q);
int set_cpu_share(int share);
int set_Mlfq_cpu_share(int share);
int is_emptyS(struct Stride* q);
int is_fullS (struct Stride* q);
int enqueueS( struct Stride* q, struct proc* item );
struct proc* dequeueS(struct Stride* q);
struct proc* normalDequeueS(struct Stride* q);
void deleteProcOfQS(struct proc** p);
struct proc* peekStride(struct Stride* q);
struct proc* idxPeekStride(struct Stride* q, int index);
void checkRcountS(struct Stride* q);
void printStride(void);
void printStrideAll();
