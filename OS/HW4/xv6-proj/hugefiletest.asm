
_hugefiletest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 e4 f0             	and    $0xfffffff0,%esp
   9:	81 ec 20 04 00 00    	sub    $0x420,%esp
  int fd, i, j; 
  int r;
  int total;
  char *path = (argc > 1) ? argv[1] : "hugefile";
   f:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  13:	c7 44 24 1c 66 0a 00 	movl   $0xa66,0x1c(%esp)
  1a:	00 
  1b:	7e 0a                	jle    27 <main+0x27>
  1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  20:	8b 40 04             	mov    0x4(%eax),%eax
  23:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  char data[512];
  char buf[512];

  printf(1, "hugefiletest starting\n");
  27:	c7 44 24 04 6f 0a 00 	movl   $0xa6f,0x4(%esp)
  2e:	00 
  2f:	8d 5c 24 20          	lea    0x20(%esp),%ebx
  33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3a:	e8 c1 06 00 00       	call   700 <printf>
  const int sz = sizeof(data);
  for (i = 0; i < sz; i++) {
  3f:	31 c0                	xor    %eax,%eax
  41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      data[i] = i % 128;
  48:	89 c2                	mov    %eax,%edx
  4a:	83 e2 7f             	and    $0x7f,%edx
  4d:	88 14 03             	mov    %dl,(%ebx,%eax,1)
  char data[512];
  char buf[512];

  printf(1, "hugefiletest starting\n");
  const int sz = sizeof(data);
  for (i = 0; i < sz; i++) {
  50:	83 c0 01             	add    $0x1,%eax
  53:	3d 00 02 00 00       	cmp    $0x200,%eax
  58:	75 ee                	jne    48 <main+0x48>
      data[i] = i % 128;
  }

  printf(1, "1. create test\n");
  5a:	c7 44 24 04 86 0a 00 	movl   $0xa86,0x4(%esp)
  61:	00 
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 1024; i++){
  62:	31 ff                	xor    %edi,%edi
  const int sz = sizeof(data);
  for (i = 0; i < sz; i++) {
      data[i] = i % 128;
  }

  printf(1, "1. create test\n");
  64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  6b:	e8 90 06 00 00       	call   700 <printf>
  fd = open(path, O_CREATE | O_RDWR);
  70:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  74:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  7b:	00 
  7c:	89 04 24             	mov    %eax,(%esp)
  7f:	e8 2e 05 00 00       	call   5b2 <open>
  84:	89 c6                	mov    %eax,%esi
  86:	eb 26                	jmp    ae <main+0xae>
  for(i = 0; i < 1024; i++){
    if (i % 100 == 0){
      printf(1, "%d bytes written\n", i * 512);
    }
    if ((r = write(fd, data, sizeof(data))) != sizeof(data)){
  88:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8f:	00 
  90:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  94:	89 34 24             	mov    %esi,(%esp)
  97:	e8 f6 04 00 00       	call   592 <write>
  9c:	3d 00 02 00 00       	cmp    $0x200,%eax
  a1:	75 42                	jne    e5 <main+0xe5>
      data[i] = i % 128;
  }

  printf(1, "1. create test\n");
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 1024; i++){
  a3:	83 c7 01             	add    $0x1,%edi
  a6:	81 ff 00 04 00 00    	cmp    $0x400,%edi
  ac:	74 54                	je     102 <main+0x102>
    if (i % 100 == 0){
  ae:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
  b3:	f7 ef                	imul   %edi
  b5:	89 f8                	mov    %edi,%eax
  b7:	c1 f8 1f             	sar    $0x1f,%eax
  ba:	c1 fa 05             	sar    $0x5,%edx
  bd:	29 c2                	sub    %eax,%edx
  bf:	6b d2 64             	imul   $0x64,%edx,%edx
  c2:	39 d7                	cmp    %edx,%edi
  c4:	75 c2                	jne    88 <main+0x88>
  c6:	89 f8                	mov    %edi,%eax
  c8:	c1 e0 09             	shl    $0x9,%eax
      printf(1, "%d bytes written\n", i * 512);
  cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  cf:	c7 44 24 04 96 0a 00 	movl   $0xa96,0x4(%esp)
  d6:	00 
  d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  de:	e8 1d 06 00 00       	call   700 <printf>
  e3:	eb a3                	jmp    88 <main+0x88>
      for(j = 0; j < 1024; j++){
        if (j % 100 == 0){
          printf(1, "%d bytes totally written\n", total);
        }
        if ((r = write(fd, data, sizeof(data))) != sizeof(data)){
          printf(1, "write returned %d : failed\n", r);
  e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  e9:	c7 44 24 04 a8 0a 00 	movl   $0xaa8,0x4(%esp)
  f0:	00 
  f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f8:	e8 03 06 00 00       	call   700 <printf>
          exit();
  fd:	e8 70 04 00 00       	call   572 <exit>
    if ((r = write(fd, data, sizeof(data))) != sizeof(data)){
      printf(1, "write returned %d : failed\n", r);
      exit();
    }
  }
  printf(1, "%d bytes written\n", 1024 * 512);
 102:	c7 44 24 08 00 00 08 	movl   $0x80000,0x8(%esp)
 109:	00 
 10a:	8d bc 24 20 02 00 00 	lea    0x220(%esp),%edi
 111:	c7 44 24 04 96 0a 00 	movl   $0xa96,0x4(%esp)
 118:	00 
 119:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 120:	e8 db 05 00 00       	call   700 <printf>
  close(fd);
 125:	89 34 24             	mov    %esi,(%esp)

  printf(1, "2. read test\n");
  fd = open(path, O_RDONLY);
  for (i = 0; i < 1024; i++){
 128:	31 f6                	xor    %esi,%esi
      printf(1, "write returned %d : failed\n", r);
      exit();
    }
  }
  printf(1, "%d bytes written\n", 1024 * 512);
  close(fd);
 12a:	e8 6b 04 00 00       	call   59a <close>

  printf(1, "2. read test\n");
 12f:	c7 44 24 04 c4 0a 00 	movl   $0xac4,0x4(%esp)
 136:	00 
 137:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 13e:	e8 bd 05 00 00       	call   700 <printf>
  fd = open(path, O_RDONLY);
 143:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 147:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 14e:	00 
 14f:	89 04 24             	mov    %eax,(%esp)
 152:	e8 5b 04 00 00       	call   5b2 <open>
 157:	89 44 24 18          	mov    %eax,0x18(%esp)
  for (i = 0; i < 1024; i++){
    if (i % 100 == 0){
 15b:	89 f0                	mov    %esi,%eax
 15d:	b9 64 00 00 00       	mov    $0x64,%ecx
 162:	99                   	cltd   
 163:	f7 f9                	idiv   %ecx
 165:	85 d2                	test   %edx,%edx
 167:	74 53                	je     1bc <main+0x1bc>
      printf(1, "%d bytes read\n", i * 512);
    }
    if ((r = read(fd, buf, sizeof(data))) != sizeof(data)){
 169:	8b 44 24 18          	mov    0x18(%esp),%eax
 16d:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 174:	00 
 175:	89 7c 24 04          	mov    %edi,0x4(%esp)
 179:	89 04 24             	mov    %eax,(%esp)
 17c:	e8 09 04 00 00       	call   58a <read>
 181:	3d 00 02 00 00       	cmp    $0x200,%eax
 186:	0f 85 4f 01 00 00    	jne    2db <main+0x2db>
 18c:	31 c0                	xor    %eax,%eax
 18e:	eb 0a                	jmp    19a <main+0x19a>
      printf(1, "read returned %d : failed\n", r);
      exit();
    }
    for (j = 0; j < sz; j++) {
 190:	83 c0 01             	add    $0x1,%eax
 193:	3d 00 02 00 00       	cmp    $0x200,%eax
 198:	74 41                	je     1db <main+0x1db>
      if (buf[j] != data[j]) {
 19a:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
 19e:	38 0c 07             	cmp    %cl,(%edi,%eax,1)
 1a1:	74 ed                	je     190 <main+0x190>
        printf(1, "data inconsistency detected\n");
 1a3:	c7 44 24 04 fc 0a 00 	movl   $0xafc,0x4(%esp)
 1aa:	00 
 1ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1b2:	e8 49 05 00 00       	call   700 <printf>
        exit();
 1b7:	e8 b6 03 00 00       	call   572 <exit>
 1bc:	89 f0                	mov    %esi,%eax
 1be:	c1 e0 09             	shl    $0x9,%eax

  printf(1, "2. read test\n");
  fd = open(path, O_RDONLY);
  for (i = 0; i < 1024; i++){
    if (i % 100 == 0){
      printf(1, "%d bytes read\n", i * 512);
 1c1:	89 44 24 08          	mov    %eax,0x8(%esp)
 1c5:	c7 44 24 04 d2 0a 00 	movl   $0xad2,0x4(%esp)
 1cc:	00 
 1cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1d4:	e8 27 05 00 00       	call   700 <printf>
 1d9:	eb 8e                	jmp    169 <main+0x169>
  printf(1, "%d bytes written\n", 1024 * 512);
  close(fd);

  printf(1, "2. read test\n");
  fd = open(path, O_RDONLY);
  for (i = 0; i < 1024; i++){
 1db:	83 c6 01             	add    $0x1,%esi
 1de:	81 fe 00 04 00 00    	cmp    $0x400,%esi
 1e4:	0f 85 71 ff ff ff    	jne    15b <main+0x15b>
        printf(1, "data inconsistency detected\n");
        exit();
      }
    }
  }
  printf(1, "%d bytes read\n", 1024 * 512);
 1ea:	c7 44 24 08 00 00 08 	movl   $0x80000,0x8(%esp)
 1f1:	00 
  close(fd);

  printf(1, "3. stress test\n");
  total = 0;
 1f2:	66 31 f6             	xor    %si,%si
  for (i = 0; i < 20; i++) {
 1f5:	31 ff                	xor    %edi,%edi
        printf(1, "data inconsistency detected\n");
        exit();
      }
    }
  }
  printf(1, "%d bytes read\n", 1024 * 512);
 1f7:	c7 44 24 04 d2 0a 00 	movl   $0xad2,0x4(%esp)
 1fe:	00 
 1ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 206:	e8 f5 04 00 00       	call   700 <printf>
  close(fd);
 20b:	8b 44 24 18          	mov    0x18(%esp),%eax
 20f:	89 04 24             	mov    %eax,(%esp)
 212:	e8 83 03 00 00       	call   59a <close>

  printf(1, "3. stress test\n");
 217:	c7 44 24 04 19 0b 00 	movl   $0xb19,0x4(%esp)
 21e:	00 
 21f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 226:	e8 d5 04 00 00       	call   700 <printf>
  total = 0;
  for (i = 0; i < 20; i++) {
    printf(1, "stress test...%d \n", i);
 22b:	89 7c 24 08          	mov    %edi,0x8(%esp)
 22f:	c7 44 24 04 29 0b 00 	movl   $0xb29,0x4(%esp)
 236:	00 
 237:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 23e:	e8 bd 04 00 00       	call   700 <printf>
    if(unlink(path) < 0){
 243:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 247:	89 04 24             	mov    %eax,(%esp)
 24a:	e8 73 03 00 00       	call   5c2 <unlink>
 24f:	85 c0                	test   %eax,%eax
 251:	0f 88 a1 00 00 00    	js     2f8 <main+0x2f8>
      printf(1, "rm: %s failed to delete\n", path);
      exit();
    }
    
    fd = open(path, O_CREATE | O_RDWR);
 257:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 25b:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
 262:	00 
 263:	89 04 24             	mov    %eax,(%esp)
 266:	e8 47 03 00 00       	call   5b2 <open>
      for(j = 0; j < 1024; j++){
 26b:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
 272:	00 
    if(unlink(path) < 0){
      printf(1, "rm: %s failed to delete\n", path);
      exit();
    }
    
    fd = open(path, O_CREATE | O_RDWR);
 273:	89 44 24 14          	mov    %eax,0x14(%esp)
 277:	eb 38                	jmp    2b1 <main+0x2b1>
      for(j = 0; j < 1024; j++){
        if (j % 100 == 0){
          printf(1, "%d bytes totally written\n", total);
        }
        if ((r = write(fd, data, sizeof(data))) != sizeof(data)){
 279:	8b 44 24 14          	mov    0x14(%esp),%eax
 27d:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 284:	00 
 285:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 289:	89 04 24             	mov    %eax,(%esp)
 28c:	e8 01 03 00 00       	call   592 <write>
 291:	3d 00 02 00 00       	cmp    $0x200,%eax
 296:	0f 85 49 fe ff ff    	jne    e5 <main+0xe5>
      printf(1, "rm: %s failed to delete\n", path);
      exit();
    }
    
    fd = open(path, O_CREATE | O_RDWR);
      for(j = 0; j < 1024; j++){
 29c:	83 44 24 18 01       	addl   $0x1,0x18(%esp)
 2a1:	81 c6 00 02 00 00    	add    $0x200,%esi
 2a7:	81 7c 24 18 00 04 00 	cmpl   $0x400,0x18(%esp)
 2ae:	00 
 2af:	74 68                	je     319 <main+0x319>
        if (j % 100 == 0){
 2b1:	8b 44 24 18          	mov    0x18(%esp),%eax
 2b5:	b9 64 00 00 00       	mov    $0x64,%ecx
 2ba:	99                   	cltd   
 2bb:	f7 f9                	idiv   %ecx
 2bd:	85 d2                	test   %edx,%edx
 2bf:	75 b8                	jne    279 <main+0x279>
          printf(1, "%d bytes totally written\n", total);
 2c1:	89 74 24 08          	mov    %esi,0x8(%esp)
 2c5:	c7 44 24 04 55 0b 00 	movl   $0xb55,0x4(%esp)
 2cc:	00 
 2cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2d4:	e8 27 04 00 00       	call   700 <printf>
 2d9:	eb 9e                	jmp    279 <main+0x279>
  for (i = 0; i < 1024; i++){
    if (i % 100 == 0){
      printf(1, "%d bytes read\n", i * 512);
    }
    if ((r = read(fd, buf, sizeof(data))) != sizeof(data)){
      printf(1, "read returned %d : failed\n", r);
 2db:	89 44 24 08          	mov    %eax,0x8(%esp)
 2df:	c7 44 24 04 e1 0a 00 	movl   $0xae1,0x4(%esp)
 2e6:	00 
 2e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2ee:	e8 0d 04 00 00       	call   700 <printf>
      exit();
 2f3:	e8 7a 02 00 00       	call   572 <exit>
  printf(1, "3. stress test\n");
  total = 0;
  for (i = 0; i < 20; i++) {
    printf(1, "stress test...%d \n", i);
    if(unlink(path) < 0){
      printf(1, "rm: %s failed to delete\n", path);
 2f8:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 2fc:	c7 44 24 04 3c 0b 00 	movl   $0xb3c,0x4(%esp)
 303:	00 
 304:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 30b:	89 44 24 08          	mov    %eax,0x8(%esp)
 30f:	e8 ec 03 00 00       	call   700 <printf>
      exit();
 314:	e8 59 02 00 00       	call   572 <exit>
          printf(1, "write returned %d : failed\n", r);
          exit();
        }
        total += sizeof(data);
      }
      printf(1, "%d bytes written\n", total);
 319:	89 74 24 08          	mov    %esi,0x8(%esp)
  printf(1, "%d bytes read\n", 1024 * 512);
  close(fd);

  printf(1, "3. stress test\n");
  total = 0;
  for (i = 0; i < 20; i++) {
 31d:	83 c7 01             	add    $0x1,%edi
          printf(1, "write returned %d : failed\n", r);
          exit();
        }
        total += sizeof(data);
      }
      printf(1, "%d bytes written\n", total);
 320:	c7 44 24 04 96 0a 00 	movl   $0xa96,0x4(%esp)
 327:	00 
 328:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 32f:	e8 cc 03 00 00       	call   700 <printf>
    close(fd);
 334:	8b 44 24 14          	mov    0x14(%esp),%eax
 338:	89 04 24             	mov    %eax,(%esp)
 33b:	e8 5a 02 00 00       	call   59a <close>
  printf(1, "%d bytes read\n", 1024 * 512);
  close(fd);

  printf(1, "3. stress test\n");
  total = 0;
  for (i = 0; i < 20; i++) {
 340:	83 ff 14             	cmp    $0x14,%edi
 343:	0f 85 e2 fe ff ff    	jne    22b <main+0x22b>
      }
      printf(1, "%d bytes written\n", total);
    close(fd);
  }

  exit();
 349:	e8 24 02 00 00       	call   572 <exit>
 34e:	66 90                	xchg   %ax,%ax

00000350 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	8b 45 08             	mov    0x8(%ebp),%eax
 356:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 359:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 35a:	89 c2                	mov    %eax,%edx
 35c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 360:	83 c1 01             	add    $0x1,%ecx
 363:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 367:	83 c2 01             	add    $0x1,%edx
 36a:	84 db                	test   %bl,%bl
 36c:	88 5a ff             	mov    %bl,-0x1(%edx)
 36f:	75 ef                	jne    360 <strcpy+0x10>
    ;
  return os;
}
 371:	5b                   	pop    %ebx
 372:	5d                   	pop    %ebp
 373:	c3                   	ret    
 374:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 37a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000380 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	8b 55 08             	mov    0x8(%ebp),%edx
 386:	53                   	push   %ebx
 387:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 38a:	0f b6 02             	movzbl (%edx),%eax
 38d:	84 c0                	test   %al,%al
 38f:	74 2d                	je     3be <strcmp+0x3e>
 391:	0f b6 19             	movzbl (%ecx),%ebx
 394:	38 d8                	cmp    %bl,%al
 396:	74 0e                	je     3a6 <strcmp+0x26>
 398:	eb 2b                	jmp    3c5 <strcmp+0x45>
 39a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3a0:	38 c8                	cmp    %cl,%al
 3a2:	75 15                	jne    3b9 <strcmp+0x39>
    p++, q++;
 3a4:	89 d9                	mov    %ebx,%ecx
 3a6:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3a9:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 3ac:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3af:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 3b3:	84 c0                	test   %al,%al
 3b5:	75 e9                	jne    3a0 <strcmp+0x20>
 3b7:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3b9:	29 c8                	sub    %ecx,%eax
}
 3bb:	5b                   	pop    %ebx
 3bc:	5d                   	pop    %ebp
 3bd:	c3                   	ret    
 3be:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3c1:	31 c0                	xor    %eax,%eax
 3c3:	eb f4                	jmp    3b9 <strcmp+0x39>
 3c5:	0f b6 cb             	movzbl %bl,%ecx
 3c8:	eb ef                	jmp    3b9 <strcmp+0x39>
 3ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003d0 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 3d6:	80 39 00             	cmpb   $0x0,(%ecx)
 3d9:	74 12                	je     3ed <strlen+0x1d>
 3db:	31 d2                	xor    %edx,%edx
 3dd:	8d 76 00             	lea    0x0(%esi),%esi
 3e0:	83 c2 01             	add    $0x1,%edx
 3e3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 3e7:	89 d0                	mov    %edx,%eax
 3e9:	75 f5                	jne    3e0 <strlen+0x10>
    ;
  return n;
}
 3eb:	5d                   	pop    %ebp
 3ec:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 3ed:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 3ef:	5d                   	pop    %ebp
 3f0:	c3                   	ret    
 3f1:	eb 0d                	jmp    400 <memset>
 3f3:	90                   	nop
 3f4:	90                   	nop
 3f5:	90                   	nop
 3f6:	90                   	nop
 3f7:	90                   	nop
 3f8:	90                   	nop
 3f9:	90                   	nop
 3fa:	90                   	nop
 3fb:	90                   	nop
 3fc:	90                   	nop
 3fd:	90                   	nop
 3fe:	90                   	nop
 3ff:	90                   	nop

00000400 <memset>:

void*
memset(void *dst, int c, uint n)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	8b 55 08             	mov    0x8(%ebp),%edx
 406:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 407:	8b 4d 10             	mov    0x10(%ebp),%ecx
 40a:	8b 45 0c             	mov    0xc(%ebp),%eax
 40d:	89 d7                	mov    %edx,%edi
 40f:	fc                   	cld    
 410:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 412:	89 d0                	mov    %edx,%eax
 414:	5f                   	pop    %edi
 415:	5d                   	pop    %ebp
 416:	c3                   	ret    
 417:	89 f6                	mov    %esi,%esi
 419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000420 <strchr>:

char*
strchr(const char *s, char c)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	8b 45 08             	mov    0x8(%ebp),%eax
 426:	53                   	push   %ebx
 427:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 42a:	0f b6 18             	movzbl (%eax),%ebx
 42d:	84 db                	test   %bl,%bl
 42f:	74 1d                	je     44e <strchr+0x2e>
    if(*s == c)
 431:	38 d3                	cmp    %dl,%bl
 433:	89 d1                	mov    %edx,%ecx
 435:	75 0d                	jne    444 <strchr+0x24>
 437:	eb 17                	jmp    450 <strchr+0x30>
 439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 440:	38 ca                	cmp    %cl,%dl
 442:	74 0c                	je     450 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 444:	83 c0 01             	add    $0x1,%eax
 447:	0f b6 10             	movzbl (%eax),%edx
 44a:	84 d2                	test   %dl,%dl
 44c:	75 f2                	jne    440 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 44e:	31 c0                	xor    %eax,%eax
}
 450:	5b                   	pop    %ebx
 451:	5d                   	pop    %ebp
 452:	c3                   	ret    
 453:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000460 <gets>:

char*
gets(char *buf, int max)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	57                   	push   %edi
 464:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 465:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 467:	53                   	push   %ebx
 468:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 46b:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 46e:	eb 31                	jmp    4a1 <gets+0x41>
    cc = read(0, &c, 1);
 470:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 477:	00 
 478:	89 7c 24 04          	mov    %edi,0x4(%esp)
 47c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 483:	e8 02 01 00 00       	call   58a <read>
    if(cc < 1)
 488:	85 c0                	test   %eax,%eax
 48a:	7e 1d                	jle    4a9 <gets+0x49>
      break;
    buf[i++] = c;
 48c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 490:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 492:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 495:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 497:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 49b:	74 0c                	je     4a9 <gets+0x49>
 49d:	3c 0a                	cmp    $0xa,%al
 49f:	74 08                	je     4a9 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4a1:	8d 5e 01             	lea    0x1(%esi),%ebx
 4a4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 4a7:	7c c7                	jl     470 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4a9:	8b 45 08             	mov    0x8(%ebp),%eax
 4ac:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 4b0:	83 c4 2c             	add    $0x2c,%esp
 4b3:	5b                   	pop    %ebx
 4b4:	5e                   	pop    %esi
 4b5:	5f                   	pop    %edi
 4b6:	5d                   	pop    %ebp
 4b7:	c3                   	ret    
 4b8:	90                   	nop
 4b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000004c0 <stat>:

int
stat(char *n, struct stat *st)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	56                   	push   %esi
 4c4:	53                   	push   %ebx
 4c5:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c8:	8b 45 08             	mov    0x8(%ebp),%eax
 4cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4d2:	00 
 4d3:	89 04 24             	mov    %eax,(%esp)
 4d6:	e8 d7 00 00 00       	call   5b2 <open>
  if(fd < 0)
 4db:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4dd:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 4df:	78 27                	js     508 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 4e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e4:	89 1c 24             	mov    %ebx,(%esp)
 4e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4eb:	e8 da 00 00 00       	call   5ca <fstat>
  close(fd);
 4f0:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 4f3:	89 c6                	mov    %eax,%esi
  close(fd);
 4f5:	e8 a0 00 00 00       	call   59a <close>
  return r;
 4fa:	89 f0                	mov    %esi,%eax
}
 4fc:	83 c4 10             	add    $0x10,%esp
 4ff:	5b                   	pop    %ebx
 500:	5e                   	pop    %esi
 501:	5d                   	pop    %ebp
 502:	c3                   	ret    
 503:	90                   	nop
 504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 508:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 50d:	eb ed                	jmp    4fc <stat+0x3c>
 50f:	90                   	nop

00000510 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	8b 4d 08             	mov    0x8(%ebp),%ecx
 516:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 517:	0f be 11             	movsbl (%ecx),%edx
 51a:	8d 42 d0             	lea    -0x30(%edx),%eax
 51d:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 51f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 524:	77 17                	ja     53d <atoi+0x2d>
 526:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 528:	83 c1 01             	add    $0x1,%ecx
 52b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 52e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 532:	0f be 11             	movsbl (%ecx),%edx
 535:	8d 5a d0             	lea    -0x30(%edx),%ebx
 538:	80 fb 09             	cmp    $0x9,%bl
 53b:	76 eb                	jbe    528 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 53d:	5b                   	pop    %ebx
 53e:	5d                   	pop    %ebp
 53f:	c3                   	ret    

00000540 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 540:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 541:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 543:	89 e5                	mov    %esp,%ebp
 545:	56                   	push   %esi
 546:	8b 45 08             	mov    0x8(%ebp),%eax
 549:	53                   	push   %ebx
 54a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 54d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 550:	85 db                	test   %ebx,%ebx
 552:	7e 12                	jle    566 <memmove+0x26>
 554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 558:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 55c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 55f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 562:	39 da                	cmp    %ebx,%edx
 564:	75 f2                	jne    558 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 566:	5b                   	pop    %ebx
 567:	5e                   	pop    %esi
 568:	5d                   	pop    %ebp
 569:	c3                   	ret    

0000056a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 56a:	b8 01 00 00 00       	mov    $0x1,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <exit>:
SYSCALL(exit)
 572:	b8 02 00 00 00       	mov    $0x2,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <wait>:
SYSCALL(wait)
 57a:	b8 03 00 00 00       	mov    $0x3,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <pipe>:
SYSCALL(pipe)
 582:	b8 04 00 00 00       	mov    $0x4,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <read>:
SYSCALL(read)
 58a:	b8 05 00 00 00       	mov    $0x5,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <write>:
SYSCALL(write)
 592:	b8 11 00 00 00       	mov    $0x11,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <close>:
SYSCALL(close)
 59a:	b8 16 00 00 00       	mov    $0x16,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <kill>:
SYSCALL(kill)
 5a2:	b8 06 00 00 00       	mov    $0x6,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <exec>:
SYSCALL(exec)
 5aa:	b8 07 00 00 00       	mov    $0x7,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <open>:
SYSCALL(open)
 5b2:	b8 10 00 00 00       	mov    $0x10,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <mknod>:
SYSCALL(mknod)
 5ba:	b8 12 00 00 00       	mov    $0x12,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <unlink>:
SYSCALL(unlink)
 5c2:	b8 13 00 00 00       	mov    $0x13,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <fstat>:
SYSCALL(fstat)
 5ca:	b8 08 00 00 00       	mov    $0x8,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <link>:
SYSCALL(link)
 5d2:	b8 14 00 00 00       	mov    $0x14,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <mkdir>:
SYSCALL(mkdir)
 5da:	b8 15 00 00 00       	mov    $0x15,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <chdir>:
SYSCALL(chdir)
 5e2:	b8 09 00 00 00       	mov    $0x9,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <dup>:
SYSCALL(dup)
 5ea:	b8 0a 00 00 00       	mov    $0xa,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <getpid>:
SYSCALL(getpid)
 5f2:	b8 0b 00 00 00       	mov    $0xb,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <getppid>:
SYSCALL(getppid)
 5fa:	b8 0c 00 00 00       	mov    $0xc,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <sbrk>:
SYSCALL(sbrk)
 602:	b8 0d 00 00 00       	mov    $0xd,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <sleep>:
SYSCALL(sleep)
 60a:	b8 0e 00 00 00       	mov    $0xe,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <uptime>:
SYSCALL(uptime)
 612:	b8 0f 00 00 00       	mov    $0xf,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <my_syscall>:
SYSCALL(my_syscall)
 61a:	b8 17 00 00 00       	mov    $0x17,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <yield>:
SYSCALL(yield)
 622:	b8 18 00 00 00       	mov    $0x18,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <getlev>:
SYSCALL(getlev)
 62a:	b8 19 00 00 00       	mov    $0x19,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <set_cpu_share>:
SYSCALL(set_cpu_share)
 632:	b8 1a 00 00 00       	mov    $0x1a,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <thread_create>:
SYSCALL(thread_create)
 63a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <thread_exit>:
SYSCALL(thread_exit)
 642:	b8 1c 00 00 00       	mov    $0x1c,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <thread_join>:
SYSCALL(thread_join)
 64a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    
 652:	66 90                	xchg   %ax,%ax
 654:	66 90                	xchg   %ax,%ax
 656:	66 90                	xchg   %ax,%ax
 658:	66 90                	xchg   %ax,%ax
 65a:	66 90                	xchg   %ax,%ax
 65c:	66 90                	xchg   %ax,%ax
 65e:	66 90                	xchg   %ax,%ax

00000660 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	57                   	push   %edi
 664:	56                   	push   %esi
 665:	89 c6                	mov    %eax,%esi
 667:	53                   	push   %ebx
 668:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 66b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 66e:	85 db                	test   %ebx,%ebx
 670:	74 09                	je     67b <printint+0x1b>
 672:	89 d0                	mov    %edx,%eax
 674:	c1 e8 1f             	shr    $0x1f,%eax
 677:	84 c0                	test   %al,%al
 679:	75 75                	jne    6f0 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 67b:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 67d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 684:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 687:	31 ff                	xor    %edi,%edi
 689:	89 ce                	mov    %ecx,%esi
 68b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 68e:	eb 02                	jmp    692 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 690:	89 cf                	mov    %ecx,%edi
 692:	31 d2                	xor    %edx,%edx
 694:	f7 f6                	div    %esi
 696:	8d 4f 01             	lea    0x1(%edi),%ecx
 699:	0f b6 92 76 0b 00 00 	movzbl 0xb76(%edx),%edx
  }while((x /= base) != 0);
 6a0:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 6a2:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 6a5:	75 e9                	jne    690 <printint+0x30>
  if(neg)
 6a7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 6aa:	89 c8                	mov    %ecx,%eax
 6ac:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 6af:	85 d2                	test   %edx,%edx
 6b1:	74 08                	je     6bb <printint+0x5b>
    buf[i++] = '-';
 6b3:	8d 4f 02             	lea    0x2(%edi),%ecx
 6b6:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 6bb:	8d 79 ff             	lea    -0x1(%ecx),%edi
 6be:	66 90                	xchg   %ax,%ax
 6c0:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 6c5:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6c8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6cf:	00 
 6d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 6d4:	89 34 24             	mov    %esi,(%esp)
 6d7:	88 45 d7             	mov    %al,-0x29(%ebp)
 6da:	e8 b3 fe ff ff       	call   592 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6df:	83 ff ff             	cmp    $0xffffffff,%edi
 6e2:	75 dc                	jne    6c0 <printint+0x60>
    putc(fd, buf[i]);
}
 6e4:	83 c4 4c             	add    $0x4c,%esp
 6e7:	5b                   	pop    %ebx
 6e8:	5e                   	pop    %esi
 6e9:	5f                   	pop    %edi
 6ea:	5d                   	pop    %ebp
 6eb:	c3                   	ret    
 6ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 6f0:	89 d0                	mov    %edx,%eax
 6f2:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 6f4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 6fb:	eb 87                	jmp    684 <printint+0x24>
 6fd:	8d 76 00             	lea    0x0(%esi),%esi

00000700 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 704:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 706:	56                   	push   %esi
 707:	53                   	push   %ebx
 708:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 70b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 70e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 711:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 714:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 717:	0f b6 13             	movzbl (%ebx),%edx
 71a:	83 c3 01             	add    $0x1,%ebx
 71d:	84 d2                	test   %dl,%dl
 71f:	75 39                	jne    75a <printf+0x5a>
 721:	e9 c2 00 00 00       	jmp    7e8 <printf+0xe8>
 726:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 728:	83 fa 25             	cmp    $0x25,%edx
 72b:	0f 84 bf 00 00 00    	je     7f0 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 731:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 734:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 73b:	00 
 73c:	89 44 24 04          	mov    %eax,0x4(%esp)
 740:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 743:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 746:	e8 47 fe ff ff       	call   592 <write>
 74b:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 74e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 752:	84 d2                	test   %dl,%dl
 754:	0f 84 8e 00 00 00    	je     7e8 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 75a:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 75c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 75f:	74 c7                	je     728 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 761:	83 ff 25             	cmp    $0x25,%edi
 764:	75 e5                	jne    74b <printf+0x4b>
      if(c == 'd'){
 766:	83 fa 64             	cmp    $0x64,%edx
 769:	0f 84 31 01 00 00    	je     8a0 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 76f:	25 f7 00 00 00       	and    $0xf7,%eax
 774:	83 f8 70             	cmp    $0x70,%eax
 777:	0f 84 83 00 00 00    	je     800 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 77d:	83 fa 73             	cmp    $0x73,%edx
 780:	0f 84 a2 00 00 00    	je     828 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 786:	83 fa 63             	cmp    $0x63,%edx
 789:	0f 84 35 01 00 00    	je     8c4 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 78f:	83 fa 25             	cmp    $0x25,%edx
 792:	0f 84 e0 00 00 00    	je     878 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 798:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 79b:	83 c3 01             	add    $0x1,%ebx
 79e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7a5:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7a6:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ac:	89 34 24             	mov    %esi,(%esp)
 7af:	89 55 d0             	mov    %edx,-0x30(%ebp)
 7b2:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 7b6:	e8 d7 fd ff ff       	call   592 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 7bb:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7be:	8d 45 e7             	lea    -0x19(%ebp),%eax
 7c1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7c8:	00 
 7c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 7cd:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 7d0:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7d3:	e8 ba fd ff ff       	call   592 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7d8:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 7dc:	84 d2                	test   %dl,%dl
 7de:	0f 85 76 ff ff ff    	jne    75a <printf+0x5a>
 7e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7e8:	83 c4 3c             	add    $0x3c,%esp
 7eb:	5b                   	pop    %ebx
 7ec:	5e                   	pop    %esi
 7ed:	5f                   	pop    %edi
 7ee:	5d                   	pop    %ebp
 7ef:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 7f0:	bf 25 00 00 00       	mov    $0x25,%edi
 7f5:	e9 51 ff ff ff       	jmp    74b <printf+0x4b>
 7fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 800:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 803:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 808:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 80a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 811:	8b 10                	mov    (%eax),%edx
 813:	89 f0                	mov    %esi,%eax
 815:	e8 46 fe ff ff       	call   660 <printint>
        ap++;
 81a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 81e:	e9 28 ff ff ff       	jmp    74b <printf+0x4b>
 823:	90                   	nop
 824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 828:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 82b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 82f:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 831:	b8 6f 0b 00 00       	mov    $0xb6f,%eax
 836:	85 ff                	test   %edi,%edi
 838:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 83b:	0f b6 07             	movzbl (%edi),%eax
 83e:	84 c0                	test   %al,%al
 840:	74 2a                	je     86c <printf+0x16c>
 842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 848:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 84b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 84e:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 851:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 858:	00 
 859:	89 44 24 04          	mov    %eax,0x4(%esp)
 85d:	89 34 24             	mov    %esi,(%esp)
 860:	e8 2d fd ff ff       	call   592 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 865:	0f b6 07             	movzbl (%edi),%eax
 868:	84 c0                	test   %al,%al
 86a:	75 dc                	jne    848 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 86c:	31 ff                	xor    %edi,%edi
 86e:	e9 d8 fe ff ff       	jmp    74b <printf+0x4b>
 873:	90                   	nop
 874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 878:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 87b:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 87d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 884:	00 
 885:	89 44 24 04          	mov    %eax,0x4(%esp)
 889:	89 34 24             	mov    %esi,(%esp)
 88c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 890:	e8 fd fc ff ff       	call   592 <write>
 895:	e9 b1 fe ff ff       	jmp    74b <printf+0x4b>
 89a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 8a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 8a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 8a8:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 8ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8b2:	8b 10                	mov    (%eax),%edx
 8b4:	89 f0                	mov    %esi,%eax
 8b6:	e8 a5 fd ff ff       	call   660 <printint>
        ap++;
 8bb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 8bf:	e9 87 fe ff ff       	jmp    74b <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 8c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 8c7:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 8c9:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8cb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8d2:	00 
 8d3:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 8d6:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8d9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 8dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 8e0:	e8 ad fc ff ff       	call   592 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 8e5:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 8e9:	e9 5d fe ff ff       	jmp    74b <printf+0x4b>
 8ee:	66 90                	xchg   %ax,%ax

000008f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8f0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f1:	a1 f0 0d 00 00       	mov    0xdf0,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 8f6:	89 e5                	mov    %esp,%ebp
 8f8:	57                   	push   %edi
 8f9:	56                   	push   %esi
 8fa:	53                   	push   %ebx
 8fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8fe:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 900:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 903:	39 d0                	cmp    %edx,%eax
 905:	72 11                	jb     918 <free+0x28>
 907:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 908:	39 c8                	cmp    %ecx,%eax
 90a:	72 04                	jb     910 <free+0x20>
 90c:	39 ca                	cmp    %ecx,%edx
 90e:	72 10                	jb     920 <free+0x30>
 910:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 912:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 914:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 916:	73 f0                	jae    908 <free+0x18>
 918:	39 ca                	cmp    %ecx,%edx
 91a:	72 04                	jb     920 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 91c:	39 c8                	cmp    %ecx,%eax
 91e:	72 f0                	jb     910 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 920:	8b 73 fc             	mov    -0x4(%ebx),%esi
 923:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 926:	39 cf                	cmp    %ecx,%edi
 928:	74 1e                	je     948 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 92a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 92d:	8b 48 04             	mov    0x4(%eax),%ecx
 930:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 933:	39 f2                	cmp    %esi,%edx
 935:	74 28                	je     95f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 937:	89 10                	mov    %edx,(%eax)
  freep = p;
 939:	a3 f0 0d 00 00       	mov    %eax,0xdf0
}
 93e:	5b                   	pop    %ebx
 93f:	5e                   	pop    %esi
 940:	5f                   	pop    %edi
 941:	5d                   	pop    %ebp
 942:	c3                   	ret    
 943:	90                   	nop
 944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 948:	03 71 04             	add    0x4(%ecx),%esi
 94b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 94e:	8b 08                	mov    (%eax),%ecx
 950:	8b 09                	mov    (%ecx),%ecx
 952:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 955:	8b 48 04             	mov    0x4(%eax),%ecx
 958:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 95b:	39 f2                	cmp    %esi,%edx
 95d:	75 d8                	jne    937 <free+0x47>
    p->s.size += bp->s.size;
 95f:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 962:	a3 f0 0d 00 00       	mov    %eax,0xdf0
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 967:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 96a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 96d:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 96f:	5b                   	pop    %ebx
 970:	5e                   	pop    %esi
 971:	5f                   	pop    %edi
 972:	5d                   	pop    %ebp
 973:	c3                   	ret    
 974:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 97a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000980 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 980:	55                   	push   %ebp
 981:	89 e5                	mov    %esp,%ebp
 983:	57                   	push   %edi
 984:	56                   	push   %esi
 985:	53                   	push   %ebx
 986:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 989:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 98c:	8b 1d f0 0d 00 00    	mov    0xdf0,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 992:	8d 48 07             	lea    0x7(%eax),%ecx
 995:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 998:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 99a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 99d:	0f 84 9b 00 00 00    	je     a3e <malloc+0xbe>
 9a3:	8b 13                	mov    (%ebx),%edx
 9a5:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 9a8:	39 fe                	cmp    %edi,%esi
 9aa:	76 64                	jbe    a10 <malloc+0x90>
 9ac:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 9b3:	bb 00 80 00 00       	mov    $0x8000,%ebx
 9b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 9bb:	eb 0e                	jmp    9cb <malloc+0x4b>
 9bd:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 9c2:	8b 78 04             	mov    0x4(%eax),%edi
 9c5:	39 fe                	cmp    %edi,%esi
 9c7:	76 4f                	jbe    a18 <malloc+0x98>
 9c9:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9cb:	3b 15 f0 0d 00 00    	cmp    0xdf0,%edx
 9d1:	75 ed                	jne    9c0 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 9d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9d6:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 9dc:	bf 00 10 00 00       	mov    $0x1000,%edi
 9e1:	0f 43 fe             	cmovae %esi,%edi
 9e4:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 9e7:	89 04 24             	mov    %eax,(%esp)
 9ea:	e8 13 fc ff ff       	call   602 <sbrk>
  if(p == (char*)-1)
 9ef:	83 f8 ff             	cmp    $0xffffffff,%eax
 9f2:	74 18                	je     a0c <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 9f4:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 9f7:	83 c0 08             	add    $0x8,%eax
 9fa:	89 04 24             	mov    %eax,(%esp)
 9fd:	e8 ee fe ff ff       	call   8f0 <free>
  return freep;
 a02:	8b 15 f0 0d 00 00    	mov    0xdf0,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 a08:	85 d2                	test   %edx,%edx
 a0a:	75 b4                	jne    9c0 <malloc+0x40>
        return 0;
 a0c:	31 c0                	xor    %eax,%eax
 a0e:	eb 20                	jmp    a30 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 a10:	89 d0                	mov    %edx,%eax
 a12:	89 da                	mov    %ebx,%edx
 a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 a18:	39 fe                	cmp    %edi,%esi
 a1a:	74 1c                	je     a38 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 a1c:	29 f7                	sub    %esi,%edi
 a1e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 a21:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 a24:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 a27:	89 15 f0 0d 00 00    	mov    %edx,0xdf0
      return (void*)(p + 1);
 a2d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a30:	83 c4 1c             	add    $0x1c,%esp
 a33:	5b                   	pop    %ebx
 a34:	5e                   	pop    %esi
 a35:	5f                   	pop    %edi
 a36:	5d                   	pop    %ebp
 a37:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 a38:	8b 08                	mov    (%eax),%ecx
 a3a:	89 0a                	mov    %ecx,(%edx)
 a3c:	eb e9                	jmp    a27 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 a3e:	c7 05 f0 0d 00 00 f4 	movl   $0xdf4,0xdf0
 a45:	0d 00 00 
    base.s.size = 0;
 a48:	ba f4 0d 00 00       	mov    $0xdf4,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 a4d:	c7 05 f4 0d 00 00 f4 	movl   $0xdf4,0xdf4
 a54:	0d 00 00 
    base.s.size = 0;
 a57:	c7 05 f8 0d 00 00 00 	movl   $0x0,0xdf8
 a5e:	00 00 00 
 a61:	e9 46 ff ff ff       	jmp    9ac <malloc+0x2c>
