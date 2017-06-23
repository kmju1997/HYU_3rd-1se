9800 #include "syscall.h"
9801 #include "traps.h"
9802 
9803 #define SYSCALL(name) \
9804   .globl name; \
9805   name: \
9806     movl $SYS_ ## name, %eax; \
9807     int $T_SYSCALL; \
9808     ret
9809 
9810 SYSCALL(fork)
9811 SYSCALL(exit)
9812 SYSCALL(wait)
9813 SYSCALL(pipe)
9814 SYSCALL(read)
9815 SYSCALL(write)
9816 SYSCALL(close)
9817 SYSCALL(kill)
9818 SYSCALL(exec)
9819 SYSCALL(open)
9820 SYSCALL(mknod)
9821 SYSCALL(unlink)
9822 SYSCALL(fstat)
9823 SYSCALL(link)
9824 SYSCALL(mkdir)
9825 SYSCALL(chdir)
9826 SYSCALL(dup)
9827 SYSCALL(getpid)
9828 SYSCALL(getppid)
9829 SYSCALL(sbrk)
9830 SYSCALL(sleep)
9831 SYSCALL(uptime)
9832 SYSCALL(my_syscall)
9833 SYSCALL(yield)
9834 SYSCALL(getlev)
9835 SYSCALL(set_cpu_share)
9836 SYSCALL(thread_create)
9837 SYSCALL(thread_exit)
9838 SYSCALL(thread_join)
9839 
9840 
9841 
9842 
9843 
9844 
9845 
9846 
9847 
9848 
9849 
