
_threadtest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    "stresstest",
};

    int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 e4 f0             	and    $0xfffffff0,%esp
   9:	83 ec 20             	sub    $0x20,%esp
   c:	8b 7d 0c             	mov    0xc(%ebp),%edi
    int i;
    int ret;
    int pid;
    int start = 0;
    int end = NTEST-1;
    if (argc >= 2)
   f:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  13:	0f 8e 2e 01 00 00    	jle    147 <main+0x147>
        start = atoi(argv[1]);
  19:	8b 47 04             	mov    0x4(%edi),%eax
{
    int i;
    int ret;
    int pid;
    int start = 0;
    int end = NTEST-1;
  1c:	be 04 00 00 00       	mov    $0x4,%esi
    if (argc >= 2)
        start = atoi(argv[1]);
  21:	89 04 24             	mov    %eax,(%esp)
  24:	e8 27 09 00 00       	call   950 <atoi>
    if (argc >= 3)
  29:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
    int ret;
    int pid;
    int start = 0;
    int end = NTEST-1;
    if (argc >= 2)
        start = atoi(argv[1]);
  2d:	89 c3                	mov    %eax,%ebx
    if (argc >= 3)
  2f:	74 0d                	je     3e <main+0x3e>
        end = atoi(argv[2]);
  31:	8b 47 08             	mov    0x8(%edi),%eax
  34:	89 04 24             	mov    %eax,(%esp)
  37:	e8 14 09 00 00       	call   950 <atoi>
  3c:	89 c6                	mov    %eax,%esi

    for (i = start; i <= end; i++){
  3e:	39 de                	cmp    %ebx,%esi
  40:	0f 8c fc 00 00 00    	jl     142 <main+0x142>
            write(gpipe[1], (char*)&ret, sizeof(ret));
            close(gpipe[1]);
            exit();
        } else{
            close(gpipe[1]);
            if (wait() == -1 || read(gpipe[0], (char*)&ret, sizeof(ret)) == -1 || ret != 0){
  46:	8d 7c 24 1c          	lea    0x1c(%esp),%edi
  4a:	e9 a8 00 00 00       	jmp    f7 <main+0xf7>
  4f:	90                   	nop
        printf(1,"%d. %s start\n", i, testname[i]);
        if (pipe(gpipe) < 0){
            printf(1,"pipe panic\n");
            exit();
        }
        ret = 0;
  50:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  57:	00 

        if ((pid = fork()) < 0){
  58:	e8 4d 09 00 00       	call   9aa <fork>
  5d:	85 c0                	test   %eax,%eax
  5f:	0f 88 16 01 00 00    	js     17b <main+0x17b>
            printf(1,"fork panic\n");
            exit();
        }
        if (pid == 0){
  65:	0f 84 29 01 00 00    	je     194 <main+0x194>
            ret = testfunc[i]();
            write(gpipe[1], (char*)&ret, sizeof(ret));
            close(gpipe[1]);
            exit();
        } else{
            close(gpipe[1]);
  6b:	a1 08 14 00 00       	mov    0x1408,%eax
  70:	89 04 24             	mov    %eax,(%esp)
  73:	e8 62 09 00 00       	call   9da <close>
            if (wait() == -1 || read(gpipe[0], (char*)&ret, sizeof(ret)) == -1 || ret != 0){
  78:	e8 3d 09 00 00       	call   9ba <wait>
  7d:	83 f8 ff             	cmp    $0xffffffff,%eax
  80:	0f 84 cd 00 00 00    	je     153 <main+0x153>
  86:	a1 04 14 00 00       	mov    0x1404,%eax
  8b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  92:	00 
  93:	89 7c 24 04          	mov    %edi,0x4(%esp)
  97:	89 04 24             	mov    %eax,(%esp)
  9a:	e8 2b 09 00 00       	call   9ca <read>
  9f:	83 f8 ff             	cmp    $0xffffffff,%eax
  a2:	0f 84 ab 00 00 00    	je     153 <main+0x153>
  a8:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  ac:	85 c0                	test   %eax,%eax
  ae:	0f 85 9f 00 00 00    	jne    153 <main+0x153>
                printf(1,"%d. %s panic\n", i, testname[i]);
                exit();
            }
            close(gpipe[0]);
  b4:	a1 04 14 00 00       	mov    0x1404,%eax
  b9:	89 04 24             	mov    %eax,(%esp)
  bc:	e8 19 09 00 00       	call   9da <close>
        }
        printf(1,"%d. %s finish\n", i, testname[i]);
  c1:	8b 04 9d cc 13 00 00 	mov    0x13cc(,%ebx,4),%eax
  c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    if (argc >= 2)
        start = atoi(argv[1]);
    if (argc >= 3)
        end = atoi(argv[2]);

    for (i = start; i <= end; i++){
  cc:	83 c3 01             	add    $0x1,%ebx
                printf(1,"%d. %s panic\n", i, testname[i]);
                exit();
            }
            close(gpipe[0]);
        }
        printf(1,"%d. %s finish\n", i, testname[i]);
  cf:	c7 44 24 04 2f 0f 00 	movl   $0xf2f,0x4(%esp)
  d6:	00 
  d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  de:	89 44 24 0c          	mov    %eax,0xc(%esp)
  e2:	e8 59 0a 00 00       	call   b40 <printf>
        sleep(100);
  e7:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  ee:	e8 57 09 00 00       	call   a4a <sleep>
    if (argc >= 2)
        start = atoi(argv[1]);
    if (argc >= 3)
        end = atoi(argv[2]);

    for (i = start; i <= end; i++){
  f3:	39 f3                	cmp    %esi,%ebx
  f5:	7f 4b                	jg     142 <main+0x142>
        printf(1,"%d. %s start\n", i, testname[i]);
  f7:	8b 04 9d cc 13 00 00 	mov    0x13cc(,%ebx,4),%eax
  fe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 102:	c7 44 24 04 fb 0e 00 	movl   $0xefb,0x4(%esp)
 109:	00 
 10a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 111:	89 44 24 0c          	mov    %eax,0xc(%esp)
 115:	e8 26 0a 00 00       	call   b40 <printf>
        if (pipe(gpipe) < 0){
 11a:	c7 04 24 04 14 00 00 	movl   $0x1404,(%esp)
 121:	e8 9c 08 00 00       	call   9c2 <pipe>
 126:	85 c0                	test   %eax,%eax
 128:	0f 89 22 ff ff ff    	jns    50 <main+0x50>
            printf(1,"pipe panic\n");
 12e:	c7 44 24 04 09 0f 00 	movl   $0xf09,0x4(%esp)
 135:	00 
 136:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 13d:	e8 fe 09 00 00       	call   b40 <printf>
            exit();
 142:	e8 6b 08 00 00       	call   9b2 <exit>
{
    int i;
    int ret;
    int pid;
    int start = 0;
    int end = NTEST-1;
 147:	be 04 00 00 00       	mov    $0x4,%esi
main(int argc, char *argv[])
{
    int i;
    int ret;
    int pid;
    int start = 0;
 14c:	31 db                	xor    %ebx,%ebx
 14e:	e9 f3 fe ff ff       	jmp    46 <main+0x46>
            close(gpipe[1]);
            exit();
        } else{
            close(gpipe[1]);
            if (wait() == -1 || read(gpipe[0], (char*)&ret, sizeof(ret)) == -1 || ret != 0){
                printf(1,"%d. %s panic\n", i, testname[i]);
 153:	8b 04 9d cc 13 00 00 	mov    0x13cc(,%ebx,4),%eax
 15a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 15e:	c7 44 24 04 21 0f 00 	movl   $0xf21,0x4(%esp)
 165:	00 
 166:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 16d:	89 44 24 0c          	mov    %eax,0xc(%esp)
 171:	e8 ca 09 00 00       	call   b40 <printf>
                exit();
 176:	e8 37 08 00 00       	call   9b2 <exit>
            exit();
        }
        ret = 0;

        if ((pid = fork()) < 0){
            printf(1,"fork panic\n");
 17b:	c7 44 24 04 15 0f 00 	movl   $0xf15,0x4(%esp)
 182:	00 
 183:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 18a:	e8 b1 09 00 00       	call   b40 <printf>
            exit();
 18f:	e8 1e 08 00 00       	call   9b2 <exit>
        }
        if (pid == 0){
            close(gpipe[0]);
 194:	a1 04 14 00 00       	mov    0x1404,%eax
 199:	89 04 24             	mov    %eax,(%esp)
 19c:	e8 39 08 00 00       	call   9da <close>
            ret = testfunc[i]();
 1a1:	ff 14 9d e0 13 00 00 	call   *0x13e0(,%ebx,4)
            write(gpipe[1], (char*)&ret, sizeof(ret));
 1a8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
 1af:	00 
            printf(1,"fork panic\n");
            exit();
        }
        if (pid == 0){
            close(gpipe[0]);
            ret = testfunc[i]();
 1b0:	89 44 24 1c          	mov    %eax,0x1c(%esp)
            write(gpipe[1], (char*)&ret, sizeof(ret));
 1b4:	8d 44 24 1c          	lea    0x1c(%esp),%eax
 1b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 1bc:	a1 08 14 00 00       	mov    0x1408,%eax
 1c1:	89 04 24             	mov    %eax,(%esp)
 1c4:	e8 09 08 00 00       	call   9d2 <write>
            close(gpipe[1]);
 1c9:	a1 08 14 00 00       	mov    0x1408,%eax
 1ce:	89 04 24             	mov    %eax,(%esp)
 1d1:	e8 04 08 00 00       	call   9da <close>
            exit();
 1d6:	e8 d7 07 00 00       	call   9b2 <exit>
 1db:	66 90                	xchg   %ax,%ax
 1dd:	66 90                	xchg   %ax,%ax
 1df:	90                   	nop

000001e0 <basicthreadmain>:
}

// ============================================================================
    void*
basicthreadmain(void *arg)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	57                   	push   %edi
    int tid = (int) arg;
    int i;
    for (i = 0; i < 100000000; i++){
        if (i % 20000000 == 0){
 1e4:	bf 6b ca 5f 6b       	mov    $0x6b5fca6b,%edi
}

// ============================================================================
    void*
basicthreadmain(void *arg)
{
 1e9:	56                   	push   %esi
 1ea:	53                   	push   %ebx
    int tid = (int) arg;
    int i;
    for (i = 0; i < 100000000; i++){
 1eb:	31 db                	xor    %ebx,%ebx
}

// ============================================================================
    void*
basicthreadmain(void *arg)
{
 1ed:	83 ec 1c             	sub    $0x1c,%esp
 1f0:	8b 75 08             	mov    0x8(%ebp),%esi
 1f3:	eb 0e                	jmp    203 <basicthreadmain+0x23>
 1f5:	8d 76 00             	lea    0x0(%esi),%esi
    int tid = (int) arg;
    int i;
    for (i = 0; i < 100000000; i++){
 1f8:	83 c3 01             	add    $0x1,%ebx
 1fb:	81 fb 00 e1 f5 05    	cmp    $0x5f5e100,%ebx
 201:	74 3b                	je     23e <basicthreadmain+0x5e>
        if (i % 20000000 == 0){
 203:	89 d8                	mov    %ebx,%eax
 205:	f7 ef                	imul   %edi
 207:	89 d8                	mov    %ebx,%eax
 209:	c1 f8 1f             	sar    $0x1f,%eax
 20c:	c1 fa 17             	sar    $0x17,%edx
 20f:	29 c2                	sub    %eax,%edx
 211:	69 d2 00 2d 31 01    	imul   $0x1312d00,%edx,%edx
 217:	39 d3                	cmp    %edx,%ebx
 219:	75 dd                	jne    1f8 <basicthreadmain+0x18>
            printf(1, "%d", tid);
 21b:	89 74 24 08          	mov    %esi,0x8(%esp)
    void*
basicthreadmain(void *arg)
{
    int tid = (int) arg;
    int i;
    for (i = 0; i < 100000000; i++){
 21f:	83 c3 01             	add    $0x1,%ebx
        if (i % 20000000 == 0){
            printf(1, "%d", tid);
 222:	c7 44 24 04 a6 0e 00 	movl   $0xea6,0x4(%esp)
 229:	00 
 22a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 231:	e8 0a 09 00 00       	call   b40 <printf>
    void*
basicthreadmain(void *arg)
{
    int tid = (int) arg;
    int i;
    for (i = 0; i < 100000000; i++){
 236:	81 fb 00 e1 f5 05    	cmp    $0x5f5e100,%ebx
 23c:	75 c5                	jne    203 <basicthreadmain+0x23>
        if (i % 20000000 == 0){
            printf(1, "%d", tid);
        }
    }
    thread_exit((void *)(tid+1));
 23e:	83 c6 01             	add    $0x1,%esi
 241:	89 34 24             	mov    %esi,(%esp)
 244:	e8 39 08 00 00       	call   a82 <thread_exit>
 249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000250 <jointhreadmain>:

// ============================================================================

    void*
jointhreadmain(void *arg)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	83 ec 18             	sub    $0x18,%esp
    int val = (int)arg;
    sleep(200);
 256:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
 25d:	e8 e8 07 00 00       	call   a4a <sleep>
    printf(1, "thread_exit...\n");
 262:	c7 44 24 04 a9 0e 00 	movl   $0xea9,0x4(%esp)
 269:	00 
 26a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 271:	e8 ca 08 00 00       	call   b40 <printf>
    thread_exit((void *)(val*2));
 276:	8b 45 08             	mov    0x8(%ebp),%eax
 279:	01 c0                	add    %eax,%eax
 27b:	89 04 24             	mov    %eax,(%esp)
 27e:	e8 ff 07 00 00       	call   a82 <thread_exit>
 283:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000290 <stressthreadmain>:

// ============================================================================

    void*
stressthreadmain(void *arg)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	83 ec 18             	sub    $0x18,%esp
    thread_exit(0);
 296:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 29d:	e8 e0 07 00 00       	call   a82 <thread_exit>
 2a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002b0 <racingthreadmain>:
}


    void*
racingthreadmain(void *arg)
{
 2b0:	8b 0d 00 14 00 00    	mov    0x1400,%ecx
    int tid = (int) arg;
    int i;
    int tmp;

    for (i = 0; i < 10000000; i++){
 2b6:	31 c0                	xor    %eax,%eax
        tmp = gcnt;
        tmp++;
 2b8:	8d 54 08 01          	lea    0x1(%eax,%ecx,1),%edx
{
    int tid = (int) arg;
    int i;
    int tmp;

    for (i = 0; i < 10000000; i++){
 2bc:	83 c0 01             	add    $0x1,%eax
 2bf:	3d 80 96 98 00       	cmp    $0x989680,%eax
 2c4:	75 f2                	jne    2b8 <racingthreadmain+0x8>
}


    void*
racingthreadmain(void *arg)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 18             	sub    $0x18,%esp
        tmp = gcnt;
        tmp++;
        nop();
        gcnt = tmp;
    }
    thread_exit((void *)(tid+1));
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	89 15 00 14 00 00    	mov    %edx,0x1400
 2d5:	83 c0 01             	add    $0x1,%eax
 2d8:	89 04 24             	mov    %eax,(%esp)
 2db:	e8 a2 07 00 00       	call   a82 <thread_exit>

000002e0 <jointest2>:
    return 0;
}

    int
jointest2(void)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	56                   	push   %esi
 2e4:	53                   	push   %ebx
    thread_t threads[NUM_THREAD];
    int i;
    void *retval;

    for (i = 1; i <= NUM_THREAD; i++){
 2e5:	bb 01 00 00 00       	mov    $0x1,%ebx
    return 0;
}

    int
jointest2(void)
{
 2ea:	83 ec 40             	sub    $0x40,%esp
 2ed:	8d 75 d0             	lea    -0x30(%ebp),%esi
    thread_t threads[NUM_THREAD];
    int i;
    void *retval;

    for (i = 1; i <= NUM_THREAD; i++){
        if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
 2f0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 2f4:	c7 44 24 04 50 02 00 	movl   $0x250,0x4(%esp)
 2fb:	00 
 2fc:	89 34 24             	mov    %esi,(%esp)
 2ff:	e8 76 07 00 00       	call   a7a <thread_create>
 304:	85 c0                	test   %eax,%eax
 306:	75 78                	jne    380 <jointest2+0xa0>
{
    thread_t threads[NUM_THREAD];
    int i;
    void *retval;

    for (i = 1; i <= NUM_THREAD; i++){
 308:	83 c3 01             	add    $0x1,%ebx
 30b:	83 c6 04             	add    $0x4,%esi
 30e:	83 fb 0b             	cmp    $0xb,%ebx
 311:	75 dd                	jne    2f0 <jointest2+0x10>
        if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
            printf(1, "panic at thread_create\n");
            return -1;
        }
    }
    sleep(500);
 313:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
    printf(1, "thread_join!!!\n");
 31a:	b3 02                	mov    $0x2,%bl
        if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
            printf(1, "panic at thread_create\n");
            return -1;
        }
    }
    sleep(500);
 31c:	e8 29 07 00 00       	call   a4a <sleep>
 321:	8d 75 cc             	lea    -0x34(%ebp),%esi
    printf(1, "thread_join!!!\n");
 324:	c7 44 24 04 d1 0e 00 	movl   $0xed1,0x4(%esp)
 32b:	00 
 32c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 333:	e8 08 08 00 00       	call   b40 <printf>
    for (i = 1; i <= NUM_THREAD; i++){
        if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
 338:	8b 44 5d cc          	mov    -0x34(%ebp,%ebx,2),%eax
 33c:	89 74 24 04          	mov    %esi,0x4(%esp)
 340:	89 04 24             	mov    %eax,(%esp)
 343:	e8 42 07 00 00       	call   a8a <thread_join>
 348:	85 c0                	test   %eax,%eax
 34a:	75 54                	jne    3a0 <jointest2+0xc0>
 34c:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
 34f:	75 4f                	jne    3a0 <jointest2+0xc0>
 351:	83 c3 02             	add    $0x2,%ebx
            return -1;
        }
    }
    sleep(500);
    printf(1, "thread_join!!!\n");
    for (i = 1; i <= NUM_THREAD; i++){
 354:	83 fb 16             	cmp    $0x16,%ebx
 357:	75 df                	jne    338 <jointest2+0x58>
        if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
            printf(1, "panic at thread_join\n");
            return -1;
        }
    }
    printf(1,"\n");
 359:	c7 44 24 04 df 0e 00 	movl   $0xedf,0x4(%esp)
 360:	00 
 361:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 368:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 36b:	e8 d0 07 00 00       	call   b40 <printf>
 370:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    return 0;
}
 373:	83 c4 40             	add    $0x40,%esp
 376:	5b                   	pop    %ebx
 377:	5e                   	pop    %esi
 378:	5d                   	pop    %ebp
 379:	c3                   	ret    
 37a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    int i;
    void *retval;

    for (i = 1; i <= NUM_THREAD; i++){
        if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
            printf(1, "panic at thread_create\n");
 380:	c7 44 24 04 b9 0e 00 	movl   $0xeb9,0x4(%esp)
 387:	00 
 388:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 38f:	e8 ac 07 00 00       	call   b40 <printf>
            return -1;
        }
    }
    printf(1,"\n");
    return 0;
}
 394:	83 c4 40             	add    $0x40,%esp
    void *retval;

    for (i = 1; i <= NUM_THREAD; i++){
        if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
            printf(1, "panic at thread_create\n");
            return -1;
 397:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
            return -1;
        }
    }
    printf(1,"\n");
    return 0;
}
 39c:	5b                   	pop    %ebx
 39d:	5e                   	pop    %esi
 39e:	5d                   	pop    %ebp
 39f:	c3                   	ret    
    }
    sleep(500);
    printf(1, "thread_join!!!\n");
    for (i = 1; i <= NUM_THREAD; i++){
        if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
            printf(1, "panic at thread_join\n");
 3a0:	c7 44 24 04 e1 0e 00 	movl   $0xee1,0x4(%esp)
 3a7:	00 
 3a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3af:	e8 8c 07 00 00       	call   b40 <printf>
            return -1;
        }
    }
    printf(1,"\n");
    return 0;
}
 3b4:	83 c4 40             	add    $0x40,%esp
    sleep(500);
    printf(1, "thread_join!!!\n");
    for (i = 1; i <= NUM_THREAD; i++){
        if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
            printf(1, "panic at thread_join\n");
            return -1;
 3b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        }
    }
    printf(1,"\n");
    return 0;
}
 3bc:	5b                   	pop    %ebx
 3bd:	5e                   	pop    %esi
 3be:	5d                   	pop    %ebp
 3bf:	c3                   	ret    

000003c0 <racingtest>:
    thread_exit((void *)(tid+1));
}

    int
racingtest(void)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	56                   	push   %esi
 3c4:	53                   	push   %ebx
    thread_t threads[NUM_THREAD];
    int i;
    void *retval;
    gcnt = 0;

    for (i = 0; i < NUM_THREAD; i++){
 3c5:	31 db                	xor    %ebx,%ebx
    thread_exit((void *)(tid+1));
}

    int
racingtest(void)
{
 3c7:	83 ec 40             	sub    $0x40,%esp
 3ca:	8d 75 d0             	lea    -0x30(%ebp),%esi
    thread_t threads[NUM_THREAD];
    int i;
    void *retval;
    gcnt = 0;
 3cd:	c7 05 00 14 00 00 00 	movl   $0x0,0x1400
 3d4:	00 00 00 
 3d7:	90                   	nop

    for (i = 0; i < NUM_THREAD; i++){
        if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
 3d8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 3dc:	c7 44 24 04 b0 02 00 	movl   $0x2b0,0x4(%esp)
 3e3:	00 
 3e4:	89 34 24             	mov    %esi,(%esp)
 3e7:	e8 8e 06 00 00       	call   a7a <thread_create>
 3ec:	85 c0                	test   %eax,%eax
 3ee:	75 68                	jne    458 <racingtest+0x98>
    thread_t threads[NUM_THREAD];
    int i;
    void *retval;
    gcnt = 0;

    for (i = 0; i < NUM_THREAD; i++){
 3f0:	83 c3 01             	add    $0x1,%ebx
 3f3:	83 c6 04             	add    $0x4,%esi
 3f6:	83 fb 0a             	cmp    $0xa,%ebx
 3f9:	75 dd                	jne    3d8 <racingtest+0x18>
 3fb:	30 db                	xor    %bl,%bl
 3fd:	8d 75 cc             	lea    -0x34(%ebp),%esi
 400:	eb 08                	jmp    40a <racingtest+0x4a>
 402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
            printf(1, "panic at thread_create\n");
            return -1;
        }
    }
    for (i = 0; i < NUM_THREAD; i++){
 408:	89 d3                	mov    %edx,%ebx
        if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
 40a:	8b 44 9d d0          	mov    -0x30(%ebp,%ebx,4),%eax
 40e:	89 74 24 04          	mov    %esi,0x4(%esp)
 412:	89 04 24             	mov    %eax,(%esp)
 415:	e8 70 06 00 00       	call   a8a <thread_join>
 41a:	85 c0                	test   %eax,%eax
 41c:	75 5a                	jne    478 <racingtest+0xb8>
 41e:	8b 55 cc             	mov    -0x34(%ebp),%edx
 421:	83 c3 01             	add    $0x1,%ebx
 424:	39 da                	cmp    %ebx,%edx
 426:	75 50                	jne    478 <racingtest+0xb8>
        if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
            printf(1, "panic at thread_create\n");
            return -1;
        }
    }
    for (i = 0; i < NUM_THREAD; i++){
 428:	83 fa 0a             	cmp    $0xa,%edx
 42b:	75 db                	jne    408 <racingtest+0x48>
        if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
            printf(1, "panic at thread_join\n");
            return -1;
        }
    }
    printf(1,"%d\n", gcnt);
 42d:	8b 15 00 14 00 00    	mov    0x1400,%edx
 433:	c7 44 24 04 f7 0e 00 	movl   $0xef7,0x4(%esp)
 43a:	00 
 43b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 442:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 445:	89 54 24 08          	mov    %edx,0x8(%esp)
 449:	e8 f2 06 00 00       	call   b40 <printf>
 44e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    return 0;
}
 451:	83 c4 40             	add    $0x40,%esp
 454:	5b                   	pop    %ebx
 455:	5e                   	pop    %esi
 456:	5d                   	pop    %ebp
 457:	c3                   	ret    
    void *retval;
    gcnt = 0;

    for (i = 0; i < NUM_THREAD; i++){
        if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
            printf(1, "panic at thread_create\n");
 458:	c7 44 24 04 b9 0e 00 	movl   $0xeb9,0x4(%esp)
 45f:	00 
 460:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 467:	e8 d4 06 00 00       	call   b40 <printf>
            return -1;
        }
    }
    printf(1,"%d\n", gcnt);
    return 0;
}
 46c:	83 c4 40             	add    $0x40,%esp
    gcnt = 0;

    for (i = 0; i < NUM_THREAD; i++){
        if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
            printf(1, "panic at thread_create\n");
            return -1;
 46f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
            return -1;
        }
    }
    printf(1,"%d\n", gcnt);
    return 0;
}
 474:	5b                   	pop    %ebx
 475:	5e                   	pop    %esi
 476:	5d                   	pop    %ebp
 477:	c3                   	ret    
            return -1;
        }
    }
    for (i = 0; i < NUM_THREAD; i++){
        if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
            printf(1, "panic at thread_join\n");
 478:	c7 44 24 04 e1 0e 00 	movl   $0xee1,0x4(%esp)
 47f:	00 
 480:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 487:	e8 b4 06 00 00       	call   b40 <printf>
            return -1;
        }
    }
    printf(1,"%d\n", gcnt);
    return 0;
}
 48c:	83 c4 40             	add    $0x40,%esp
            return -1;
        }
    }
    for (i = 0; i < NUM_THREAD; i++){
        if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
            printf(1, "panic at thread_join\n");
 48f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
            return -1;
        }
    }
    printf(1,"%d\n", gcnt);
    return 0;
}
 494:	5b                   	pop    %ebx
 495:	5e                   	pop    %esi
 496:	5d                   	pop    %ebp
 497:	c3                   	ret    
 498:	90                   	nop
 499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000004a0 <basictest>:
    thread_exit((void *)(tid+1));
}

    int
basictest(void)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	56                   	push   %esi
 4a4:	53                   	push   %ebx
    thread_t threads[NUM_THREAD];
    int i;
    void *retval;

    for (i = 0; i < NUM_THREAD; i++){
 4a5:	31 db                	xor    %ebx,%ebx
    thread_exit((void *)(tid+1));
}

    int
basictest(void)
{
 4a7:	83 ec 40             	sub    $0x40,%esp
 4aa:	8d 75 d0             	lea    -0x30(%ebp),%esi
 4ad:	8d 76 00             	lea    0x0(%esi),%esi
    thread_t threads[NUM_THREAD];
    int i;
    void *retval;

    for (i = 0; i < NUM_THREAD; i++){
        if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
 4b0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 4b4:	c7 44 24 04 e0 01 00 	movl   $0x1e0,0x4(%esp)
 4bb:	00 
 4bc:	89 34 24             	mov    %esi,(%esp)
 4bf:	e8 b6 05 00 00       	call   a7a <thread_create>
 4c4:	85 c0                	test   %eax,%eax
 4c6:	75 60                	jne    528 <basictest+0x88>
{
    thread_t threads[NUM_THREAD];
    int i;
    void *retval;

    for (i = 0; i < NUM_THREAD; i++){
 4c8:	83 c3 01             	add    $0x1,%ebx
 4cb:	83 c6 04             	add    $0x4,%esi
 4ce:	83 fb 0a             	cmp    $0xa,%ebx
 4d1:	75 dd                	jne    4b0 <basictest+0x10>
 4d3:	30 db                	xor    %bl,%bl
 4d5:	8d 75 cc             	lea    -0x34(%ebp),%esi
 4d8:	eb 08                	jmp    4e2 <basictest+0x42>
 4da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
            printf(1, "panic at thread_create\n");
            return -1;
        }
    }
    for (i = 0; i < NUM_THREAD; i++){
 4e0:	89 d3                	mov    %edx,%ebx
        if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
 4e2:	8b 44 9d d0          	mov    -0x30(%ebp,%ebx,4),%eax
 4e6:	89 74 24 04          	mov    %esi,0x4(%esp)
 4ea:	89 04 24             	mov    %eax,(%esp)
 4ed:	e8 98 05 00 00       	call   a8a <thread_join>
 4f2:	85 c0                	test   %eax,%eax
 4f4:	75 52                	jne    548 <basictest+0xa8>
 4f6:	8b 55 cc             	mov    -0x34(%ebp),%edx
 4f9:	83 c3 01             	add    $0x1,%ebx
 4fc:	39 da                	cmp    %ebx,%edx
 4fe:	75 48                	jne    548 <basictest+0xa8>
        if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
            printf(1, "panic at thread_create\n");
            return -1;
        }
    }
    for (i = 0; i < NUM_THREAD; i++){
 500:	83 fa 0a             	cmp    $0xa,%edx
 503:	75 db                	jne    4e0 <basictest+0x40>
        if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
            printf(1, "panic at thread_join\n");
            return -1;
        }
    }
    printf(1,"\n");
 505:	c7 44 24 04 df 0e 00 	movl   $0xedf,0x4(%esp)
 50c:	00 
 50d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 514:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 517:	e8 24 06 00 00       	call   b40 <printf>
 51c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    return 0;
}
 51f:	83 c4 40             	add    $0x40,%esp
 522:	5b                   	pop    %ebx
 523:	5e                   	pop    %esi
 524:	5d                   	pop    %ebp
 525:	c3                   	ret    
 526:	66 90                	xchg   %ax,%ax
    int i;
    void *retval;

    for (i = 0; i < NUM_THREAD; i++){
        if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
            printf(1, "panic at thread_create\n");
 528:	c7 44 24 04 b9 0e 00 	movl   $0xeb9,0x4(%esp)
 52f:	00 
 530:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 537:	e8 04 06 00 00       	call   b40 <printf>
            return -1;
        }
    }
    printf(1,"\n");
    return 0;
}
 53c:	83 c4 40             	add    $0x40,%esp
    void *retval;

    for (i = 0; i < NUM_THREAD; i++){
        if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
            printf(1, "panic at thread_create\n");
            return -1;
 53f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
            return -1;
        }
    }
    printf(1,"\n");
    return 0;
}
 544:	5b                   	pop    %ebx
 545:	5e                   	pop    %esi
 546:	5d                   	pop    %ebp
 547:	c3                   	ret    
            return -1;
        }
    }
    for (i = 0; i < NUM_THREAD; i++){
        if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
            printf(1, "panic at thread_join\n");
 548:	c7 44 24 04 e1 0e 00 	movl   $0xee1,0x4(%esp)
 54f:	00 
 550:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 557:	e8 e4 05 00 00       	call   b40 <printf>
            return -1;
        }
    }
    printf(1,"\n");
    return 0;
}
 55c:	83 c4 40             	add    $0x40,%esp
            return -1;
        }
    }
    for (i = 0; i < NUM_THREAD; i++){
        if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
            printf(1, "panic at thread_join\n");
 55f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
            return -1;
        }
    }
    printf(1,"\n");
    return 0;
}
 564:	5b                   	pop    %ebx
 565:	5e                   	pop    %esi
 566:	5d                   	pop    %ebp
 567:	c3                   	ret    
 568:	90                   	nop
 569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000570 <jointest1>:
    thread_exit((void *)(val*2));
}

    int
jointest1(void)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	56                   	push   %esi
 574:	53                   	push   %ebx
    thread_t threads[NUM_THREAD];
    int i;
    void *retval;

    for (i = 1; i <= NUM_THREAD; i++){
 575:	bb 01 00 00 00       	mov    $0x1,%ebx
    thread_exit((void *)(val*2));
}

    int
jointest1(void)
{
 57a:	83 ec 40             	sub    $0x40,%esp
 57d:	8d 75 d0             	lea    -0x30(%ebp),%esi
    thread_t threads[NUM_THREAD];
    int i;
    void *retval;

    for (i = 1; i <= NUM_THREAD; i++){
        if (thread_create(&threads[i-1], jointhreadmain, (void*)i) != 0){
 580:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 584:	c7 44 24 04 50 02 00 	movl   $0x250,0x4(%esp)
 58b:	00 
 58c:	89 34 24             	mov    %esi,(%esp)
 58f:	e8 e6 04 00 00       	call   a7a <thread_create>
 594:	85 c0                	test   %eax,%eax
 596:	75 70                	jne    608 <jointest1+0x98>
{
    thread_t threads[NUM_THREAD];
    int i;
    void *retval;

    for (i = 1; i <= NUM_THREAD; i++){
 598:	83 c3 01             	add    $0x1,%ebx
 59b:	83 c6 04             	add    $0x4,%esi
 59e:	83 fb 0b             	cmp    $0xb,%ebx
 5a1:	75 dd                	jne    580 <jointest1+0x10>
        if (thread_create(&threads[i-1], jointhreadmain, (void*)i) != 0){
            printf(1, "panic at thread_create\n");
            return -1;
        }
    }
    printf(1, "thread_join!!!\n");
 5a3:	c7 44 24 04 d1 0e 00 	movl   $0xed1,0x4(%esp)
 5aa:	00 
 5ab:	b3 02                	mov    $0x2,%bl
 5ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5b4:	8d 75 cc             	lea    -0x34(%ebp),%esi
 5b7:	e8 84 05 00 00       	call   b40 <printf>
 5bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (i = 1; i <= NUM_THREAD; i++){
        if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
 5c0:	8b 44 5d cc          	mov    -0x34(%ebp,%ebx,2),%eax
 5c4:	89 74 24 04          	mov    %esi,0x4(%esp)
 5c8:	89 04 24             	mov    %eax,(%esp)
 5cb:	e8 ba 04 00 00       	call   a8a <thread_join>
 5d0:	85 c0                	test   %eax,%eax
 5d2:	75 54                	jne    628 <jointest1+0xb8>
 5d4:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
 5d7:	75 4f                	jne    628 <jointest1+0xb8>
 5d9:	83 c3 02             	add    $0x2,%ebx
            printf(1, "panic at thread_create\n");
            return -1;
        }
    }
    printf(1, "thread_join!!!\n");
    for (i = 1; i <= NUM_THREAD; i++){
 5dc:	83 fb 16             	cmp    $0x16,%ebx
 5df:	75 df                	jne    5c0 <jointest1+0x50>
        if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
            printf(1, "panic at thread_join\n");
            return -1;
        }
    }
    printf(1,"\n");
 5e1:	c7 44 24 04 df 0e 00 	movl   $0xedf,0x4(%esp)
 5e8:	00 
 5e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5f0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 5f3:	e8 48 05 00 00       	call   b40 <printf>
 5f8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    return 0;
}
 5fb:	83 c4 40             	add    $0x40,%esp
 5fe:	5b                   	pop    %ebx
 5ff:	5e                   	pop    %esi
 600:	5d                   	pop    %ebp
 601:	c3                   	ret    
 602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    int i;
    void *retval;

    for (i = 1; i <= NUM_THREAD; i++){
        if (thread_create(&threads[i-1], jointhreadmain, (void*)i) != 0){
            printf(1, "panic at thread_create\n");
 608:	c7 44 24 04 b9 0e 00 	movl   $0xeb9,0x4(%esp)
 60f:	00 
 610:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 617:	e8 24 05 00 00       	call   b40 <printf>
            return -1;
        }
    }
    printf(1,"\n");
    return 0;
}
 61c:	83 c4 40             	add    $0x40,%esp
    void *retval;

    for (i = 1; i <= NUM_THREAD; i++){
        if (thread_create(&threads[i-1], jointhreadmain, (void*)i) != 0){
            printf(1, "panic at thread_create\n");
            return -1;
 61f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
            return -1;
        }
    }
    printf(1,"\n");
    return 0;
}
 624:	5b                   	pop    %ebx
 625:	5e                   	pop    %esi
 626:	5d                   	pop    %ebp
 627:	c3                   	ret    
        }
    }
    printf(1, "thread_join!!!\n");
    for (i = 1; i <= NUM_THREAD; i++){
        if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
            printf(1, "panic at thread_join\n");
 628:	c7 44 24 04 e1 0e 00 	movl   $0xee1,0x4(%esp)
 62f:	00 
 630:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 637:	e8 04 05 00 00       	call   b40 <printf>
            return -1;
        }
    }
    printf(1,"\n");
    return 0;
}
 63c:	83 c4 40             	add    $0x40,%esp
        }
    }
    printf(1, "thread_join!!!\n");
    for (i = 1; i <= NUM_THREAD; i++){
        if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
            printf(1, "panic at thread_join\n");
 63f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
            return -1;
        }
    }
    printf(1,"\n");
    return 0;
}
 644:	5b                   	pop    %ebx
 645:	5e                   	pop    %esi
 646:	5d                   	pop    %ebp
 647:	c3                   	ret    
 648:	90                   	nop
 649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000650 <stresstest>:
    thread_exit(0);
}

    int
stresstest(void)
{
 650:	55                   	push   %ebp
 651:	89 e5                	mov    %esp,%ebp
 653:	57                   	push   %edi
 654:	56                   	push   %esi
 655:	53                   	push   %ebx
 656:	83 ec 4c             	sub    $0x4c,%esp
 659:	8d 5d bc             	lea    -0x44(%ebp),%ebx
    const int nstress = 35000;
    thread_t threads[NUM_THREAD];
    int i, n;
    void *retval;

    for (n = 1; n <= nstress; n++){
 65c:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
 663:	8d 75 c0             	lea    -0x40(%ebp),%esi
 666:	31 ff                	xor    %edi,%edi
        if (n % 1000 == 0)
            printf(1, "%d\n", n);
        for (i = 0; i < NUM_THREAD; i++){
            if (thread_create(&threads[i], stressthreadmain, (void*)i) != 0){
 668:	89 7c 24 08          	mov    %edi,0x8(%esp)
 66c:	c7 44 24 04 90 02 00 	movl   $0x290,0x4(%esp)
 673:	00 
 674:	89 34 24             	mov    %esi,(%esp)
 677:	e8 fe 03 00 00       	call   a7a <thread_create>
 67c:	85 c0                	test   %eax,%eax
 67e:	0f 85 8c 00 00 00    	jne    710 <stresstest+0xc0>
    void *retval;

    for (n = 1; n <= nstress; n++){
        if (n % 1000 == 0)
            printf(1, "%d\n", n);
        for (i = 0; i < NUM_THREAD; i++){
 684:	83 c7 01             	add    $0x1,%edi
 687:	83 c6 04             	add    $0x4,%esi
 68a:	83 ff 0a             	cmp    $0xa,%edi
 68d:	75 d9                	jne    668 <stresstest+0x18>
 68f:	8d 7d c0             	lea    -0x40(%ebp),%edi
 692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                printf(1, "panic at thread_create\n");
                return -1;
            }
        }
        for (i = 0; i < NUM_THREAD; i++){
            if (thread_join(threads[i], &retval) != 0){
 698:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 69c:	8b 07                	mov    (%edi),%eax
 69e:	89 04 24             	mov    %eax,(%esp)
 6a1:	e8 e4 03 00 00       	call   a8a <thread_join>
 6a6:	85 c0                	test   %eax,%eax
 6a8:	0f 85 8a 00 00 00    	jne    738 <stresstest+0xe8>
 6ae:	83 c7 04             	add    $0x4,%edi
            if (thread_create(&threads[i], stressthreadmain, (void*)i) != 0){
                printf(1, "panic at thread_create\n");
                return -1;
            }
        }
        for (i = 0; i < NUM_THREAD; i++){
 6b1:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 6b4:	39 cf                	cmp    %ecx,%edi
 6b6:	75 e0                	jne    698 <stresstest+0x48>
    const int nstress = 35000;
    thread_t threads[NUM_THREAD];
    int i, n;
    void *retval;

    for (n = 1; n <= nstress; n++){
 6b8:	83 45 b4 01          	addl   $0x1,-0x4c(%ebp)
 6bc:	81 7d b4 b9 88 00 00 	cmpl   $0x88b9,-0x4c(%ebp)
 6c3:	0f 84 90 00 00 00    	je     759 <stresstest+0x109>
        if (n % 1000 == 0)
 6c9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 6cc:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 6d1:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
 6d4:	f7 ea                	imul   %edx
 6d6:	89 c8                	mov    %ecx,%eax
 6d8:	c1 f8 1f             	sar    $0x1f,%eax
 6db:	c1 fa 06             	sar    $0x6,%edx
 6de:	29 c2                	sub    %eax,%edx
 6e0:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
 6e6:	39 d1                	cmp    %edx,%ecx
 6e8:	0f 85 75 ff ff ff    	jne    663 <stresstest+0x13>
            printf(1, "%d\n", n);
 6ee:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 6f2:	c7 44 24 04 f7 0e 00 	movl   $0xef7,0x4(%esp)
 6f9:	00 
 6fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 701:	e8 3a 04 00 00       	call   b40 <printf>
 706:	e9 58 ff ff ff       	jmp    663 <stresstest+0x13>
 70b:	90                   	nop
 70c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        for (i = 0; i < NUM_THREAD; i++){
            if (thread_create(&threads[i], stressthreadmain, (void*)i) != 0){
                printf(1, "panic at thread_create\n");
 710:	c7 44 24 04 b9 0e 00 	movl   $0xeb9,0x4(%esp)
 717:	00 
 718:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 71f:	e8 1c 04 00 00       	call   b40 <printf>
                return -1;
 724:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
            }
        }
    }
    printf(1, "\n");
    return 0;
}
 729:	83 c4 4c             	add    $0x4c,%esp
 72c:	5b                   	pop    %ebx
 72d:	5e                   	pop    %esi
 72e:	5f                   	pop    %edi
 72f:	5d                   	pop    %ebp
 730:	c3                   	ret    
 731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                return -1;
            }
        }
        for (i = 0; i < NUM_THREAD; i++){
            if (thread_join(threads[i], &retval) != 0){
                printf(1, "panic at thread_join\n");
 738:	c7 44 24 04 e1 0e 00 	movl   $0xee1,0x4(%esp)
 73f:	00 
 740:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 747:	e8 f4 03 00 00       	call   b40 <printf>
            }
        }
    }
    printf(1, "\n");
    return 0;
}
 74c:	83 c4 4c             	add    $0x4c,%esp
            }
        }
        for (i = 0; i < NUM_THREAD; i++){
            if (thread_join(threads[i], &retval) != 0){
                printf(1, "panic at thread_join\n");
                return -1;
 74f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
            }
        }
    }
    printf(1, "\n");
    return 0;
}
 754:	5b                   	pop    %ebx
 755:	5e                   	pop    %esi
 756:	5f                   	pop    %edi
 757:	5d                   	pop    %ebp
 758:	c3                   	ret    
                printf(1, "panic at thread_join\n");
                return -1;
            }
        }
    }
    printf(1, "\n");
 759:	c7 44 24 04 df 0e 00 	movl   $0xedf,0x4(%esp)
 760:	00 
 761:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 768:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 76b:	e8 d0 03 00 00       	call   b40 <printf>
 770:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 773:	eb b4                	jmp    729 <stresstest+0xd9>
 775:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000780 <nop>:
    }
    exit();
}

// ============================================================================
void nop(){ 
 780:	55                   	push   %ebp
 781:	89 e5                	mov    %esp,%ebp
    //sleep(1);
}
 783:	5d                   	pop    %ebp
 784:	c3                   	ret    
 785:	66 90                	xchg   %ax,%ax
 787:	66 90                	xchg   %ax,%ax
 789:	66 90                	xchg   %ax,%ax
 78b:	66 90                	xchg   %ax,%ax
 78d:	66 90                	xchg   %ax,%ax
 78f:	90                   	nop

00000790 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	8b 45 08             	mov    0x8(%ebp),%eax
 796:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 799:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 79a:	89 c2                	mov    %eax,%edx
 79c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7a0:	83 c1 01             	add    $0x1,%ecx
 7a3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 7a7:	83 c2 01             	add    $0x1,%edx
 7aa:	84 db                	test   %bl,%bl
 7ac:	88 5a ff             	mov    %bl,-0x1(%edx)
 7af:	75 ef                	jne    7a0 <strcpy+0x10>
    ;
  return os;
}
 7b1:	5b                   	pop    %ebx
 7b2:	5d                   	pop    %ebp
 7b3:	c3                   	ret    
 7b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 7ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000007c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 7c0:	55                   	push   %ebp
 7c1:	89 e5                	mov    %esp,%ebp
 7c3:	8b 55 08             	mov    0x8(%ebp),%edx
 7c6:	53                   	push   %ebx
 7c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 7ca:	0f b6 02             	movzbl (%edx),%eax
 7cd:	84 c0                	test   %al,%al
 7cf:	74 2d                	je     7fe <strcmp+0x3e>
 7d1:	0f b6 19             	movzbl (%ecx),%ebx
 7d4:	38 d8                	cmp    %bl,%al
 7d6:	74 0e                	je     7e6 <strcmp+0x26>
 7d8:	eb 2b                	jmp    805 <strcmp+0x45>
 7da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 7e0:	38 c8                	cmp    %cl,%al
 7e2:	75 15                	jne    7f9 <strcmp+0x39>
    p++, q++;
 7e4:	89 d9                	mov    %ebx,%ecx
 7e6:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 7e9:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 7ec:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 7ef:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 7f3:	84 c0                	test   %al,%al
 7f5:	75 e9                	jne    7e0 <strcmp+0x20>
 7f7:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 7f9:	29 c8                	sub    %ecx,%eax
}
 7fb:	5b                   	pop    %ebx
 7fc:	5d                   	pop    %ebp
 7fd:	c3                   	ret    
 7fe:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 801:	31 c0                	xor    %eax,%eax
 803:	eb f4                	jmp    7f9 <strcmp+0x39>
 805:	0f b6 cb             	movzbl %bl,%ecx
 808:	eb ef                	jmp    7f9 <strcmp+0x39>
 80a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000810 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 810:	55                   	push   %ebp
 811:	89 e5                	mov    %esp,%ebp
 813:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 816:	80 39 00             	cmpb   $0x0,(%ecx)
 819:	74 12                	je     82d <strlen+0x1d>
 81b:	31 d2                	xor    %edx,%edx
 81d:	8d 76 00             	lea    0x0(%esi),%esi
 820:	83 c2 01             	add    $0x1,%edx
 823:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 827:	89 d0                	mov    %edx,%eax
 829:	75 f5                	jne    820 <strlen+0x10>
    ;
  return n;
}
 82b:	5d                   	pop    %ebp
 82c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 82d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 82f:	5d                   	pop    %ebp
 830:	c3                   	ret    
 831:	eb 0d                	jmp    840 <memset>
 833:	90                   	nop
 834:	90                   	nop
 835:	90                   	nop
 836:	90                   	nop
 837:	90                   	nop
 838:	90                   	nop
 839:	90                   	nop
 83a:	90                   	nop
 83b:	90                   	nop
 83c:	90                   	nop
 83d:	90                   	nop
 83e:	90                   	nop
 83f:	90                   	nop

00000840 <memset>:

void*
memset(void *dst, int c, uint n)
{
 840:	55                   	push   %ebp
 841:	89 e5                	mov    %esp,%ebp
 843:	8b 55 08             	mov    0x8(%ebp),%edx
 846:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 847:	8b 4d 10             	mov    0x10(%ebp),%ecx
 84a:	8b 45 0c             	mov    0xc(%ebp),%eax
 84d:	89 d7                	mov    %edx,%edi
 84f:	fc                   	cld    
 850:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 852:	89 d0                	mov    %edx,%eax
 854:	5f                   	pop    %edi
 855:	5d                   	pop    %ebp
 856:	c3                   	ret    
 857:	89 f6                	mov    %esi,%esi
 859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000860 <strchr>:

char*
strchr(const char *s, char c)
{
 860:	55                   	push   %ebp
 861:	89 e5                	mov    %esp,%ebp
 863:	8b 45 08             	mov    0x8(%ebp),%eax
 866:	53                   	push   %ebx
 867:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 86a:	0f b6 18             	movzbl (%eax),%ebx
 86d:	84 db                	test   %bl,%bl
 86f:	74 1d                	je     88e <strchr+0x2e>
    if(*s == c)
 871:	38 d3                	cmp    %dl,%bl
 873:	89 d1                	mov    %edx,%ecx
 875:	75 0d                	jne    884 <strchr+0x24>
 877:	eb 17                	jmp    890 <strchr+0x30>
 879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 880:	38 ca                	cmp    %cl,%dl
 882:	74 0c                	je     890 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 884:	83 c0 01             	add    $0x1,%eax
 887:	0f b6 10             	movzbl (%eax),%edx
 88a:	84 d2                	test   %dl,%dl
 88c:	75 f2                	jne    880 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 88e:	31 c0                	xor    %eax,%eax
}
 890:	5b                   	pop    %ebx
 891:	5d                   	pop    %ebp
 892:	c3                   	ret    
 893:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000008a0 <gets>:

char*
gets(char *buf, int max)
{
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	57                   	push   %edi
 8a4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 8a5:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 8a7:	53                   	push   %ebx
 8a8:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 8ab:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 8ae:	eb 31                	jmp    8e1 <gets+0x41>
    cc = read(0, &c, 1);
 8b0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8b7:	00 
 8b8:	89 7c 24 04          	mov    %edi,0x4(%esp)
 8bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8c3:	e8 02 01 00 00       	call   9ca <read>
    if(cc < 1)
 8c8:	85 c0                	test   %eax,%eax
 8ca:	7e 1d                	jle    8e9 <gets+0x49>
      break;
    buf[i++] = c;
 8cc:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 8d0:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 8d2:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 8d5:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 8d7:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 8db:	74 0c                	je     8e9 <gets+0x49>
 8dd:	3c 0a                	cmp    $0xa,%al
 8df:	74 08                	je     8e9 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 8e1:	8d 5e 01             	lea    0x1(%esi),%ebx
 8e4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 8e7:	7c c7                	jl     8b0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 8e9:	8b 45 08             	mov    0x8(%ebp),%eax
 8ec:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 8f0:	83 c4 2c             	add    $0x2c,%esp
 8f3:	5b                   	pop    %ebx
 8f4:	5e                   	pop    %esi
 8f5:	5f                   	pop    %edi
 8f6:	5d                   	pop    %ebp
 8f7:	c3                   	ret    
 8f8:	90                   	nop
 8f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000900 <stat>:

int
stat(char *n, struct stat *st)
{
 900:	55                   	push   %ebp
 901:	89 e5                	mov    %esp,%ebp
 903:	56                   	push   %esi
 904:	53                   	push   %ebx
 905:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 908:	8b 45 08             	mov    0x8(%ebp),%eax
 90b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 912:	00 
 913:	89 04 24             	mov    %eax,(%esp)
 916:	e8 d7 00 00 00       	call   9f2 <open>
  if(fd < 0)
 91b:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 91d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 91f:	78 27                	js     948 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 921:	8b 45 0c             	mov    0xc(%ebp),%eax
 924:	89 1c 24             	mov    %ebx,(%esp)
 927:	89 44 24 04          	mov    %eax,0x4(%esp)
 92b:	e8 da 00 00 00       	call   a0a <fstat>
  close(fd);
 930:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 933:	89 c6                	mov    %eax,%esi
  close(fd);
 935:	e8 a0 00 00 00       	call   9da <close>
  return r;
 93a:	89 f0                	mov    %esi,%eax
}
 93c:	83 c4 10             	add    $0x10,%esp
 93f:	5b                   	pop    %ebx
 940:	5e                   	pop    %esi
 941:	5d                   	pop    %ebp
 942:	c3                   	ret    
 943:	90                   	nop
 944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 948:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 94d:	eb ed                	jmp    93c <stat+0x3c>
 94f:	90                   	nop

00000950 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 950:	55                   	push   %ebp
 951:	89 e5                	mov    %esp,%ebp
 953:	8b 4d 08             	mov    0x8(%ebp),%ecx
 956:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 957:	0f be 11             	movsbl (%ecx),%edx
 95a:	8d 42 d0             	lea    -0x30(%edx),%eax
 95d:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 95f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 964:	77 17                	ja     97d <atoi+0x2d>
 966:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 968:	83 c1 01             	add    $0x1,%ecx
 96b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 96e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 972:	0f be 11             	movsbl (%ecx),%edx
 975:	8d 5a d0             	lea    -0x30(%edx),%ebx
 978:	80 fb 09             	cmp    $0x9,%bl
 97b:	76 eb                	jbe    968 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 97d:	5b                   	pop    %ebx
 97e:	5d                   	pop    %ebp
 97f:	c3                   	ret    

00000980 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 980:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 981:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 983:	89 e5                	mov    %esp,%ebp
 985:	56                   	push   %esi
 986:	8b 45 08             	mov    0x8(%ebp),%eax
 989:	53                   	push   %ebx
 98a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 98d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 990:	85 db                	test   %ebx,%ebx
 992:	7e 12                	jle    9a6 <memmove+0x26>
 994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 998:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 99c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 99f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 9a2:	39 da                	cmp    %ebx,%edx
 9a4:	75 f2                	jne    998 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 9a6:	5b                   	pop    %ebx
 9a7:	5e                   	pop    %esi
 9a8:	5d                   	pop    %ebp
 9a9:	c3                   	ret    

000009aa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 9aa:	b8 01 00 00 00       	mov    $0x1,%eax
 9af:	cd 40                	int    $0x40
 9b1:	c3                   	ret    

000009b2 <exit>:
SYSCALL(exit)
 9b2:	b8 02 00 00 00       	mov    $0x2,%eax
 9b7:	cd 40                	int    $0x40
 9b9:	c3                   	ret    

000009ba <wait>:
SYSCALL(wait)
 9ba:	b8 03 00 00 00       	mov    $0x3,%eax
 9bf:	cd 40                	int    $0x40
 9c1:	c3                   	ret    

000009c2 <pipe>:
SYSCALL(pipe)
 9c2:	b8 04 00 00 00       	mov    $0x4,%eax
 9c7:	cd 40                	int    $0x40
 9c9:	c3                   	ret    

000009ca <read>:
SYSCALL(read)
 9ca:	b8 05 00 00 00       	mov    $0x5,%eax
 9cf:	cd 40                	int    $0x40
 9d1:	c3                   	ret    

000009d2 <write>:
SYSCALL(write)
 9d2:	b8 11 00 00 00       	mov    $0x11,%eax
 9d7:	cd 40                	int    $0x40
 9d9:	c3                   	ret    

000009da <close>:
SYSCALL(close)
 9da:	b8 16 00 00 00       	mov    $0x16,%eax
 9df:	cd 40                	int    $0x40
 9e1:	c3                   	ret    

000009e2 <kill>:
SYSCALL(kill)
 9e2:	b8 06 00 00 00       	mov    $0x6,%eax
 9e7:	cd 40                	int    $0x40
 9e9:	c3                   	ret    

000009ea <exec>:
SYSCALL(exec)
 9ea:	b8 07 00 00 00       	mov    $0x7,%eax
 9ef:	cd 40                	int    $0x40
 9f1:	c3                   	ret    

000009f2 <open>:
SYSCALL(open)
 9f2:	b8 10 00 00 00       	mov    $0x10,%eax
 9f7:	cd 40                	int    $0x40
 9f9:	c3                   	ret    

000009fa <mknod>:
SYSCALL(mknod)
 9fa:	b8 12 00 00 00       	mov    $0x12,%eax
 9ff:	cd 40                	int    $0x40
 a01:	c3                   	ret    

00000a02 <unlink>:
SYSCALL(unlink)
 a02:	b8 13 00 00 00       	mov    $0x13,%eax
 a07:	cd 40                	int    $0x40
 a09:	c3                   	ret    

00000a0a <fstat>:
SYSCALL(fstat)
 a0a:	b8 08 00 00 00       	mov    $0x8,%eax
 a0f:	cd 40                	int    $0x40
 a11:	c3                   	ret    

00000a12 <link>:
SYSCALL(link)
 a12:	b8 14 00 00 00       	mov    $0x14,%eax
 a17:	cd 40                	int    $0x40
 a19:	c3                   	ret    

00000a1a <mkdir>:
SYSCALL(mkdir)
 a1a:	b8 15 00 00 00       	mov    $0x15,%eax
 a1f:	cd 40                	int    $0x40
 a21:	c3                   	ret    

00000a22 <chdir>:
SYSCALL(chdir)
 a22:	b8 09 00 00 00       	mov    $0x9,%eax
 a27:	cd 40                	int    $0x40
 a29:	c3                   	ret    

00000a2a <dup>:
SYSCALL(dup)
 a2a:	b8 0a 00 00 00       	mov    $0xa,%eax
 a2f:	cd 40                	int    $0x40
 a31:	c3                   	ret    

00000a32 <getpid>:
SYSCALL(getpid)
 a32:	b8 0b 00 00 00       	mov    $0xb,%eax
 a37:	cd 40                	int    $0x40
 a39:	c3                   	ret    

00000a3a <getppid>:
SYSCALL(getppid)
 a3a:	b8 0c 00 00 00       	mov    $0xc,%eax
 a3f:	cd 40                	int    $0x40
 a41:	c3                   	ret    

00000a42 <sbrk>:
SYSCALL(sbrk)
 a42:	b8 0d 00 00 00       	mov    $0xd,%eax
 a47:	cd 40                	int    $0x40
 a49:	c3                   	ret    

00000a4a <sleep>:
SYSCALL(sleep)
 a4a:	b8 0e 00 00 00       	mov    $0xe,%eax
 a4f:	cd 40                	int    $0x40
 a51:	c3                   	ret    

00000a52 <uptime>:
SYSCALL(uptime)
 a52:	b8 0f 00 00 00       	mov    $0xf,%eax
 a57:	cd 40                	int    $0x40
 a59:	c3                   	ret    

00000a5a <my_syscall>:
SYSCALL(my_syscall)
 a5a:	b8 17 00 00 00       	mov    $0x17,%eax
 a5f:	cd 40                	int    $0x40
 a61:	c3                   	ret    

00000a62 <yield>:
SYSCALL(yield)
 a62:	b8 18 00 00 00       	mov    $0x18,%eax
 a67:	cd 40                	int    $0x40
 a69:	c3                   	ret    

00000a6a <getlev>:
SYSCALL(getlev)
 a6a:	b8 19 00 00 00       	mov    $0x19,%eax
 a6f:	cd 40                	int    $0x40
 a71:	c3                   	ret    

00000a72 <set_cpu_share>:
SYSCALL(set_cpu_share)
 a72:	b8 1a 00 00 00       	mov    $0x1a,%eax
 a77:	cd 40                	int    $0x40
 a79:	c3                   	ret    

00000a7a <thread_create>:
SYSCALL(thread_create)
 a7a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 a7f:	cd 40                	int    $0x40
 a81:	c3                   	ret    

00000a82 <thread_exit>:
SYSCALL(thread_exit)
 a82:	b8 1c 00 00 00       	mov    $0x1c,%eax
 a87:	cd 40                	int    $0x40
 a89:	c3                   	ret    

00000a8a <thread_join>:
SYSCALL(thread_join)
 a8a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 a8f:	cd 40                	int    $0x40
 a91:	c3                   	ret    
 a92:	66 90                	xchg   %ax,%ax
 a94:	66 90                	xchg   %ax,%ax
 a96:	66 90                	xchg   %ax,%ax
 a98:	66 90                	xchg   %ax,%ax
 a9a:	66 90                	xchg   %ax,%ax
 a9c:	66 90                	xchg   %ax,%ax
 a9e:	66 90                	xchg   %ax,%ax

00000aa0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 aa0:	55                   	push   %ebp
 aa1:	89 e5                	mov    %esp,%ebp
 aa3:	57                   	push   %edi
 aa4:	56                   	push   %esi
 aa5:	89 c6                	mov    %eax,%esi
 aa7:	53                   	push   %ebx
 aa8:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 aab:	8b 5d 08             	mov    0x8(%ebp),%ebx
 aae:	85 db                	test   %ebx,%ebx
 ab0:	74 09                	je     abb <printint+0x1b>
 ab2:	89 d0                	mov    %edx,%eax
 ab4:	c1 e8 1f             	shr    $0x1f,%eax
 ab7:	84 c0                	test   %al,%al
 ab9:	75 75                	jne    b30 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 abb:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 abd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 ac4:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 ac7:	31 ff                	xor    %edi,%edi
 ac9:	89 ce                	mov    %ecx,%esi
 acb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 ace:	eb 02                	jmp    ad2 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 ad0:	89 cf                	mov    %ecx,%edi
 ad2:	31 d2                	xor    %edx,%edx
 ad4:	f7 f6                	div    %esi
 ad6:	8d 4f 01             	lea    0x1(%edi),%ecx
 ad9:	0f b6 92 79 0f 00 00 	movzbl 0xf79(%edx),%edx
  }while((x /= base) != 0);
 ae0:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 ae2:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 ae5:	75 e9                	jne    ad0 <printint+0x30>
  if(neg)
 ae7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 aea:	89 c8                	mov    %ecx,%eax
 aec:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 aef:	85 d2                	test   %edx,%edx
 af1:	74 08                	je     afb <printint+0x5b>
    buf[i++] = '-';
 af3:	8d 4f 02             	lea    0x2(%edi),%ecx
 af6:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 afb:	8d 79 ff             	lea    -0x1(%ecx),%edi
 afe:	66 90                	xchg   %ax,%ax
 b00:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 b05:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 b08:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 b0f:	00 
 b10:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 b14:	89 34 24             	mov    %esi,(%esp)
 b17:	88 45 d7             	mov    %al,-0x29(%ebp)
 b1a:	e8 b3 fe ff ff       	call   9d2 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 b1f:	83 ff ff             	cmp    $0xffffffff,%edi
 b22:	75 dc                	jne    b00 <printint+0x60>
    putc(fd, buf[i]);
}
 b24:	83 c4 4c             	add    $0x4c,%esp
 b27:	5b                   	pop    %ebx
 b28:	5e                   	pop    %esi
 b29:	5f                   	pop    %edi
 b2a:	5d                   	pop    %ebp
 b2b:	c3                   	ret    
 b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 b30:	89 d0                	mov    %edx,%eax
 b32:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 b34:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 b3b:	eb 87                	jmp    ac4 <printint+0x24>
 b3d:	8d 76 00             	lea    0x0(%esi),%esi

00000b40 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 b40:	55                   	push   %ebp
 b41:	89 e5                	mov    %esp,%ebp
 b43:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 b44:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 b46:	56                   	push   %esi
 b47:	53                   	push   %ebx
 b48:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 b4b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 b4e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 b51:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 b54:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 b57:	0f b6 13             	movzbl (%ebx),%edx
 b5a:	83 c3 01             	add    $0x1,%ebx
 b5d:	84 d2                	test   %dl,%dl
 b5f:	75 39                	jne    b9a <printf+0x5a>
 b61:	e9 c2 00 00 00       	jmp    c28 <printf+0xe8>
 b66:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 b68:	83 fa 25             	cmp    $0x25,%edx
 b6b:	0f 84 bf 00 00 00    	je     c30 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 b71:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 b74:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 b7b:	00 
 b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
 b80:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 b83:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 b86:	e8 47 fe ff ff       	call   9d2 <write>
 b8b:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 b8e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 b92:	84 d2                	test   %dl,%dl
 b94:	0f 84 8e 00 00 00    	je     c28 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 b9a:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 b9c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 b9f:	74 c7                	je     b68 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 ba1:	83 ff 25             	cmp    $0x25,%edi
 ba4:	75 e5                	jne    b8b <printf+0x4b>
      if(c == 'd'){
 ba6:	83 fa 64             	cmp    $0x64,%edx
 ba9:	0f 84 31 01 00 00    	je     ce0 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 baf:	25 f7 00 00 00       	and    $0xf7,%eax
 bb4:	83 f8 70             	cmp    $0x70,%eax
 bb7:	0f 84 83 00 00 00    	je     c40 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 bbd:	83 fa 73             	cmp    $0x73,%edx
 bc0:	0f 84 a2 00 00 00    	je     c68 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 bc6:	83 fa 63             	cmp    $0x63,%edx
 bc9:	0f 84 35 01 00 00    	je     d04 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 bcf:	83 fa 25             	cmp    $0x25,%edx
 bd2:	0f 84 e0 00 00 00    	je     cb8 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 bd8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 bdb:	83 c3 01             	add    $0x1,%ebx
 bde:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 be5:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 be6:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 be8:	89 44 24 04          	mov    %eax,0x4(%esp)
 bec:	89 34 24             	mov    %esi,(%esp)
 bef:	89 55 d0             	mov    %edx,-0x30(%ebp)
 bf2:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 bf6:	e8 d7 fd ff ff       	call   9d2 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 bfb:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 bfe:	8d 45 e7             	lea    -0x19(%ebp),%eax
 c01:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 c08:	00 
 c09:	89 44 24 04          	mov    %eax,0x4(%esp)
 c0d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 c10:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 c13:	e8 ba fd ff ff       	call   9d2 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 c18:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 c1c:	84 d2                	test   %dl,%dl
 c1e:	0f 85 76 ff ff ff    	jne    b9a <printf+0x5a>
 c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 c28:	83 c4 3c             	add    $0x3c,%esp
 c2b:	5b                   	pop    %ebx
 c2c:	5e                   	pop    %esi
 c2d:	5f                   	pop    %edi
 c2e:	5d                   	pop    %ebp
 c2f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 c30:	bf 25 00 00 00       	mov    $0x25,%edi
 c35:	e9 51 ff ff ff       	jmp    b8b <printf+0x4b>
 c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 c40:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 c43:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 c48:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 c4a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 c51:	8b 10                	mov    (%eax),%edx
 c53:	89 f0                	mov    %esi,%eax
 c55:	e8 46 fe ff ff       	call   aa0 <printint>
        ap++;
 c5a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 c5e:	e9 28 ff ff ff       	jmp    b8b <printf+0x4b>
 c63:	90                   	nop
 c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 c68:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 c6b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 c6f:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 c71:	b8 72 0f 00 00       	mov    $0xf72,%eax
 c76:	85 ff                	test   %edi,%edi
 c78:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 c7b:	0f b6 07             	movzbl (%edi),%eax
 c7e:	84 c0                	test   %al,%al
 c80:	74 2a                	je     cac <printf+0x16c>
 c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 c88:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 c8b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 c8e:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 c91:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 c98:	00 
 c99:	89 44 24 04          	mov    %eax,0x4(%esp)
 c9d:	89 34 24             	mov    %esi,(%esp)
 ca0:	e8 2d fd ff ff       	call   9d2 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 ca5:	0f b6 07             	movzbl (%edi),%eax
 ca8:	84 c0                	test   %al,%al
 caa:	75 dc                	jne    c88 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 cac:	31 ff                	xor    %edi,%edi
 cae:	e9 d8 fe ff ff       	jmp    b8b <printf+0x4b>
 cb3:	90                   	nop
 cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 cb8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 cbb:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 cbd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 cc4:	00 
 cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
 cc9:	89 34 24             	mov    %esi,(%esp)
 ccc:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 cd0:	e8 fd fc ff ff       	call   9d2 <write>
 cd5:	e9 b1 fe ff ff       	jmp    b8b <printf+0x4b>
 cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 ce0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 ce3:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 ce8:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 ceb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 cf2:	8b 10                	mov    (%eax),%edx
 cf4:	89 f0                	mov    %esi,%eax
 cf6:	e8 a5 fd ff ff       	call   aa0 <printint>
        ap++;
 cfb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 cff:	e9 87 fe ff ff       	jmp    b8b <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 d04:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 d07:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 d09:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 d0b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 d12:	00 
 d13:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 d16:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 d19:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 d1c:	89 44 24 04          	mov    %eax,0x4(%esp)
 d20:	e8 ad fc ff ff       	call   9d2 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 d25:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 d29:	e9 5d fe ff ff       	jmp    b8b <printf+0x4b>
 d2e:	66 90                	xchg   %ax,%ax

00000d30 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 d30:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d31:	a1 f4 13 00 00       	mov    0x13f4,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 d36:	89 e5                	mov    %esp,%ebp
 d38:	57                   	push   %edi
 d39:	56                   	push   %esi
 d3a:	53                   	push   %ebx
 d3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d3e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 d40:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d43:	39 d0                	cmp    %edx,%eax
 d45:	72 11                	jb     d58 <free+0x28>
 d47:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d48:	39 c8                	cmp    %ecx,%eax
 d4a:	72 04                	jb     d50 <free+0x20>
 d4c:	39 ca                	cmp    %ecx,%edx
 d4e:	72 10                	jb     d60 <free+0x30>
 d50:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d52:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d54:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d56:	73 f0                	jae    d48 <free+0x18>
 d58:	39 ca                	cmp    %ecx,%edx
 d5a:	72 04                	jb     d60 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d5c:	39 c8                	cmp    %ecx,%eax
 d5e:	72 f0                	jb     d50 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 d60:	8b 73 fc             	mov    -0x4(%ebx),%esi
 d63:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 d66:	39 cf                	cmp    %ecx,%edi
 d68:	74 1e                	je     d88 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 d6a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 d6d:	8b 48 04             	mov    0x4(%eax),%ecx
 d70:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 d73:	39 f2                	cmp    %esi,%edx
 d75:	74 28                	je     d9f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 d77:	89 10                	mov    %edx,(%eax)
  freep = p;
 d79:	a3 f4 13 00 00       	mov    %eax,0x13f4
}
 d7e:	5b                   	pop    %ebx
 d7f:	5e                   	pop    %esi
 d80:	5f                   	pop    %edi
 d81:	5d                   	pop    %ebp
 d82:	c3                   	ret    
 d83:	90                   	nop
 d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 d88:	03 71 04             	add    0x4(%ecx),%esi
 d8b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 d8e:	8b 08                	mov    (%eax),%ecx
 d90:	8b 09                	mov    (%ecx),%ecx
 d92:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 d95:	8b 48 04             	mov    0x4(%eax),%ecx
 d98:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 d9b:	39 f2                	cmp    %esi,%edx
 d9d:	75 d8                	jne    d77 <free+0x47>
    p->s.size += bp->s.size;
 d9f:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 da2:	a3 f4 13 00 00       	mov    %eax,0x13f4
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 da7:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 daa:	8b 53 f8             	mov    -0x8(%ebx),%edx
 dad:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 daf:	5b                   	pop    %ebx
 db0:	5e                   	pop    %esi
 db1:	5f                   	pop    %edi
 db2:	5d                   	pop    %ebp
 db3:	c3                   	ret    
 db4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 dba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000dc0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 dc0:	55                   	push   %ebp
 dc1:	89 e5                	mov    %esp,%ebp
 dc3:	57                   	push   %edi
 dc4:	56                   	push   %esi
 dc5:	53                   	push   %ebx
 dc6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 dcc:	8b 1d f4 13 00 00    	mov    0x13f4,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 dd2:	8d 48 07             	lea    0x7(%eax),%ecx
 dd5:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 dd8:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 dda:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 ddd:	0f 84 9b 00 00 00    	je     e7e <malloc+0xbe>
 de3:	8b 13                	mov    (%ebx),%edx
 de5:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 de8:	39 fe                	cmp    %edi,%esi
 dea:	76 64                	jbe    e50 <malloc+0x90>
 dec:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 df3:	bb 00 80 00 00       	mov    $0x8000,%ebx
 df8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 dfb:	eb 0e                	jmp    e0b <malloc+0x4b>
 dfd:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e00:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 e02:	8b 78 04             	mov    0x4(%eax),%edi
 e05:	39 fe                	cmp    %edi,%esi
 e07:	76 4f                	jbe    e58 <malloc+0x98>
 e09:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 e0b:	3b 15 f4 13 00 00    	cmp    0x13f4,%edx
 e11:	75 ed                	jne    e00 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 e13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 e16:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 e1c:	bf 00 10 00 00       	mov    $0x1000,%edi
 e21:	0f 43 fe             	cmovae %esi,%edi
 e24:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 e27:	89 04 24             	mov    %eax,(%esp)
 e2a:	e8 13 fc ff ff       	call   a42 <sbrk>
  if(p == (char*)-1)
 e2f:	83 f8 ff             	cmp    $0xffffffff,%eax
 e32:	74 18                	je     e4c <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 e34:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 e37:	83 c0 08             	add    $0x8,%eax
 e3a:	89 04 24             	mov    %eax,(%esp)
 e3d:	e8 ee fe ff ff       	call   d30 <free>
  return freep;
 e42:	8b 15 f4 13 00 00    	mov    0x13f4,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 e48:	85 d2                	test   %edx,%edx
 e4a:	75 b4                	jne    e00 <malloc+0x40>
        return 0;
 e4c:	31 c0                	xor    %eax,%eax
 e4e:	eb 20                	jmp    e70 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 e50:	89 d0                	mov    %edx,%eax
 e52:	89 da                	mov    %ebx,%edx
 e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 e58:	39 fe                	cmp    %edi,%esi
 e5a:	74 1c                	je     e78 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 e5c:	29 f7                	sub    %esi,%edi
 e5e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 e61:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 e64:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 e67:	89 15 f4 13 00 00    	mov    %edx,0x13f4
      return (void*)(p + 1);
 e6d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 e70:	83 c4 1c             	add    $0x1c,%esp
 e73:	5b                   	pop    %ebx
 e74:	5e                   	pop    %esi
 e75:	5f                   	pop    %edi
 e76:	5d                   	pop    %ebp
 e77:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 e78:	8b 08                	mov    (%eax),%ecx
 e7a:	89 0a                	mov    %ecx,(%edx)
 e7c:	eb e9                	jmp    e67 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 e7e:	c7 05 f4 13 00 00 f8 	movl   $0x13f8,0x13f4
 e85:	13 00 00 
    base.s.size = 0;
 e88:	ba f8 13 00 00       	mov    $0x13f8,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 e8d:	c7 05 f8 13 00 00 f8 	movl   $0x13f8,0x13f8
 e94:	13 00 00 
    base.s.size = 0;
 e97:	c7 05 fc 13 00 00 00 	movl   $0x0,0x13fc
 e9e:	00 00 00 
 ea1:	e9 46 ff ff ff       	jmp    dec <malloc+0x2c>
