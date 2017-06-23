9750 # Initial process execs /init.
9751 # This code runs in user space.
9752 
9753 #include "syscall.h"
9754 #include "traps.h"
9755 
9756 
9757 # exec(init, argv)
9758 .globl start
9759 start:
9760   pushl $argv
9761   pushl $init
9762   pushl $0  // where caller pc would be
9763   movl $SYS_exec, %eax
9764   int $T_SYSCALL
9765 
9766 # for(;;) exit();
9767 exit:
9768   movl $SYS_exit, %eax
9769   int $T_SYSCALL
9770   jmp exit
9771 
9772 # char init[] = "/init\0";
9773 init:
9774   .string "/init\0"
9775 
9776 # char *argv[] = { init, 0 };
9777 .p2align 2
9778 argv:
9779   .long init
9780   .long 0
9781 
9782 
9783 
9784 
9785 
9786 
9787 
9788 
9789 
9790 
9791 
9792 
9793 
9794 
9795 
9796 
9797 
9798 
9799 
