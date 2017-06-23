#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "mlfq.h"
#include "stride.h"
#include "thread.h"
#include "spinlock.h"

struct {
    struct spinlock lock;
    struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
int nexttid = 1000;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

    void
pinit(void)
{
    initlock(&ptable.lock, "ptable");
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
    static struct proc*
allocproc(void)
{
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if(p->state == UNUSED)
            goto found;

    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
    p->pid = nextpid++;
    //ADDED
    p->tid = 0;
    p->isthread = 0;
    p->numOfThread = 0;

    release(&ptable.lock);

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
        p->state = UNUSED;
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
    p->tf = (struct trapframe*)sp;

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint*)sp = (uint)trapret;

    sp -= sizeof *p->context;
    p->context = (struct context*)sp;
    memset(p->context, 0, sizeof *p->context);
    p->context->eip = (uint)forkret;

    return p;
}

//PAGEBREAK: 32
// Set up first user process.
    void
userinit(void)
{
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    p = allocproc();

    initproc = p;
    if((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
    p->sz = PGSIZE;
    memset(p->tf, 0, sizeof(*p->tf));
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
    p->tf->es = p->tf->ds;
    p->tf->ss = p->tf->ds;
    p->tf->eflags = FL_IF;
    p->tf->esp = PGSIZE;
    p->tf->eip = 0;  // beginning of initcode.S

    safestrcpy(p->name, "initcode", sizeof(p->name));
    p->cwd = namei("/");

    // this assignment to p->state lets other cores
    // run this process. the acquire forces the above
    // writes to be visible, and the lock is also needed
    // because the assignment might not be atomic.
    acquire(&ptable.lock);

    p->state = RUNNABLE;

    release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
    int
growproc(int n)
{
    uint sz;

    //ADDED
    acquire(&ptable.lock);

    sz = proc->sz;
    if(n > 0){
        if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
            return -1;
    } else if(n < 0){
        if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
            return -1;
    }
    //ADDED
    if(proc->isthread == 1){
        proc->parent->sz = sz;
    }
    proc->sz = sz;
    release(&ptable.lock);

    switchuvm(proc);
    return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
    int
fork(void)
{
    int i, pid;
    struct proc *np;
    //struct proc *iter;


    if(proc->isthread == 1){
        return thread_fork();
    }


    // Allocate process.
    if((np = allocproc()) == 0){
        return -1;
    }

    // Copy process state from p.
    if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
        kfree(np->kstack);
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
    }
    np->sz = proc->sz;
    np->parent = proc;
    *np->tf = *proc->tf;

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for(i = 0; i < NOFILE; i++)
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);
    np->cwd = idup(proc->cwd);

    safestrcpy(np->name, proc->name, sizeof(proc->name));

    pid = np->pid;

    acquire(&ptable.lock);

    np->state = RUNNABLE;
    //for added
    enqueue(&qOfM[0],np);

    release(&ptable.lock);

    return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
    void
exit(void)
{
    struct proc *p;
    int fd;
    int c_retval = 0;


    if(proc->isthread == 1){
        return clean(proc->parent);

    }

    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
        if(proc->ofile[fd]){
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }

    begin_op();
    iput(proc->cwd);
    end_op();
    proc->cwd = 0;

    acquire(&ptable.lock);

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);

    /* COMMENT
       cprintf("-----------Before------------\n");
       printPtable();
       */


    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->parent == proc){
            //ADDED - Clean threads of proc
            if(p->isthread == 1){
                release(&ptable.lock);
                thread_clean(p->tid,(void**)c_retval);
                acquire(&ptable.lock);
            }

            p->parent = initproc;
            if(p->state == ZOMBIE){
                wakeup1(initproc);
            }
        }
    }


    // Jump into the scheduler, never to return.
    // for added
    if(proc->stride == 0)dequeue(&qOfM[proc->qPosi],proc);
    proc->consumedTime = 0;
    if(proc->pid > 2 )cut_cpu_share(proc->stride);
    proc->stride = 0;
    proc->pass = 0;
    proc->qPosi = 0;

    //to confirm
    wakeup1(proc->parent);

    proc->state = ZOMBIE;


    /*COMMENT
      cprintf("-----------After------------\n");
    cprintf(    "exi : %d in : %d\n",proc->pid, proc->qPosi);
      printPtable();
      */

    sched();
    panic("zombie exit");


}
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
    int
wait(void)
{
    struct proc *p;
    int havekids, pid;
    //int retval = 0;

    acquire(&ptable.lock);
    for(;;){
        // Scan through table looking for exited children.
        havekids = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
            if(p->parent != proc )
                continue;
            if(p->isthread == 1)
                continue;
            havekids = 1;
            if(p->state == ZOMBIE){
                // Found one.
                pid = p->pid;
                kfree(p->kstack);
                p->kstack = 0;
                freevm(p->pgdir);
                p->pid = 0;
                p->parent = 0;
                p->name[0] = 0;
                p->killed = 0;
                p->state = UNUSED;
                release(&ptable.lock);
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if(!havekids || proc->killed){
            release(&ptable.lock);
            return -1;
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
    }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
    void
scheduler(void)
{
    struct proc *p;
    int i = 0;
    struct Mlfq* nextQ;
    int checkQ = 0; //for check 'for looping queue' and nextQ
    curQ = 0;
    MlfqProcFlag = 0;

    initMlfq(&qOfM[0]);
    initMlfq(&qOfM[1]);
    initMlfq(&qOfM[2]);
    initMlfqGlobal();
    initStride();

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state == UNUSED)
            continue;
        enqueue(&qOfM[0],p); 
    }   
    release(&ptable.lock);



    for(;;){
        // Enable interrupts on this processor.
        sti();

        nextQ = &qOfM[curQ];
        schedulerMode = 0;

        checkRcount(&qOfM[0]);
        checkRcount(&qOfM[1]);
        checkRcount(&qOfM[2]);

        if(qOfM[0].rCount != 0){
            curQ = 0;
        }else if(qOfM[1].rCount != 0){
            curQ = 1;
        }else if(qOfM[2].rCount != 0){
            curQ = 2;
        }else curQ =0;
        checkQ = curQ;
        nextQ = &qOfM[curQ];



        // Loop over process table looking for process to run.
        acquire(&ptable.lock);

        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
            findMinPassStride();
            if(minPass == MlfqPass){
                schedulerMode = 1;
                break;
            }
            if(p->pass != minPass || p->stride == 0)
                continue;
            if(p->state != RUNNABLE )
                continue;

            p->pass += p->stride;

            schedulerMode =0;

            proc = p;
            switchuvm(p);
            p->state = RUNNING;
            swtch(&cpu->scheduler, p->context);
            switchkvm();

            proc = 0;
        }

        if(schedulerMode == 1)
        {
            for(p = peekMlfq(nextQ); p; p = idxPeekMlfq(nextQ,i)){

                if(qOfM[0].rCount != 0){
                    curQ = 0;
                }else if(qOfM[1].rCount != 0){
                    curQ = 1;
                }else if(qOfM[2].rCount != 0){
                    curQ = 2;
                }else curQ =0;
                if(checkQ != curQ) break;


                if(p->state != RUNNABLE){
                    i++;;
                    continue;
                }


                i=0;

                proc = p;
                switchuvm(p);
                p->state = RUNNING;
                swtch(&cpu->scheduler, p->context);
                switchkvm();

                proc = 0;
            }

            MlfqPass += MlfqStride;
        }
        release(&ptable.lock);
    }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
    void
sched(void)
{
    int intena;

    if(!holding(&ptable.lock))
        panic("sched ptable.lock");
    if(cpu->ncli != 1)
        panic("sched locks");
    if(proc->state == RUNNING)
        panic("sched running");
    if(readeflags()&FL_IF)
        panic("sched interruptible");
    intena = cpu->intena;
    swtch(&proc->context, cpu->scheduler);
    cpu->intena = intena;
}

// Give up the CPU for one scheduling round.
    void
yield(void)
{
    //cprintf("yield~~!~!~!~!\n");
    acquire(&ptable.lock);  //DOC: yieldlock
    if(yieldbytimer == 0 && proc->stride == 0 && schedulerMode == 1){

        dequeue(&qOfM[proc->qPosi],proc);
        enqueue(&qOfM[proc->qPosi], proc);
    }
    proc->state = RUNNABLE;
    yieldbytimer = 0;
    sched();
    release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
    void
forkret(void)
{
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);

    if (first) {
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot
        // be run from main().
        first = 0;
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
    void
sleep(void *chan, struct spinlock *lk)
{
    if(proc == 0)
        panic("sleep");

    if(lk == 0)
        panic("sleep without lk");

    // Must acquire ptable.lock in order to
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if(lk != &ptable.lock){  //DOC: sleeplock0
        acquire(&ptable.lock);  //DOC: sleeplock1
        release(lk);
    }

    // Go to sleep.
    proc->chan = chan;
    proc->state = SLEEPING;

    //cprintf(" sleep in~~~~pid %d tid %d\n",proc->pid,proc->tid);
    sched();

    //cprintf(" sleep done ~~~~pid %d tid %d\n",proc->pid,proc->tid);
    // Tidy up.
    proc->chan = 0;

    // Reacquire original lock.
    if(lk != &ptable.lock){  //DOC: sleeplock2
        release(&ptable.lock);
        acquire(lk);
    }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if(p->state == SLEEPING && p->chan == chan){
            p->state = RUNNABLE;
        }
}

// Wake up all processes sleeping on chan.
    void
wakeup(void *chan)
{
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
    int
kill(int pid)
{

    struct proc *p;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->pid == pid){
            p->killed = 1;
            // Wake process from sleep if necessary.
            if(p->state == SLEEPING)
                p->state = RUNNABLE;
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
    return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
    void
procdump(void)
{
    static char *states[] = {
        [UNUSED]    "unused",
        [EMBRYO]    "embryo",
        [SLEEPING]  "sleep ",
        [RUNNABLE]  "runble",
        [RUNNING]   "run   ",
        [ZOMBIE]    "zombie"
    };
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state == UNUSED)
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
            state = states[p->state];
        else
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        if(p->state == SLEEPING){
            getcallerpcs((uint*)p->context->ebp+2, pc);
            for(i=0; i<10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
    }
}

//For ADDED : scheduler-----------------------------------------------

//ADDED : Decrease every process's pass value if overflow occurs
    void
findMinPassStride(void)
{
    struct proc* p;
    int overflowFlag = 0;

    minPass = MlfqPass;
    if(minPass >= 2147483647 - 20000){
        overflowFlag = 1;
    }

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state != RUNNABLE)
            continue;
        if(p->pass >= 2147483647 - 20000){
            /*
               cprintf("[Warning] stride pass overflow~~-    -   -   -   -   -   -   -   -   -   -   -\n");
               cprintf(" Let OS manage pass of processes~~-    -   -   -   -   -   -   -   -   -   -   -\n");
               */
            overflowFlag = 1;
        }
        if(p->stride >0 && p->pass <= minPass){
            minPass = p->pass;
        }
    }

    if(overflowFlag == 1){
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
            if(p->state != RUNNABLE)
                continue;
            if(p->pass > 0){
                p->pass = p->pass - minPass + 10;
            }
        }
        MlfqPass = MlfqPass - minPass + 10;
        overflowFlag = 0;
    }
}    

///for debugging
    void
printPtable(void)
{
    struct proc* p;

    cprintf("hello~~~~~~\n");
    cprintf(" Mlfq:: / stride %d / pass %d\n",MlfqStride, MlfqPass);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->pid != 0)
            cprintf(" pid %d / tid %d/ ppid %d/ ptid %d/ name %s /state %d / cT %d / stride %d / p-s %d/ pass %d / n-o-t %d\n",\
                    p->pid,p->tid, p->parent->pid, p->parent->tid, p->name, p->state,p->consumedTime, p->stride, p->pstride, p->pass, p->numOfThread);

    }
}

//ADDED
//HW3
    static struct proc*
allocthread(void)
{
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if(p->state == UNUSED)
            goto found;

    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
    //ADDED
    p->tid = nexttid++ + proc->pid*100;

    release(&ptable.lock);

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
        p->state = UNUSED;
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
    p->tf = (struct trapframe*)sp;

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint*)sp = (uint)trapret;

    sp -= sizeof *p->context;
    p->context = (struct context*)sp;
    memset(p->context, 0, sizeof *p->context);
    p->context->eip = (uint)forkret;

    return p;
}
//For ADDED : thread ----------------------------------------
//If isthread == 1, then proc is treated as thread structure
int
thread_create(thread_t *thread, void *(*start_routine)(void *), void*arg){

    int i;
    uint sz, sp;
    struct proc *np;

    // Allocate process.
    if((np = allocthread()) == 0){
        return -1;
    }

    np->pid = proc->pid;

    // Copy process state from p.
    np->pgdir = proc->pgdir;

    //ADDED
    if(proc->isthread == 1 ){
        np->parent = proc->parent;
    }else{
        np->parent = proc;
    }
    *np->tf = *proc->tf;

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    np->tf->eip = (int)(*start_routine);
    np->isthread = 1;


    acquire(&ptable.lock);
    //Allocate thread stack
    sz = PGROUNDUP(np->parent->sz);
    if((sz = allocuvm(np->parent->pgdir, sz, sz + 2*PGSIZE)) == 0){
        goto bad;
    }
    clearpteu(np->parent->pgdir, (char*)(sz - 2*PGSIZE));
    release(&ptable.lock);
    sp = sz;
    np->parent->sz = sz;
    np->sz = sz;
    np->stack = sp;

    np->tf->esp = sp;
    *((int*)(np->tf->esp - 4)) = (int)arg;
    *((int *)(np->tf->esp - 8)) = 0xFFFFFFFF;
    np->tf->esp -= 8;



    for(i = 0; i < NOFILE; i++)
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);
    np->cwd = idup(proc->cwd);

    safestrcpy(np->name, proc->name, sizeof(proc->name));

    //ADDED
    *thread = np->tid;
    proc->numOfThread++;
    if(proc->stride>0)share_stride_in_proc(proc);

    acquire(&ptable.lock);

    np->state = RUNNABLE;
    enqueue(&qOfM[0],np);

    //CMT
    //cprintf("t-c pid %d / tid %d\n",np->pid,np->tid);
    //printPtable();
    release(&ptable.lock);
    yield();


    return 0;

bad:
    cprintf("thread_create error'\n");

    return -1;
}

void
thread_exit(void * retval){

    struct proc *p;
    int fd;


    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
        if(proc->ofile[fd]){
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }

    begin_op();
    iput(proc->cwd);
    end_op();
    proc->cwd = 0;

    acquire(&ptable.lock);

    // Parent might be sleeping in join().
    wakeup1((void*)proc->parent);

    ///*
    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->parent == proc){
            p->parent = initproc;
            if(p->state == ZOMBIE){
                wakeup1(initproc);
            }
        }
    }
    //*/

    // Jump into the scheduler, never to return.
    //ADDED
    if(proc->stride == 0)dequeue(&qOfM[proc->qPosi],proc);
    if(proc->pid > 2 )cut_cpu_share(proc->stride);
    proc->consumedTime = 0;
    proc->stride = 0;
    proc->pass = 0;
    proc->qPosi = 0;


    //ADDED
    proc->retval = retval;

    proc->state = ZOMBIE;

    proc->parent->numOfThread--;
    if(proc->parent->stride > 0)share_stride_in_proc(proc->parent);

    //CMT
    //printMLFQAll();
    //cprintf("t-e pid %d / tid %d\n",proc->pid,proc->tid);
    //printPtable();

    sched();
    panic("zombie exit");
}

int
thread_join(thread_t thread, void **retval){

    struct proc *p;
    int havekids;
    uint sz;

    acquire(&ptable.lock);
    for(;;){
        // Scan through table looking for exited children.
        havekids = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
            if(p->parent != proc || p->isthread != 1 || p->tid != thread){
                continue;
            }
            havekids = 1;
            if(p->state == ZOMBIE){
                //CMT
                //cprintf("t-j  pid %d / tid %d\n",p->pid,p->tid);
                // Found one.
                kfree(p->kstack);
                p->kstack = 0;
                p->pid = 0;
                p->tid = 0;
                p->parent = 0;
                p->name[0] = 0;
                p->killed = 0;
                p->state = UNUSED;

                //ADDED
                //dealocate thread stack
                sz = PGROUNDUP(p->sz);
                if((sz = deallocuvm(p->pgdir, sz, sz - 2*PGSIZE)) == 0){
                    goto bad;
                }
                empty_stack_clean(proc);

                //The procedure that passing retval from t_exit to t_join
                *retval = p->retval;
                //printMLFQAll();

                release(&ptable.lock);

                return 0;
            }
        }

        // No point waiting if we don't have any children.
        if(!havekids || proc->killed){
            cprintf(" [Warning] There isn't child to join \n");
            release(&ptable.lock);
            return 0;
            //return -1;
        }



        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep((void*)proc, &ptable.lock);  //DOC: wait-sleep

    }

bad:
    cprintf(" [Error]thread join error\n");
    return -1;
    return 0;
}

int
thread_clean(thread_t thread, void **retval){

    struct proc *p;
    uint sz;
    int fd;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->isthread != 1 || p->tid != thread){
            continue;
        }
        // Found one.

        // THREAD EXIT---------------------

        if(p == initproc)
            panic("init exiting");

        release(&ptable.lock);
        // Close all open files.
        for(fd = 0; fd < NOFILE; fd++){
            if(p->ofile[fd]){
                fileclose(p->ofile[fd]);
                p->ofile[fd] = 0;
            }
        }

        begin_op();
        iput(p->cwd);
        end_op();
        p->cwd = 0;


        acquire(&ptable.lock);
        // Parent might be sleeping in join().
        wakeup1((void*)p->pid);


        //ADDED
        if(p->stride == 0)dequeue(&qOfM[p->qPosi],p);
        if(p->pid > 2 )cut_cpu_share(p->stride);
        p->consumedTime = 0;
        p->stride = 0;
        p->pass = 0;
        p->qPosi = 0;


        p->retval = retval;

        //ADDED
        proc->parent->numOfThread--;
        if(proc->parent->stride > 0)share_stride_in_proc(proc->parent);

        p->state = ZOMBIE;


        //THREAD CLEAN-----------------------------
        if(p->kstack)kfree(p->kstack);
        p->kstack = 0;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;


        //ADDED
        //dealocate thread stack
        sz = PGROUNDUP(p->sz);
        if((sz = deallocuvm(p->pgdir, sz, sz - 2*PGSIZE)) == 0){
            goto bad;
        }
        empty_stack_clean(proc);

        //The procedure that passing retval from t_exit to t_join
        *retval = p->retval;

        release(&ptable.lock);
        return 0;
    }

    // No point waiting if we don't have any children.
    if(proc->killed){
        cprintf(" [Warning] There is no child to clean\n");
        release(&ptable.lock);
        return 0;
        //return -1;
    }

bad:
    cprintf(" [Error]thread clean error\n");
    release(&ptable.lock);
    return -1;
}

    void
clean(struct proc *target)
{
    proc = target;
    switchuvm(target);
    target->state = RUNNING;
    wakeup(target);
    target->context->eip = (uint)exit;
    swtch(&proc->context, target->context);
}
    int
thread_fork(void)
{
    int i, pid;
    struct proc *np;
    uint tmp_ebp, sz;

    tmp_ebp = proc->parent->tf->ebp;
    // Allocate process.
    if((np = allocproc()) == 0){
        return -1;
    }


    // Copy process state from p.
    if((np->pgdir = copyuvm_force(proc->pgdir, proc->sz)) == 0){
        cprintf("hello??\n");
        kfree(np->kstack);
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
    }
    np->sz = proc->sz;
    np->parent = proc;
    *np->tf = *proc->tf;


    //ADDED
    //dealocate thread stack
    sz = PGROUNDUP(np->sz)- 2*PGSIZE;
    if((sz = deallocuvm(np->pgdir, sz, tmp_ebp)) == 0){
        cprintf("new process that forked by thread meets error\n");
    }


    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;


    for(i = 0; i < NOFILE; i++)
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);
    np->cwd = idup(proc->cwd);

    safestrcpy(np->name, proc->name, sizeof(proc->name));

    pid = np->pid;

    acquire(&ptable.lock);

    np->state = RUNNABLE;
    //ADDED
    enqueue(&qOfM[0],np);

    release(&ptable.lock);

    return pid;
}

void
share_stride_in_proc(struct proc* parent){
    struct proc* p;
    ushort real_stride;
    ushort each_stride;

    if(parent->stride == 0) return ;

    real_stride = parent->pstride;
    each_stride = real_stride*(parent->numOfThread+1);

        findMinPassStride();

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->parent != parent || p->isthread != 1 ){
            continue;
        }
        p->stride = each_stride;
        p->pass = minPass;

    }
    parent->stride = each_stride;
}

