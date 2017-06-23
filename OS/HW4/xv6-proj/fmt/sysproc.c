4600 #include "types.h"
4601 #include "x86.h"
4602 #include "defs.h"
4603 #include "date.h"
4604 #include "param.h"
4605 #include "memlayout.h"
4606 #include "mmu.h"
4607 #include "proc.h"
4608 #include "mlfq.h"
4609 #include "stride.h"
4610 
4611 int
4612 sys_fork(void)
4613 {
4614   return fork();
4615 }
4616 
4617 int
4618 sys_exit(void)
4619 {
4620   exit();
4621   return 0;  // not reached
4622 }
4623 
4624 int
4625 sys_wait(void)
4626 {
4627   return wait();
4628 }
4629 
4630 int
4631 sys_kill(void)
4632 {
4633   int pid;
4634 
4635   if(argint(0, &pid) < 0)
4636     return -1;
4637   return kill(pid);
4638 }
4639 
4640 int
4641 sys_getpid(void)
4642 {
4643   return proc->pid;
4644 }
4645 
4646 
4647 
4648 
4649 
4650 int
4651 sys_getppid(void)
4652 {
4653     return proc->parent->pid;
4654 }
4655 
4656 void
4657 sys_yield(void)
4658 {
4659     return yield();
4660 }
4661 int
4662 sys_getlev(void)
4663 {
4664     return curQ;
4665 }
4666 int
4667 sys_set_cpu_share(void)
4668 {
4669     int share;
4670     if(argint(0, &share) < 0)
4671         return -1;
4672     return set_cpu_share(share);
4673 }
4674 int
4675 sys_sbrk(void)
4676 {
4677   int addr;
4678   int n;
4679 
4680   if(argint(0, &n) < 0)
4681     return -1;
4682  //ADDED
4683   if(proc->isthread == 1){
4684       proc->sz = proc->parent->sz;
4685   }
4686   addr = proc->sz;
4687 
4688   if(growproc(n) < 0)
4689     return -1;
4690   return addr;
4691 }
4692 
4693 
4694 
4695 
4696 
4697 
4698 
4699 
4700 int
4701 sys_sleep(void)
4702 {
4703   int n;
4704   uint ticks0;
4705 
4706   if(argint(0, &n) < 0)
4707     return -1;
4708   acquire(&tickslock);
4709   ticks0 = ticks;
4710   while(ticks - ticks0 < n){
4711     if(proc->killed){
4712       release(&tickslock);
4713       return -1;
4714     }
4715     sleep(&ticks, &tickslock);
4716   }
4717   release(&tickslock);
4718   return 0;
4719 }
4720 
4721 // return how many clock tick interrupts have occurred
4722 // since start.
4723 int
4724 sys_uptime(void)
4725 {
4726   uint xticks;
4727 
4728   acquire(&tickslock);
4729   xticks = ticks;
4730   release(&tickslock);
4731   return xticks;
4732 }
4733 
4734 int
4735 sys_thread_create(void)
4736 {
4737     int thread;
4738     int addrOfStartRoutine;
4739     int arg;
4740 
4741     if(argint(0, &thread) < 0)
4742         return -1;
4743     if(argint(1, &addrOfStartRoutine) < 0)
4744         return -1;
4745     if(argint(2, &arg) < 0)
4746         return -1;
4747 
4748     return thread_create((thread_t *)thread, (void*)addrOfStartRoutine,(void*)arg);
4749 
4750 }
4751 
4752 void
4753 sys_thread_exit(void)
4754 {
4755     int retval;
4756 
4757     if(argint(0, &retval) < 0){
4758     }
4759 
4760     return thread_exit((void*)retval);
4761 }
4762 
4763 int
4764 sys_thread_join(void)
4765 {
4766     int thread;
4767     int retval;
4768 
4769     if(argint(0, &thread) < 0)
4770         return -1;
4771     if(argint(1, &retval) < 0)
4772         return -1;
4773     return thread_join((thread_t)thread, (void**)retval);
4774 }
4775 
4776 
4777 
4778 
4779 
4780 
4781 
4782 
4783 
4784 
4785 
4786 
4787 
4788 
4789 
4790 
4791 
4792 
4793 
4794 
4795 
4796 
4797 
4798 
4799 
