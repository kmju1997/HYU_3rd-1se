4150 #include "types.h"
4151 #include "defs.h"
4152 #include "param.h"
4153 #include "memlayout.h"
4154 #include "mmu.h"
4155 #include "x86.h"
4156 #include "traps.h"
4157 #include "proc.h"
4158 #include "mlfq.h"
4159 #include "stride.h"
4160 #include "spinlock.h"
4161 
4162 // Interrupt descriptor table (shared by all CPUs).
4163 struct gatedesc idt[256];
4164 extern uint vectors[];  // in vectors.S: array of 256 entry pointers
4165 struct spinlock tickslock;
4166 uint ticks;
4167 
4168     void
4169 tvinit(void)
4170 {
4171     int i;
4172 
4173     for(i = 0; i < 256; i++)
4174         SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
4175     SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
4176     SETGATE(idt[T_LAB4], 1, SEG_KCODE<<3, vectors[T_LAB4], DPL_USER);
4177 
4178     initlock(&tickslock, "time");
4179 }
4180 
4181     void
4182 idtinit(void)
4183 {
4184     lidt(idt, sizeof(idt));
4185 }
4186 
4187 
4188 
4189 
4190 
4191 
4192 
4193 
4194 
4195 
4196 
4197 
4198 
4199 
4200     void
4201 trap(struct trapframe *tf)
4202 {
4203     if(tf->trapno == T_SYSCALL){
4204         //ADDED
4205         if(proc->killed){
4206             exit();
4207         }
4208         proc->tf = tf;
4209         syscall();
4210         if(proc->killed)
4211             exit();
4212         return;
4213     }
4214 
4215     if(tf->trapno == T_LAB4){
4216         cprintf("user Interrupt %d called!\n", T_LAB4);
4217         exit();
4218         return;
4219     }
4220 
4221     switch(tf->trapno){
4222         case T_IRQ0 + IRQ_TIMER:
4223             if(cpunum() == 0){
4224                 acquire(&tickslock);
4225                 if(proc != 0){
4226                     proc->consumedTime++;
4227                 }
4228                     //cprintf("t\t");
4229                 ticks++;
4230                 wakeup(&ticks);
4231                 release(&tickslock);
4232             }
4233             lapiceoi();
4234             break;
4235         case T_IRQ0 + IRQ_IDE:
4236             ideintr();
4237             lapiceoi();
4238             break;
4239         case T_IRQ0 + IRQ_IDE+1:
4240             // Bochs generates spurious IDE1 interrupts.
4241             break;
4242         case T_IRQ0 + IRQ_KBD:
4243             kbdintr();
4244             lapiceoi();
4245             break;
4246         case T_IRQ0 + IRQ_COM1:
4247             uartintr();
4248             lapiceoi();
4249             break;
4250         case T_IRQ0 + 7:
4251         case T_IRQ0 + IRQ_SPURIOUS:
4252             cprintf("cpu%d: spurious interrupt at %x:%x\n",
4253                     cpunum(), tf->cs, tf->eip);
4254             lapiceoi();
4255             break;
4256 
4257 
4258         default:
4259             if(proc == 0 || (tf->cs&3) == 0){
4260                 // In kernel, it must be our mistake.
4261                 cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
4262                         tf->trapno, cpunum(), tf->eip, rcr2());
4263                 cprintf(" [cause] pid %d / tid %d\n",proc->pid,proc->tid);
4264                 panic("trap");
4265             }
4266             // In user space, assume process misbehaved.
4267             cprintf("pid %d tid %d %s: trap %d err %d on cpu %d "
4268                     "eip 0x%x addr 0x%x--kill proc\n",
4269                     proc->pid, proc->tid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
4270                     rcr2());
4271             proc->killed = 1;
4272     }
4273 
4274     // Force process exit if it has been killed and is in user space.
4275     // (If it is still executing in the kernel, let it keep running
4276     // until it gets to the regular system call return.)
4277     if(proc && proc->killed && (tf->cs&3) == DPL_USER){
4278 
4279         exit();
4280     }
4281 
4282     // Force process to give up CPU on clock tick.
4283     // If interrupts were on while locks held, would need to check nlock.
4284     if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
4285         //schedulerMode == means Now cuurent proc is Mlfq
4286         if(schedulerMode == 1)
4287         {
4288             //when the boost time comes
4289             if(ticks % MLFQ_BOOST_TIME ==0){
4290                 boostMlfq();
4291                 yieldbytimer = 1; //flag that notify yield is called by timer
4292                 yield();
4293                 //The procedure that moving monopolying process to lower queue
4294             }else if(proc->pid > 2 && proc->state == RUNNING){
4295                 if(proc->consumedTime % qOfM[proc->qPosi].timeAllot == 0){
4296                     if(proc->qPosi != MAX_QUEUE_NUM-1){
4297                         dequeue(&qOfM[proc->qPosi],proc);
4298                         if(proc->qPosi == 2) enqueue(&qOfM[proc->qPosi], proc);
4299                         else enqueue(&qOfM[proc->qPosi+1], proc);
4300                         yieldbytimer = 1;
4301                         yield();
4302                     }
4303 
4304                 }
4305                 //The procedure that switching context when every timeQuantum meets
4306                 if(proc->consumedTime % qOfM[proc->qPosi].timeQuan == 0){
4307                     dequeue(&qOfM[proc->qPosi],proc);
4308                     enqueue(&qOfM[proc->qPosi], proc);
4309                     yieldbytimer = 1;
4310                     yield();
4311                 }
4312             }
4313 
4314             //Stride context switching
4315         } else if(proc->consumedTime % TIME_PER_ONE_PASS  == 0){
4316             yieldbytimer = 1;
4317             yield();
4318         }
4319     }
4320 
4321     // Check if the process has been killed since we yielded
4322     if(proc && proc->killed && (tf->cs&3) == DPL_USER){
4323         exit();
4324     }
4325 }
4326 
4327 
4328 
4329 
4330 
4331 
4332 
4333 
4334 
4335 
4336 
4337 
4338 
4339 
4340 
4341 
4342 
4343 
4344 
4345 
4346 
4347 
4348 
4349 
