4100 #include "mmu.h"
4101 
4102   # vectors.S sends all traps here.
4103 .globl alltraps
4104 alltraps:
4105   # Build trap frame.
4106   pushl %ds
4107   pushl %es
4108   pushl %fs
4109   pushl %gs
4110   pushal
4111 
4112   # Set up data and per-cpu segments.
4113   movw $(SEG_KDATA<<3), %ax
4114   movw %ax, %ds
4115   movw %ax, %es
4116   movw $(SEG_KCPU<<3), %ax
4117   movw %ax, %fs
4118   movw %ax, %gs
4119 
4120   # Call trap(tf), where tf=%esp
4121   pushl %esp
4122   call trap
4123   addl $4, %esp
4124 
4125   # Return falls through to trapret...
4126 .globl trapret
4127 trapret:
4128   popal
4129   popl %gs
4130   popl %fs
4131   popl %es
4132   popl %ds
4133   addl $0x8, %esp  # trapno and errcode
4134   iret
4135 
4136 
4137 
4138 
4139 
4140 
4141 
4142 
4143 
4144 
4145 
4146 
4147 
4148 
4149 
