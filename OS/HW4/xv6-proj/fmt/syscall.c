4400 #include "types.h"
4401 #include "defs.h"
4402 #include "param.h"
4403 #include "memlayout.h"
4404 #include "mmu.h"
4405 #include "proc.h"
4406 #include "x86.h"
4407 #include "syscall.h"
4408 
4409 // User code makes a system call with INT T_SYSCALL.
4410 // System call number in %eax.
4411 // Arguments on the stack, from the user call to the C
4412 // library system call function. The saved user %esp points
4413 // to a saved program counter, and then the first argument.
4414 
4415 // Fetch the int at addr from the current process.
4416 int
4417 fetchint(uint addr, int *ip)
4418 {
4419   if(addr >= proc->sz || addr+4 > proc->sz)
4420     return -1;
4421   *ip = *(int*)(addr);
4422   return 0;
4423 }
4424 
4425 // Fetch the nul-terminated string at addr from the current process.
4426 // Doesn't actually copy the string - just sets *pp to point at it.
4427 // Returns length of string, not including nul.
4428 int
4429 fetchstr(uint addr, char **pp)
4430 {
4431   char *s, *ep;
4432 
4433   if(addr >= proc->sz)
4434     return -1;
4435   *pp = (char*)addr;
4436   ep = (char*)proc->sz;
4437   for(s = *pp; s < ep; s++)
4438     if(*s == 0)
4439       return s - *pp;
4440   return -1;
4441 }
4442 
4443 // Fetch the nth 32-bit system call argument.
4444 int
4445 argint(int n, int *ip)
4446 {
4447   return fetchint(proc->tf->esp + 4 + 4*n, ip);
4448 }
4449 
4450 // Fetch the nth word-sized system call argument as a pointer
4451 // to a block of memory of size bytes.  Check that the pointer
4452 // lies within the process address space.
4453 int
4454 argptr(int n, char **pp, int size)
4455 {
4456   int i;
4457 
4458   if(argint(n, &i) < 0)
4459     return -1;
4460   if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
4461     return -1;
4462   *pp = (char*)i;
4463   return 0;
4464 }
4465 
4466 // Fetch the nth word-sized system call argument as a string pointer.
4467 // Check that the pointer is valid and the string is nul-terminated.
4468 // (There is no shared writable memory, so the string can't change
4469 // between this check and being used by the kernel.)
4470 int
4471 argstr(int n, char **pp)
4472 {
4473   int addr;
4474   if(argint(n, &addr) < 0)
4475     return -1;
4476   return fetchstr(addr, pp);
4477 }
4478 
4479 extern int sys_chdir(void);
4480 extern int sys_close(void);
4481 extern int sys_dup(void);
4482 extern int sys_exec(void);
4483 extern int sys_exit(void);
4484 extern int sys_fork(void);
4485 extern int sys_fstat(void);
4486 extern int sys_getpid(void);
4487 extern int sys_getppid(void);
4488 extern int sys_kill(void);
4489 extern int sys_link(void);
4490 extern int sys_mkdir(void);
4491 extern int sys_mknod(void);
4492 extern int sys_open(void);
4493 extern int sys_pipe(void);
4494 extern int sys_read(void);
4495 extern int sys_sbrk(void);
4496 extern int sys_sleep(void);
4497 extern int sys_unlink(void);
4498 extern int sys_wait(void);
4499 extern int sys_write(void);
4500 extern int sys_uptime(void);
4501 extern int sys_my_syscall(void);
4502 extern int sys_yield(void);
4503 extern int sys_getlev(void);
4504 extern int sys_set_cpu_share(void);
4505 extern int sys_thread_create(void);
4506 extern int sys_thread_exit(void);
4507 extern int sys_thread_join(void);
4508 
4509 
4510 static int (*syscalls[])(void) = {
4511 [SYS_fork]    sys_fork,
4512 [SYS_exit]    sys_exit,
4513 [SYS_wait]    sys_wait,
4514 [SYS_pipe]    sys_pipe,
4515 [SYS_read]    sys_read,
4516 [SYS_kill]    sys_kill,
4517 [SYS_exec]    sys_exec,
4518 [SYS_fstat]   sys_fstat,
4519 [SYS_chdir]   sys_chdir,
4520 [SYS_dup]     sys_dup,
4521 [SYS_getpid]  sys_getpid,
4522 [SYS_getppid]  sys_getppid,
4523 [SYS_sbrk]    sys_sbrk,
4524 [SYS_sleep]   sys_sleep,
4525 [SYS_uptime]  sys_uptime,
4526 [SYS_open]    sys_open,
4527 [SYS_write]   sys_write,
4528 [SYS_mknod]   sys_mknod,
4529 [SYS_unlink]  sys_unlink,
4530 [SYS_link]    sys_link,
4531 [SYS_mkdir]   sys_mkdir,
4532 [SYS_close]   sys_close,
4533 [SYS_my_syscall] sys_my_syscall,
4534 [SYS_yield] sys_yield,
4535 [SYS_getlev] sys_getlev,
4536 [SYS_set_cpu_share] sys_set_cpu_share,
4537 [SYS_thread_create] sys_thread_create,
4538 [SYS_thread_exit] sys_thread_exit,
4539 [SYS_thread_join] sys_thread_join,
4540 };
4541 
4542 
4543 
4544 
4545 
4546 
4547 
4548 
4549 
4550 void
4551 syscall(void)
4552 {
4553   int num;
4554 
4555   num = proc->tf->eax;
4556   if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
4557     proc->tf->eax = syscalls[num]();
4558   } else {
4559     cprintf("%d %s: unknown sys call %d\n",
4560             proc->pid, proc->name, num);
4561     proc->tf->eax = -1;
4562   }
4563 }
4564 
4565 
4566 
4567 
4568 
4569 
4570 
4571 
4572 
4573 
4574 
4575 
4576 
4577 
4578 
4579 
4580 
4581 
4582 
4583 
4584 
4585 
4586 
4587 
4588 
4589 
4590 
4591 
4592 
4593 
4594 
4595 
4596 
4597 
4598 
4599 
