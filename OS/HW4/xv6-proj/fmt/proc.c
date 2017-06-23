2500 #include "types.h"
2501 #include "defs.h"
2502 #include "param.h"
2503 #include "memlayout.h"
2504 #include "mmu.h"
2505 #include "x86.h"
2506 #include "proc.h"
2507 #include "mlfq.h"
2508 #include "stride.h"
2509 #include "thread.h"
2510 #include "spinlock.h"
2511 
2512 struct {
2513     struct spinlock lock;
2514     struct proc proc[NPROC];
2515 } ptable;
2516 
2517 static struct proc *initproc;
2518 
2519 int nextpid = 1;
2520 int nexttid = 1000;
2521 extern void forkret(void);
2522 extern void trapret(void);
2523 
2524 static void wakeup1(void *chan);
2525 
2526     void
2527 pinit(void)
2528 {
2529     initlock(&ptable.lock, "ptable");
2530 }
2531 
2532 
2533 
2534 
2535 
2536 
2537 
2538 
2539 
2540 
2541 
2542 
2543 
2544 
2545 
2546 
2547 
2548 
2549 
2550 // Look in the process table for an UNUSED proc.
2551 // If found, change state to EMBRYO and initialize
2552 // state required to run in the kernel.
2553 // Otherwise return 0.
2554     static struct proc*
2555 allocproc(void)
2556 {
2557     struct proc *p;
2558     char *sp;
2559 
2560     acquire(&ptable.lock);
2561 
2562     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
2563         if(p->state == UNUSED)
2564             goto found;
2565 
2566     release(&ptable.lock);
2567     return 0;
2568 
2569 found:
2570     p->state = EMBRYO;
2571     p->pid = nextpid++;
2572     //ADDED
2573     p->tid = 0;
2574     p->isthread = 0;
2575     p->numOfThread = 0;
2576 
2577     release(&ptable.lock);
2578 
2579     // Allocate kernel stack.
2580     if((p->kstack = kalloc()) == 0){
2581         p->state = UNUSED;
2582         return 0;
2583     }
2584     sp = p->kstack + KSTACKSIZE;
2585 
2586     // Leave room for trap frame.
2587     sp -= sizeof *p->tf;
2588     p->tf = (struct trapframe*)sp;
2589 
2590     // Set up new context to start executing at forkret,
2591     // which returns to trapret.
2592     sp -= 4;
2593     *(uint*)sp = (uint)trapret;
2594 
2595     sp -= sizeof *p->context;
2596     p->context = (struct context*)sp;
2597     memset(p->context, 0, sizeof *p->context);
2598     p->context->eip = (uint)forkret;
2599 
2600     return p;
2601 }
2602 
2603 
2604 // Set up first user process.
2605     void
2606 userinit(void)
2607 {
2608     struct proc *p;
2609     extern char _binary_initcode_start[], _binary_initcode_size[];
2610 
2611     p = allocproc();
2612 
2613     initproc = p;
2614     if((p->pgdir = setupkvm()) == 0)
2615         panic("userinit: out of memory?");
2616     inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
2617     p->sz = PGSIZE;
2618     memset(p->tf, 0, sizeof(*p->tf));
2619     p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
2620     p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
2621     p->tf->es = p->tf->ds;
2622     p->tf->ss = p->tf->ds;
2623     p->tf->eflags = FL_IF;
2624     p->tf->esp = PGSIZE;
2625     p->tf->eip = 0;  // beginning of initcode.S
2626 
2627     safestrcpy(p->name, "initcode", sizeof(p->name));
2628     p->cwd = namei("/");
2629 
2630     // this assignment to p->state lets other cores
2631     // run this process. the acquire forces the above
2632     // writes to be visible, and the lock is also needed
2633     // because the assignment might not be atomic.
2634     acquire(&ptable.lock);
2635 
2636     p->state = RUNNABLE;
2637 
2638     release(&ptable.lock);
2639 }
2640 
2641 
2642 
2643 
2644 
2645 
2646 
2647 
2648 
2649 
2650 // Grow current process's memory by n bytes.
2651 // Return 0 on success, -1 on failure.
2652     int
2653 growproc(int n)
2654 {
2655     uint sz;
2656 
2657     //ADDED
2658     acquire(&ptable.lock);
2659 
2660     sz = proc->sz;
2661     if(n > 0){
2662         if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
2663             return -1;
2664     } else if(n < 0){
2665         if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
2666             return -1;
2667     }
2668     //ADDED
2669     if(proc->isthread == 1){
2670         proc->parent->sz = sz;
2671     }
2672     proc->sz = sz;
2673     release(&ptable.lock);
2674 
2675     switchuvm(proc);
2676     return 0;
2677 }
2678 
2679 // Create a new process copying p as the parent.
2680 // Sets up stack to return as if from system call.
2681 // Caller must set state of returned proc to RUNNABLE.
2682     int
2683 fork(void)
2684 {
2685     int i, pid;
2686     struct proc *np;
2687     //struct proc *iter;
2688 
2689 
2690     if(proc->isthread == 1){
2691         return thread_fork();
2692     }
2693 
2694 
2695     // Allocate process.
2696     if((np = allocproc()) == 0){
2697         return -1;
2698     }
2699 
2700     // Copy process state from p.
2701     if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
2702         kfree(np->kstack);
2703         np->kstack = 0;
2704         np->state = UNUSED;
2705         return -1;
2706     }
2707     np->sz = proc->sz;
2708     np->parent = proc;
2709     *np->tf = *proc->tf;
2710 
2711     // Clear %eax so that fork returns 0 in the child.
2712     np->tf->eax = 0;
2713 
2714     for(i = 0; i < NOFILE; i++)
2715         if(proc->ofile[i])
2716             np->ofile[i] = filedup(proc->ofile[i]);
2717     np->cwd = idup(proc->cwd);
2718 
2719     safestrcpy(np->name, proc->name, sizeof(proc->name));
2720 
2721     pid = np->pid;
2722 
2723     acquire(&ptable.lock);
2724 
2725     np->state = RUNNABLE;
2726     //for added
2727     enqueue(&qOfM[0],np);
2728 
2729     release(&ptable.lock);
2730 
2731     return pid;
2732 }
2733 
2734 // Exit the current process.  Does not return.
2735 // An exited process remains in the zombie state
2736 // until its parent calls wait() to find out it exited.
2737     void
2738 exit(void)
2739 {
2740     struct proc *p;
2741     int fd;
2742     int c_retval = 0;
2743 
2744 
2745     if(proc->isthread == 1){
2746         return clean(proc->parent);
2747 
2748     }
2749 
2750     if(proc == initproc)
2751         panic("init exiting");
2752 
2753     // Close all open files.
2754     for(fd = 0; fd < NOFILE; fd++){
2755         if(proc->ofile[fd]){
2756             fileclose(proc->ofile[fd]);
2757             proc->ofile[fd] = 0;
2758         }
2759     }
2760 
2761     begin_op();
2762     iput(proc->cwd);
2763     end_op();
2764     proc->cwd = 0;
2765 
2766     acquire(&ptable.lock);
2767 
2768     // Parent might be sleeping in wait().
2769     wakeup1(proc->parent);
2770 
2771     /* COMMENT
2772        cprintf("-----------Before------------\n");
2773        printPtable();
2774        */
2775 
2776 
2777     // Pass abandoned children to init.
2778     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
2779         if(p->parent == proc){
2780             //ADDED - Clean threads of proc
2781             if(p->isthread == 1){
2782                 release(&ptable.lock);
2783                 thread_clean(p->tid,(void**)c_retval);
2784                 acquire(&ptable.lock);
2785             }
2786 
2787             p->parent = initproc;
2788             if(p->state == ZOMBIE){
2789                 wakeup1(initproc);
2790             }
2791         }
2792     }
2793 
2794 
2795     // Jump into the scheduler, never to return.
2796     // for added
2797     if(proc->stride == 0)dequeue(&qOfM[proc->qPosi],proc);
2798     proc->consumedTime = 0;
2799     if(proc->pid > 2 )cut_cpu_share(proc->stride);
2800     proc->stride = 0;
2801     proc->pass = 0;
2802     proc->qPosi = 0;
2803 
2804     //to confirm
2805     wakeup1(proc->parent);
2806 
2807     proc->state = ZOMBIE;
2808 
2809 
2810     /*COMMENT
2811       cprintf("-----------After------------\n");
2812     cprintf(    "exi : %d in : %d\n",proc->pid, proc->qPosi);
2813       printPtable();
2814       */
2815 
2816     sched();
2817     panic("zombie exit");
2818 
2819 
2820 }
2821 // Wait for a child process to exit and return its pid.
2822 // Return -1 if this process has no children.
2823     int
2824 wait(void)
2825 {
2826     struct proc *p;
2827     int havekids, pid;
2828     //int retval = 0;
2829 
2830     acquire(&ptable.lock);
2831     for(;;){
2832         // Scan through table looking for exited children.
2833         havekids = 0;
2834         for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
2835             if(p->parent != proc )
2836                 continue;
2837             if(p->isthread == 1)
2838                 continue;
2839             havekids = 1;
2840             if(p->state == ZOMBIE){
2841                 // Found one.
2842                 pid = p->pid;
2843                 kfree(p->kstack);
2844                 p->kstack = 0;
2845                 freevm(p->pgdir);
2846                 p->pid = 0;
2847                 p->parent = 0;
2848                 p->name[0] = 0;
2849                 p->killed = 0;
2850                 p->state = UNUSED;
2851                 release(&ptable.lock);
2852                 return pid;
2853             }
2854         }
2855 
2856         // No point waiting if we don't have any children.
2857         if(!havekids || proc->killed){
2858             release(&ptable.lock);
2859             return -1;
2860         }
2861 
2862         // Wait for children to exit.  (See wakeup1 call in proc_exit.)
2863         sleep(proc, &ptable.lock);  //DOC: wait-sleep
2864     }
2865 }
2866 
2867 
2868 
2869 
2870 
2871 
2872 
2873 
2874 
2875 
2876 
2877 
2878 
2879 
2880 
2881 
2882 
2883 
2884 
2885 
2886 
2887 
2888 
2889 
2890 
2891 
2892 
2893 
2894 
2895 
2896 
2897 
2898 
2899 
2900 // Per-CPU process scheduler.
2901 // Each CPU calls scheduler() after setting itself up.
2902 // Scheduler never returns.  It loops, doing:
2903 //  - choose a process to run
2904 //  - swtch to start running that process
2905 //  - eventually that process transfers control
2906 //      via swtch back to the scheduler.
2907     void
2908 scheduler(void)
2909 {
2910     struct proc *p;
2911     int i = 0;
2912     struct Mlfq* nextQ;
2913     int checkQ = 0; //for check 'for looping queue' and nextQ
2914     curQ = 0;
2915     MlfqProcFlag = 0;
2916 
2917     initMlfq(&qOfM[0]);
2918     initMlfq(&qOfM[1]);
2919     initMlfq(&qOfM[2]);
2920     initMlfqGlobal();
2921     initStride();
2922 
2923     acquire(&ptable.lock);
2924     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
2925         if(p->state == UNUSED)
2926             continue;
2927         enqueue(&qOfM[0],p);
2928     }
2929     release(&ptable.lock);
2930 
2931 
2932 
2933     for(;;){
2934         // Enable interrupts on this processor.
2935         sti();
2936 
2937         nextQ = &qOfM[curQ];
2938         schedulerMode = 0;
2939 
2940         checkRcount(&qOfM[0]);
2941         checkRcount(&qOfM[1]);
2942         checkRcount(&qOfM[2]);
2943 
2944         if(qOfM[0].rCount != 0){
2945             curQ = 0;
2946         }else if(qOfM[1].rCount != 0){
2947             curQ = 1;
2948         }else if(qOfM[2].rCount != 0){
2949             curQ = 2;
2950         }else curQ =0;
2951         checkQ = curQ;
2952         nextQ = &qOfM[curQ];
2953 
2954 
2955 
2956         // Loop over process table looking for process to run.
2957         acquire(&ptable.lock);
2958 
2959         for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
2960             findMinPassStride();
2961             if(minPass == MlfqPass){
2962                 schedulerMode = 1;
2963                 break;
2964             }
2965             if(p->pass != minPass || p->stride == 0)
2966                 continue;
2967             if(p->state != RUNNABLE )
2968                 continue;
2969 
2970             p->pass += p->stride;
2971 
2972             schedulerMode =0;
2973 
2974             proc = p;
2975             switchuvm(p);
2976             p->state = RUNNING;
2977             swtch(&cpu->scheduler, p->context);
2978             switchkvm();
2979 
2980             proc = 0;
2981         }
2982 
2983         if(schedulerMode == 1)
2984         {
2985             for(p = peekMlfq(nextQ); p; p = idxPeekMlfq(nextQ,i)){
2986 
2987                 if(qOfM[0].rCount != 0){
2988                     curQ = 0;
2989                 }else if(qOfM[1].rCount != 0){
2990                     curQ = 1;
2991                 }else if(qOfM[2].rCount != 0){
2992                     curQ = 2;
2993                 }else curQ =0;
2994                 if(checkQ != curQ) break;
2995 
2996 
2997 
2998 
2999 
3000                 if(p->state != RUNNABLE){
3001                     i++;;
3002                     continue;
3003                 }
3004 
3005 
3006                 i=0;
3007 
3008                 proc = p;
3009                 switchuvm(p);
3010                 p->state = RUNNING;
3011                 swtch(&cpu->scheduler, p->context);
3012                 switchkvm();
3013 
3014                 proc = 0;
3015             }
3016 
3017             MlfqPass += MlfqStride;
3018         }
3019         release(&ptable.lock);
3020     }
3021 }
3022 
3023 // Enter scheduler.  Must hold only ptable.lock
3024 // and have changed proc->state. Saves and restores
3025 // intena because intena is a property of this
3026 // kernel thread, not this CPU. It should
3027 // be proc->intena and proc->ncli, but that would
3028 // break in the few places where a lock is held but
3029 // there's no process.
3030     void
3031 sched(void)
3032 {
3033     int intena;
3034 
3035     if(!holding(&ptable.lock))
3036         panic("sched ptable.lock");
3037     if(cpu->ncli != 1)
3038         panic("sched locks");
3039     if(proc->state == RUNNING)
3040         panic("sched running");
3041     if(readeflags()&FL_IF)
3042         panic("sched interruptible");
3043     intena = cpu->intena;
3044     swtch(&proc->context, cpu->scheduler);
3045     cpu->intena = intena;
3046 }
3047 
3048 
3049 
3050 // Give up the CPU for one scheduling round.
3051     void
3052 yield(void)
3053 {
3054     //cprintf("yield~~!~!~!~!\n");
3055     acquire(&ptable.lock);  //DOC: yieldlock
3056     if(yieldbytimer == 0 && proc->stride == 0 && schedulerMode == 1){
3057 
3058         dequeue(&qOfM[proc->qPosi],proc);
3059         enqueue(&qOfM[proc->qPosi], proc);
3060     }
3061     proc->state = RUNNABLE;
3062     yieldbytimer = 0;
3063     sched();
3064     release(&ptable.lock);
3065 }
3066 
3067 // A fork child's very first scheduling by scheduler()
3068 // will swtch here.  "Return" to user space.
3069     void
3070 forkret(void)
3071 {
3072     static int first = 1;
3073     // Still holding ptable.lock from scheduler.
3074     release(&ptable.lock);
3075 
3076     if (first) {
3077         // Some initialization functions must be run in the context
3078         // of a regular process (e.g., they call sleep), and thus cannot
3079         // be run from main().
3080         first = 0;
3081         iinit(ROOTDEV);
3082         initlog(ROOTDEV);
3083     }
3084 
3085     // Return to "caller", actually trapret (see allocproc).
3086 }
3087 
3088 
3089 
3090 
3091 
3092 
3093 
3094 
3095 
3096 
3097 
3098 
3099 
3100 // Atomically release lock and sleep on chan.
3101 // Reacquires lock when awakened.
3102     void
3103 sleep(void *chan, struct spinlock *lk)
3104 {
3105     if(proc == 0)
3106         panic("sleep");
3107 
3108     if(lk == 0)
3109         panic("sleep without lk");
3110 
3111     // Must acquire ptable.lock in order to
3112     // change p->state and then call sched.
3113     // Once we hold ptable.lock, we can be
3114     // guaranteed that we won't miss any wakeup
3115     // (wakeup runs with ptable.lock locked),
3116     // so it's okay to release lk.
3117     if(lk != &ptable.lock){  //DOC: sleeplock0
3118         acquire(&ptable.lock);  //DOC: sleeplock1
3119         release(lk);
3120     }
3121 
3122     // Go to sleep.
3123     proc->chan = chan;
3124     proc->state = SLEEPING;
3125 
3126     //cprintf(" sleep in~~~~pid %d tid %d\n",proc->pid,proc->tid);
3127     sched();
3128 
3129     //cprintf(" sleep done ~~~~pid %d tid %d\n",proc->pid,proc->tid);
3130     // Tidy up.
3131     proc->chan = 0;
3132 
3133     // Reacquire original lock.
3134     if(lk != &ptable.lock){  //DOC: sleeplock2
3135         release(&ptable.lock);
3136         acquire(lk);
3137     }
3138 }
3139 
3140 
3141 
3142 
3143 
3144 
3145 
3146 
3147 
3148 
3149 
3150 // Wake up all processes sleeping on chan.
3151 // The ptable lock must be held.
3152     static void
3153 wakeup1(void *chan)
3154 {
3155     struct proc *p;
3156 
3157     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
3158         if(p->state == SLEEPING && p->chan == chan){
3159             p->state = RUNNABLE;
3160         }
3161 }
3162 
3163 // Wake up all processes sleeping on chan.
3164     void
3165 wakeup(void *chan)
3166 {
3167     acquire(&ptable.lock);
3168     wakeup1(chan);
3169     release(&ptable.lock);
3170 }
3171 
3172 // Kill the process with the given pid.
3173 // Process won't exit until it returns
3174 // to user space (see trap in trap.c).
3175     int
3176 kill(int pid)
3177 {
3178 
3179     struct proc *p;
3180 
3181     acquire(&ptable.lock);
3182     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
3183         if(p->pid == pid){
3184             p->killed = 1;
3185             // Wake process from sleep if necessary.
3186             if(p->state == SLEEPING)
3187                 p->state = RUNNABLE;
3188             release(&ptable.lock);
3189             return 0;
3190         }
3191     }
3192     release(&ptable.lock);
3193     return -1;
3194 }
3195 
3196 
3197 
3198 
3199 
3200 // Print a process listing to console.  For debugging.
3201 // Runs when user types ^P on console.
3202 // No lock to avoid wedging a stuck machine further.
3203     void
3204 procdump(void)
3205 {
3206     static char *states[] = {
3207         [UNUSED]    "unused",
3208         [EMBRYO]    "embryo",
3209         [SLEEPING]  "sleep ",
3210         [RUNNABLE]  "runble",
3211         [RUNNING]   "run   ",
3212         [ZOMBIE]    "zombie"
3213     };
3214     int i;
3215     struct proc *p;
3216     char *state;
3217     uint pc[10];
3218 
3219     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
3220         if(p->state == UNUSED)
3221             continue;
3222         if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
3223             state = states[p->state];
3224         else
3225             state = "???";
3226         cprintf("%d %s %s", p->pid, state, p->name);
3227         if(p->state == SLEEPING){
3228             getcallerpcs((uint*)p->context->ebp+2, pc);
3229             for(i=0; i<10 && pc[i] != 0; i++)
3230                 cprintf(" %p", pc[i]);
3231         }
3232         cprintf("\n");
3233     }
3234 }
3235 
3236 
3237 
3238 
3239 
3240 
3241 
3242 
3243 
3244 
3245 
3246 
3247 
3248 
3249 
3250 //For ADDED : scheduler-----------------------------------------------
3251 
3252 //ADDED : Decrease every process's pass value if overflow occurs
3253     void
3254 findMinPassStride(void)
3255 {
3256     struct proc* p;
3257     int overflowFlag = 0;
3258 
3259     minPass = MlfqPass;
3260     if(minPass >= 2147483647 - 20000){
3261         overflowFlag = 1;
3262     }
3263 
3264     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
3265         if(p->state != RUNNABLE)
3266             continue;
3267         if(p->pass >= 2147483647 - 20000){
3268             /*
3269                cprintf("[Warning] stride pass overflow~~-    -   -   -   -   -   -   -   -   -   -   -\n");
3270                cprintf(" Let OS manage pass of processes~~-    -   -   -   -   -   -   -   -   -   -   -\n");
3271                */
3272             overflowFlag = 1;
3273         }
3274         if(p->stride >0 && p->pass <= minPass){
3275             minPass = p->pass;
3276         }
3277     }
3278 
3279     if(overflowFlag == 1){
3280         for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
3281             if(p->state != RUNNABLE)
3282                 continue;
3283             if(p->pass > 0){
3284                 p->pass = p->pass - minPass + 10;
3285             }
3286         }
3287         MlfqPass = MlfqPass - minPass + 10;
3288         overflowFlag = 0;
3289     }
3290 }
3291 
3292 
3293 
3294 
3295 
3296 
3297 
3298 
3299 
3300 ///for debugging
3301     void
3302 printPtable(void)
3303 {
3304     struct proc* p;
3305 
3306     cprintf("hello~~~~~~\n");
3307     cprintf(" Mlfq:: / stride %d / pass %d\n",MlfqStride, MlfqPass);
3308     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
3309         if(p->pid != 0)
3310             cprintf(" pid %d / tid %d/ ppid %d/ ptid %d/ name %s /state %d / cT %d / stride %d / p-s %d/ pass %d / n-o-t %d\n",\
3311                     p->pid,p->tid, p->parent->pid, p->parent->tid, p->name, p->state,p->consumedTime, p->stride, p->pstride, p->pass, p->numOfThread);
3312 
3313     }
3314 }
3315 
3316 //ADDED
3317 //HW3
3318     static struct proc*
3319 allocthread(void)
3320 {
3321     struct proc *p;
3322     char *sp;
3323 
3324     acquire(&ptable.lock);
3325 
3326     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
3327         if(p->state == UNUSED)
3328             goto found;
3329 
3330     release(&ptable.lock);
3331     return 0;
3332 
3333 found:
3334     p->state = EMBRYO;
3335     //ADDED
3336     p->tid = nexttid++ + proc->pid*100;
3337 
3338     release(&ptable.lock);
3339 
3340     // Allocate kernel stack.
3341     if((p->kstack = kalloc()) == 0){
3342         p->state = UNUSED;
3343         return 0;
3344     }
3345     sp = p->kstack + KSTACKSIZE;
3346 
3347     // Leave room for trap frame.
3348     sp -= sizeof *p->tf;
3349     p->tf = (struct trapframe*)sp;
3350     // Set up new context to start executing at forkret,
3351     // which returns to trapret.
3352     sp -= 4;
3353     *(uint*)sp = (uint)trapret;
3354 
3355     sp -= sizeof *p->context;
3356     p->context = (struct context*)sp;
3357     memset(p->context, 0, sizeof *p->context);
3358     p->context->eip = (uint)forkret;
3359 
3360     return p;
3361 }
3362 //For ADDED : thread ----------------------------------------
3363 //If isthread == 1, then proc is treated as thread structure
3364 int
3365 thread_create(thread_t *thread, void *(*start_routine)(void *), void*arg){
3366 
3367     int i;
3368     uint sz, sp;
3369     struct proc *np;
3370 
3371     // Allocate process.
3372     if((np = allocthread()) == 0){
3373         return -1;
3374     }
3375 
3376     np->pid = proc->pid;
3377 
3378     // Copy process state from p.
3379     np->pgdir = proc->pgdir;
3380 
3381     //ADDED
3382     if(proc->isthread == 1 ){
3383         np->parent = proc->parent;
3384     }else{
3385         np->parent = proc;
3386     }
3387     *np->tf = *proc->tf;
3388 
3389     // Clear %eax so that fork returns 0 in the child.
3390     np->tf->eax = 0;
3391 
3392     np->tf->eip = (int)(*start_routine);
3393     np->isthread = 1;
3394 
3395 
3396 
3397 
3398 
3399 
3400     acquire(&ptable.lock);
3401     //Allocate thread stack
3402     sz = PGROUNDUP(np->parent->sz);
3403     if((sz = allocuvm(np->parent->pgdir, sz, sz + 2*PGSIZE)) == 0){
3404         goto bad;
3405     }
3406     clearpteu(np->parent->pgdir, (char*)(sz - 2*PGSIZE));
3407     release(&ptable.lock);
3408     sp = sz;
3409     np->parent->sz = sz;
3410     np->sz = sz;
3411     np->stack = sp;
3412 
3413     np->tf->esp = sp;
3414     *((int*)(np->tf->esp - 4)) = (int)arg;
3415     *((int *)(np->tf->esp - 8)) = 0xFFFFFFFF;
3416     np->tf->esp -= 8;
3417 
3418 
3419 
3420     for(i = 0; i < NOFILE; i++)
3421         if(proc->ofile[i])
3422             np->ofile[i] = filedup(proc->ofile[i]);
3423     np->cwd = idup(proc->cwd);
3424 
3425     safestrcpy(np->name, proc->name, sizeof(proc->name));
3426 
3427     //ADDED
3428     *thread = np->tid;
3429     proc->numOfThread++;
3430     if(proc->stride>0)share_stride_in_proc(proc);
3431 
3432     acquire(&ptable.lock);
3433 
3434     np->state = RUNNABLE;
3435     enqueue(&qOfM[0],np);
3436 
3437     //CMT
3438     //cprintf("t-c pid %d / tid %d\n",np->pid,np->tid);
3439     //printPtable();
3440     release(&ptable.lock);
3441     yield();
3442 
3443 
3444     return 0;
3445 
3446 bad:
3447     cprintf("thread_create error'\n");
3448 
3449 
3450     return -1;
3451 }
3452 
3453 void
3454 thread_exit(void * retval){
3455 
3456     struct proc *p;
3457     int fd;
3458 
3459 
3460     if(proc == initproc)
3461         panic("init exiting");
3462 
3463     // Close all open files.
3464     for(fd = 0; fd < NOFILE; fd++){
3465         if(proc->ofile[fd]){
3466             fileclose(proc->ofile[fd]);
3467             proc->ofile[fd] = 0;
3468         }
3469     }
3470 
3471     begin_op();
3472     iput(proc->cwd);
3473     end_op();
3474     proc->cwd = 0;
3475 
3476     acquire(&ptable.lock);
3477 
3478     // Parent might be sleeping in join().
3479     wakeup1((void*)proc->parent);
3480 
3481     ///*
3482     // Pass abandoned children to init.
3483     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
3484         if(p->parent == proc){
3485             p->parent = initproc;
3486             if(p->state == ZOMBIE){
3487                 wakeup1(initproc);
3488             }
3489         }
3490     }
3491     //*/
3492 
3493     // Jump into the scheduler, never to return.
3494     //ADDED
3495     if(proc->stride == 0)dequeue(&qOfM[proc->qPosi],proc);
3496     if(proc->pid > 2 )cut_cpu_share(proc->stride);
3497     proc->consumedTime = 0;
3498     proc->stride = 0;
3499     proc->pass = 0;
3500     proc->qPosi = 0;
3501 
3502 
3503     //ADDED
3504     proc->retval = retval;
3505 
3506     proc->state = ZOMBIE;
3507 
3508     proc->parent->numOfThread--;
3509     if(proc->parent->stride > 0)share_stride_in_proc(proc->parent);
3510 
3511     //CMT
3512     //printMLFQAll();
3513     //cprintf("t-e pid %d / tid %d\n",proc->pid,proc->tid);
3514     //printPtable();
3515 
3516     sched();
3517     panic("zombie exit");
3518 }
3519 
3520 int
3521 thread_join(thread_t thread, void **retval){
3522 
3523     struct proc *p;
3524     int havekids;
3525     uint sz;
3526 
3527     acquire(&ptable.lock);
3528     for(;;){
3529         // Scan through table looking for exited children.
3530         havekids = 0;
3531         for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
3532             if(p->parent != proc || p->isthread != 1 || p->tid != thread){
3533                 continue;
3534             }
3535             havekids = 1;
3536             if(p->state == ZOMBIE){
3537                 //CMT
3538                 //cprintf("t-j  pid %d / tid %d\n",p->pid,p->tid);
3539                 // Found one.
3540                 kfree(p->kstack);
3541                 p->kstack = 0;
3542                 p->pid = 0;
3543                 p->tid = 0;
3544                 p->parent = 0;
3545                 p->name[0] = 0;
3546                 p->killed = 0;
3547                 p->state = UNUSED;
3548 
3549 
3550                 //ADDED
3551                 //dealocate thread stack
3552                 sz = PGROUNDUP(p->sz);
3553                 if((sz = deallocuvm(p->pgdir, sz, sz - 2*PGSIZE)) == 0){
3554                     goto bad;
3555                 }
3556                 empty_stack_clean(proc);
3557 
3558                 //The procedure that passing retval from t_exit to t_join
3559                 *retval = p->retval;
3560                 //printMLFQAll();
3561 
3562                 release(&ptable.lock);
3563 
3564                 return 0;
3565             }
3566         }
3567 
3568         // No point waiting if we don't have any children.
3569         if(!havekids || proc->killed){
3570             cprintf(" [Warning] There isn't child to join \n");
3571             release(&ptable.lock);
3572             return 0;
3573             //return -1;
3574         }
3575 
3576 
3577 
3578         // Wait for children to exit.  (See wakeup1 call in proc_exit.)
3579         sleep((void*)proc, &ptable.lock);  //DOC: wait-sleep
3580 
3581     }
3582 
3583 bad:
3584     cprintf(" [Error]thread join error\n");
3585     return -1;
3586     return 0;
3587 }
3588 
3589 
3590 
3591 
3592 
3593 
3594 
3595 
3596 
3597 
3598 
3599 
3600 int
3601 thread_clean(thread_t thread, void **retval){
3602 
3603     struct proc *p;
3604     uint sz;
3605     int fd;
3606 
3607     acquire(&ptable.lock);
3608     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
3609         if(p->isthread != 1 || p->tid != thread){
3610             continue;
3611         }
3612         // Found one.
3613 
3614         // THREAD EXIT---------------------
3615 
3616         if(p == initproc)
3617             panic("init exiting");
3618 
3619         release(&ptable.lock);
3620         // Close all open files.
3621         for(fd = 0; fd < NOFILE; fd++){
3622             if(p->ofile[fd]){
3623                 fileclose(p->ofile[fd]);
3624                 p->ofile[fd] = 0;
3625             }
3626         }
3627 
3628         begin_op();
3629         iput(p->cwd);
3630         end_op();
3631         p->cwd = 0;
3632 
3633 
3634         acquire(&ptable.lock);
3635         // Parent might be sleeping in join().
3636         wakeup1((void*)p->pid);
3637 
3638 
3639         //ADDED
3640         if(p->stride == 0)dequeue(&qOfM[p->qPosi],p);
3641         if(p->pid > 2 )cut_cpu_share(p->stride);
3642         p->consumedTime = 0;
3643         p->stride = 0;
3644         p->pass = 0;
3645         p->qPosi = 0;
3646 
3647 
3648         p->retval = retval;
3649 
3650         //ADDED
3651         proc->parent->numOfThread--;
3652         if(proc->parent->stride > 0)share_stride_in_proc(proc->parent);
3653 
3654         p->state = ZOMBIE;
3655 
3656 
3657         //THREAD CLEAN-----------------------------
3658         if(p->kstack)kfree(p->kstack);
3659         p->kstack = 0;
3660         p->pid = 0;
3661         p->parent = 0;
3662         p->name[0] = 0;
3663         p->killed = 0;
3664         p->state = UNUSED;
3665 
3666 
3667         //ADDED
3668         //dealocate thread stack
3669         sz = PGROUNDUP(p->sz);
3670         if((sz = deallocuvm(p->pgdir, sz, sz - 2*PGSIZE)) == 0){
3671             goto bad;
3672         }
3673         empty_stack_clean(proc);
3674 
3675         //The procedure that passing retval from t_exit to t_join
3676         *retval = p->retval;
3677 
3678         release(&ptable.lock);
3679         return 0;
3680     }
3681 
3682     // No point waiting if we don't have any children.
3683     if(proc->killed){
3684         cprintf(" [Warning] There is no child to clean\n");
3685         release(&ptable.lock);
3686         return 0;
3687         //return -1;
3688     }
3689 
3690 bad:
3691     cprintf(" [Error]thread clean error\n");
3692     release(&ptable.lock);
3693     return -1;
3694 }
3695 
3696 
3697 
3698 
3699 
3700     void
3701 clean(struct proc *target)
3702 {
3703     proc = target;
3704     switchuvm(target);
3705     target->state = RUNNING;
3706     wakeup(target);
3707     target->context->eip = (uint)exit;
3708     swtch(&proc->context, target->context);
3709 }
3710     int
3711 thread_fork(void)
3712 {
3713     int i, pid;
3714     struct proc *np;
3715     uint tmp_ebp, sz;
3716 
3717     tmp_ebp = proc->parent->tf->ebp;
3718     // Allocate process.
3719     if((np = allocproc()) == 0){
3720         return -1;
3721     }
3722 
3723 
3724     // Copy process state from p.
3725     if((np->pgdir = copyuvm_force(proc->pgdir, proc->sz)) == 0){
3726         cprintf("hello??\n");
3727         kfree(np->kstack);
3728         np->kstack = 0;
3729         np->state = UNUSED;
3730         return -1;
3731     }
3732     np->sz = proc->sz;
3733     np->parent = proc;
3734     *np->tf = *proc->tf;
3735 
3736 
3737     //ADDED
3738     //dealocate thread stack
3739     sz = PGROUNDUP(np->sz)- 2*PGSIZE;
3740     if((sz = deallocuvm(np->pgdir, sz, tmp_ebp)) == 0){
3741         cprintf("new process that forked by thread meets error\n");
3742     }
3743 
3744 
3745     // Clear %eax so that fork returns 0 in the child.
3746     np->tf->eax = 0;
3747 
3748 
3749 
3750     for(i = 0; i < NOFILE; i++)
3751         if(proc->ofile[i])
3752             np->ofile[i] = filedup(proc->ofile[i]);
3753     np->cwd = idup(proc->cwd);
3754 
3755     safestrcpy(np->name, proc->name, sizeof(proc->name));
3756 
3757     pid = np->pid;
3758 
3759     acquire(&ptable.lock);
3760 
3761     np->state = RUNNABLE;
3762     //ADDED
3763     enqueue(&qOfM[0],np);
3764 
3765     release(&ptable.lock);
3766 
3767     return pid;
3768 }
3769 
3770 void
3771 share_stride_in_proc(struct proc* parent){
3772     struct proc* p;
3773     ushort real_stride;
3774     ushort each_stride;
3775 
3776     if(parent->stride == 0) return ;
3777 
3778     real_stride = parent->pstride;
3779     each_stride = real_stride*(parent->numOfThread+1);
3780 
3781         findMinPassStride();
3782 
3783     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
3784         if(p->parent != parent || p->isthread != 1 ){
3785             continue;
3786         }
3787         p->stride = each_stride;
3788         p->pass = minPass;
3789 
3790     }
3791     parent->stride = each_stride;
3792 }
3793 
3794 
3795 
3796 
3797 
3798 
3799 
