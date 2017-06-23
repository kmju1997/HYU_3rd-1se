#define STRIDE_TIME_QUANTUM 15
#define STRIDE_MAXIMUM_PORTION 100
#define STRIDE_LARGE_NUMBER 100
#define TIME_PER_ONE_PASS 20

int curStridePor;
uint minPass;

void initStride(void);
int set_cpu_share(int share);
int set_Mlfq_cpu_share(int share);
void printStrideAll();
void cut_cpu_share(int stride);
