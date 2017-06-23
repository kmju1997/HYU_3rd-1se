0250 struct buf;
0251 struct context;
0252 struct file;
0253 struct inode;
0254 struct pipe;
0255 struct proc;
0256 struct rtcdate;
0257 struct spinlock;
0258 struct sleeplock;
0259 struct stat;
0260 struct superblock;
0261 typedef unsigned long int thread_t;
0262 
0263 // bio.c
0264 void            binit(void);
0265 struct buf*     bread(uint, uint);
0266 void            brelse(struct buf*);
0267 void            bwrite(struct buf*);
0268 
0269 // console.c
0270 void            consoleinit(void);
0271 void            cprintf(char*, ...);
0272 void            consoleintr(int(*)(void));
0273 void            panic(char*) __attribute__((noreturn));
0274 
0275 // exec.c
0276 int             exec(char*, char**);
0277 
0278 // file.c
0279 struct file*    filealloc(void);
0280 void            fileclose(struct file*);
0281 struct file*    filedup(struct file*);
0282 void            fileinit(void);
0283 int             fileread(struct file*, char*, int n);
0284 int             filestat(struct file*, struct stat*);
0285 int             filewrite(struct file*, char*, int n);
0286 
0287 // fs.c
0288 void            readsb(int dev, struct superblock *sb);
0289 int             dirlink(struct inode*, char*, uint);
0290 struct inode*   dirlookup(struct inode*, char*, uint*);
0291 struct inode*   ialloc(uint, short);
0292 struct inode*   idup(struct inode*);
0293 void            iinit(int dev);
0294 void            ilock(struct inode*);
0295 void            iput(struct inode*);
0296 void            iunlock(struct inode*);
0297 void            iunlockput(struct inode*);
0298 void            iupdate(struct inode*);
0299 int             namecmp(const char*, const char*);
0300 struct inode*   namei(char*);
0301 struct inode*   nameiparent(char*, char*);
0302 int             readi(struct inode*, char*, uint, uint);
0303 void            stati(struct inode*, struct stat*);
0304 int             writei(struct inode*, char*, uint, uint);
0305 
0306 // ide.c
0307 void            ideinit(void);
0308 void            ideintr(void);
0309 void            iderw(struct buf*);
0310 
0311 // ioapic.c
0312 void            ioapicenable(int irq, int cpu);
0313 extern uchar    ioapicid;
0314 void            ioapicinit(void);
0315 
0316 // kalloc.c
0317 char*           kalloc(void);
0318 void            kfree(char*);
0319 void            kinit1(void*, void*);
0320 void            kinit2(void*, void*);
0321 
0322 // kbd.c
0323 void            kbdintr(void);
0324 
0325 // lapic.c
0326 void            cmostime(struct rtcdate *r);
0327 int             cpunum(void);
0328 extern volatile uint*    lapic;
0329 void            lapiceoi(void);
0330 void            lapicinit(void);
0331 void            lapicstartap(uchar, uint);
0332 void            microdelay(int);
0333 
0334 // log.c
0335 void            initlog(int dev);
0336 void            log_write(struct buf*);
0337 void            begin_op();
0338 void            end_op();
0339 
0340 // mp.c
0341 extern int      ismp;
0342 void            mpinit(void);
0343 
0344 // picirq.c
0345 void            picenable(int);
0346 void            picinit(void);
0347 
0348 
0349 
0350 // pipe.c
0351 int             pipealloc(struct file**, struct file**);
0352 void            pipeclose(struct pipe*, int);
0353 int             piperead(struct pipe*, char*, int);
0354 int             pipewrite(struct pipe*, char*, int);
0355 
0356 
0357 // proc.c
0358 void            exit(void);
0359 int             fork(void);
0360 int             growproc(int);
0361 int             kill(int);
0362 void            pinit(void);
0363 void            procdump(void);
0364 void            scheduler(void) __attribute__((noreturn));
0365 void            sched(void);
0366 void            sleep(void*, struct spinlock*);
0367 void            userinit(void);
0368 int             wait(void);
0369 void            wakeup(void*);
0370 void            yield(void);
0371 void            findMinPassStride(void);
0372 void            printPtable(void);
0373 int             thread_create(thread_t *thread, void *(*start_routine)(void *), void*arg);
0374 void            thread_exit(void * retval) __attribute__ ((noreturn));
0375 int             thread_join(thread_t thread, void **retval);
0376 int             thread_clean(thread_t thread, void **retval);
0377 void		    clean(struct proc *target);
0378 int             thread_fork(void);
0379 void            share_stride_in_proc(struct proc* parent);
0380 // swtch.S
0381 void            swtch(struct context**, struct context*);
0382 
0383 // spinlock.c
0384 void            acquire(struct spinlock*);
0385 void            getcallerpcs(void*, uint*);
0386 int             holding(struct spinlock*);
0387 void            initlock(struct spinlock*, char*);
0388 void            release(struct spinlock*);
0389 void            pushcli(void);
0390 void            popcli(void);
0391 
0392 // sleeplock.c
0393 void            acquiresleep(struct sleeplock*);
0394 void            releasesleep(struct sleeplock*);
0395 int             holdingsleep(struct sleeplock*);
0396 void            initsleeplock(struct sleeplock*, char*);
0397 
0398 
0399 
0400 // string.c
0401 int             memcmp(const void*, const void*, uint);
0402 void*           memmove(void*, const void*, uint);
0403 void*           memset(void*, int, uint);
0404 char*           safestrcpy(char*, const char*, int);
0405 int             strlen(const char*);
0406 int             strncmp(const char*, const char*, uint);
0407 char*           strncpy(char*, const char*, int);
0408 
0409 // syscall.c
0410 int             argint(int, int*);
0411 int             argptr(int, char**, int);
0412 int             argstr(int, char**);
0413 int             fetchint(uint, int*);
0414 int             fetchstr(uint, char**);
0415 void            syscall(void);
0416 
0417 // timer.c
0418 void            timerinit(void);
0419 
0420 // trap.c
0421 void            idtinit(void);
0422 extern uint     ticks;
0423 void            tvinit(void);
0424 extern struct spinlock tickslock;
0425 
0426 // uart.c
0427 void            uartinit(void);
0428 void            uartintr(void);
0429 void            uartputc(int);
0430 
0431 // vm.c
0432 void            seginit(void);
0433 void            kvmalloc(void);
0434 pde_t*          setupkvm(void);
0435 char*           uva2ka(pde_t*, char*);
0436 int             allocuvm(pde_t*, uint, uint);
0437 int             deallocuvm(pde_t*, uint, uint);
0438 void            freevm(pde_t*);
0439 void            inituvm(pde_t*, char*, uint);
0440 int             loaduvm(pde_t*, char*, struct inode*, uint, uint);
0441 pde_t*          copyuvm(pde_t*, uint);
0442 void            switchuvm(struct proc*);
0443 void            switchkvm(void);
0444 int             copyout(pde_t*, uint, void*, uint);
0445 void            clearpteu(pde_t *pgdir, char *uva);
0446 void            empty_stack_clean(struct proc *p);
0447 pde_t*          copyuvm_force(pde_t*, uint);
0448 
0449 
0450 //prac_syscall.c
0451 int             my_syscall(char*);
0452 // number of elements in fixed-size array
0453 #define NELEM(x) (sizeof(x)/sizeof((x)[0]))
0454 
0455 
0456 
0457 
0458 
0459 
0460 
0461 
0462 
0463 
0464 
0465 
0466 
0467 
0468 
0469 
0470 
0471 
0472 
0473 
0474 
0475 
0476 
0477 
0478 
0479 
0480 
0481 
0482 
0483 
0484 
0485 
0486 
0487 
0488 
0489 
0490 
0491 
0492 
0493 
0494 
0495 
0496 
0497 
0498 
0499 
