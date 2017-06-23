#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "mlfq.h"
#include "stride.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return proc->pid;
}

int
sys_getppid(void)
{
    return proc->parent->pid;
}

void
sys_yield(void)
{
    return yield();
}
int
sys_getlev(void)
{
    return curQ;
}
int
sys_set_cpu_share(void)
{
    int share;
    if(argint(0, &share) < 0)
        return -1;
    return set_cpu_share(share);
}
int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
 //ADDED
  if(proc->isthread == 1){
      proc->sz = proc->parent->sz;
  }
  addr = proc->sz;

  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_thread_create(void)
{
    int thread;
    int addrOfStartRoutine;
    int arg;

    if(argint(0, &thread) < 0)
        return -1;
    if(argint(1, &addrOfStartRoutine) < 0)
        return -1;
    if(argint(2, &arg) < 0)
        return -1;

    return thread_create((thread_t *)thread, (void*)addrOfStartRoutine,(void*)arg);

}

void
sys_thread_exit(void)
{
    int retval;

    if(argint(0, &retval) < 0){
    }

    return thread_exit((void*)retval);
}

int
sys_thread_join(void)
{
    int thread;
    int retval;
    
    if(argint(0, &thread) < 0)
        return -1;
    if(argint(1, &retval) < 0)
        return -1;
    return thread_join((thread_t)thread, (void**)retval);
}
