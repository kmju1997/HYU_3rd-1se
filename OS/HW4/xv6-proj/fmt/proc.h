2400 // Per-CPU state
2401 struct cpu {
2402     uchar apicid;                // Local APIC ID
2403     struct context *scheduler;   // swtch() here to enter scheduler
2404     struct taskstate ts;         // Used by x86 to find stack for interrupt
2405     struct segdesc gdt[NSEGS];   // x86 global descriptor table
2406     volatile uint started;       // Has the CPU started?
2407     int ncli;                    // Depth of pushcli nesting.
2408     int intena;                  // Were interrupts enabled before pushcli?
2409 
2410     // Cpu-local storage variables; see below
2411     struct cpu *cpu;
2412     struct proc *proc;           // The currently-running process.
2413 };
2414 
2415 extern struct cpu cpus[NCPU];
2416 extern int ncpu;
2417 
2418 // Per-CPU variables, holding pointers to the
2419 // current cpu and to the current process.
2420 // The asm suffix tells gcc to use "%gs:0" to refer to cpu
2421 // and "%gs:4" to refer to proc.  seginit sets up the
2422 // %gs segment register so that %gs refers to the memory
2423 // holding those two variables in the local cpu's struct cpu.
2424 // This is similar to how thread-local variables are implemented
2425 // in thread libraries such as Linux pthreads.
2426 extern struct cpu *cpu asm("%gs:0");       // &cpus[cpunum()]
2427 extern struct proc *proc asm("%gs:4");     // cpus[cpunum()].proc
2428 
2429 
2430 // Saved registers for kernel context switches.
2431 // Don't need to save all the segment registers (%cs, etc),
2432 // because they are constant across kernel contexts.
2433 // Don't need to save %eax, %ecx, %edx, because the
2434 // x86 convention is that the caller has saved them.
2435 // Contexts are stored at the bottom of the stack they
2436 // describe; the stack pointer is the address of the context.
2437 // The layout of the context matches the layout of the stack in swtch.S
2438 // at the "Switch stacks" comment. Switch doesn't save eip explicitly,
2439 // but it is on the stack and allocproc() manipulates it.
2440 struct context {
2441     uint edi;
2442     uint esi;
2443     uint ebx;
2444     uint ebp;
2445     uint eip;
2446 };
2447 
2448 
2449 
2450 enum procstate { UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };
2451 
2452 // Per-process state
2453 struct proc {
2454     uint sz;                     // Size of process memory (bytes)
2455     pde_t* pgdir;                // Page table
2456     char *kstack;                // Bottom of kernel stack for this process
2457     enum procstate state;        // Process state
2458     int pid;                     // Process ID
2459     struct proc *parent;         // Parent process
2460     struct trapframe *tf;        // Trap frame for current syscall
2461     struct context *context;     // swtch() here to run process
2462     void *chan;                  // If non-zero, sleeping on chan
2463     int killed;                  // If non-zero, have been killed
2464     struct file *ofile[NOFILE];  // Open files
2465     struct inode *cwd;           // Current directory
2466     char name[16];               // Process name (debugging)
2467 
2468     //For ADDED
2469     ushort qPosi;
2470     ushort stride; // store stride to each processes
2471     ushort pstride; //A process's stride (not shared with thread)
2472     unsigned long int pass; //store pass value to each processes
2473     uint consumedTime; //consumedTime is equal to "STRIDE_TIMEQUANTUM * NumberOfWalk"
2474 
2475     ushort isthread;
2476     ushort numOfThread;
2477     int stack;
2478     void *retval;
2479     int tid;
2480 
2481 
2482 };
2483 
2484 // Process memory is laid out contiguously, low addresses first:
2485 //   text
2486 //   original data and bss
2487 //   fixed-size stack
2488 //   expandable heap
2489 
2490 
2491 
2492 
2493 
2494 
2495 
2496 
2497 
2498 
2499 
