#include "types.h" 
#include "defs.h" 
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "mlfq.h"
#include "stride.h"

void initStride(void){
    curStridePor = 0;
    curStridePor += MlfqCPUShare;
    minPass = 999999999;
}
int set_cpu_share(int share){
    int stride;

    if(STRIDE_MAXIMUM_PORTION < curStridePor + share){
        cprintf("Ther is no cpu_share for %s / pid %d / curStridePor is %d\n",proc->name,proc->pid, curStridePor);
        proc->stride = 0;
        stride = 0;
        return -1;
    }

    curStridePor += share;
    stride = STRIDE_LARGE_NUMBER / share;
    if(proc && proc->pid > 2){
        findMinPassStride();
        proc->pass = minPass-10;
        proc->stride = stride;
    }
    dequeue(&qOfM[proc->qPosi],proc);
    //cprintf("\n                 pid %d req/// share : %d  pass %d /total %d \n",proc->pid, share,proc->pass,  curStridePor);
    yield();
    //printPtable();
    //printMlfq();

    return stride;

}
int set_Mlfq_cpu_share(int share){
    int stride;

    if(STRIDE_MAXIMUM_PORTION < curStridePor + share) return -1;

    curStridePor += share;
    stride = STRIDE_LARGE_NUMBER / share;
    MlfqProc->stride = stride;

    return stride;

}

void cut_cpu_share(int stride){
    int share;
    int tmp;

   if(stride != 0) share = STRIDE_LARGE_NUMBER / stride;
   else share=0;
    tmp = curStridePor - share;
    curStridePor = tmp;

}

/*
   void printStrideAll(){
   struct proc* p;
   cprintf("\nStirde All :-------------------------------------\n");
   cprintf("\nStirde curStridePor :%d-------------------------------------\n",curStridePor);
   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
   if(p)
   cprintf(" pid %d / state %d / cT %d / stride %d / pass %d\n",p->pid,p->state,p->consumedTime, p->stride, p->pass);

   }

   }
   */
