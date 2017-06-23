#define STRIDE_TIME_QUANTUM 15
#define STRIDE_MAXIMUM_PORTION 100
#define STRIDE_LARGE_NUMBER 10000
#define TIME_PER_ONE_PASS 20

uint curStridePor;
uint minPass;

void initStride(void);
int set_cpu_share(int share);
int set_Mlfq_cpu_share(int share);
void printStrideAll();
