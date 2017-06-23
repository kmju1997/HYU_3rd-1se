
_threadtest2:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  "stridetest2",
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
      1c:	be 0e 00 00 00       	mov    $0xe,%esi
  if (argc >= 2)
    start = atoi(argv[1]);
      21:	89 04 24             	mov    %eax,(%esp)
      24:	e8 07 16 00 00       	call   1630 <atoi>
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
      37:	e8 f4 15 00 00       	call   1630 <atoi>
      3c:	89 c6                	mov    %eax,%esi

  //start=10;
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
      58:	e8 2d 16 00 00       	call   168a <fork>
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
      6b:	a1 70 26 00 00       	mov    0x2670,%eax
      70:	89 04 24             	mov    %eax,(%esp)
      73:	e8 42 16 00 00       	call   16ba <close>
      if (wait() == -1 || read(gpipe[0], (char*)&ret, sizeof(ret)) == -1 || ret != 0){
      78:	e8 1d 16 00 00       	call   169a <wait>
      7d:	83 f8 ff             	cmp    $0xffffffff,%eax
      80:	0f 84 cd 00 00 00    	je     153 <main+0x153>
      86:	a1 6c 26 00 00       	mov    0x266c,%eax
      8b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
      92:	00 
      93:	89 7c 24 04          	mov    %edi,0x4(%esp)
      97:	89 04 24             	mov    %eax,(%esp)
      9a:	e8 0b 16 00 00       	call   16aa <read>
      9f:	83 f8 ff             	cmp    $0xffffffff,%eax
      a2:	0f 84 ab 00 00 00    	je     153 <main+0x153>
      a8:	8b 44 24 1c          	mov    0x1c(%esp),%eax
      ac:	85 c0                	test   %eax,%eax
      ae:	0f 85 9f 00 00 00    	jne    153 <main+0x153>
        printf(1,"%d. %s panic\n", i, testname[i]);
        exit();
      }
      close(gpipe[0]);
      b4:	a1 6c 26 00 00       	mov    0x266c,%eax
      b9:	89 04 24             	mov    %eax,(%esp)
      bc:	e8 f9 15 00 00       	call   16ba <close>
    }
    printf(1,"%d. %s finish\n", i, testname[i]);
      c1:	8b 04 9d e0 25 00 00 	mov    0x25e0(,%ebx,4),%eax
      c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    start = atoi(argv[1]);
  if (argc >= 3)
    end = atoi(argv[2]);

  //start=10;
  for (i = start; i <= end; i++){
      cc:	83 c3 01             	add    $0x1,%ebx
        printf(1,"%d. %s panic\n", i, testname[i]);
        exit();
      }
      close(gpipe[0]);
    }
    printf(1,"%d. %s finish\n", i, testname[i]);
      cf:	c7 44 24 04 38 1d 00 	movl   $0x1d38,0x4(%esp)
      d6:	00 
      d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      de:	89 44 24 0c          	mov    %eax,0xc(%esp)
      e2:	e8 39 17 00 00       	call   1820 <printf>
    sleep(100);
      e7:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
      ee:	e8 37 16 00 00       	call   172a <sleep>
    start = atoi(argv[1]);
  if (argc >= 3)
    end = atoi(argv[2]);

  //start=10;
  for (i = start; i <= end; i++){
      f3:	39 f3                	cmp    %esi,%ebx
      f5:	7f 4b                	jg     142 <main+0x142>
    printf(1,"%d. %s start\n", i, testname[i]);
      f7:	8b 04 9d e0 25 00 00 	mov    0x25e0(,%ebx,4),%eax
      fe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     102:	c7 44 24 04 04 1d 00 	movl   $0x1d04,0x4(%esp)
     109:	00 
     10a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     111:	89 44 24 0c          	mov    %eax,0xc(%esp)
     115:	e8 06 17 00 00       	call   1820 <printf>
    if (pipe(gpipe) < 0){
     11a:	c7 04 24 6c 26 00 00 	movl   $0x266c,(%esp)
     121:	e8 7c 15 00 00       	call   16a2 <pipe>
     126:	85 c0                	test   %eax,%eax
     128:	0f 89 22 ff ff ff    	jns    50 <main+0x50>
      printf(1,"pipe panic\n");
     12e:	c7 44 24 04 12 1d 00 	movl   $0x1d12,0x4(%esp)
     135:	00 
     136:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     13d:	e8 de 16 00 00       	call   1820 <printf>
      exit();
     142:	e8 4b 15 00 00       	call   1692 <exit>
{
  int i;
  int ret;
  int pid;
  int start = 0;
  int end = NTEST-1;
     147:	be 0e 00 00 00       	mov    $0xe,%esi
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
     153:	8b 04 9d e0 25 00 00 	mov    0x25e0(,%ebx,4),%eax
     15a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     15e:	c7 44 24 04 2a 1d 00 	movl   $0x1d2a,0x4(%esp)
     165:	00 
     166:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     16d:	89 44 24 0c          	mov    %eax,0xc(%esp)
     171:	e8 aa 16 00 00       	call   1820 <printf>
        exit();
     176:	e8 17 15 00 00       	call   1692 <exit>
      exit();
    }
    ret = 0;

    if ((pid = fork()) < 0){
      printf(1,"fork panic\n");
     17b:	c7 44 24 04 1e 1d 00 	movl   $0x1d1e,0x4(%esp)
     182:	00 
     183:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     18a:	e8 91 16 00 00       	call   1820 <printf>
      exit();
     18f:	e8 fe 14 00 00       	call   1692 <exit>
    }
    if (pid == 0){
      close(gpipe[0]);
     194:	a1 6c 26 00 00       	mov    0x266c,%eax
     199:	89 04 24             	mov    %eax,(%esp)
     19c:	e8 19 15 00 00       	call   16ba <close>
      ret = testfunc[i]();
     1a1:	ff 14 9d 20 26 00 00 	call   *0x2620(,%ebx,4)
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
     1bc:	a1 70 26 00 00       	mov    0x2670,%eax
     1c1:	89 04 24             	mov    %eax,(%esp)
     1c4:	e8 e9 14 00 00       	call   16b2 <write>
      close(gpipe[1]);
     1c9:	a1 70 26 00 00       	mov    0x2670,%eax
     1ce:	89 04 24             	mov    %eax,(%esp)
     1d1:	e8 e4 14 00 00       	call   16ba <close>
      exit();
     1d6:	e8 b7 14 00 00       	call   1692 <exit>
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
     222:	c7 44 24 04 88 1b 00 	movl   $0x1b88,0x4(%esp)
     229:	00 
     22a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     231:	e8 ea 15 00 00       	call   1820 <printf>
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
     244:	e8 19 15 00 00       	call   1762 <thread_exit>
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
     25d:	e8 c8 14 00 00       	call   172a <sleep>
  printf(1, "thread_exit...\n");
     262:	c7 44 24 04 8b 1b 00 	movl   $0x1b8b,0x4(%esp)
     269:	00 
     26a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     271:	e8 aa 15 00 00       	call   1820 <printf>
  thread_exit((void *)(val*2));
     276:	8b 45 08             	mov    0x8(%ebp),%eax
     279:	01 c0                	add    %eax,%eax
     27b:	89 04 24             	mov    %eax,(%esp)
     27e:	e8 df 14 00 00       	call   1762 <thread_exit>
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
     29d:	e8 c0 14 00 00       	call   1762 <thread_exit>
     2a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     2a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002b0 <exitthreadmain>:

// ============================================================================

void*
exitthreadmain(void *arg)
{
     2b0:	55                   	push   %ebp
     2b1:	89 e5                	mov    %esp,%ebp
     2b3:	83 ec 18             	sub    $0x18,%esp
     2b6:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;
  if ((int)arg == 1){
     2b9:	83 f8 01             	cmp    $0x1,%eax
     2bc:	74 12                	je     2d0 <exitthreadmain+0x20>
    while(1){
      printf(1, "thread_exit ...\n");
      for (i = 0; i < 5000000; i++);
    }
  } else if ((int)arg == 2){
     2be:	83 f8 02             	cmp    $0x2,%eax
     2c1:	74 34                	je     2f7 <exitthreadmain+0x47>
    exit();
  }
  thread_exit(0);
     2c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     2ca:	e8 93 14 00 00       	call   1762 <thread_exit>
     2cf:	90                   	nop
exitthreadmain(void *arg)
{
  int i;
  if ((int)arg == 1){
    while(1){
      printf(1, "thread_exit ...\n");
     2d0:	c7 44 24 04 9b 1b 00 	movl   $0x1b9b,0x4(%esp)
     2d7:	00 
     2d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2df:	e8 3c 15 00 00       	call   1820 <printf>
     2e4:	b8 40 4b 4c 00       	mov    $0x4c4b40,%eax
     2e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for (i = 0; i < 5000000; i++);
     2f0:	83 e8 01             	sub    $0x1,%eax
     2f3:	75 fb                	jne    2f0 <exitthreadmain+0x40>
     2f5:	eb d9                	jmp    2d0 <exitthreadmain+0x20>
    }
  } else if ((int)arg == 2){
    exit();
     2f7:	e8 96 13 00 00       	call   1692 <exit>
     2fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000300 <forkthreadmain>:

// ============================================================================

void*
forkthreadmain(void *arg)
{
     300:	55                   	push   %ebp
     301:	89 e5                	mov    %esp,%ebp
     303:	83 ec 18             	sub    $0x18,%esp
  int pid;
  if ((pid = fork()) == -1){
     306:	e8 7f 13 00 00       	call   168a <fork>
     30b:	83 f8 ff             	cmp    $0xffffffff,%eax
     30e:	74 47                	je     357 <forkthreadmain+0x57>
    printf(1, "panic at fork in forktest\n");
    exit();
  } else if (pid == 0){
     310:	85 c0                	test   %eax,%eax
     312:	74 2a                	je     33e <forkthreadmain+0x3e>
    printf(1, "child\n");
    exit();
  } else{
    printf(1, "parent\n");
     314:	c7 44 24 04 ce 1b 00 	movl   $0x1bce,0x4(%esp)
     31b:	00 
     31c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     323:	e8 f8 14 00 00       	call   1820 <printf>
    if (wait() == -1){
     328:	e8 6d 13 00 00       	call   169a <wait>
     32d:	83 c0 01             	add    $0x1,%eax
     330:	74 3e                	je     370 <forkthreadmain+0x70>
      printf(1, "panic at wait in forktest\n");
      exit();
    }
  }
  thread_exit(0);
     332:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     339:	e8 24 14 00 00       	call   1762 <thread_exit>
  int pid;
  if ((pid = fork()) == -1){
    printf(1, "panic at fork in forktest\n");
    exit();
  } else if (pid == 0){
    printf(1, "child\n");
     33e:	c7 44 24 04 c7 1b 00 	movl   $0x1bc7,0x4(%esp)
     345:	00 
     346:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     34d:	e8 ce 14 00 00       	call   1820 <printf>
    exit();
     352:	e8 3b 13 00 00       	call   1692 <exit>
void*
forkthreadmain(void *arg)
{
  int pid;
  if ((pid = fork()) == -1){
    printf(1, "panic at fork in forktest\n");
     357:	c7 44 24 04 ac 1b 00 	movl   $0x1bac,0x4(%esp)
     35e:	00 
     35f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     366:	e8 b5 14 00 00       	call   1820 <printf>
    exit();
     36b:	e8 22 13 00 00       	call   1692 <exit>
    printf(1, "child\n");
    exit();
  } else{
    printf(1, "parent\n");
    if (wait() == -1){
      printf(1, "panic at wait in forktest\n");
     370:	c7 44 24 04 d6 1b 00 	movl   $0x1bd6,0x4(%esp)
     377:	00 
     378:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     37f:	e8 9c 14 00 00       	call   1820 <printf>
      exit();
     384:	e8 09 13 00 00       	call   1692 <exit>
     389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000390 <sleepthreadmain>:

// ============================================================================

void*
sleepthreadmain(void *arg)
{
     390:	55                   	push   %ebp
     391:	89 e5                	mov    %esp,%ebp
     393:	83 ec 18             	sub    $0x18,%esp
  sleep(1000000);
     396:	c7 04 24 40 42 0f 00 	movl   $0xf4240,(%esp)
     39d:	e8 88 13 00 00       	call   172a <sleep>
  thread_exit(0);
     3a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     3a9:	e8 b4 13 00 00       	call   1762 <thread_exit>
     3ae:	66 90                	xchg   %ax,%ax

000003b0 <racingthreadmain>:
// ============================================================================
void nop(){ }

void*
racingthreadmain(void *arg)
{
     3b0:	55                   	push   %ebp
     3b1:	89 e5                	mov    %esp,%ebp
     3b3:	83 ec 18             	sub    $0x18,%esp
    tmp = gcnt;
    tmp++;
    nop();
    gcnt = tmp;
  }
  thread_exit((void *)(tid+1));
     3b6:	8b 45 08             	mov    0x8(%ebp),%eax
     3b9:	81 05 68 26 00 00 80 	addl   $0x989680,0x2668
     3c0:	96 98 00 
     3c3:	83 c0 01             	add    $0x1,%eax
     3c6:	89 04 24             	mov    %eax,(%esp)
     3c9:	e8 94 13 00 00       	call   1762 <thread_exit>
     3ce:	66 90                	xchg   %ax,%ax

000003d0 <exittest2>:
  return 0;
}

int
exittest2(void)
{
     3d0:	55                   	push   %ebp
     3d1:	89 e5                	mov    %esp,%ebp
     3d3:	56                   	push   %esi
     3d4:	53                   	push   %ebx
     3d5:	83 ec 40             	sub    $0x40,%esp
     3d8:	8d 5d d0             	lea    -0x30(%ebp),%ebx
     3db:	8d 75 f8             	lea    -0x8(%ebp),%esi
     3de:	66 90                	xchg   %ax,%ax
  thread_t threads[NUM_THREAD];
  int i;

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], exitthreadmain, (void*)2) != 0){
     3e0:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
     3e7:	00 
     3e8:	c7 44 24 04 b0 02 00 	movl   $0x2b0,0x4(%esp)
     3ef:	00 
     3f0:	89 1c 24             	mov    %ebx,(%esp)
     3f3:	e8 62 13 00 00       	call   175a <thread_create>
     3f8:	85 c0                	test   %eax,%eax
     3fa:	75 09                	jne    405 <exittest2+0x35>
     3fc:	83 c3 04             	add    $0x4,%ebx
exittest2(void)
{
  thread_t threads[NUM_THREAD];
  int i;

  for (i = 0; i < NUM_THREAD; i++){
     3ff:	39 f3                	cmp    %esi,%ebx
     401:	75 dd                	jne    3e0 <exittest2+0x10>
     403:	eb fe                	jmp    403 <exittest2+0x33>
    if (thread_create(&threads[i], exitthreadmain, (void*)2) != 0){
      printf(1, "panic at thread_create\n");
     405:	c7 44 24 04 f1 1b 00 	movl   $0x1bf1,0x4(%esp)
     40c:	00 
     40d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     414:	e8 07 14 00 00       	call   1820 <printf>
      return -1;
    }
  }
  while(1);
  return 0;
}
     419:	83 c4 40             	add    $0x40,%esp
     41c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     421:	5b                   	pop    %ebx
     422:	5e                   	pop    %esi
     423:	5d                   	pop    %ebp
     424:	c3                   	ret    
     425:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000430 <jointest2>:
  return 0;
}

int
jointest2(void)
{
     430:	55                   	push   %ebp
     431:	89 e5                	mov    %esp,%ebp
     433:	56                   	push   %esi
     434:	53                   	push   %ebx
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
     435:	bb 01 00 00 00       	mov    $0x1,%ebx
  return 0;
}

int
jointest2(void)
{
     43a:	83 ec 40             	sub    $0x40,%esp
     43d:	8d 75 d0             	lea    -0x30(%ebp),%esi
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
     440:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     444:	c7 44 24 04 50 02 00 	movl   $0x250,0x4(%esp)
     44b:	00 
     44c:	89 34 24             	mov    %esi,(%esp)
     44f:	e8 06 13 00 00       	call   175a <thread_create>
     454:	85 c0                	test   %eax,%eax
     456:	75 78                	jne    4d0 <jointest2+0xa0>
{
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
     458:	83 c3 01             	add    $0x1,%ebx
     45b:	83 c6 04             	add    $0x4,%esi
     45e:	83 fb 0b             	cmp    $0xb,%ebx
     461:	75 dd                	jne    440 <jointest2+0x10>
    if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  sleep(500);
     463:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
  printf(1, "thread_join!!!\n");
     46a:	b3 02                	mov    $0x2,%bl
    if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  sleep(500);
     46c:	e8 b9 12 00 00       	call   172a <sleep>
     471:	8d 75 cc             	lea    -0x34(%ebp),%esi
  printf(1, "thread_join!!!\n");
     474:	c7 44 24 04 09 1c 00 	movl   $0x1c09,0x4(%esp)
     47b:	00 
     47c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     483:	e8 98 13 00 00       	call   1820 <printf>
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
     488:	8b 44 5d cc          	mov    -0x34(%ebp,%ebx,2),%eax
     48c:	89 74 24 04          	mov    %esi,0x4(%esp)
     490:	89 04 24             	mov    %eax,(%esp)
     493:	e8 d2 12 00 00       	call   176a <thread_join>
     498:	85 c0                	test   %eax,%eax
     49a:	75 54                	jne    4f0 <jointest2+0xc0>
     49c:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
     49f:	75 4f                	jne    4f0 <jointest2+0xc0>
     4a1:	83 c3 02             	add    $0x2,%ebx
      return -1;
    }
  }
  sleep(500);
  printf(1, "thread_join!!!\n");
  for (i = 1; i <= NUM_THREAD; i++){
     4a4:	83 fb 16             	cmp    $0x16,%ebx
     4a7:	75 df                	jne    488 <jointest2+0x58>
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }
  printf(1,"\n");
     4a9:	c7 44 24 04 17 1c 00 	movl   $0x1c17,0x4(%esp)
     4b0:	00 
     4b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     4b8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     4bb:	e8 60 13 00 00       	call   1820 <printf>
     4c0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  return 0;
}
     4c3:	83 c4 40             	add    $0x40,%esp
     4c6:	5b                   	pop    %ebx
     4c7:	5e                   	pop    %esi
     4c8:	5d                   	pop    %ebp
     4c9:	c3                   	ret    
     4ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
      printf(1, "panic at thread_create\n");
     4d0:	c7 44 24 04 f1 1b 00 	movl   $0x1bf1,0x4(%esp)
     4d7:	00 
     4d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     4df:	e8 3c 13 00 00       	call   1820 <printf>
      return -1;
    }
  }
  printf(1,"\n");
  return 0;
}
     4e4:	83 c4 40             	add    $0x40,%esp
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
     4e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
    }
  }
  printf(1,"\n");
  return 0;
}
     4ec:	5b                   	pop    %ebx
     4ed:	5e                   	pop    %esi
     4ee:	5d                   	pop    %ebp
     4ef:	c3                   	ret    
  }
  sleep(500);
  printf(1, "thread_join!!!\n");
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
      printf(1, "panic at thread_join\n");
     4f0:	c7 44 24 04 19 1c 00 	movl   $0x1c19,0x4(%esp)
     4f7:	00 
     4f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     4ff:	e8 1c 13 00 00       	call   1820 <printf>
      return -1;
    }
  }
  printf(1,"\n");
  return 0;
}
     504:	83 c4 40             	add    $0x40,%esp
  sleep(500);
  printf(1, "thread_join!!!\n");
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
      printf(1, "panic at thread_join\n");
      return -1;
     507:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
  }
  printf(1,"\n");
  return 0;
}
     50c:	5b                   	pop    %ebx
     50d:	5e                   	pop    %esi
     50e:	5d                   	pop    %ebp
     50f:	c3                   	ret    

00000510 <pipetest>:
  thread_exit(0);
}

int
pipetest(void)
{
     510:	55                   	push   %ebp
     511:	89 e5                	mov    %esp,%ebp
     513:	57                   	push   %edi
     514:	56                   	push   %esi
     515:	53                   	push   %ebx
     516:	83 ec 5c             	sub    $0x5c,%esp
  int fd[2];
  int i;
  void *retval;
  int pid;

  if (pipe(fd) < 0){
     519:	8d 45 ac             	lea    -0x54(%ebp),%eax
     51c:	89 04 24             	mov    %eax,(%esp)
     51f:	e8 7e 11 00 00       	call   16a2 <pipe>
     524:	85 c0                	test   %eax,%eax
     526:	0f 88 bc 01 00 00    	js     6e8 <pipetest+0x1d8>
    printf(1, "panic at pipe in pipetest\n");
    return -1;
  }
  arg[1] = fd[0];
     52c:	8b 45 ac             	mov    -0x54(%ebp),%eax
     52f:	89 45 b8             	mov    %eax,-0x48(%ebp)
  arg[2] = fd[1];
     532:	8b 45 b0             	mov    -0x50(%ebp),%eax
     535:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if ((pid = fork()) < 0){
     538:	e8 4d 11 00 00       	call   168a <fork>
     53d:	85 c0                	test   %eax,%eax
     53f:	0f 88 c1 01 00 00    	js     706 <pipetest+0x1f6>
      printf(1, "panic at fork in pipetest\n");
      return -1;
  } else if (pid == 0){
     545:	0f 85 85 00 00 00    	jne    5d0 <pipetest+0xc0>
    close(fd[0]);
     54b:	8b 45 ac             	mov    -0x54(%ebp),%eax
     54e:	8d 75 e8             	lea    -0x18(%ebp),%esi
     551:	8d 5d b4             	lea    -0x4c(%ebp),%ebx
     554:	89 04 24             	mov    %eax,(%esp)
     557:	e8 5e 11 00 00       	call   16ba <close>
     55c:	8d 45 c0             	lea    -0x40(%ebp),%eax
    arg[0] = 0;
     55f:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
     566:	89 c7                	mov    %eax,%edi
     568:	89 45 a4             	mov    %eax,-0x5c(%ebp)
     56b:	90                   	nop
     56c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_create(&threads[i], pipethreadmain, (void*)arg) != 0){
     570:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     574:	c7 44 24 04 50 08 00 	movl   $0x850,0x4(%esp)
     57b:	00 
     57c:	89 3c 24             	mov    %edi,(%esp)
     57f:	e8 d6 11 00 00       	call   175a <thread_create>
     584:	85 c0                	test   %eax,%eax
     586:	0f 85 ec 00 00 00    	jne    678 <pipetest+0x168>
     58c:	83 c7 04             	add    $0x4,%edi
      printf(1, "panic at fork in pipetest\n");
      return -1;
  } else if (pid == 0){
    close(fd[0]);
    arg[0] = 0;
    for (i = 0; i < NUM_THREAD; i++){
     58f:	39 f7                	cmp    %esi,%edi
     591:	75 dd                	jne    570 <pipetest+0x60>
     593:	8b 7d a4             	mov    -0x5c(%ebp),%edi
     596:	8d 5d a8             	lea    -0x58(%ebp),%ebx
     599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "panic at thread_create\n");
        return -1;
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_join(threads[i], &retval) != 0){
     5a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     5a4:	8b 07                	mov    (%edi),%eax
     5a6:	89 04 24             	mov    %eax,(%esp)
     5a9:	e8 bc 11 00 00       	call   176a <thread_join>
     5ae:	85 c0                	test   %eax,%eax
     5b0:	0f 85 ea 00 00 00    	jne    6a0 <pipetest+0x190>
     5b6:	83 c7 04             	add    $0x4,%edi
      if (thread_create(&threads[i], pipethreadmain, (void*)arg) != 0){
        printf(1, "panic at thread_create\n");
        return -1;
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
     5b9:	39 fe                	cmp    %edi,%esi
     5bb:	75 e3                	jne    5a0 <pipetest+0x90>
      if (thread_join(threads[i], &retval) != 0){
        printf(1, "panic at thread_join\n");
        return -1;
      }
    }
    close(fd[1]);
     5bd:	8b 45 b0             	mov    -0x50(%ebp),%eax
     5c0:	89 04 24             	mov    %eax,(%esp)
     5c3:	e8 f2 10 00 00       	call   16ba <close>
    exit();
     5c8:	e8 c5 10 00 00       	call   1692 <exit>
     5cd:	8d 76 00             	lea    0x0(%esi),%esi
  } else{
    close(fd[1]);
     5d0:	8b 45 b0             	mov    -0x50(%ebp),%eax
     5d3:	8d 75 e8             	lea    -0x18(%ebp),%esi
     5d6:	8d 5d b4             	lea    -0x4c(%ebp),%ebx
     5d9:	89 04 24             	mov    %eax,(%esp)
     5dc:	e8 d9 10 00 00       	call   16ba <close>
     5e1:	8d 45 c0             	lea    -0x40(%ebp),%eax
    arg[0] = 1;
     5e4:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
     5eb:	89 c7                	mov    %eax,%edi
    gcnt = 0;
     5ed:	c7 05 68 26 00 00 00 	movl   $0x0,0x2668
     5f4:	00 00 00 
     5f7:	89 45 a4             	mov    %eax,-0x5c(%ebp)
     5fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_create(&threads[i], pipethreadmain, (void*)arg) != 0){
     600:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     604:	c7 44 24 04 50 08 00 	movl   $0x850,0x4(%esp)
     60b:	00 
     60c:	89 3c 24             	mov    %edi,(%esp)
     60f:	e8 46 11 00 00       	call   175a <thread_create>
     614:	85 c0                	test   %eax,%eax
     616:	75 60                	jne    678 <pipetest+0x168>
     618:	83 c7 04             	add    $0x4,%edi
    exit();
  } else{
    close(fd[1]);
    arg[0] = 1;
    gcnt = 0;
    for (i = 0; i < NUM_THREAD; i++){
     61b:	39 f7                	cmp    %esi,%edi
     61d:	75 e1                	jne    600 <pipetest+0xf0>
     61f:	8b 7d a4             	mov    -0x5c(%ebp),%edi
     622:	8d 5d a8             	lea    -0x58(%ebp),%ebx
     625:	8d 76 00             	lea    0x0(%esi),%esi
        printf(1, "panic at thread_create\n");
        return -1;
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_join(threads[i], &retval) != 0){
     628:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     62c:	8b 07                	mov    (%edi),%eax
     62e:	89 04 24             	mov    %eax,(%esp)
     631:	e8 34 11 00 00       	call   176a <thread_join>
     636:	85 c0                	test   %eax,%eax
     638:	75 66                	jne    6a0 <pipetest+0x190>
     63a:	83 c7 04             	add    $0x4,%edi
      if (thread_create(&threads[i], pipethreadmain, (void*)arg) != 0){
        printf(1, "panic at thread_create\n");
        return -1;
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
     63d:	39 fe                	cmp    %edi,%esi
     63f:	75 e7                	jne    628 <pipetest+0x118>
     641:	89 45 a4             	mov    %eax,-0x5c(%ebp)
      if (thread_join(threads[i], &retval) != 0){
        printf(1, "panic at thread_join\n");
        return -1;
      }
    }
    close(fd[0]);
     644:	8b 45 ac             	mov    -0x54(%ebp),%eax
     647:	89 04 24             	mov    %eax,(%esp)
     64a:	e8 6b 10 00 00       	call   16ba <close>
  }
  if (wait() == -1){
     64f:	e8 46 10 00 00       	call   169a <wait>
     654:	8b 55 a4             	mov    -0x5c(%ebp),%edx
     657:	83 f8 ff             	cmp    $0xffffffff,%eax
     65a:	0f 84 c4 00 00 00    	je     724 <pipetest+0x214>
    printf(1, "panic at wait in pipetest\n");
    return -1;
  }
  if (gcnt != 0)
     660:	a1 68 26 00 00       	mov    0x2668,%eax
     665:	85 c0                	test   %eax,%eax
     667:	75 5f                	jne    6c8 <pipetest+0x1b8>
    printf(1,"panic at validation in pipetest : %d\n", gcnt);

  return 0;
}
     669:	83 c4 5c             	add    $0x5c,%esp
     66c:	89 d0                	mov    %edx,%eax
     66e:	5b                   	pop    %ebx
     66f:	5e                   	pop    %esi
     670:	5f                   	pop    %edi
     671:	5d                   	pop    %ebp
     672:	c3                   	ret    
     673:	90                   	nop
     674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  } else if (pid == 0){
    close(fd[0]);
    arg[0] = 0;
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_create(&threads[i], pipethreadmain, (void*)arg) != 0){
        printf(1, "panic at thread_create\n");
     678:	c7 44 24 04 f1 1b 00 	movl   $0x1bf1,0x4(%esp)
     67f:	00 
     680:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     687:	e8 94 11 00 00       	call   1820 <printf>
  }
  if (gcnt != 0)
    printf(1,"panic at validation in pipetest : %d\n", gcnt);

  return 0;
}
     68c:	83 c4 5c             	add    $0x5c,%esp
    close(fd[0]);
    arg[0] = 0;
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_create(&threads[i], pipethreadmain, (void*)arg) != 0){
        printf(1, "panic at thread_create\n");
        return -1;
     68f:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  }
  if (gcnt != 0)
    printf(1,"panic at validation in pipetest : %d\n", gcnt);

  return 0;
}
     694:	5b                   	pop    %ebx
     695:	89 d0                	mov    %edx,%eax
     697:	5e                   	pop    %esi
     698:	5f                   	pop    %edi
     699:	5d                   	pop    %ebp
     69a:	c3                   	ret    
     69b:	90                   	nop
     69c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_join(threads[i], &retval) != 0){
        printf(1, "panic at thread_join\n");
     6a0:	c7 44 24 04 19 1c 00 	movl   $0x1c19,0x4(%esp)
     6a7:	00 
     6a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6af:	e8 6c 11 00 00       	call   1820 <printf>
  }
  if (gcnt != 0)
    printf(1,"panic at validation in pipetest : %d\n", gcnt);

  return 0;
}
     6b4:	83 c4 5c             	add    $0x5c,%esp
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_join(threads[i], &retval) != 0){
        printf(1, "panic at thread_join\n");
        return -1;
     6b7:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  }
  if (gcnt != 0)
    printf(1,"panic at validation in pipetest : %d\n", gcnt);

  return 0;
}
     6bc:	5b                   	pop    %ebx
     6bd:	89 d0                	mov    %edx,%eax
     6bf:	5e                   	pop    %esi
     6c0:	5f                   	pop    %edi
     6c1:	5d                   	pop    %ebp
     6c2:	c3                   	ret    
     6c3:	90                   	nop
     6c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (wait() == -1){
    printf(1, "panic at wait in pipetest\n");
    return -1;
  }
  if (gcnt != 0)
    printf(1,"panic at validation in pipetest : %d\n", gcnt);
     6c8:	89 44 24 08          	mov    %eax,0x8(%esp)
     6cc:	c7 44 24 04 e0 1d 00 	movl   $0x1de0,0x4(%esp)
     6d3:	00 
     6d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6db:	89 55 a4             	mov    %edx,-0x5c(%ebp)
     6de:	e8 3d 11 00 00       	call   1820 <printf>
     6e3:	8b 55 a4             	mov    -0x5c(%ebp),%edx
     6e6:	eb 81                	jmp    669 <pipetest+0x159>
  int i;
  void *retval;
  int pid;

  if (pipe(fd) < 0){
    printf(1, "panic at pipe in pipetest\n");
     6e8:	c7 44 24 04 2f 1c 00 	movl   $0x1c2f,0x4(%esp)
     6ef:	00 
     6f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6f7:	e8 24 11 00 00       	call   1820 <printf>
    return -1;
     6fc:	ba ff ff ff ff       	mov    $0xffffffff,%edx
     701:	e9 63 ff ff ff       	jmp    669 <pipetest+0x159>
  }
  arg[1] = fd[0];
  arg[2] = fd[1];
  if ((pid = fork()) < 0){
      printf(1, "panic at fork in pipetest\n");
     706:	c7 44 24 04 4a 1c 00 	movl   $0x1c4a,0x4(%esp)
     70d:	00 
     70e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     715:	e8 06 11 00 00       	call   1820 <printf>
      return -1;
     71a:	ba ff ff ff ff       	mov    $0xffffffff,%edx
     71f:	e9 45 ff ff ff       	jmp    669 <pipetest+0x159>
      }
    }
    close(fd[0]);
  }
  if (wait() == -1){
    printf(1, "panic at wait in pipetest\n");
     724:	c7 44 24 04 65 1c 00 	movl   $0x1c65,0x4(%esp)
     72b:	00 
     72c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     733:	e8 e8 10 00 00       	call   1820 <printf>
    return -1;
     738:	ba ff ff ff ff       	mov    $0xffffffff,%edx
     73d:	e9 27 ff ff ff       	jmp    669 <pipetest+0x159>
     742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000750 <execthreadmain>:

// ============================================================================

void*
execthreadmain(void *arg)
{
     750:	55                   	push   %ebp
     751:	89 e5                	mov    %esp,%ebp
     753:	83 ec 28             	sub    $0x28,%esp
  char *args[3] = {"echo", "echo is executed!", 0}; 
  sleep(1);
     756:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
// ============================================================================

void*
execthreadmain(void *arg)
{
  char *args[3] = {"echo", "echo is executed!", 0}; 
     75d:	c7 45 ec 80 1c 00 00 	movl   $0x1c80,-0x14(%ebp)
     764:	c7 45 f0 85 1c 00 00 	movl   $0x1c85,-0x10(%ebp)
     76b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  sleep(1);
     772:	e8 b3 0f 00 00       	call   172a <sleep>
  exec("echo", args);
     777:	8d 45 ec             	lea    -0x14(%ebp),%eax
     77a:	89 44 24 04          	mov    %eax,0x4(%esp)
     77e:	c7 04 24 80 1c 00 00 	movl   $0x1c80,(%esp)
     785:	e8 40 0f 00 00       	call   16ca <exec>

  printf(1, "panic at execthreadmain\n");
     78a:	c7 44 24 04 97 1c 00 	movl   $0x1c97,0x4(%esp)
     791:	00 
     792:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     799:	e8 82 10 00 00       	call   1820 <printf>
  exit();
     79e:	e8 ef 0e 00 00       	call   1692 <exit>
     7a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     7a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000007b0 <sbrkthreadmain>:

// ============================================================================

void*
sbrkthreadmain(void *arg)
{
     7b0:	55                   	push   %ebp
     7b1:	89 e5                	mov    %esp,%ebp
     7b3:	57                   	push   %edi
     7b4:	56                   	push   %esi
     7b5:	53                   	push   %ebx
     7b6:	83 ec 1c             	sub    $0x1c,%esp
     7b9:	8b 75 08             	mov    0x8(%ebp),%esi
  int tid = (int)arg;
  char *oldbrk;
  char *end;
  char *c;
  oldbrk = sbrk(1000);
     7bc:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
     7c3:	e8 5a 0f 00 00       	call   1722 <sbrk>
     7c8:	8d 4e 01             	lea    0x1(%esi),%ecx
     7cb:	89 c7                	mov    %eax,%edi
     7cd:	89 c2                	mov    %eax,%edx
  end = oldbrk + 1000;
     7cf:	8d 98 e8 03 00 00    	lea    0x3e8(%eax),%ebx
     7d5:	8d 76 00             	lea    0x0(%esi),%esi
  for (c = oldbrk; c < end; c++){
    *c = tid+1;
     7d8:	88 0a                	mov    %cl,(%edx)
  char *oldbrk;
  char *end;
  char *c;
  oldbrk = sbrk(1000);
  end = oldbrk + 1000;
  for (c = oldbrk; c < end; c++){
     7da:	83 c2 01             	add    $0x1,%edx
     7dd:	39 d3                	cmp    %edx,%ebx
     7df:	75 f7                	jne    7d8 <sbrkthreadmain+0x28>
    *c = tid+1;
  }
  sleep(1);
     7e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  for (c = oldbrk; c < end; c++){
    if (*c != tid+1){
     7e8:	83 c6 01             	add    $0x1,%esi
  oldbrk = sbrk(1000);
  end = oldbrk + 1000;
  for (c = oldbrk; c < end; c++){
    *c = tid+1;
  }
  sleep(1);
     7eb:	e8 3a 0f 00 00       	call   172a <sleep>
  for (c = oldbrk; c < end; c++){
    if (*c != tid+1){
     7f0:	0f be 17             	movsbl (%edi),%edx
     7f3:	39 f2                	cmp    %esi,%edx
     7f5:	75 0f                	jne    806 <sbrkthreadmain+0x56>
     7f7:	90                   	nop
  end = oldbrk + 1000;
  for (c = oldbrk; c < end; c++){
    *c = tid+1;
  }
  sleep(1);
  for (c = oldbrk; c < end; c++){
     7f8:	83 c7 01             	add    $0x1,%edi
     7fb:	39 fb                	cmp    %edi,%ebx
     7fd:	74 20                	je     81f <sbrkthreadmain+0x6f>
    if (*c != tid+1){
     7ff:	0f be 07             	movsbl (%edi),%eax
     802:	39 d0                	cmp    %edx,%eax
     804:	74 f2                	je     7f8 <sbrkthreadmain+0x48>
      printf(1, "panic at sbrkthreadmain\n");
     806:	c7 44 24 04 b0 1c 00 	movl   $0x1cb0,0x4(%esp)
     80d:	00 
     80e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     815:	e8 06 10 00 00       	call   1820 <printf>
      exit();
     81a:	e8 73 0e 00 00       	call   1692 <exit>
    }
  }
  thread_exit(0);
     81f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     826:	e8 37 0f 00 00       	call   1762 <thread_exit>
     82b:	90                   	nop
     82c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000830 <killthreadmain>:

// ============================================================================

void*
killthreadmain(void *arg)
{
     830:	55                   	push   %ebp
     831:	89 e5                	mov    %esp,%ebp
     833:	83 ec 18             	sub    $0x18,%esp
  kill(getpid());
     836:	e8 d7 0e 00 00       	call   1712 <getpid>
     83b:	89 04 24             	mov    %eax,(%esp)
     83e:	e8 7f 0e 00 00       	call   16c2 <kill>
     843:	eb fe                	jmp    843 <killthreadmain+0x13>
     845:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000850 <pipethreadmain>:

// ============================================================================

void*
pipethreadmain(void *arg)
{
     850:	55                   	push   %ebp
     851:	89 e5                	mov    %esp,%ebp
     853:	57                   	push   %edi
     854:	56                   	push   %esi
     855:	53                   	push   %ebx
     856:	83 ec 2c             	sub    $0x2c,%esp
     859:	8b 75 08             	mov    0x8(%ebp),%esi
  int type = ((int*)arg)[0];
  int *fd = (int*)arg+1;
  int i;
  int input;

  for (i = -5; i <= 5; i++){
     85c:	c7 45 e0 fb ff ff ff 	movl   $0xfffffffb,-0x20(%ebp)
      __sync_fetch_and_add(&gcnt, input);
      //gcnt += input;
    } else{
        //ADDED
        //printf(1,"wirte %d\n",i);
      write(fd[1], &i, sizeof(int));
     863:	8d 7d e0             	lea    -0x20(%ebp),%edi
// ============================================================================

void*
pipethreadmain(void *arg)
{
  int type = ((int*)arg)[0];
     866:	8b 1e                	mov    (%esi),%ebx
     868:	eb 30                	jmp    89a <pipethreadmain+0x4a>
     86a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i;
  int input;

  for (i = -5; i <= 5; i++){
    if (type){
      read(fd[0], &input, sizeof(int));
     870:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     873:	89 44 24 04          	mov    %eax,0x4(%esp)
     877:	8b 46 04             	mov    0x4(%esi),%eax
     87a:	89 04 24             	mov    %eax,(%esp)
     87d:	e8 28 0e 00 00       	call   16aa <read>
      //ADDED
        //printf(1,"read %d\n",input);
      __sync_fetch_and_add(&gcnt, input);
     882:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     885:	f0 01 05 68 26 00 00 	lock add %eax,0x2668
  int type = ((int*)arg)[0];
  int *fd = (int*)arg+1;
  int i;
  int input;

  for (i = -5; i <= 5; i++){
     88c:	8b 45 e0             	mov    -0x20(%ebp),%eax
     88f:	83 c0 01             	add    $0x1,%eax
     892:	83 f8 05             	cmp    $0x5,%eax
     895:	89 45 e0             	mov    %eax,-0x20(%ebp)
     898:	7f 29                	jg     8c3 <pipethreadmain+0x73>
    if (type){
     89a:	85 db                	test   %ebx,%ebx
      read(fd[0], &input, sizeof(int));
     89c:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
     8a3:	00 
  int *fd = (int*)arg+1;
  int i;
  int input;

  for (i = -5; i <= 5; i++){
    if (type){
     8a4:	75 ca                	jne    870 <pipethreadmain+0x20>
      __sync_fetch_and_add(&gcnt, input);
      //gcnt += input;
    } else{
        //ADDED
        //printf(1,"wirte %d\n",i);
      write(fd[1], &i, sizeof(int));
     8a6:	89 7c 24 04          	mov    %edi,0x4(%esp)
     8aa:	8b 46 08             	mov    0x8(%esi),%eax
     8ad:	89 04 24             	mov    %eax,(%esp)
     8b0:	e8 fd 0d 00 00       	call   16b2 <write>
  int type = ((int*)arg)[0];
  int *fd = (int*)arg+1;
  int i;
  int input;

  for (i = -5; i <= 5; i++){
     8b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
     8b8:	83 c0 01             	add    $0x1,%eax
     8bb:	83 f8 05             	cmp    $0x5,%eax
     8be:	89 45 e0             	mov    %eax,-0x20(%ebp)
     8c1:	7e d7                	jle    89a <pipethreadmain+0x4a>
        //ADDED
        //printf(1,"wirte %d\n",i);
      write(fd[1], &i, sizeof(int));
    }
  }
  thread_exit(0);
     8c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     8ca:	e8 93 0e 00 00       	call   1762 <thread_exit>
     8cf:	90                   	nop

000008d0 <stridethreadmain>:

// ============================================================================

void*
stridethreadmain(void *arg)
{
     8d0:	55                   	push   %ebp
     8d1:	89 e5                	mov    %esp,%ebp
     8d3:	53                   	push   %ebx
     8d4:	83 ec 14             	sub    $0x14,%esp
     8d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int *flag = (int*)arg;
  int t;
  while(*flag){
     8da:	8b 03                	mov    (%ebx),%eax
     8dc:	85 c0                	test   %eax,%eax
     8de:	74 27                	je     907 <stridethreadmain+0x37>
    while(*flag == 1){
     8e0:	83 f8 01             	cmp    $0x1,%eax
     8e3:	75 10                	jne    8f5 <stridethreadmain+0x25>
     8e5:	8d 76 00             	lea    0x0(%esi),%esi
      for (t = 0; t < 5; t++);
      __sync_fetch_and_add(&gcnt, 1);
     8e8:	f0 83 05 68 26 00 00 	lock addl $0x1,0x2668
     8ef:	01 
stridethreadmain(void *arg)
{
  int *flag = (int*)arg;
  int t;
  while(*flag){
    while(*flag == 1){
     8f0:	83 3b 01             	cmpl   $0x1,(%ebx)
     8f3:	74 f3                	je     8e8 <stridethreadmain+0x18>
      for (t = 0; t < 5; t++);
      __sync_fetch_and_add(&gcnt, 1);
    }
    //ADDED
    sleep(1);
     8f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     8fc:	e8 29 0e 00 00       	call   172a <sleep>
void*
stridethreadmain(void *arg)
{
  int *flag = (int*)arg;
  int t;
  while(*flag){
     901:	8b 03                	mov    (%ebx),%eax
     903:	85 c0                	test   %eax,%eax
     905:	75 d9                	jne    8e0 <stridethreadmain+0x10>
      __sync_fetch_and_add(&gcnt, 1);
    }
    //ADDED
    sleep(1);
  }
  thread_exit(0);
     907:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     90e:	e8 4f 0e 00 00       	call   1762 <thread_exit>
     913:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000920 <stridetest1>:
}

int
stridetest1(void)
{
     920:	55                   	push   %ebp
     921:	89 e5                	mov    %esp,%ebp
     923:	57                   	push   %edi
     924:	56                   	push   %esi
     925:	53                   	push   %ebx
     926:	83 ec 4c             	sub    $0x4c,%esp
  int i;
  int pid;
  int flag;
  void *retval;

  gcnt = 0;
     929:	c7 05 68 26 00 00 00 	movl   $0x0,0x2668
     930:	00 00 00 
  flag = 2;
     933:	c7 45 b8 02 00 00 00 	movl   $0x2,-0x48(%ebp)
  if ((pid = fork()) == -1){
     93a:	e8 4b 0d 00 00       	call   168a <fork>
     93f:	83 f8 ff             	cmp    $0xffffffff,%eax
     942:	89 45 b4             	mov    %eax,-0x4c(%ebp)
     945:	0f 84 38 01 00 00    	je     a83 <stridetest1+0x163>
    printf(1, "panic at fork in forktest\n");
    exit();
  } else if (pid == 0){
     94b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
     94e:	85 d2                	test   %edx,%edx
     950:	0f 85 ca 00 00 00    	jne    a20 <stridetest1+0x100>
    set_cpu_share(50);
     956:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
     95d:	e8 f0 0d 00 00       	call   1752 <set_cpu_share>
     962:	8d 7d c0             	lea    -0x40(%ebp),%edi
     965:	8d 5d e8             	lea    -0x18(%ebp),%ebx
     968:	8d 75 b8             	lea    -0x48(%ebp),%esi
     96b:	90                   	nop
     96c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  } else{
    set_cpu_share(10);
  }

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], stridethreadmain, (void*)&flag) != 0){
     970:	89 74 24 08          	mov    %esi,0x8(%esp)
     974:	c7 44 24 04 d0 08 00 	movl   $0x8d0,0x4(%esp)
     97b:	00 
     97c:	89 3c 24             	mov    %edi,(%esp)
     97f:	e8 d6 0d 00 00       	call   175a <thread_create>
     984:	85 c0                	test   %eax,%eax
     986:	0f 85 ac 00 00 00    	jne    a38 <stridetest1+0x118>
     98c:	83 c7 04             	add    $0x4,%edi
    set_cpu_share(50);
  } else{
    set_cpu_share(10);
  }

  for (i = 0; i < NUM_THREAD; i++){
     98f:	39 df                	cmp    %ebx,%edi
     991:	75 dd                	jne    970 <stridetest1+0x50>
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  flag = 1;
  sleep(500);
     993:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
     99a:	8d 7d c0             	lea    -0x40(%ebp),%edi
    if (thread_create(&threads[i], stridethreadmain, (void*)&flag) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  flag = 1;
     99d:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
     9a4:	8d 75 bc             	lea    -0x44(%ebp),%esi
  sleep(500);
     9a7:	e8 7e 0d 00 00       	call   172a <sleep>
  flag = 0;
     9ac:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
     9b3:	90                   	nop
     9b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0){
     9b8:	89 74 24 04          	mov    %esi,0x4(%esp)
     9bc:	8b 07                	mov    (%edi),%eax
     9be:	89 04 24             	mov    %eax,(%esp)
     9c1:	e8 a4 0d 00 00       	call   176a <thread_join>
     9c6:	85 c0                	test   %eax,%eax
     9c8:	89 c1                	mov    %eax,%ecx
     9ca:	0f 85 90 00 00 00    	jne    a60 <stridetest1+0x140>
     9d0:	83 c7 04             	add    $0x4,%edi
    }
  }
  flag = 1;
  sleep(500);
  flag = 0;
  for (i = 0; i < NUM_THREAD; i++){
     9d3:	39 df                	cmp    %ebx,%edi
     9d5:	75 e1                	jne    9b8 <stridetest1+0x98>
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }

  if (pid == 0){
     9d7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     9da:	85 c0                	test   %eax,%eax
     9dc:	0f 84 ba 00 00 00    	je     a9c <stridetest1+0x17c>
    printf(1, "50% : %d\n", gcnt);
    exit();
  } else{
    printf(1, "10% : %d\n", gcnt);
     9e2:	a1 68 26 00 00       	mov    0x2668,%eax
     9e7:	c7 44 24 04 d3 1c 00 	movl   $0x1cd3,0x4(%esp)
     9ee:	00 
     9ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9f6:	89 4d b4             	mov    %ecx,-0x4c(%ebp)
     9f9:	89 44 24 08          	mov    %eax,0x8(%esp)
     9fd:	e8 1e 0e 00 00       	call   1820 <printf>
    if (wait() == -1){
     a02:	e8 93 0c 00 00       	call   169a <wait>
     a07:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
     a0a:	83 f8 ff             	cmp    $0xffffffff,%eax
     a0d:	0f 84 ab 00 00 00    	je     abe <stridetest1+0x19e>
      exit();
    }
  }

  return 0;
}
     a13:	83 c4 4c             	add    $0x4c,%esp
     a16:	89 c8                	mov    %ecx,%eax
     a18:	5b                   	pop    %ebx
     a19:	5e                   	pop    %esi
     a1a:	5f                   	pop    %edi
     a1b:	5d                   	pop    %ebp
     a1c:	c3                   	ret    
     a1d:	8d 76 00             	lea    0x0(%esi),%esi
    printf(1, "panic at fork in forktest\n");
    exit();
  } else if (pid == 0){
    set_cpu_share(50);
  } else{
    set_cpu_share(10);
     a20:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
     a27:	e8 26 0d 00 00       	call   1752 <set_cpu_share>
     a2c:	e9 31 ff ff ff       	jmp    962 <stridetest1+0x42>
     a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], stridethreadmain, (void*)&flag) != 0){
      printf(1, "panic at thread_create\n");
     a38:	c7 44 24 04 f1 1b 00 	movl   $0x1bf1,0x4(%esp)
     a3f:	00 
     a40:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a47:	e8 d4 0d 00 00       	call   1820 <printf>
      exit();
    }
  }

  return 0;
}
     a4c:	83 c4 4c             	add    $0x4c,%esp
  }

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], stridethreadmain, (void*)&flag) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
     a4f:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
      exit();
    }
  }

  return 0;
}
     a54:	5b                   	pop    %ebx
     a55:	89 c8                	mov    %ecx,%eax
     a57:	5e                   	pop    %esi
     a58:	5f                   	pop    %edi
     a59:	5d                   	pop    %ebp
     a5a:	c3                   	ret    
     a5b:	90                   	nop
     a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  flag = 1;
  sleep(500);
  flag = 0;
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0){
      printf(1, "panic at thread_join\n");
     a60:	c7 44 24 04 19 1c 00 	movl   $0x1c19,0x4(%esp)
     a67:	00 
     a68:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a6f:	e8 ac 0d 00 00       	call   1820 <printf>
      exit();
    }
  }

  return 0;
}
     a74:	83 c4 4c             	add    $0x4c,%esp
  sleep(500);
  flag = 0;
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0){
      printf(1, "panic at thread_join\n");
      return -1;
     a77:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
      exit();
    }
  }

  return 0;
}
     a7c:	5b                   	pop    %ebx
     a7d:	89 c8                	mov    %ecx,%eax
     a7f:	5e                   	pop    %esi
     a80:	5f                   	pop    %edi
     a81:	5d                   	pop    %ebp
     a82:	c3                   	ret    
  void *retval;

  gcnt = 0;
  flag = 2;
  if ((pid = fork()) == -1){
    printf(1, "panic at fork in forktest\n");
     a83:	c7 44 24 04 ac 1b 00 	movl   $0x1bac,0x4(%esp)
     a8a:	00 
     a8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a92:	e8 89 0d 00 00       	call   1820 <printf>
    exit();
     a97:	e8 f6 0b 00 00       	call   1692 <exit>
      return -1;
    }
  }

  if (pid == 0){
    printf(1, "50% : %d\n", gcnt);
     a9c:	a1 68 26 00 00       	mov    0x2668,%eax
     aa1:	c7 44 24 04 c9 1c 00 	movl   $0x1cc9,0x4(%esp)
     aa8:	00 
     aa9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ab0:	89 44 24 08          	mov    %eax,0x8(%esp)
     ab4:	e8 67 0d 00 00       	call   1820 <printf>
    exit();
     ab9:	e8 d4 0b 00 00       	call   1692 <exit>
  } else{
    printf(1, "10% : %d\n", gcnt);
    if (wait() == -1){
      printf(1, "panic at wait in forktest\n");
     abe:	c7 44 24 04 d6 1b 00 	movl   $0x1bd6,0x4(%esp)
     ac5:	00 
     ac6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     acd:	e8 4e 0d 00 00       	call   1820 <printf>
      exit();
     ad2:	e8 bb 0b 00 00       	call   1692 <exit>
     ad7:	89 f6                	mov    %esi,%esi
     ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000ae0 <stridetest2>:
  return 0;
}

int
stridetest2(void)
{
     ae0:	55                   	push   %ebp
     ae1:	89 e5                	mov    %esp,%ebp
     ae3:	57                   	push   %edi
     ae4:	56                   	push   %esi
     ae5:	53                   	push   %ebx
     ae6:	83 ec 4c             	sub    $0x4c,%esp
  int i;
  int pid;
  int flag;
  void *retval;

  gcnt = 0;
     ae9:	c7 05 68 26 00 00 00 	movl   $0x0,0x2668
     af0:	00 00 00 
  flag = 2;
     af3:	c7 45 b8 02 00 00 00 	movl   $0x2,-0x48(%ebp)
  if ((pid = fork()) == -1){
     afa:	e8 8b 0b 00 00       	call   168a <fork>
     aff:	83 f8 ff             	cmp    $0xffffffff,%eax
     b02:	89 45 b4             	mov    %eax,-0x4c(%ebp)
     b05:	0f 84 38 01 00 00    	je     c43 <stridetest2+0x163>
     b0b:	8d 7d c0             	lea    -0x40(%ebp),%edi
     b0e:	8d 5d e8             	lea    -0x18(%ebp),%ebx
     b11:	8d 75 b8             	lea    -0x48(%ebp),%esi
     b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(1, "panic at fork in forktest\n");
    exit();
  }

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], stridethreadmain, (void*)&flag) != 0){
     b18:	89 74 24 08          	mov    %esi,0x8(%esp)
     b1c:	c7 44 24 04 d0 08 00 	movl   $0x8d0,0x4(%esp)
     b23:	00 
     b24:	89 3c 24             	mov    %edi,(%esp)
     b27:	e8 2e 0c 00 00       	call   175a <thread_create>
     b2c:	85 c0                	test   %eax,%eax
     b2e:	0f 85 c4 00 00 00    	jne    bf8 <stridetest2+0x118>
     b34:	83 c7 04             	add    $0x4,%edi
  if ((pid = fork()) == -1){
    printf(1, "panic at fork in forktest\n");
    exit();
  }

  for (i = 0; i < NUM_THREAD; i++){
     b37:	39 df                	cmp    %ebx,%edi
     b39:	75 dd                	jne    b18 <stridetest2+0x38>
    if (thread_create(&threads[i], stridethreadmain, (void*)&flag) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  if (pid == 0){
     b3b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
     b3e:	85 d2                	test   %edx,%edx
     b40:	0f 84 9a 00 00 00    	je     be0 <stridetest2+0x100>
    set_cpu_share(60);
  } else{
    set_cpu_share(20);
     b46:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     b4d:	e8 00 0c 00 00       	call   1752 <set_cpu_share>
  }
  flag = 1;
  sleep(500);
     b52:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
     b59:	8d 7d c0             	lea    -0x40(%ebp),%edi
  if (pid == 0){
    set_cpu_share(60);
  } else{
    set_cpu_share(20);
  }
  flag = 1;
     b5c:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
     b63:	8d 75 bc             	lea    -0x44(%ebp),%esi
  sleep(500);
     b66:	e8 bf 0b 00 00       	call   172a <sleep>
  flag = 0;
     b6b:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
     b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0){
     b78:	89 74 24 04          	mov    %esi,0x4(%esp)
     b7c:	8b 07                	mov    (%edi),%eax
     b7e:	89 04 24             	mov    %eax,(%esp)
     b81:	e8 e4 0b 00 00       	call   176a <thread_join>
     b86:	85 c0                	test   %eax,%eax
     b88:	89 c1                	mov    %eax,%ecx
     b8a:	0f 85 90 00 00 00    	jne    c20 <stridetest2+0x140>
     b90:	83 c7 04             	add    $0x4,%edi
    set_cpu_share(20);
  }
  flag = 1;
  sleep(500);
  flag = 0;
  for (i = 0; i < NUM_THREAD; i++){
     b93:	39 df                	cmp    %ebx,%edi
     b95:	75 e1                	jne    b78 <stridetest2+0x98>
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }

  if (pid == 0){
     b97:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     b9a:	85 c0                	test   %eax,%eax
     b9c:	0f 84 ba 00 00 00    	je     c5c <stridetest2+0x17c>
    printf(1, "60% : %d\n", gcnt);
    exit();
  } else{
    printf(1, "20% : %d\n", gcnt);
     ba2:	a1 68 26 00 00       	mov    0x2668,%eax
     ba7:	c7 44 24 04 e7 1c 00 	movl   $0x1ce7,0x4(%esp)
     bae:	00 
     baf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     bb6:	89 4d b4             	mov    %ecx,-0x4c(%ebp)
     bb9:	89 44 24 08          	mov    %eax,0x8(%esp)
     bbd:	e8 5e 0c 00 00       	call   1820 <printf>
    if (wait() == -1){
     bc2:	e8 d3 0a 00 00       	call   169a <wait>
     bc7:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
     bca:	83 f8 ff             	cmp    $0xffffffff,%eax
     bcd:	0f 84 ab 00 00 00    	je     c7e <stridetest2+0x19e>
      exit();
    }
  }

  return 0;
}
     bd3:	83 c4 4c             	add    $0x4c,%esp
     bd6:	89 c8                	mov    %ecx,%eax
     bd8:	5b                   	pop    %ebx
     bd9:	5e                   	pop    %esi
     bda:	5f                   	pop    %edi
     bdb:	5d                   	pop    %ebp
     bdc:	c3                   	ret    
     bdd:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  if (pid == 0){
    set_cpu_share(60);
     be0:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
     be7:	e8 66 0b 00 00       	call   1752 <set_cpu_share>
     bec:	e9 61 ff ff ff       	jmp    b52 <stridetest2+0x72>
     bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
  }

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], stridethreadmain, (void*)&flag) != 0){
      printf(1, "panic at thread_create\n");
     bf8:	c7 44 24 04 f1 1b 00 	movl   $0x1bf1,0x4(%esp)
     bff:	00 
     c00:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c07:	e8 14 0c 00 00       	call   1820 <printf>
      exit();
    }
  }

  return 0;
}
     c0c:	83 c4 4c             	add    $0x4c,%esp
  }

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], stridethreadmain, (void*)&flag) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
     c0f:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
      exit();
    }
  }

  return 0;
}
     c14:	5b                   	pop    %ebx
     c15:	89 c8                	mov    %ecx,%eax
     c17:	5e                   	pop    %esi
     c18:	5f                   	pop    %edi
     c19:	5d                   	pop    %ebp
     c1a:	c3                   	ret    
     c1b:	90                   	nop
     c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  flag = 1;
  sleep(500);
  flag = 0;
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0){
      printf(1, "panic at thread_join\n");
     c20:	c7 44 24 04 19 1c 00 	movl   $0x1c19,0x4(%esp)
     c27:	00 
     c28:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c2f:	e8 ec 0b 00 00       	call   1820 <printf>
      exit();
    }
  }

  return 0;
}
     c34:	83 c4 4c             	add    $0x4c,%esp
  sleep(500);
  flag = 0;
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0){
      printf(1, "panic at thread_join\n");
      return -1;
     c37:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
      exit();
    }
  }

  return 0;
}
     c3c:	5b                   	pop    %ebx
     c3d:	89 c8                	mov    %ecx,%eax
     c3f:	5e                   	pop    %esi
     c40:	5f                   	pop    %edi
     c41:	5d                   	pop    %ebp
     c42:	c3                   	ret    
  void *retval;

  gcnt = 0;
  flag = 2;
  if ((pid = fork()) == -1){
    printf(1, "panic at fork in forktest\n");
     c43:	c7 44 24 04 ac 1b 00 	movl   $0x1bac,0x4(%esp)
     c4a:	00 
     c4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c52:	e8 c9 0b 00 00       	call   1820 <printf>
    exit();
     c57:	e8 36 0a 00 00       	call   1692 <exit>
      return -1;
    }
  }

  if (pid == 0){
    printf(1, "60% : %d\n", gcnt);
     c5c:	a1 68 26 00 00       	mov    0x2668,%eax
     c61:	c7 44 24 04 dd 1c 00 	movl   $0x1cdd,0x4(%esp)
     c68:	00 
     c69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c70:	89 44 24 08          	mov    %eax,0x8(%esp)
     c74:	e8 a7 0b 00 00       	call   1820 <printf>
    exit();
     c79:	e8 14 0a 00 00       	call   1692 <exit>
  } else{
    printf(1, "20% : %d\n", gcnt);
    if (wait() == -1){
      printf(1, "panic at wait in forktest\n");
     c7e:	c7 44 24 04 d6 1b 00 	movl   $0x1bd6,0x4(%esp)
     c85:	00 
     c86:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c8d:	e8 8e 0b 00 00       	call   1820 <printf>
      exit();
     c92:	e8 fb 09 00 00       	call   1692 <exit>
     c97:	89 f6                	mov    %esi,%esi
     c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000ca0 <exittest1>:
  thread_exit(0);
}

int
exittest1(void)
{
     ca0:	55                   	push   %ebp
     ca1:	89 e5                	mov    %esp,%ebp
     ca3:	57                   	push   %edi
     ca4:	56                   	push   %esi
     ca5:	53                   	push   %ebx
     ca6:	83 ec 4c             	sub    $0x4c,%esp
     ca9:	8d 5d c0             	lea    -0x40(%ebp),%ebx
     cac:	8d 7d e8             	lea    -0x18(%ebp),%edi
     caf:	90                   	nop
  thread_t threads[NUM_THREAD];
  int i;
  
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], exitthreadmain, (void*)1) != 0){
     cb0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     cb7:	00 
     cb8:	c7 44 24 04 b0 02 00 	movl   $0x2b0,0x4(%esp)
     cbf:	00 
     cc0:	89 1c 24             	mov    %ebx,(%esp)
     cc3:	e8 92 0a 00 00       	call   175a <thread_create>
     cc8:	85 c0                	test   %eax,%eax
     cca:	89 c6                	mov    %eax,%esi
     ccc:	75 22                	jne    cf0 <exittest1+0x50>
     cce:	83 c3 04             	add    $0x4,%ebx
exittest1(void)
{
  thread_t threads[NUM_THREAD];
  int i;
  
  for (i = 0; i < NUM_THREAD; i++){
     cd1:	39 fb                	cmp    %edi,%ebx
     cd3:	75 db                	jne    cb0 <exittest1+0x10>
    if (thread_create(&threads[i], exitthreadmain, (void*)1) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  sleep(1);
     cd5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     cdc:	e8 49 0a 00 00       	call   172a <sleep>
  return 0;
}
     ce1:	83 c4 4c             	add    $0x4c,%esp
     ce4:	89 f0                	mov    %esi,%eax
     ce6:	5b                   	pop    %ebx
     ce7:	5e                   	pop    %esi
     ce8:	5f                   	pop    %edi
     ce9:	5d                   	pop    %ebp
     cea:	c3                   	ret    
     ceb:	90                   	nop
     cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  thread_t threads[NUM_THREAD];
  int i;
  
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], exitthreadmain, (void*)1) != 0){
      printf(1, "panic at thread_create\n");
     cf0:	c7 44 24 04 f1 1b 00 	movl   $0x1bf1,0x4(%esp)
     cf7:	00 
     cf8:	be ff ff ff ff       	mov    $0xffffffff,%esi
     cfd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d04:	e8 17 0b 00 00       	call   1820 <printf>
      return -1;
    }
  }
  sleep(1);
  return 0;
}
     d09:	83 c4 4c             	add    $0x4c,%esp
     d0c:	89 f0                	mov    %esi,%eax
     d0e:	5b                   	pop    %ebx
     d0f:	5e                   	pop    %esi
     d10:	5f                   	pop    %edi
     d11:	5d                   	pop    %ebp
     d12:	c3                   	ret    
     d13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000d20 <sleeptest>:
  thread_exit(0);
}

int
sleeptest(void)
{
     d20:	55                   	push   %ebp
     d21:	89 e5                	mov    %esp,%ebp
     d23:	57                   	push   %edi
     d24:	56                   	push   %esi
     d25:	53                   	push   %ebx
  thread_t threads[NUM_THREAD];
  int i;

  for (i = 0; i < NUM_THREAD; i++){
     d26:	31 db                	xor    %ebx,%ebx
  thread_exit(0);
}

int
sleeptest(void)
{
     d28:	83 ec 4c             	sub    $0x4c,%esp
     d2b:	8d 75 c0             	lea    -0x40(%ebp),%esi
     d2e:	66 90                	xchg   %ax,%ax
  thread_t threads[NUM_THREAD];
  int i;

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], sleepthreadmain, (void*)i) != 0){
     d30:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     d34:	c7 44 24 04 90 03 00 	movl   $0x390,0x4(%esp)
     d3b:	00 
     d3c:	89 34 24             	mov    %esi,(%esp)
     d3f:	e8 16 0a 00 00       	call   175a <thread_create>
     d44:	85 c0                	test   %eax,%eax
     d46:	89 c7                	mov    %eax,%edi
     d48:	75 26                	jne    d70 <sleeptest+0x50>
sleeptest(void)
{
  thread_t threads[NUM_THREAD];
  int i;

  for (i = 0; i < NUM_THREAD; i++){
     d4a:	83 c3 01             	add    $0x1,%ebx
     d4d:	83 c6 04             	add    $0x4,%esi
     d50:	83 fb 0a             	cmp    $0xa,%ebx
     d53:	75 db                	jne    d30 <sleeptest+0x10>
    if (thread_create(&threads[i], sleepthreadmain, (void*)i) != 0){
        printf(1, "panic at thread_create\n");
        return -1;
    }
  }
  sleep(10);
     d55:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
     d5c:	e8 c9 09 00 00       	call   172a <sleep>
  return 0;
}
     d61:	83 c4 4c             	add    $0x4c,%esp
     d64:	89 f8                	mov    %edi,%eax
     d66:	5b                   	pop    %ebx
     d67:	5e                   	pop    %esi
     d68:	5f                   	pop    %edi
     d69:	5d                   	pop    %ebp
     d6a:	c3                   	ret    
     d6b:	90                   	nop
     d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  thread_t threads[NUM_THREAD];
  int i;

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], sleepthreadmain, (void*)i) != 0){
        printf(1, "panic at thread_create\n");
     d70:	c7 44 24 04 f1 1b 00 	movl   $0x1bf1,0x4(%esp)
     d77:	00 
     d78:	bf ff ff ff ff       	mov    $0xffffffff,%edi
     d7d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d84:	e8 97 0a 00 00       	call   1820 <printf>
        return -1;
    }
  }
  sleep(10);
  return 0;
}
     d89:	83 c4 4c             	add    $0x4c,%esp
     d8c:	89 f8                	mov    %edi,%eax
     d8e:	5b                   	pop    %ebx
     d8f:	5e                   	pop    %esi
     d90:	5f                   	pop    %edi
     d91:	5d                   	pop    %ebp
     d92:	c3                   	ret    
     d93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000da0 <racingtest>:
  thread_exit((void *)(tid+1));
}

int
racingtest(void)
{
     da0:	55                   	push   %ebp
     da1:	89 e5                	mov    %esp,%ebp
     da3:	56                   	push   %esi
     da4:	53                   	push   %ebx
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  gcnt = 0;
  
  for (i = 0; i < NUM_THREAD; i++){
     da5:	31 db                	xor    %ebx,%ebx
  thread_exit((void *)(tid+1));
}

int
racingtest(void)
{
     da7:	83 ec 40             	sub    $0x40,%esp
     daa:	8d 75 d0             	lea    -0x30(%ebp),%esi
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  gcnt = 0;
     dad:	c7 05 68 26 00 00 00 	movl   $0x0,0x2668
     db4:	00 00 00 
     db7:	90                   	nop
  
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
     db8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     dbc:	c7 44 24 04 b0 03 00 	movl   $0x3b0,0x4(%esp)
     dc3:	00 
     dc4:	89 34 24             	mov    %esi,(%esp)
     dc7:	e8 8e 09 00 00       	call   175a <thread_create>
     dcc:	85 c0                	test   %eax,%eax
     dce:	75 68                	jne    e38 <racingtest+0x98>
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  gcnt = 0;
  
  for (i = 0; i < NUM_THREAD; i++){
     dd0:	83 c3 01             	add    $0x1,%ebx
     dd3:	83 c6 04             	add    $0x4,%esi
     dd6:	83 fb 0a             	cmp    $0xa,%ebx
     dd9:	75 dd                	jne    db8 <racingtest+0x18>
     ddb:	30 db                	xor    %bl,%bl
     ddd:	8d 75 cc             	lea    -0x34(%ebp),%esi
     de0:	eb 08                	jmp    dea <racingtest+0x4a>
     de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
     de8:	89 d3                	mov    %edx,%ebx
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
     dea:	8b 44 9d d0          	mov    -0x30(%ebp,%ebx,4),%eax
     dee:	89 74 24 04          	mov    %esi,0x4(%esp)
     df2:	89 04 24             	mov    %eax,(%esp)
     df5:	e8 70 09 00 00       	call   176a <thread_join>
     dfa:	85 c0                	test   %eax,%eax
     dfc:	75 5a                	jne    e58 <racingtest+0xb8>
     dfe:	8b 55 cc             	mov    -0x34(%ebp),%edx
     e01:	83 c3 01             	add    $0x1,%ebx
     e04:	39 da                	cmp    %ebx,%edx
     e06:	75 50                	jne    e58 <racingtest+0xb8>
    if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
     e08:	83 fa 0a             	cmp    $0xa,%edx
     e0b:	75 db                	jne    de8 <racingtest+0x48>
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }
  printf(1,"%d\n", gcnt);
     e0d:	8b 15 68 26 00 00    	mov    0x2668,%edx
     e13:	c7 44 24 04 d9 1c 00 	movl   $0x1cd9,0x4(%esp)
     e1a:	00 
     e1b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e22:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     e25:	89 54 24 08          	mov    %edx,0x8(%esp)
     e29:	e8 f2 09 00 00       	call   1820 <printf>
     e2e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  return 0;
}
     e31:	83 c4 40             	add    $0x40,%esp
     e34:	5b                   	pop    %ebx
     e35:	5e                   	pop    %esi
     e36:	5d                   	pop    %ebp
     e37:	c3                   	ret    
  void *retval;
  gcnt = 0;
  
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
     e38:	c7 44 24 04 f1 1b 00 	movl   $0x1bf1,0x4(%esp)
     e3f:	00 
     e40:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e47:	e8 d4 09 00 00       	call   1820 <printf>
      return -1;
    }
  }
  printf(1,"%d\n", gcnt);
  return 0;
}
     e4c:	83 c4 40             	add    $0x40,%esp
  gcnt = 0;
  
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
     e4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
    }
  }
  printf(1,"%d\n", gcnt);
  return 0;
}
     e54:	5b                   	pop    %ebx
     e55:	5e                   	pop    %esi
     e56:	5d                   	pop    %ebp
     e57:	c3                   	ret    
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
      printf(1, "panic at thread_join\n");
     e58:	c7 44 24 04 19 1c 00 	movl   $0x1c19,0x4(%esp)
     e5f:	00 
     e60:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e67:	e8 b4 09 00 00       	call   1820 <printf>
      return -1;
    }
  }
  printf(1,"%d\n", gcnt);
  return 0;
}
     e6c:	83 c4 40             	add    $0x40,%esp
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
      printf(1, "panic at thread_join\n");
     e6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
    }
  }
  printf(1,"%d\n", gcnt);
  return 0;
}
     e74:	5b                   	pop    %ebx
     e75:	5e                   	pop    %esi
     e76:	5d                   	pop    %ebp
     e77:	c3                   	ret    
     e78:	90                   	nop
     e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000e80 <basictest>:
  thread_exit((void *)(tid+1));
}

int
basictest(void)
{
     e80:	55                   	push   %ebp
     e81:	89 e5                	mov    %esp,%ebp
     e83:	56                   	push   %esi
     e84:	53                   	push   %ebx
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 0; i < NUM_THREAD; i++){
     e85:	31 db                	xor    %ebx,%ebx
  thread_exit((void *)(tid+1));
}

int
basictest(void)
{
     e87:	83 ec 40             	sub    $0x40,%esp
     e8a:	8d 75 d0             	lea    -0x30(%ebp),%esi
     e8d:	8d 76 00             	lea    0x0(%esi),%esi
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
     e90:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     e94:	c7 44 24 04 e0 01 00 	movl   $0x1e0,0x4(%esp)
     e9b:	00 
     e9c:	89 34 24             	mov    %esi,(%esp)
     e9f:	e8 b6 08 00 00       	call   175a <thread_create>
     ea4:	85 c0                	test   %eax,%eax
     ea6:	75 60                	jne    f08 <basictest+0x88>
{
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 0; i < NUM_THREAD; i++){
     ea8:	83 c3 01             	add    $0x1,%ebx
     eab:	83 c6 04             	add    $0x4,%esi
     eae:	83 fb 0a             	cmp    $0xa,%ebx
     eb1:	75 dd                	jne    e90 <basictest+0x10>
     eb3:	30 db                	xor    %bl,%bl
     eb5:	8d 75 cc             	lea    -0x34(%ebp),%esi
     eb8:	eb 08                	jmp    ec2 <basictest+0x42>
     eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
     ec0:	89 d3                	mov    %edx,%ebx
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
     ec2:	8b 44 9d d0          	mov    -0x30(%ebp,%ebx,4),%eax
     ec6:	89 74 24 04          	mov    %esi,0x4(%esp)
     eca:	89 04 24             	mov    %eax,(%esp)
     ecd:	e8 98 08 00 00       	call   176a <thread_join>
     ed2:	85 c0                	test   %eax,%eax
     ed4:	75 52                	jne    f28 <basictest+0xa8>
     ed6:	8b 55 cc             	mov    -0x34(%ebp),%edx
     ed9:	83 c3 01             	add    $0x1,%ebx
     edc:	39 da                	cmp    %ebx,%edx
     ede:	75 48                	jne    f28 <basictest+0xa8>
    if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
     ee0:	83 fa 0a             	cmp    $0xa,%edx
     ee3:	75 db                	jne    ec0 <basictest+0x40>
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }
  printf(1,"\n");
     ee5:	c7 44 24 04 17 1c 00 	movl   $0x1c17,0x4(%esp)
     eec:	00 
     eed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ef4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     ef7:	e8 24 09 00 00       	call   1820 <printf>
     efc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  return 0;
}
     eff:	83 c4 40             	add    $0x40,%esp
     f02:	5b                   	pop    %ebx
     f03:	5e                   	pop    %esi
     f04:	5d                   	pop    %ebp
     f05:	c3                   	ret    
     f06:	66 90                	xchg   %ax,%ax
  int i;
  void *retval;
  
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
     f08:	c7 44 24 04 f1 1b 00 	movl   $0x1bf1,0x4(%esp)
     f0f:	00 
     f10:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f17:	e8 04 09 00 00       	call   1820 <printf>
      return -1;
    }
  }
  printf(1,"\n");
  return 0;
}
     f1c:	83 c4 40             	add    $0x40,%esp
  void *retval;
  
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
     f1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
    }
  }
  printf(1,"\n");
  return 0;
}
     f24:	5b                   	pop    %ebx
     f25:	5e                   	pop    %esi
     f26:	5d                   	pop    %ebp
     f27:	c3                   	ret    
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
      printf(1, "panic at thread_join\n");
     f28:	c7 44 24 04 19 1c 00 	movl   $0x1c19,0x4(%esp)
     f2f:	00 
     f30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f37:	e8 e4 08 00 00       	call   1820 <printf>
      return -1;
    }
  }
  printf(1,"\n");
  return 0;
}
     f3c:	83 c4 40             	add    $0x40,%esp
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
      printf(1, "panic at thread_join\n");
     f3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
    }
  }
  printf(1,"\n");
  return 0;
}
     f44:	5b                   	pop    %ebx
     f45:	5e                   	pop    %esi
     f46:	5d                   	pop    %ebp
     f47:	c3                   	ret    
     f48:	90                   	nop
     f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000f50 <jointest1>:
  thread_exit((void *)(val*2));
}

int
jointest1(void)
{
     f50:	55                   	push   %ebp
     f51:	89 e5                	mov    %esp,%ebp
     f53:	56                   	push   %esi
     f54:	53                   	push   %ebx
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
     f55:	bb 01 00 00 00       	mov    $0x1,%ebx
  thread_exit((void *)(val*2));
}

int
jointest1(void)
{
     f5a:	83 ec 40             	sub    $0x40,%esp
     f5d:	8d 75 d0             	lea    -0x30(%ebp),%esi
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_create(&threads[i-1], jointhreadmain, (void*)i) != 0){
     f60:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     f64:	c7 44 24 04 50 02 00 	movl   $0x250,0x4(%esp)
     f6b:	00 
     f6c:	89 34 24             	mov    %esi,(%esp)
     f6f:	e8 e6 07 00 00       	call   175a <thread_create>
     f74:	85 c0                	test   %eax,%eax
     f76:	75 70                	jne    fe8 <jointest1+0x98>
{
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
     f78:	83 c3 01             	add    $0x1,%ebx
     f7b:	83 c6 04             	add    $0x4,%esi
     f7e:	83 fb 0b             	cmp    $0xb,%ebx
     f81:	75 dd                	jne    f60 <jointest1+0x10>
    if (thread_create(&threads[i-1], jointhreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  printf(1, "thread_join!!!\n");
     f83:	c7 44 24 04 09 1c 00 	movl   $0x1c09,0x4(%esp)
     f8a:	00 
     f8b:	b3 02                	mov    $0x2,%bl
     f8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f94:	8d 75 cc             	lea    -0x34(%ebp),%esi
     f97:	e8 84 08 00 00       	call   1820 <printf>
     f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
     fa0:	8b 44 5d cc          	mov    -0x34(%ebp,%ebx,2),%eax
     fa4:	89 74 24 04          	mov    %esi,0x4(%esp)
     fa8:	89 04 24             	mov    %eax,(%esp)
     fab:	e8 ba 07 00 00       	call   176a <thread_join>
     fb0:	85 c0                	test   %eax,%eax
     fb2:	75 54                	jne    1008 <jointest1+0xb8>
     fb4:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
     fb7:	75 4f                	jne    1008 <jointest1+0xb8>
     fb9:	83 c3 02             	add    $0x2,%ebx
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  printf(1, "thread_join!!!\n");
  for (i = 1; i <= NUM_THREAD; i++){
     fbc:	83 fb 16             	cmp    $0x16,%ebx
     fbf:	75 df                	jne    fa0 <jointest1+0x50>
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }
  printf(1,"\n");
     fc1:	c7 44 24 04 17 1c 00 	movl   $0x1c17,0x4(%esp)
     fc8:	00 
     fc9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fd0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     fd3:	e8 48 08 00 00       	call   1820 <printf>
     fd8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  return 0;
}
     fdb:	83 c4 40             	add    $0x40,%esp
     fde:	5b                   	pop    %ebx
     fdf:	5e                   	pop    %esi
     fe0:	5d                   	pop    %ebp
     fe1:	c3                   	ret    
     fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_create(&threads[i-1], jointhreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
     fe8:	c7 44 24 04 f1 1b 00 	movl   $0x1bf1,0x4(%esp)
     fef:	00 
     ff0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ff7:	e8 24 08 00 00       	call   1820 <printf>
      return -1;
    }
  }
  printf(1,"\n");
  return 0;
}
     ffc:	83 c4 40             	add    $0x40,%esp
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_create(&threads[i-1], jointhreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
     fff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
    }
  }
  printf(1,"\n");
  return 0;
}
    1004:	5b                   	pop    %ebx
    1005:	5e                   	pop    %esi
    1006:	5d                   	pop    %ebp
    1007:	c3                   	ret    
    }
  }
  printf(1, "thread_join!!!\n");
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
      printf(1, "panic at thread_join\n");
    1008:	c7 44 24 04 19 1c 00 	movl   $0x1c19,0x4(%esp)
    100f:	00 
    1010:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1017:	e8 04 08 00 00       	call   1820 <printf>
      return -1;
    }
  }
  printf(1,"\n");
  return 0;
}
    101c:	83 c4 40             	add    $0x40,%esp
    }
  }
  printf(1, "thread_join!!!\n");
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
      printf(1, "panic at thread_join\n");
    101f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
    }
  }
  printf(1,"\n");
  return 0;
}
    1024:	5b                   	pop    %ebx
    1025:	5e                   	pop    %esi
    1026:	5d                   	pop    %ebp
    1027:	c3                   	ret    
    1028:	90                   	nop
    1029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001030 <stresstest>:
  thread_exit(0);
}

int
stresstest(void)
{
    1030:	55                   	push   %ebp
    1031:	89 e5                	mov    %esp,%ebp
    1033:	57                   	push   %edi
    1034:	56                   	push   %esi
    1035:	53                   	push   %ebx
    1036:	83 ec 4c             	sub    $0x4c,%esp
    1039:	8d 5d bc             	lea    -0x44(%ebp),%ebx
  const int nstress = 35000;
  thread_t threads[NUM_THREAD];
  int i, n;
  void *retval;

  for (n = 1; n <= nstress; n++){
    103c:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
    1043:	8d 75 c0             	lea    -0x40(%ebp),%esi
    1046:	31 ff                	xor    %edi,%edi
    if (n % 1000 == 0)
      printf(1, "%d\n", n);
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_create(&threads[i], stressthreadmain, (void*)i) != 0){
    1048:	89 7c 24 08          	mov    %edi,0x8(%esp)
    104c:	c7 44 24 04 90 02 00 	movl   $0x290,0x4(%esp)
    1053:	00 
    1054:	89 34 24             	mov    %esi,(%esp)
    1057:	e8 fe 06 00 00       	call   175a <thread_create>
    105c:	85 c0                	test   %eax,%eax
    105e:	0f 85 8c 00 00 00    	jne    10f0 <stresstest+0xc0>
  void *retval;

  for (n = 1; n <= nstress; n++){
    if (n % 1000 == 0)
      printf(1, "%d\n", n);
    for (i = 0; i < NUM_THREAD; i++){
    1064:	83 c7 01             	add    $0x1,%edi
    1067:	83 c6 04             	add    $0x4,%esi
    106a:	83 ff 0a             	cmp    $0xa,%edi
    106d:	75 d9                	jne    1048 <stresstest+0x18>
    106f:	8d 7d c0             	lea    -0x40(%ebp),%edi
    1072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printf(1, "panic at thread_create\n");
        return -1;
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_join(threads[i], &retval) != 0){
    1078:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    107c:	8b 07                	mov    (%edi),%eax
    107e:	89 04 24             	mov    %eax,(%esp)
    1081:	e8 e4 06 00 00       	call   176a <thread_join>
    1086:	85 c0                	test   %eax,%eax
    1088:	0f 85 8a 00 00 00    	jne    1118 <stresstest+0xe8>
    108e:	83 c7 04             	add    $0x4,%edi
      if (thread_create(&threads[i], stressthreadmain, (void*)i) != 0){
        printf(1, "panic at thread_create\n");
        return -1;
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
    1091:	8d 4d e8             	lea    -0x18(%ebp),%ecx
    1094:	39 cf                	cmp    %ecx,%edi
    1096:	75 e0                	jne    1078 <stresstest+0x48>
  const int nstress = 35000;
  thread_t threads[NUM_THREAD];
  int i, n;
  void *retval;

  for (n = 1; n <= nstress; n++){
    1098:	83 45 b4 01          	addl   $0x1,-0x4c(%ebp)
    109c:	81 7d b4 b9 88 00 00 	cmpl   $0x88b9,-0x4c(%ebp)
    10a3:	0f 84 90 00 00 00    	je     1139 <stresstest+0x109>
    if (n % 1000 == 0)
    10a9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    10ac:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    10b1:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
    10b4:	f7 ea                	imul   %edx
    10b6:	89 c8                	mov    %ecx,%eax
    10b8:	c1 f8 1f             	sar    $0x1f,%eax
    10bb:	c1 fa 06             	sar    $0x6,%edx
    10be:	29 c2                	sub    %eax,%edx
    10c0:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    10c6:	39 d1                	cmp    %edx,%ecx
    10c8:	0f 85 75 ff ff ff    	jne    1043 <stresstest+0x13>
      printf(1, "%d\n", n);
    10ce:	89 4c 24 08          	mov    %ecx,0x8(%esp)
    10d2:	c7 44 24 04 d9 1c 00 	movl   $0x1cd9,0x4(%esp)
    10d9:	00 
    10da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10e1:	e8 3a 07 00 00       	call   1820 <printf>
    10e6:	e9 58 ff ff ff       	jmp    1043 <stresstest+0x13>
    10eb:	90                   	nop
    10ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_create(&threads[i], stressthreadmain, (void*)i) != 0){
        printf(1, "panic at thread_create\n");
    10f0:	c7 44 24 04 f1 1b 00 	movl   $0x1bf1,0x4(%esp)
    10f7:	00 
    10f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10ff:	e8 1c 07 00 00       	call   1820 <printf>
        return -1;
    1104:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      }
    }
  }
  printf(1, "\n");
  return 0;
}
    1109:	83 c4 4c             	add    $0x4c,%esp
    110c:	5b                   	pop    %ebx
    110d:	5e                   	pop    %esi
    110e:	5f                   	pop    %edi
    110f:	5d                   	pop    %ebp
    1110:	c3                   	ret    
    1111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_join(threads[i], &retval) != 0){
        printf(1, "panic at thread_join\n");
    1118:	c7 44 24 04 19 1c 00 	movl   $0x1c19,0x4(%esp)
    111f:	00 
    1120:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1127:	e8 f4 06 00 00       	call   1820 <printf>
      }
    }
  }
  printf(1, "\n");
  return 0;
}
    112c:	83 c4 4c             	add    $0x4c,%esp
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_join(threads[i], &retval) != 0){
        printf(1, "panic at thread_join\n");
        return -1;
    112f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      }
    }
  }
  printf(1, "\n");
  return 0;
}
    1134:	5b                   	pop    %ebx
    1135:	5e                   	pop    %esi
    1136:	5f                   	pop    %edi
    1137:	5d                   	pop    %ebp
    1138:	c3                   	ret    
        printf(1, "panic at thread_join\n");
        return -1;
      }
    }
  }
  printf(1, "\n");
    1139:	c7 44 24 04 17 1c 00 	movl   $0x1c17,0x4(%esp)
    1140:	00 
    1141:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1148:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    114b:	e8 d0 06 00 00       	call   1820 <printf>
    1150:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    1153:	eb b4                	jmp    1109 <stresstest+0xd9>
    1155:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001160 <forktest>:
  thread_exit(0);
}

int
forktest(void)
{
    1160:	55                   	push   %ebp
    1161:	89 e5                	mov    %esp,%ebp
    1163:	57                   	push   %edi
    1164:	56                   	push   %esi
    1165:	53                   	push   %ebx
    1166:	83 ec 4c             	sub    $0x4c,%esp
    1169:	8d 5d c0             	lea    -0x40(%ebp),%ebx
    116c:	8d 75 e8             	lea    -0x18(%ebp),%esi
    116f:	90                   	nop
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], forkthreadmain, (void*)0) != 0){
    1170:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    1177:	00 
    1178:	c7 44 24 04 00 03 00 	movl   $0x300,0x4(%esp)
    117f:	00 
    1180:	89 1c 24             	mov    %ebx,(%esp)
    1183:	e8 d2 05 00 00       	call   175a <thread_create>
    1188:	85 c0                	test   %eax,%eax
    118a:	75 3c                	jne    11c8 <forktest+0x68>
    118c:	83 c3 04             	add    $0x4,%ebx
{
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
    118f:	39 f3                	cmp    %esi,%ebx
    1191:	75 dd                	jne    1170 <forktest+0x10>
    1193:	8d 5d c0             	lea    -0x40(%ebp),%ebx
    1196:	8d 7d bc             	lea    -0x44(%ebp),%edi
    1199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0){
    11a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
    11a4:	8b 03                	mov    (%ebx),%eax
    11a6:	89 04 24             	mov    %eax,(%esp)
    11a9:	e8 bc 05 00 00       	call   176a <thread_join>
    11ae:	85 c0                	test   %eax,%eax
    11b0:	75 3e                	jne    11f0 <forktest+0x90>
    11b2:	83 c3 04             	add    $0x4,%ebx
    if (thread_create(&threads[i], forkthreadmain, (void*)0) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    11b5:	39 f3                	cmp    %esi,%ebx
    11b7:	75 e7                	jne    11a0 <forktest+0x40>
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }
  return 0;
}
    11b9:	83 c4 4c             	add    $0x4c,%esp
    11bc:	5b                   	pop    %ebx
    11bd:	5e                   	pop    %esi
    11be:	5f                   	pop    %edi
    11bf:	5d                   	pop    %ebp
    11c0:	c3                   	ret    
    11c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int i;
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], forkthreadmain, (void*)0) != 0){
      printf(1, "panic at thread_create\n");
    11c8:	c7 44 24 04 f1 1b 00 	movl   $0x1bf1,0x4(%esp)
    11cf:	00 
    11d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11d7:	e8 44 06 00 00       	call   1820 <printf>
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }
  return 0;
}
    11dc:	83 c4 4c             	add    $0x4c,%esp
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], forkthreadmain, (void*)0) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    11df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }
  return 0;
}
    11e4:	5b                   	pop    %ebx
    11e5:	5e                   	pop    %esi
    11e6:	5f                   	pop    %edi
    11e7:	5d                   	pop    %ebp
    11e8:	c3                   	ret    
    11e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0){
      printf(1, "panic at thread_join\n");
    11f0:	c7 44 24 04 19 1c 00 	movl   $0x1c19,0x4(%esp)
    11f7:	00 
    11f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11ff:	e8 1c 06 00 00       	call   1820 <printf>
      return -1;
    }
  }
  return 0;
}
    1204:	83 c4 4c             	add    $0x4c,%esp
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0){
      printf(1, "panic at thread_join\n");
    1207:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
    }
  }
  return 0;
}
    120c:	5b                   	pop    %ebx
    120d:	5e                   	pop    %esi
    120e:	5f                   	pop    %edi
    120f:	5d                   	pop    %ebp
    1210:	c3                   	ret    
    1211:	eb 0d                	jmp    1220 <exectest>
    1213:	90                   	nop
    1214:	90                   	nop
    1215:	90                   	nop
    1216:	90                   	nop
    1217:	90                   	nop
    1218:	90                   	nop
    1219:	90                   	nop
    121a:	90                   	nop
    121b:	90                   	nop
    121c:	90                   	nop
    121d:	90                   	nop
    121e:	90                   	nop
    121f:	90                   	nop

00001220 <exectest>:
  exit();
}

int
exectest(void)
{
    1220:	55                   	push   %ebp
    1221:	89 e5                	mov    %esp,%ebp
    1223:	57                   	push   %edi
    1224:	56                   	push   %esi
    1225:	53                   	push   %ebx
    1226:	83 ec 4c             	sub    $0x4c,%esp
    1229:	8d 5d c0             	lea    -0x40(%ebp),%ebx
    122c:	8d 75 e8             	lea    -0x18(%ebp),%esi
    122f:	90                   	nop
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], execthreadmain, (void*)0) != 0){
    1230:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    1237:	00 
    1238:	c7 44 24 04 50 07 00 	movl   $0x750,0x4(%esp)
    123f:	00 
    1240:	89 1c 24             	mov    %ebx,(%esp)
    1243:	e8 12 05 00 00       	call   175a <thread_create>
    1248:	85 c0                	test   %eax,%eax
    124a:	75 54                	jne    12a0 <exectest+0x80>
    124c:	83 c3 04             	add    $0x4,%ebx
{
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
    124f:	39 f3                	cmp    %esi,%ebx
    1251:	75 dd                	jne    1230 <exectest+0x10>
    1253:	8d 5d c0             	lea    -0x40(%ebp),%ebx
    1256:	8d 7d bc             	lea    -0x44(%ebp),%edi
    1259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0){
    1260:	89 7c 24 04          	mov    %edi,0x4(%esp)
    1264:	8b 03                	mov    (%ebx),%eax
    1266:	89 04 24             	mov    %eax,(%esp)
    1269:	e8 fc 04 00 00       	call   176a <thread_join>
    126e:	85 c0                	test   %eax,%eax
    1270:	75 56                	jne    12c8 <exectest+0xa8>
    1272:	83 c3 04             	add    $0x4,%ebx
    if (thread_create(&threads[i], execthreadmain, (void*)0) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    1275:	39 f3                	cmp    %esi,%ebx
    1277:	75 e7                	jne    1260 <exectest+0x40>
    if (thread_join(threads[i], &retval) != 0){
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }
  printf(1, "panic at exectest\n");
    1279:	c7 44 24 04 f1 1c 00 	movl   $0x1cf1,0x4(%esp)
    1280:	00 
    1281:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1288:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    128b:	e8 90 05 00 00       	call   1820 <printf>
    1290:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  return 0;
}
    1293:	83 c4 4c             	add    $0x4c,%esp
    1296:	5b                   	pop    %ebx
    1297:	5e                   	pop    %esi
    1298:	5f                   	pop    %edi
    1299:	5d                   	pop    %ebp
    129a:	c3                   	ret    
    129b:	90                   	nop
    129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int i;
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], execthreadmain, (void*)0) != 0){
      printf(1, "panic at thread_create\n");
    12a0:	c7 44 24 04 f1 1b 00 	movl   $0x1bf1,0x4(%esp)
    12a7:	00 
    12a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12af:	e8 6c 05 00 00       	call   1820 <printf>
      return -1;
    }
  }
  printf(1, "panic at exectest\n");
  return 0;
}
    12b4:	83 c4 4c             	add    $0x4c,%esp
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], execthreadmain, (void*)0) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    12b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
    }
  }
  printf(1, "panic at exectest\n");
  return 0;
}
    12bc:	5b                   	pop    %ebx
    12bd:	5e                   	pop    %esi
    12be:	5f                   	pop    %edi
    12bf:	5d                   	pop    %ebp
    12c0:	c3                   	ret    
    12c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0){
      printf(1, "panic at thread_join\n");
    12c8:	c7 44 24 04 19 1c 00 	movl   $0x1c19,0x4(%esp)
    12cf:	00 
    12d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12d7:	e8 44 05 00 00       	call   1820 <printf>
      return -1;
    }
  }
  printf(1, "panic at exectest\n");
  return 0;
}
    12dc:	83 c4 4c             	add    $0x4c,%esp
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0){
      printf(1, "panic at thread_join\n");
    12df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
    }
  }
  printf(1, "panic at exectest\n");
  return 0;
}
    12e4:	5b                   	pop    %ebx
    12e5:	5e                   	pop    %esi
    12e6:	5f                   	pop    %edi
    12e7:	5d                   	pop    %ebp
    12e8:	c3                   	ret    
    12e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000012f0 <sbrktest>:
  thread_exit(0);
}

int
sbrktest(void)
{
    12f0:	55                   	push   %ebp
    12f1:	89 e5                	mov    %esp,%ebp
    12f3:	57                   	push   %edi
    12f4:	56                   	push   %esi
    12f5:	53                   	push   %ebx
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
    12f6:	31 db                	xor    %ebx,%ebx
  thread_exit(0);
}

int
sbrktest(void)
{
    12f8:	83 ec 4c             	sub    $0x4c,%esp
    12fb:	8d 75 c0             	lea    -0x40(%ebp),%esi
    12fe:	66 90                	xchg   %ax,%ax
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], sbrkthreadmain, (void*)i) != 0){
    1300:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    1304:	c7 44 24 04 b0 07 00 	movl   $0x7b0,0x4(%esp)
    130b:	00 
    130c:	89 34 24             	mov    %esi,(%esp)
    130f:	e8 46 04 00 00       	call   175a <thread_create>
    1314:	85 c0                	test   %eax,%eax
    1316:	75 40                	jne    1358 <sbrktest+0x68>
{
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
    1318:	83 c3 01             	add    $0x1,%ebx
    131b:	83 c6 04             	add    $0x4,%esi
    131e:	83 fb 0a             	cmp    $0xa,%ebx
    1321:	75 dd                	jne    1300 <sbrktest+0x10>
    1323:	8d 5d c0             	lea    -0x40(%ebp),%ebx
    1326:	8d 7d e8             	lea    -0x18(%ebp),%edi
    1329:	8d 75 bc             	lea    -0x44(%ebp),%esi
    132c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0){
    1330:	89 74 24 04          	mov    %esi,0x4(%esp)
    1334:	8b 03                	mov    (%ebx),%eax
    1336:	89 04 24             	mov    %eax,(%esp)
    1339:	e8 2c 04 00 00       	call   176a <thread_join>
    133e:	85 c0                	test   %eax,%eax
    1340:	75 3e                	jne    1380 <sbrktest+0x90>
    1342:	83 c3 04             	add    $0x4,%ebx
    if (thread_create(&threads[i], sbrkthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    1345:	39 fb                	cmp    %edi,%ebx
    1347:	75 e7                	jne    1330 <sbrktest+0x40>
      return -1;
    }
  }

  return 0;
}
    1349:	83 c4 4c             	add    $0x4c,%esp
    134c:	5b                   	pop    %ebx
    134d:	5e                   	pop    %esi
    134e:	5f                   	pop    %edi
    134f:	5d                   	pop    %ebp
    1350:	c3                   	ret    
    1351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int i;
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], sbrkthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
    1358:	c7 44 24 04 f1 1b 00 	movl   $0x1bf1,0x4(%esp)
    135f:	00 
    1360:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1367:	e8 b4 04 00 00       	call   1820 <printf>
      return -1;
    }
  }

  return 0;
}
    136c:	83 c4 4c             	add    $0x4c,%esp
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], sbrkthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    136f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
    }
  }

  return 0;
}
    1374:	5b                   	pop    %ebx
    1375:	5e                   	pop    %esi
    1376:	5f                   	pop    %edi
    1377:	5d                   	pop    %ebp
    1378:	c3                   	ret    
    1379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0){
      printf(1, "panic at thread_join\n");
    1380:	c7 44 24 04 19 1c 00 	movl   $0x1c19,0x4(%esp)
    1387:	00 
    1388:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    138f:	e8 8c 04 00 00       	call   1820 <printf>
      return -1;
    }
  }

  return 0;
}
    1394:	83 c4 4c             	add    $0x4c,%esp
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0){
      printf(1, "panic at thread_join\n");
    1397:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
    }
  }

  return 0;
}
    139c:	5b                   	pop    %ebx
    139d:	5e                   	pop    %esi
    139e:	5f                   	pop    %edi
    139f:	5d                   	pop    %ebp
    13a0:	c3                   	ret    
    13a1:	eb 0d                	jmp    13b0 <killtest>
    13a3:	90                   	nop
    13a4:	90                   	nop
    13a5:	90                   	nop
    13a6:	90                   	nop
    13a7:	90                   	nop
    13a8:	90                   	nop
    13a9:	90                   	nop
    13aa:	90                   	nop
    13ab:	90                   	nop
    13ac:	90                   	nop
    13ad:	90                   	nop
    13ae:	90                   	nop
    13af:	90                   	nop

000013b0 <killtest>:
  while(1);
}

int
killtest(void)
{
    13b0:	55                   	push   %ebp
    13b1:	89 e5                	mov    %esp,%ebp
    13b3:	57                   	push   %edi
    13b4:	56                   	push   %esi
    13b5:	53                   	push   %ebx
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
    13b6:	31 db                	xor    %ebx,%ebx
  while(1);
}

int
killtest(void)
{
    13b8:	83 ec 4c             	sub    $0x4c,%esp
    13bb:	8d 75 c0             	lea    -0x40(%ebp),%esi
    13be:	eb 0b                	jmp    13cb <killtest+0x1b>
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
    13c0:	83 c3 01             	add    $0x1,%ebx
    13c3:	83 c6 04             	add    $0x4,%esi
    13c6:	83 fb 0a             	cmp    $0xa,%ebx
    13c9:	74 3d                	je     1408 <killtest+0x58>
    if (thread_create(&threads[i], killthreadmain, (void*)i) != 0){
    13cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    13cf:	c7 44 24 04 30 08 00 	movl   $0x830,0x4(%esp)
    13d6:	00 
    13d7:	89 34 24             	mov    %esi,(%esp)
    13da:	e8 7b 03 00 00       	call   175a <thread_create>
    13df:	85 c0                	test   %eax,%eax
    13e1:	74 dd                	je     13c0 <killtest+0x10>
      printf(1, "panic at thread_create\n");
    13e3:	c7 44 24 04 f1 1b 00 	movl   $0x1bf1,0x4(%esp)
    13ea:	00 
    13eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13f2:	e8 29 04 00 00       	call   1820 <printf>
      return -1;
    }
  }
  while(1);
  return 0;
}
    13f7:	83 c4 4c             	add    $0x4c,%esp
    13fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    13ff:	5b                   	pop    %ebx
    1400:	5e                   	pop    %esi
    1401:	5f                   	pop    %edi
    1402:	5d                   	pop    %ebp
    1403:	c3                   	ret    
    1404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1408:	8d 5d c0             	lea    -0x40(%ebp),%ebx
    140b:	8d 75 e8             	lea    -0x18(%ebp),%esi
    140e:	8d 7d bc             	lea    -0x44(%ebp),%edi
    1411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0){
    1418:	89 7c 24 04          	mov    %edi,0x4(%esp)
    141c:	8b 03                	mov    (%ebx),%eax
    141e:	89 04 24             	mov    %eax,(%esp)
    1421:	e8 44 03 00 00       	call   176a <thread_join>
    1426:	85 c0                	test   %eax,%eax
    1428:	75 09                	jne    1433 <killtest+0x83>
    142a:	83 c3 04             	add    $0x4,%ebx
    if (thread_create(&threads[i], killthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    142d:	39 f3                	cmp    %esi,%ebx
    142f:	75 e7                	jne    1418 <killtest+0x68>
    1431:	eb fe                	jmp    1431 <killtest+0x81>
    if (thread_join(threads[i], &retval) != 0){
      printf(1, "panic at thread_join\n");
    1433:	c7 44 24 04 19 1c 00 	movl   $0x1c19,0x4(%esp)
    143a:	00 
    143b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1442:	e8 d9 03 00 00       	call   1820 <printf>
      return -1;
    }
  }
  while(1);
  return 0;
}
    1447:	83 c4 4c             	add    $0x4c,%esp
    144a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    144f:	5b                   	pop    %ebx
    1450:	5e                   	pop    %esi
    1451:	5f                   	pop    %edi
    1452:	5d                   	pop    %ebp
    1453:	c3                   	ret    
    1454:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    145a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00001460 <nop>:
  }
  exit();
}

// ============================================================================
void nop(){ }
    1460:	55                   	push   %ebp
    1461:	89 e5                	mov    %esp,%ebp
    1463:	5d                   	pop    %ebp
    1464:	c3                   	ret    
    1465:	66 90                	xchg   %ax,%ax
    1467:	66 90                	xchg   %ax,%ax
    1469:	66 90                	xchg   %ax,%ax
    146b:	66 90                	xchg   %ax,%ax
    146d:	66 90                	xchg   %ax,%ax
    146f:	90                   	nop

00001470 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1470:	55                   	push   %ebp
    1471:	89 e5                	mov    %esp,%ebp
    1473:	8b 45 08             	mov    0x8(%ebp),%eax
    1476:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1479:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    147a:	89 c2                	mov    %eax,%edx
    147c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1480:	83 c1 01             	add    $0x1,%ecx
    1483:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    1487:	83 c2 01             	add    $0x1,%edx
    148a:	84 db                	test   %bl,%bl
    148c:	88 5a ff             	mov    %bl,-0x1(%edx)
    148f:	75 ef                	jne    1480 <strcpy+0x10>
    ;
  return os;
}
    1491:	5b                   	pop    %ebx
    1492:	5d                   	pop    %ebp
    1493:	c3                   	ret    
    1494:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    149a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000014a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    14a0:	55                   	push   %ebp
    14a1:	89 e5                	mov    %esp,%ebp
    14a3:	8b 55 08             	mov    0x8(%ebp),%edx
    14a6:	53                   	push   %ebx
    14a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    14aa:	0f b6 02             	movzbl (%edx),%eax
    14ad:	84 c0                	test   %al,%al
    14af:	74 2d                	je     14de <strcmp+0x3e>
    14b1:	0f b6 19             	movzbl (%ecx),%ebx
    14b4:	38 d8                	cmp    %bl,%al
    14b6:	74 0e                	je     14c6 <strcmp+0x26>
    14b8:	eb 2b                	jmp    14e5 <strcmp+0x45>
    14ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    14c0:	38 c8                	cmp    %cl,%al
    14c2:	75 15                	jne    14d9 <strcmp+0x39>
    p++, q++;
    14c4:	89 d9                	mov    %ebx,%ecx
    14c6:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    14c9:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
    14cc:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    14cf:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
    14d3:	84 c0                	test   %al,%al
    14d5:	75 e9                	jne    14c0 <strcmp+0x20>
    14d7:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
    14d9:	29 c8                	sub    %ecx,%eax
}
    14db:	5b                   	pop    %ebx
    14dc:	5d                   	pop    %ebp
    14dd:	c3                   	ret    
    14de:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    14e1:	31 c0                	xor    %eax,%eax
    14e3:	eb f4                	jmp    14d9 <strcmp+0x39>
    14e5:	0f b6 cb             	movzbl %bl,%ecx
    14e8:	eb ef                	jmp    14d9 <strcmp+0x39>
    14ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000014f0 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
    14f0:	55                   	push   %ebp
    14f1:	89 e5                	mov    %esp,%ebp
    14f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    14f6:	80 39 00             	cmpb   $0x0,(%ecx)
    14f9:	74 12                	je     150d <strlen+0x1d>
    14fb:	31 d2                	xor    %edx,%edx
    14fd:	8d 76 00             	lea    0x0(%esi),%esi
    1500:	83 c2 01             	add    $0x1,%edx
    1503:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    1507:	89 d0                	mov    %edx,%eax
    1509:	75 f5                	jne    1500 <strlen+0x10>
    ;
  return n;
}
    150b:	5d                   	pop    %ebp
    150c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
    150d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
    150f:	5d                   	pop    %ebp
    1510:	c3                   	ret    
    1511:	eb 0d                	jmp    1520 <memset>
    1513:	90                   	nop
    1514:	90                   	nop
    1515:	90                   	nop
    1516:	90                   	nop
    1517:	90                   	nop
    1518:	90                   	nop
    1519:	90                   	nop
    151a:	90                   	nop
    151b:	90                   	nop
    151c:	90                   	nop
    151d:	90                   	nop
    151e:	90                   	nop
    151f:	90                   	nop

00001520 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1520:	55                   	push   %ebp
    1521:	89 e5                	mov    %esp,%ebp
    1523:	8b 55 08             	mov    0x8(%ebp),%edx
    1526:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1527:	8b 4d 10             	mov    0x10(%ebp),%ecx
    152a:	8b 45 0c             	mov    0xc(%ebp),%eax
    152d:	89 d7                	mov    %edx,%edi
    152f:	fc                   	cld    
    1530:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1532:	89 d0                	mov    %edx,%eax
    1534:	5f                   	pop    %edi
    1535:	5d                   	pop    %ebp
    1536:	c3                   	ret    
    1537:	89 f6                	mov    %esi,%esi
    1539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001540 <strchr>:

char*
strchr(const char *s, char c)
{
    1540:	55                   	push   %ebp
    1541:	89 e5                	mov    %esp,%ebp
    1543:	8b 45 08             	mov    0x8(%ebp),%eax
    1546:	53                   	push   %ebx
    1547:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
    154a:	0f b6 18             	movzbl (%eax),%ebx
    154d:	84 db                	test   %bl,%bl
    154f:	74 1d                	je     156e <strchr+0x2e>
    if(*s == c)
    1551:	38 d3                	cmp    %dl,%bl
    1553:	89 d1                	mov    %edx,%ecx
    1555:	75 0d                	jne    1564 <strchr+0x24>
    1557:	eb 17                	jmp    1570 <strchr+0x30>
    1559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1560:	38 ca                	cmp    %cl,%dl
    1562:	74 0c                	je     1570 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1564:	83 c0 01             	add    $0x1,%eax
    1567:	0f b6 10             	movzbl (%eax),%edx
    156a:	84 d2                	test   %dl,%dl
    156c:	75 f2                	jne    1560 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
    156e:	31 c0                	xor    %eax,%eax
}
    1570:	5b                   	pop    %ebx
    1571:	5d                   	pop    %ebp
    1572:	c3                   	ret    
    1573:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001580 <gets>:

char*
gets(char *buf, int max)
{
    1580:	55                   	push   %ebp
    1581:	89 e5                	mov    %esp,%ebp
    1583:	57                   	push   %edi
    1584:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1585:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
    1587:	53                   	push   %ebx
    1588:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    158b:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    158e:	eb 31                	jmp    15c1 <gets+0x41>
    cc = read(0, &c, 1);
    1590:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1597:	00 
    1598:	89 7c 24 04          	mov    %edi,0x4(%esp)
    159c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    15a3:	e8 02 01 00 00       	call   16aa <read>
    if(cc < 1)
    15a8:	85 c0                	test   %eax,%eax
    15aa:	7e 1d                	jle    15c9 <gets+0x49>
      break;
    buf[i++] = c;
    15ac:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    15b0:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    15b2:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
    15b5:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    15b7:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
    15bb:	74 0c                	je     15c9 <gets+0x49>
    15bd:	3c 0a                	cmp    $0xa,%al
    15bf:	74 08                	je     15c9 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    15c1:	8d 5e 01             	lea    0x1(%esi),%ebx
    15c4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    15c7:	7c c7                	jl     1590 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    15c9:	8b 45 08             	mov    0x8(%ebp),%eax
    15cc:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    15d0:	83 c4 2c             	add    $0x2c,%esp
    15d3:	5b                   	pop    %ebx
    15d4:	5e                   	pop    %esi
    15d5:	5f                   	pop    %edi
    15d6:	5d                   	pop    %ebp
    15d7:	c3                   	ret    
    15d8:	90                   	nop
    15d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000015e0 <stat>:

int
stat(char *n, struct stat *st)
{
    15e0:	55                   	push   %ebp
    15e1:	89 e5                	mov    %esp,%ebp
    15e3:	56                   	push   %esi
    15e4:	53                   	push   %ebx
    15e5:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    15e8:	8b 45 08             	mov    0x8(%ebp),%eax
    15eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    15f2:	00 
    15f3:	89 04 24             	mov    %eax,(%esp)
    15f6:	e8 d7 00 00 00       	call   16d2 <open>
  if(fd < 0)
    15fb:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    15fd:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
    15ff:	78 27                	js     1628 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    1601:	8b 45 0c             	mov    0xc(%ebp),%eax
    1604:	89 1c 24             	mov    %ebx,(%esp)
    1607:	89 44 24 04          	mov    %eax,0x4(%esp)
    160b:	e8 da 00 00 00       	call   16ea <fstat>
  close(fd);
    1610:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
    1613:	89 c6                	mov    %eax,%esi
  close(fd);
    1615:	e8 a0 00 00 00       	call   16ba <close>
  return r;
    161a:	89 f0                	mov    %esi,%eax
}
    161c:	83 c4 10             	add    $0x10,%esp
    161f:	5b                   	pop    %ebx
    1620:	5e                   	pop    %esi
    1621:	5d                   	pop    %ebp
    1622:	c3                   	ret    
    1623:	90                   	nop
    1624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
    1628:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    162d:	eb ed                	jmp    161c <stat+0x3c>
    162f:	90                   	nop

00001630 <atoi>:
  return r;
}

int
atoi(const char *s)
{
    1630:	55                   	push   %ebp
    1631:	89 e5                	mov    %esp,%ebp
    1633:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1636:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1637:	0f be 11             	movsbl (%ecx),%edx
    163a:	8d 42 d0             	lea    -0x30(%edx),%eax
    163d:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
    163f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    1644:	77 17                	ja     165d <atoi+0x2d>
    1646:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
    1648:	83 c1 01             	add    $0x1,%ecx
    164b:	8d 04 80             	lea    (%eax,%eax,4),%eax
    164e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1652:	0f be 11             	movsbl (%ecx),%edx
    1655:	8d 5a d0             	lea    -0x30(%edx),%ebx
    1658:	80 fb 09             	cmp    $0x9,%bl
    165b:	76 eb                	jbe    1648 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
    165d:	5b                   	pop    %ebx
    165e:	5d                   	pop    %ebp
    165f:	c3                   	ret    

00001660 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1660:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1661:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
    1663:	89 e5                	mov    %esp,%ebp
    1665:	56                   	push   %esi
    1666:	8b 45 08             	mov    0x8(%ebp),%eax
    1669:	53                   	push   %ebx
    166a:	8b 5d 10             	mov    0x10(%ebp),%ebx
    166d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1670:	85 db                	test   %ebx,%ebx
    1672:	7e 12                	jle    1686 <memmove+0x26>
    1674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
    1678:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    167c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    167f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1682:	39 da                	cmp    %ebx,%edx
    1684:	75 f2                	jne    1678 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
    1686:	5b                   	pop    %ebx
    1687:	5e                   	pop    %esi
    1688:	5d                   	pop    %ebp
    1689:	c3                   	ret    

0000168a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    168a:	b8 01 00 00 00       	mov    $0x1,%eax
    168f:	cd 40                	int    $0x40
    1691:	c3                   	ret    

00001692 <exit>:
SYSCALL(exit)
    1692:	b8 02 00 00 00       	mov    $0x2,%eax
    1697:	cd 40                	int    $0x40
    1699:	c3                   	ret    

0000169a <wait>:
SYSCALL(wait)
    169a:	b8 03 00 00 00       	mov    $0x3,%eax
    169f:	cd 40                	int    $0x40
    16a1:	c3                   	ret    

000016a2 <pipe>:
SYSCALL(pipe)
    16a2:	b8 04 00 00 00       	mov    $0x4,%eax
    16a7:	cd 40                	int    $0x40
    16a9:	c3                   	ret    

000016aa <read>:
SYSCALL(read)
    16aa:	b8 05 00 00 00       	mov    $0x5,%eax
    16af:	cd 40                	int    $0x40
    16b1:	c3                   	ret    

000016b2 <write>:
SYSCALL(write)
    16b2:	b8 11 00 00 00       	mov    $0x11,%eax
    16b7:	cd 40                	int    $0x40
    16b9:	c3                   	ret    

000016ba <close>:
SYSCALL(close)
    16ba:	b8 16 00 00 00       	mov    $0x16,%eax
    16bf:	cd 40                	int    $0x40
    16c1:	c3                   	ret    

000016c2 <kill>:
SYSCALL(kill)
    16c2:	b8 06 00 00 00       	mov    $0x6,%eax
    16c7:	cd 40                	int    $0x40
    16c9:	c3                   	ret    

000016ca <exec>:
SYSCALL(exec)
    16ca:	b8 07 00 00 00       	mov    $0x7,%eax
    16cf:	cd 40                	int    $0x40
    16d1:	c3                   	ret    

000016d2 <open>:
SYSCALL(open)
    16d2:	b8 10 00 00 00       	mov    $0x10,%eax
    16d7:	cd 40                	int    $0x40
    16d9:	c3                   	ret    

000016da <mknod>:
SYSCALL(mknod)
    16da:	b8 12 00 00 00       	mov    $0x12,%eax
    16df:	cd 40                	int    $0x40
    16e1:	c3                   	ret    

000016e2 <unlink>:
SYSCALL(unlink)
    16e2:	b8 13 00 00 00       	mov    $0x13,%eax
    16e7:	cd 40                	int    $0x40
    16e9:	c3                   	ret    

000016ea <fstat>:
SYSCALL(fstat)
    16ea:	b8 08 00 00 00       	mov    $0x8,%eax
    16ef:	cd 40                	int    $0x40
    16f1:	c3                   	ret    

000016f2 <link>:
SYSCALL(link)
    16f2:	b8 14 00 00 00       	mov    $0x14,%eax
    16f7:	cd 40                	int    $0x40
    16f9:	c3                   	ret    

000016fa <mkdir>:
SYSCALL(mkdir)
    16fa:	b8 15 00 00 00       	mov    $0x15,%eax
    16ff:	cd 40                	int    $0x40
    1701:	c3                   	ret    

00001702 <chdir>:
SYSCALL(chdir)
    1702:	b8 09 00 00 00       	mov    $0x9,%eax
    1707:	cd 40                	int    $0x40
    1709:	c3                   	ret    

0000170a <dup>:
SYSCALL(dup)
    170a:	b8 0a 00 00 00       	mov    $0xa,%eax
    170f:	cd 40                	int    $0x40
    1711:	c3                   	ret    

00001712 <getpid>:
SYSCALL(getpid)
    1712:	b8 0b 00 00 00       	mov    $0xb,%eax
    1717:	cd 40                	int    $0x40
    1719:	c3                   	ret    

0000171a <getppid>:
SYSCALL(getppid)
    171a:	b8 0c 00 00 00       	mov    $0xc,%eax
    171f:	cd 40                	int    $0x40
    1721:	c3                   	ret    

00001722 <sbrk>:
SYSCALL(sbrk)
    1722:	b8 0d 00 00 00       	mov    $0xd,%eax
    1727:	cd 40                	int    $0x40
    1729:	c3                   	ret    

0000172a <sleep>:
SYSCALL(sleep)
    172a:	b8 0e 00 00 00       	mov    $0xe,%eax
    172f:	cd 40                	int    $0x40
    1731:	c3                   	ret    

00001732 <uptime>:
SYSCALL(uptime)
    1732:	b8 0f 00 00 00       	mov    $0xf,%eax
    1737:	cd 40                	int    $0x40
    1739:	c3                   	ret    

0000173a <my_syscall>:
SYSCALL(my_syscall)
    173a:	b8 17 00 00 00       	mov    $0x17,%eax
    173f:	cd 40                	int    $0x40
    1741:	c3                   	ret    

00001742 <yield>:
SYSCALL(yield)
    1742:	b8 18 00 00 00       	mov    $0x18,%eax
    1747:	cd 40                	int    $0x40
    1749:	c3                   	ret    

0000174a <getlev>:
SYSCALL(getlev)
    174a:	b8 19 00 00 00       	mov    $0x19,%eax
    174f:	cd 40                	int    $0x40
    1751:	c3                   	ret    

00001752 <set_cpu_share>:
SYSCALL(set_cpu_share)
    1752:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1757:	cd 40                	int    $0x40
    1759:	c3                   	ret    

0000175a <thread_create>:
SYSCALL(thread_create)
    175a:	b8 1b 00 00 00       	mov    $0x1b,%eax
    175f:	cd 40                	int    $0x40
    1761:	c3                   	ret    

00001762 <thread_exit>:
SYSCALL(thread_exit)
    1762:	b8 1c 00 00 00       	mov    $0x1c,%eax
    1767:	cd 40                	int    $0x40
    1769:	c3                   	ret    

0000176a <thread_join>:
SYSCALL(thread_join)
    176a:	b8 1d 00 00 00       	mov    $0x1d,%eax
    176f:	cd 40                	int    $0x40
    1771:	c3                   	ret    
    1772:	66 90                	xchg   %ax,%ax
    1774:	66 90                	xchg   %ax,%ax
    1776:	66 90                	xchg   %ax,%ax
    1778:	66 90                	xchg   %ax,%ax
    177a:	66 90                	xchg   %ax,%ax
    177c:	66 90                	xchg   %ax,%ax
    177e:	66 90                	xchg   %ax,%ax

00001780 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1780:	55                   	push   %ebp
    1781:	89 e5                	mov    %esp,%ebp
    1783:	57                   	push   %edi
    1784:	56                   	push   %esi
    1785:	89 c6                	mov    %eax,%esi
    1787:	53                   	push   %ebx
    1788:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    178b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    178e:	85 db                	test   %ebx,%ebx
    1790:	74 09                	je     179b <printint+0x1b>
    1792:	89 d0                	mov    %edx,%eax
    1794:	c1 e8 1f             	shr    $0x1f,%eax
    1797:	84 c0                	test   %al,%al
    1799:	75 75                	jne    1810 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    179b:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    179d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    17a4:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    17a7:	31 ff                	xor    %edi,%edi
    17a9:	89 ce                	mov    %ecx,%esi
    17ab:	8d 5d d7             	lea    -0x29(%ebp),%ebx
    17ae:	eb 02                	jmp    17b2 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
    17b0:	89 cf                	mov    %ecx,%edi
    17b2:	31 d2                	xor    %edx,%edx
    17b4:	f7 f6                	div    %esi
    17b6:	8d 4f 01             	lea    0x1(%edi),%ecx
    17b9:	0f b6 92 0f 1e 00 00 	movzbl 0x1e0f(%edx),%edx
  }while((x /= base) != 0);
    17c0:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
    17c2:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
    17c5:	75 e9                	jne    17b0 <printint+0x30>
  if(neg)
    17c7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
    17ca:	89 c8                	mov    %ecx,%eax
    17cc:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
    17cf:	85 d2                	test   %edx,%edx
    17d1:	74 08                	je     17db <printint+0x5b>
    buf[i++] = '-';
    17d3:	8d 4f 02             	lea    0x2(%edi),%ecx
    17d6:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
    17db:	8d 79 ff             	lea    -0x1(%ecx),%edi
    17de:	66 90                	xchg   %ax,%ax
    17e0:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
    17e5:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    17e8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    17ef:	00 
    17f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    17f4:	89 34 24             	mov    %esi,(%esp)
    17f7:	88 45 d7             	mov    %al,-0x29(%ebp)
    17fa:	e8 b3 fe ff ff       	call   16b2 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    17ff:	83 ff ff             	cmp    $0xffffffff,%edi
    1802:	75 dc                	jne    17e0 <printint+0x60>
    putc(fd, buf[i]);
}
    1804:	83 c4 4c             	add    $0x4c,%esp
    1807:	5b                   	pop    %ebx
    1808:	5e                   	pop    %esi
    1809:	5f                   	pop    %edi
    180a:	5d                   	pop    %ebp
    180b:	c3                   	ret    
    180c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    1810:	89 d0                	mov    %edx,%eax
    1812:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    1814:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    181b:	eb 87                	jmp    17a4 <printint+0x24>
    181d:	8d 76 00             	lea    0x0(%esi),%esi

00001820 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1820:	55                   	push   %ebp
    1821:	89 e5                	mov    %esp,%ebp
    1823:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1824:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1826:	56                   	push   %esi
    1827:	53                   	push   %ebx
    1828:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    182b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    182e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1831:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    1834:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
    1837:	0f b6 13             	movzbl (%ebx),%edx
    183a:	83 c3 01             	add    $0x1,%ebx
    183d:	84 d2                	test   %dl,%dl
    183f:	75 39                	jne    187a <printf+0x5a>
    1841:	e9 c2 00 00 00       	jmp    1908 <printf+0xe8>
    1846:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    1848:	83 fa 25             	cmp    $0x25,%edx
    184b:	0f 84 bf 00 00 00    	je     1910 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1851:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1854:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    185b:	00 
    185c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1860:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
    1863:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1866:	e8 47 fe ff ff       	call   16b2 <write>
    186b:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    186e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
    1872:	84 d2                	test   %dl,%dl
    1874:	0f 84 8e 00 00 00    	je     1908 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
    187a:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    187c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
    187f:	74 c7                	je     1848 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1881:	83 ff 25             	cmp    $0x25,%edi
    1884:	75 e5                	jne    186b <printf+0x4b>
      if(c == 'd'){
    1886:	83 fa 64             	cmp    $0x64,%edx
    1889:	0f 84 31 01 00 00    	je     19c0 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    188f:	25 f7 00 00 00       	and    $0xf7,%eax
    1894:	83 f8 70             	cmp    $0x70,%eax
    1897:	0f 84 83 00 00 00    	je     1920 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    189d:	83 fa 73             	cmp    $0x73,%edx
    18a0:	0f 84 a2 00 00 00    	je     1948 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    18a6:	83 fa 63             	cmp    $0x63,%edx
    18a9:	0f 84 35 01 00 00    	je     19e4 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    18af:	83 fa 25             	cmp    $0x25,%edx
    18b2:	0f 84 e0 00 00 00    	je     1998 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    18b8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    18bb:	83 c3 01             	add    $0x1,%ebx
    18be:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    18c5:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    18c6:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    18c8:	89 44 24 04          	mov    %eax,0x4(%esp)
    18cc:	89 34 24             	mov    %esi,(%esp)
    18cf:	89 55 d0             	mov    %edx,-0x30(%ebp)
    18d2:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
    18d6:	e8 d7 fd ff ff       	call   16b2 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    18db:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    18de:	8d 45 e7             	lea    -0x19(%ebp),%eax
    18e1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    18e8:	00 
    18e9:	89 44 24 04          	mov    %eax,0x4(%esp)
    18ed:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    18f0:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    18f3:	e8 ba fd ff ff       	call   16b2 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    18f8:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
    18fc:	84 d2                	test   %dl,%dl
    18fe:	0f 85 76 ff ff ff    	jne    187a <printf+0x5a>
    1904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1908:	83 c4 3c             	add    $0x3c,%esp
    190b:	5b                   	pop    %ebx
    190c:	5e                   	pop    %esi
    190d:	5f                   	pop    %edi
    190e:	5d                   	pop    %ebp
    190f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    1910:	bf 25 00 00 00       	mov    $0x25,%edi
    1915:	e9 51 ff ff ff       	jmp    186b <printf+0x4b>
    191a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    1920:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    1923:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1928:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    192a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1931:	8b 10                	mov    (%eax),%edx
    1933:	89 f0                	mov    %esi,%eax
    1935:	e8 46 fe ff ff       	call   1780 <printint>
        ap++;
    193a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    193e:	e9 28 ff ff ff       	jmp    186b <printf+0x4b>
    1943:	90                   	nop
    1944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
    1948:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
    194b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
    194f:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
    1951:	b8 08 1e 00 00       	mov    $0x1e08,%eax
    1956:	85 ff                	test   %edi,%edi
    1958:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
    195b:	0f b6 07             	movzbl (%edi),%eax
    195e:	84 c0                	test   %al,%al
    1960:	74 2a                	je     198c <printf+0x16c>
    1962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1968:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    196b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
    196e:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1971:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1978:	00 
    1979:	89 44 24 04          	mov    %eax,0x4(%esp)
    197d:	89 34 24             	mov    %esi,(%esp)
    1980:	e8 2d fd ff ff       	call   16b2 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1985:	0f b6 07             	movzbl (%edi),%eax
    1988:	84 c0                	test   %al,%al
    198a:	75 dc                	jne    1968 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    198c:	31 ff                	xor    %edi,%edi
    198e:	e9 d8 fe ff ff       	jmp    186b <printf+0x4b>
    1993:	90                   	nop
    1994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1998:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    199b:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    199d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    19a4:	00 
    19a5:	89 44 24 04          	mov    %eax,0x4(%esp)
    19a9:	89 34 24             	mov    %esi,(%esp)
    19ac:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
    19b0:	e8 fd fc ff ff       	call   16b2 <write>
    19b5:	e9 b1 fe ff ff       	jmp    186b <printf+0x4b>
    19ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    19c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    19c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    19c8:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    19cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19d2:	8b 10                	mov    (%eax),%edx
    19d4:	89 f0                	mov    %esi,%eax
    19d6:	e8 a5 fd ff ff       	call   1780 <printint>
        ap++;
    19db:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    19df:	e9 87 fe ff ff       	jmp    186b <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    19e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    19e7:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    19e9:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    19eb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    19f2:	00 
    19f3:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    19f6:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    19f9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    19fc:	89 44 24 04          	mov    %eax,0x4(%esp)
    1a00:	e8 ad fc ff ff       	call   16b2 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
    1a05:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    1a09:	e9 5d fe ff ff       	jmp    186b <printf+0x4b>
    1a0e:	66 90                	xchg   %ax,%ax

00001a10 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1a10:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1a11:	a1 5c 26 00 00       	mov    0x265c,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
    1a16:	89 e5                	mov    %esp,%ebp
    1a18:	57                   	push   %edi
    1a19:	56                   	push   %esi
    1a1a:	53                   	push   %ebx
    1a1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1a1e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1a20:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1a23:	39 d0                	cmp    %edx,%eax
    1a25:	72 11                	jb     1a38 <free+0x28>
    1a27:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1a28:	39 c8                	cmp    %ecx,%eax
    1a2a:	72 04                	jb     1a30 <free+0x20>
    1a2c:	39 ca                	cmp    %ecx,%edx
    1a2e:	72 10                	jb     1a40 <free+0x30>
    1a30:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1a32:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1a34:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1a36:	73 f0                	jae    1a28 <free+0x18>
    1a38:	39 ca                	cmp    %ecx,%edx
    1a3a:	72 04                	jb     1a40 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1a3c:	39 c8                	cmp    %ecx,%eax
    1a3e:	72 f0                	jb     1a30 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1a40:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1a43:	8d 3c f2             	lea    (%edx,%esi,8),%edi
    1a46:	39 cf                	cmp    %ecx,%edi
    1a48:	74 1e                	je     1a68 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1a4a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1a4d:	8b 48 04             	mov    0x4(%eax),%ecx
    1a50:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
    1a53:	39 f2                	cmp    %esi,%edx
    1a55:	74 28                	je     1a7f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    1a57:	89 10                	mov    %edx,(%eax)
  freep = p;
    1a59:	a3 5c 26 00 00       	mov    %eax,0x265c
}
    1a5e:	5b                   	pop    %ebx
    1a5f:	5e                   	pop    %esi
    1a60:	5f                   	pop    %edi
    1a61:	5d                   	pop    %ebp
    1a62:	c3                   	ret    
    1a63:	90                   	nop
    1a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1a68:	03 71 04             	add    0x4(%ecx),%esi
    1a6b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1a6e:	8b 08                	mov    (%eax),%ecx
    1a70:	8b 09                	mov    (%ecx),%ecx
    1a72:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1a75:	8b 48 04             	mov    0x4(%eax),%ecx
    1a78:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
    1a7b:	39 f2                	cmp    %esi,%edx
    1a7d:	75 d8                	jne    1a57 <free+0x47>
    p->s.size += bp->s.size;
    1a7f:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
    1a82:	a3 5c 26 00 00       	mov    %eax,0x265c
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1a87:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1a8a:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1a8d:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
    1a8f:	5b                   	pop    %ebx
    1a90:	5e                   	pop    %esi
    1a91:	5f                   	pop    %edi
    1a92:	5d                   	pop    %ebp
    1a93:	c3                   	ret    
    1a94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1a9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00001aa0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1aa0:	55                   	push   %ebp
    1aa1:	89 e5                	mov    %esp,%ebp
    1aa3:	57                   	push   %edi
    1aa4:	56                   	push   %esi
    1aa5:	53                   	push   %ebx
    1aa6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    1aac:	8b 1d 5c 26 00 00    	mov    0x265c,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1ab2:	8d 48 07             	lea    0x7(%eax),%ecx
    1ab5:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
    1ab8:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1aba:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
    1abd:	0f 84 9b 00 00 00    	je     1b5e <malloc+0xbe>
    1ac3:	8b 13                	mov    (%ebx),%edx
    1ac5:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    1ac8:	39 fe                	cmp    %edi,%esi
    1aca:	76 64                	jbe    1b30 <malloc+0x90>
    1acc:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    1ad3:	bb 00 80 00 00       	mov    $0x8000,%ebx
    1ad8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    1adb:	eb 0e                	jmp    1aeb <malloc+0x4b>
    1add:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1ae0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1ae2:	8b 78 04             	mov    0x4(%eax),%edi
    1ae5:	39 fe                	cmp    %edi,%esi
    1ae7:	76 4f                	jbe    1b38 <malloc+0x98>
    1ae9:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1aeb:	3b 15 5c 26 00 00    	cmp    0x265c,%edx
    1af1:	75 ed                	jne    1ae0 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    1af3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1af6:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    1afc:	bf 00 10 00 00       	mov    $0x1000,%edi
    1b01:	0f 43 fe             	cmovae %esi,%edi
    1b04:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
    1b07:	89 04 24             	mov    %eax,(%esp)
    1b0a:	e8 13 fc ff ff       	call   1722 <sbrk>
  if(p == (char*)-1)
    1b0f:	83 f8 ff             	cmp    $0xffffffff,%eax
    1b12:	74 18                	je     1b2c <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    1b14:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
    1b17:	83 c0 08             	add    $0x8,%eax
    1b1a:	89 04 24             	mov    %eax,(%esp)
    1b1d:	e8 ee fe ff ff       	call   1a10 <free>
  return freep;
    1b22:	8b 15 5c 26 00 00    	mov    0x265c,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
    1b28:	85 d2                	test   %edx,%edx
    1b2a:	75 b4                	jne    1ae0 <malloc+0x40>
        return 0;
    1b2c:	31 c0                	xor    %eax,%eax
    1b2e:	eb 20                	jmp    1b50 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    1b30:	89 d0                	mov    %edx,%eax
    1b32:	89 da                	mov    %ebx,%edx
    1b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    1b38:	39 fe                	cmp    %edi,%esi
    1b3a:	74 1c                	je     1b58 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    1b3c:	29 f7                	sub    %esi,%edi
    1b3e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
    1b41:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
    1b44:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
    1b47:	89 15 5c 26 00 00    	mov    %edx,0x265c
      return (void*)(p + 1);
    1b4d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1b50:	83 c4 1c             	add    $0x1c,%esp
    1b53:	5b                   	pop    %ebx
    1b54:	5e                   	pop    %esi
    1b55:	5f                   	pop    %edi
    1b56:	5d                   	pop    %ebp
    1b57:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
    1b58:	8b 08                	mov    (%eax),%ecx
    1b5a:	89 0a                	mov    %ecx,(%edx)
    1b5c:	eb e9                	jmp    1b47 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    1b5e:	c7 05 5c 26 00 00 60 	movl   $0x2660,0x265c
    1b65:	26 00 00 
    base.s.size = 0;
    1b68:	ba 60 26 00 00       	mov    $0x2660,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    1b6d:	c7 05 60 26 00 00 60 	movl   $0x2660,0x2660
    1b74:	26 00 00 
    base.s.size = 0;
    1b77:	c7 05 64 26 00 00 00 	movl   $0x0,0x2664
    1b7e:	00 00 00 
    1b81:	e9 46 ff ff ff       	jmp    1acc <malloc+0x2c>
