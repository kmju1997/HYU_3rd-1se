4000 // x86 trap and interrupt constants.
4001 
4002 // Processor-defined:
4003 #define T_DIVIDE         0      // divide error
4004 #define T_DEBUG          1      // debug exception
4005 #define T_NMI            2      // non-maskable interrupt
4006 #define T_BRKPT          3      // breakpoint
4007 #define T_OFLOW          4      // overflow
4008 #define T_BOUND          5      // bounds check
4009 #define T_ILLOP          6      // illegal opcode
4010 #define T_DEVICE         7      // device not available
4011 #define T_DBLFLT         8      // double fault
4012 // #define T_COPROC      9      // reserved (not used since 486)
4013 #define T_TSS           10      // invalid task switch segment
4014 #define T_SEGNP         11      // segment not present
4015 #define T_STACK         12      // stack exception
4016 #define T_GPFLT         13      // general protection fault
4017 #define T_PGFLT         14      // page fault
4018 // #define T_RES        15      // reserved
4019 #define T_FPERR         16      // floating point error
4020 #define T_ALIGN         17      // aligment check
4021 #define T_MCHK          18      // machine check
4022 #define T_SIMDERR       19      // SIMD floating point error
4023 
4024 // These are arbitrarily chosen, but with care not to overlap
4025 // processor defined exceptions or interrupt vectors.
4026 #define T_SYSCALL       64      // system call
4027 #define T_YIELD         65      //sys_yield() syscall
4028 #define T_LAB4         128     // Lab4 system call
4029 #define T_DEFAULT      500      // catchall
4030 
4031 #define T_IRQ0          32      // IRQ 0 corresponds to int T_IRQ
4032 
4033 #define IRQ_TIMER        0
4034 #define IRQ_KBD          1
4035 #define IRQ_COM1         4
4036 #define IRQ_IDE         14
4037 #define IRQ_ERROR       19
4038 #define IRQ_SPURIOUS    31
4039 
4040 
4041 
4042 
4043 
4044 
4045 
4046 
4047 
4048 
4049 
