
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 d5 10 80       	mov    $0x8010d5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 00 30 10 80       	mov    $0x80103000,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 d6 10 80       	mov    $0x8010d614,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 14             	sub    $0x14,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 e0 8f 10 	movl   $0x80108fe0,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
8010005b:	e8 b0 53 00 00       	call   80105410 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
80100060:	ba dc 1c 11 80       	mov    $0x80111cdc,%edx

  initlock(&bcache.lock, "bcache");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100065:	c7 05 2c 1d 11 80 dc 	movl   $0x80111cdc,0x80111d2c
8010006c:	1c 11 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 30 1d 11 80 dc 	movl   $0x80111cdc,0x80111d30
80100076:	1c 11 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 dc 1c 11 80 	movl   $0x80111cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 e7 8f 10 	movl   $0x80108fe7,0x4(%esp)
8010009b:	80 
8010009c:	e8 5f 52 00 00       	call   80105300 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 30 1d 11 80       	mov    0x80111d30,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d dc 1c 11 80       	cmp    $0x80111cdc,%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b4:	89 1d 30 1d 11 80    	mov    %ebx,0x80111d30

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000dc:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000e6:	e8 a5 53 00 00       	call   80105490 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 30 1d 11 80    	mov    0x80111d30,%ebx
801000f1:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c 1d 11 80    	mov    0x80111d2c,%ebx
80100126:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
80100161:	e8 6a 54 00 00       	call   801055d0 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 cf 51 00 00       	call   80105340 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!(b->flags & B_VALID)) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 42 21 00 00       	call   801022c0 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100188:	c7 04 24 ee 8f 10 80 	movl   $0x80108fee,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 2b 52 00 00       	call   801053e0 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 f7 20 00 00       	jmp    801022c0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	c7 04 24 ff 8f 10 80 	movl   $0x80108fff,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 ea 51 00 00       	call   801053e0 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 9e 51 00 00       	call   801053a0 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
80100209:	e8 82 52 00 00       	call   80105490 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 30 1d 11 80       	mov    0x80111d30,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 dc 1c 11 80 	movl   $0x80111cdc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100235:	a1 30 1d 11 80       	mov    0x80111d30,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 30 1d 11 80    	mov    %ebx,0x80111d30
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 e0 d5 10 80 	movl   $0x8010d5e0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
80100250:	e9 7b 53 00 00       	jmp    801055d0 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100255:	c7 04 24 06 90 10 80 	movl   $0x80109006,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 c9 15 00 00       	call   80101850 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010028e:	e8 fd 51 00 00       	call   80105490 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 26                	jmp    801002c9 <consoleread+0x59>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(proc->killed){
801002a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801002ae:	8b 40 24             	mov    0x24(%eax),%eax
801002b1:	85 c0                	test   %eax,%eax
801002b3:	75 73                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b5:	c7 44 24 04 20 c5 10 	movl   $0x8010c520,0x4(%esp)
801002bc:	80 
801002bd:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
801002c4:	e8 77 39 00 00       	call   80103c40 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c9:	a1 c0 1f 11 80       	mov    0x80111fc0,%eax
801002ce:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
801002d4:	74 d2                	je     801002a8 <consoleread+0x38>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d6:	8d 50 01             	lea    0x1(%eax),%edx
801002d9:	89 15 c0 1f 11 80    	mov    %edx,0x80111fc0
801002df:	89 c2                	mov    %eax,%edx
801002e1:	83 e2 7f             	and    $0x7f,%edx
801002e4:	0f b6 8a 40 1f 11 80 	movzbl -0x7feee0c0(%edx),%ecx
801002eb:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ee:	83 fa 04             	cmp    $0x4,%edx
801002f1:	74 56                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f3:	83 c6 01             	add    $0x1,%esi
    --n;
801002f6:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f9:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002fc:	88 4e ff             	mov    %cl,-0x1(%esi)
    --n;
    if(c == '\n')
801002ff:	74 52                	je     80100353 <consoleread+0xe3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100301:	85 db                	test   %ebx,%ebx
80100303:	75 c4                	jne    801002c9 <consoleread+0x59>
80100305:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100308:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010030f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100312:	e8 b9 52 00 00       	call   801055d0 <release>
  ilock(ip);
80100317:	89 3c 24             	mov    %edi,(%esp)
8010031a:	e8 61 14 00 00       	call   80101780 <ilock>
8010031f:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100322:	eb 1d                	jmp    80100341 <consoleread+0xd1>
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(proc->killed){
        release(&cons.lock);
80100328:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010032f:	e8 9c 52 00 00       	call   801055d0 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 44 14 00 00       	call   80101780 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
8010034e:	a3 c0 1f 11 80       	mov    %eax,0x80111fc0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ae                	jmp    80100308 <consoleread+0x98>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb aa                	jmp    80100308 <consoleread+0x98>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
80100369:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
8010036f:	8d 5d d0             	lea    -0x30(%ebp),%ebx
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100372:	c7 05 54 c5 10 80 00 	movl   $0x0,0x8010c554
80100379:	00 00 00 
8010037c:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
8010037f:	0f b6 00             	movzbl (%eax),%eax
80100382:	c7 04 24 0d 90 10 80 	movl   $0x8010900d,(%esp)
80100389:	89 44 24 04          	mov    %eax,0x4(%esp)
8010038d:	e8 be 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
80100392:	8b 45 08             	mov    0x8(%ebp),%eax
80100395:	89 04 24             	mov    %eax,(%esp)
80100398:	e8 b3 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
8010039d:	c7 04 24 06 95 10 80 	movl   $0x80109506,(%esp)
801003a4:	e8 a7 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a9:	8d 45 08             	lea    0x8(%ebp),%eax
801003ac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003b0:	89 04 24             	mov    %eax,(%esp)
801003b3:	e8 78 50 00 00       	call   80105430 <getcallerpcs>
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 29 90 10 80 	movl   $0x80109029,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 c5 10 80 01 	movl   $0x1,0x8010c558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003e0:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 92 6a 00 00       	call   80106ea0 <uartputc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx

  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 

  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 e2 69 00 00       	call   80106ea0 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 d6 69 00 00       	call   80106ea0 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 ca 69 00 00       	call   80106ea0 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 bf 51 00 00       	call   801056c0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 02 51 00 00       	call   80105620 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010052a:	c7 04 24 2d 90 10 80 	movl   $0x8010902d,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  else
    x = xx;

  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 58 90 10 80 	movzbl -0x7fef6fa8(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>

  if(sign)
801005a8:	85 ff                	test   %edi,%edi
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  }while((x /= base) != 0);

  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
    consputc(buf[i]);
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 49 12 00 00       	call   80101850 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010060e:	e8 7d 4e 00 00       	call   80105490 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010062f:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
80100636:	e8 95 4f 00 00       	call   801055d0 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 3a 11 00 00       	call   80101780 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100659:	a1 54 c5 10 80       	mov    0x8010c554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
    acquire(&cons.lock);

  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
      break;
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
      consputc(c);
      break;
    }
  }

  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
801006f3:	e8 d8 4e 00 00       	call   801055d0 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 40 90 10 80       	mov    $0x80109040,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
80100790:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
80100797:	e8 f4 4c 00 00       	call   80105490 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007a1:	c7 04 24 47 90 10 80 	movl   $0x80109047,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007be:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
801007c5:	e8 c6 4c 00 00       	call   80105490 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801007f2:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
801007f7:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 c8 1f 11 80       	mov    %eax,0x80111fc8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100820:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
80100827:	e8 a4 4d 00 00       	call   801055d0 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 c0 1f 11 80    	sub    0x80111fc0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 c8 1f 11 80    	mov    %edx,0x80111fc8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 40 1f 11 80    	mov    %cl,-0x7feee0c0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d c0 1f 11 80    	mov    0x80111fc0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008a6:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ad:	a3 c4 1f 11 80       	mov    %eax,0x80111fc4
          wakeup(&input.r);
801008b2:	e8 39 35 00 00       	call   80103df0 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008c0:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
801008c5:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008d8:	a3 c8 1f 11 80       	mov    %eax,0x80111fc8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008e7:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
801008ec:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100900:	80 ba 40 1f 11 80 0a 	cmpb   $0xa,-0x7feee0c0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 b4 35 00 00       	jmp    80103ee0 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 40 1f 11 80 0a 	movb   $0xa,-0x7feee0c0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 50 90 10 	movl   $0x80109050,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
80100965:	e8 a6 4a 00 00       	call   80105410 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
8010096a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
80100971:	c7 05 ec 2c 11 80 f0 	movl   $0x801005f0,0x80112cec
80100978:	05 10 80 
  devsw[CONSOLE].read = consoleread;
8010097b:	c7 05 e8 2c 11 80 70 	movl   $0x80100270,0x80112ce8
80100982:	02 10 80 
  cons.locking = 1;
80100985:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
8010098c:	00 00 00 

  picenable(IRQ_KBD);
8010098f:	e8 0c 2a 00 00       	call   801033a0 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100994:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010099b:	00 
8010099c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801009a3:	e8 a8 1a 00 00       	call   80102450 <ioapicenable>
}
801009a8:	c9                   	leave  
801009a9:	c3                   	ret    
801009aa:	66 90                	xchg   %ax,%ax
801009ac:	66 90                	xchg   %ax,%ax
801009ae:	66 90                	xchg   %ax,%ax

801009b0 <exec>:
#include "elf.h"
#include "mlfq.h"

    int
exec(char *path, char **argv)
{
801009b0:	55                   	push   %ebp
801009b1:	89 e5                	mov    %esp,%ebp
801009b3:	57                   	push   %edi
801009b4:	56                   	push   %esi
801009b5:	53                   	push   %ebx
801009b6:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pde_t *pgdir, *oldpgdir;

    begin_op();
801009bc:	e8 6f 23 00 00       	call   80102d30 <begin_op>

    if((ip = namei(path)) == 0){
801009c1:	8b 45 08             	mov    0x8(%ebp),%eax
801009c4:	89 04 24             	mov    %eax,(%esp)
801009c7:	e8 c4 16 00 00       	call   80102090 <namei>
801009cc:	85 c0                	test   %eax,%eax
801009ce:	89 c3                	mov    %eax,%ebx
801009d0:	74 37                	je     80100a09 <exec+0x59>
        end_op();
        return -1;
    }
    ilock(ip);
801009d2:	89 04 24             	mov    %eax,(%esp)
801009d5:	e8 a6 0d 00 00       	call   80101780 <ilock>
    pgdir = 0;

    // Check ELF header
    if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009da:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009e0:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e7:	00 
801009e8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ef:	00 
801009f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f4:	89 1c 24             	mov    %ebx,(%esp)
801009f7:	e8 f4 10 00 00       	call   80101af0 <readi>
801009fc:	83 f8 34             	cmp    $0x34,%eax
801009ff:	74 1f                	je     80100a20 <exec+0x70>

bad:
    if(pgdir)
        freevm(pgdir);
    if(ip){
        iunlockput(ip);
80100a01:	89 1c 24             	mov    %ebx,(%esp)
80100a04:	e8 97 10 00 00       	call   80101aa0 <iunlockput>
        end_op();
80100a09:	e8 92 23 00 00       	call   80102da0 <end_op>
    }
    return -1;
80100a0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a13:	81 c4 1c 01 00 00    	add    $0x11c,%esp
80100a19:	5b                   	pop    %ebx
80100a1a:	5e                   	pop    %esi
80100a1b:	5f                   	pop    %edi
80100a1c:	5d                   	pop    %ebp
80100a1d:	c3                   	ret    
80100a1e:	66 90                	xchg   %ax,%ax
    pgdir = 0;

    // Check ELF header
    if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
        goto bad;
    if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d5                	jne    80100a01 <exec+0x51>
        goto bad;

    if((pgdir = setupkvm()) == 0)
80100a2c:	e8 ef 72 00 00       	call   80107d20 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a39:	74 c6                	je     80100a01 <exec+0x51>
        goto bad;

    // Load program into memory.
    sz = 0;
    for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi

    if((pgdir = setupkvm()) == 0)
        goto bad;

    // Load program into memory.
    sz = 0;
80100a49:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100a50:	00 00 00 
    for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x183>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xc5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x183>
        if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 5d 10 00 00       	call   80101af0 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x170>
            goto bad;
        if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xb0>
            continue;
        if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x170>
            goto bad;
        if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x170>
            goto bad;
        if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 19 75 00 00       	call   80107ff0 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x170>
            goto bad;
        if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x170>
            goto bad;
        if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 18 74 00 00       	call   80107f30 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xb0>

    return 0;

bad:
    if(pgdir)
        freevm(pgdir);
80100b20:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 d2 75 00 00       	call   80108100 <freevm>
80100b2e:	e9 ce fe ff ff       	jmp    80100a01 <exec+0x51>
        if(ph.vaddr % PGSIZE != 0)
            goto bad;
        if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
            goto bad;
    }
    iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 65 0f 00 00       	call   80101aa0 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80100b40:	e8 5b 22 00 00       	call   80102da0 <end_op>
    ip = 0;

    // Allocate two pages at the next page boundary.
    // Make the first inaccessible.  Use the second as the user stack.
    sz = PGROUNDUP(sz);
80100b45:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b55:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 7f 74 00 00       	call   80107ff0 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b79:	75 18                	jne    80100b93 <exec+0x1e3>

    return 0;

bad:
    if(pgdir)
        freevm(pgdir);
80100b7b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 77 75 00 00       	call   80108100 <freevm>
    if(ip){
        iunlockput(ip);
        end_op();
    }
    return -1;
80100b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8e:	e9 80 fe ff ff       	jmp    80100a13 <exec+0x63>
    // Allocate two pages at the next page boundary.
    // Make the first inaccessible.  Use the second as the user stack.
    sz = PGROUNDUP(sz);
    if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
        goto bad;
    clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100b93:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100b99:	89 d8                	mov    %ebx,%eax
80100b9b:	2d 00 20 00 00       	sub    $0x2000,%eax
80100ba0:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ba4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100baa:	89 04 24             	mov    %eax,(%esp)
80100bad:	e8 ce 75 00 00       	call   80108180 <clearpteu>
    sp = sz;

    // Push argument strings, prepare rest of stack in ustack.
    for(argc = 0; argv[argc]; argc++) {
80100bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bb5:	8b 00                	mov    (%eax),%eax
80100bb7:	85 c0                	test   %eax,%eax
80100bb9:	0f 84 87 01 00 00    	je     80100d46 <exec+0x396>
80100bbf:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100bc2:	31 f6                	xor    %esi,%esi
80100bc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bc7:	89 f2                	mov    %esi,%edx
80100bc9:	89 fe                	mov    %edi,%esi
80100bcb:	89 d7                	mov    %edx,%edi
80100bcd:	83 c1 04             	add    $0x4,%ecx
80100bd0:	eb 0e                	jmp    80100be0 <exec+0x230>
80100bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100bd8:	83 c1 04             	add    $0x4,%ecx
        if(argc >= MAXARG)
80100bdb:	83 ff 20             	cmp    $0x20,%edi
80100bde:	74 9b                	je     80100b7b <exec+0x1cb>
            goto bad;
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100be0:	89 04 24             	mov    %eax,(%esp)
80100be3:	89 8d f0 fe ff ff    	mov    %ecx,-0x110(%ebp)
80100be9:	e8 52 4c 00 00       	call   80105840 <strlen>
80100bee:	f7 d0                	not    %eax
80100bf0:	01 c3                	add    %eax,%ebx
        if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bf2:	8b 06                	mov    (%esi),%eax

    // Push argument strings, prepare rest of stack in ustack.
    for(argc = 0; argv[argc]; argc++) {
        if(argc >= MAXARG)
            goto bad;
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bf4:	83 e3 fc             	and    $0xfffffffc,%ebx
        if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bf7:	89 04 24             	mov    %eax,(%esp)
80100bfa:	e8 41 4c 00 00       	call   80105840 <strlen>
80100bff:	83 c0 01             	add    $0x1,%eax
80100c02:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c06:	8b 06                	mov    (%esi),%eax
80100c08:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c0c:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c10:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c16:	89 04 24             	mov    %eax,(%esp)
80100c19:	e8 c2 76 00 00       	call   801082e0 <copyout>
80100c1e:	85 c0                	test   %eax,%eax
80100c20:	0f 88 55 ff ff ff    	js     80100b7b <exec+0x1cb>
        goto bad;
    clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
    sp = sz;

    // Push argument strings, prepare rest of stack in ustack.
    for(argc = 0; argv[argc]; argc++) {
80100c26:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
        if(argc >= MAXARG)
            goto bad;
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
        if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
            goto bad;
        ustack[3+argc] = sp;
80100c2c:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c32:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
        goto bad;
    clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
    sp = sz;

    // Push argument strings, prepare rest of stack in ustack.
    for(argc = 0; argv[argc]; argc++) {
80100c39:	83 c7 01             	add    $0x1,%edi
80100c3c:	8b 01                	mov    (%ecx),%eax
80100c3e:	89 ce                	mov    %ecx,%esi
80100c40:	85 c0                	test   %eax,%eax
80100c42:	75 94                	jne    80100bd8 <exec+0x228>
80100c44:	89 fe                	mov    %edi,%esi
    }
    ustack[3+argc] = 0;

    ustack[0] = 0xffffffff;  // fake return PC
    ustack[1] = argc;
    ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c46:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100c4d:	89 d9                	mov    %ebx,%ecx
80100c4f:	29 c1                	sub    %eax,%ecx

    sp -= (3+argc+1) * 4;
80100c51:	83 c0 0c             	add    $0xc,%eax
80100c54:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c56:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c5a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c60:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c64:	89 5c 24 04          	mov    %ebx,0x4(%esp)
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
        if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
            goto bad;
        ustack[3+argc] = sp;
    }
    ustack[3+argc] = 0;
80100c68:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100c6f:	00 00 00 00 
    ustack[0] = 0xffffffff;  // fake return PC
    ustack[1] = argc;
    ustack[2] = sp - (argc+1)*4;  // argv pointer

    sp -= (3+argc+1) * 4;
    if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c73:	89 04 24             	mov    %eax,(%esp)
            goto bad;
        ustack[3+argc] = sp;
    }
    ustack[3+argc] = 0;

    ustack[0] = 0xffffffff;  // fake return PC
80100c76:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c7d:	ff ff ff 
    ustack[1] = argc;
80100c80:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
    ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c86:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

    sp -= (3+argc+1) * 4;
    if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c8c:	e8 4f 76 00 00       	call   801082e0 <copyout>
80100c91:	85 c0                	test   %eax,%eax
80100c93:	0f 88 e2 fe ff ff    	js     80100b7b <exec+0x1cb>
        goto bad;

    // Save program name for debugging.
    for(last=s=path; *s; s++)
80100c99:	8b 45 08             	mov    0x8(%ebp),%eax
80100c9c:	0f b6 10             	movzbl (%eax),%edx
80100c9f:	84 d2                	test   %dl,%dl
80100ca1:	74 19                	je     80100cbc <exec+0x30c>
80100ca3:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100ca6:	83 c0 01             	add    $0x1,%eax
        if(*s == '/')
            last = s+1;
80100ca9:	80 fa 2f             	cmp    $0x2f,%dl
    sp -= (3+argc+1) * 4;
    if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
        goto bad;

    // Save program name for debugging.
    for(last=s=path; *s; s++)
80100cac:	0f b6 10             	movzbl (%eax),%edx
        if(*s == '/')
            last = s+1;
80100caf:	0f 44 c8             	cmove  %eax,%ecx
80100cb2:	83 c0 01             	add    $0x1,%eax
    sp -= (3+argc+1) * 4;
    if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
        goto bad;

    // Save program name for debugging.
    for(last=s=path; *s; s++)
80100cb5:	84 d2                	test   %dl,%dl
80100cb7:	75 f0                	jne    80100ca9 <exec+0x2f9>
80100cb9:	89 4d 08             	mov    %ecx,0x8(%ebp)
        if(*s == '/')
            last = s+1;
    safestrcpy(proc->name, last, sizeof(proc->name));
80100cbc:	8b 45 08             	mov    0x8(%ebp),%eax
80100cbf:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100cc6:	00 
80100cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ccb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cd1:	83 c0 6c             	add    $0x6c,%eax
80100cd4:	89 04 24             	mov    %eax,(%esp)
80100cd7:	e8 24 4b 00 00       	call   80105800 <safestrcpy>

    // Commit to the user image.
    oldpgdir = proc->pgdir;
80100cdc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    proc->pgdir = pgdir;
80100ce2:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
        if(*s == '/')
            last = s+1;
    safestrcpy(proc->name, last, sizeof(proc->name));

    // Commit to the user image.
    oldpgdir = proc->pgdir;
80100ce8:	8b 70 04             	mov    0x4(%eax),%esi
    proc->pgdir = pgdir;
80100ceb:	89 48 04             	mov    %ecx,0x4(%eax)
    proc->sz = sz;
80100cee:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100cf4:	89 08                	mov    %ecx,(%eax)
    proc->tf->eip = elf.entry;  // main
80100cf6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cfc:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100d02:	8b 50 18             	mov    0x18(%eax),%edx
80100d05:	89 4a 38             	mov    %ecx,0x38(%edx)
    proc->tf->esp = sp;
80100d08:	8b 50 18             	mov    0x18(%eax),%edx
80100d0b:	89 5a 44             	mov    %ebx,0x44(%edx)

    switchuvm(proc);
80100d0e:	89 04 24             	mov    %eax,(%esp)
80100d11:	e8 ca 70 00 00       	call   80107de0 <switchuvm>
    if(proc->isthread ==0)
80100d16:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
        freevm(oldpgdir);

    return 0;
80100d1d:	31 c0                	xor    %eax,%eax
    proc->sz = sz;
    proc->tf->eip = elf.entry;  // main
    proc->tf->esp = sp;

    switchuvm(proc);
    if(proc->isthread ==0)
80100d1f:	66 83 ba 8c 00 00 00 	cmpw   $0x0,0x8c(%edx)
80100d26:	00 
80100d27:	0f 85 e6 fc ff ff    	jne    80100a13 <exec+0x63>
        freevm(oldpgdir);
80100d2d:	89 34 24             	mov    %esi,(%esp)
80100d30:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100d36:	e8 c5 73 00 00       	call   80108100 <freevm>
80100d3b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100d41:	e9 cd fc ff ff       	jmp    80100a13 <exec+0x63>
        goto bad;
    clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
    sp = sz;

    // Push argument strings, prepare rest of stack in ustack.
    for(argc = 0; argv[argc]; argc++) {
80100d46:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100d4c:	31 f6                	xor    %esi,%esi
80100d4e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100d54:	e9 ed fe ff ff       	jmp    80100c46 <exec+0x296>
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	c7 44 24 04 69 90 10 	movl   $0x80109069,0x4(%esp)
80100d6d:	80 
80100d6e:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80100d75:	e8 96 46 00 00       	call   80105410 <initlock>
}
80100d7a:	c9                   	leave  
80100d7b:	c3                   	ret    
80100d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb 74 23 11 80       	mov    $0x80112374,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d89:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d8c:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80100d93:	e8 f8 46 00 00       	call   80105490 <acquire>
80100d98:	eb 11                	jmp    80100dab <filealloc+0x2b>
80100d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb d4 2c 11 80    	cmp    $0x80112cd4,%ebx
80100da9:	74 25                	je     80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100db9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dc0:	e8 0b 48 00 00       	call   801055d0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc5:	83 c4 14             	add    $0x14,%esp
  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
80100dc8:	89 d8                	mov    %ebx,%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dca:	5b                   	pop    %ebx
80100dcb:	5d                   	pop    %ebp
80100dcc:	c3                   	ret    
80100dcd:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dd0:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80100dd7:	e8 f4 47 00 00       	call   801055d0 <release>
  return 0;
}
80100ddc:	83 c4 14             	add    $0x14,%esp
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
80100ddf:	31 c0                	xor    %eax,%eax
}
80100de1:	5b                   	pop    %ebx
80100de2:	5d                   	pop    %ebp
80100de3:	c3                   	ret    
80100de4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 14             	sub    $0x14,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80100e01:	e8 8a 46 00 00       	call   80105490 <acquire>
  if(f->ref < 1)
80100e06:	8b 43 04             	mov    0x4(%ebx),%eax
80100e09:	85 c0                	test   %eax,%eax
80100e0b:	7e 1a                	jle    80100e27 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100e0d:	83 c0 01             	add    $0x1,%eax
80100e10:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e13:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80100e1a:	e8 b1 47 00 00       	call   801055d0 <release>
  return f;
}
80100e1f:	83 c4 14             	add    $0x14,%esp
80100e22:	89 d8                	mov    %ebx,%eax
80100e24:	5b                   	pop    %ebx
80100e25:	5d                   	pop    %ebp
80100e26:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e27:	c7 04 24 70 90 10 80 	movl   $0x80109070,(%esp)
80100e2e:	e8 2d f5 ff ff       	call   80100360 <panic>
80100e33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 1c             	sub    $0x1c,%esp
80100e49:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80100e53:	e8 38 46 00 00       	call   80105490 <acquire>
  if(f->ref < 1)
80100e58:	8b 57 04             	mov    0x4(%edi),%edx
80100e5b:	85 d2                	test   %edx,%edx
80100e5d:	0f 8e 89 00 00 00    	jle    80100eec <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e63:	83 ea 01             	sub    $0x1,%edx
80100e66:	85 d2                	test   %edx,%edx
80100e68:	89 57 04             	mov    %edx,0x4(%edi)
80100e6b:	74 13                	je     80100e80 <fileclose+0x40>
    release(&ftable.lock);
80100e6d:	c7 45 08 40 23 11 80 	movl   $0x80112340,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e74:	83 c4 1c             	add    $0x1c,%esp
80100e77:	5b                   	pop    %ebx
80100e78:	5e                   	pop    %esi
80100e79:	5f                   	pop    %edi
80100e7a:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e7b:	e9 50 47 00 00       	jmp    801055d0 <release>
    return;
  }
  ff = *f;
80100e80:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e84:	8b 37                	mov    (%edi),%esi
80100e86:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
80100e89:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e8f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e92:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e95:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e9f:	e8 2c 47 00 00       	call   801055d0 <release>

  if(ff.type == FD_PIPE)
80100ea4:	83 fe 01             	cmp    $0x1,%esi
80100ea7:	74 0f                	je     80100eb8 <fileclose+0x78>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ea9:	83 fe 02             	cmp    $0x2,%esi
80100eac:	74 22                	je     80100ed0 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100eae:	83 c4 1c             	add    $0x1c,%esp
80100eb1:	5b                   	pop    %ebx
80100eb2:	5e                   	pop    %esi
80100eb3:	5f                   	pop    %edi
80100eb4:	5d                   	pop    %ebp
80100eb5:	c3                   	ret    
80100eb6:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100eb8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100ebc:	89 1c 24             	mov    %ebx,(%esp)
80100ebf:	89 74 24 04          	mov    %esi,0x4(%esp)
80100ec3:	e8 88 26 00 00       	call   80103550 <pipeclose>
80100ec8:	eb e4                	jmp    80100eae <fileclose+0x6e>
80100eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ed0:	e8 5b 1e 00 00       	call   80102d30 <begin_op>
    iput(ff.ip);
80100ed5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ed8:	89 04 24             	mov    %eax,(%esp)
80100edb:	e8 b0 09 00 00       	call   80101890 <iput>
    end_op();
  }
}
80100ee0:	83 c4 1c             	add    $0x1c,%esp
80100ee3:	5b                   	pop    %ebx
80100ee4:	5e                   	pop    %esi
80100ee5:	5f                   	pop    %edi
80100ee6:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100ee7:	e9 b4 1e 00 00       	jmp    80102da0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100eec:	c7 04 24 78 90 10 80 	movl   $0x80109078,(%esp)
80100ef3:	e8 68 f4 ff ff       	call   80100360 <panic>
80100ef8:	90                   	nop
80100ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f00 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 14             	sub    $0x14,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f0a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f0d:	75 31                	jne    80100f40 <filestat+0x40>
    ilock(f->ip);
80100f0f:	8b 43 10             	mov    0x10(%ebx),%eax
80100f12:	89 04 24             	mov    %eax,(%esp)
80100f15:	e8 66 08 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f1d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f21:	8b 43 10             	mov    0x10(%ebx),%eax
80100f24:	89 04 24             	mov    %eax,(%esp)
80100f27:	e8 94 0b 00 00       	call   80101ac0 <stati>
    iunlock(f->ip);
80100f2c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f2f:	89 04 24             	mov    %eax,(%esp)
80100f32:	e8 19 09 00 00       	call   80101850 <iunlock>
    return 0;
  }
  return -1;
}
80100f37:	83 c4 14             	add    $0x14,%esp
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
80100f3a:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f3c:	5b                   	pop    %ebx
80100f3d:	5d                   	pop    %ebp
80100f3e:	c3                   	ret    
80100f3f:	90                   	nop
80100f40:	83 c4 14             	add    $0x14,%esp
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f48:	5b                   	pop    %ebx
80100f49:	5d                   	pop    %ebp
80100f4a:	c3                   	ret    
80100f4b:	90                   	nop
80100f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f50 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 1c             	sub    $0x1c,%esp
80100f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f62:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f66:	74 68                	je     80100fd0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f68:	8b 03                	mov    (%ebx),%eax
80100f6a:	83 f8 01             	cmp    $0x1,%eax
80100f6d:	74 49                	je     80100fb8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f6f:	83 f8 02             	cmp    $0x2,%eax
80100f72:	75 63                	jne    80100fd7 <fileread+0x87>
    ilock(f->ip);
80100f74:	8b 43 10             	mov    0x10(%ebx),%eax
80100f77:	89 04 24             	mov    %eax,(%esp)
80100f7a:	e8 01 08 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f83:	8b 43 14             	mov    0x14(%ebx),%eax
80100f86:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f8a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f8e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f91:	89 04 24             	mov    %eax,(%esp)
80100f94:	e8 57 0b 00 00       	call   80101af0 <readi>
80100f99:	85 c0                	test   %eax,%eax
80100f9b:	89 c6                	mov    %eax,%esi
80100f9d:	7e 03                	jle    80100fa2 <fileread+0x52>
      f->off += r;
80100f9f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa2:	8b 43 10             	mov    0x10(%ebx),%eax
80100fa5:	89 04 24             	mov    %eax,(%esp)
80100fa8:	e8 a3 08 00 00       	call   80101850 <iunlock>
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fad:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100faf:	83 c4 1c             	add    $0x1c,%esp
80100fb2:	5b                   	pop    %ebx
80100fb3:	5e                   	pop    %esi
80100fb4:	5f                   	pop    %edi
80100fb5:	5d                   	pop    %ebp
80100fb6:	c3                   	ret    
80100fb7:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fb8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fbb:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fbe:	83 c4 1c             	add    $0x1c,%esp
80100fc1:	5b                   	pop    %ebx
80100fc2:	5e                   	pop    %esi
80100fc3:	5f                   	pop    %edi
80100fc4:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fc5:	e9 36 27 00 00       	jmp    80103700 <piperead>
80100fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fd5:	eb d8                	jmp    80100faf <fileread+0x5f>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fd7:	c7 04 24 82 90 10 80 	movl   $0x80109082,(%esp)
80100fde:	e8 7d f3 ff ff       	call   80100360 <panic>
80100fe3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 2c             	sub    $0x2c,%esp
80100ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ffc:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fff:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101002:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101005:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
8010100c:	0f 84 ae 00 00 00    	je     801010c0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 07                	mov    (%edi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c2 00 00 00    	je     801010df <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d7 00 00 00    	jne    801010fd <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101029:	31 db                	xor    %ebx,%ebx
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 31                	jg     80101060 <filewrite+0x70>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101038:	8b 4f 10             	mov    0x10(%edi),%ecx
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
8010103b:	01 47 14             	add    %eax,0x14(%edi)
8010103e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101041:	89 0c 24             	mov    %ecx,(%esp)
80101044:	e8 07 08 00 00       	call   80101850 <iunlock>
      end_op();
80101049:	e8 52 1d 00 00       	call   80102da0 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101051:	39 f0                	cmp    %esi,%eax
80101053:	0f 85 98 00 00 00    	jne    801010f1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101059:	01 c3                	add    %eax,%ebx
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010105b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010105e:	7e 70                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101060:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101063:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80101068:	29 de                	sub    %ebx,%esi
8010106a:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
80101070:	0f 4f f0             	cmovg  %eax,%esi
      if(n1 > max)
        n1 = max;

      begin_op();
80101073:	e8 b8 1c 00 00       	call   80102d30 <begin_op>
      ilock(f->ip);
80101078:	8b 47 10             	mov    0x10(%edi),%eax
8010107b:	89 04 24             	mov    %eax,(%esp)
8010107e:	e8 fd 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101083:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101087:	8b 47 14             	mov    0x14(%edi),%eax
8010108a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010108e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101091:	01 d8                	add    %ebx,%eax
80101093:	89 44 24 04          	mov    %eax,0x4(%esp)
80101097:	8b 47 10             	mov    0x10(%edi),%eax
8010109a:	89 04 24             	mov    %eax,(%esp)
8010109d:	e8 4e 0b 00 00       	call   80101bf0 <writei>
801010a2:	85 c0                	test   %eax,%eax
801010a4:	7f 92                	jg     80101038 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
801010a6:	8b 4f 10             	mov    0x10(%edi),%ecx
801010a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010ac:	89 0c 24             	mov    %ecx,(%esp)
801010af:	e8 9c 07 00 00       	call   80101850 <iunlock>
      end_op();
801010b4:	e8 e7 1c 00 00       	call   80102da0 <end_op>

      if(r < 0)
801010b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010bc:	85 c0                	test   %eax,%eax
801010be:	74 91                	je     80101051 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010c0:	83 c4 2c             	add    $0x2c,%esp
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
801010c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010c8:	5b                   	pop    %ebx
801010c9:	5e                   	pop    %esi
801010ca:	5f                   	pop    %edi
801010cb:	5d                   	pop    %ebp
801010cc:	c3                   	ret    
801010cd:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010d0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010d3:	89 d8                	mov    %ebx,%eax
801010d5:	75 e9                	jne    801010c0 <filewrite+0xd0>
  }
  panic("filewrite");
}
801010d7:	83 c4 2c             	add    $0x2c,%esp
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010df:	8b 47 0c             	mov    0xc(%edi),%eax
801010e2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010e5:	83 c4 2c             	add    $0x2c,%esp
801010e8:	5b                   	pop    %ebx
801010e9:	5e                   	pop    %esi
801010ea:	5f                   	pop    %edi
801010eb:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010ec:	e9 ef 24 00 00       	jmp    801035e0 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010f1:	c7 04 24 8b 90 10 80 	movl   $0x8010908b,(%esp)
801010f8:	e8 63 f2 ff ff       	call   80100360 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010fd:	c7 04 24 91 90 10 80 	movl   $0x80109091,(%esp)
80101104:	e8 57 f2 ff ff       	call   80100360 <panic>
80101109:	66 90                	xchg   %ax,%ax
8010110b:	66 90                	xchg   %ax,%ax
8010110d:	66 90                	xchg   %ax,%ax
8010110f:	90                   	nop

80101110 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 2c             	sub    $0x2c,%esp
80101119:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010111c:	a1 40 2d 11 80       	mov    0x80112d40,%eax
80101121:	85 c0                	test   %eax,%eax
80101123:	0f 84 8c 00 00 00    	je     801011b5 <balloc+0xa5>
80101129:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101130:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101133:	89 f0                	mov    %esi,%eax
80101135:	c1 f8 0c             	sar    $0xc,%eax
80101138:	03 05 58 2d 11 80    	add    0x80112d58,%eax
8010113e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101142:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101145:	89 04 24             	mov    %eax,(%esp)
80101148:	e8 83 ef ff ff       	call   801000d0 <bread>
8010114d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101150:	a1 40 2d 11 80       	mov    0x80112d40,%eax
80101155:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101158:	31 c0                	xor    %eax,%eax
8010115a:	eb 33                	jmp    8010118f <balloc+0x7f>
8010115c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101160:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101163:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101165:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101167:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010116a:	83 e1 07             	and    $0x7,%ecx
8010116d:	bf 01 00 00 00       	mov    $0x1,%edi
80101172:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101174:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101179:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010117b:	0f b6 fb             	movzbl %bl,%edi
8010117e:	85 cf                	test   %ecx,%edi
80101180:	74 46                	je     801011c8 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101182:	83 c0 01             	add    $0x1,%eax
80101185:	83 c6 01             	add    $0x1,%esi
80101188:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010118d:	74 05                	je     80101194 <balloc+0x84>
8010118f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101192:	72 cc                	jb     80101160 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101194:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101197:	89 04 24             	mov    %eax,(%esp)
8010119a:	e8 41 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010119f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a9:	3b 05 40 2d 11 80    	cmp    0x80112d40,%eax
801011af:	0f 82 7b ff ff ff    	jb     80101130 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801011b5:	c7 04 24 9b 90 10 80 	movl   $0x8010909b,(%esp)
801011bc:	e8 9f f1 ff ff       	call   80100360 <panic>
801011c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011c8:	09 d9                	or     %ebx,%ecx
801011ca:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011cd:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
801011d1:	89 1c 24             	mov    %ebx,(%esp)
801011d4:	e8 f7 1c 00 00       	call   80102ed0 <log_write>
        brelse(bp);
801011d9:	89 1c 24             	mov    %ebx,(%esp)
801011dc:	e8 ff ef ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011e4:	89 74 24 04          	mov    %esi,0x4(%esp)
801011e8:	89 04 24             	mov    %eax,(%esp)
801011eb:	e8 e0 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801011f0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801011f7:	00 
801011f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801011ff:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
80101200:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101202:	8d 40 5c             	lea    0x5c(%eax),%eax
80101205:	89 04 24             	mov    %eax,(%esp)
80101208:	e8 13 44 00 00       	call   80105620 <memset>
  log_write(bp);
8010120d:	89 1c 24             	mov    %ebx,(%esp)
80101210:	e8 bb 1c 00 00       	call   80102ed0 <log_write>
  brelse(bp);
80101215:	89 1c 24             	mov    %ebx,(%esp)
80101218:	e8 c3 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010121d:	83 c4 2c             	add    $0x2c,%esp
80101220:	89 f0                	mov    %esi,%eax
80101222:	5b                   	pop    %ebx
80101223:	5e                   	pop    %esi
80101224:	5f                   	pop    %edi
80101225:	5d                   	pop    %ebp
80101226:	c3                   	ret    
80101227:	89 f6                	mov    %esi,%esi
80101229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101230 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	89 c7                	mov    %eax,%edi
80101236:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101237:	31 f6                	xor    %esi,%esi
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101239:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010123a:	bb 94 2d 11 80       	mov    $0x80112d94,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010123f:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101242:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101249:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010124c:	e8 3f 42 00 00       	call   80105490 <acquire>

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101251:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101254:	eb 14                	jmp    8010126a <iget+0x3a>
80101256:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101258:	85 f6                	test   %esi,%esi
8010125a:	74 3c                	je     80101298 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010125c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101262:	81 fb b4 49 11 80    	cmp    $0x801149b4,%ebx
80101268:	74 46                	je     801012b0 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010126a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010126d:	85 c9                	test   %ecx,%ecx
8010126f:	7e e7                	jle    80101258 <iget+0x28>
80101271:	39 3b                	cmp    %edi,(%ebx)
80101273:	75 e3                	jne    80101258 <iget+0x28>
80101275:	39 53 04             	cmp    %edx,0x4(%ebx)
80101278:	75 de                	jne    80101258 <iget+0x28>
      ip->ref++;
8010127a:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
8010127d:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010127f:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101286:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101289:	e8 42 43 00 00       	call   801055d0 <release>
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
8010128e:	83 c4 1c             	add    $0x1c,%esp
80101291:	89 f0                	mov    %esi,%eax
80101293:	5b                   	pop    %ebx
80101294:	5e                   	pop    %esi
80101295:	5f                   	pop    %edi
80101296:	5d                   	pop    %ebp
80101297:	c3                   	ret    
80101298:	85 c9                	test   %ecx,%ecx
8010129a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129d:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012a3:	81 fb b4 49 11 80    	cmp    $0x801149b4,%ebx
801012a9:	75 bf                	jne    8010126a <iget+0x3a>
801012ab:	90                   	nop
801012ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012b0:	85 f6                	test   %esi,%esi
801012b2:	74 29                	je     801012dd <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801012b4:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012b6:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012b9:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
801012c0:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012c7:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
801012ce:	e8 fd 42 00 00       	call   801055d0 <release>

  return ip;
}
801012d3:	83 c4 1c             	add    $0x1c,%esp
801012d6:	89 f0                	mov    %esi,%eax
801012d8:	5b                   	pop    %ebx
801012d9:	5e                   	pop    %esi
801012da:	5f                   	pop    %edi
801012db:	5d                   	pop    %ebp
801012dc:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012dd:	c7 04 24 b1 90 10 80 	movl   $0x801090b1,(%esp)
801012e4:	e8 77 f0 ff ff       	call   80100360 <panic>
801012e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801012f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	89 c3                	mov    %eax,%ebx
801012f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012fb:	83 fa 0a             	cmp    $0xa,%edx
801012fe:	77 18                	ja     80101318 <bmap+0x28>
80101300:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
80101303:	8b 46 5c             	mov    0x5c(%esi),%eax
80101306:	85 c0                	test   %eax,%eax
80101308:	0f 84 e2 00 00 00    	je     801013f0 <bmap+0x100>
    return addr;
  }


  panic("bmap: out of range");
}
8010130e:	83 c4 1c             	add    $0x1c,%esp
80101311:	5b                   	pop    %ebx
80101312:	5e                   	pop    %esi
80101313:	5f                   	pop    %edi
80101314:	5d                   	pop    %ebp
80101315:	c3                   	ret    
80101316:	66 90                	xchg   %ax,%ax
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101318:	8d 72 f5             	lea    -0xb(%edx),%esi

  if(bn < NINDIRECT){
8010131b:	83 fe 7f             	cmp    $0x7f,%esi
8010131e:	0f 86 7c 00 00 00    	jbe    801013a0 <bmap+0xb0>
      log_write(bp);
    }
    brelse(bp);
    return addr;
  }
  bn -= NINDIRECT;
80101324:	8d b2 75 ff ff ff    	lea    -0x8b(%edx),%esi

  if(bn <NDOINDIRECT){
8010132a:	81 fe ff 3f 00 00    	cmp    $0x3fff,%esi
80101330:	0f 87 14 01 00 00    	ja     8010144a <bmap+0x15a>
    // Load Doubleindirect block, allocating if necessary.
    //cprintf(" blo num : %d\n",bn);
    if((addr = ip->addrs[NDIRECT+1]) == 0)
80101336:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010133c:	85 c0                	test   %eax,%eax
8010133e:	0f 84 f4 00 00 00    	je     80101438 <bmap+0x148>
      ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101344:	89 44 24 04          	mov    %eax,0x4(%esp)
80101348:	8b 03                	mov    (%ebx),%eax
8010134a:	89 04 24             	mov    %eax,(%esp)
8010134d:	e8 7e ed ff ff       	call   801000d0 <bread>
80101352:	89 c2                	mov    %eax,%edx
    a = (uint*)bp->data;
    //cprintf(" here? num : %d\n",addr);
    if((addr = a[bn/NINDIRECT]) == 0){
80101354:	89 f0                	mov    %esi,%eax
80101356:	c1 e8 07             	shr    $0x7,%eax
80101359:	8d 7c 82 5c          	lea    0x5c(%edx,%eax,4),%edi
8010135d:	8b 07                	mov    (%edi),%eax
8010135f:	85 c0                	test   %eax,%eax
80101361:	0f 84 b1 00 00 00    	je     80101418 <bmap+0x128>
      a[bn/NINDIRECT] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101367:	89 14 24             	mov    %edx,(%esp)
    //cprintf(" here? num : %d\n",addr);
    bp = bread(ip->dev, a[bn/NINDIRECT]);
    a = (uint*)bp->data;
    if((addr = a[bn%NINDIRECT]) == 0){
8010136a:	83 e6 7f             	and    $0x7f,%esi
    //cprintf(" here? num : %d\n",addr);
    if((addr = a[bn/NINDIRECT]) == 0){
      a[bn/NINDIRECT] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
8010136d:	e8 6e ee ff ff       	call   801001e0 <brelse>
    //cprintf(" here? num : %d\n",addr);
    bp = bread(ip->dev, a[bn/NINDIRECT]);
80101372:	8b 07                	mov    (%edi),%eax
80101374:	89 44 24 04          	mov    %eax,0x4(%esp)
80101378:	8b 03                	mov    (%ebx),%eax
8010137a:	89 04 24             	mov    %eax,(%esp)
8010137d:	e8 4e ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn%NINDIRECT]) == 0){
80101382:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
      a[bn/NINDIRECT] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    //cprintf(" here? num : %d\n",addr);
    bp = bread(ip->dev, a[bn/NINDIRECT]);
80101386:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn%NINDIRECT]) == 0){
80101388:	8b 32                	mov    (%edx),%esi
8010138a:	85 f6                	test   %esi,%esi
8010138c:	74 36                	je     801013c4 <bmap+0xd4>
        a[bn%NINDIRECT] = addr = balloc(ip->dev);
        log_write(bp);
    }
    //cprintf(" here? num : %d\n",addr);

    brelse(bp);
8010138e:	89 3c 24             	mov    %edi,(%esp)
80101391:	e8 4a ee ff ff       	call   801001e0 <brelse>
    return addr;
80101396:	89 f0                	mov    %esi,%eax
  }


  panic("bmap: out of range");
}
80101398:	83 c4 1c             	add    $0x1c,%esp
8010139b:	5b                   	pop    %ebx
8010139c:	5e                   	pop    %esi
8010139d:	5f                   	pop    %edi
8010139e:	5d                   	pop    %ebp
8010139f:	c3                   	ret    
  }
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801013a0:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
801013a6:	85 c0                	test   %eax,%eax
801013a8:	74 5e                	je     80101408 <bmap+0x118>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801013ae:	8b 03                	mov    (%ebx),%eax
801013b0:	89 04 24             	mov    %eax,(%esp)
801013b3:	e8 18 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013b8:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013bc:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013be:	8b 32                	mov    (%edx),%esi
801013c0:	85 f6                	test   %esi,%esi
801013c2:	75 ca                	jne    8010138e <bmap+0x9e>
    brelse(bp);
    //cprintf(" here? num : %d\n",addr);
    bp = bread(ip->dev, a[bn/NINDIRECT]);
    a = (uint*)bp->data;
    if((addr = a[bn%NINDIRECT]) == 0){
        a[bn%NINDIRECT] = addr = balloc(ip->dev);
801013c4:	8b 03                	mov    (%ebx),%eax
801013c6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013c9:	e8 42 fd ff ff       	call   80101110 <balloc>
801013ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013d1:	89 02                	mov    %eax,(%edx)
801013d3:	89 c6                	mov    %eax,%esi
        log_write(bp);
801013d5:	89 3c 24             	mov    %edi,(%esp)
801013d8:	e8 f3 1a 00 00       	call   80102ed0 <log_write>
    }
    //cprintf(" here? num : %d\n",addr);

    brelse(bp);
801013dd:	89 3c 24             	mov    %edi,(%esp)
801013e0:	e8 fb ed ff ff       	call   801001e0 <brelse>
    return addr;
801013e5:	89 f0                	mov    %esi,%eax
801013e7:	eb af                	jmp    80101398 <bmap+0xa8>
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
801013f0:	8b 03                	mov    (%ebx),%eax
801013f2:	e8 19 fd ff ff       	call   80101110 <balloc>
801013f7:	89 46 5c             	mov    %eax,0x5c(%esi)
    return addr;
  }


  panic("bmap: out of range");
}
801013fa:	83 c4 1c             	add    $0x1c,%esp
801013fd:	5b                   	pop    %ebx
801013fe:	5e                   	pop    %esi
801013ff:	5f                   	pop    %edi
80101400:	5d                   	pop    %ebp
80101401:	c3                   	ret    
80101402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101408:	8b 03                	mov    (%ebx),%eax
8010140a:	e8 01 fd ff ff       	call   80101110 <balloc>
8010140f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
80101415:	eb 93                	jmp    801013aa <bmap+0xba>
80101417:	90                   	nop
      ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    //cprintf(" here? num : %d\n",addr);
    if((addr = a[bn/NINDIRECT]) == 0){
      a[bn/NINDIRECT] = addr = balloc(ip->dev);
80101418:	8b 03                	mov    (%ebx),%eax
8010141a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010141d:	e8 ee fc ff ff       	call   80101110 <balloc>
      log_write(bp);
80101422:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    //cprintf(" here? num : %d\n",addr);
    if((addr = a[bn/NINDIRECT]) == 0){
      a[bn/NINDIRECT] = addr = balloc(ip->dev);
80101425:	89 07                	mov    %eax,(%edi)
      log_write(bp);
80101427:	89 14 24             	mov    %edx,(%esp)
8010142a:	e8 a1 1a 00 00       	call   80102ed0 <log_write>
8010142f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101432:	e9 30 ff ff ff       	jmp    80101367 <bmap+0x77>
80101437:	90                   	nop

  if(bn <NDOINDIRECT){
    // Load Doubleindirect block, allocating if necessary.
    //cprintf(" blo num : %d\n",bn);
    if((addr = ip->addrs[NDIRECT+1]) == 0)
      ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
80101438:	8b 03                	mov    (%ebx),%eax
8010143a:	e8 d1 fc ff ff       	call   80101110 <balloc>
8010143f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101445:	e9 fa fe ff ff       	jmp    80101344 <bmap+0x54>
    brelse(bp);
    return addr;
  }


  panic("bmap: out of range");
8010144a:	c7 04 24 c1 90 10 80 	movl   $0x801090c1,(%esp)
80101451:	e8 0a ef ff ff       	call   80100360 <panic>
80101456:	8d 76 00             	lea    0x0(%esi),%esi
80101459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101460 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	56                   	push   %esi
80101464:	53                   	push   %ebx
80101465:	83 ec 10             	sub    $0x10,%esp
  struct buf *bp;

  bp = bread(dev, 1);
80101468:	8b 45 08             	mov    0x8(%ebp),%eax
8010146b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101472:	00 
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101473:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101476:	89 04 24             	mov    %eax,(%esp)
80101479:	e8 52 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010147e:	89 34 24             	mov    %esi,(%esp)
80101481:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101488:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
80101489:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010148b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010148e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101492:	e8 29 42 00 00       	call   801056c0 <memmove>
  brelse(bp);
80101497:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010149a:	83 c4 10             	add    $0x10,%esp
8010149d:	5b                   	pop    %ebx
8010149e:	5e                   	pop    %esi
8010149f:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801014a0:	e9 3b ed ff ff       	jmp    801001e0 <brelse>
801014a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	57                   	push   %edi
801014b4:	89 d7                	mov    %edx,%edi
801014b6:	56                   	push   %esi
801014b7:	53                   	push   %ebx
801014b8:	89 c3                	mov    %eax,%ebx
801014ba:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801014bd:	89 04 24             	mov    %eax,(%esp)
801014c0:	c7 44 24 04 40 2d 11 	movl   $0x80112d40,0x4(%esp)
801014c7:	80 
801014c8:	e8 93 ff ff ff       	call   80101460 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014cd:	89 fa                	mov    %edi,%edx
801014cf:	c1 ea 0c             	shr    $0xc,%edx
801014d2:	03 15 58 2d 11 80    	add    0x80112d58,%edx
801014d8:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
801014db:	bb 01 00 00 00       	mov    $0x1,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
801014e0:	89 54 24 04          	mov    %edx,0x4(%esp)
801014e4:	e8 e7 eb ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801014e9:	89 f9                	mov    %edi,%ecx
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
801014eb:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
801014f1:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
801014f3:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014f6:	c1 fa 03             	sar    $0x3,%edx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
801014f9:	d3 e3                	shl    %cl,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
801014fb:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
801014fd:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101502:	0f b6 c8             	movzbl %al,%ecx
80101505:	85 d9                	test   %ebx,%ecx
80101507:	74 20                	je     80101529 <bfree+0x79>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101509:	f7 d3                	not    %ebx
8010150b:	21 c3                	and    %eax,%ebx
8010150d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101511:	89 34 24             	mov    %esi,(%esp)
80101514:	e8 b7 19 00 00       	call   80102ed0 <log_write>
  brelse(bp);
80101519:	89 34 24             	mov    %esi,(%esp)
8010151c:	e8 bf ec ff ff       	call   801001e0 <brelse>
}
80101521:	83 c4 1c             	add    $0x1c,%esp
80101524:	5b                   	pop    %ebx
80101525:	5e                   	pop    %esi
80101526:	5f                   	pop    %edi
80101527:	5d                   	pop    %ebp
80101528:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101529:	c7 04 24 d4 90 10 80 	movl   $0x801090d4,(%esp)
80101530:	e8 2b ee ff ff       	call   80100360 <panic>
80101535:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101540 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	53                   	push   %ebx
80101544:	bb a0 2d 11 80       	mov    $0x80112da0,%ebx
80101549:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010154c:	c7 44 24 04 e7 90 10 	movl   $0x801090e7,0x4(%esp)
80101553:	80 
80101554:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
8010155b:	e8 b0 3e 00 00       	call   80105410 <initlock>
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101560:	89 1c 24             	mov    %ebx,(%esp)
80101563:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101569:	c7 44 24 04 ee 90 10 	movl   $0x801090ee,0x4(%esp)
80101570:	80 
80101571:	e8 8a 3d 00 00       	call   80105300 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101576:	81 fb c0 49 11 80    	cmp    $0x801149c0,%ebx
8010157c:	75 e2                	jne    80101560 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }
  
  readsb(dev, &sb);
8010157e:	8b 45 08             	mov    0x8(%ebp),%eax
80101581:	c7 44 24 04 40 2d 11 	movl   $0x80112d40,0x4(%esp)
80101588:	80 
80101589:	89 04 24             	mov    %eax,(%esp)
8010158c:	e8 cf fe ff ff       	call   80101460 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101591:	a1 58 2d 11 80       	mov    0x80112d58,%eax
80101596:	c7 04 24 44 91 10 80 	movl   $0x80109144,(%esp)
8010159d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801015a1:	a1 54 2d 11 80       	mov    0x80112d54,%eax
801015a6:	89 44 24 18          	mov    %eax,0x18(%esp)
801015aa:	a1 50 2d 11 80       	mov    0x80112d50,%eax
801015af:	89 44 24 14          	mov    %eax,0x14(%esp)
801015b3:	a1 4c 2d 11 80       	mov    0x80112d4c,%eax
801015b8:	89 44 24 10          	mov    %eax,0x10(%esp)
801015bc:	a1 48 2d 11 80       	mov    0x80112d48,%eax
801015c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801015c5:	a1 44 2d 11 80       	mov    0x80112d44,%eax
801015ca:	89 44 24 08          	mov    %eax,0x8(%esp)
801015ce:	a1 40 2d 11 80       	mov    0x80112d40,%eax
801015d3:	89 44 24 04          	mov    %eax,0x4(%esp)
801015d7:	e8 74 f0 ff ff       	call   80100650 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801015dc:	83 c4 24             	add    $0x24,%esp
801015df:	5b                   	pop    %ebx
801015e0:	5d                   	pop    %ebp
801015e1:	c3                   	ret    
801015e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801015f0 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	57                   	push   %edi
801015f4:	56                   	push   %esi
801015f5:	53                   	push   %ebx
801015f6:	83 ec 2c             	sub    $0x2c,%esp
801015f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801015fc:	83 3d 48 2d 11 80 01 	cmpl   $0x1,0x80112d48
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101603:	8b 7d 08             	mov    0x8(%ebp),%edi
80101606:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101609:	0f 86 a2 00 00 00    	jbe    801016b1 <ialloc+0xc1>
8010160f:	be 01 00 00 00       	mov    $0x1,%esi
80101614:	bb 01 00 00 00       	mov    $0x1,%ebx
80101619:	eb 1a                	jmp    80101635 <ialloc+0x45>
8010161b:	90                   	nop
8010161c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101620:	89 14 24             	mov    %edx,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101623:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101626:	e8 b5 eb ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010162b:	89 de                	mov    %ebx,%esi
8010162d:	3b 1d 48 2d 11 80    	cmp    0x80112d48,%ebx
80101633:	73 7c                	jae    801016b1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101635:	89 f0                	mov    %esi,%eax
80101637:	c1 e8 03             	shr    $0x3,%eax
8010163a:	03 05 54 2d 11 80    	add    0x80112d54,%eax
80101640:	89 3c 24             	mov    %edi,(%esp)
80101643:	89 44 24 04          	mov    %eax,0x4(%esp)
80101647:	e8 84 ea ff ff       	call   801000d0 <bread>
8010164c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010164e:	89 f0                	mov    %esi,%eax
80101650:	83 e0 07             	and    $0x7,%eax
80101653:	c1 e0 06             	shl    $0x6,%eax
80101656:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010165a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010165e:	75 c0                	jne    80101620 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101660:	89 0c 24             	mov    %ecx,(%esp)
80101663:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010166a:	00 
8010166b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101672:	00 
80101673:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101676:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101679:	e8 a2 3f 00 00       	call   80105620 <memset>
      dip->type = type;
8010167e:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
80101682:	8b 55 dc             	mov    -0x24(%ebp),%edx
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
80101685:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
80101688:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
8010168b:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010168e:	89 14 24             	mov    %edx,(%esp)
80101691:	e8 3a 18 00 00       	call   80102ed0 <log_write>
      brelse(bp);
80101696:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101699:	89 14 24             	mov    %edx,(%esp)
8010169c:	e8 3f eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801016a1:	83 c4 2c             	add    $0x2c,%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801016a4:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801016a6:	5b                   	pop    %ebx
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801016a7:	89 f8                	mov    %edi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801016a9:	5e                   	pop    %esi
801016aa:	5f                   	pop    %edi
801016ab:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801016ac:	e9 7f fb ff ff       	jmp    80101230 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016b1:	c7 04 24 f4 90 10 80 	movl   $0x801090f4,(%esp)
801016b8:	e8 a3 ec ff ff       	call   80100360 <panic>
801016bd:	8d 76 00             	lea    0x0(%esi),%esi

801016c0 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	56                   	push   %esi
801016c4:	53                   	push   %ebx
801016c5:	83 ec 10             	sub    $0x10,%esp
801016c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016cb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016ce:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d1:	c1 e8 03             	shr    $0x3,%eax
801016d4:	03 05 54 2d 11 80    	add    0x80112d54,%eax
801016da:	89 44 24 04          	mov    %eax,0x4(%esp)
801016de:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801016e1:	89 04 24             	mov    %eax,(%esp)
801016e4:	e8 e7 e9 ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e9:	8b 53 a8             	mov    -0x58(%ebx),%edx
801016ec:	83 e2 07             	and    $0x7,%edx
801016ef:	c1 e2 06             	shl    $0x6,%edx
801016f2:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f6:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
801016f8:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016fc:	83 c2 0c             	add    $0xc,%edx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
801016ff:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101703:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101707:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010170b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010170f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101713:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101717:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010171b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010171e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101721:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101725:	89 14 24             	mov    %edx,(%esp)
80101728:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010172f:	00 
80101730:	e8 8b 3f 00 00       	call   801056c0 <memmove>
  log_write(bp);
80101735:	89 34 24             	mov    %esi,(%esp)
80101738:	e8 93 17 00 00       	call   80102ed0 <log_write>
  brelse(bp);
8010173d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101740:	83 c4 10             	add    $0x10,%esp
80101743:	5b                   	pop    %ebx
80101744:	5e                   	pop    %esi
80101745:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
80101746:	e9 95 ea ff ff       	jmp    801001e0 <brelse>
8010174b:	90                   	nop
8010174c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101750 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 14             	sub    $0x14,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
80101761:	e8 2a 3d 00 00       	call   80105490 <acquire>
  ip->ref++;
80101766:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010176a:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
80101771:	e8 5a 3e 00 00       	call   801055d0 <release>
  return ip;
}
80101776:	83 c4 14             	add    $0x14,%esp
80101779:	89 d8                	mov    %ebx,%eax
8010177b:	5b                   	pop    %ebx
8010177c:	5d                   	pop    %ebp
8010177d:	c3                   	ret    
8010177e:	66 90                	xchg   %ax,%ax

80101780 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	83 ec 10             	sub    $0x10,%esp
80101788:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
8010178b:	85 db                	test   %ebx,%ebx
8010178d:	0f 84 b0 00 00 00    	je     80101843 <ilock+0xc3>
80101793:	8b 43 08             	mov    0x8(%ebx),%eax
80101796:	85 c0                	test   %eax,%eax
80101798:	0f 8e a5 00 00 00    	jle    80101843 <ilock+0xc3>
    panic("ilock");

  acquiresleep(&ip->lock);
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	89 04 24             	mov    %eax,(%esp)
801017a4:	e8 97 3b 00 00       	call   80105340 <acquiresleep>

  if(!(ip->flags & I_VALID)){
801017a9:	f6 43 4c 02          	testb  $0x2,0x4c(%ebx)
801017ad:	74 09                	je     801017b8 <ilock+0x38>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801017af:	83 c4 10             	add    $0x10,%esp
801017b2:	5b                   	pop    %ebx
801017b3:	5e                   	pop    %esi
801017b4:	5d                   	pop    %ebp
801017b5:	c3                   	ret    
801017b6:	66 90                	xchg   %ax,%ax
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017b8:	8b 43 04             	mov    0x4(%ebx),%eax
801017bb:	c1 e8 03             	shr    $0x3,%eax
801017be:	03 05 54 2d 11 80    	add    0x80112d54,%eax
801017c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801017c8:	8b 03                	mov    (%ebx),%eax
801017ca:	89 04 24             	mov    %eax,(%esp)
801017cd:	e8 fe e8 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017d2:	8b 53 04             	mov    0x4(%ebx),%edx
801017d5:	83 e2 07             	and    $0x7,%edx
801017d8:	c1 e2 06             	shl    $0x6,%edx
801017db:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017df:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801017e1:	0f b7 02             	movzwl (%edx),%eax
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017e4:	83 c2 0c             	add    $0xc,%edx
  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801017e7:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
801017eb:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
801017ef:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
801017f3:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
801017f7:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
801017fb:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
801017ff:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101803:	8b 42 fc             	mov    -0x4(%edx),%eax
80101806:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101809:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010180c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101810:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101817:	00 
80101818:	89 04 24             	mov    %eax,(%esp)
8010181b:	e8 a0 3e 00 00       	call   801056c0 <memmove>
    brelse(bp);
80101820:	89 34 24             	mov    %esi,(%esp)
80101823:	e8 b8 e9 ff ff       	call   801001e0 <brelse>
    ip->flags |= I_VALID;
80101828:	83 4b 4c 02          	orl    $0x2,0x4c(%ebx)
    if(ip->type == 0)
8010182c:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101831:	0f 85 78 ff ff ff    	jne    801017af <ilock+0x2f>
      panic("ilock: no type");
80101837:	c7 04 24 0c 91 10 80 	movl   $0x8010910c,(%esp)
8010183e:	e8 1d eb ff ff       	call   80100360 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101843:	c7 04 24 06 91 10 80 	movl   $0x80109106,(%esp)
8010184a:	e8 11 eb ff ff       	call   80100360 <panic>
8010184f:	90                   	nop

80101850 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101850:	55                   	push   %ebp
80101851:	89 e5                	mov    %esp,%ebp
80101853:	56                   	push   %esi
80101854:	53                   	push   %ebx
80101855:	83 ec 10             	sub    $0x10,%esp
80101858:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010185b:	85 db                	test   %ebx,%ebx
8010185d:	74 24                	je     80101883 <iunlock+0x33>
8010185f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101862:	89 34 24             	mov    %esi,(%esp)
80101865:	e8 76 3b 00 00       	call   801053e0 <holdingsleep>
8010186a:	85 c0                	test   %eax,%eax
8010186c:	74 15                	je     80101883 <iunlock+0x33>
8010186e:	8b 43 08             	mov    0x8(%ebx),%eax
80101871:	85 c0                	test   %eax,%eax
80101873:	7e 0e                	jle    80101883 <iunlock+0x33>
    panic("iunlock");

  releasesleep(&ip->lock);
80101875:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	5b                   	pop    %ebx
8010187c:	5e                   	pop    %esi
8010187d:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010187e:	e9 1d 3b 00 00       	jmp    801053a0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101883:	c7 04 24 1b 91 10 80 	movl   $0x8010911b,(%esp)
8010188a:	e8 d1 ea ff ff       	call   80100360 <panic>
8010188f:	90                   	nop

80101890 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	57                   	push   %edi
80101894:	56                   	push   %esi
80101895:	53                   	push   %ebx
80101896:	83 ec 2c             	sub    $0x2c,%esp
80101899:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&icache.lock);
8010189c:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
801018a3:	e8 e8 3b 00 00       	call   80105490 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
801018a8:	8b 47 08             	mov    0x8(%edi),%eax
801018ab:	83 f8 01             	cmp    $0x1,%eax
801018ae:	74 19                	je     801018c9 <iput+0x39>
    ip->type = 0;
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
801018b0:	83 e8 01             	sub    $0x1,%eax
801018b3:	89 47 08             	mov    %eax,0x8(%edi)
  release(&icache.lock);
801018b6:	c7 45 08 60 2d 11 80 	movl   $0x80112d60,0x8(%ebp)
}
801018bd:	83 c4 2c             	add    $0x2c,%esp
801018c0:	5b                   	pop    %ebx
801018c1:	5e                   	pop    %esi
801018c2:	5f                   	pop    %edi
801018c3:	5d                   	pop    %ebp
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
  release(&icache.lock);
801018c4:	e9 07 3d 00 00       	jmp    801055d0 <release>
// case it has to free the inode.
void
iput(struct inode *ip)
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
801018c9:	f6 47 4c 02          	testb  $0x2,0x4c(%edi)
801018cd:	74 e1                	je     801018b0 <iput+0x20>
801018cf:	66 83 7f 56 00       	cmpw   $0x0,0x56(%edi)
801018d4:	75 da                	jne    801018b0 <iput+0x20>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
801018d6:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
801018dd:	89 fb                	mov    %edi,%ebx
801018df:	e8 ec 3c 00 00       	call   801055d0 <release>
801018e4:	8d 77 2c             	lea    0x2c(%edi),%esi
801018e7:	eb 07                	jmp    801018f0 <iput+0x60>
801018e9:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp, *bip;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018ec:	39 f3                	cmp    %esi,%ebx
801018ee:	74 1c                	je     8010190c <iput+0x7c>
    if(ip->addrs[i]){
801018f0:	8b 53 5c             	mov    0x5c(%ebx),%edx
801018f3:	85 d2                	test   %edx,%edx
801018f5:	74 f2                	je     801018e9 <iput+0x59>
      bfree(ip->dev, ip->addrs[i]);
801018f7:	8b 07                	mov    (%edi),%eax
801018f9:	83 c3 04             	add    $0x4,%ebx
801018fc:	e8 af fb ff ff       	call   801014b0 <bfree>
      ip->addrs[i] = 0;
80101901:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
{
  int i, j;
  struct buf *bp, *bip;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101908:	39 f3                	cmp    %esi,%ebx
8010190a:	75 e4                	jne    801018f0 <iput+0x60>
    }
  }

  /*
  */
  if(ip->addrs[NDIRECT]){
8010190c:	8b 87 88 00 00 00    	mov    0x88(%edi),%eax
80101912:	85 c0                	test   %eax,%eax
80101914:	75 42                	jne    80101958 <iput+0xc8>
    }
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }
  if(ip->addrs[NDIRECT+1]){
80101916:	8b 87 8c 00 00 00    	mov    0x8c(%edi),%eax
8010191c:	85 c0                	test   %eax,%eax
8010191e:	75 79                	jne    80101999 <iput+0x109>
      bfree(ip->dev, ip->addrs[NDIRECT+1]);
    ip->addrs[NDIRECT+1] = 0;
  }


  ip->size = 0;
80101920:	c7 47 58 00 00 00 00 	movl   $0x0,0x58(%edi)
  iupdate(ip);
80101927:	89 3c 24             	mov    %edi,(%esp)
8010192a:	e8 91 fd ff ff       	call   801016c0 <iupdate>
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
8010192f:	31 c0                	xor    %eax,%eax
80101931:	66 89 47 50          	mov    %ax,0x50(%edi)
    iupdate(ip);
80101935:	89 3c 24             	mov    %edi,(%esp)
80101938:	e8 83 fd ff ff       	call   801016c0 <iupdate>
    acquire(&icache.lock);
8010193d:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
80101944:	e8 47 3b 00 00       	call   80105490 <acquire>
80101949:	8b 47 08             	mov    0x8(%edi),%eax
    ip->flags = 0;
8010194c:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
80101953:	e9 58 ff ff ff       	jmp    801018b0 <iput+0x20>
  }

  /*
  */
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101958:	89 44 24 04          	mov    %eax,0x4(%esp)
8010195c:	8b 07                	mov    (%edi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
8010195e:	31 db                	xor    %ebx,%ebx
  }

  /*
  */
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101960:	89 04 24             	mov    %eax,(%esp)
80101963:	e8 68 e7 ff ff       	call   801000d0 <bread>
80101968:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
8010196b:	8d 70 5c             	lea    0x5c(%eax),%esi
    for(j = 0; j < NINDIRECT; j++){
8010196e:	31 c0                	xor    %eax,%eax
80101970:	eb 17                	jmp    80101989 <iput+0xf9>
80101972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101978:	83 c3 01             	add    $0x1,%ebx
8010197b:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80101981:	89 d8                	mov    %ebx,%eax
80101983:	0f 84 bb 00 00 00    	je     80101a44 <iput+0x1b4>
      if(a[j])
80101989:	8b 14 86             	mov    (%esi,%eax,4),%edx
8010198c:	85 d2                	test   %edx,%edx
8010198e:	74 e8                	je     80101978 <iput+0xe8>
        bfree(ip->dev, a[j]);
80101990:	8b 07                	mov    (%edi),%eax
80101992:	e8 19 fb ff ff       	call   801014b0 <bfree>
80101997:	eb df                	jmp    80101978 <iput+0xe8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }
  if(ip->addrs[NDIRECT+1]){
      bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
80101999:	89 44 24 04          	mov    %eax,0x4(%esp)
8010199d:	8b 07                	mov    (%edi),%eax
8010199f:	89 04 24             	mov    %eax,(%esp)
801019a2:	e8 29 e7 ff ff       	call   801000d0 <bread>
      a = (uint*)bp->data;

      for(j = 0; j < NINDIRECT; j++){
801019a7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }
  if(ip->addrs[NDIRECT+1]){
      bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
801019ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      a = (uint*)bp->data;
801019b1:	83 c0 5c             	add    $0x5c,%eax
801019b4:	89 45 dc             	mov    %eax,-0x24(%ebp)

      for(j = 0; j < NINDIRECT; j++){
801019b7:	31 c0                	xor    %eax,%eax
801019b9:	eb 17                	jmp    801019d2 <iput+0x142>
801019bb:	90                   	nop
801019bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019c0:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801019c4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019c7:	89 c8                	mov    %ecx,%eax
801019c9:	83 c1 80             	add    $0xffffff80,%ecx
801019cc:	0f 84 99 00 00 00    	je     80101a6b <iput+0x1db>
          if(a[j]){
801019d2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
801019d5:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801019d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019db:	8b 00                	mov    (%eax),%eax
801019dd:	85 c0                	test   %eax,%eax
801019df:	74 df                	je     801019c0 <iput+0x130>
                  bip = bread(ip->dev, a[j]);
801019e1:	89 44 24 04          	mov    %eax,0x4(%esp)
801019e5:	8b 07                	mov    (%edi),%eax
                  a = (uint*)bip->data;
              for(i = 0; i < NINDIRECT; i++){
801019e7:	31 db                	xor    %ebx,%ebx
      bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
      a = (uint*)bp->data;

      for(j = 0; j < NINDIRECT; j++){
          if(a[j]){
                  bip = bread(ip->dev, a[j]);
801019e9:	89 04 24             	mov    %eax,(%esp)
801019ec:	e8 df e6 ff ff       	call   801000d0 <bread>
801019f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
                  a = (uint*)bip->data;
801019f4:	8d 70 5c             	lea    0x5c(%eax),%esi
              for(i = 0; i < NINDIRECT; i++){
801019f7:	31 c0                	xor    %eax,%eax
801019f9:	eb 12                	jmp    80101a0d <iput+0x17d>
801019fb:	90                   	nop
801019fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a00:	83 c3 01             	add    $0x1,%ebx
80101a03:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80101a09:	89 d8                	mov    %ebx,%eax
80101a0b:	74 1b                	je     80101a28 <iput+0x198>
                  if(a[i])
80101a0d:	8b 14 86             	mov    (%esi,%eax,4),%edx
80101a10:	85 d2                	test   %edx,%edx
80101a12:	74 ec                	je     80101a00 <iput+0x170>
                      bfree(ip->dev, a[i]);
80101a14:	8b 07                	mov    (%edi),%eax

      for(j = 0; j < NINDIRECT; j++){
          if(a[j]){
                  bip = bread(ip->dev, a[j]);
                  a = (uint*)bip->data;
              for(i = 0; i < NINDIRECT; i++){
80101a16:	83 c3 01             	add    $0x1,%ebx
                  if(a[i])
                      bfree(ip->dev, a[i]);
80101a19:	e8 92 fa ff ff       	call   801014b0 <bfree>

      for(j = 0; j < NINDIRECT; j++){
          if(a[j]){
                  bip = bread(ip->dev, a[j]);
                  a = (uint*)bip->data;
              for(i = 0; i < NINDIRECT; i++){
80101a1e:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80101a24:	89 d8                	mov    %ebx,%eax
80101a26:	75 e5                	jne    80101a0d <iput+0x17d>
                  if(a[i])
                      bfree(ip->dev, a[i]);
              }
             brelse(bip);
80101a28:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a2b:	89 04 24             	mov    %eax,(%esp)
80101a2e:	e8 ad e7 ff ff       	call   801001e0 <brelse>
              a = (uint*)bp->data;

              bfree(ip->dev, a[j]);
80101a33:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a36:	8b 10                	mov    (%eax),%edx
80101a38:	8b 07                	mov    (%edi),%eax
80101a3a:	e8 71 fa ff ff       	call   801014b0 <bfree>
80101a3f:	e9 7c ff ff ff       	jmp    801019c0 <iput+0x130>
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101a44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101a47:	89 04 24             	mov    %eax,(%esp)
80101a4a:	e8 91 e7 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a4f:	8b 97 88 00 00 00    	mov    0x88(%edi),%edx
80101a55:	8b 07                	mov    (%edi),%eax
80101a57:	e8 54 fa ff ff       	call   801014b0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a5c:	c7 87 88 00 00 00 00 	movl   $0x0,0x88(%edi)
80101a63:	00 00 00 
80101a66:	e9 ab fe ff ff       	jmp    80101916 <iput+0x86>
              a = (uint*)bp->data;

              bfree(ip->dev, a[j]);
          }
      }
      brelse(bp);
80101a6b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101a6e:	89 04 24             	mov    %eax,(%esp)
80101a71:	e8 6a e7 ff ff       	call   801001e0 <brelse>
      bfree(ip->dev, ip->addrs[NDIRECT+1]);
80101a76:	8b 97 8c 00 00 00    	mov    0x8c(%edi),%edx
80101a7c:	8b 07                	mov    (%edi),%eax
80101a7e:	e8 2d fa ff ff       	call   801014b0 <bfree>
    ip->addrs[NDIRECT+1] = 0;
80101a83:	c7 87 8c 00 00 00 00 	movl   $0x0,0x8c(%edi)
80101a8a:	00 00 00 
80101a8d:	e9 8e fe ff ff       	jmp    80101920 <iput+0x90>
80101a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101aa0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	53                   	push   %ebx
80101aa4:	83 ec 14             	sub    $0x14,%esp
80101aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101aaa:	89 1c 24             	mov    %ebx,(%esp)
80101aad:	e8 9e fd ff ff       	call   80101850 <iunlock>
  iput(ip);
80101ab2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101ab5:	83 c4 14             	add    $0x14,%esp
80101ab8:	5b                   	pop    %ebx
80101ab9:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
80101aba:	e9 d1 fd ff ff       	jmp    80101890 <iput>
80101abf:	90                   	nop

80101ac0 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101ac0:	55                   	push   %ebp
80101ac1:	89 e5                	mov    %esp,%ebp
80101ac3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ac9:	8b 0a                	mov    (%edx),%ecx
80101acb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101ace:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ad1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ad4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ad8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101adb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101adf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101ae3:	8b 52 58             	mov    0x58(%edx),%edx
80101ae6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ae9:	5d                   	pop    %ebp
80101aea:	c3                   	ret    
80101aeb:	90                   	nop
80101aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101af0 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101af0:	55                   	push   %ebp
80101af1:	89 e5                	mov    %esp,%ebp
80101af3:	57                   	push   %edi
80101af4:	56                   	push   %esi
80101af5:	53                   	push   %ebx
80101af6:	83 ec 2c             	sub    $0x2c,%esp
80101af9:	8b 45 0c             	mov    0xc(%ebp),%eax
80101afc:	8b 7d 08             	mov    0x8(%ebp),%edi
80101aff:	8b 75 10             	mov    0x10(%ebp),%esi
80101b02:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101b05:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b08:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b10:	0f 84 aa 00 00 00    	je     80101bc0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b16:	8b 47 58             	mov    0x58(%edi),%eax
80101b19:	39 f0                	cmp    %esi,%eax
80101b1b:	0f 82 c7 00 00 00    	jb     80101be8 <readi+0xf8>
80101b21:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b24:	89 da                	mov    %ebx,%edx
80101b26:	01 f2                	add    %esi,%edx
80101b28:	0f 82 ba 00 00 00    	jb     80101be8 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b2e:	89 c1                	mov    %eax,%ecx
80101b30:	29 f1                	sub    %esi,%ecx
80101b32:	39 d0                	cmp    %edx,%eax
80101b34:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b37:	31 c0                	xor    %eax,%eax
80101b39:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b3b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b3e:	74 70                	je     80101bb0 <readi+0xc0>
80101b40:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101b43:	89 c7                	mov    %eax,%edi
80101b45:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b48:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b4b:	89 f2                	mov    %esi,%edx
80101b4d:	c1 ea 09             	shr    $0x9,%edx
80101b50:	89 d8                	mov    %ebx,%eax
80101b52:	e8 99 f7 ff ff       	call   801012f0 <bmap>
80101b57:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b5b:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b5d:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b62:	89 04 24             	mov    %eax,(%esp)
80101b65:	e8 66 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b6a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101b6d:	29 f9                	sub    %edi,%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b6f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b71:	89 f0                	mov    %esi,%eax
80101b73:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b78:	29 c3                	sub    %eax,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101b7a:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b7e:	39 cb                	cmp    %ecx,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101b80:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b87:	0f 47 d9             	cmova  %ecx,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101b8a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b8e:	01 df                	add    %ebx,%edi
80101b90:	01 de                	add    %ebx,%esi
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101b92:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101b95:	89 04 24             	mov    %eax,(%esp)
80101b98:	e8 23 3b 00 00       	call   801056c0 <memmove>
    brelse(bp);
80101b9d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101ba0:	89 14 24             	mov    %edx,(%esp)
80101ba3:	e8 38 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ba8:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bab:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101bae:	77 98                	ja     80101b48 <readi+0x58>
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101bb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101bb3:	83 c4 2c             	add    $0x2c,%esp
80101bb6:	5b                   	pop    %ebx
80101bb7:	5e                   	pop    %esi
80101bb8:	5f                   	pop    %edi
80101bb9:	5d                   	pop    %ebp
80101bba:	c3                   	ret    
80101bbb:	90                   	nop
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101bc0:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101bc4:	66 83 f8 09          	cmp    $0x9,%ax
80101bc8:	77 1e                	ja     80101be8 <readi+0xf8>
80101bca:	8b 04 c5 e0 2c 11 80 	mov    -0x7feed320(,%eax,8),%eax
80101bd1:	85 c0                	test   %eax,%eax
80101bd3:	74 13                	je     80101be8 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101bd5:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101bd8:	89 75 10             	mov    %esi,0x10(%ebp)
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101bdb:	83 c4 2c             	add    $0x2c,%esp
80101bde:	5b                   	pop    %ebx
80101bdf:	5e                   	pop    %esi
80101be0:	5f                   	pop    %edi
80101be1:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101be2:	ff e0                	jmp    *%eax
80101be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bed:	eb c4                	jmp    80101bb3 <readi+0xc3>
80101bef:	90                   	nop

80101bf0 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	57                   	push   %edi
80101bf4:	56                   	push   %esi
80101bf5:	53                   	push   %ebx
80101bf6:	83 ec 2c             	sub    $0x2c,%esp
80101bf9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101bff:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c02:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c07:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101c0a:	8b 75 10             	mov    0x10(%ebp),%esi
80101c0d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c10:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c13:	0f 84 b7 00 00 00    	je     80101cd0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c1c:	39 70 58             	cmp    %esi,0x58(%eax)
80101c1f:	0f 82 e3 00 00 00    	jb     80101d08 <writei+0x118>
80101c25:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101c28:	89 c8                	mov    %ecx,%eax
80101c2a:	01 f0                	add    %esi,%eax
80101c2c:	0f 82 d6 00 00 00    	jb     80101d08 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c32:	3d 00 16 81 00       	cmp    $0x811600,%eax
80101c37:	0f 87 cb 00 00 00    	ja     80101d08 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c3d:	85 c9                	test   %ecx,%ecx
80101c3f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c46:	74 77                	je     80101cbf <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c48:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c4b:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c4d:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c52:	c1 ea 09             	shr    $0x9,%edx
80101c55:	89 f8                	mov    %edi,%eax
80101c57:	e8 94 f6 ff ff       	call   801012f0 <bmap>
80101c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c60:	8b 07                	mov    (%edi),%eax
80101c62:	89 04 24             	mov    %eax,(%esp)
80101c65:	e8 66 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c6a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101c6d:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c70:	8b 55 dc             	mov    -0x24(%ebp),%edx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c73:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c75:	89 f0                	mov    %esi,%eax
80101c77:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c7c:	29 c3                	sub    %eax,%ebx
80101c7e:	39 cb                	cmp    %ecx,%ebx
80101c80:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c83:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c87:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101c89:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c8d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101c91:	89 04 24             	mov    %eax,(%esp)
80101c94:	e8 27 3a 00 00       	call   801056c0 <memmove>
    log_write(bp);
80101c99:	89 3c 24             	mov    %edi,(%esp)
80101c9c:	e8 2f 12 00 00       	call   80102ed0 <log_write>
    brelse(bp);
80101ca1:	89 3c 24             	mov    %edi,(%esp)
80101ca4:	e8 37 e5 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ca9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101cac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101caf:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cb2:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101cb5:	77 91                	ja     80101c48 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101cb7:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cba:	39 70 58             	cmp    %esi,0x58(%eax)
80101cbd:	72 39                	jb     80101cf8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101cbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101cc2:	83 c4 2c             	add    $0x2c,%esp
80101cc5:	5b                   	pop    %ebx
80101cc6:	5e                   	pop    %esi
80101cc7:	5f                   	pop    %edi
80101cc8:	5d                   	pop    %ebp
80101cc9:	c3                   	ret    
80101cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cd0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cd4:	66 83 f8 09          	cmp    $0x9,%ax
80101cd8:	77 2e                	ja     80101d08 <writei+0x118>
80101cda:	8b 04 c5 e4 2c 11 80 	mov    -0x7feed31c(,%eax,8),%eax
80101ce1:	85 c0                	test   %eax,%eax
80101ce3:	74 23                	je     80101d08 <writei+0x118>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101ce5:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101ce8:	83 c4 2c             	add    $0x2c,%esp
80101ceb:	5b                   	pop    %ebx
80101cec:	5e                   	pop    %esi
80101ced:	5f                   	pop    %edi
80101cee:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101cef:	ff e0                	jmp    *%eax
80101cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101cf8:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cfb:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101cfe:	89 04 24             	mov    %eax,(%esp)
80101d01:	e8 ba f9 ff ff       	call   801016c0 <iupdate>
80101d06:	eb b7                	jmp    80101cbf <writei+0xcf>
  }
  return n;
}
80101d08:	83 c4 2c             	add    $0x2c,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101d0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101d10:	5b                   	pop    %ebx
80101d11:	5e                   	pop    %esi
80101d12:	5f                   	pop    %edi
80101d13:	5d                   	pop    %ebp
80101d14:	c3                   	ret    
80101d15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d20 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d20:	55                   	push   %ebp
80101d21:	89 e5                	mov    %esp,%ebp
80101d23:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101d26:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d29:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d30:	00 
80101d31:	89 44 24 04          	mov    %eax,0x4(%esp)
80101d35:	8b 45 08             	mov    0x8(%ebp),%eax
80101d38:	89 04 24             	mov    %eax,(%esp)
80101d3b:	e8 00 3a 00 00       	call   80105740 <strncmp>
}
80101d40:	c9                   	leave  
80101d41:	c3                   	ret    
80101d42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d50 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d50:	55                   	push   %ebp
80101d51:	89 e5                	mov    %esp,%ebp
80101d53:	57                   	push   %edi
80101d54:	56                   	push   %esi
80101d55:	53                   	push   %ebx
80101d56:	83 ec 2c             	sub    $0x2c,%esp
80101d59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d5c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d61:	0f 85 97 00 00 00    	jne    80101dfe <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d67:	8b 53 58             	mov    0x58(%ebx),%edx
80101d6a:	31 ff                	xor    %edi,%edi
80101d6c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d6f:	85 d2                	test   %edx,%edx
80101d71:	75 0d                	jne    80101d80 <dirlookup+0x30>
80101d73:	eb 73                	jmp    80101de8 <dirlookup+0x98>
80101d75:	8d 76 00             	lea    0x0(%esi),%esi
80101d78:	83 c7 10             	add    $0x10,%edi
80101d7b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101d7e:	76 68                	jbe    80101de8 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d80:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101d87:	00 
80101d88:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101d8c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101d90:	89 1c 24             	mov    %ebx,(%esp)
80101d93:	e8 58 fd ff ff       	call   80101af0 <readi>
80101d98:	83 f8 10             	cmp    $0x10,%eax
80101d9b:	75 55                	jne    80101df2 <dirlookup+0xa2>
      panic("dirlink read");
    if(de.inum == 0)
80101d9d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101da2:	74 d4                	je     80101d78 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101da4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101da7:	89 44 24 04          	mov    %eax,0x4(%esp)
80101dab:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dae:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101db5:	00 
80101db6:	89 04 24             	mov    %eax,(%esp)
80101db9:	e8 82 39 00 00       	call   80105740 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101dbe:	85 c0                	test   %eax,%eax
80101dc0:	75 b6                	jne    80101d78 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101dc2:	8b 45 10             	mov    0x10(%ebp),%eax
80101dc5:	85 c0                	test   %eax,%eax
80101dc7:	74 05                	je     80101dce <dirlookup+0x7e>
        *poff = off;
80101dc9:	8b 45 10             	mov    0x10(%ebp),%eax
80101dcc:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101dce:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101dd2:	8b 03                	mov    (%ebx),%eax
80101dd4:	e8 57 f4 ff ff       	call   80101230 <iget>
    }
  }

  return 0;
}
80101dd9:	83 c4 2c             	add    $0x2c,%esp
80101ddc:	5b                   	pop    %ebx
80101ddd:	5e                   	pop    %esi
80101dde:	5f                   	pop    %edi
80101ddf:	5d                   	pop    %ebp
80101de0:	c3                   	ret    
80101de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101de8:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101deb:	31 c0                	xor    %eax,%eax
}
80101ded:	5b                   	pop    %ebx
80101dee:	5e                   	pop    %esi
80101def:	5f                   	pop    %edi
80101df0:	5d                   	pop    %ebp
80101df1:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101df2:	c7 04 24 35 91 10 80 	movl   $0x80109135,(%esp)
80101df9:	e8 62 e5 ff ff       	call   80100360 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101dfe:	c7 04 24 23 91 10 80 	movl   $0x80109123,(%esp)
80101e05:	e8 56 e5 ff ff       	call   80100360 <panic>
80101e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101e10 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	57                   	push   %edi
80101e14:	89 cf                	mov    %ecx,%edi
80101e16:	56                   	push   %esi
80101e17:	53                   	push   %ebx
80101e18:	89 c3                	mov    %eax,%ebx
80101e1a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e1d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e20:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101e23:	0f 84 51 01 00 00    	je     80101f7a <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101e29:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101e2f:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101e32:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
80101e39:	e8 52 36 00 00       	call   80105490 <acquire>
  ip->ref++;
80101e3e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e42:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
80101e49:	e8 82 37 00 00       	call   801055d0 <release>
80101e4e:	eb 03                	jmp    80101e53 <namex+0x43>
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101e50:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101e53:	0f b6 03             	movzbl (%ebx),%eax
80101e56:	3c 2f                	cmp    $0x2f,%al
80101e58:	74 f6                	je     80101e50 <namex+0x40>
    path++;
  if(*path == 0)
80101e5a:	84 c0                	test   %al,%al
80101e5c:	0f 84 ed 00 00 00    	je     80101f4f <namex+0x13f>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101e62:	0f b6 03             	movzbl (%ebx),%eax
80101e65:	89 da                	mov    %ebx,%edx
80101e67:	84 c0                	test   %al,%al
80101e69:	0f 84 b1 00 00 00    	je     80101f20 <namex+0x110>
80101e6f:	3c 2f                	cmp    $0x2f,%al
80101e71:	75 0f                	jne    80101e82 <namex+0x72>
80101e73:	e9 a8 00 00 00       	jmp    80101f20 <namex+0x110>
80101e78:	3c 2f                	cmp    $0x2f,%al
80101e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101e80:	74 0a                	je     80101e8c <namex+0x7c>
    path++;
80101e82:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101e85:	0f b6 02             	movzbl (%edx),%eax
80101e88:	84 c0                	test   %al,%al
80101e8a:	75 ec                	jne    80101e78 <namex+0x68>
80101e8c:	89 d1                	mov    %edx,%ecx
80101e8e:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101e90:	83 f9 0d             	cmp    $0xd,%ecx
80101e93:	0f 8e 8f 00 00 00    	jle    80101f28 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101e99:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101e9d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ea4:	00 
80101ea5:	89 3c 24             	mov    %edi,(%esp)
80101ea8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101eab:	e8 10 38 00 00       	call   801056c0 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101eb0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101eb3:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101eb5:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101eb8:	75 0e                	jne    80101ec8 <namex+0xb8>
80101eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101ec0:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101ec3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101ec6:	74 f8                	je     80101ec0 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ec8:	89 34 24             	mov    %esi,(%esp)
80101ecb:	e8 b0 f8 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101ed0:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ed5:	0f 85 85 00 00 00    	jne    80101f60 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101edb:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ede:	85 d2                	test   %edx,%edx
80101ee0:	74 09                	je     80101eeb <namex+0xdb>
80101ee2:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ee5:	0f 84 a5 00 00 00    	je     80101f90 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101eeb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101ef2:	00 
80101ef3:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101ef7:	89 34 24             	mov    %esi,(%esp)
80101efa:	e8 51 fe ff ff       	call   80101d50 <dirlookup>
80101eff:	85 c0                	test   %eax,%eax
80101f01:	74 5d                	je     80101f60 <namex+0x150>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101f03:	89 34 24             	mov    %esi,(%esp)
80101f06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101f09:	e8 42 f9 ff ff       	call   80101850 <iunlock>
  iput(ip);
80101f0e:	89 34 24             	mov    %esi,(%esp)
80101f11:	e8 7a f9 ff ff       	call   80101890 <iput>
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101f16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f19:	89 c6                	mov    %eax,%esi
80101f1b:	e9 33 ff ff ff       	jmp    80101e53 <namex+0x43>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101f20:	31 c9                	xor    %ecx,%ecx
80101f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101f28:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101f2c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101f30:	89 3c 24             	mov    %edi,(%esp)
80101f33:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101f36:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101f39:	e8 82 37 00 00       	call   801056c0 <memmove>
    name[len] = 0;
80101f3e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f41:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101f44:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101f48:	89 d3                	mov    %edx,%ebx
80101f4a:	e9 66 ff ff ff       	jmp    80101eb5 <namex+0xa5>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101f52:	85 c0                	test   %eax,%eax
80101f54:	75 4c                	jne    80101fa2 <namex+0x192>
80101f56:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101f58:	83 c4 2c             	add    $0x2c,%esp
80101f5b:	5b                   	pop    %ebx
80101f5c:	5e                   	pop    %esi
80101f5d:	5f                   	pop    %edi
80101f5e:	5d                   	pop    %ebp
80101f5f:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101f60:	89 34 24             	mov    %esi,(%esp)
80101f63:	e8 e8 f8 ff ff       	call   80101850 <iunlock>
  iput(ip);
80101f68:	89 34 24             	mov    %esi,(%esp)
80101f6b:	e8 20 f9 ff ff       	call   80101890 <iput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101f70:	83 c4 2c             	add    $0x2c,%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101f73:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101f75:	5b                   	pop    %ebx
80101f76:	5e                   	pop    %esi
80101f77:	5f                   	pop    %edi
80101f78:	5d                   	pop    %ebp
80101f79:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101f7a:	ba 01 00 00 00       	mov    $0x1,%edx
80101f7f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f84:	e8 a7 f2 ff ff       	call   80101230 <iget>
80101f89:	89 c6                	mov    %eax,%esi
80101f8b:	e9 c3 fe ff ff       	jmp    80101e53 <namex+0x43>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101f90:	89 34 24             	mov    %esi,(%esp)
80101f93:	e8 b8 f8 ff ff       	call   80101850 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101f98:	83 c4 2c             	add    $0x2c,%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101f9b:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101f9d:	5b                   	pop    %ebx
80101f9e:	5e                   	pop    %esi
80101f9f:	5f                   	pop    %edi
80101fa0:	5d                   	pop    %ebp
80101fa1:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101fa2:	89 34 24             	mov    %esi,(%esp)
80101fa5:	e8 e6 f8 ff ff       	call   80101890 <iput>
    return 0;
80101faa:	31 c0                	xor    %eax,%eax
80101fac:	eb aa                	jmp    80101f58 <namex+0x148>
80101fae:	66 90                	xchg   %ax,%ax

80101fb0 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101fb0:	55                   	push   %ebp
80101fb1:	89 e5                	mov    %esp,%ebp
80101fb3:	57                   	push   %edi
80101fb4:	56                   	push   %esi
80101fb5:	53                   	push   %ebx
80101fb6:	83 ec 2c             	sub    $0x2c,%esp
80101fb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fbf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101fc6:	00 
80101fc7:	89 1c 24             	mov    %ebx,(%esp)
80101fca:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fce:	e8 7d fd ff ff       	call   80101d50 <dirlookup>
80101fd3:	85 c0                	test   %eax,%eax
80101fd5:	0f 85 8b 00 00 00    	jne    80102066 <dirlink+0xb6>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fdb:	8b 43 58             	mov    0x58(%ebx),%eax
80101fde:	31 ff                	xor    %edi,%edi
80101fe0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fe3:	85 c0                	test   %eax,%eax
80101fe5:	75 13                	jne    80101ffa <dirlink+0x4a>
80101fe7:	eb 35                	jmp    8010201e <dirlink+0x6e>
80101fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ff0:	8d 57 10             	lea    0x10(%edi),%edx
80101ff3:	39 53 58             	cmp    %edx,0x58(%ebx)
80101ff6:	89 d7                	mov    %edx,%edi
80101ff8:	76 24                	jbe    8010201e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ffa:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102001:	00 
80102002:	89 7c 24 08          	mov    %edi,0x8(%esp)
80102006:	89 74 24 04          	mov    %esi,0x4(%esp)
8010200a:	89 1c 24             	mov    %ebx,(%esp)
8010200d:	e8 de fa ff ff       	call   80101af0 <readi>
80102012:	83 f8 10             	cmp    $0x10,%eax
80102015:	75 5e                	jne    80102075 <dirlink+0xc5>
      panic("dirlink read");
    if(de.inum == 0)
80102017:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010201c:	75 d2                	jne    80101ff0 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
8010201e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102021:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102028:	00 
80102029:	89 44 24 04          	mov    %eax,0x4(%esp)
8010202d:	8d 45 da             	lea    -0x26(%ebp),%eax
80102030:	89 04 24             	mov    %eax,(%esp)
80102033:	e8 78 37 00 00       	call   801057b0 <strncpy>
  de.inum = inum;
80102038:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010203b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102042:	00 
80102043:	89 7c 24 08          	mov    %edi,0x8(%esp)
80102047:	89 74 24 04          	mov    %esi,0x4(%esp)
8010204b:	89 1c 24             	mov    %ebx,(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
8010204e:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102052:	e8 99 fb ff ff       	call   80101bf0 <writei>
80102057:	83 f8 10             	cmp    $0x10,%eax
8010205a:	75 25                	jne    80102081 <dirlink+0xd1>
    panic("dirlink");

  return 0;
8010205c:	31 c0                	xor    %eax,%eax
}
8010205e:	83 c4 2c             	add    $0x2c,%esp
80102061:	5b                   	pop    %ebx
80102062:	5e                   	pop    %esi
80102063:	5f                   	pop    %edi
80102064:	5d                   	pop    %ebp
80102065:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80102066:	89 04 24             	mov    %eax,(%esp)
80102069:	e8 22 f8 ff ff       	call   80101890 <iput>
    return -1;
8010206e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102073:	eb e9                	jmp    8010205e <dirlink+0xae>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80102075:	c7 04 24 35 91 10 80 	movl   $0x80109135,(%esp)
8010207c:	e8 df e2 ff ff       	call   80100360 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80102081:	c7 04 24 7e 98 10 80 	movl   $0x8010987e,(%esp)
80102088:	e8 d3 e2 ff ff       	call   80100360 <panic>
8010208d:	8d 76 00             	lea    0x0(%esi),%esi

80102090 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80102090:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102091:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80102093:	89 e5                	mov    %esp,%ebp
80102095:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102098:	8b 45 08             	mov    0x8(%ebp),%eax
8010209b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010209e:	e8 6d fd ff ff       	call   80101e10 <namex>
}
801020a3:	c9                   	leave  
801020a4:	c3                   	ret    
801020a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020b0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020b0:	55                   	push   %ebp
  return namex(path, 1, name);
801020b1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
801020b6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020be:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
801020bf:	e9 4c fd ff ff       	jmp    80101e10 <namex>
801020c4:	66 90                	xchg   %ax,%ax
801020c6:	66 90                	xchg   %ax,%ax
801020c8:	66 90                	xchg   %ax,%ax
801020ca:	66 90                	xchg   %ax,%ax
801020cc:	66 90                	xchg   %ax,%ax
801020ce:	66 90                	xchg   %ax,%ax

801020d0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020d0:	55                   	push   %ebp
801020d1:	89 e5                	mov    %esp,%ebp
801020d3:	56                   	push   %esi
801020d4:	89 c6                	mov    %eax,%esi
801020d6:	53                   	push   %ebx
801020d7:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
801020da:	85 c0                	test   %eax,%eax
801020dc:	0f 84 99 00 00 00    	je     8010217b <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020e2:	8b 48 08             	mov    0x8(%eax),%ecx
801020e5:	81 f9 cf 07 00 00    	cmp    $0x7cf,%ecx
801020eb:	0f 87 7e 00 00 00    	ja     8010216f <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020f1:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020f6:	66 90                	xchg   %ax,%ax
801020f8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f9:	83 e0 c0             	and    $0xffffffc0,%eax
801020fc:	3c 40                	cmp    $0x40,%al
801020fe:	75 f8                	jne    801020f8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102100:	31 db                	xor    %ebx,%ebx
80102102:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102107:	89 d8                	mov    %ebx,%eax
80102109:	ee                   	out    %al,(%dx)
8010210a:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010210f:	b8 01 00 00 00       	mov    $0x1,%eax
80102114:	ee                   	out    %al,(%dx)
80102115:	0f b6 c1             	movzbl %cl,%eax
80102118:	b2 f3                	mov    $0xf3,%dl
8010211a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
8010211b:	89 c8                	mov    %ecx,%eax
8010211d:	b2 f4                	mov    $0xf4,%dl
8010211f:	c1 f8 08             	sar    $0x8,%eax
80102122:	ee                   	out    %al,(%dx)
80102123:	b2 f5                	mov    $0xf5,%dl
80102125:	89 d8                	mov    %ebx,%eax
80102127:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102128:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010212c:	b2 f6                	mov    $0xf6,%dl
8010212e:	83 e0 01             	and    $0x1,%eax
80102131:	c1 e0 04             	shl    $0x4,%eax
80102134:	83 c8 e0             	or     $0xffffffe0,%eax
80102137:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102138:	f6 06 04             	testb  $0x4,(%esi)
8010213b:	75 13                	jne    80102150 <idestart+0x80>
8010213d:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102142:	b8 20 00 00 00       	mov    $0x20,%eax
80102147:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102148:	83 c4 10             	add    $0x10,%esp
8010214b:	5b                   	pop    %ebx
8010214c:	5e                   	pop    %esi
8010214d:	5d                   	pop    %ebp
8010214e:	c3                   	ret    
8010214f:	90                   	nop
80102150:	b2 f7                	mov    $0xf7,%dl
80102152:	b8 30 00 00 00       	mov    $0x30,%eax
80102157:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102158:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
8010215d:	83 c6 5c             	add    $0x5c,%esi
80102160:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102165:	fc                   	cld    
80102166:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102168:	83 c4 10             	add    $0x10,%esp
8010216b:	5b                   	pop    %ebx
8010216c:	5e                   	pop    %esi
8010216d:	5d                   	pop    %ebp
8010216e:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010216f:	c7 04 24 a0 91 10 80 	movl   $0x801091a0,(%esp)
80102176:	e8 e5 e1 ff ff       	call   80100360 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010217b:	c7 04 24 97 91 10 80 	movl   $0x80109197,(%esp)
80102182:	e8 d9 e1 ff ff       	call   80100360 <panic>
80102187:	89 f6                	mov    %esi,%esi
80102189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102190 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102190:	55                   	push   %ebp
80102191:	89 e5                	mov    %esp,%ebp
80102193:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102196:	c7 44 24 04 b2 91 10 	movl   $0x801091b2,0x4(%esp)
8010219d:	80 
8010219e:	c7 04 24 80 c5 10 80 	movl   $0x8010c580,(%esp)
801021a5:	e8 66 32 00 00       	call   80105410 <initlock>
  picenable(IRQ_IDE);
801021aa:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801021b1:	e8 ea 11 00 00       	call   801033a0 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021b6:	a1 e0 50 11 80       	mov    0x801150e0,%eax
801021bb:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801021c2:	83 e8 01             	sub    $0x1,%eax
801021c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801021c9:	e8 82 02 00 00       	call   80102450 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ce:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021d3:	90                   	nop
801021d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021d8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021d9:	83 e0 c0             	and    $0xffffffc0,%eax
801021dc:	3c 40                	cmp    $0x40,%al
801021de:	75 f8                	jne    801021d8 <ideinit+0x48>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021e0:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021e5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021ea:	ee                   	out    %al,(%dx)
801021eb:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021f0:	b2 f7                	mov    $0xf7,%dl
801021f2:	eb 09                	jmp    801021fd <ideinit+0x6d>
801021f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801021f8:	83 e9 01             	sub    $0x1,%ecx
801021fb:	74 0f                	je     8010220c <ideinit+0x7c>
801021fd:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021fe:	84 c0                	test   %al,%al
80102200:	74 f6                	je     801021f8 <ideinit+0x68>
      havedisk1 = 1;
80102202:	c7 05 60 c5 10 80 01 	movl   $0x1,0x8010c560
80102209:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010220c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102211:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102216:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
80102217:	c9                   	leave  
80102218:	c3                   	ret    
80102219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102220 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102220:	55                   	push   %ebp
80102221:	89 e5                	mov    %esp,%ebp
80102223:	57                   	push   %edi
80102224:	56                   	push   %esi
80102225:	53                   	push   %ebx
80102226:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102229:	c7 04 24 80 c5 10 80 	movl   $0x8010c580,(%esp)
80102230:	e8 5b 32 00 00       	call   80105490 <acquire>
  if((b = idequeue) == 0){
80102235:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
8010223b:	85 db                	test   %ebx,%ebx
8010223d:	74 30                	je     8010226f <ideintr+0x4f>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
8010223f:	8b 43 58             	mov    0x58(%ebx),%eax
80102242:	a3 64 c5 10 80       	mov    %eax,0x8010c564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102247:	8b 33                	mov    (%ebx),%esi
80102249:	f7 c6 04 00 00 00    	test   $0x4,%esi
8010224f:	74 37                	je     80102288 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102251:	83 e6 fb             	and    $0xfffffffb,%esi
80102254:	83 ce 02             	or     $0x2,%esi
80102257:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102259:	89 1c 24             	mov    %ebx,(%esp)
8010225c:	e8 8f 1b 00 00       	call   80103df0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102261:	a1 64 c5 10 80       	mov    0x8010c564,%eax
80102266:	85 c0                	test   %eax,%eax
80102268:	74 05                	je     8010226f <ideintr+0x4f>
    idestart(idequeue);
8010226a:	e8 61 fe ff ff       	call   801020d0 <idestart>
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
  if((b = idequeue) == 0){
    release(&idelock);
8010226f:	c7 04 24 80 c5 10 80 	movl   $0x8010c580,(%esp)
80102276:	e8 55 33 00 00       	call   801055d0 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
8010227b:	83 c4 1c             	add    $0x1c,%esp
8010227e:	5b                   	pop    %ebx
8010227f:	5e                   	pop    %esi
80102280:	5f                   	pop    %edi
80102281:	5d                   	pop    %ebp
80102282:	c3                   	ret    
80102283:	90                   	nop
80102284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102288:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010228d:	8d 76 00             	lea    0x0(%esi),%esi
80102290:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102291:	89 c1                	mov    %eax,%ecx
80102293:	83 e1 c0             	and    $0xffffffc0,%ecx
80102296:	80 f9 40             	cmp    $0x40,%cl
80102299:	75 f5                	jne    80102290 <ideintr+0x70>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010229b:	a8 21                	test   $0x21,%al
8010229d:	75 b2                	jne    80102251 <ideintr+0x31>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
8010229f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801022a2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022a7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022ac:	fc                   	cld    
801022ad:	f3 6d                	rep insl (%dx),%es:(%edi)
801022af:	8b 33                	mov    (%ebx),%esi
801022b1:	eb 9e                	jmp    80102251 <ideintr+0x31>
801022b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022c0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	53                   	push   %ebx
801022c4:	83 ec 14             	sub    $0x14,%esp
801022c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ca:	8d 43 0c             	lea    0xc(%ebx),%eax
801022cd:	89 04 24             	mov    %eax,(%esp)
801022d0:	e8 0b 31 00 00       	call   801053e0 <holdingsleep>
801022d5:	85 c0                	test   %eax,%eax
801022d7:	0f 84 9e 00 00 00    	je     8010237b <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022dd:	8b 03                	mov    (%ebx),%eax
801022df:	83 e0 06             	and    $0x6,%eax
801022e2:	83 f8 02             	cmp    $0x2,%eax
801022e5:	0f 84 a8 00 00 00    	je     80102393 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022eb:	8b 53 04             	mov    0x4(%ebx),%edx
801022ee:	85 d2                	test   %edx,%edx
801022f0:	74 0d                	je     801022ff <iderw+0x3f>
801022f2:	a1 60 c5 10 80       	mov    0x8010c560,%eax
801022f7:	85 c0                	test   %eax,%eax
801022f9:	0f 84 88 00 00 00    	je     80102387 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022ff:	c7 04 24 80 c5 10 80 	movl   $0x8010c580,(%esp)
80102306:	e8 85 31 00 00       	call   80105490 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010230b:	a1 64 c5 10 80       	mov    0x8010c564,%eax
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102310:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102317:	85 c0                	test   %eax,%eax
80102319:	75 07                	jne    80102322 <iderw+0x62>
8010231b:	eb 4e                	jmp    8010236b <iderw+0xab>
8010231d:	8d 76 00             	lea    0x0(%esi),%esi
80102320:	89 d0                	mov    %edx,%eax
80102322:	8b 50 58             	mov    0x58(%eax),%edx
80102325:	85 d2                	test   %edx,%edx
80102327:	75 f7                	jne    80102320 <iderw+0x60>
80102329:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010232c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010232e:	39 1d 64 c5 10 80    	cmp    %ebx,0x8010c564
80102334:	74 3c                	je     80102372 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102336:	8b 03                	mov    (%ebx),%eax
80102338:	83 e0 06             	and    $0x6,%eax
8010233b:	83 f8 02             	cmp    $0x2,%eax
8010233e:	74 1a                	je     8010235a <iderw+0x9a>
    sleep(b, &idelock);
80102340:	c7 44 24 04 80 c5 10 	movl   $0x8010c580,0x4(%esp)
80102347:	80 
80102348:	89 1c 24             	mov    %ebx,(%esp)
8010234b:	e8 f0 18 00 00       	call   80103c40 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102350:	8b 13                	mov    (%ebx),%edx
80102352:	83 e2 06             	and    $0x6,%edx
80102355:	83 fa 02             	cmp    $0x2,%edx
80102358:	75 e6                	jne    80102340 <iderw+0x80>
    sleep(b, &idelock);
  }

  release(&idelock);
8010235a:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
80102361:	83 c4 14             	add    $0x14,%esp
80102364:	5b                   	pop    %ebx
80102365:	5d                   	pop    %ebp
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }

  release(&idelock);
80102366:	e9 65 32 00 00       	jmp    801055d0 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010236b:	b8 64 c5 10 80       	mov    $0x8010c564,%eax
80102370:	eb ba                	jmp    8010232c <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102372:	89 d8                	mov    %ebx,%eax
80102374:	e8 57 fd ff ff       	call   801020d0 <idestart>
80102379:	eb bb                	jmp    80102336 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010237b:	c7 04 24 b6 91 10 80 	movl   $0x801091b6,(%esp)
80102382:	e8 d9 df ff ff       	call   80100360 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102387:	c7 04 24 e1 91 10 80 	movl   $0x801091e1,(%esp)
8010238e:	e8 cd df ff ff       	call   80100360 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102393:	c7 04 24 cc 91 10 80 	movl   $0x801091cc,(%esp)
8010239a:	e8 c1 df ff ff       	call   80100360 <panic>
8010239f:	90                   	nop

801023a0 <ioapicinit>:
void
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
801023a0:	a1 e4 4a 11 80       	mov    0x80114ae4,%eax
801023a5:	85 c0                	test   %eax,%eax
801023a7:	0f 84 9b 00 00 00    	je     80102448 <ioapicinit+0xa8>
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023ad:	55                   	push   %ebp
801023ae:	89 e5                	mov    %esp,%ebp
801023b0:	56                   	push   %esi
801023b1:	53                   	push   %ebx
801023b2:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023b5:	c7 05 b4 49 11 80 00 	movl   $0xfec00000,0x801149b4
801023bc:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801023bf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023c6:	00 00 00 
  return ioapic->data;
801023c9:	8b 15 b4 49 11 80    	mov    0x801149b4,%edx
801023cf:	8b 42 10             	mov    0x10(%edx),%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801023d2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023d8:	8b 1d b4 49 11 80    	mov    0x801149b4,%ebx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023de:	0f b6 15 e0 4a 11 80 	movzbl 0x80114ae0,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023e5:	c1 e8 10             	shr    $0x10,%eax
801023e8:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
801023eb:	8b 43 10             	mov    0x10(%ebx),%eax
  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
801023ee:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023f1:	39 c2                	cmp    %eax,%edx
801023f3:	74 12                	je     80102407 <ioapicinit+0x67>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023f5:	c7 04 24 00 92 10 80 	movl   $0x80109200,(%esp)
801023fc:	e8 4f e2 ff ff       	call   80100650 <cprintf>
80102401:	8b 1d b4 49 11 80    	mov    0x801149b4,%ebx
80102407:	ba 10 00 00 00       	mov    $0x10,%edx
8010240c:	31 c0                	xor    %eax,%eax
8010240e:	eb 02                	jmp    80102412 <ioapicinit+0x72>
80102410:	89 cb                	mov    %ecx,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102412:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
80102414:	8b 1d b4 49 11 80    	mov    0x801149b4,%ebx
8010241a:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010241d:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102423:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102426:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102429:	8d 4a 01             	lea    0x1(%edx),%ecx
8010242c:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010242f:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102431:	8b 0d b4 49 11 80    	mov    0x801149b4,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102437:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102439:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102440:	7d ce                	jge    80102410 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102442:	83 c4 10             	add    $0x10,%esp
80102445:	5b                   	pop    %ebx
80102446:	5e                   	pop    %esi
80102447:	5d                   	pop    %ebp
80102448:	f3 c3                	repz ret 
8010244a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102450 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
80102450:	8b 15 e4 4a 11 80    	mov    0x80114ae4,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102456:	55                   	push   %ebp
80102457:	89 e5                	mov    %esp,%ebp
80102459:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
8010245c:	85 d2                	test   %edx,%edx
8010245e:	74 29                	je     80102489 <ioapicenable+0x39>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102460:	8d 48 20             	lea    0x20(%eax),%ecx
80102463:	8d 54 00 10          	lea    0x10(%eax,%eax,1),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102467:	a1 b4 49 11 80       	mov    0x801149b4,%eax
8010246c:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
8010246e:	a1 b4 49 11 80       	mov    0x801149b4,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102473:	83 c2 01             	add    $0x1,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102476:	89 48 10             	mov    %ecx,0x10(%eax)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102479:	8b 4d 0c             	mov    0xc(%ebp),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010247c:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
8010247e:	a1 b4 49 11 80       	mov    0x801149b4,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102483:	c1 e1 18             	shl    $0x18,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102486:	89 48 10             	mov    %ecx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102489:	5d                   	pop    %ebp
8010248a:	c3                   	ret    
8010248b:	66 90                	xchg   %ax,%ax
8010248d:	66 90                	xchg   %ax,%ax
8010248f:	90                   	nop

80102490 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	53                   	push   %ebx
80102494:	83 ec 14             	sub    $0x14,%esp
80102497:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010249a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024a0:	75 7c                	jne    8010251e <kfree+0x8e>
801024a2:	81 fb a8 80 11 80    	cmp    $0x801180a8,%ebx
801024a8:	72 74                	jb     8010251e <kfree+0x8e>
801024aa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024b0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024b5:	77 67                	ja     8010251e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024b7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801024be:	00 
801024bf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801024c6:	00 
801024c7:	89 1c 24             	mov    %ebx,(%esp)
801024ca:	e8 51 31 00 00       	call   80105620 <memset>

  if(kmem.use_lock)
801024cf:	8b 15 f4 49 11 80    	mov    0x801149f4,%edx
801024d5:	85 d2                	test   %edx,%edx
801024d7:	75 37                	jne    80102510 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024d9:	a1 f8 49 11 80       	mov    0x801149f8,%eax
801024de:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024e0:	a1 f4 49 11 80       	mov    0x801149f4,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
801024e5:	89 1d f8 49 11 80    	mov    %ebx,0x801149f8
  if(kmem.use_lock)
801024eb:	85 c0                	test   %eax,%eax
801024ed:	75 09                	jne    801024f8 <kfree+0x68>
    release(&kmem.lock);
}
801024ef:	83 c4 14             	add    $0x14,%esp
801024f2:	5b                   	pop    %ebx
801024f3:	5d                   	pop    %ebp
801024f4:	c3                   	ret    
801024f5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801024f8:	c7 45 08 c0 49 11 80 	movl   $0x801149c0,0x8(%ebp)
}
801024ff:	83 c4 14             	add    $0x14,%esp
80102502:	5b                   	pop    %ebx
80102503:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102504:	e9 c7 30 00 00       	jmp    801055d0 <release>
80102509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102510:	c7 04 24 c0 49 11 80 	movl   $0x801149c0,(%esp)
80102517:	e8 74 2f 00 00       	call   80105490 <acquire>
8010251c:	eb bb                	jmp    801024d9 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
8010251e:	c7 04 24 32 92 10 80 	movl   $0x80109232,(%esp)
80102525:	e8 36 de ff ff       	call   80100360 <panic>
8010252a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102530 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102530:	55                   	push   %ebp
80102531:	89 e5                	mov    %esp,%ebp
80102533:	56                   	push   %esi
80102534:	53                   	push   %ebx
80102535:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102538:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
8010253b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010253e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102544:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010254a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102550:	39 de                	cmp    %ebx,%esi
80102552:	73 08                	jae    8010255c <freerange+0x2c>
80102554:	eb 18                	jmp    8010256e <freerange+0x3e>
80102556:	66 90                	xchg   %ax,%ax
80102558:	89 da                	mov    %ebx,%edx
8010255a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010255c:	89 14 24             	mov    %edx,(%esp)
8010255f:	e8 2c ff ff ff       	call   80102490 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102564:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010256a:	39 f0                	cmp    %esi,%eax
8010256c:	76 ea                	jbe    80102558 <freerange+0x28>
    kfree(p);
}
8010256e:	83 c4 10             	add    $0x10,%esp
80102571:	5b                   	pop    %ebx
80102572:	5e                   	pop    %esi
80102573:	5d                   	pop    %ebp
80102574:	c3                   	ret    
80102575:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102580 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	56                   	push   %esi
80102584:	53                   	push   %ebx
80102585:	83 ec 10             	sub    $0x10,%esp
80102588:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010258b:	c7 44 24 04 38 92 10 	movl   $0x80109238,0x4(%esp)
80102592:	80 
80102593:	c7 04 24 c0 49 11 80 	movl   $0x801149c0,(%esp)
8010259a:	e8 71 2e 00 00       	call   80105410 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010259f:	8b 45 08             	mov    0x8(%ebp),%eax
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801025a2:	c7 05 f4 49 11 80 00 	movl   $0x0,0x801149f4
801025a9:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801025ac:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801025b2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b8:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801025be:	39 de                	cmp    %ebx,%esi
801025c0:	73 0a                	jae    801025cc <kinit1+0x4c>
801025c2:	eb 1a                	jmp    801025de <kinit1+0x5e>
801025c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025c8:	89 da                	mov    %ebx,%edx
801025ca:	89 c3                	mov    %eax,%ebx
    kfree(p);
801025cc:	89 14 24             	mov    %edx,(%esp)
801025cf:	e8 bc fe ff ff       	call   80102490 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801025da:	39 c6                	cmp    %eax,%esi
801025dc:	73 ea                	jae    801025c8 <kinit1+0x48>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
801025de:	83 c4 10             	add    $0x10,%esp
801025e1:	5b                   	pop    %ebx
801025e2:	5e                   	pop    %esi
801025e3:	5d                   	pop    %ebp
801025e4:	c3                   	ret    
801025e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025f0 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	56                   	push   %esi
801025f4:	53                   	push   %ebx
801025f5:	83 ec 10             	sub    $0x10,%esp

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801025f8:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
801025fb:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801025fe:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102604:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102610:	39 de                	cmp    %ebx,%esi
80102612:	73 08                	jae    8010261c <kinit2+0x2c>
80102614:	eb 18                	jmp    8010262e <kinit2+0x3e>
80102616:	66 90                	xchg   %ax,%ax
80102618:	89 da                	mov    %ebx,%edx
8010261a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010261c:	89 14 24             	mov    %edx,(%esp)
8010261f:	e8 6c fe ff ff       	call   80102490 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102624:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010262a:	39 c6                	cmp    %eax,%esi
8010262c:	73 ea                	jae    80102618 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
8010262e:	c7 05 f4 49 11 80 01 	movl   $0x1,0x801149f4
80102635:	00 00 00 
}
80102638:	83 c4 10             	add    $0x10,%esp
8010263b:	5b                   	pop    %ebx
8010263c:	5e                   	pop    %esi
8010263d:	5d                   	pop    %ebp
8010263e:	c3                   	ret    
8010263f:	90                   	nop

80102640 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	53                   	push   %ebx
80102644:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
80102647:	a1 f4 49 11 80       	mov    0x801149f4,%eax
8010264c:	85 c0                	test   %eax,%eax
8010264e:	75 30                	jne    80102680 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102650:	8b 1d f8 49 11 80    	mov    0x801149f8,%ebx
  if(r)
80102656:	85 db                	test   %ebx,%ebx
80102658:	74 08                	je     80102662 <kalloc+0x22>
    kmem.freelist = r->next;
8010265a:	8b 13                	mov    (%ebx),%edx
8010265c:	89 15 f8 49 11 80    	mov    %edx,0x801149f8
  if(kmem.use_lock)
80102662:	85 c0                	test   %eax,%eax
80102664:	74 0c                	je     80102672 <kalloc+0x32>
    release(&kmem.lock);
80102666:	c7 04 24 c0 49 11 80 	movl   $0x801149c0,(%esp)
8010266d:	e8 5e 2f 00 00       	call   801055d0 <release>
  return (char*)r;
}
80102672:	83 c4 14             	add    $0x14,%esp
80102675:	89 d8                	mov    %ebx,%eax
80102677:	5b                   	pop    %ebx
80102678:	5d                   	pop    %ebp
80102679:	c3                   	ret    
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102680:	c7 04 24 c0 49 11 80 	movl   $0x801149c0,(%esp)
80102687:	e8 04 2e 00 00       	call   80105490 <acquire>
8010268c:	a1 f4 49 11 80       	mov    0x801149f4,%eax
80102691:	eb bd                	jmp    80102650 <kalloc+0x10>
80102693:	66 90                	xchg   %ax,%ax
80102695:	66 90                	xchg   %ax,%ax
80102697:	66 90                	xchg   %ax,%ax
80102699:	66 90                	xchg   %ax,%ax
8010269b:	66 90                	xchg   %ax,%ax
8010269d:	66 90                	xchg   %ax,%ax
8010269f:	90                   	nop

801026a0 <kbdgetc>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026a0:	ba 64 00 00 00       	mov    $0x64,%edx
801026a5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026a6:	a8 01                	test   $0x1,%al
801026a8:	0f 84 ba 00 00 00    	je     80102768 <kbdgetc+0xc8>
801026ae:	b2 60                	mov    $0x60,%dl
801026b0:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801026b1:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
801026b4:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
801026ba:	0f 84 88 00 00 00    	je     80102748 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026c0:	84 c0                	test   %al,%al
801026c2:	79 2c                	jns    801026f0 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801026c4:	8b 15 b4 c5 10 80    	mov    0x8010c5b4,%edx
801026ca:	f6 c2 40             	test   $0x40,%dl
801026cd:	75 05                	jne    801026d4 <kbdgetc+0x34>
801026cf:	89 c1                	mov    %eax,%ecx
801026d1:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801026d4:	0f b6 81 60 93 10 80 	movzbl -0x7fef6ca0(%ecx),%eax
801026db:	83 c8 40             	or     $0x40,%eax
801026de:	0f b6 c0             	movzbl %al,%eax
801026e1:	f7 d0                	not    %eax
801026e3:	21 d0                	and    %edx,%eax
801026e5:	a3 b4 c5 10 80       	mov    %eax,0x8010c5b4
    return 0;
801026ea:	31 c0                	xor    %eax,%eax
801026ec:	c3                   	ret    
801026ed:	8d 76 00             	lea    0x0(%esi),%esi
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026f0:	55                   	push   %ebp
801026f1:	89 e5                	mov    %esp,%ebp
801026f3:	53                   	push   %ebx
801026f4:	8b 1d b4 c5 10 80    	mov    0x8010c5b4,%ebx
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026fa:	f6 c3 40             	test   $0x40,%bl
801026fd:	74 09                	je     80102708 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026ff:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102702:	83 e3 bf             	and    $0xffffffbf,%ebx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102705:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102708:	0f b6 91 60 93 10 80 	movzbl -0x7fef6ca0(%ecx),%edx
  shift ^= togglecode[data];
8010270f:	0f b6 81 60 92 10 80 	movzbl -0x7fef6da0(%ecx),%eax
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102716:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102718:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010271a:	89 d0                	mov    %edx,%eax
8010271c:	83 e0 03             	and    $0x3,%eax
8010271f:	8b 04 85 40 92 10 80 	mov    -0x7fef6dc0(,%eax,4),%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102726:	89 15 b4 c5 10 80    	mov    %edx,0x8010c5b4
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
8010272c:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010272f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102733:	74 0b                	je     80102740 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
80102735:	8d 50 9f             	lea    -0x61(%eax),%edx
80102738:	83 fa 19             	cmp    $0x19,%edx
8010273b:	77 1b                	ja     80102758 <kbdgetc+0xb8>
      c += 'A' - 'a';
8010273d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102740:	5b                   	pop    %ebx
80102741:	5d                   	pop    %ebp
80102742:	c3                   	ret    
80102743:	90                   	nop
80102744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102748:	83 0d b4 c5 10 80 40 	orl    $0x40,0x8010c5b4
    return 0;
8010274f:	31 c0                	xor    %eax,%eax
80102751:	c3                   	ret    
80102752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102758:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010275b:	8d 50 20             	lea    0x20(%eax),%edx
8010275e:	83 f9 19             	cmp    $0x19,%ecx
80102761:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
80102764:	eb da                	jmp    80102740 <kbdgetc+0xa0>
80102766:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102768:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010276d:	c3                   	ret    
8010276e:	66 90                	xchg   %ax,%ax

80102770 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
80102773:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102776:	c7 04 24 a0 26 10 80 	movl   $0x801026a0,(%esp)
8010277d:	e8 2e e0 ff ff       	call   801007b0 <consoleintr>
}
80102782:	c9                   	leave  
80102783:	c3                   	ret    
80102784:	66 90                	xchg   %ax,%ax
80102786:	66 90                	xchg   %ax,%ax
80102788:	66 90                	xchg   %ax,%ax
8010278a:	66 90                	xchg   %ax,%ax
8010278c:	66 90                	xchg   %ax,%ax
8010278e:	66 90                	xchg   %ax,%ax

80102790 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
80102790:	55                   	push   %ebp
80102791:	89 c1                	mov    %eax,%ecx
80102793:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102795:	ba 70 00 00 00       	mov    $0x70,%edx
8010279a:	53                   	push   %ebx
8010279b:	31 c0                	xor    %eax,%eax
8010279d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010279e:	bb 71 00 00 00       	mov    $0x71,%ebx
801027a3:	89 da                	mov    %ebx,%edx
801027a5:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
801027a6:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027a9:	b2 70                	mov    $0x70,%dl
801027ab:	89 01                	mov    %eax,(%ecx)
801027ad:	b8 02 00 00 00       	mov    $0x2,%eax
801027b2:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027b3:	89 da                	mov    %ebx,%edx
801027b5:	ec                   	in     (%dx),%al
801027b6:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027b9:	b2 70                	mov    $0x70,%dl
801027bb:	89 41 04             	mov    %eax,0x4(%ecx)
801027be:	b8 04 00 00 00       	mov    $0x4,%eax
801027c3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027c4:	89 da                	mov    %ebx,%edx
801027c6:	ec                   	in     (%dx),%al
801027c7:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027ca:	b2 70                	mov    $0x70,%dl
801027cc:	89 41 08             	mov    %eax,0x8(%ecx)
801027cf:	b8 07 00 00 00       	mov    $0x7,%eax
801027d4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027d5:	89 da                	mov    %ebx,%edx
801027d7:	ec                   	in     (%dx),%al
801027d8:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027db:	b2 70                	mov    $0x70,%dl
801027dd:	89 41 0c             	mov    %eax,0xc(%ecx)
801027e0:	b8 08 00 00 00       	mov    $0x8,%eax
801027e5:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027e6:	89 da                	mov    %ebx,%edx
801027e8:	ec                   	in     (%dx),%al
801027e9:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027ec:	b2 70                	mov    $0x70,%dl
801027ee:	89 41 10             	mov    %eax,0x10(%ecx)
801027f1:	b8 09 00 00 00       	mov    $0x9,%eax
801027f6:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027f7:	89 da                	mov    %ebx,%edx
801027f9:	ec                   	in     (%dx),%al
801027fa:	0f b6 d8             	movzbl %al,%ebx
801027fd:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102800:	5b                   	pop    %ebx
80102801:	5d                   	pop    %ebp
80102802:	c3                   	ret    
80102803:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102810 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic)
80102810:	a1 fc 49 11 80       	mov    0x801149fc,%eax
}
//PAGEBREAK!

void
lapicinit(void)
{
80102815:	55                   	push   %ebp
80102816:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102818:	85 c0                	test   %eax,%eax
8010281a:	0f 84 c0 00 00 00    	je     801028e0 <lapicinit+0xd0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102820:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102827:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010282a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010282d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102834:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102837:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010283a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102841:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102844:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102847:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010284e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102851:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102854:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010285b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010285e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102861:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102868:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010286b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010286e:	8b 50 30             	mov    0x30(%eax),%edx
80102871:	c1 ea 10             	shr    $0x10,%edx
80102874:	80 fa 03             	cmp    $0x3,%dl
80102877:	77 6f                	ja     801028e8 <lapicinit+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102879:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102880:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102883:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102886:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010288d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102890:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102893:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010289a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010289d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028a0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028a7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028aa:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028ad:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b7:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028ba:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028c1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028c4:	8b 50 20             	mov    0x20(%eax),%edx
801028c7:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028c8:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028ce:	80 e6 10             	and    $0x10,%dh
801028d1:	75 f5                	jne    801028c8 <lapicinit+0xb8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028d3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028da:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028dd:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028e0:	5d                   	pop    %ebp
801028e1:	c3                   	ret    
801028e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028e8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028ef:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028f2:	8b 50 20             	mov    0x20(%eax),%edx
801028f5:	eb 82                	jmp    80102879 <lapicinit+0x69>
801028f7:	89 f6                	mov    %esi,%esi
801028f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102900 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
80102900:	55                   	push   %ebp
80102901:	89 e5                	mov    %esp,%ebp
80102903:	56                   	push   %esi
80102904:	53                   	push   %ebx
80102905:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102908:	9c                   	pushf  
80102909:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
8010290a:	f6 c4 02             	test   $0x2,%ah
8010290d:	74 12                	je     80102921 <cpunum+0x21>
    static int n;
    if(n++ == 0)
8010290f:	a1 b8 c5 10 80       	mov    0x8010c5b8,%eax
80102914:	8d 50 01             	lea    0x1(%eax),%edx
80102917:	85 c0                	test   %eax,%eax
80102919:	89 15 b8 c5 10 80    	mov    %edx,0x8010c5b8
8010291f:	74 4a                	je     8010296b <cpunum+0x6b>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
80102921:	a1 fc 49 11 80       	mov    0x801149fc,%eax
80102926:	85 c0                	test   %eax,%eax
80102928:	74 5d                	je     80102987 <cpunum+0x87>
    return 0;

  apicid = lapic[ID] >> 24;
8010292a:	8b 58 20             	mov    0x20(%eax),%ebx
  for (i = 0; i < ncpu; ++i) {
8010292d:	8b 35 e0 50 11 80    	mov    0x801150e0,%esi
  }

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
80102933:	c1 eb 18             	shr    $0x18,%ebx
  for (i = 0; i < ncpu; ++i) {
80102936:	85 f6                	test   %esi,%esi
80102938:	7e 56                	jle    80102990 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
8010293a:	0f b6 05 00 4b 11 80 	movzbl 0x80114b00,%eax
80102941:	39 d8                	cmp    %ebx,%eax
80102943:	74 42                	je     80102987 <cpunum+0x87>
80102945:	ba bc 4b 11 80       	mov    $0x80114bbc,%edx

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
8010294a:	31 c0                	xor    %eax,%eax
8010294c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102950:	83 c0 01             	add    $0x1,%eax
80102953:	39 f0                	cmp    %esi,%eax
80102955:	74 39                	je     80102990 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
80102957:	0f b6 0a             	movzbl (%edx),%ecx
8010295a:	81 c2 bc 00 00 00    	add    $0xbc,%edx
80102960:	39 d9                	cmp    %ebx,%ecx
80102962:	75 ec                	jne    80102950 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
80102964:	83 c4 10             	add    $0x10,%esp
80102967:	5b                   	pop    %ebx
80102968:	5e                   	pop    %esi
80102969:	5d                   	pop    %ebp
8010296a:	c3                   	ret    
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
8010296b:	8b 45 04             	mov    0x4(%ebp),%eax
8010296e:	c7 04 24 60 94 10 80 	movl   $0x80109460,(%esp)
80102975:	89 44 24 04          	mov    %eax,0x4(%esp)
80102979:	e8 d2 dc ff ff       	call   80100650 <cprintf>
        __builtin_return_address(0));
  }

  if (!lapic)
8010297e:	a1 fc 49 11 80       	mov    0x801149fc,%eax
80102983:	85 c0                	test   %eax,%eax
80102985:	75 a3                	jne    8010292a <cpunum+0x2a>
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
80102987:	83 c4 10             	add    $0x10,%esp
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
    return 0;
8010298a:	31 c0                	xor    %eax,%eax
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
8010298c:	5b                   	pop    %ebx
8010298d:	5e                   	pop    %esi
8010298e:	5d                   	pop    %ebp
8010298f:	c3                   	ret    
  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
80102990:	c7 04 24 8c 94 10 80 	movl   $0x8010948c,(%esp)
80102997:	e8 c4 d9 ff ff       	call   80100360 <panic>
8010299c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801029a0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801029a0:	a1 fc 49 11 80       	mov    0x801149fc,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
801029a5:	55                   	push   %ebp
801029a6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801029a8:	85 c0                	test   %eax,%eax
801029aa:	74 0d                	je     801029b9 <lapiceoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029ac:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029b3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
801029b9:	5d                   	pop    %ebp
801029ba:	c3                   	ret    
801029bb:	90                   	nop
801029bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801029c0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801029c0:	55                   	push   %ebp
801029c1:	89 e5                	mov    %esp,%ebp
}
801029c3:	5d                   	pop    %ebp
801029c4:	c3                   	ret    
801029c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029d0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801029d0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d1:	ba 70 00 00 00       	mov    $0x70,%edx
801029d6:	89 e5                	mov    %esp,%ebp
801029d8:	b8 0f 00 00 00       	mov    $0xf,%eax
801029dd:	53                   	push   %ebx
801029de:	8b 4d 08             	mov    0x8(%ebp),%ecx
801029e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801029e4:	ee                   	out    %al,(%dx)
801029e5:	b8 0a 00 00 00       	mov    $0xa,%eax
801029ea:	b2 71                	mov    $0x71,%dl
801029ec:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029ed:	31 c0                	xor    %eax,%eax
801029ef:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801029f5:	89 d8                	mov    %ebx,%eax
801029f7:	c1 e8 04             	shr    $0x4,%eax
801029fa:	66 a3 69 04 00 80    	mov    %ax,0x80000469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a00:	a1 fc 49 11 80       	mov    0x801149fc,%eax
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102a05:	c1 e1 18             	shl    $0x18,%ecx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a08:	c1 eb 0c             	shr    $0xc,%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a0b:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a11:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a14:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a1b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a1e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a21:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a28:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a2b:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a2e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a34:	8b 50 20             	mov    0x20(%eax),%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a37:	89 da                	mov    %ebx,%edx
80102a39:	80 ce 06             	or     $0x6,%dh
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a3c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a42:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a45:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a4b:	8b 48 20             	mov    0x20(%eax),%ecx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a4e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a54:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102a57:	5b                   	pop    %ebx
80102a58:	5d                   	pop    %ebp
80102a59:	c3                   	ret    
80102a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a60 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102a60:	55                   	push   %ebp
80102a61:	ba 70 00 00 00       	mov    $0x70,%edx
80102a66:	89 e5                	mov    %esp,%ebp
80102a68:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a6d:	57                   	push   %edi
80102a6e:	56                   	push   %esi
80102a6f:	53                   	push   %ebx
80102a70:	83 ec 4c             	sub    $0x4c,%esp
80102a73:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a74:	b2 71                	mov    $0x71,%dl
80102a76:	ec                   	in     (%dx),%al
80102a77:	88 45 b7             	mov    %al,-0x49(%ebp)
80102a7a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a7d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102a81:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a88:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80102a8d:	89 d8                	mov    %ebx,%eax
80102a8f:	e8 fc fc ff ff       	call   80102790 <fill_rtcdate>
80102a94:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a99:	89 f2                	mov    %esi,%edx
80102a9b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9c:	ba 71 00 00 00       	mov    $0x71,%edx
80102aa1:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102aa2:	84 c0                	test   %al,%al
80102aa4:	78 e7                	js     80102a8d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102aa6:	89 f8                	mov    %edi,%eax
80102aa8:	e8 e3 fc ff ff       	call   80102790 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aad:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102ab4:	00 
80102ab5:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102ab9:	89 1c 24             	mov    %ebx,(%esp)
80102abc:	e8 af 2b 00 00       	call   80105670 <memcmp>
80102ac1:	85 c0                	test   %eax,%eax
80102ac3:	75 c3                	jne    80102a88 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ac5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102ac9:	75 78                	jne    80102b43 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102acb:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ace:	89 c2                	mov    %eax,%edx
80102ad0:	83 e0 0f             	and    $0xf,%eax
80102ad3:	c1 ea 04             	shr    $0x4,%edx
80102ad6:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ad9:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102adc:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102adf:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ae2:	89 c2                	mov    %eax,%edx
80102ae4:	83 e0 0f             	and    $0xf,%eax
80102ae7:	c1 ea 04             	shr    $0x4,%edx
80102aea:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102aed:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102af0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102af3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102af6:	89 c2                	mov    %eax,%edx
80102af8:	83 e0 0f             	and    $0xf,%eax
80102afb:	c1 ea 04             	shr    $0x4,%edx
80102afe:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b01:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b04:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b07:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b0a:	89 c2                	mov    %eax,%edx
80102b0c:	83 e0 0f             	and    $0xf,%eax
80102b0f:	c1 ea 04             	shr    $0x4,%edx
80102b12:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b15:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b18:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b1b:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b1e:	89 c2                	mov    %eax,%edx
80102b20:	83 e0 0f             	and    $0xf,%eax
80102b23:	c1 ea 04             	shr    $0x4,%edx
80102b26:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b29:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b2c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b2f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b32:	89 c2                	mov    %eax,%edx
80102b34:	83 e0 0f             	and    $0xf,%eax
80102b37:	c1 ea 04             	shr    $0x4,%edx
80102b3a:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b40:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b43:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102b46:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b49:	89 01                	mov    %eax,(%ecx)
80102b4b:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b4e:	89 41 04             	mov    %eax,0x4(%ecx)
80102b51:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b54:	89 41 08             	mov    %eax,0x8(%ecx)
80102b57:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b5a:	89 41 0c             	mov    %eax,0xc(%ecx)
80102b5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b60:	89 41 10             	mov    %eax,0x10(%ecx)
80102b63:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b66:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102b69:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102b70:	83 c4 4c             	add    $0x4c,%esp
80102b73:	5b                   	pop    %ebx
80102b74:	5e                   	pop    %esi
80102b75:	5f                   	pop    %edi
80102b76:	5d                   	pop    %ebp
80102b77:	c3                   	ret    
80102b78:	66 90                	xchg   %ax,%ax
80102b7a:	66 90                	xchg   %ax,%ax
80102b7c:	66 90                	xchg   %ax,%ax
80102b7e:	66 90                	xchg   %ax,%ax

80102b80 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	57                   	push   %edi
80102b84:	56                   	push   %esi
80102b85:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b86:	31 db                	xor    %ebx,%ebx
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102b88:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b8b:	a1 48 4a 11 80       	mov    0x80114a48,%eax
80102b90:	85 c0                	test   %eax,%eax
80102b92:	7e 78                	jle    80102c0c <install_trans+0x8c>
80102b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102b98:	a1 34 4a 11 80       	mov    0x80114a34,%eax
80102b9d:	01 d8                	add    %ebx,%eax
80102b9f:	83 c0 01             	add    $0x1,%eax
80102ba2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ba6:	a1 44 4a 11 80       	mov    0x80114a44,%eax
80102bab:	89 04 24             	mov    %eax,(%esp)
80102bae:	e8 1d d5 ff ff       	call   801000d0 <bread>
80102bb3:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bb5:	8b 04 9d 4c 4a 11 80 	mov    -0x7feeb5b4(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bbc:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bc3:	a1 44 4a 11 80       	mov    0x80114a44,%eax
80102bc8:	89 04 24             	mov    %eax,(%esp)
80102bcb:	e8 00 d5 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bd0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102bd7:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bd8:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bda:	8d 47 5c             	lea    0x5c(%edi),%eax
80102bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
80102be1:	8d 46 5c             	lea    0x5c(%esi),%eax
80102be4:	89 04 24             	mov    %eax,(%esp)
80102be7:	e8 d4 2a 00 00       	call   801056c0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102bec:	89 34 24             	mov    %esi,(%esp)
80102bef:	e8 ac d5 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102bf4:	89 3c 24             	mov    %edi,(%esp)
80102bf7:	e8 e4 d5 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102bfc:	89 34 24             	mov    %esi,(%esp)
80102bff:	e8 dc d5 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c04:	39 1d 48 4a 11 80    	cmp    %ebx,0x80114a48
80102c0a:	7f 8c                	jg     80102b98 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102c0c:	83 c4 1c             	add    $0x1c,%esp
80102c0f:	5b                   	pop    %ebx
80102c10:	5e                   	pop    %esi
80102c11:	5f                   	pop    %edi
80102c12:	5d                   	pop    %ebp
80102c13:	c3                   	ret    
80102c14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102c1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102c20 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	57                   	push   %edi
80102c24:	56                   	push   %esi
80102c25:	53                   	push   %ebx
80102c26:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c29:	a1 34 4a 11 80       	mov    0x80114a34,%eax
80102c2e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c32:	a1 44 4a 11 80       	mov    0x80114a44,%eax
80102c37:	89 04 24             	mov    %eax,(%esp)
80102c3a:	e8 91 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102c3f:	8b 1d 48 4a 11 80    	mov    0x80114a48,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102c45:	31 d2                	xor    %edx,%edx
80102c47:	85 db                	test   %ebx,%ebx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102c49:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102c4b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102c4e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102c51:	7e 17                	jle    80102c6a <write_head+0x4a>
80102c53:	90                   	nop
80102c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102c58:	8b 0c 95 4c 4a 11 80 	mov    -0x7feeb5b4(,%edx,4),%ecx
80102c5f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c63:	83 c2 01             	add    $0x1,%edx
80102c66:	39 da                	cmp    %ebx,%edx
80102c68:	75 ee                	jne    80102c58 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102c6a:	89 3c 24             	mov    %edi,(%esp)
80102c6d:	e8 2e d5 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102c72:	89 3c 24             	mov    %edi,(%esp)
80102c75:	e8 66 d5 ff ff       	call   801001e0 <brelse>
}
80102c7a:	83 c4 1c             	add    $0x1c,%esp
80102c7d:	5b                   	pop    %ebx
80102c7e:	5e                   	pop    %esi
80102c7f:	5f                   	pop    %edi
80102c80:	5d                   	pop    %ebp
80102c81:	c3                   	ret    
80102c82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c90 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102c90:	55                   	push   %ebp
80102c91:	89 e5                	mov    %esp,%ebp
80102c93:	56                   	push   %esi
80102c94:	53                   	push   %ebx
80102c95:	83 ec 30             	sub    $0x30,%esp
80102c98:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102c9b:	c7 44 24 04 9c 94 10 	movl   $0x8010949c,0x4(%esp)
80102ca2:	80 
80102ca3:	c7 04 24 00 4a 11 80 	movl   $0x80114a00,(%esp)
80102caa:	e8 61 27 00 00       	call   80105410 <initlock>
  readsb(dev, &sb);
80102caf:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cb2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102cb6:	89 1c 24             	mov    %ebx,(%esp)
80102cb9:	e8 a2 e7 ff ff       	call   80101460 <readsb>
  log.start = sb.logstart;
80102cbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102cc1:	8b 55 e8             	mov    -0x18(%ebp),%edx

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102cc4:	89 1c 24             	mov    %ebx,(%esp)
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102cc7:	89 1d 44 4a 11 80    	mov    %ebx,0x80114a44

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102ccd:	89 44 24 04          	mov    %eax,0x4(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102cd1:	89 15 38 4a 11 80    	mov    %edx,0x80114a38
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102cd7:	a3 34 4a 11 80       	mov    %eax,0x80114a34

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102cdc:	e8 ef d3 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102ce1:	31 d2                	xor    %edx,%edx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ce3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ce6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102ce9:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ceb:	89 1d 48 4a 11 80    	mov    %ebx,0x80114a48
  for (i = 0; i < log.lh.n; i++) {
80102cf1:	7e 17                	jle    80102d0a <initlog+0x7a>
80102cf3:	90                   	nop
80102cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102cf8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102cfc:	89 0c 95 4c 4a 11 80 	mov    %ecx,-0x7feeb5b4(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102d03:	83 c2 01             	add    $0x1,%edx
80102d06:	39 da                	cmp    %ebx,%edx
80102d08:	75 ee                	jne    80102cf8 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102d0a:	89 04 24             	mov    %eax,(%esp)
80102d0d:	e8 ce d4 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d12:	e8 69 fe ff ff       	call   80102b80 <install_trans>
  log.lh.n = 0;
80102d17:	c7 05 48 4a 11 80 00 	movl   $0x0,0x80114a48
80102d1e:	00 00 00 
  write_head(); // clear the log
80102d21:	e8 fa fe ff ff       	call   80102c20 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102d26:	83 c4 30             	add    $0x30,%esp
80102d29:	5b                   	pop    %ebx
80102d2a:	5e                   	pop    %esi
80102d2b:	5d                   	pop    %ebp
80102d2c:	c3                   	ret    
80102d2d:	8d 76 00             	lea    0x0(%esi),%esi

80102d30 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d30:	55                   	push   %ebp
80102d31:	89 e5                	mov    %esp,%ebp
80102d33:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102d36:	c7 04 24 00 4a 11 80 	movl   $0x80114a00,(%esp)
80102d3d:	e8 4e 27 00 00       	call   80105490 <acquire>
80102d42:	eb 18                	jmp    80102d5c <begin_op+0x2c>
80102d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d48:	c7 44 24 04 00 4a 11 	movl   $0x80114a00,0x4(%esp)
80102d4f:	80 
80102d50:	c7 04 24 00 4a 11 80 	movl   $0x80114a00,(%esp)
80102d57:	e8 e4 0e 00 00       	call   80103c40 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102d5c:	a1 40 4a 11 80       	mov    0x80114a40,%eax
80102d61:	85 c0                	test   %eax,%eax
80102d63:	75 e3                	jne    80102d48 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d65:	a1 3c 4a 11 80       	mov    0x80114a3c,%eax
80102d6a:	8b 15 48 4a 11 80    	mov    0x80114a48,%edx
80102d70:	83 c0 01             	add    $0x1,%eax
80102d73:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d76:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d79:	83 fa 1e             	cmp    $0x1e,%edx
80102d7c:	7f ca                	jg     80102d48 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d7e:	c7 04 24 00 4a 11 80 	movl   $0x80114a00,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102d85:	a3 3c 4a 11 80       	mov    %eax,0x80114a3c
      release(&log.lock);
80102d8a:	e8 41 28 00 00       	call   801055d0 <release>
      break;
    }
  }
}
80102d8f:	c9                   	leave  
80102d90:	c3                   	ret    
80102d91:	eb 0d                	jmp    80102da0 <end_op>
80102d93:	90                   	nop
80102d94:	90                   	nop
80102d95:	90                   	nop
80102d96:	90                   	nop
80102d97:	90                   	nop
80102d98:	90                   	nop
80102d99:	90                   	nop
80102d9a:	90                   	nop
80102d9b:	90                   	nop
80102d9c:	90                   	nop
80102d9d:	90                   	nop
80102d9e:	90                   	nop
80102d9f:	90                   	nop

80102da0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
80102da3:	57                   	push   %edi
80102da4:	56                   	push   %esi
80102da5:	53                   	push   %ebx
80102da6:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102da9:	c7 04 24 00 4a 11 80 	movl   $0x80114a00,(%esp)
80102db0:	e8 db 26 00 00       	call   80105490 <acquire>
  log.outstanding -= 1;
80102db5:	a1 3c 4a 11 80       	mov    0x80114a3c,%eax
  if(log.committing)
80102dba:	8b 15 40 4a 11 80    	mov    0x80114a40,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102dc0:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102dc3:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102dc5:	a3 3c 4a 11 80       	mov    %eax,0x80114a3c
  if(log.committing)
80102dca:	0f 85 f3 00 00 00    	jne    80102ec3 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102dd0:	85 c0                	test   %eax,%eax
80102dd2:	0f 85 cb 00 00 00    	jne    80102ea3 <end_op+0x103>
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102dd8:	c7 04 24 00 4a 11 80 	movl   $0x80114a00,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ddf:	31 db                	xor    %ebx,%ebx
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102de1:	c7 05 40 4a 11 80 01 	movl   $0x1,0x80114a40
80102de8:	00 00 00 
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102deb:	e8 e0 27 00 00       	call   801055d0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102df0:	a1 48 4a 11 80       	mov    0x80114a48,%eax
80102df5:	85 c0                	test   %eax,%eax
80102df7:	0f 8e 90 00 00 00    	jle    80102e8d <end_op+0xed>
80102dfd:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e00:	a1 34 4a 11 80       	mov    0x80114a34,%eax
80102e05:	01 d8                	add    %ebx,%eax
80102e07:	83 c0 01             	add    $0x1,%eax
80102e0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e0e:	a1 44 4a 11 80       	mov    0x80114a44,%eax
80102e13:	89 04 24             	mov    %eax,(%esp)
80102e16:	e8 b5 d2 ff ff       	call   801000d0 <bread>
80102e1b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e1d:	8b 04 9d 4c 4a 11 80 	mov    -0x7feeb5b4(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e24:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e27:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e2b:	a1 44 4a 11 80       	mov    0x80114a44,%eax
80102e30:	89 04 24             	mov    %eax,(%esp)
80102e33:	e8 98 d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e38:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102e3f:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e40:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e42:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e45:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e49:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e4c:	89 04 24             	mov    %eax,(%esp)
80102e4f:	e8 6c 28 00 00       	call   801056c0 <memmove>
    bwrite(to);  // write the log
80102e54:	89 34 24             	mov    %esi,(%esp)
80102e57:	e8 44 d3 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102e5c:	89 3c 24             	mov    %edi,(%esp)
80102e5f:	e8 7c d3 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102e64:	89 34 24             	mov    %esi,(%esp)
80102e67:	e8 74 d3 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e6c:	3b 1d 48 4a 11 80    	cmp    0x80114a48,%ebx
80102e72:	7c 8c                	jl     80102e00 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102e74:	e8 a7 fd ff ff       	call   80102c20 <write_head>
    install_trans(); // Now install writes to home locations
80102e79:	e8 02 fd ff ff       	call   80102b80 <install_trans>
    log.lh.n = 0;
80102e7e:	c7 05 48 4a 11 80 00 	movl   $0x0,0x80114a48
80102e85:	00 00 00 
    write_head();    // Erase the transaction from the log
80102e88:	e8 93 fd ff ff       	call   80102c20 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102e8d:	c7 04 24 00 4a 11 80 	movl   $0x80114a00,(%esp)
80102e94:	e8 f7 25 00 00       	call   80105490 <acquire>
    log.committing = 0;
80102e99:	c7 05 40 4a 11 80 00 	movl   $0x0,0x80114a40
80102ea0:	00 00 00 
    wakeup(&log);
80102ea3:	c7 04 24 00 4a 11 80 	movl   $0x80114a00,(%esp)
80102eaa:	e8 41 0f 00 00       	call   80103df0 <wakeup>
    release(&log.lock);
80102eaf:	c7 04 24 00 4a 11 80 	movl   $0x80114a00,(%esp)
80102eb6:	e8 15 27 00 00       	call   801055d0 <release>
  }
}
80102ebb:	83 c4 1c             	add    $0x1c,%esp
80102ebe:	5b                   	pop    %ebx
80102ebf:	5e                   	pop    %esi
80102ec0:	5f                   	pop    %edi
80102ec1:	5d                   	pop    %ebp
80102ec2:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102ec3:	c7 04 24 a0 94 10 80 	movl   $0x801094a0,(%esp)
80102eca:	e8 91 d4 ff ff       	call   80100360 <panic>
80102ecf:	90                   	nop

80102ed0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102ed0:	55                   	push   %ebp
80102ed1:	89 e5                	mov    %esp,%ebp
80102ed3:	53                   	push   %ebx
80102ed4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ed7:	a1 48 4a 11 80       	mov    0x80114a48,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102edc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102edf:	83 f8 1d             	cmp    $0x1d,%eax
80102ee2:	0f 8f 98 00 00 00    	jg     80102f80 <log_write+0xb0>
80102ee8:	8b 0d 38 4a 11 80    	mov    0x80114a38,%ecx
80102eee:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102ef1:	39 d0                	cmp    %edx,%eax
80102ef3:	0f 8d 87 00 00 00    	jge    80102f80 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102ef9:	a1 3c 4a 11 80       	mov    0x80114a3c,%eax
80102efe:	85 c0                	test   %eax,%eax
80102f00:	0f 8e 86 00 00 00    	jle    80102f8c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f06:	c7 04 24 00 4a 11 80 	movl   $0x80114a00,(%esp)
80102f0d:	e8 7e 25 00 00       	call   80105490 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f12:	8b 15 48 4a 11 80    	mov    0x80114a48,%edx
80102f18:	83 fa 00             	cmp    $0x0,%edx
80102f1b:	7e 54                	jle    80102f71 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f1d:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102f20:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f22:	39 0d 4c 4a 11 80    	cmp    %ecx,0x80114a4c
80102f28:	75 0f                	jne    80102f39 <log_write+0x69>
80102f2a:	eb 3c                	jmp    80102f68 <log_write+0x98>
80102f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f30:	39 0c 85 4c 4a 11 80 	cmp    %ecx,-0x7feeb5b4(,%eax,4)
80102f37:	74 2f                	je     80102f68 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102f39:	83 c0 01             	add    $0x1,%eax
80102f3c:	39 d0                	cmp    %edx,%eax
80102f3e:	75 f0                	jne    80102f30 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102f40:	89 0c 95 4c 4a 11 80 	mov    %ecx,-0x7feeb5b4(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102f47:	83 c2 01             	add    $0x1,%edx
80102f4a:	89 15 48 4a 11 80    	mov    %edx,0x80114a48
  b->flags |= B_DIRTY; // prevent eviction
80102f50:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102f53:	c7 45 08 00 4a 11 80 	movl   $0x80114a00,0x8(%ebp)
}
80102f5a:	83 c4 14             	add    $0x14,%esp
80102f5d:	5b                   	pop    %ebx
80102f5e:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102f5f:	e9 6c 26 00 00       	jmp    801055d0 <release>
80102f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102f68:	89 0c 85 4c 4a 11 80 	mov    %ecx,-0x7feeb5b4(,%eax,4)
80102f6f:	eb df                	jmp    80102f50 <log_write+0x80>
80102f71:	8b 43 08             	mov    0x8(%ebx),%eax
80102f74:	a3 4c 4a 11 80       	mov    %eax,0x80114a4c
  if (i == log.lh.n)
80102f79:	75 d5                	jne    80102f50 <log_write+0x80>
80102f7b:	eb ca                	jmp    80102f47 <log_write+0x77>
80102f7d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102f80:	c7 04 24 af 94 10 80 	movl   $0x801094af,(%esp)
80102f87:	e8 d4 d3 ff ff       	call   80100360 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102f8c:	c7 04 24 c5 94 10 80 	movl   $0x801094c5,(%esp)
80102f93:	e8 c8 d3 ff ff       	call   80100360 <panic>
80102f98:	66 90                	xchg   %ax,%ax
80102f9a:	66 90                	xchg   %ax,%ax
80102f9c:	66 90                	xchg   %ax,%ax
80102f9e:	66 90                	xchg   %ax,%ax

80102fa0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpunum());
80102fa6:	e8 55 f9 ff ff       	call   80102900 <cpunum>
80102fab:	c7 04 24 e0 94 10 80 	movl   $0x801094e0,(%esp)
80102fb2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fb6:	e8 95 d6 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102fbb:	e8 40 3a 00 00       	call   80106a00 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80102fc0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102fc7:	b8 01 00 00 00       	mov    $0x1,%eax
80102fcc:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80102fd3:	e8 a8 10 00 00       	call   80104080 <scheduler>
80102fd8:	90                   	nop
80102fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102fe0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102fe6:	e8 d5 4d 00 00       	call   80107dc0 <switchkvm>
  seginit();
80102feb:	e8 f0 4b 00 00       	call   80107be0 <seginit>
  lapicinit();
80102ff0:	e8 1b f8 ff ff       	call   80102810 <lapicinit>
  mpmain();
80102ff5:	e8 a6 ff ff ff       	call   80102fa0 <mpmain>
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 e4 f0             	and    $0xfffffff0,%esp
80103007:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010300a:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103011:	80 
80103012:	c7 04 24 a8 80 11 80 	movl   $0x801180a8,(%esp)
80103019:	e8 62 f5 ff ff       	call   80102580 <kinit1>
  kvmalloc();      // kernel page table
8010301e:	e8 7d 4d 00 00       	call   80107da0 <kvmalloc>
  mpinit();        // detect other processors
80103023:	e8 a8 01 00 00       	call   801031d0 <mpinit>
  lapicinit();     // interrupt controller
80103028:	e8 e3 f7 ff ff       	call   80102810 <lapicinit>
8010302d:	8d 76 00             	lea    0x0(%esi),%esi
  seginit();       // segment descriptors
80103030:	e8 ab 4b 00 00       	call   80107be0 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80103035:	e8 c6 f8 ff ff       	call   80102900 <cpunum>
8010303a:	c7 04 24 f1 94 10 80 	movl   $0x801094f1,(%esp)
80103041:	89 44 24 04          	mov    %eax,0x4(%esp)
80103045:	e8 06 d6 ff ff       	call   80100650 <cprintf>
  picinit();       // another interrupt controller
8010304a:	e8 81 03 00 00       	call   801033d0 <picinit>
  ioapicinit();    // another interrupt controller
8010304f:	e8 4c f3 ff ff       	call   801023a0 <ioapicinit>
  consoleinit();   // console hardware
80103054:	e8 f7 d8 ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80103059:	e8 92 3e 00 00       	call   80106ef0 <uartinit>
8010305e:	66 90                	xchg   %ax,%ax
  pinit();         // process table
80103060:	e8 bb 08 00 00       	call   80103920 <pinit>
  tvinit();        // trap vectors
80103065:	e8 c6 38 00 00       	call   80106930 <tvinit>
  binit();         // buffer cache
8010306a:	e8 d1 cf ff ff       	call   80100040 <binit>
8010306f:	90                   	nop
  fileinit();      // file table
80103070:	e8 eb dc ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk
80103075:	e8 16 f1 ff ff       	call   80102190 <ideinit>
  if(!ismp)
8010307a:	a1 e4 4a 11 80       	mov    0x80114ae4,%eax
8010307f:	85 c0                	test   %eax,%eax
80103081:	0f 84 ca 00 00 00    	je     80103151 <main+0x151>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103087:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
8010308e:	00 

  for(c = cpus; c < cpus+ncpu; c++){
8010308f:	bb 00 4b 11 80       	mov    $0x80114b00,%ebx

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103094:	c7 44 24 04 8c c4 10 	movl   $0x8010c48c,0x4(%esp)
8010309b:	80 
8010309c:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
801030a3:	e8 18 26 00 00       	call   801056c0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030a8:	69 05 e0 50 11 80 bc 	imul   $0xbc,0x801150e0,%eax
801030af:	00 00 00 
801030b2:	05 00 4b 11 80       	add    $0x80114b00,%eax
801030b7:	39 d8                	cmp    %ebx,%eax
801030b9:	76 78                	jbe    80103133 <main+0x133>
801030bb:	90                   	nop
801030bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == cpus+cpunum())  // We've started already.
801030c0:	e8 3b f8 ff ff       	call   80102900 <cpunum>
801030c5:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801030cb:	05 00 4b 11 80       	add    $0x80114b00,%eax
801030d0:	39 c3                	cmp    %eax,%ebx
801030d2:	74 46                	je     8010311a <main+0x11a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801030d4:	e8 67 f5 ff ff       	call   80102640 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
801030d9:	c7 05 f8 6f 00 80 e0 	movl   $0x80102fe0,0x80006ff8
801030e0:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801030e3:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
801030ea:	b0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
801030ed:	05 00 10 00 00       	add    $0x1000,%eax
801030f2:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801030f7:	0f b6 03             	movzbl (%ebx),%eax
801030fa:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80103101:	00 
80103102:	89 04 24             	mov    %eax,(%esp)
80103105:	e8 c6 f8 ff ff       	call   801029d0 <lapicstartap>
8010310a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103110:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
80103116:	85 c0                	test   %eax,%eax
80103118:	74 f6                	je     80103110 <main+0x110>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010311a:	69 05 e0 50 11 80 bc 	imul   $0xbc,0x801150e0,%eax
80103121:	00 00 00 
80103124:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
8010312a:	05 00 4b 11 80       	add    $0x80114b00,%eax
8010312f:	39 c3                	cmp    %eax,%ebx
80103131:	72 8d                	jb     801030c0 <main+0xc0>
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103133:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
8010313a:	8e 
8010313b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103142:	e8 a9 f4 ff ff       	call   801025f0 <kinit2>
  userinit();      // first user process
80103147:	e8 f4 07 00 00       	call   80103940 <userinit>
  mpmain();        // finish this processor's setup
8010314c:	e8 4f fe ff ff       	call   80102fa0 <mpmain>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
80103151:	e8 7a 37 00 00       	call   801068d0 <timerinit>
80103156:	e9 2c ff ff ff       	jmp    80103087 <main+0x87>
8010315b:	66 90                	xchg   %ax,%ax
8010315d:	66 90                	xchg   %ax,%ax
8010315f:	90                   	nop

80103160 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103164:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010316a:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
8010316b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010316e:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103171:	39 de                	cmp    %ebx,%esi
80103173:	73 3c                	jae    801031b1 <mpsearch1+0x51>
80103175:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103178:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010317f:	00 
80103180:	c7 44 24 04 08 95 10 	movl   $0x80109508,0x4(%esp)
80103187:	80 
80103188:	89 34 24             	mov    %esi,(%esp)
8010318b:	e8 e0 24 00 00       	call   80105670 <memcmp>
80103190:	85 c0                	test   %eax,%eax
80103192:	75 16                	jne    801031aa <mpsearch1+0x4a>
80103194:	31 c9                	xor    %ecx,%ecx
80103196:	31 d2                	xor    %edx,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103198:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010319c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010319f:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801031a1:	83 fa 10             	cmp    $0x10,%edx
801031a4:	75 f2                	jne    80103198 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031a6:	84 c9                	test   %cl,%cl
801031a8:	74 10                	je     801031ba <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801031aa:	83 c6 10             	add    $0x10,%esi
801031ad:	39 f3                	cmp    %esi,%ebx
801031af:	77 c7                	ja     80103178 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
801031b1:	83 c4 10             	add    $0x10,%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801031b4:	31 c0                	xor    %eax,%eax
}
801031b6:	5b                   	pop    %ebx
801031b7:	5e                   	pop    %esi
801031b8:	5d                   	pop    %ebp
801031b9:	c3                   	ret    
801031ba:	83 c4 10             	add    $0x10,%esp
801031bd:	89 f0                	mov    %esi,%eax
801031bf:	5b                   	pop    %ebx
801031c0:	5e                   	pop    %esi
801031c1:	5d                   	pop    %ebp
801031c2:	c3                   	ret    
801031c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801031d0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	57                   	push   %edi
801031d4:	56                   	push   %esi
801031d5:	53                   	push   %ebx
801031d6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031d9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801031e0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801031e7:	c1 e0 08             	shl    $0x8,%eax
801031ea:	09 d0                	or     %edx,%eax
801031ec:	c1 e0 04             	shl    $0x4,%eax
801031ef:	85 c0                	test   %eax,%eax
801031f1:	75 1b                	jne    8010320e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801031f3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801031fa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103201:	c1 e0 08             	shl    $0x8,%eax
80103204:	09 d0                	or     %edx,%eax
80103206:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103209:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010320e:	ba 00 04 00 00       	mov    $0x400,%edx
80103213:	e8 48 ff ff ff       	call   80103160 <mpsearch1>
80103218:	85 c0                	test   %eax,%eax
8010321a:	89 c7                	mov    %eax,%edi
8010321c:	0f 84 4e 01 00 00    	je     80103370 <mpinit+0x1a0>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103222:	8b 77 04             	mov    0x4(%edi),%esi
80103225:	85 f6                	test   %esi,%esi
80103227:	0f 84 ce 00 00 00    	je     801032fb <mpinit+0x12b>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010322d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103233:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010323a:	00 
8010323b:	c7 44 24 04 0d 95 10 	movl   $0x8010950d,0x4(%esp)
80103242:	80 
80103243:	89 04 24             	mov    %eax,(%esp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103246:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103249:	e8 22 24 00 00       	call   80105670 <memcmp>
8010324e:	85 c0                	test   %eax,%eax
80103250:	0f 85 a5 00 00 00    	jne    801032fb <mpinit+0x12b>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103256:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010325d:	3c 04                	cmp    $0x4,%al
8010325f:	0f 85 29 01 00 00    	jne    8010338e <mpinit+0x1be>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103265:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010326c:	85 c0                	test   %eax,%eax
8010326e:	74 1d                	je     8010328d <mpinit+0xbd>
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
80103270:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103272:	31 d2                	xor    %edx,%edx
80103274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103278:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010327f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103280:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103283:	01 d9                	add    %ebx,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103285:	39 d0                	cmp    %edx,%eax
80103287:	7f ef                	jg     80103278 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103289:	84 c9                	test   %cl,%cl
8010328b:	75 6e                	jne    801032fb <mpinit+0x12b>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
8010328d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103290:	85 db                	test   %ebx,%ebx
80103292:	74 67                	je     801032fb <mpinit+0x12b>
    return;
  ismp = 1;
80103294:	c7 05 e4 4a 11 80 01 	movl   $0x1,0x80114ae4
8010329b:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
8010329e:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032a4:	a3 fc 49 11 80       	mov    %eax,0x801149fc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032a9:	0f b7 8e 04 00 00 80 	movzwl -0x7ffffffc(%esi),%ecx
801032b0:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801032b6:	01 d9                	add    %ebx,%ecx
801032b8:	39 c8                	cmp    %ecx,%eax
801032ba:	0f 83 90 00 00 00    	jae    80103350 <mpinit+0x180>
    switch(*p){
801032c0:	80 38 04             	cmpb   $0x4,(%eax)
801032c3:	77 7b                	ja     80103340 <mpinit+0x170>
801032c5:	0f b6 10             	movzbl (%eax),%edx
801032c8:	ff 24 95 14 95 10 80 	jmp    *-0x7fef6aec(,%edx,4)
801032cf:	90                   	nop
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032d0:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d3:	39 c1                	cmp    %eax,%ecx
801032d5:	77 e9                	ja     801032c0 <mpinit+0xf0>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
801032d7:	a1 e4 4a 11 80       	mov    0x80114ae4,%eax
801032dc:	85 c0                	test   %eax,%eax
801032de:	75 70                	jne    80103350 <mpinit+0x180>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801032e0:	c7 05 e0 50 11 80 01 	movl   $0x1,0x801150e0
801032e7:	00 00 00 
    lapic = 0;
801032ea:	c7 05 fc 49 11 80 00 	movl   $0x0,0x801149fc
801032f1:	00 00 00 
    ioapicid = 0;
801032f4:	c6 05 e0 4a 11 80 00 	movb   $0x0,0x80114ae0
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801032fb:	83 c4 1c             	add    $0x1c,%esp
801032fe:	5b                   	pop    %ebx
801032ff:	5e                   	pop    %esi
80103300:	5f                   	pop    %edi
80103301:	5d                   	pop    %ebp
80103302:	c3                   	ret    
80103303:	90                   	nop
80103304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103308:	8b 15 e0 50 11 80    	mov    0x801150e0,%edx
8010330e:	83 fa 07             	cmp    $0x7,%edx
80103311:	7f 17                	jg     8010332a <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103313:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
80103317:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
        ncpu++;
8010331d:	83 05 e0 50 11 80 01 	addl   $0x1,0x801150e0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103324:	88 9a 00 4b 11 80    	mov    %bl,-0x7feeb500(%edx)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010332a:	83 c0 14             	add    $0x14,%eax
      continue;
8010332d:	eb a4                	jmp    801032d3 <mpinit+0x103>
8010332f:	90                   	nop
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103330:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103334:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103337:	88 15 e0 4a 11 80    	mov    %dl,0x80114ae0
      p += sizeof(struct mpioapic);
      continue;
8010333d:	eb 94                	jmp    801032d3 <mpinit+0x103>
8010333f:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103340:	c7 05 e4 4a 11 80 00 	movl   $0x0,0x80114ae4
80103347:	00 00 00 
      break;
8010334a:	eb 87                	jmp    801032d3 <mpinit+0x103>
8010334c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    lapic = 0;
    ioapicid = 0;
    return;
  }

  if(mp->imcrp){
80103350:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
80103354:	74 a5                	je     801032fb <mpinit+0x12b>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103356:	ba 22 00 00 00       	mov    $0x22,%edx
8010335b:	b8 70 00 00 00       	mov    $0x70,%eax
80103360:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103361:	b2 23                	mov    $0x23,%dl
80103363:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103364:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103367:	ee                   	out    %al,(%dx)
  }
}
80103368:	83 c4 1c             	add    $0x1c,%esp
8010336b:	5b                   	pop    %ebx
8010336c:	5e                   	pop    %esi
8010336d:	5f                   	pop    %edi
8010336e:	5d                   	pop    %ebp
8010336f:	c3                   	ret    
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103370:	ba 00 00 01 00       	mov    $0x10000,%edx
80103375:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010337a:	e8 e1 fd ff ff       	call   80103160 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010337f:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103381:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103383:	0f 85 99 fe ff ff    	jne    80103222 <mpinit+0x52>
80103389:	e9 6d ff ff ff       	jmp    801032fb <mpinit+0x12b>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
8010338e:	3c 01                	cmp    $0x1,%al
80103390:	0f 84 cf fe ff ff    	je     80103265 <mpinit+0x95>
80103396:	e9 60 ff ff ff       	jmp    801032fb <mpinit+0x12b>
8010339b:	66 90                	xchg   %ax,%ax
8010339d:	66 90                	xchg   %ax,%ax
8010339f:	90                   	nop

801033a0 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
801033a0:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
801033a1:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
801033a6:	89 e5                	mov    %esp,%ebp
801033a8:	ba 21 00 00 00       	mov    $0x21,%edx
  picsetmask(irqmask & ~(1<<irq));
801033ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
801033b0:	d3 c0                	rol    %cl,%eax
801033b2:	66 23 05 00 c0 10 80 	and    0x8010c000,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
801033b9:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
801033bf:	ee                   	out    %al,(%dx)
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
801033c0:	66 c1 e8 08          	shr    $0x8,%ax
801033c4:	b2 a1                	mov    $0xa1,%dl
801033c6:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
801033c7:	5d                   	pop    %ebp
801033c8:	c3                   	ret    
801033c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801033d0 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
801033d0:	55                   	push   %ebp
801033d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033d6:	89 e5                	mov    %esp,%ebp
801033d8:	57                   	push   %edi
801033d9:	56                   	push   %esi
801033da:	53                   	push   %ebx
801033db:	bb 21 00 00 00       	mov    $0x21,%ebx
801033e0:	89 da                	mov    %ebx,%edx
801033e2:	ee                   	out    %al,(%dx)
801033e3:	b9 a1 00 00 00       	mov    $0xa1,%ecx
801033e8:	89 ca                	mov    %ecx,%edx
801033ea:	ee                   	out    %al,(%dx)
801033eb:	bf 11 00 00 00       	mov    $0x11,%edi
801033f0:	be 20 00 00 00       	mov    $0x20,%esi
801033f5:	89 f8                	mov    %edi,%eax
801033f7:	89 f2                	mov    %esi,%edx
801033f9:	ee                   	out    %al,(%dx)
801033fa:	b8 20 00 00 00       	mov    $0x20,%eax
801033ff:	89 da                	mov    %ebx,%edx
80103401:	ee                   	out    %al,(%dx)
80103402:	b8 04 00 00 00       	mov    $0x4,%eax
80103407:	ee                   	out    %al,(%dx)
80103408:	b8 03 00 00 00       	mov    $0x3,%eax
8010340d:	ee                   	out    %al,(%dx)
8010340e:	b3 a0                	mov    $0xa0,%bl
80103410:	89 f8                	mov    %edi,%eax
80103412:	89 da                	mov    %ebx,%edx
80103414:	ee                   	out    %al,(%dx)
80103415:	b8 28 00 00 00       	mov    $0x28,%eax
8010341a:	89 ca                	mov    %ecx,%edx
8010341c:	ee                   	out    %al,(%dx)
8010341d:	b8 02 00 00 00       	mov    $0x2,%eax
80103422:	ee                   	out    %al,(%dx)
80103423:	b8 03 00 00 00       	mov    $0x3,%eax
80103428:	ee                   	out    %al,(%dx)
80103429:	bf 68 00 00 00       	mov    $0x68,%edi
8010342e:	89 f2                	mov    %esi,%edx
80103430:	89 f8                	mov    %edi,%eax
80103432:	ee                   	out    %al,(%dx)
80103433:	b9 0a 00 00 00       	mov    $0xa,%ecx
80103438:	89 c8                	mov    %ecx,%eax
8010343a:	ee                   	out    %al,(%dx)
8010343b:	89 f8                	mov    %edi,%eax
8010343d:	89 da                	mov    %ebx,%edx
8010343f:	ee                   	out    %al,(%dx)
80103440:	89 c8                	mov    %ecx,%eax
80103442:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
80103443:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
8010344a:	66 83 f8 ff          	cmp    $0xffff,%ax
8010344e:	74 0a                	je     8010345a <picinit+0x8a>
80103450:	b2 21                	mov    $0x21,%dl
80103452:	ee                   	out    %al,(%dx)
static void
picsetmask(ushort mask)
{
  irqmask = mask;
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
80103453:	66 c1 e8 08          	shr    $0x8,%ax
80103457:	b2 a1                	mov    $0xa1,%dl
80103459:	ee                   	out    %al,(%dx)
  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    picsetmask(irqmask);
}
8010345a:	5b                   	pop    %ebx
8010345b:	5e                   	pop    %esi
8010345c:	5f                   	pop    %edi
8010345d:	5d                   	pop    %ebp
8010345e:	c3                   	ret    
8010345f:	90                   	nop

80103460 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	57                   	push   %edi
80103464:	56                   	push   %esi
80103465:	53                   	push   %ebx
80103466:	83 ec 1c             	sub    $0x1c,%esp
80103469:	8b 75 08             	mov    0x8(%ebp),%esi
8010346c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010346f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103475:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010347b:	e8 00 d9 ff ff       	call   80100d80 <filealloc>
80103480:	85 c0                	test   %eax,%eax
80103482:	89 06                	mov    %eax,(%esi)
80103484:	0f 84 a4 00 00 00    	je     8010352e <pipealloc+0xce>
8010348a:	e8 f1 d8 ff ff       	call   80100d80 <filealloc>
8010348f:	85 c0                	test   %eax,%eax
80103491:	89 03                	mov    %eax,(%ebx)
80103493:	0f 84 87 00 00 00    	je     80103520 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103499:	e8 a2 f1 ff ff       	call   80102640 <kalloc>
8010349e:	85 c0                	test   %eax,%eax
801034a0:	89 c7                	mov    %eax,%edi
801034a2:	74 7c                	je     80103520 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801034a4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034ab:	00 00 00 
  p->writeopen = 1;
801034ae:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034b5:	00 00 00 
  p->nwrite = 0;
801034b8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034bf:	00 00 00 
  p->nread = 0;
801034c2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034c9:	00 00 00 
  initlock(&p->lock, "pipe");
801034cc:	89 04 24             	mov    %eax,(%esp)
801034cf:	c7 44 24 04 28 95 10 	movl   $0x80109528,0x4(%esp)
801034d6:	80 
801034d7:	e8 34 1f 00 00       	call   80105410 <initlock>
  (*f0)->type = FD_PIPE;
801034dc:	8b 06                	mov    (%esi),%eax
801034de:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034e4:	8b 06                	mov    (%esi),%eax
801034e6:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034ea:	8b 06                	mov    (%esi),%eax
801034ec:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034f0:	8b 06                	mov    (%esi),%eax
801034f2:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034f5:	8b 03                	mov    (%ebx),%eax
801034f7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034fd:	8b 03                	mov    (%ebx),%eax
801034ff:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103503:	8b 03                	mov    (%ebx),%eax
80103505:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103509:	8b 03                	mov    (%ebx),%eax
  return 0;
8010350b:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
8010350d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103510:	83 c4 1c             	add    $0x1c,%esp
80103513:	89 d8                	mov    %ebx,%eax
80103515:	5b                   	pop    %ebx
80103516:	5e                   	pop    %esi
80103517:	5f                   	pop    %edi
80103518:	5d                   	pop    %ebp
80103519:	c3                   	ret    
8010351a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103520:	8b 06                	mov    (%esi),%eax
80103522:	85 c0                	test   %eax,%eax
80103524:	74 08                	je     8010352e <pipealloc+0xce>
    fileclose(*f0);
80103526:	89 04 24             	mov    %eax,(%esp)
80103529:	e8 12 d9 ff ff       	call   80100e40 <fileclose>
  if(*f1)
8010352e:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
80103530:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
80103535:	85 c0                	test   %eax,%eax
80103537:	74 d7                	je     80103510 <pipealloc+0xb0>
    fileclose(*f1);
80103539:	89 04 24             	mov    %eax,(%esp)
8010353c:	e8 ff d8 ff ff       	call   80100e40 <fileclose>
  return -1;
}
80103541:	83 c4 1c             	add    $0x1c,%esp
80103544:	89 d8                	mov    %ebx,%eax
80103546:	5b                   	pop    %ebx
80103547:	5e                   	pop    %esi
80103548:	5f                   	pop    %edi
80103549:	5d                   	pop    %ebp
8010354a:	c3                   	ret    
8010354b:	90                   	nop
8010354c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103550 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	56                   	push   %esi
80103554:	53                   	push   %ebx
80103555:	83 ec 10             	sub    $0x10,%esp
80103558:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010355b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010355e:	89 1c 24             	mov    %ebx,(%esp)
80103561:	e8 2a 1f 00 00       	call   80105490 <acquire>
  if(writable){
80103566:	85 f6                	test   %esi,%esi
80103568:	74 3e                	je     801035a8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010356a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103570:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103577:	00 00 00 
    wakeup(&p->nread);
8010357a:	89 04 24             	mov    %eax,(%esp)
8010357d:	e8 6e 08 00 00       	call   80103df0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103582:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103588:	85 d2                	test   %edx,%edx
8010358a:	75 0a                	jne    80103596 <pipeclose+0x46>
8010358c:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103592:	85 c0                	test   %eax,%eax
80103594:	74 32                	je     801035c8 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103596:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103599:	83 c4 10             	add    $0x10,%esp
8010359c:	5b                   	pop    %ebx
8010359d:	5e                   	pop    %esi
8010359e:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010359f:	e9 2c 20 00 00       	jmp    801055d0 <release>
801035a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801035a8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801035ae:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035b5:	00 00 00 
    wakeup(&p->nwrite);
801035b8:	89 04 24             	mov    %eax,(%esp)
801035bb:	e8 30 08 00 00       	call   80103df0 <wakeup>
801035c0:	eb c0                	jmp    80103582 <pipeclose+0x32>
801035c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801035c8:	89 1c 24             	mov    %ebx,(%esp)
801035cb:	e8 00 20 00 00       	call   801055d0 <release>
    kfree((char*)p);
801035d0:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
801035d3:	83 c4 10             	add    $0x10,%esp
801035d6:	5b                   	pop    %ebx
801035d7:	5e                   	pop    %esi
801035d8:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801035d9:	e9 b2 ee ff ff       	jmp    80102490 <kfree>
801035de:	66 90                	xchg   %ax,%ax

801035e0 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	57                   	push   %edi
801035e4:	56                   	push   %esi
801035e5:	53                   	push   %ebx
801035e6:	83 ec 1c             	sub    $0x1c,%esp
801035e9:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
801035ec:	89 3c 24             	mov    %edi,(%esp)
801035ef:	e8 9c 1e 00 00       	call   80105490 <acquire>
  for(i = 0; i < n; i++){
801035f4:	8b 45 10             	mov    0x10(%ebp),%eax
801035f7:	85 c0                	test   %eax,%eax
801035f9:	0f 8e c2 00 00 00    	jle    801036c1 <pipewrite+0xe1>
801035ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80103602:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
80103608:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
8010360e:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
80103614:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103617:	03 45 10             	add    0x10(%ebp),%eax
8010361a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010361d:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
80103623:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
80103629:	39 d1                	cmp    %edx,%ecx
8010362b:	0f 85 c4 00 00 00    	jne    801036f5 <pipewrite+0x115>
      if(p->readopen == 0 || proc->killed){
80103631:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
80103637:	85 d2                	test   %edx,%edx
80103639:	0f 84 a1 00 00 00    	je     801036e0 <pipewrite+0x100>
8010363f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103646:	8b 42 24             	mov    0x24(%edx),%eax
80103649:	85 c0                	test   %eax,%eax
8010364b:	74 22                	je     8010366f <pipewrite+0x8f>
8010364d:	e9 8e 00 00 00       	jmp    801036e0 <pipewrite+0x100>
80103652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103658:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
8010365e:	85 c0                	test   %eax,%eax
80103660:	74 7e                	je     801036e0 <pipewrite+0x100>
80103662:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103668:	8b 48 24             	mov    0x24(%eax),%ecx
8010366b:	85 c9                	test   %ecx,%ecx
8010366d:	75 71                	jne    801036e0 <pipewrite+0x100>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010366f:	89 34 24             	mov    %esi,(%esp)
80103672:	e8 79 07 00 00       	call   80103df0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103677:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010367b:	89 1c 24             	mov    %ebx,(%esp)
8010367e:	e8 bd 05 00 00       	call   80103c40 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103683:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
80103689:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
8010368f:	05 00 02 00 00       	add    $0x200,%eax
80103694:	39 c2                	cmp    %eax,%edx
80103696:	74 c0                	je     80103658 <pipewrite+0x78>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010369b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010369e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036a4:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
801036aa:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801036ae:	0f b6 00             	movzbl (%eax),%eax
801036b1:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801036b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801036b8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
801036bb:	0f 85 5c ff ff ff    	jne    8010361d <pipewrite+0x3d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036c1:	8d 97 34 02 00 00    	lea    0x234(%edi),%edx
801036c7:	89 14 24             	mov    %edx,(%esp)
801036ca:	e8 21 07 00 00       	call   80103df0 <wakeup>
  release(&p->lock);
801036cf:	89 3c 24             	mov    %edi,(%esp)
801036d2:	e8 f9 1e 00 00       	call   801055d0 <release>
  return n;
801036d7:	8b 45 10             	mov    0x10(%ebp),%eax
801036da:	eb 11                	jmp    801036ed <pipewrite+0x10d>
801036dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
801036e0:	89 3c 24             	mov    %edi,(%esp)
801036e3:	e8 e8 1e 00 00       	call   801055d0 <release>
        return -1;
801036e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036ed:	83 c4 1c             	add    $0x1c,%esp
801036f0:	5b                   	pop    %ebx
801036f1:	5e                   	pop    %esi
801036f2:	5f                   	pop    %edi
801036f3:	5d                   	pop    %ebp
801036f4:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036f5:	89 ca                	mov    %ecx,%edx
801036f7:	eb 9f                	jmp    80103698 <pipewrite+0xb8>
801036f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103700 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	57                   	push   %edi
80103704:	56                   	push   %esi
80103705:	53                   	push   %ebx
80103706:	83 ec 1c             	sub    $0x1c,%esp
80103709:	8b 75 08             	mov    0x8(%ebp),%esi
8010370c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010370f:	89 34 24             	mov    %esi,(%esp)
80103712:	e8 79 1d 00 00       	call   80105490 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103717:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010371d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103723:	75 5b                	jne    80103780 <piperead+0x80>
80103725:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010372b:	85 db                	test   %ebx,%ebx
8010372d:	74 51                	je     80103780 <piperead+0x80>
8010372f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103735:	eb 25                	jmp    8010375c <piperead+0x5c>
80103737:	90                   	nop
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103738:	89 74 24 04          	mov    %esi,0x4(%esp)
8010373c:	89 1c 24             	mov    %ebx,(%esp)
8010373f:	e8 fc 04 00 00       	call   80103c40 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103744:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010374a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103750:	75 2e                	jne    80103780 <piperead+0x80>
80103752:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103758:	85 d2                	test   %edx,%edx
8010375a:	74 24                	je     80103780 <piperead+0x80>
    if(proc->killed){
8010375c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103762:	8b 48 24             	mov    0x24(%eax),%ecx
80103765:	85 c9                	test   %ecx,%ecx
80103767:	74 cf                	je     80103738 <piperead+0x38>
      release(&p->lock);
80103769:	89 34 24             	mov    %esi,(%esp)
8010376c:	e8 5f 1e 00 00       	call   801055d0 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103771:	83 c4 1c             	add    $0x1c,%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
      return -1;
80103774:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103779:	5b                   	pop    %ebx
8010377a:	5e                   	pop    %esi
8010377b:	5f                   	pop    %edi
8010377c:	5d                   	pop    %ebp
8010377d:	c3                   	ret    
8010377e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103780:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103783:	31 db                	xor    %ebx,%ebx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103785:	85 d2                	test   %edx,%edx
80103787:	7f 2b                	jg     801037b4 <piperead+0xb4>
80103789:	eb 31                	jmp    801037bc <piperead+0xbc>
8010378b:	90                   	nop
8010378c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103790:	8d 48 01             	lea    0x1(%eax),%ecx
80103793:	25 ff 01 00 00       	and    $0x1ff,%eax
80103798:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010379e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801037a3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037a6:	83 c3 01             	add    $0x1,%ebx
801037a9:	3b 5d 10             	cmp    0x10(%ebp),%ebx
801037ac:	74 0e                	je     801037bc <piperead+0xbc>
    if(p->nread == p->nwrite)
801037ae:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037b4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037ba:	75 d4                	jne    80103790 <piperead+0x90>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037bc:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037c2:	89 04 24             	mov    %eax,(%esp)
801037c5:	e8 26 06 00 00       	call   80103df0 <wakeup>
  release(&p->lock);
801037ca:	89 34 24             	mov    %esi,(%esp)
801037cd:	e8 fe 1d 00 00       	call   801055d0 <release>
  return i;
}
801037d2:	83 c4 1c             	add    $0x1c,%esp
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
801037d5:	89 d8                	mov    %ebx,%eax
}
801037d7:	5b                   	pop    %ebx
801037d8:	5e                   	pop    %esi
801037d9:	5f                   	pop    %edi
801037da:	5d                   	pop    %ebp
801037db:	c3                   	ret    
801037dc:	66 90                	xchg   %ax,%ax
801037de:	66 90                	xchg   %ax,%ax

801037e0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
    static struct proc*
allocproc(void)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	53                   	push   %ebx
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037e4:	bb 54 51 11 80       	mov    $0x80115154,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
    static struct proc*
allocproc(void)
{
801037e9:	83 ec 14             	sub    $0x14,%esp
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);
801037ec:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
801037f3:	e8 98 1c 00 00       	call   80105490 <acquire>
801037f8:	eb 18                	jmp    80103812 <allocproc+0x32>
801037fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103800:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80103806:	81 fb 54 78 11 80    	cmp    $0x80117854,%ebx
8010380c:	0f 84 96 00 00 00    	je     801038a8 <allocproc+0xc8>
        if(p->state == UNUSED)
80103812:	8b 4b 0c             	mov    0xc(%ebx),%ecx
80103815:	85 c9                	test   %ecx,%ecx
80103817:	75 e7                	jne    80103800 <allocproc+0x20>
    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
    p->pid = nextpid++;
80103819:	a1 0c c0 10 80       	mov    0x8010c00c,%eax
    //ADDED
    p->tid = 0;
    p->isthread = 0;
    p->numOfThread = 0;

    release(&ptable.lock);
8010381e:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)

    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
80103825:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->pid = nextpid++;
    //ADDED
    p->tid = 0;
8010382c:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
80103833:	00 00 00 
    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
    p->pid = nextpid++;
80103836:	8d 50 01             	lea    0x1(%eax),%edx
80103839:	89 15 0c c0 10 80    	mov    %edx,0x8010c00c
    //ADDED
    p->tid = 0;
    p->isthread = 0;
    p->numOfThread = 0;
8010383f:	31 d2                	xor    %edx,%edx
    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
    p->pid = nextpid++;
80103841:	89 43 10             	mov    %eax,0x10(%ebx)
    //ADDED
    p->tid = 0;
    p->isthread = 0;
80103844:	31 c0                	xor    %eax,%eax
80103846:	66 89 83 8c 00 00 00 	mov    %ax,0x8c(%ebx)
    p->numOfThread = 0;
8010384d:	66 89 93 8e 00 00 00 	mov    %dx,0x8e(%ebx)

    release(&ptable.lock);
80103854:	e8 77 1d 00 00       	call   801055d0 <release>

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
80103859:	e8 e2 ed ff ff       	call   80102640 <kalloc>
8010385e:	85 c0                	test   %eax,%eax
80103860:	89 43 08             	mov    %eax,0x8(%ebx)
80103863:	74 57                	je     801038bc <allocproc+0xdc>
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
80103865:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint*)sp = (uint)trapret;

    sp -= sizeof *p->context;
8010386b:	05 9c 0f 00 00       	add    $0xf9c,%eax
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
80103870:	89 53 18             	mov    %edx,0x18(%ebx)
    p->tf = (struct trapframe*)sp;

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint*)sp = (uint)trapret;
80103873:	c7 40 14 1d 69 10 80 	movl   $0x8010691d,0x14(%eax)

    sp -= sizeof *p->context;
    p->context = (struct context*)sp;
    memset(p->context, 0, sizeof *p->context);
8010387a:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80103881:	00 
80103882:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103889:	00 
8010388a:	89 04 24             	mov    %eax,(%esp)
    // which returns to trapret.
    sp -= 4;
    *(uint*)sp = (uint)trapret;

    sp -= sizeof *p->context;
    p->context = (struct context*)sp;
8010388d:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103890:	e8 8b 1d 00 00       	call   80105620 <memset>
    p->context->eip = (uint)forkret;
80103895:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103898:	c7 40 10 d0 38 10 80 	movl   $0x801038d0,0x10(%eax)

    return p;
8010389f:	89 d8                	mov    %ebx,%eax
}
801038a1:	83 c4 14             	add    $0x14,%esp
801038a4:	5b                   	pop    %ebx
801038a5:	5d                   	pop    %ebp
801038a6:	c3                   	ret    
801038a7:	90                   	nop

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if(p->state == UNUSED)
            goto found;

    release(&ptable.lock);
801038a8:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
801038af:	e8 1c 1d 00 00       	call   801055d0 <release>
    p->context = (struct context*)sp;
    memset(p->context, 0, sizeof *p->context);
    p->context->eip = (uint)forkret;

    return p;
}
801038b4:	83 c4 14             	add    $0x14,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if(p->state == UNUSED)
            goto found;

    release(&ptable.lock);
    return 0;
801038b7:	31 c0                	xor    %eax,%eax
    p->context = (struct context*)sp;
    memset(p->context, 0, sizeof *p->context);
    p->context->eip = (uint)forkret;

    return p;
}
801038b9:	5b                   	pop    %ebx
801038ba:	5d                   	pop    %ebp
801038bb:	c3                   	ret    

    release(&ptable.lock);

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
        p->state = UNUSED;
801038bc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return 0;
801038c3:	eb dc                	jmp    801038a1 <allocproc+0xc1>
801038c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038d0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
    void
forkret(void)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	83 ec 18             	sub    $0x18,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
801038d6:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
801038dd:	e8 ee 1c 00 00       	call   801055d0 <release>

    if (first) {
801038e2:	a1 04 c0 10 80       	mov    0x8010c004,%eax
801038e7:	85 c0                	test   %eax,%eax
801038e9:	75 05                	jne    801038f0 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
801038eb:	c9                   	leave  
801038ec:	c3                   	ret    
801038ed:	8d 76 00             	lea    0x0(%esi),%esi
    if (first) {
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot
        // be run from main().
        first = 0;
        iinit(ROOTDEV);
801038f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

    if (first) {
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot
        // be run from main().
        first = 0;
801038f7:	c7 05 04 c0 10 80 00 	movl   $0x0,0x8010c004
801038fe:	00 00 00 
        iinit(ROOTDEV);
80103901:	e8 3a dc ff ff       	call   80101540 <iinit>
        initlog(ROOTDEV);
80103906:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010390d:	e8 7e f3 ff ff       	call   80102c90 <initlog>
    }

    // Return to "caller", actually trapret (see allocproc).
}
80103912:	c9                   	leave  
80103913:	c3                   	ret    
80103914:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010391a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103920 <pinit>:

static void wakeup1(void *chan);

    void
pinit(void)
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	83 ec 18             	sub    $0x18,%esp
    initlock(&ptable.lock, "ptable");
80103926:	c7 44 24 04 2d 95 10 	movl   $0x8010952d,0x4(%esp)
8010392d:	80 
8010392e:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80103935:	e8 d6 1a 00 00       	call   80105410 <initlock>
}
8010393a:	c9                   	leave  
8010393b:	c3                   	ret    
8010393c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103940 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
    void
userinit(void)
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	53                   	push   %ebx
80103944:	83 ec 14             	sub    $0x14,%esp
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    p = allocproc();
80103947:	e8 94 fe ff ff       	call   801037e0 <allocproc>
8010394c:	89 c3                	mov    %eax,%ebx

    initproc = p;
8010394e:	a3 bc c5 10 80       	mov    %eax,0x8010c5bc
    if((p->pgdir = setupkvm()) == 0)
80103953:	e8 c8 43 00 00       	call   80107d20 <setupkvm>
80103958:	85 c0                	test   %eax,%eax
8010395a:	89 43 04             	mov    %eax,0x4(%ebx)
8010395d:	0f 84 d4 00 00 00    	je     80103a37 <userinit+0xf7>
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103963:	89 04 24             	mov    %eax,(%esp)
80103966:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010396d:	00 
8010396e:	c7 44 24 04 60 c4 10 	movl   $0x8010c460,0x4(%esp)
80103975:	80 
80103976:	e8 35 45 00 00       	call   80107eb0 <inituvm>
    p->sz = PGSIZE;
8010397b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
80103981:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103988:	00 
80103989:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103990:	00 
80103991:	8b 43 18             	mov    0x18(%ebx),%eax
80103994:	89 04 24             	mov    %eax,(%esp)
80103997:	e8 84 1c 00 00       	call   80105620 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010399c:	8b 43 18             	mov    0x18(%ebx),%eax
8010399f:	ba 23 00 00 00       	mov    $0x23,%edx
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039a4:	b9 2b 00 00 00       	mov    $0x2b,%ecx
    if((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
    p->sz = PGSIZE;
    memset(p->tf, 0, sizeof(*p->tf));
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039a9:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039ad:	8b 43 18             	mov    0x18(%ebx),%eax
801039b0:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->tf->es = p->tf->ds;
801039b4:	8b 43 18             	mov    0x18(%ebx),%eax
801039b7:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039bb:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
801039bf:	8b 43 18             	mov    0x18(%ebx),%eax
801039c2:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039c6:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
801039ca:	8b 43 18             	mov    0x18(%ebx),%eax
801039cd:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
801039d4:	8b 43 18             	mov    0x18(%ebx),%eax
801039d7:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
801039de:	8b 43 18             	mov    0x18(%ebx),%eax
801039e1:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

    safestrcpy(p->name, "initcode", sizeof(p->name));
801039e8:	8d 43 6c             	lea    0x6c(%ebx),%eax
801039eb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801039f2:	00 
801039f3:	c7 44 24 04 4d 95 10 	movl   $0x8010954d,0x4(%esp)
801039fa:	80 
801039fb:	89 04 24             	mov    %eax,(%esp)
801039fe:	e8 fd 1d 00 00       	call   80105800 <safestrcpy>
    p->cwd = namei("/");
80103a03:	c7 04 24 56 95 10 80 	movl   $0x80109556,(%esp)
80103a0a:	e8 81 e6 ff ff       	call   80102090 <namei>
80103a0f:	89 43 68             	mov    %eax,0x68(%ebx)

    // this assignment to p->state lets other cores
    // run this process. the acquire forces the above
    // writes to be visible, and the lock is also needed
    // because the assignment might not be atomic.
    acquire(&ptable.lock);
80103a12:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80103a19:	e8 72 1a 00 00       	call   80105490 <acquire>

    p->state = RUNNABLE;
80103a1e:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

    release(&ptable.lock);
80103a25:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80103a2c:	e8 9f 1b 00 00       	call   801055d0 <release>
}
80103a31:	83 c4 14             	add    $0x14,%esp
80103a34:	5b                   	pop    %ebx
80103a35:	5d                   	pop    %ebp
80103a36:	c3                   	ret    

    p = allocproc();

    initproc = p;
    if((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
80103a37:	c7 04 24 34 95 10 80 	movl   $0x80109534,(%esp)
80103a3e:	e8 1d c9 ff ff       	call   80100360 <panic>
80103a43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a50 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
    int
growproc(int n)
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	53                   	push   %ebx
80103a54:	83 ec 14             	sub    $0x14,%esp
80103a57:	8b 5d 08             	mov    0x8(%ebp),%ebx
    uint sz;

    //ADDED
    acquire(&ptable.lock);
80103a5a:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80103a61:	e8 2a 1a 00 00       	call   80105490 <acquire>

    sz = proc->sz;
80103a66:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
    if(n > 0){
80103a6d:	83 fb 00             	cmp    $0x0,%ebx
    uint sz;

    //ADDED
    acquire(&ptable.lock);

    sz = proc->sz;
80103a70:	8b 02                	mov    (%edx),%eax
    if(n > 0){
80103a72:	7e 54                	jle    80103ac8 <growproc+0x78>
        if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80103a74:	01 c3                	add    %eax,%ebx
80103a76:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80103a7a:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a7e:	8b 42 04             	mov    0x4(%edx),%eax
80103a81:	89 04 24             	mov    %eax,(%esp)
80103a84:	e8 67 45 00 00       	call   80107ff0 <allocuvm>
80103a89:	85 c0                	test   %eax,%eax
80103a8b:	74 5b                	je     80103ae8 <growproc+0x98>
80103a8d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
    } else if(n < 0){
        if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
            return -1;
    }
    //ADDED
    if(proc->isthread == 1){
80103a94:	66 83 ba 8c 00 00 00 	cmpw   $0x1,0x8c(%edx)
80103a9b:	01 
80103a9c:	74 52                	je     80103af0 <growproc+0xa0>
        proc->parent->sz = sz;
    }
    proc->sz = sz;
80103a9e:	89 02                	mov    %eax,(%edx)
    release(&ptable.lock);
80103aa0:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80103aa7:	e8 24 1b 00 00       	call   801055d0 <release>

    switchuvm(proc);
80103aac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ab2:	89 04 24             	mov    %eax,(%esp)
80103ab5:	e8 26 43 00 00       	call   80107de0 <switchuvm>
    return 0;
80103aba:	31 c0                	xor    %eax,%eax
}
80103abc:	83 c4 14             	add    $0x14,%esp
80103abf:	5b                   	pop    %ebx
80103ac0:	5d                   	pop    %ebp
80103ac1:	c3                   	ret    
80103ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    sz = proc->sz;
    if(n > 0){
        if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
            return -1;
    } else if(n < 0){
80103ac8:	74 ca                	je     80103a94 <growproc+0x44>
        if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80103aca:	01 c3                	add    %eax,%ebx
80103acc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80103ad0:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ad4:	8b 42 04             	mov    0x4(%edx),%eax
80103ad7:	89 04 24             	mov    %eax,(%esp)
80103ada:	e8 01 46 00 00       	call   801080e0 <deallocuvm>
80103adf:	85 c0                	test   %eax,%eax
80103ae1:	75 aa                	jne    80103a8d <growproc+0x3d>
80103ae3:	90                   	nop
80103ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&ptable.lock);

    sz = proc->sz;
    if(n > 0){
        if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
            return -1;
80103ae8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103aed:	eb cd                	jmp    80103abc <growproc+0x6c>
80103aef:	90                   	nop
        if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
            return -1;
    }
    //ADDED
    if(proc->isthread == 1){
        proc->parent->sz = sz;
80103af0:	8b 52 14             	mov    0x14(%edx),%edx
80103af3:	89 02                	mov    %eax,(%edx)
80103af5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103afc:	eb a0                	jmp    80103a9e <growproc+0x4e>
80103afe:	66 90                	xchg   %ax,%ax

80103b00 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
    void
sched(void)
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	53                   	push   %ebx
80103b04:	83 ec 14             	sub    $0x14,%esp
    int intena;

    if(!holding(&ptable.lock))
80103b07:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80103b0e:	e8 1d 1a 00 00       	call   80105530 <holding>
80103b13:	85 c0                	test   %eax,%eax
80103b15:	74 4d                	je     80103b64 <sched+0x64>
        panic("sched ptable.lock");
    if(cpu->ncli != 1)
80103b17:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103b1d:	83 b8 ac 00 00 00 01 	cmpl   $0x1,0xac(%eax)
80103b24:	75 62                	jne    80103b88 <sched+0x88>
        panic("sched locks");
    if(proc->state == RUNNING)
80103b26:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103b2d:	83 7a 0c 04          	cmpl   $0x4,0xc(%edx)
80103b31:	74 49                	je     80103b7c <sched+0x7c>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b33:	9c                   	pushf  
80103b34:	59                   	pop    %ecx
        panic("sched running");
    if(readeflags()&FL_IF)
80103b35:	80 e5 02             	and    $0x2,%ch
80103b38:	75 36                	jne    80103b70 <sched+0x70>
        panic("sched interruptible");
    intena = cpu->intena;
80103b3a:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    swtch(&proc->context, cpu->scheduler);
80103b40:	83 c2 1c             	add    $0x1c,%edx
80103b43:	8b 40 04             	mov    0x4(%eax),%eax
80103b46:	89 14 24             	mov    %edx,(%esp)
80103b49:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b4d:	e8 09 1d 00 00       	call   8010585b <swtch>
    cpu->intena = intena;
80103b52:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103b58:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
80103b5e:	83 c4 14             	add    $0x14,%esp
80103b61:	5b                   	pop    %ebx
80103b62:	5d                   	pop    %ebp
80103b63:	c3                   	ret    
sched(void)
{
    int intena;

    if(!holding(&ptable.lock))
        panic("sched ptable.lock");
80103b64:	c7 04 24 58 95 10 80 	movl   $0x80109558,(%esp)
80103b6b:	e8 f0 c7 ff ff       	call   80100360 <panic>
    if(cpu->ncli != 1)
        panic("sched locks");
    if(proc->state == RUNNING)
        panic("sched running");
    if(readeflags()&FL_IF)
        panic("sched interruptible");
80103b70:	c7 04 24 84 95 10 80 	movl   $0x80109584,(%esp)
80103b77:	e8 e4 c7 ff ff       	call   80100360 <panic>
    if(!holding(&ptable.lock))
        panic("sched ptable.lock");
    if(cpu->ncli != 1)
        panic("sched locks");
    if(proc->state == RUNNING)
        panic("sched running");
80103b7c:	c7 04 24 76 95 10 80 	movl   $0x80109576,(%esp)
80103b83:	e8 d8 c7 ff ff       	call   80100360 <panic>
    int intena;

    if(!holding(&ptable.lock))
        panic("sched ptable.lock");
    if(cpu->ncli != 1)
        panic("sched locks");
80103b88:	c7 04 24 6a 95 10 80 	movl   $0x8010956a,(%esp)
80103b8f:	e8 cc c7 ff ff       	call   80100360 <panic>
80103b94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103ba0 <yield>:
}

// Give up the CPU for one scheduling round.
    void
yield(void)
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	83 ec 18             	sub    $0x18,%esp
    //cprintf("yield~~!~!~!~!\n");
    acquire(&ptable.lock);  //DOC: yieldlock
80103ba6:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80103bad:	e8 de 18 00 00       	call   80105490 <acquire>
    if(yieldbytimer == 0 && proc->stride == 0 && schedulerMode == 1){
80103bb2:	8b 15 e4 1f 11 80    	mov    0x80111fe4,%edx
80103bb8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103bbe:	85 d2                	test   %edx,%edx
80103bc0:	75 10                	jne    80103bd2 <yield+0x32>
80103bc2:	66 83 78 7e 00       	cmpw   $0x0,0x7e(%eax)
80103bc7:	75 09                	jne    80103bd2 <yield+0x32>
80103bc9:	83 3d f0 1f 11 80 01 	cmpl   $0x1,0x80111ff0
80103bd0:	74 26                	je     80103bf8 <yield+0x58>

        dequeue(&qOfM[proc->qPosi],proc);
        enqueue(&qOfM[proc->qPosi], proc);
    }
    proc->state = RUNNABLE;
80103bd2:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    yieldbytimer = 0;
80103bd9:	c7 05 e4 1f 11 80 00 	movl   $0x0,0x80111fe4
80103be0:	00 00 00 
    sched();
80103be3:	e8 18 ff ff ff       	call   80103b00 <sched>
    release(&ptable.lock);
80103be8:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80103bef:	e8 dc 19 00 00       	call   801055d0 <release>
}
80103bf4:	c9                   	leave  
80103bf5:	c3                   	ret    
80103bf6:	66 90                	xchg   %ax,%ax
{
    //cprintf("yield~~!~!~!~!\n");
    acquire(&ptable.lock);  //DOC: yieldlock
    if(yieldbytimer == 0 && proc->stride == 0 && schedulerMode == 1){

        dequeue(&qOfM[proc->qPosi],proc);
80103bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
80103bfc:	0f b7 40 7c          	movzwl 0x7c(%eax),%eax
80103c00:	69 c0 10 01 00 00    	imul   $0x110,%eax,%eax
80103c06:	05 00 20 11 80       	add    $0x80112000,%eax
80103c0b:	89 04 24             	mov    %eax,(%esp)
80103c0e:	e8 4d 4c 00 00       	call   80108860 <dequeue>
        enqueue(&qOfM[proc->qPosi], proc);
80103c13:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103c19:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c1d:	0f b7 40 7c          	movzwl 0x7c(%eax),%eax
80103c21:	69 c0 10 01 00 00    	imul   $0x110,%eax,%eax
80103c27:	05 00 20 11 80       	add    $0x80112000,%eax
80103c2c:	89 04 24             	mov    %eax,(%esp)
80103c2f:	e8 8c 4a 00 00       	call   801086c0 <enqueue>
80103c34:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103c3a:	eb 96                	jmp    80103bd2 <yield+0x32>
80103c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103c40 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
    void
sleep(void *chan, struct spinlock *lk)
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	56                   	push   %esi
80103c44:	53                   	push   %ebx
80103c45:	83 ec 10             	sub    $0x10,%esp
    if(proc == 0)
80103c48:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
    void
sleep(void *chan, struct spinlock *lk)
{
80103c4e:	8b 75 08             	mov    0x8(%ebp),%esi
80103c51:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if(proc == 0)
80103c54:	85 c0                	test   %eax,%eax
80103c56:	0f 84 8b 00 00 00    	je     80103ce7 <sleep+0xa7>
        panic("sleep");

    if(lk == 0)
80103c5c:	85 db                	test   %ebx,%ebx
80103c5e:	74 7b                	je     80103cdb <sleep+0x9b>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if(lk != &ptable.lock){  //DOC: sleeplock0
80103c60:	81 fb 20 51 11 80    	cmp    $0x80115120,%ebx
80103c66:	74 50                	je     80103cb8 <sleep+0x78>
        acquire(&ptable.lock);  //DOC: sleeplock1
80103c68:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80103c6f:	e8 1c 18 00 00       	call   80105490 <acquire>
        release(lk);
80103c74:	89 1c 24             	mov    %ebx,(%esp)
80103c77:	e8 54 19 00 00       	call   801055d0 <release>
    }

    // Go to sleep.
    proc->chan = chan;
80103c7c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103c82:	89 70 20             	mov    %esi,0x20(%eax)
    proc->state = SLEEPING;
80103c85:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

    //cprintf(" sleep in~~~~pid %d tid %d\n",proc->pid,proc->tid);
    sched();
80103c8c:	e8 6f fe ff ff       	call   80103b00 <sched>

    //cprintf(" sleep done ~~~~pid %d tid %d\n",proc->pid,proc->tid);
    // Tidy up.
    proc->chan = 0;
80103c91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103c97:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

    // Reacquire original lock.
    if(lk != &ptable.lock){  //DOC: sleeplock2
        release(&ptable.lock);
80103c9e:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80103ca5:	e8 26 19 00 00       	call   801055d0 <release>
        acquire(lk);
80103caa:	89 5d 08             	mov    %ebx,0x8(%ebp)
    }
}
80103cad:	83 c4 10             	add    $0x10,%esp
80103cb0:	5b                   	pop    %ebx
80103cb1:	5e                   	pop    %esi
80103cb2:	5d                   	pop    %ebp
    proc->chan = 0;

    // Reacquire original lock.
    if(lk != &ptable.lock){  //DOC: sleeplock2
        release(&ptable.lock);
        acquire(lk);
80103cb3:	e9 d8 17 00 00       	jmp    80105490 <acquire>
        acquire(&ptable.lock);  //DOC: sleeplock1
        release(lk);
    }

    // Go to sleep.
    proc->chan = chan;
80103cb8:	89 70 20             	mov    %esi,0x20(%eax)
    proc->state = SLEEPING;
80103cbb:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

    //cprintf(" sleep in~~~~pid %d tid %d\n",proc->pid,proc->tid);
    sched();
80103cc2:	e8 39 fe ff ff       	call   80103b00 <sched>

    //cprintf(" sleep done ~~~~pid %d tid %d\n",proc->pid,proc->tid);
    // Tidy up.
    proc->chan = 0;
80103cc7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ccd:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
    // Reacquire original lock.
    if(lk != &ptable.lock){  //DOC: sleeplock2
        release(&ptable.lock);
        acquire(lk);
    }
}
80103cd4:	83 c4 10             	add    $0x10,%esp
80103cd7:	5b                   	pop    %ebx
80103cd8:	5e                   	pop    %esi
80103cd9:	5d                   	pop    %ebp
80103cda:	c3                   	ret    
{
    if(proc == 0)
        panic("sleep");

    if(lk == 0)
        panic("sleep without lk");
80103cdb:	c7 04 24 9e 95 10 80 	movl   $0x8010959e,(%esp)
80103ce2:	e8 79 c6 ff ff       	call   80100360 <panic>
// Reacquires lock when awakened.
    void
sleep(void *chan, struct spinlock *lk)
{
    if(proc == 0)
        panic("sleep");
80103ce7:	c7 04 24 98 95 10 80 	movl   $0x80109598,(%esp)
80103cee:	e8 6d c6 ff ff       	call   80100360 <panic>
80103cf3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d00 <wait>:
}
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
    int
wait(void)
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	56                   	push   %esi
80103d04:	53                   	push   %ebx
80103d05:	83 ec 10             	sub    $0x10,%esp
    struct proc *p;
    int havekids, pid;
    //int retval = 0;

    acquire(&ptable.lock);
80103d08:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80103d0f:	e8 7c 17 00 00       	call   80105490 <acquire>
80103d14:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    for(;;){
        // Scan through table looking for exited children.
        havekids = 0;
80103d1a:	31 d2                	xor    %edx,%edx
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d1c:	bb 54 51 11 80       	mov    $0x80115154,%ebx
80103d21:	eb 13                	jmp    80103d36 <wait+0x36>
80103d23:	90                   	nop
80103d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d28:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80103d2e:	81 fb 54 78 11 80    	cmp    $0x80117854,%ebx
80103d34:	74 2a                	je     80103d60 <wait+0x60>
            if(p->parent != proc )
80103d36:	39 43 14             	cmp    %eax,0x14(%ebx)
80103d39:	75 ed                	jne    80103d28 <wait+0x28>
                continue;
            if(p->isthread == 1)
80103d3b:	66 83 bb 8c 00 00 00 	cmpw   $0x1,0x8c(%ebx)
80103d42:	01 
80103d43:	74 e3                	je     80103d28 <wait+0x28>
                continue;
            havekids = 1;
            if(p->state == ZOMBIE){
80103d45:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103d49:	74 32                	je     80103d7d <wait+0x7d>

    acquire(&ptable.lock);
    for(;;){
        // Scan through table looking for exited children.
        havekids = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d4b:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
            if(p->parent != proc )
                continue;
            if(p->isthread == 1)
                continue;
            havekids = 1;
80103d51:	ba 01 00 00 00       	mov    $0x1,%edx

    acquire(&ptable.lock);
    for(;;){
        // Scan through table looking for exited children.
        havekids = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d56:	81 fb 54 78 11 80    	cmp    $0x80117854,%ebx
80103d5c:	75 d8                	jne    80103d36 <wait+0x36>
80103d5e:	66 90                	xchg   %ax,%ax
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if(!havekids || proc->killed){
80103d60:	85 d2                	test   %edx,%edx
80103d62:	74 6e                	je     80103dd2 <wait+0xd2>
80103d64:	8b 50 24             	mov    0x24(%eax),%edx
80103d67:	85 d2                	test   %edx,%edx
80103d69:	75 67                	jne    80103dd2 <wait+0xd2>
            release(&ptable.lock);
            return -1;
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
80103d6b:	c7 44 24 04 20 51 11 	movl   $0x80115120,0x4(%esp)
80103d72:	80 
80103d73:	89 04 24             	mov    %eax,(%esp)
80103d76:	e8 c5 fe ff ff       	call   80103c40 <sleep>
    }
80103d7b:	eb 97                	jmp    80103d14 <wait+0x14>
                continue;
            havekids = 1;
            if(p->state == ZOMBIE){
                // Found one.
                pid = p->pid;
                kfree(p->kstack);
80103d7d:	8b 43 08             	mov    0x8(%ebx),%eax
            if(p->isthread == 1)
                continue;
            havekids = 1;
            if(p->state == ZOMBIE){
                // Found one.
                pid = p->pid;
80103d80:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
80103d83:	89 04 24             	mov    %eax,(%esp)
80103d86:	e8 05 e7 ff ff       	call   80102490 <kfree>
                p->kstack = 0;
                freevm(p->pgdir);
80103d8b:	8b 43 04             	mov    0x4(%ebx),%eax
            havekids = 1;
            if(p->state == ZOMBIE){
                // Found one.
                pid = p->pid;
                kfree(p->kstack);
                p->kstack = 0;
80103d8e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
80103d95:	89 04 24             	mov    %eax,(%esp)
80103d98:	e8 63 43 00 00       	call   80108100 <freevm>
                p->pid = 0;
                p->parent = 0;
                p->name[0] = 0;
                p->killed = 0;
                p->state = UNUSED;
                release(&ptable.lock);
80103d9d:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
                // Found one.
                pid = p->pid;
                kfree(p->kstack);
                p->kstack = 0;
                freevm(p->pgdir);
                p->pid = 0;
80103da4:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
80103dab:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
80103db2:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
80103db6:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
80103dbd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                release(&ptable.lock);
80103dc4:	e8 07 18 00 00       	call   801055d0 <release>
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
    }
}
80103dc9:	83 c4 10             	add    $0x10,%esp
                p->parent = 0;
                p->name[0] = 0;
                p->killed = 0;
                p->state = UNUSED;
                release(&ptable.lock);
                return pid;
80103dcc:	89 f0                	mov    %esi,%eax
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
    }
}
80103dce:	5b                   	pop    %ebx
80103dcf:	5e                   	pop    %esi
80103dd0:	5d                   	pop    %ebp
80103dd1:	c3                   	ret    
            }
        }

        // No point waiting if we don't have any children.
        if(!havekids || proc->killed){
            release(&ptable.lock);
80103dd2:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80103dd9:	e8 f2 17 00 00       	call   801055d0 <release>
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
    }
}
80103dde:	83 c4 10             	add    $0x10,%esp
        }

        // No point waiting if we don't have any children.
        if(!havekids || proc->killed){
            release(&ptable.lock);
            return -1;
80103de1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
    }
}
80103de6:	5b                   	pop    %ebx
80103de7:	5e                   	pop    %esi
80103de8:	5d                   	pop    %ebp
80103de9:	c3                   	ret    
80103dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103df0 <wakeup>:
}

// Wake up all processes sleeping on chan.
    void
wakeup(void *chan)
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	53                   	push   %ebx
80103df4:	83 ec 14             	sub    $0x14,%esp
80103df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
80103dfa:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80103e01:	e8 8a 16 00 00       	call   80105490 <acquire>
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e06:	b8 54 51 11 80       	mov    $0x80115154,%eax
80103e0b:	eb 0f                	jmp    80103e1c <wakeup+0x2c>
80103e0d:	8d 76 00             	lea    0x0(%esi),%esi
80103e10:	05 9c 00 00 00       	add    $0x9c,%eax
80103e15:	3d 54 78 11 80       	cmp    $0x80117854,%eax
80103e1a:	74 24                	je     80103e40 <wakeup+0x50>
        if(p->state == SLEEPING && p->chan == chan){
80103e1c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e20:	75 ee                	jne    80103e10 <wakeup+0x20>
80103e22:	3b 58 20             	cmp    0x20(%eax),%ebx
80103e25:	75 e9                	jne    80103e10 <wakeup+0x20>
            p->state = RUNNABLE;
80103e27:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e2e:	05 9c 00 00 00       	add    $0x9c,%eax
80103e33:	3d 54 78 11 80       	cmp    $0x80117854,%eax
80103e38:	75 e2                	jne    80103e1c <wakeup+0x2c>
80103e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    void
wakeup(void *chan)
{
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
80103e40:	c7 45 08 20 51 11 80 	movl   $0x80115120,0x8(%ebp)
}
80103e47:	83 c4 14             	add    $0x14,%esp
80103e4a:	5b                   	pop    %ebx
80103e4b:	5d                   	pop    %ebp
    void
wakeup(void *chan)
{
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
80103e4c:	e9 7f 17 00 00       	jmp    801055d0 <release>
80103e51:	eb 0d                	jmp    80103e60 <kill>
80103e53:	90                   	nop
80103e54:	90                   	nop
80103e55:	90                   	nop
80103e56:	90                   	nop
80103e57:	90                   	nop
80103e58:	90                   	nop
80103e59:	90                   	nop
80103e5a:	90                   	nop
80103e5b:	90                   	nop
80103e5c:	90                   	nop
80103e5d:	90                   	nop
80103e5e:	90                   	nop
80103e5f:	90                   	nop

80103e60 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
    int
kill(int pid)
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	53                   	push   %ebx
80103e64:	83 ec 14             	sub    $0x14,%esp
80103e67:	8b 5d 08             	mov    0x8(%ebp),%ebx

    struct proc *p;

    acquire(&ptable.lock);
80103e6a:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80103e71:	e8 1a 16 00 00       	call   80105490 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e76:	b8 54 51 11 80       	mov    $0x80115154,%eax
80103e7b:	eb 0f                	jmp    80103e8c <kill+0x2c>
80103e7d:	8d 76 00             	lea    0x0(%esi),%esi
80103e80:	05 9c 00 00 00       	add    $0x9c,%eax
80103e85:	3d 54 78 11 80       	cmp    $0x80117854,%eax
80103e8a:	74 3c                	je     80103ec8 <kill+0x68>
        if(p->pid == pid){
80103e8c:	39 58 10             	cmp    %ebx,0x10(%eax)
80103e8f:	75 ef                	jne    80103e80 <kill+0x20>
            p->killed = 1;
            // Wake process from sleep if necessary.
            if(p->state == SLEEPING)
80103e91:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
    struct proc *p;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->pid == pid){
            p->killed = 1;
80103e95:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            // Wake process from sleep if necessary.
            if(p->state == SLEEPING)
80103e9c:	74 1a                	je     80103eb8 <kill+0x58>
                p->state = RUNNABLE;
            release(&ptable.lock);
80103e9e:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80103ea5:	e8 26 17 00 00       	call   801055d0 <release>
            return 0;
        }
    }
    release(&ptable.lock);
    return -1;
}
80103eaa:	83 c4 14             	add    $0x14,%esp
            p->killed = 1;
            // Wake process from sleep if necessary.
            if(p->state == SLEEPING)
                p->state = RUNNABLE;
            release(&ptable.lock);
            return 0;
80103ead:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
80103eaf:	5b                   	pop    %ebx
80103eb0:	5d                   	pop    %ebp
80103eb1:	c3                   	ret    
80103eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->pid == pid){
            p->killed = 1;
            // Wake process from sleep if necessary.
            if(p->state == SLEEPING)
                p->state = RUNNABLE;
80103eb8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103ebf:	eb dd                	jmp    80103e9e <kill+0x3e>
80103ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
80103ec8:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80103ecf:	e8 fc 16 00 00       	call   801055d0 <release>
    return -1;
}
80103ed4:	83 c4 14             	add    $0x14,%esp
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
    return -1;
80103ed7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103edc:	5b                   	pop    %ebx
80103edd:	5d                   	pop    %ebp
80103ede:	c3                   	ret    
80103edf:	90                   	nop

80103ee0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
    void
procdump(void)
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	57                   	push   %edi
80103ee4:	56                   	push   %esi
80103ee5:	53                   	push   %ebx
80103ee6:	bb c0 51 11 80       	mov    $0x801151c0,%ebx
80103eeb:	83 ec 4c             	sub    $0x4c,%esp
80103eee:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103ef1:	eb 23                	jmp    80103f16 <procdump+0x36>
80103ef3:	90                   	nop
80103ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(p->state == SLEEPING){
            getcallerpcs((uint*)p->context->ebp+2, pc);
            for(i=0; i<10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80103ef8:	c7 04 24 06 95 10 80 	movl   $0x80109506,(%esp)
80103eff:	e8 4c c7 ff ff       	call   80100650 <cprintf>
80103f04:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f0a:	81 fb c0 78 11 80    	cmp    $0x801178c0,%ebx
80103f10:	0f 84 8a 00 00 00    	je     80103fa0 <procdump+0xc0>
        if(p->state == UNUSED)
80103f16:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103f19:	85 c0                	test   %eax,%eax
80103f1b:	74 e7                	je     80103f04 <procdump+0x24>
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f1d:	83 f8 05             	cmp    $0x5,%eax
            state = states[p->state];
        else
            state = "???";
80103f20:	ba af 95 10 80       	mov    $0x801095af,%edx
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state == UNUSED)
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f25:	77 11                	ja     80103f38 <procdump+0x58>
80103f27:	8b 14 85 6c 97 10 80 	mov    -0x7fef6894(,%eax,4),%edx
            state = states[p->state];
        else
            state = "???";
80103f2e:	b8 af 95 10 80       	mov    $0x801095af,%eax
80103f33:	85 d2                	test   %edx,%edx
80103f35:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
80103f38:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103f3b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103f3f:	89 54 24 08          	mov    %edx,0x8(%esp)
80103f43:	c7 04 24 b3 95 10 80 	movl   $0x801095b3,(%esp)
80103f4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f4e:	e8 fd c6 ff ff       	call   80100650 <cprintf>
        if(p->state == SLEEPING){
80103f53:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103f57:	75 9f                	jne    80103ef8 <procdump+0x18>
            getcallerpcs((uint*)p->context->ebp+2, pc);
80103f59:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103f5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f60:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103f63:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103f66:	8b 40 0c             	mov    0xc(%eax),%eax
80103f69:	83 c0 08             	add    $0x8,%eax
80103f6c:	89 04 24             	mov    %eax,(%esp)
80103f6f:	e8 bc 14 00 00       	call   80105430 <getcallerpcs>
80103f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            for(i=0; i<10 && pc[i] != 0; i++)
80103f78:	8b 17                	mov    (%edi),%edx
80103f7a:	85 d2                	test   %edx,%edx
80103f7c:	0f 84 76 ff ff ff    	je     80103ef8 <procdump+0x18>
                cprintf(" %p", pc[i]);
80103f82:	89 54 24 04          	mov    %edx,0x4(%esp)
80103f86:	83 c7 04             	add    $0x4,%edi
80103f89:	c7 04 24 29 90 10 80 	movl   $0x80109029,(%esp)
80103f90:	e8 bb c6 ff ff       	call   80100650 <cprintf>
        else
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        if(p->state == SLEEPING){
            getcallerpcs((uint*)p->context->ebp+2, pc);
            for(i=0; i<10 && pc[i] != 0; i++)
80103f95:	39 f7                	cmp    %esi,%edi
80103f97:	75 df                	jne    80103f78 <procdump+0x98>
80103f99:	e9 5a ff ff ff       	jmp    80103ef8 <procdump+0x18>
80103f9e:	66 90                	xchg   %ax,%ax
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
    }
}
80103fa0:	83 c4 4c             	add    $0x4c,%esp
80103fa3:	5b                   	pop    %ebx
80103fa4:	5e                   	pop    %esi
80103fa5:	5f                   	pop    %edi
80103fa6:	5d                   	pop    %ebp
80103fa7:	c3                   	ret    
80103fa8:	90                   	nop
80103fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103fb0 <findMinPassStride>:
//For ADDED : scheduler-----------------------------------------------

//ADDED : Decrease every process's pass value if overflow occurs
    void
findMinPassStride(void)
{
80103fb0:	55                   	push   %ebp
    struct proc* p;
    int overflowFlag = 0;

    minPass = MlfqPass;
    if(minPass >= 2147483647 - 20000){
80103fb1:	31 c9                	xor    %ecx,%ecx
//For ADDED : scheduler-----------------------------------------------

//ADDED : Decrease every process's pass value if overflow occurs
    void
findMinPassStride(void)
{
80103fb3:	89 e5                	mov    %esp,%ebp
    struct proc* p;
    int overflowFlag = 0;
80103fb5:	b8 54 51 11 80       	mov    $0x80115154,%eax
//For ADDED : scheduler-----------------------------------------------

//ADDED : Decrease every process's pass value if overflow occurs
    void
findMinPassStride(void)
{
80103fba:	57                   	push   %edi
        if(p->pass >= 2147483647 - 20000){
            /*
               cprintf("[Warning] stride pass overflow~~-    -   -   -   -   -   -   -   -   -   -   -\n");
               cprintf(" Let OS manage pass of processes~~-    -   -   -   -   -   -   -   -   -   -   -\n");
               */
            overflowFlag = 1;
80103fbb:	bf 01 00 00 00       	mov    $0x1,%edi
//For ADDED : scheduler-----------------------------------------------

//ADDED : Decrease every process's pass value if overflow occurs
    void
findMinPassStride(void)
{
80103fc0:	56                   	push   %esi
    struct proc* p;
    int overflowFlag = 0;

    minPass = MlfqPass;
80103fc1:	8b 35 38 23 11 80    	mov    0x80112338,%esi
//For ADDED : scheduler-----------------------------------------------

//ADDED : Decrease every process's pass value if overflow occurs
    void
findMinPassStride(void)
{
80103fc7:	53                   	push   %ebx
    struct proc* p;
    int overflowFlag = 0;

    minPass = MlfqPass;
    if(minPass >= 2147483647 - 20000){
80103fc8:	81 fe de b1 ff 7f    	cmp    $0x7fffb1de,%esi
//ADDED : Decrease every process's pass value if overflow occurs
    void
findMinPassStride(void)
{
    struct proc* p;
    int overflowFlag = 0;
80103fce:	89 f3                	mov    %esi,%ebx

    minPass = MlfqPass;
    if(minPass >= 2147483647 - 20000){
80103fd0:	0f 97 c1             	seta   %cl
80103fd3:	eb 0f                	jmp    80103fe4 <findMinPassStride+0x34>
80103fd5:	8d 76 00             	lea    0x0(%esi),%esi
        overflowFlag = 1;
    }

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fd8:	05 9c 00 00 00       	add    $0x9c,%eax
80103fdd:	3d 54 78 11 80       	cmp    $0x80117854,%eax
80103fe2:	74 34                	je     80104018 <findMinPassStride+0x68>
        if(p->state != RUNNABLE)
80103fe4:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103fe8:	75 ee                	jne    80103fd8 <findMinPassStride+0x28>
            continue;
        if(p->pass >= 2147483647 - 20000){
80103fea:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
            /*
               cprintf("[Warning] stride pass overflow~~-    -   -   -   -   -   -   -   -   -   -   -\n");
               cprintf(" Let OS manage pass of processes~~-    -   -   -   -   -   -   -   -   -   -   -\n");
               */
            overflowFlag = 1;
80103ff0:	81 fa df b1 ff 7f    	cmp    $0x7fffb1df,%edx
80103ff6:	0f 43 cf             	cmovae %edi,%ecx
        }
        if(p->stride >0 && p->pass <= minPass){
80103ff9:	66 83 78 7e 00       	cmpw   $0x0,0x7e(%eax)
80103ffe:	74 d8                	je     80103fd8 <findMinPassStride+0x28>
80104000:	39 d3                	cmp    %edx,%ebx
80104002:	0f 47 da             	cmova  %edx,%ebx
    minPass = MlfqPass;
    if(minPass >= 2147483647 - 20000){
        overflowFlag = 1;
    }

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104005:	05 9c 00 00 00       	add    $0x9c,%eax
8010400a:	3d 54 78 11 80       	cmp    $0x80117854,%eax
8010400f:	75 d3                	jne    80103fe4 <findMinPassStride+0x34>
80104011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if(p->stride >0 && p->pass <= minPass){
            minPass = p->pass;
        }
    }

    if(overflowFlag == 1){
80104018:	83 f9 01             	cmp    $0x1,%ecx
8010401b:	89 1d 00 51 11 80    	mov    %ebx,0x80115100
80104021:	74 05                	je     80104028 <findMinPassStride+0x78>
            }
        }
        MlfqPass = MlfqPass - minPass + 10;
        overflowFlag = 0;
    }
}    
80104023:	5b                   	pop    %ebx
80104024:	5e                   	pop    %esi
80104025:	5f                   	pop    %edi
80104026:	5d                   	pop    %ebp
80104027:	c3                   	ret    
    if(overflowFlag == 1){
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
            if(p->state != RUNNABLE)
                continue;
            if(p->pass > 0){
                p->pass = p->pass - minPass + 10;
80104028:	b1 0a                	mov    $0xa,%cl
        if(p->stride >0 && p->pass <= minPass){
            minPass = p->pass;
        }
    }

    if(overflowFlag == 1){
8010402a:	b8 54 51 11 80       	mov    $0x80115154,%eax
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
            if(p->state != RUNNABLE)
                continue;
            if(p->pass > 0){
                p->pass = p->pass - minPass + 10;
8010402f:	29 d9                	sub    %ebx,%ecx
80104031:	eb 11                	jmp    80104044 <findMinPassStride+0x94>
80104033:	90                   	nop
80104034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            minPass = p->pass;
        }
    }

    if(overflowFlag == 1){
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104038:	05 9c 00 00 00       	add    $0x9c,%eax
8010403d:	3d 54 78 11 80       	cmp    $0x80117854,%eax
80104042:	74 21                	je     80104065 <findMinPassStride+0xb5>
            if(p->state != RUNNABLE)
80104044:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104048:	75 ee                	jne    80104038 <findMinPassStride+0x88>
                continue;
            if(p->pass > 0){
8010404a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104050:	85 d2                	test   %edx,%edx
80104052:	74 e4                	je     80104038 <findMinPassStride+0x88>
                p->pass = p->pass - minPass + 10;
80104054:	01 ca                	add    %ecx,%edx
            minPass = p->pass;
        }
    }

    if(overflowFlag == 1){
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104056:	05 9c 00 00 00       	add    $0x9c,%eax
            if(p->state != RUNNABLE)
                continue;
            if(p->pass > 0){
                p->pass = p->pass - minPass + 10;
8010405b:	89 50 e8             	mov    %edx,-0x18(%eax)
            minPass = p->pass;
        }
    }

    if(overflowFlag == 1){
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010405e:	3d 54 78 11 80       	cmp    $0x80117854,%eax
80104063:	75 df                	jne    80104044 <findMinPassStride+0x94>
                continue;
            if(p->pass > 0){
                p->pass = p->pass - minPass + 10;
            }
        }
        MlfqPass = MlfqPass - minPass + 10;
80104065:	83 c6 0a             	add    $0xa,%esi
80104068:	29 de                	sub    %ebx,%esi
8010406a:	89 35 38 23 11 80    	mov    %esi,0x80112338
        overflowFlag = 0;
    }
}    
80104070:	5b                   	pop    %ebx
80104071:	5e                   	pop    %esi
80104072:	5f                   	pop    %edi
80104073:	5d                   	pop    %ebp
80104074:	c3                   	ret    
80104075:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104080 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
    void
scheduler(void)
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	57                   	push   %edi
80104084:	56                   	push   %esi
80104085:	53                   	push   %ebx
    initMlfq(&qOfM[2]);
    initMlfqGlobal();
    initStride();

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104086:	bb 54 51 11 80       	mov    $0x80115154,%ebx
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
    void
scheduler(void)
{
8010408b:	83 ec 1c             	sub    $0x1c,%esp
    struct Mlfq* nextQ;
    int checkQ = 0; //for check 'for looping queue' and nextQ
    curQ = 0;
    MlfqProcFlag = 0;

    initMlfq(&qOfM[0]);
8010408e:	c7 04 24 00 20 11 80 	movl   $0x80112000,(%esp)
{
    struct proc *p;
    int i = 0;
    struct Mlfq* nextQ;
    int checkQ = 0; //for check 'for looping queue' and nextQ
    curQ = 0;
80104095:	c7 05 e0 1f 11 80 00 	movl   $0x0,0x80111fe0
8010409c:	00 00 00 
    MlfqProcFlag = 0;
8010409f:	c7 05 ec 1f 11 80 00 	movl   $0x0,0x80111fec
801040a6:	00 00 00 

    initMlfq(&qOfM[0]);
801040a9:	e8 b2 44 00 00       	call   80108560 <initMlfq>
    initMlfq(&qOfM[1]);
801040ae:	c7 04 24 10 21 11 80 	movl   $0x80112110,(%esp)
801040b5:	e8 a6 44 00 00       	call   80108560 <initMlfq>
    initMlfq(&qOfM[2]);
801040ba:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
801040c1:	e8 9a 44 00 00       	call   80108560 <initMlfq>
    initMlfqGlobal();
801040c6:	e8 e5 44 00 00       	call   801085b0 <initMlfqGlobal>
    initStride();
801040cb:	e8 60 4d 00 00       	call   80108e30 <initStride>

    acquire(&ptable.lock);
801040d0:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
801040d7:	e8 b4 13 00 00       	call   80105490 <acquire>
801040dc:	eb 10                	jmp    801040ee <scheduler+0x6e>
801040de:	66 90                	xchg   %ax,%ax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040e0:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
801040e6:	81 fb 54 78 11 80    	cmp    $0x80117854,%ebx
801040ec:	74 25                	je     80104113 <scheduler+0x93>
        if(p->state == UNUSED)
801040ee:	8b 43 0c             	mov    0xc(%ebx),%eax
801040f1:	85 c0                	test   %eax,%eax
801040f3:	74 eb                	je     801040e0 <scheduler+0x60>
            continue;
        enqueue(&qOfM[0],p); 
801040f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    initMlfq(&qOfM[2]);
    initMlfqGlobal();
    initStride();

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040f9:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
        if(p->state == UNUSED)
            continue;
        enqueue(&qOfM[0],p); 
801040ff:	c7 04 24 00 20 11 80 	movl   $0x80112000,(%esp)
80104106:	e8 b5 45 00 00       	call   801086c0 <enqueue>
    initMlfq(&qOfM[2]);
    initMlfqGlobal();
    initStride();

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010410b:	81 fb 54 78 11 80    	cmp    $0x80117854,%ebx
80104111:	75 db                	jne    801040ee <scheduler+0x6e>
        if(p->state == UNUSED)
            continue;
        enqueue(&qOfM[0],p); 
    }   
    release(&ptable.lock);
80104113:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
//      via swtch back to the scheduler.
    void
scheduler(void)
{
    struct proc *p;
    int i = 0;
8010411a:	31 f6                	xor    %esi,%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state == UNUSED)
            continue;
        enqueue(&qOfM[0],p); 
    }   
    release(&ptable.lock);
8010411c:	e8 af 14 00 00       	call   801055d0 <release>
80104121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80104128:	fb                   	sti    
        sti();

        nextQ = &qOfM[curQ];
        schedulerMode = 0;

        checkRcount(&qOfM[0]);
80104129:	c7 04 24 00 20 11 80 	movl   $0x80112000,(%esp)
    for(;;){
        // Enable interrupts on this processor.
        sti();

        nextQ = &qOfM[curQ];
        schedulerMode = 0;
80104130:	c7 05 f0 1f 11 80 00 	movl   $0x0,0x80111ff0
80104137:	00 00 00 

        checkRcount(&qOfM[0]);
8010413a:	e8 c1 46 00 00       	call   80108800 <checkRcount>
        checkRcount(&qOfM[1]);
8010413f:	c7 04 24 10 21 11 80 	movl   $0x80112110,(%esp)
80104146:	e8 b5 46 00 00       	call   80108800 <checkRcount>
        checkRcount(&qOfM[2]);
8010414b:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80104152:	e8 a9 46 00 00       	call   80108800 <checkRcount>

        if(qOfM[0].rCount != 0){
80104157:	66 83 3d 08 21 11 80 	cmpw   $0x0,0x80112108
8010415e:	00 
8010415f:	0f 85 8b 01 00 00    	jne    801042f0 <scheduler+0x270>
            curQ = 0;
        }else if(qOfM[1].rCount != 0){
80104165:	66 83 3d 18 22 11 80 	cmpw   $0x0,0x80112218
8010416c:	00 
8010416d:	0f 84 b5 01 00 00    	je     80104328 <scheduler+0x2a8>
            curQ = 1;
80104173:	c7 05 e0 1f 11 80 01 	movl   $0x1,0x80111fe0
8010417a:	00 00 00 
8010417d:	bf 01 00 00 00       	mov    $0x1,%edi
        nextQ = &qOfM[curQ];



        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
80104182:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)

        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104189:	bb 54 51 11 80       	mov    $0x80115154,%ebx
        nextQ = &qOfM[curQ];



        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
8010418e:	e8 fd 12 00 00       	call   80105490 <acquire>
80104193:	eb 15                	jmp    801041aa <scheduler+0x12a>
80104195:	8d 76 00             	lea    0x0(%esi),%esi

        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104198:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
8010419e:	81 fb 54 78 11 80    	cmp    $0x80117854,%ebx
801041a4:	0f 84 96 00 00 00    	je     80104240 <scheduler+0x1c0>
            findMinPassStride();
801041aa:	e8 01 fe ff ff       	call   80103fb0 <findMinPassStride>
            if(minPass == MlfqPass){
801041af:	a1 00 51 11 80       	mov    0x80115100,%eax
801041b4:	3b 05 38 23 11 80    	cmp    0x80112338,%eax
801041ba:	0f 84 a0 00 00 00    	je     80104260 <scheduler+0x1e0>
                schedulerMode = 1;
                break;
            }
            if(p->pass != minPass || p->stride == 0)
801041c0:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
801041c6:	75 d0                	jne    80104198 <scheduler+0x118>
801041c8:	0f b7 53 7e          	movzwl 0x7e(%ebx),%edx
801041cc:	66 85 d2             	test   %dx,%dx
801041cf:	74 c7                	je     80104198 <scheduler+0x118>
                continue;
            if(p->state != RUNNABLE )
801041d1:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801041d5:	75 c1                	jne    80104198 <scheduler+0x118>
                continue;

            p->pass += p->stride;
801041d7:	01 d0                	add    %edx,%eax
801041d9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)

            schedulerMode =0;

            proc = p;
            switchuvm(p);
801041df:	89 1c 24             	mov    %ebx,(%esp)

            p->pass += p->stride;

            schedulerMode =0;

            proc = p;
801041e2:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4


        // Loop over process table looking for process to run.
        acquire(&ptable.lock);

        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041e9:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
            if(p->state != RUNNABLE )
                continue;

            p->pass += p->stride;

            schedulerMode =0;
801041ef:	c7 05 f0 1f 11 80 00 	movl   $0x0,0x80111ff0
801041f6:	00 00 00 

            proc = p;
            switchuvm(p);
801041f9:	e8 e2 3b 00 00       	call   80107de0 <switchuvm>
            p->state = RUNNING;
            swtch(&cpu->scheduler, p->context);
801041fe:	8b 43 80             	mov    -0x80(%ebx),%eax

            schedulerMode =0;

            proc = p;
            switchuvm(p);
            p->state = RUNNING;
80104201:	c7 83 70 ff ff ff 04 	movl   $0x4,-0x90(%ebx)
80104208:	00 00 00 
            swtch(&cpu->scheduler, p->context);
8010420b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010420f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104215:	83 c0 04             	add    $0x4,%eax
80104218:	89 04 24             	mov    %eax,(%esp)
8010421b:	e8 3b 16 00 00       	call   8010585b <swtch>
            switchkvm();
80104220:	e8 9b 3b 00 00       	call   80107dc0 <switchkvm>


        // Loop over process table looking for process to run.
        acquire(&ptable.lock);

        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104225:	81 fb 54 78 11 80    	cmp    $0x80117854,%ebx
            switchuvm(p);
            p->state = RUNNING;
            swtch(&cpu->scheduler, p->context);
            switchkvm();

            proc = 0;
8010422b:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104232:	00 00 00 00 


        // Loop over process table looking for process to run.
        acquire(&ptable.lock);

        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104236:	0f 85 6e ff ff ff    	jne    801041aa <scheduler+0x12a>
8010423c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            switchkvm();

            proc = 0;
        }

        if(schedulerMode == 1)
80104240:	83 3d f0 1f 11 80 01 	cmpl   $0x1,0x80111ff0
80104247:	74 21                	je     8010426a <scheduler+0x1ea>
                proc = 0;
            }

            MlfqPass += MlfqStride;
        }
        release(&ptable.lock);
80104249:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80104250:	e8 7b 13 00 00       	call   801055d0 <release>
    }
80104255:	e9 ce fe ff ff       	jmp    80104128 <scheduler+0xa8>
8010425a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        acquire(&ptable.lock);

        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
            findMinPassStride();
            if(minPass == MlfqPass){
                schedulerMode = 1;
80104260:	c7 05 f0 1f 11 80 01 	movl   $0x1,0x80111ff0
80104267:	00 00 00 
            curQ = 1;
        }else if(qOfM[2].rCount != 0){
            curQ = 2;
        }else curQ =0;
        checkQ = curQ;
        nextQ = &qOfM[curQ];
8010426a:	69 df 10 01 00 00    	imul   $0x110,%edi,%ebx
80104270:	81 c3 00 20 11 80    	add    $0x80112000,%ebx
            proc = 0;
        }

        if(schedulerMode == 1)
        {
            for(p = peekMlfq(nextQ); p; p = idxPeekMlfq(nextQ,i)){
80104276:	89 1c 24             	mov    %ebx,(%esp)
80104279:	e8 32 45 00 00       	call   801087b0 <peekMlfq>
8010427e:	85 c0                	test   %eax,%eax
80104280:	75 40                	jne    801042c2 <scheduler+0x242>
80104282:	eb 58                	jmp    801042dc <scheduler+0x25c>
80104284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

                if(qOfM[0].rCount != 0){
                    curQ = 0;
                }else if(qOfM[1].rCount != 0){
80104288:	66 83 3d 18 22 11 80 	cmpw   $0x0,0x80112218
8010428f:	00 
80104290:	74 76                	je     80104308 <scheduler+0x288>
                    curQ = 1;
80104292:	c7 05 e0 1f 11 80 01 	movl   $0x1,0x80111fe0
80104299:	00 00 00 
8010429c:	ba 01 00 00 00       	mov    $0x1,%edx
                }else if(qOfM[2].rCount != 0){
                    curQ = 2;
                }else curQ =0;
                if(checkQ != curQ) break;
801042a1:	39 d7                	cmp    %edx,%edi
801042a3:	75 37                	jne    801042dc <scheduler+0x25c>


                if(p->state != RUNNABLE){
801042a5:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801042a9:	0f 84 99 00 00 00    	je     80104348 <scheduler+0x2c8>
                    i++;;
801042af:	83 c6 01             	add    $0x1,%esi
            proc = 0;
        }

        if(schedulerMode == 1)
        {
            for(p = peekMlfq(nextQ); p; p = idxPeekMlfq(nextQ,i)){
801042b2:	89 74 24 04          	mov    %esi,0x4(%esp)
801042b6:	89 1c 24             	mov    %ebx,(%esp)
801042b9:	e8 12 45 00 00       	call   801087d0 <idxPeekMlfq>
801042be:	85 c0                	test   %eax,%eax
801042c0:	74 1a                	je     801042dc <scheduler+0x25c>

                if(qOfM[0].rCount != 0){
801042c2:	66 83 3d 08 21 11 80 	cmpw   $0x0,0x80112108
801042c9:	00 
801042ca:	74 bc                	je     80104288 <scheduler+0x208>
801042cc:	31 d2                	xor    %edx,%edx
                }else if(qOfM[1].rCount != 0){
                    curQ = 1;
                }else if(qOfM[2].rCount != 0){
                    curQ = 2;
                }else curQ =0;
                if(checkQ != curQ) break;
801042ce:	39 d7                	cmp    %edx,%edi
        if(schedulerMode == 1)
        {
            for(p = peekMlfq(nextQ); p; p = idxPeekMlfq(nextQ,i)){

                if(qOfM[0].rCount != 0){
                    curQ = 0;
801042d0:	c7 05 e0 1f 11 80 00 	movl   $0x0,0x80111fe0
801042d7:	00 00 00 
                }else if(qOfM[1].rCount != 0){
                    curQ = 1;
                }else if(qOfM[2].rCount != 0){
                    curQ = 2;
                }else curQ =0;
                if(checkQ != curQ) break;
801042da:	74 c9                	je     801042a5 <scheduler+0x225>
                switchkvm();

                proc = 0;
            }

            MlfqPass += MlfqStride;
801042dc:	0f b7 05 e8 1f 11 80 	movzwl 0x80111fe8,%eax
801042e3:	01 05 38 23 11 80    	add    %eax,0x80112338
801042e9:	e9 5b ff ff ff       	jmp    80104249 <scheduler+0x1c9>
801042ee:	66 90                	xchg   %ax,%ax
        checkRcount(&qOfM[0]);
        checkRcount(&qOfM[1]);
        checkRcount(&qOfM[2]);

        if(qOfM[0].rCount != 0){
            curQ = 0;
801042f0:	c7 05 e0 1f 11 80 00 	movl   $0x0,0x80111fe0
801042f7:	00 00 00 
801042fa:	31 ff                	xor    %edi,%edi
801042fc:	e9 81 fe ff ff       	jmp    80104182 <scheduler+0x102>
80104301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

                if(qOfM[0].rCount != 0){
                    curQ = 0;
                }else if(qOfM[1].rCount != 0){
                    curQ = 1;
                }else if(qOfM[2].rCount != 0){
80104308:	66 83 3d 28 23 11 80 	cmpw   $0x0,0x80112328
8010430f:	00 
80104310:	74 ba                	je     801042cc <scheduler+0x24c>
                    curQ = 2;
80104312:	c7 05 e0 1f 11 80 02 	movl   $0x2,0x80111fe0
80104319:	00 00 00 
8010431c:	ba 02 00 00 00       	mov    $0x2,%edx
80104321:	e9 7b ff ff ff       	jmp    801042a1 <scheduler+0x221>
80104326:	66 90                	xchg   %ax,%ax

        if(qOfM[0].rCount != 0){
            curQ = 0;
        }else if(qOfM[1].rCount != 0){
            curQ = 1;
        }else if(qOfM[2].rCount != 0){
80104328:	66 83 3d 28 23 11 80 	cmpw   $0x0,0x80112328
8010432f:	00 
80104330:	74 be                	je     801042f0 <scheduler+0x270>
            curQ = 2;
80104332:	c7 05 e0 1f 11 80 02 	movl   $0x2,0x80111fe0
80104339:	00 00 00 
8010433c:	bf 02 00 00 00       	mov    $0x2,%edi
80104341:	e9 3c fe ff ff       	jmp    80104182 <scheduler+0x102>
80104346:	66 90                	xchg   %ax,%ax


                i=0;

                proc = p;
                switchuvm(p);
80104348:	89 04 24             	mov    %eax,(%esp)
                    i++;;
                    continue;
                }


                i=0;
8010434b:	31 f6                	xor    %esi,%esi

                proc = p;
8010434d:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
                switchuvm(p);
80104353:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104356:	e8 85 3a 00 00       	call   80107de0 <switchuvm>
                p->state = RUNNING;
8010435b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010435e:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
                swtch(&cpu->scheduler, p->context);
80104365:	8b 40 1c             	mov    0x1c(%eax),%eax
80104368:	89 44 24 04          	mov    %eax,0x4(%esp)
8010436c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104372:	83 c0 04             	add    $0x4,%eax
80104375:	89 04 24             	mov    %eax,(%esp)
80104378:	e8 de 14 00 00       	call   8010585b <swtch>
                switchkvm();
8010437d:	e8 3e 3a 00 00       	call   80107dc0 <switchkvm>

                proc = 0;
80104382:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104389:	00 00 00 00 
8010438d:	e9 20 ff ff ff       	jmp    801042b2 <scheduler+0x232>
80104392:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043a0 <share_stride_in_proc.part.1>:

    return pid;
}

void
share_stride_in_proc(struct proc* parent){
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	56                   	push   %esi
801043a4:	53                   	push   %ebx
    ushort each_stride;

    if(parent->stride == 0) return ;

    real_stride = parent->pstride;
    each_stride = real_stride*(parent->numOfThread+1);
801043a5:	0f b7 b0 8e 00 00 00 	movzwl 0x8e(%eax),%esi

    return pid;
}

void
share_stride_in_proc(struct proc* parent){
801043ac:	89 c3                	mov    %eax,%ebx
    ushort each_stride;

    if(parent->stride == 0) return ;

    real_stride = parent->pstride;
    each_stride = real_stride*(parent->numOfThread+1);
801043ae:	83 c6 01             	add    $0x1,%esi
801043b1:	66 0f af b0 80 00 00 	imul   0x80(%eax),%si
801043b8:	00 

        findMinPassStride();
801043b9:	e8 f2 fb ff ff       	call   80103fb0 <findMinPassStride>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->parent != parent || p->isthread != 1 ){
            continue;
        }
        p->stride = each_stride;
        p->pass = minPass;
801043be:	a1 00 51 11 80       	mov    0x80115100,%eax
    real_stride = parent->pstride;
    each_stride = real_stride*(parent->numOfThread+1);

        findMinPassStride();

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043c3:	ba 54 51 11 80       	mov    $0x80115154,%edx
801043c8:	eb 14                	jmp    801043de <share_stride_in_proc.part.1+0x3e>
801043ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043d0:	81 c2 9c 00 00 00    	add    $0x9c,%edx
801043d6:	81 fa 54 78 11 80    	cmp    $0x80117854,%edx
801043dc:	74 2a                	je     80104408 <share_stride_in_proc.part.1+0x68>
        if(p->parent != parent || p->isthread != 1 ){
801043de:	3b 5a 14             	cmp    0x14(%edx),%ebx
801043e1:	75 ed                	jne    801043d0 <share_stride_in_proc.part.1+0x30>
801043e3:	66 83 ba 8c 00 00 00 	cmpw   $0x1,0x8c(%edx)
801043ea:	01 
801043eb:	75 e3                	jne    801043d0 <share_stride_in_proc.part.1+0x30>
            continue;
        }
        p->stride = each_stride;
801043ed:	66 89 72 7e          	mov    %si,0x7e(%edx)
    real_stride = parent->pstride;
    each_stride = real_stride*(parent->numOfThread+1);

        findMinPassStride();

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043f1:	81 c2 9c 00 00 00    	add    $0x9c,%edx
        if(p->parent != parent || p->isthread != 1 ){
            continue;
        }
        p->stride = each_stride;
        p->pass = minPass;
801043f7:	89 42 e8             	mov    %eax,-0x18(%edx)
    real_stride = parent->pstride;
    each_stride = real_stride*(parent->numOfThread+1);

        findMinPassStride();

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043fa:	81 fa 54 78 11 80    	cmp    $0x80117854,%edx
80104400:	75 dc                	jne    801043de <share_stride_in_proc.part.1+0x3e>
80104402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        }
        p->stride = each_stride;
        p->pass = minPass;

    }
    parent->stride = each_stride;
80104408:	66 89 73 7e          	mov    %si,0x7e(%ebx)
}
8010440c:	5b                   	pop    %ebx
8010440d:	5e                   	pop    %esi
8010440e:	5d                   	pop    %ebp
8010440f:	c3                   	ret    

80104410 <printPtable>:
}    

///for debugging
    void
printPtable(void)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	53                   	push   %ebx
80104414:	bb c0 51 11 80       	mov    $0x801151c0,%ebx
80104419:	83 ec 34             	sub    $0x34,%esp
    struct proc* p;

    cprintf("hello~~~~~~\n");
8010441c:	c7 04 24 bc 95 10 80 	movl   $0x801095bc,(%esp)
80104423:	e8 28 c2 ff ff       	call   80100650 <cprintf>
    cprintf(" Mlfq:: / stride %d / pass %d\n",MlfqStride, MlfqPass);
80104428:	a1 38 23 11 80       	mov    0x80112338,%eax
8010442d:	c7 04 24 64 96 10 80 	movl   $0x80109664,(%esp)
80104434:	89 44 24 08          	mov    %eax,0x8(%esp)
80104438:	0f b7 05 e8 1f 11 80 	movzwl 0x80111fe8,%eax
8010443f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104443:	e8 08 c2 ff ff       	call   80100650 <cprintf>
80104448:	eb 14                	jmp    8010445e <printPtable+0x4e>
8010444a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104450:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104456:	81 fb c0 78 11 80    	cmp    $0x801178c0,%ebx
8010445c:	74 7d                	je     801044db <printPtable+0xcb>
        if(p->pid != 0)
8010445e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80104461:	85 c0                	test   %eax,%eax
80104463:	74 eb                	je     80104450 <printPtable+0x40>
            cprintf(" pid %d / tid %d/ ppid %d/ ptid %d/ name %s /state %d / cT %d / stride %d / p-s %d/ pass %d / n-o-t %d\n",\
80104465:	0f b7 4b 22          	movzwl 0x22(%ebx),%ecx
                    p->pid,p->tid, p->parent->pid, p->parent->tid, p->name, p->state,p->consumedTime, p->stride, p->pstride, p->pass, p->numOfThread);
80104469:	8b 53 a8             	mov    -0x58(%ebx),%edx

    cprintf("hello~~~~~~\n");
    cprintf(" Mlfq:: / stride %d / pass %d\n",MlfqStride, MlfqPass);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->pid != 0)
            cprintf(" pid %d / tid %d/ ppid %d/ ptid %d/ name %s /state %d / cT %d / stride %d / p-s %d/ pass %d / n-o-t %d\n",\
8010446c:	89 5c 24 14          	mov    %ebx,0x14(%esp)
80104470:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80104476:	89 4c 24 2c          	mov    %ecx,0x2c(%esp)
8010447a:	8b 8b 7c ff ff ff    	mov    -0x84(%ebx),%ecx
80104480:	89 4c 24 28          	mov    %ecx,0x28(%esp)
80104484:	0f b7 8b 78 ff ff ff 	movzwl -0x88(%ebx),%ecx
8010448b:	89 4c 24 24          	mov    %ecx,0x24(%esp)
8010448f:	0f b7 8b 76 ff ff ff 	movzwl -0x8a(%ebx),%ecx
80104496:	89 4c 24 20          	mov    %ecx,0x20(%esp)
8010449a:	8b 4b 80             	mov    -0x80(%ebx),%ecx
8010449d:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
801044a1:	8b 8b 04 ff ff ff    	mov    -0xfc(%ebx),%ecx
801044a7:	89 4c 24 18          	mov    %ecx,0x18(%esp)
801044ab:	8b 8a 98 00 00 00    	mov    0x98(%edx),%ecx
801044b1:	89 4c 24 10          	mov    %ecx,0x10(%esp)
801044b5:	8b 52 10             	mov    0x10(%edx),%edx
801044b8:	89 44 24 04          	mov    %eax,0x4(%esp)
801044bc:	c7 04 24 84 96 10 80 	movl   $0x80109684,(%esp)
801044c3:	89 54 24 0c          	mov    %edx,0xc(%esp)
801044c7:	8b 53 90             	mov    -0x70(%ebx),%edx
801044ca:	89 54 24 08          	mov    %edx,0x8(%esp)
801044ce:	e8 7d c1 ff ff       	call   80100650 <cprintf>
{
    struct proc* p;

    cprintf("hello~~~~~~\n");
    cprintf(" Mlfq:: / stride %d / pass %d\n",MlfqStride, MlfqPass);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044d3:	81 fb c0 78 11 80    	cmp    $0x801178c0,%ebx
801044d9:	75 83                	jne    8010445e <printPtable+0x4e>
        if(p->pid != 0)
            cprintf(" pid %d / tid %d/ ppid %d/ ptid %d/ name %s /state %d / cT %d / stride %d / p-s %d/ pass %d / n-o-t %d\n",\
                    p->pid,p->tid, p->parent->pid, p->parent->tid, p->name, p->state,p->consumedTime, p->stride, p->pstride, p->pass, p->numOfThread);

    }
}
801044db:	83 c4 34             	add    $0x34,%esp
801044de:	5b                   	pop    %ebx
801044df:	5d                   	pop    %ebp
801044e0:	c3                   	ret    
801044e1:	eb 0d                	jmp    801044f0 <thread_create>
801044e3:	90                   	nop
801044e4:	90                   	nop
801044e5:	90                   	nop
801044e6:	90                   	nop
801044e7:	90                   	nop
801044e8:	90                   	nop
801044e9:	90                   	nop
801044ea:	90                   	nop
801044eb:	90                   	nop
801044ec:	90                   	nop
801044ed:	90                   	nop
801044ee:	90                   	nop
801044ef:	90                   	nop

801044f0 <thread_create>:
    return p;
}
//For ADDED : thread ----------------------------------------
//If isthread == 1, then proc is treated as thread structure
int
thread_create(thread_t *thread, void *(*start_routine)(void *), void*arg){
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	57                   	push   %edi
801044f4:	56                   	push   %esi
801044f5:	53                   	push   %ebx
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044f6:	bb 54 51 11 80       	mov    $0x80115154,%ebx
    return p;
}
//For ADDED : thread ----------------------------------------
//If isthread == 1, then proc is treated as thread structure
int
thread_create(thread_t *thread, void *(*start_routine)(void *), void*arg){
801044fb:	83 ec 1c             	sub    $0x1c,%esp
allocthread(void)
{
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);
801044fe:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80104505:	e8 86 0f 00 00       	call   80105490 <acquire>
8010450a:	eb 16                	jmp    80104522 <thread_create+0x32>
8010450c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104510:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80104516:	81 fb 54 78 11 80    	cmp    $0x80117854,%ebx
8010451c:	0f 84 3e 02 00 00    	je     80104760 <thread_create+0x270>
        if(p->state == UNUSED)
80104522:	8b 53 0c             	mov    0xc(%ebx),%edx
80104525:	85 d2                	test   %edx,%edx
80104527:	75 e7                	jne    80104510 <thread_create+0x20>
    return 0;

found:
    p->state = EMBRYO;
    //ADDED
    p->tid = nexttid++ + proc->pid*100;
80104529:	a1 08 c0 10 80       	mov    0x8010c008,%eax

    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
8010452e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    //ADDED
    p->tid = nexttid++ + proc->pid*100;
80104535:	8d 50 01             	lea    0x1(%eax),%edx
80104538:	89 15 08 c0 10 80    	mov    %edx,0x8010c008
8010453e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104545:	6b 52 10 64          	imul   $0x64,0x10(%edx),%edx

    release(&ptable.lock);
80104549:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
    return 0;

found:
    p->state = EMBRYO;
    //ADDED
    p->tid = nexttid++ + proc->pid*100;
80104550:	01 d0                	add    %edx,%eax
80104552:	89 83 98 00 00 00    	mov    %eax,0x98(%ebx)

    release(&ptable.lock);
80104558:	e8 73 10 00 00       	call   801055d0 <release>

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
8010455d:	e8 de e0 ff ff       	call   80102640 <kalloc>
80104562:	85 c0                	test   %eax,%eax
80104564:	89 43 08             	mov    %eax,0x8(%ebx)
80104567:	0f 84 1f 02 00 00    	je     8010478c <thread_create+0x29c>
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
8010456d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint*)sp = (uint)trapret;

    sp -= sizeof *p->context;
80104573:	05 9c 0f 00 00       	add    $0xf9c,%eax
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
80104578:	89 53 18             	mov    %edx,0x18(%ebx)
    p->tf = (struct trapframe*)sp;

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint*)sp = (uint)trapret;
8010457b:	c7 40 14 1d 69 10 80 	movl   $0x8010691d,0x14(%eax)

    sp -= sizeof *p->context;
    p->context = (struct context*)sp;
    memset(p->context, 0, sizeof *p->context);
80104582:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104589:	00 
8010458a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104591:	00 
80104592:	89 04 24             	mov    %eax,(%esp)
    // which returns to trapret.
    sp -= 4;
    *(uint*)sp = (uint)trapret;

    sp -= sizeof *p->context;
    p->context = (struct context*)sp;
80104595:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80104598:	e8 83 10 00 00       	call   80105620 <memset>
    p->context->eip = (uint)forkret;
8010459d:	8b 43 1c             	mov    0x1c(%ebx),%eax
801045a0:	c7 40 10 d0 38 10 80 	movl   $0x801038d0,0x10(%eax)
    // Allocate process.
    if((np = allocthread()) == 0){
        return -1;
    }

    np->pid = proc->pid;
801045a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045ad:	8b 50 10             	mov    0x10(%eax),%edx
801045b0:	89 53 10             	mov    %edx,0x10(%ebx)

    // Copy process state from p.
    np->pgdir = proc->pgdir;
801045b3:	8b 50 04             	mov    0x4(%eax),%edx
801045b6:	89 53 04             	mov    %edx,0x4(%ebx)

    //ADDED
    if(proc->isthread == 1 ){
801045b9:	66 83 b8 8c 00 00 00 	cmpw   $0x1,0x8c(%eax)
801045c0:	01 
801045c1:	0f 84 89 01 00 00    	je     80104750 <thread_create+0x260>
        np->parent = proc->parent;
    }else{
        np->parent = proc;
801045c7:	89 43 14             	mov    %eax,0x14(%ebx)
    }
    *np->tf = *proc->tf;
801045ca:	8b 70 18             	mov    0x18(%eax),%esi
801045cd:	b9 13 00 00 00       	mov    $0x13,%ecx
801045d2:	8b 7b 18             	mov    0x18(%ebx),%edi
801045d5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    np->tf->eip = (int)(*start_routine);
801045d7:	8b 55 0c             	mov    0xc(%ebp),%edx
        np->parent = proc;
    }
    *np->tf = *proc->tf;

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
801045da:	8b 43 18             	mov    0x18(%ebx),%eax
801045dd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

    np->tf->eip = (int)(*start_routine);
801045e4:	8b 43 18             	mov    0x18(%ebx),%eax
801045e7:	89 50 38             	mov    %edx,0x38(%eax)
    np->isthread = 1;
801045ea:	b8 01 00 00 00       	mov    $0x1,%eax


    acquire(&ptable.lock);
801045ef:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    np->tf->eip = (int)(*start_routine);
    np->isthread = 1;
801045f6:	66 89 83 8c 00 00 00 	mov    %ax,0x8c(%ebx)


    acquire(&ptable.lock);
801045fd:	e8 8e 0e 00 00       	call   80105490 <acquire>
    //Allocate thread stack
    sz = PGROUNDUP(np->parent->sz);
80104602:	8b 53 14             	mov    0x14(%ebx),%edx
80104605:	8b 02                	mov    (%edx),%eax
80104607:	05 ff 0f 00 00       	add    $0xfff,%eax
8010460c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if((sz = allocuvm(np->parent->pgdir, sz, sz + 2*PGSIZE)) == 0){
80104611:	8d 88 00 20 00 00    	lea    0x2000(%eax),%ecx
80104617:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010461b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010461f:	8b 42 04             	mov    0x4(%edx),%eax
80104622:	89 04 24             	mov    %eax,(%esp)
80104625:	e8 c6 39 00 00       	call   80107ff0 <allocuvm>
8010462a:	85 c0                	test   %eax,%eax
8010462c:	89 c6                	mov    %eax,%esi
8010462e:	0f 84 45 01 00 00    	je     80104779 <thread_create+0x289>
        goto bad;
    }
    clearpteu(np->parent->pgdir, (char*)(sz - 2*PGSIZE));
80104634:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
8010463a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010463e:	8b 43 14             	mov    0x14(%ebx),%eax
80104641:	8b 40 04             	mov    0x4(%eax),%eax
80104644:	89 04 24             	mov    %eax,(%esp)
80104647:	e8 34 3b 00 00       	call   80108180 <clearpteu>
    release(&ptable.lock);
8010464c:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80104653:	e8 78 0f 00 00       	call   801055d0 <release>
    sp = sz;
    np->parent->sz = sz;
80104658:	8b 43 14             	mov    0x14(%ebx),%eax
    np->sz = sz;
    np->stack = sp;

    np->tf->esp = sp;
    *((int*)(np->tf->esp - 4)) = (int)arg;
8010465b:	8b 55 10             	mov    0x10(%ebp),%edx
        goto bad;
    }
    clearpteu(np->parent->pgdir, (char*)(sz - 2*PGSIZE));
    release(&ptable.lock);
    sp = sz;
    np->parent->sz = sz;
8010465e:	89 30                	mov    %esi,(%eax)
    np->sz = sz;
    np->stack = sp;

    np->tf->esp = sp;
80104660:	8b 43 18             	mov    0x18(%ebx),%eax
    }
    clearpteu(np->parent->pgdir, (char*)(sz - 2*PGSIZE));
    release(&ptable.lock);
    sp = sz;
    np->parent->sz = sz;
    np->sz = sz;
80104663:	89 33                	mov    %esi,(%ebx)
    np->stack = sp;
80104665:	89 b3 90 00 00 00    	mov    %esi,0x90(%ebx)

    np->tf->esp = sp;
8010466b:	89 70 44             	mov    %esi,0x44(%eax)
    *((int*)(np->tf->esp - 4)) = (int)arg;
8010466e:	8b 43 18             	mov    0x18(%ebx),%eax
    *((int *)(np->tf->esp - 8)) = 0xFFFFFFFF;
    np->tf->esp -= 8;



    for(i = 0; i < NOFILE; i++)
80104671:	31 f6                	xor    %esi,%esi
    np->parent->sz = sz;
    np->sz = sz;
    np->stack = sp;

    np->tf->esp = sp;
    *((int*)(np->tf->esp - 4)) = (int)arg;
80104673:	8b 40 44             	mov    0x44(%eax),%eax
80104676:	89 50 fc             	mov    %edx,-0x4(%eax)
    *((int *)(np->tf->esp - 8)) = 0xFFFFFFFF;
80104679:	8b 43 18             	mov    0x18(%ebx),%eax
8010467c:	8b 40 44             	mov    0x44(%eax),%eax
8010467f:	c7 40 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%eax)
    np->tf->esp -= 8;
80104686:	8b 43 18             	mov    0x18(%ebx),%eax
80104689:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104690:	83 68 44 08          	subl   $0x8,0x44(%eax)
80104694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi



    for(i = 0; i < NOFILE; i++)
        if(proc->ofile[i])
80104698:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
8010469c:	85 c0                	test   %eax,%eax
8010469e:	74 13                	je     801046b3 <thread_create+0x1c3>
            np->ofile[i] = filedup(proc->ofile[i]);
801046a0:	89 04 24             	mov    %eax,(%esp)
801046a3:	e8 48 c7 ff ff       	call   80100df0 <filedup>
801046a8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801046af:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
    *((int *)(np->tf->esp - 8)) = 0xFFFFFFFF;
    np->tf->esp -= 8;



    for(i = 0; i < NOFILE; i++)
801046b3:	83 c6 01             	add    $0x1,%esi
801046b6:	83 fe 10             	cmp    $0x10,%esi
801046b9:	75 dd                	jne    80104698 <thread_create+0x1a8>
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);
    np->cwd = idup(proc->cwd);
801046bb:	8b 42 68             	mov    0x68(%edx),%eax
801046be:	89 04 24             	mov    %eax,(%esp)
801046c1:	e8 8a d0 ff ff       	call   80101750 <idup>

    safestrcpy(np->name, proc->name, sizeof(proc->name));
801046c6:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801046cd:	00 


    for(i = 0; i < NOFILE; i++)
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);
    np->cwd = idup(proc->cwd);
801046ce:	89 43 68             	mov    %eax,0x68(%ebx)

    safestrcpy(np->name, proc->name, sizeof(proc->name));
801046d1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046d7:	83 c0 6c             	add    $0x6c,%eax
801046da:	89 44 24 04          	mov    %eax,0x4(%esp)
801046de:	8d 43 6c             	lea    0x6c(%ebx),%eax
801046e1:	89 04 24             	mov    %eax,(%esp)
801046e4:	e8 17 11 00 00       	call   80105800 <safestrcpy>

    //ADDED
    *thread = np->tid;
801046e9:	8b 93 98 00 00 00    	mov    0x98(%ebx),%edx
801046ef:	8b 45 08             	mov    0x8(%ebp),%eax
801046f2:	89 10                	mov    %edx,(%eax)
    proc->numOfThread++;
801046f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046fa:	66 83 80 8e 00 00 00 	addw   $0x1,0x8e(%eax)
80104701:	01 
    if(proc->stride>0)share_stride_in_proc(proc);
80104702:	66 83 78 7e 00       	cmpw   $0x0,0x7e(%eax)
80104707:	74 05                	je     8010470e <thread_create+0x21e>
80104709:	e8 92 fc ff ff       	call   801043a0 <share_stride_in_proc.part.1>

    acquire(&ptable.lock);
8010470e:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80104715:	e8 76 0d 00 00       	call   80105490 <acquire>

    np->state = RUNNABLE;
    enqueue(&qOfM[0],np);
8010471a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010471e:	c7 04 24 00 20 11 80 	movl   $0x80112000,(%esp)
    proc->numOfThread++;
    if(proc->stride>0)share_stride_in_proc(proc);

    acquire(&ptable.lock);

    np->state = RUNNABLE;
80104725:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    enqueue(&qOfM[0],np);
8010472c:	e8 8f 3f 00 00       	call   801086c0 <enqueue>

    //CMT
    //cprintf("t-c pid %d / tid %d\n",np->pid,np->tid);
    //printPtable();
    release(&ptable.lock);
80104731:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80104738:	e8 93 0e 00 00       	call   801055d0 <release>
    yield();
8010473d:	e8 5e f4 ff ff       	call   80103ba0 <yield>


    return 0;
80104742:	31 c0                	xor    %eax,%eax

bad:
    cprintf("thread_create error'\n");

    return -1;
}
80104744:	83 c4 1c             	add    $0x1c,%esp
80104747:	5b                   	pop    %ebx
80104748:	5e                   	pop    %esi
80104749:	5f                   	pop    %edi
8010474a:	5d                   	pop    %ebp
8010474b:	c3                   	ret    
8010474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    // Copy process state from p.
    np->pgdir = proc->pgdir;

    //ADDED
    if(proc->isthread == 1 ){
        np->parent = proc->parent;
80104750:	8b 50 14             	mov    0x14(%eax),%edx
80104753:	89 53 14             	mov    %edx,0x14(%ebx)
80104756:	e9 6f fe ff ff       	jmp    801045ca <thread_create+0xda>
8010475b:	90                   	nop
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if(p->state == UNUSED)
            goto found;

    release(&ptable.lock);
80104760:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80104767:	e8 64 0e 00 00       	call   801055d0 <release>

bad:
    cprintf("thread_create error'\n");

    return -1;
}
8010476c:	83 c4 1c             	add    $0x1c,%esp
    uint sz, sp;
    struct proc *np;

    // Allocate process.
    if((np = allocthread()) == 0){
        return -1;
8010476f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

bad:
    cprintf("thread_create error'\n");

    return -1;
}
80104774:	5b                   	pop    %ebx
80104775:	5e                   	pop    %esi
80104776:	5f                   	pop    %edi
80104777:	5d                   	pop    %ebp
80104778:	c3                   	ret    


    return 0;

bad:
    cprintf("thread_create error'\n");
80104779:	c7 04 24 c9 95 10 80 	movl   $0x801095c9,(%esp)
80104780:	e8 cb be ff ff       	call   80100650 <cprintf>

    return -1;
80104785:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010478a:	eb b8                	jmp    80104744 <thread_create+0x254>

    release(&ptable.lock);

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
        p->state = UNUSED;
8010478c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
80104793:	eb d7                	jmp    8010476c <thread_create+0x27c>
80104795:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047a0 <thread_exit>:

    return -1;
}

void
thread_exit(void * retval){
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	56                   	push   %esi
801047a4:	53                   	push   %ebx

    struct proc *p;
    int fd;


    if(proc == initproc)
801047a5:	31 db                	xor    %ebx,%ebx

    return -1;
}

void
thread_exit(void * retval){
801047a7:	83 ec 10             	sub    $0x10,%esp

    struct proc *p;
    int fd;


    if(proc == initproc)
801047aa:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801047b1:	3b 15 bc c5 10 80    	cmp    0x8010c5bc,%edx
801047b7:	0f 84 97 01 00 00    	je     80104954 <thread_exit+0x1b4>
801047bd:	8d 76 00             	lea    0x0(%esi),%esi
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
        if(proc->ofile[fd]){
801047c0:	8d 73 08             	lea    0x8(%ebx),%esi
801047c3:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
801047c7:	85 c0                	test   %eax,%eax
801047c9:	74 17                	je     801047e2 <thread_exit+0x42>
            fileclose(proc->ofile[fd]);
801047cb:	89 04 24             	mov    %eax,(%esp)
801047ce:	e8 6d c6 ff ff       	call   80100e40 <fileclose>
            proc->ofile[fd] = 0;
801047d3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801047da:	c7 44 b2 08 00 00 00 	movl   $0x0,0x8(%edx,%esi,4)
801047e1:	00 

    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
801047e2:	83 c3 01             	add    $0x1,%ebx
801047e5:	83 fb 10             	cmp    $0x10,%ebx
801047e8:	75 d6                	jne    801047c0 <thread_exit+0x20>
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }

    begin_op();
801047ea:	e8 41 e5 ff ff       	call   80102d30 <begin_op>
    iput(proc->cwd);
801047ef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047f5:	8b 40 68             	mov    0x68(%eax),%eax
801047f8:	89 04 24             	mov    %eax,(%esp)
801047fb:	e8 90 d0 ff ff       	call   80101890 <iput>
    end_op();
80104800:	e8 9b e5 ff ff       	call   80102da0 <end_op>
    proc->cwd = 0;
80104805:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010480b:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

    acquire(&ptable.lock);
80104812:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80104819:	e8 72 0c 00 00       	call   80105490 <acquire>

    // Parent might be sleeping in join().
    wakeup1((void*)proc->parent);
8010481e:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104825:	b8 54 51 11 80       	mov    $0x80115154,%eax
    proc->cwd = 0;

    acquire(&ptable.lock);

    // Parent might be sleeping in join().
    wakeup1((void*)proc->parent);
8010482a:	8b 51 14             	mov    0x14(%ecx),%edx
8010482d:	eb 0d                	jmp    8010483c <thread_exit+0x9c>
8010482f:	90                   	nop
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104830:	05 9c 00 00 00       	add    $0x9c,%eax
80104835:	3d 54 78 11 80       	cmp    $0x80117854,%eax
8010483a:	74 1e                	je     8010485a <thread_exit+0xba>
        if(p->state == SLEEPING && p->chan == chan){
8010483c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104840:	75 ee                	jne    80104830 <thread_exit+0x90>
80104842:	3b 50 20             	cmp    0x20(%eax),%edx
80104845:	75 e9                	jne    80104830 <thread_exit+0x90>
            p->state = RUNNABLE;
80104847:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010484e:	05 9c 00 00 00       	add    $0x9c,%eax
80104853:	3d 54 78 11 80       	cmp    $0x80117854,%eax
80104858:	75 e2                	jne    8010483c <thread_exit+0x9c>

    ///*
    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->parent == proc){
            p->parent = initproc;
8010485a:	8b 1d bc c5 10 80    	mov    0x8010c5bc,%ebx
80104860:	ba 54 51 11 80       	mov    $0x80115154,%edx
80104865:	eb 0f                	jmp    80104876 <thread_exit+0xd6>
80104867:	90                   	nop
    // Parent might be sleeping in join().
    wakeup1((void*)proc->parent);

    ///*
    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104868:	81 c2 9c 00 00 00    	add    $0x9c,%edx
8010486e:	81 fa 54 78 11 80    	cmp    $0x80117854,%edx
80104874:	74 3a                	je     801048b0 <thread_exit+0x110>
        if(p->parent == proc){
80104876:	3b 4a 14             	cmp    0x14(%edx),%ecx
80104879:	75 ed                	jne    80104868 <thread_exit+0xc8>
            p->parent = initproc;
            if(p->state == ZOMBIE){
8010487b:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)

    ///*
    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->parent == proc){
            p->parent = initproc;
8010487f:	89 5a 14             	mov    %ebx,0x14(%edx)
            if(p->state == ZOMBIE){
80104882:	75 e4                	jne    80104868 <thread_exit+0xc8>
80104884:	b8 54 51 11 80       	mov    $0x80115154,%eax
80104889:	eb 11                	jmp    8010489c <thread_exit+0xfc>
8010488b:	90                   	nop
8010488c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104890:	05 9c 00 00 00       	add    $0x9c,%eax
80104895:	3d 54 78 11 80       	cmp    $0x80117854,%eax
8010489a:	74 cc                	je     80104868 <thread_exit+0xc8>
        if(p->state == SLEEPING && p->chan == chan){
8010489c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801048a0:	75 ee                	jne    80104890 <thread_exit+0xf0>
801048a2:	3b 58 20             	cmp    0x20(%eax),%ebx
801048a5:	75 e9                	jne    80104890 <thread_exit+0xf0>
            p->state = RUNNABLE;
801048a7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801048ae:	eb e0                	jmp    80104890 <thread_exit+0xf0>
    }
    //*/

    // Jump into the scheduler, never to return.
    //ADDED
    if(proc->stride == 0)dequeue(&qOfM[proc->qPosi],proc);
801048b0:	66 83 79 7e 00       	cmpw   $0x0,0x7e(%ecx)
801048b5:	74 76                	je     8010492d <thread_exit+0x18d>
    if(proc->pid > 2 )cut_cpu_share(proc->stride);
801048b7:	83 79 10 02          	cmpl   $0x2,0x10(%ecx)
801048bb:	7f 5b                	jg     80104918 <thread_exit+0x178>
    proc->consumedTime = 0;
    proc->stride = 0;
801048bd:	31 c0                	xor    %eax,%eax
    proc->pass = 0;
    proc->qPosi = 0;
801048bf:	31 d2                	xor    %edx,%edx
    // Jump into the scheduler, never to return.
    //ADDED
    if(proc->stride == 0)dequeue(&qOfM[proc->qPosi],proc);
    if(proc->pid > 2 )cut_cpu_share(proc->stride);
    proc->consumedTime = 0;
    proc->stride = 0;
801048c1:	66 89 41 7e          	mov    %ax,0x7e(%ecx)
    proc->pass = 0;
    proc->qPosi = 0;


    //ADDED
    proc->retval = retval;
801048c5:	8b 45 08             	mov    0x8(%ebp),%eax

    // Jump into the scheduler, never to return.
    //ADDED
    if(proc->stride == 0)dequeue(&qOfM[proc->qPosi],proc);
    if(proc->pid > 2 )cut_cpu_share(proc->stride);
    proc->consumedTime = 0;
801048c8:	c7 81 88 00 00 00 00 	movl   $0x0,0x88(%ecx)
801048cf:	00 00 00 
    proc->stride = 0;
    proc->pass = 0;
801048d2:	c7 81 84 00 00 00 00 	movl   $0x0,0x84(%ecx)
801048d9:	00 00 00 
    proc->qPosi = 0;
801048dc:	66 89 51 7c          	mov    %dx,0x7c(%ecx)


    //ADDED
    proc->retval = retval;
801048e0:	89 81 94 00 00 00    	mov    %eax,0x94(%ecx)

    proc->state = ZOMBIE;

    proc->parent->numOfThread--;
801048e6:	8b 41 14             	mov    0x14(%ecx),%eax


    //ADDED
    proc->retval = retval;

    proc->state = ZOMBIE;
801048e9:	c7 41 0c 05 00 00 00 	movl   $0x5,0xc(%ecx)

    proc->parent->numOfThread--;
801048f0:	66 83 a8 8e 00 00 00 	subw   $0x1,0x8e(%eax)
801048f7:	01 
    if(proc->parent->stride > 0)share_stride_in_proc(proc->parent);
801048f8:	8b 41 14             	mov    0x14(%ecx),%eax
801048fb:	66 83 78 7e 00       	cmpw   $0x0,0x7e(%eax)
80104900:	74 05                	je     80104907 <thread_exit+0x167>
80104902:	e8 99 fa ff ff       	call   801043a0 <share_stride_in_proc.part.1>
    //CMT
    //printMLFQAll();
    //cprintf("t-e pid %d / tid %d\n",proc->pid,proc->tid);
    //printPtable();

    sched();
80104907:	e8 f4 f1 ff ff       	call   80103b00 <sched>
    panic("zombie exit");
8010490c:	c7 04 24 ec 95 10 80 	movl   $0x801095ec,(%esp)
80104913:	e8 48 ba ff ff       	call   80100360 <panic>
    //*/

    // Jump into the scheduler, never to return.
    //ADDED
    if(proc->stride == 0)dequeue(&qOfM[proc->qPosi],proc);
    if(proc->pid > 2 )cut_cpu_share(proc->stride);
80104918:	0f b7 41 7e          	movzwl 0x7e(%ecx),%eax
8010491c:	89 04 24             	mov    %eax,(%esp)
8010491f:	e8 8c 46 00 00       	call   80108fb0 <cut_cpu_share>
80104924:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
8010492b:	eb 90                	jmp    801048bd <thread_exit+0x11d>
    }
    //*/

    // Jump into the scheduler, never to return.
    //ADDED
    if(proc->stride == 0)dequeue(&qOfM[proc->qPosi],proc);
8010492d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80104931:	0f b7 41 7c          	movzwl 0x7c(%ecx),%eax
80104935:	69 c0 10 01 00 00    	imul   $0x110,%eax,%eax
8010493b:	05 00 20 11 80       	add    $0x80112000,%eax
80104940:	89 04 24             	mov    %eax,(%esp)
80104943:	e8 18 3f 00 00       	call   80108860 <dequeue>
80104948:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
8010494f:	e9 63 ff ff ff       	jmp    801048b7 <thread_exit+0x117>
    struct proc *p;
    int fd;


    if(proc == initproc)
        panic("init exiting");
80104954:	c7 04 24 df 95 10 80 	movl   $0x801095df,(%esp)
8010495b:	e8 00 ba ff ff       	call   80100360 <panic>

80104960 <thread_join>:
    sched();
    panic("zombie exit");
}

int
thread_join(thread_t thread, void **retval){
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	56                   	push   %esi
80104964:	53                   	push   %ebx
80104965:	83 ec 10             	sub    $0x10,%esp
80104968:	8b 75 08             	mov    0x8(%ebp),%esi

    struct proc *p;
    int havekids;
    uint sz;

    acquire(&ptable.lock);
8010496b:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80104972:	e8 19 0b 00 00       	call   80105490 <acquire>
80104977:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    for(;;){
        // Scan through table looking for exited children.
        havekids = 0;
8010497d:	31 d2                	xor    %edx,%edx
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010497f:	bb 54 51 11 80       	mov    $0x80115154,%ebx
80104984:	eb 10                	jmp    80104996 <thread_join+0x36>
80104986:	66 90                	xchg   %ax,%ax
80104988:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
8010498e:	81 fb 54 78 11 80    	cmp    $0x80117854,%ebx
80104994:	74 32                	je     801049c8 <thread_join+0x68>
            if(p->parent != proc || p->isthread != 1 || p->tid != thread){
80104996:	39 43 14             	cmp    %eax,0x14(%ebx)
80104999:	75 ed                	jne    80104988 <thread_join+0x28>
8010499b:	66 83 bb 8c 00 00 00 	cmpw   $0x1,0x8c(%ebx)
801049a2:	01 
801049a3:	75 e3                	jne    80104988 <thread_join+0x28>
801049a5:	39 b3 98 00 00 00    	cmp    %esi,0x98(%ebx)
801049ab:	75 db                	jne    80104988 <thread_join+0x28>
                continue;
            }
            havekids = 1;
            if(p->state == ZOMBIE){
801049ad:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801049b1:	74 53                	je     80104a06 <thread_join+0xa6>

    acquire(&ptable.lock);
    for(;;){
        // Scan through table looking for exited children.
        havekids = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049b3:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
            if(p->parent != proc || p->isthread != 1 || p->tid != thread){
                continue;
            }
            havekids = 1;
801049b9:	ba 01 00 00 00       	mov    $0x1,%edx

    acquire(&ptable.lock);
    for(;;){
        // Scan through table looking for exited children.
        havekids = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049be:	81 fb 54 78 11 80    	cmp    $0x80117854,%ebx
801049c4:	75 d0                	jne    80104996 <thread_join+0x36>
801049c6:	66 90                	xchg   %ax,%ax
                return 0;
            }
        }

        // No point waiting if we don't have any children.
        if(!havekids || proc->killed){
801049c8:	85 d2                	test   %edx,%edx
801049ca:	74 19                	je     801049e5 <thread_join+0x85>
801049cc:	8b 50 24             	mov    0x24(%eax),%edx
801049cf:	85 d2                	test   %edx,%edx
801049d1:	75 12                	jne    801049e5 <thread_join+0x85>
        }



        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep((void*)proc, &ptable.lock);  //DOC: wait-sleep
801049d3:	c7 44 24 04 20 51 11 	movl   $0x80115120,0x4(%esp)
801049da:	80 
801049db:	89 04 24             	mov    %eax,(%esp)
801049de:	e8 5d f2 ff ff       	call   80103c40 <sleep>

    }
801049e3:	eb 92                	jmp    80104977 <thread_join+0x17>
            }
        }

        // No point waiting if we don't have any children.
        if(!havekids || proc->killed){
            cprintf(" [Warning] There isn't child to join \n");
801049e5:	c7 04 24 ec 96 10 80 	movl   $0x801096ec,(%esp)
801049ec:	e8 5f bc ff ff       	call   80100650 <cprintf>
            release(&ptable.lock);
801049f1:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
801049f8:	e8 d3 0b 00 00       	call   801055d0 <release>
            return 0;
801049fd:	31 c0                	xor    %eax,%eax

bad:
    cprintf(" [Error]thread join error\n");
    return -1;
    return 0;
}
801049ff:	83 c4 10             	add    $0x10,%esp
80104a02:	5b                   	pop    %ebx
80104a03:	5e                   	pop    %esi
80104a04:	5d                   	pop    %ebp
80104a05:	c3                   	ret    
            havekids = 1;
            if(p->state == ZOMBIE){
                //CMT
                //cprintf("t-j  pid %d / tid %d\n",p->pid,p->tid);
                // Found one.
                kfree(p->kstack);
80104a06:	8b 43 08             	mov    0x8(%ebx),%eax
80104a09:	89 04 24             	mov    %eax,(%esp)
80104a0c:	e8 7f da ff ff       	call   80102490 <kfree>
                p->killed = 0;
                p->state = UNUSED;

                //ADDED
                //dealocate thread stack
                sz = PGROUNDUP(p->sz);
80104a11:	8b 03                	mov    (%ebx),%eax
            if(p->state == ZOMBIE){
                //CMT
                //cprintf("t-j  pid %d / tid %d\n",p->pid,p->tid);
                // Found one.
                kfree(p->kstack);
                p->kstack = 0;
80104a13:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                p->pid = 0;
80104a1a:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->tid = 0;
80104a21:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
80104a28:	00 00 00 
                p->killed = 0;
                p->state = UNUSED;

                //ADDED
                //dealocate thread stack
                sz = PGROUNDUP(p->sz);
80104a2b:	05 ff 0f 00 00       	add    $0xfff,%eax
80104a30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
                if((sz = deallocuvm(p->pgdir, sz, sz - 2*PGSIZE)) == 0){
80104a35:	8d 90 00 e0 ff ff    	lea    -0x2000(%eax),%edx
80104a3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a3f:	8b 43 04             	mov    0x4(%ebx),%eax
80104a42:	89 54 24 08          	mov    %edx,0x8(%esp)
                // Found one.
                kfree(p->kstack);
                p->kstack = 0;
                p->pid = 0;
                p->tid = 0;
                p->parent = 0;
80104a46:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
80104a4d:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->state = UNUSED;

                //ADDED
                //dealocate thread stack
                sz = PGROUNDUP(p->sz);
                if((sz = deallocuvm(p->pgdir, sz, sz - 2*PGSIZE)) == 0){
80104a51:	89 04 24             	mov    %eax,(%esp)
                p->kstack = 0;
                p->pid = 0;
                p->tid = 0;
                p->parent = 0;
                p->name[0] = 0;
                p->killed = 0;
80104a54:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
80104a5b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

                //ADDED
                //dealocate thread stack
                sz = PGROUNDUP(p->sz);
                if((sz = deallocuvm(p->pgdir, sz, sz - 2*PGSIZE)) == 0){
80104a62:	e8 79 36 00 00       	call   801080e0 <deallocuvm>
80104a67:	85 c0                	test   %eax,%eax
80104a69:	74 2e                	je     80104a99 <thread_join+0x139>
                    goto bad;
                }
                empty_stack_clean(proc);
80104a6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a71:	89 04 24             	mov    %eax,(%esp)
80104a74:	e8 f7 38 00 00       	call   80108370 <empty_stack_clean>

                //The procedure that passing retval from t_exit to t_join
                *retval = p->retval;
80104a79:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a7c:	8b 93 94 00 00 00    	mov    0x94(%ebx),%edx
80104a82:	89 10                	mov    %edx,(%eax)
                //printMLFQAll();

                release(&ptable.lock);
80104a84:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80104a8b:	e8 40 0b 00 00       	call   801055d0 <release>

bad:
    cprintf(" [Error]thread join error\n");
    return -1;
    return 0;
}
80104a90:	83 c4 10             	add    $0x10,%esp
                *retval = p->retval;
                //printMLFQAll();

                release(&ptable.lock);

                return 0;
80104a93:	31 c0                	xor    %eax,%eax

bad:
    cprintf(" [Error]thread join error\n");
    return -1;
    return 0;
}
80104a95:	5b                   	pop    %ebx
80104a96:	5e                   	pop    %esi
80104a97:	5d                   	pop    %ebp
80104a98:	c3                   	ret    
        sleep((void*)proc, &ptable.lock);  //DOC: wait-sleep

    }

bad:
    cprintf(" [Error]thread join error\n");
80104a99:	c7 04 24 f8 95 10 80 	movl   $0x801095f8,(%esp)
80104aa0:	e8 ab bb ff ff       	call   80100650 <cprintf>
    return -1;
80104aa5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104aaa:	e9 50 ff ff ff       	jmp    801049ff <thread_join+0x9f>
80104aaf:	90                   	nop

80104ab0 <thread_clean>:
    return 0;
}

int
thread_clean(thread_t thread, void **retval){
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	57                   	push   %edi
80104ab4:	56                   	push   %esi
80104ab5:	53                   	push   %ebx
    struct proc *p;
    uint sz;
    int fd;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ab6:	bb 54 51 11 80       	mov    $0x80115154,%ebx
    return -1;
    return 0;
}

int
thread_clean(thread_t thread, void **retval){
80104abb:	83 ec 1c             	sub    $0x1c,%esp
80104abe:	8b 7d 08             	mov    0x8(%ebp),%edi

    struct proc *p;
    uint sz;
    int fd;

    acquire(&ptable.lock);
80104ac1:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
    return -1;
    return 0;
}

int
thread_clean(thread_t thread, void **retval){
80104ac8:	8b 75 0c             	mov    0xc(%ebp),%esi

    struct proc *p;
    uint sz;
    int fd;

    acquire(&ptable.lock);
80104acb:	e8 c0 09 00 00       	call   80105490 <acquire>
80104ad0:	eb 18                	jmp    80104aea <thread_clean+0x3a>
80104ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ad8:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80104ade:	81 fb 54 78 11 80    	cmp    $0x80117854,%ebx
80104ae4:	0f 84 e1 01 00 00    	je     80104ccb <thread_clean+0x21b>
        if(p->isthread != 1 || p->tid != thread){
80104aea:	66 83 bb 8c 00 00 00 	cmpw   $0x1,0x8c(%ebx)
80104af1:	01 
80104af2:	75 e4                	jne    80104ad8 <thread_clean+0x28>
80104af4:	39 bb 98 00 00 00    	cmp    %edi,0x98(%ebx)
80104afa:	75 dc                	jne    80104ad8 <thread_clean+0x28>
        }
        // Found one.

        // THREAD EXIT---------------------

        if(p == initproc)
80104afc:	39 1d bc c5 10 80    	cmp    %ebx,0x8010c5bc
80104b02:	0f 84 14 02 00 00    	je     80104d1c <thread_clean+0x26c>
            panic("init exiting");

        release(&ptable.lock);
80104b08:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
        // Close all open files.
        for(fd = 0; fd < NOFILE; fd++){
80104b0f:	31 ff                	xor    %edi,%edi
        // THREAD EXIT---------------------

        if(p == initproc)
            panic("init exiting");

        release(&ptable.lock);
80104b11:	e8 ba 0a 00 00       	call   801055d0 <release>
80104b16:	66 90                	xchg   %ax,%ax
        // Close all open files.
        for(fd = 0; fd < NOFILE; fd++){
            if(p->ofile[fd]){
80104b18:	8b 44 bb 28          	mov    0x28(%ebx,%edi,4),%eax
80104b1c:	85 c0                	test   %eax,%eax
80104b1e:	74 10                	je     80104b30 <thread_clean+0x80>
                fileclose(p->ofile[fd]);
80104b20:	89 04 24             	mov    %eax,(%esp)
80104b23:	e8 18 c3 ff ff       	call   80100e40 <fileclose>
                p->ofile[fd] = 0;
80104b28:	c7 44 bb 28 00 00 00 	movl   $0x0,0x28(%ebx,%edi,4)
80104b2f:	00 
        if(p == initproc)
            panic("init exiting");

        release(&ptable.lock);
        // Close all open files.
        for(fd = 0; fd < NOFILE; fd++){
80104b30:	83 c7 01             	add    $0x1,%edi
80104b33:	83 ff 10             	cmp    $0x10,%edi
80104b36:	75 e0                	jne    80104b18 <thread_clean+0x68>
                fileclose(p->ofile[fd]);
                p->ofile[fd] = 0;
            }
        }

        begin_op();
80104b38:	e8 f3 e1 ff ff       	call   80102d30 <begin_op>
        iput(p->cwd);
80104b3d:	8b 43 68             	mov    0x68(%ebx),%eax
80104b40:	89 04 24             	mov    %eax,(%esp)
80104b43:	e8 48 cd ff ff       	call   80101890 <iput>
        end_op();
80104b48:	e8 53 e2 ff ff       	call   80102da0 <end_op>
        p->cwd = 0;


        acquire(&ptable.lock);
80104b4d:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
        }

        begin_op();
        iput(p->cwd);
        end_op();
        p->cwd = 0;
80104b54:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)


        acquire(&ptable.lock);
80104b5b:	e8 30 09 00 00       	call   80105490 <acquire>
        // Parent might be sleeping in join().
        wakeup1((void*)p->pid);
80104b60:	8b 53 10             	mov    0x10(%ebx),%edx
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b63:	b8 54 51 11 80       	mov    $0x80115154,%eax
80104b68:	eb 12                	jmp    80104b7c <thread_clean+0xcc>
80104b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b70:	05 9c 00 00 00       	add    $0x9c,%eax
80104b75:	3d 54 78 11 80       	cmp    $0x80117854,%eax
80104b7a:	74 24                	je     80104ba0 <thread_clean+0xf0>
        if(p->state == SLEEPING && p->chan == chan){
80104b7c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104b80:	75 ee                	jne    80104b70 <thread_clean+0xc0>
80104b82:	3b 50 20             	cmp    0x20(%eax),%edx
80104b85:	75 e9                	jne    80104b70 <thread_clean+0xc0>
            p->state = RUNNABLE;
80104b87:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b8e:	05 9c 00 00 00       	add    $0x9c,%eax
80104b93:	3d 54 78 11 80       	cmp    $0x80117854,%eax
80104b98:	75 e2                	jne    80104b7c <thread_clean+0xcc>
80104b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        // Parent might be sleeping in join().
        wakeup1((void*)p->pid);


        //ADDED
        if(p->stride == 0)dequeue(&qOfM[p->qPosi],p);
80104ba0:	66 83 7b 7e 00       	cmpw   $0x0,0x7e(%ebx)
80104ba5:	0f 84 f6 00 00 00    	je     80104ca1 <thread_clean+0x1f1>
        if(p->pid > 2 )cut_cpu_share(p->stride);
80104bab:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80104baf:	0f 8f db 00 00 00    	jg     80104c90 <thread_clean+0x1e0>


        p->retval = retval;

        //ADDED
        proc->parent->numOfThread--;
80104bb5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

        //ADDED
        if(p->stride == 0)dequeue(&qOfM[p->qPosi],p);
        if(p->pid > 2 )cut_cpu_share(p->stride);
        p->consumedTime = 0;
        p->stride = 0;
80104bbb:	31 d2                	xor    %edx,%edx
        p->pass = 0;
        p->qPosi = 0;
80104bbd:	31 c9                	xor    %ecx,%ecx


        //ADDED
        if(p->stride == 0)dequeue(&qOfM[p->qPosi],p);
        if(p->pid > 2 )cut_cpu_share(p->stride);
        p->consumedTime = 0;
80104bbf:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80104bc6:	00 00 00 
        p->stride = 0;
80104bc9:	66 89 53 7e          	mov    %dx,0x7e(%ebx)
        p->pass = 0;
80104bcd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104bd4:	00 00 00 
        p->qPosi = 0;
80104bd7:	66 89 4b 7c          	mov    %cx,0x7c(%ebx)


        p->retval = retval;
80104bdb:	89 b3 94 00 00 00    	mov    %esi,0x94(%ebx)

        //ADDED
        proc->parent->numOfThread--;
80104be1:	8b 50 14             	mov    0x14(%eax),%edx
80104be4:	66 83 aa 8e 00 00 00 	subw   $0x1,0x8e(%edx)
80104beb:	01 
        if(proc->parent->stride > 0)share_stride_in_proc(proc->parent);
80104bec:	8b 40 14             	mov    0x14(%eax),%eax
80104bef:	66 83 78 7e 00       	cmpw   $0x0,0x7e(%eax)
80104bf4:	0f 85 c7 00 00 00    	jne    80104cc1 <thread_clean+0x211>

        p->state = ZOMBIE;


        //THREAD CLEAN-----------------------------
        if(p->kstack)kfree(p->kstack);
80104bfa:	8b 43 08             	mov    0x8(%ebx),%eax

        //ADDED
        proc->parent->numOfThread--;
        if(proc->parent->stride > 0)share_stride_in_proc(proc->parent);

        p->state = ZOMBIE;
80104bfd:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)


        //THREAD CLEAN-----------------------------
        if(p->kstack)kfree(p->kstack);
80104c04:	85 c0                	test   %eax,%eax
80104c06:	74 08                	je     80104c10 <thread_clean+0x160>
80104c08:	89 04 24             	mov    %eax,(%esp)
80104c0b:	e8 80 d8 ff ff       	call   80102490 <kfree>
        p->state = UNUSED;


        //ADDED
        //dealocate thread stack
        sz = PGROUNDUP(p->sz);
80104c10:	8b 03                	mov    (%ebx),%eax
        p->state = ZOMBIE;


        //THREAD CLEAN-----------------------------
        if(p->kstack)kfree(p->kstack);
        p->kstack = 0;
80104c12:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        p->pid = 0;
80104c19:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104c20:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->state = UNUSED;


        //ADDED
        //dealocate thread stack
        sz = PGROUNDUP(p->sz);
80104c27:	05 ff 0f 00 00       	add    $0xfff,%eax
80104c2c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
        if((sz = deallocuvm(p->pgdir, sz, sz - 2*PGSIZE)) == 0){
80104c31:	8d 90 00 e0 ff ff    	lea    -0x2000(%eax),%edx
80104c37:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c3b:	8b 43 04             	mov    0x4(%ebx),%eax
80104c3e:	89 54 24 08          	mov    %edx,0x8(%esp)
        //THREAD CLEAN-----------------------------
        if(p->kstack)kfree(p->kstack);
        p->kstack = 0;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
80104c42:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104c46:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)


        //ADDED
        //dealocate thread stack
        sz = PGROUNDUP(p->sz);
        if((sz = deallocuvm(p->pgdir, sz, sz - 2*PGSIZE)) == 0){
80104c4d:	89 04 24             	mov    %eax,(%esp)
        p->kstack = 0;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
80104c50:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)


        //ADDED
        //dealocate thread stack
        sz = PGROUNDUP(p->sz);
        if((sz = deallocuvm(p->pgdir, sz, sz - 2*PGSIZE)) == 0){
80104c57:	e8 84 34 00 00       	call   801080e0 <deallocuvm>
80104c5c:	85 c0                	test   %eax,%eax
80104c5e:	0f 84 96 00 00 00    	je     80104cfa <thread_clean+0x24a>
            goto bad;
        }
        empty_stack_clean(proc);
80104c64:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c6a:	89 04 24             	mov    %eax,(%esp)
80104c6d:	e8 fe 36 00 00       	call   80108370 <empty_stack_clean>

        //The procedure that passing retval from t_exit to t_join
        *retval = p->retval;
80104c72:	8b 83 94 00 00 00    	mov    0x94(%ebx),%eax
80104c78:	89 06                	mov    %eax,(%esi)

        release(&ptable.lock);
80104c7a:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80104c81:	e8 4a 09 00 00       	call   801055d0 <release>
        return 0;
80104c86:	31 c0                	xor    %eax,%eax

bad:
    cprintf(" [Error]thread clean error\n");
    release(&ptable.lock);
    return -1;
}
80104c88:	83 c4 1c             	add    $0x1c,%esp
80104c8b:	5b                   	pop    %ebx
80104c8c:	5e                   	pop    %esi
80104c8d:	5f                   	pop    %edi
80104c8e:	5d                   	pop    %ebp
80104c8f:	c3                   	ret    
        wakeup1((void*)p->pid);


        //ADDED
        if(p->stride == 0)dequeue(&qOfM[p->qPosi],p);
        if(p->pid > 2 )cut_cpu_share(p->stride);
80104c90:	0f b7 43 7e          	movzwl 0x7e(%ebx),%eax
80104c94:	89 04 24             	mov    %eax,(%esp)
80104c97:	e8 14 43 00 00       	call   80108fb0 <cut_cpu_share>
80104c9c:	e9 14 ff ff ff       	jmp    80104bb5 <thread_clean+0x105>
        // Parent might be sleeping in join().
        wakeup1((void*)p->pid);


        //ADDED
        if(p->stride == 0)dequeue(&qOfM[p->qPosi],p);
80104ca1:	0f b7 43 7c          	movzwl 0x7c(%ebx),%eax
80104ca5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104ca9:	69 c0 10 01 00 00    	imul   $0x110,%eax,%eax
80104caf:	05 00 20 11 80       	add    $0x80112000,%eax
80104cb4:	89 04 24             	mov    %eax,(%esp)
80104cb7:	e8 a4 3b 00 00       	call   80108860 <dequeue>
80104cbc:	e9 ea fe ff ff       	jmp    80104bab <thread_clean+0xfb>
80104cc1:	e8 da f6 ff ff       	call   801043a0 <share_stride_in_proc.part.1>
80104cc6:	e9 2f ff ff ff       	jmp    80104bfa <thread_clean+0x14a>
        release(&ptable.lock);
        return 0;
    }

    // No point waiting if we don't have any children.
    if(proc->killed){
80104ccb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cd1:	8b 40 24             	mov    0x24(%eax),%eax
80104cd4:	85 c0                	test   %eax,%eax
80104cd6:	74 22                	je     80104cfa <thread_clean+0x24a>
        cprintf(" [Warning] There is no child to clean\n");
80104cd8:	c7 04 24 14 97 10 80 	movl   $0x80109714,(%esp)
80104cdf:	e8 6c b9 ff ff       	call   80100650 <cprintf>
        release(&ptable.lock);
80104ce4:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80104ceb:	e8 e0 08 00 00       	call   801055d0 <release>

bad:
    cprintf(" [Error]thread clean error\n");
    release(&ptable.lock);
    return -1;
}
80104cf0:	83 c4 1c             	add    $0x1c,%esp

    // No point waiting if we don't have any children.
    if(proc->killed){
        cprintf(" [Warning] There is no child to clean\n");
        release(&ptable.lock);
        return 0;
80104cf3:	31 c0                	xor    %eax,%eax

bad:
    cprintf(" [Error]thread clean error\n");
    release(&ptable.lock);
    return -1;
}
80104cf5:	5b                   	pop    %ebx
80104cf6:	5e                   	pop    %esi
80104cf7:	5f                   	pop    %edi
80104cf8:	5d                   	pop    %ebp
80104cf9:	c3                   	ret    
        return 0;
        //return -1;
    }

bad:
    cprintf(" [Error]thread clean error\n");
80104cfa:	c7 04 24 13 96 10 80 	movl   $0x80109613,(%esp)
80104d01:	e8 4a b9 ff ff       	call   80100650 <cprintf>
    release(&ptable.lock);
80104d06:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80104d0d:	e8 be 08 00 00       	call   801055d0 <release>
    return -1;
80104d12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d17:	e9 6c ff ff ff       	jmp    80104c88 <thread_clean+0x1d8>
        // Found one.

        // THREAD EXIT---------------------

        if(p == initproc)
            panic("init exiting");
80104d1c:	c7 04 24 df 95 10 80 	movl   $0x801095df,(%esp)
80104d23:	e8 38 b6 ff ff       	call   80100360 <panic>
80104d28:	90                   	nop
80104d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d30 <clean>:
    return -1;
}

    void
clean(struct proc *target)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	53                   	push   %ebx
80104d34:	83 ec 14             	sub    $0x14,%esp
80104d37:	8b 5d 08             	mov    0x8(%ebp),%ebx
    proc = target;
    switchuvm(target);
80104d3a:	89 1c 24             	mov    %ebx,(%esp)
}

    void
clean(struct proc *target)
{
    proc = target;
80104d3d:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
    switchuvm(target);
80104d44:	e8 97 30 00 00       	call   80107de0 <switchuvm>
    target->state = RUNNING;
80104d49:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
    wakeup(target);
80104d50:	89 1c 24             	mov    %ebx,(%esp)
80104d53:	e8 98 f0 ff ff       	call   80103df0 <wakeup>
    target->context->eip = (uint)exit;
80104d58:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104d5b:	c7 40 10 80 4d 10 80 	movl   $0x80104d80,0x10(%eax)
    swtch(&proc->context, target->context);
80104d62:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104d65:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d6f:	83 c0 1c             	add    $0x1c,%eax
80104d72:	89 04 24             	mov    %eax,(%esp)
80104d75:	e8 e1 0a 00 00       	call   8010585b <swtch>
}
80104d7a:	83 c4 14             	add    $0x14,%esp
80104d7d:	5b                   	pop    %ebx
80104d7e:	5d                   	pop    %ebp
80104d7f:	c3                   	ret    

80104d80 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
    void
exit(void)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	56                   	push   %esi
80104d84:	53                   	push   %ebx
80104d85:	83 ec 10             	sub    $0x10,%esp
    struct proc *p;
    int fd;
    int c_retval = 0;


    if(proc->isthread == 1){
80104d88:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104d8f:	66 83 ba 8c 00 00 00 	cmpw   $0x1,0x8c(%edx)
80104d96:	01 
80104d97:	0f 84 3f 02 00 00    	je     80104fdc <exit+0x25c>
        return clean(proc->parent);

    }

    if(proc == initproc)
80104d9d:	31 db                	xor    %ebx,%ebx
80104d9f:	3b 15 bc c5 10 80    	cmp    0x8010c5bc,%edx
80104da5:	0f 84 43 02 00 00    	je     80104fee <exit+0x26e>
80104dab:	90                   	nop
80104dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
        if(proc->ofile[fd]){
80104db0:	8d 73 08             	lea    0x8(%ebx),%esi
80104db3:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
80104db7:	85 c0                	test   %eax,%eax
80104db9:	74 17                	je     80104dd2 <exit+0x52>
            fileclose(proc->ofile[fd]);
80104dbb:	89 04 24             	mov    %eax,(%esp)
80104dbe:	e8 7d c0 ff ff       	call   80100e40 <fileclose>
            proc->ofile[fd] = 0;
80104dc3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104dca:	c7 44 b2 08 00 00 00 	movl   $0x0,0x8(%edx,%esi,4)
80104dd1:	00 

    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
80104dd2:	83 c3 01             	add    $0x1,%ebx
80104dd5:	83 fb 10             	cmp    $0x10,%ebx
80104dd8:	75 d6                	jne    80104db0 <exit+0x30>
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }

    begin_op();
80104dda:	e8 51 df ff ff       	call   80102d30 <begin_op>
    iput(proc->cwd);
80104ddf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104de5:	8b 40 68             	mov    0x68(%eax),%eax
80104de8:	89 04 24             	mov    %eax,(%esp)
80104deb:	e8 a0 ca ff ff       	call   80101890 <iput>
    end_op();
80104df0:	e8 ab df ff ff       	call   80102da0 <end_op>
    proc->cwd = 0;
80104df5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dfb:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

    acquire(&ptable.lock);
80104e02:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80104e09:	e8 82 06 00 00       	call   80105490 <acquire>

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
80104e0e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e15:	b8 54 51 11 80       	mov    $0x80115154,%eax
    proc->cwd = 0;

    acquire(&ptable.lock);

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
80104e1a:	8b 4a 14             	mov    0x14(%edx),%ecx
80104e1d:	eb 0d                	jmp    80104e2c <exit+0xac>
80104e1f:	90                   	nop
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e20:	05 9c 00 00 00       	add    $0x9c,%eax
80104e25:	3d 54 78 11 80       	cmp    $0x80117854,%eax
80104e2a:	74 1e                	je     80104e4a <exit+0xca>
        if(p->state == SLEEPING && p->chan == chan){
80104e2c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104e30:	75 ee                	jne    80104e20 <exit+0xa0>
80104e32:	3b 48 20             	cmp    0x20(%eax),%ecx
80104e35:	75 e9                	jne    80104e20 <exit+0xa0>
            p->state = RUNNABLE;
80104e37:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e3e:	05 9c 00 00 00       	add    $0x9c,%eax
80104e43:	3d 54 78 11 80       	cmp    $0x80117854,%eax
80104e48:	75 e2                	jne    80104e2c <exit+0xac>
80104e4a:	89 d1                	mov    %edx,%ecx
80104e4c:	bb 54 51 11 80       	mov    $0x80115154,%ebx
80104e51:	eb 13                	jmp    80104e66 <exit+0xe6>
80104e53:	90                   	nop
80104e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
       printPtable();
       */


    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e58:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80104e5e:	81 fb 54 78 11 80    	cmp    $0x80117854,%ebx
80104e64:	74 36                	je     80104e9c <exit+0x11c>
        if(p->parent == proc){
80104e66:	39 53 14             	cmp    %edx,0x14(%ebx)
80104e69:	75 ed                	jne    80104e58 <exit+0xd8>
            //ADDED - Clean threads of proc
            if(p->isthread == 1){
80104e6b:	66 83 bb 8c 00 00 00 	cmpw   $0x1,0x8c(%ebx)
80104e72:	01 
80104e73:	0f 84 db 00 00 00    	je     80104f54 <exit+0x1d4>
                release(&ptable.lock);
                thread_clean(p->tid,(void**)c_retval);
                acquire(&ptable.lock);
            }

            p->parent = initproc;
80104e79:	8b 0d bc c5 10 80    	mov    0x8010c5bc,%ecx
            if(p->state == ZOMBIE){
80104e7f:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
                release(&ptable.lock);
                thread_clean(p->tid,(void**)c_retval);
                acquire(&ptable.lock);
            }

            p->parent = initproc;
80104e83:	89 4b 14             	mov    %ecx,0x14(%ebx)
            if(p->state == ZOMBIE){
80104e86:	0f 84 9c 00 00 00    	je     80104f28 <exit+0x1a8>
       printPtable();
       */


    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e8c:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80104e92:	89 d1                	mov    %edx,%ecx
80104e94:	81 fb 54 78 11 80    	cmp    $0x80117854,%ebx
80104e9a:	75 ca                	jne    80104e66 <exit+0xe6>
    }


    // Jump into the scheduler, never to return.
    // for added
    if(proc->stride == 0)dequeue(&qOfM[proc->qPosi],proc);
80104e9c:	66 83 7a 7e 00       	cmpw   $0x0,0x7e(%edx)
80104ea1:	0f 84 e7 00 00 00    	je     80104f8e <exit+0x20e>
    proc->consumedTime = 0;
    if(proc->pid > 2 )cut_cpu_share(proc->stride);
80104ea7:	83 79 10 02          	cmpl   $0x2,0x10(%ecx)


    // Jump into the scheduler, never to return.
    // for added
    if(proc->stride == 0)dequeue(&qOfM[proc->qPosi],proc);
    proc->consumedTime = 0;
80104eab:	c7 81 88 00 00 00 00 	movl   $0x0,0x88(%ecx)
80104eb2:	00 00 00 
    if(proc->pid > 2 )cut_cpu_share(proc->stride);
80104eb5:	0f 8f 09 01 00 00    	jg     80104fc4 <exit+0x244>
    proc->stride = 0;
80104ebb:	31 c0                	xor    %eax,%eax
    proc->pass = 0;
    proc->qPosi = 0;
80104ebd:	31 d2                	xor    %edx,%edx
    // Jump into the scheduler, never to return.
    // for added
    if(proc->stride == 0)dequeue(&qOfM[proc->qPosi],proc);
    proc->consumedTime = 0;
    if(proc->pid > 2 )cut_cpu_share(proc->stride);
    proc->stride = 0;
80104ebf:	66 89 41 7e          	mov    %ax,0x7e(%ecx)
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ec3:	b8 54 51 11 80       	mov    $0x80115154,%eax
    if(proc->stride == 0)dequeue(&qOfM[proc->qPosi],proc);
    proc->consumedTime = 0;
    if(proc->pid > 2 )cut_cpu_share(proc->stride);
    proc->stride = 0;
    proc->pass = 0;
    proc->qPosi = 0;
80104ec8:	66 89 51 7c          	mov    %dx,0x7c(%ecx)

    //to confirm
    wakeup1(proc->parent);
80104ecc:	8b 51 14             	mov    0x14(%ecx),%edx
    // for added
    if(proc->stride == 0)dequeue(&qOfM[proc->qPosi],proc);
    proc->consumedTime = 0;
    if(proc->pid > 2 )cut_cpu_share(proc->stride);
    proc->stride = 0;
    proc->pass = 0;
80104ecf:	c7 81 84 00 00 00 00 	movl   $0x0,0x84(%ecx)
80104ed6:	00 00 00 
80104ed9:	eb 11                	jmp    80104eec <exit+0x16c>
80104edb:	90                   	nop
80104edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ee0:	05 9c 00 00 00       	add    $0x9c,%eax
80104ee5:	3d 54 78 11 80       	cmp    $0x80117854,%eax
80104eea:	74 1e                	je     80104f0a <exit+0x18a>
        if(p->state == SLEEPING && p->chan == chan){
80104eec:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104ef0:	75 ee                	jne    80104ee0 <exit+0x160>
80104ef2:	3b 50 20             	cmp    0x20(%eax),%edx
80104ef5:	75 e9                	jne    80104ee0 <exit+0x160>
            p->state = RUNNABLE;
80104ef7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104efe:	05 9c 00 00 00       	add    $0x9c,%eax
80104f03:	3d 54 78 11 80       	cmp    $0x80117854,%eax
80104f08:	75 e2                	jne    80104eec <exit+0x16c>
    proc->qPosi = 0;

    //to confirm
    wakeup1(proc->parent);

    proc->state = ZOMBIE;
80104f0a:	c7 41 0c 05 00 00 00 	movl   $0x5,0xc(%ecx)
      cprintf("-----------After------------\n");
    cprintf(    "exi : %d in : %d\n",proc->pid, proc->qPosi);
      printPtable();
      */

    sched();
80104f11:	e8 ea eb ff ff       	call   80103b00 <sched>
    panic("zombie exit");
80104f16:	c7 04 24 ec 95 10 80 	movl   $0x801095ec,(%esp)
80104f1d:	e8 3e b4 ff ff       	call   80100360 <panic>
80104f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                thread_clean(p->tid,(void**)c_retval);
                acquire(&ptable.lock);
            }

            p->parent = initproc;
            if(p->state == ZOMBIE){
80104f28:	b8 54 51 11 80       	mov    $0x80115154,%eax
80104f2d:	eb 11                	jmp    80104f40 <exit+0x1c0>
80104f2f:	90                   	nop
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f30:	05 9c 00 00 00       	add    $0x9c,%eax
80104f35:	3d 54 78 11 80       	cmp    $0x80117854,%eax
80104f3a:	0f 84 4c ff ff ff    	je     80104e8c <exit+0x10c>
        if(p->state == SLEEPING && p->chan == chan){
80104f40:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104f44:	75 ea                	jne    80104f30 <exit+0x1b0>
80104f46:	3b 48 20             	cmp    0x20(%eax),%ecx
80104f49:	75 e5                	jne    80104f30 <exit+0x1b0>
            p->state = RUNNABLE;
80104f4b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104f52:	eb dc                	jmp    80104f30 <exit+0x1b0>
    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->parent == proc){
            //ADDED - Clean threads of proc
            if(p->isthread == 1){
                release(&ptable.lock);
80104f54:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80104f5b:	e8 70 06 00 00       	call   801055d0 <release>
                thread_clean(p->tid,(void**)c_retval);
80104f60:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104f67:	00 
80104f68:	8b 83 98 00 00 00    	mov    0x98(%ebx),%eax
80104f6e:	89 04 24             	mov    %eax,(%esp)
80104f71:	e8 3a fb ff ff       	call   80104ab0 <thread_clean>
                acquire(&ptable.lock);
80104f76:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80104f7d:	e8 0e 05 00 00       	call   80105490 <acquire>
80104f82:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104f89:	e9 eb fe ff ff       	jmp    80104e79 <exit+0xf9>
    }


    // Jump into the scheduler, never to return.
    // for added
    if(proc->stride == 0)dequeue(&qOfM[proc->qPosi],proc);
80104f8e:	89 54 24 04          	mov    %edx,0x4(%esp)
80104f92:	0f b7 42 7c          	movzwl 0x7c(%edx),%eax
80104f96:	69 c0 10 01 00 00    	imul   $0x110,%eax,%eax
80104f9c:	05 00 20 11 80       	add    $0x80112000,%eax
80104fa1:	89 04 24             	mov    %eax,(%esp)
80104fa4:	e8 b7 38 00 00       	call   80108860 <dequeue>
80104fa9:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
    proc->consumedTime = 0;
    if(proc->pid > 2 )cut_cpu_share(proc->stride);
80104fb0:	83 79 10 02          	cmpl   $0x2,0x10(%ecx)


    // Jump into the scheduler, never to return.
    // for added
    if(proc->stride == 0)dequeue(&qOfM[proc->qPosi],proc);
    proc->consumedTime = 0;
80104fb4:	c7 81 88 00 00 00 00 	movl   $0x0,0x88(%ecx)
80104fbb:	00 00 00 
    if(proc->pid > 2 )cut_cpu_share(proc->stride);
80104fbe:	0f 8e f7 fe ff ff    	jle    80104ebb <exit+0x13b>
80104fc4:	0f b7 41 7e          	movzwl 0x7e(%ecx),%eax
80104fc8:	89 04 24             	mov    %eax,(%esp)
80104fcb:	e8 e0 3f 00 00       	call   80108fb0 <cut_cpu_share>
80104fd0:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80104fd7:	e9 df fe ff ff       	jmp    80104ebb <exit+0x13b>
    int fd;
    int c_retval = 0;


    if(proc->isthread == 1){
        return clean(proc->parent);
80104fdc:	8b 42 14             	mov    0x14(%edx),%eax
80104fdf:	89 04 24             	mov    %eax,(%esp)
80104fe2:	e8 49 fd ff ff       	call   80104d30 <clean>

    sched();
    panic("zombie exit");


}
80104fe7:	83 c4 10             	add    $0x10,%esp
80104fea:	5b                   	pop    %ebx
80104feb:	5e                   	pop    %esi
80104fec:	5d                   	pop    %ebp
80104fed:	c3                   	ret    
        return clean(proc->parent);

    }

    if(proc == initproc)
        panic("init exiting");
80104fee:	c7 04 24 df 95 10 80 	movl   $0x801095df,(%esp)
80104ff5:	e8 66 b3 ff ff       	call   80100360 <panic>
80104ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105000 <thread_fork>:
    target->context->eip = (uint)exit;
    swtch(&proc->context, target->context);
}
    int
thread_fork(void)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	57                   	push   %edi
80105004:	56                   	push   %esi
80105005:	53                   	push   %ebx
80105006:	83 ec 1c             	sub    $0x1c,%esp
    int i, pid;
    struct proc *np;
    uint tmp_ebp, sz;

    tmp_ebp = proc->parent->tf->ebp;
80105009:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010500f:	8b 40 14             	mov    0x14(%eax),%eax
80105012:	8b 40 18             	mov    0x18(%eax),%eax
80105015:	8b 40 08             	mov    0x8(%eax),%eax
80105018:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Allocate process.
    if((np = allocproc()) == 0){
8010501b:	e8 c0 e7 ff ff       	call   801037e0 <allocproc>
80105020:	85 c0                	test   %eax,%eax
80105022:	89 c3                	mov    %eax,%ebx
80105024:	0f 84 27 01 00 00    	je     80105151 <thread_fork+0x151>
        return -1;
    }


    // Copy process state from p.
    if((np->pgdir = copyuvm_force(proc->pgdir, proc->sz)) == 0){
8010502a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105030:	8b 10                	mov    (%eax),%edx
80105032:	89 54 24 04          	mov    %edx,0x4(%esp)
80105036:	8b 40 04             	mov    0x4(%eax),%eax
80105039:	89 04 24             	mov    %eax,(%esp)
8010503c:	e8 8f 33 00 00       	call   801083d0 <copyuvm_force>
80105041:	85 c0                	test   %eax,%eax
80105043:	89 43 04             	mov    %eax,0x4(%ebx)
80105046:	0f 84 0c 01 00 00    	je     80105158 <thread_fork+0x158>
        kfree(np->kstack);
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
    }
    np->sz = proc->sz;
8010504c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    np->parent = proc;
    *np->tf = *proc->tf;
80105052:	b9 13 00 00 00       	mov    $0x13,%ecx
80105057:	8b 7b 18             	mov    0x18(%ebx),%edi
        kfree(np->kstack);
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
    }
    np->sz = proc->sz;
8010505a:	8b 00                	mov    (%eax),%eax
8010505c:	89 03                	mov    %eax,(%ebx)
    np->parent = proc;
8010505e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105064:	89 43 14             	mov    %eax,0x14(%ebx)
    *np->tf = *proc->tf;
80105067:	8b 70 18             	mov    0x18(%eax),%esi


    //ADDED
    //dealocate thread stack
    sz = PGROUNDUP(np->sz)- 2*PGSIZE;
    if((sz = deallocuvm(np->pgdir, sz, tmp_ebp)) == 0){
8010506a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        np->state = UNUSED;
        return -1;
    }
    np->sz = proc->sz;
    np->parent = proc;
    *np->tf = *proc->tf;
8010506d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)


    //ADDED
    //dealocate thread stack
    sz = PGROUNDUP(np->sz)- 2*PGSIZE;
    if((sz = deallocuvm(np->pgdir, sz, tmp_ebp)) == 0){
8010506f:	89 44 24 08          	mov    %eax,0x8(%esp)
    *np->tf = *proc->tf;


    //ADDED
    //dealocate thread stack
    sz = PGROUNDUP(np->sz)- 2*PGSIZE;
80105073:	8b 03                	mov    (%ebx),%eax
80105075:	05 ff 0f 00 00       	add    $0xfff,%eax
8010507a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010507f:	2d 00 20 00 00       	sub    $0x2000,%eax
    if((sz = deallocuvm(np->pgdir, sz, tmp_ebp)) == 0){
80105084:	89 44 24 04          	mov    %eax,0x4(%esp)
80105088:	8b 43 04             	mov    0x4(%ebx),%eax
8010508b:	89 04 24             	mov    %eax,(%esp)
8010508e:	e8 4d 30 00 00       	call   801080e0 <deallocuvm>
80105093:	85 c0                	test   %eax,%eax
80105095:	0f 84 a5 00 00 00    	je     80105140 <thread_fork+0x140>
        cprintf("new process that forked by thread meets error\n");
    }


    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
8010509b:	8b 43 18             	mov    0x18(%ebx),%eax


    for(i = 0; i < NOFILE; i++)
8010509e:	31 f6                	xor    %esi,%esi
801050a0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
        cprintf("new process that forked by thread meets error\n");
    }


    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
801050a7:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801050ae:	66 90                	xchg   %ax,%ax


    for(i = 0; i < NOFILE; i++)
        if(proc->ofile[i])
801050b0:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
801050b4:	85 c0                	test   %eax,%eax
801050b6:	74 13                	je     801050cb <thread_fork+0xcb>
            np->ofile[i] = filedup(proc->ofile[i]);
801050b8:	89 04 24             	mov    %eax,(%esp)
801050bb:	e8 30 bd ff ff       	call   80100df0 <filedup>
801050c0:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
801050c4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;


    for(i = 0; i < NOFILE; i++)
801050cb:	83 c6 01             	add    $0x1,%esi
801050ce:	83 fe 10             	cmp    $0x10,%esi
801050d1:	75 dd                	jne    801050b0 <thread_fork+0xb0>
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);
    np->cwd = idup(proc->cwd);
801050d3:	8b 42 68             	mov    0x68(%edx),%eax
801050d6:	89 04 24             	mov    %eax,(%esp)
801050d9:	e8 72 c6 ff ff       	call   80101750 <idup>
801050de:	89 43 68             	mov    %eax,0x68(%ebx)

    safestrcpy(np->name, proc->name, sizeof(proc->name));
801050e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050e7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801050ee:	00 
801050ef:	83 c0 6c             	add    $0x6c,%eax
801050f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801050f6:	8d 43 6c             	lea    0x6c(%ebx),%eax
801050f9:	89 04 24             	mov    %eax,(%esp)
801050fc:	e8 ff 06 00 00       	call   80105800 <safestrcpy>

    pid = np->pid;
80105101:	8b 73 10             	mov    0x10(%ebx),%esi

    acquire(&ptable.lock);
80105104:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
8010510b:	e8 80 03 00 00       	call   80105490 <acquire>

    np->state = RUNNABLE;
80105110:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    //ADDED
    enqueue(&qOfM[0],np);
80105117:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010511b:	c7 04 24 00 20 11 80 	movl   $0x80112000,(%esp)
80105122:	e8 99 35 00 00       	call   801086c0 <enqueue>

    release(&ptable.lock);
80105127:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
8010512e:	e8 9d 04 00 00       	call   801055d0 <release>

    return pid;
80105133:	89 f0                	mov    %esi,%eax
}
80105135:	83 c4 1c             	add    $0x1c,%esp
80105138:	5b                   	pop    %ebx
80105139:	5e                   	pop    %esi
8010513a:	5f                   	pop    %edi
8010513b:	5d                   	pop    %ebp
8010513c:	c3                   	ret    
8010513d:	8d 76 00             	lea    0x0(%esi),%esi

    //ADDED
    //dealocate thread stack
    sz = PGROUNDUP(np->sz)- 2*PGSIZE;
    if((sz = deallocuvm(np->pgdir, sz, tmp_ebp)) == 0){
        cprintf("new process that forked by thread meets error\n");
80105140:	c7 04 24 3c 97 10 80 	movl   $0x8010973c,(%esp)
80105147:	e8 04 b5 ff ff       	call   80100650 <cprintf>
8010514c:	e9 4a ff ff ff       	jmp    8010509b <thread_fork+0x9b>
    uint tmp_ebp, sz;

    tmp_ebp = proc->parent->tf->ebp;
    // Allocate process.
    if((np = allocproc()) == 0){
        return -1;
80105151:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105156:	eb dd                	jmp    80105135 <thread_fork+0x135>
    }


    // Copy process state from p.
    if((np->pgdir = copyuvm_force(proc->pgdir, proc->sz)) == 0){
        cprintf("hello??\n");
80105158:	c7 04 24 2f 96 10 80 	movl   $0x8010962f,(%esp)
8010515f:	e8 ec b4 ff ff       	call   80100650 <cprintf>
        kfree(np->kstack);
80105164:	8b 43 08             	mov    0x8(%ebx),%eax
80105167:	89 04 24             	mov    %eax,(%esp)
8010516a:	e8 21 d3 ff ff       	call   80102490 <kfree>
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
8010516f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

    // Copy process state from p.
    if((np->pgdir = copyuvm_force(proc->pgdir, proc->sz)) == 0){
        cprintf("hello??\n");
        kfree(np->kstack);
        np->kstack = 0;
80105174:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->state = UNUSED;
8010517b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return -1;
80105182:	eb b1                	jmp    80105135 <thread_fork+0x135>
80105184:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010518a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105190 <fork>:
    int i, pid;
    struct proc *np;
    //struct proc *iter;


    if(proc->isthread == 1){
80105190:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105196:	66 83 b8 8c 00 00 00 	cmpw   $0x1,0x8c(%eax)
8010519d:	01 
8010519e:	0f 84 04 01 00 00    	je     801052a8 <fork+0x118>
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
    int
fork(void)
{
801051a4:	55                   	push   %ebp
801051a5:	89 e5                	mov    %esp,%ebp
801051a7:	57                   	push   %edi
801051a8:	56                   	push   %esi
801051a9:	53                   	push   %ebx
801051aa:	83 ec 1c             	sub    $0x1c,%esp
        return thread_fork();
    }


    // Allocate process.
    if((np = allocproc()) == 0){
801051ad:	e8 2e e6 ff ff       	call   801037e0 <allocproc>
801051b2:	85 c0                	test   %eax,%eax
801051b4:	89 c3                	mov    %eax,%ebx
801051b6:	0f 84 f1 00 00 00    	je     801052ad <fork+0x11d>
        return -1;
    }

    // Copy process state from p.
    if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801051bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051c2:	8b 10                	mov    (%eax),%edx
801051c4:	89 54 24 04          	mov    %edx,0x4(%esp)
801051c8:	8b 40 04             	mov    0x4(%eax),%eax
801051cb:	89 04 24             	mov    %eax,(%esp)
801051ce:	e8 dd 2f 00 00       	call   801081b0 <copyuvm>
801051d3:	85 c0                	test   %eax,%eax
801051d5:	89 43 04             	mov    %eax,0x4(%ebx)
801051d8:	0f 84 d6 00 00 00    	je     801052b4 <fork+0x124>
        kfree(np->kstack);
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
    }
    np->sz = proc->sz;
801051de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    np->parent = proc;
    *np->tf = *proc->tf;
801051e4:	b9 13 00 00 00       	mov    $0x13,%ecx
801051e9:	8b 7b 18             	mov    0x18(%ebx),%edi
        kfree(np->kstack);
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
    }
    np->sz = proc->sz;
801051ec:	8b 00                	mov    (%eax),%eax
801051ee:	89 03                	mov    %eax,(%ebx)
    np->parent = proc;
801051f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051f6:	89 43 14             	mov    %eax,0x14(%ebx)
    *np->tf = *proc->tf;
801051f9:	8b 70 18             	mov    0x18(%eax),%esi
801051fc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for(i = 0; i < NOFILE; i++)
801051fe:	31 f6                	xor    %esi,%esi
    np->sz = proc->sz;
    np->parent = proc;
    *np->tf = *proc->tf;

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
80105200:	8b 43 18             	mov    0x18(%ebx),%eax
80105203:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010520a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80105211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    for(i = 0; i < NOFILE; i++)
        if(proc->ofile[i])
80105218:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
8010521c:	85 c0                	test   %eax,%eax
8010521e:	74 13                	je     80105233 <fork+0xa3>
            np->ofile[i] = filedup(proc->ofile[i]);
80105220:	89 04 24             	mov    %eax,(%esp)
80105223:	e8 c8 bb ff ff       	call   80100df0 <filedup>
80105228:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
8010522c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
    *np->tf = *proc->tf;

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for(i = 0; i < NOFILE; i++)
80105233:	83 c6 01             	add    $0x1,%esi
80105236:	83 fe 10             	cmp    $0x10,%esi
80105239:	75 dd                	jne    80105218 <fork+0x88>
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);
    np->cwd = idup(proc->cwd);
8010523b:	8b 42 68             	mov    0x68(%edx),%eax
8010523e:	89 04 24             	mov    %eax,(%esp)
80105241:	e8 0a c5 ff ff       	call   80101750 <idup>
80105246:	89 43 68             	mov    %eax,0x68(%ebx)

    safestrcpy(np->name, proc->name, sizeof(proc->name));
80105249:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010524f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105256:	00 
80105257:	83 c0 6c             	add    $0x6c,%eax
8010525a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010525e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80105261:	89 04 24             	mov    %eax,(%esp)
80105264:	e8 97 05 00 00       	call   80105800 <safestrcpy>

    pid = np->pid;
80105269:	8b 73 10             	mov    0x10(%ebx),%esi

    acquire(&ptable.lock);
8010526c:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80105273:	e8 18 02 00 00       	call   80105490 <acquire>

    np->state = RUNNABLE;
80105278:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    //for added
    enqueue(&qOfM[0],np);
8010527f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105283:	c7 04 24 00 20 11 80 	movl   $0x80112000,(%esp)
8010528a:	e8 31 34 00 00       	call   801086c0 <enqueue>

    release(&ptable.lock);
8010528f:	c7 04 24 20 51 11 80 	movl   $0x80115120,(%esp)
80105296:	e8 35 03 00 00       	call   801055d0 <release>

    return pid;
8010529b:	89 f0                	mov    %esi,%eax
}
8010529d:	83 c4 1c             	add    $0x1c,%esp
801052a0:	5b                   	pop    %ebx
801052a1:	5e                   	pop    %esi
801052a2:	5f                   	pop    %edi
801052a3:	5d                   	pop    %ebp
801052a4:	c3                   	ret    
801052a5:	8d 76 00             	lea    0x0(%esi),%esi
    struct proc *np;
    //struct proc *iter;


    if(proc->isthread == 1){
        return thread_fork();
801052a8:	e9 53 fd ff ff       	jmp    80105000 <thread_fork>
    }


    // Allocate process.
    if((np = allocproc()) == 0){
        return -1;
801052ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052b2:	eb e9                	jmp    8010529d <fork+0x10d>
    }

    // Copy process state from p.
    if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
        kfree(np->kstack);
801052b4:	8b 43 08             	mov    0x8(%ebx),%eax
801052b7:	89 04 24             	mov    %eax,(%esp)
801052ba:	e8 d1 d1 ff ff       	call   80102490 <kfree>
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
801052bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Copy process state from p.
    if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
        kfree(np->kstack);
        np->kstack = 0;
801052c4:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->state = UNUSED;
801052cb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return -1;
801052d2:	eb c9                	jmp    8010529d <fork+0x10d>
801052d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801052da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801052e0 <share_stride_in_proc>:

    return pid;
}

void
share_stride_in_proc(struct proc* parent){
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	8b 45 08             	mov    0x8(%ebp),%eax
    struct proc* p;
    ushort real_stride;
    ushort each_stride;

    if(parent->stride == 0) return ;
801052e6:	66 83 78 7e 00       	cmpw   $0x0,0x7e(%eax)
801052eb:	75 03                	jne    801052f0 <share_stride_in_proc+0x10>
        p->stride = each_stride;
        p->pass = minPass;

    }
    parent->stride = each_stride;
}
801052ed:	5d                   	pop    %ebp
801052ee:	c3                   	ret    
801052ef:	90                   	nop
801052f0:	5d                   	pop    %ebp
801052f1:	e9 aa f0 ff ff       	jmp    801043a0 <share_stride_in_proc.part.1>
801052f6:	66 90                	xchg   %ax,%ax
801052f8:	66 90                	xchg   %ax,%ax
801052fa:	66 90                	xchg   %ax,%ax
801052fc:	66 90                	xchg   %ax,%ax
801052fe:	66 90                	xchg   %ax,%ax

80105300 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	53                   	push   %ebx
80105304:	83 ec 14             	sub    $0x14,%esp
80105307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010530a:	c7 44 24 04 84 97 10 	movl   $0x80109784,0x4(%esp)
80105311:	80 
80105312:	8d 43 04             	lea    0x4(%ebx),%eax
80105315:	89 04 24             	mov    %eax,(%esp)
80105318:	e8 f3 00 00 00       	call   80105410 <initlock>
  lk->name = name;
8010531d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80105320:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80105326:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010532d:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80105330:	83 c4 14             	add    $0x14,%esp
80105333:	5b                   	pop    %ebx
80105334:	5d                   	pop    %ebp
80105335:	c3                   	ret    
80105336:	8d 76 00             	lea    0x0(%esi),%esi
80105339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105340 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	56                   	push   %esi
80105344:	53                   	push   %ebx
80105345:	83 ec 10             	sub    $0x10,%esp
80105348:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010534b:	8d 73 04             	lea    0x4(%ebx),%esi
8010534e:	89 34 24             	mov    %esi,(%esp)
80105351:	e8 3a 01 00 00       	call   80105490 <acquire>
  while (lk->locked) {
80105356:	8b 13                	mov    (%ebx),%edx
80105358:	85 d2                	test   %edx,%edx
8010535a:	74 16                	je     80105372 <acquiresleep+0x32>
8010535c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80105360:	89 74 24 04          	mov    %esi,0x4(%esp)
80105364:	89 1c 24             	mov    %ebx,(%esp)
80105367:	e8 d4 e8 ff ff       	call   80103c40 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010536c:	8b 03                	mov    (%ebx),%eax
8010536e:	85 c0                	test   %eax,%eax
80105370:	75 ee                	jne    80105360 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80105372:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = proc->pid;
80105378:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010537e:	8b 40 10             	mov    0x10(%eax),%eax
80105381:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105384:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105387:	83 c4 10             	add    $0x10,%esp
8010538a:	5b                   	pop    %ebx
8010538b:	5e                   	pop    %esi
8010538c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = proc->pid;
  release(&lk->lk);
8010538d:	e9 3e 02 00 00       	jmp    801055d0 <release>
80105392:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053a0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	56                   	push   %esi
801053a4:	53                   	push   %ebx
801053a5:	83 ec 10             	sub    $0x10,%esp
801053a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801053ab:	8d 73 04             	lea    0x4(%ebx),%esi
801053ae:	89 34 24             	mov    %esi,(%esp)
801053b1:	e8 da 00 00 00       	call   80105490 <acquire>
  lk->locked = 0;
801053b6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801053bc:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801053c3:	89 1c 24             	mov    %ebx,(%esp)
801053c6:	e8 25 ea ff ff       	call   80103df0 <wakeup>
  release(&lk->lk);
801053cb:	89 75 08             	mov    %esi,0x8(%ebp)
}
801053ce:	83 c4 10             	add    $0x10,%esp
801053d1:	5b                   	pop    %ebx
801053d2:	5e                   	pop    %esi
801053d3:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
801053d4:	e9 f7 01 00 00       	jmp    801055d0 <release>
801053d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053e0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	56                   	push   %esi
801053e4:	53                   	push   %ebx
801053e5:	83 ec 10             	sub    $0x10,%esp
801053e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801053eb:	8d 73 04             	lea    0x4(%ebx),%esi
801053ee:	89 34 24             	mov    %esi,(%esp)
801053f1:	e8 9a 00 00 00       	call   80105490 <acquire>
  r = lk->locked;
801053f6:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
801053f8:	89 34 24             	mov    %esi,(%esp)
801053fb:	e8 d0 01 00 00       	call   801055d0 <release>
  return r;
}
80105400:	83 c4 10             	add    $0x10,%esp
80105403:	89 d8                	mov    %ebx,%eax
80105405:	5b                   	pop    %ebx
80105406:	5e                   	pop    %esi
80105407:	5d                   	pop    %ebp
80105408:	c3                   	ret    
80105409:	66 90                	xchg   %ax,%ax
8010540b:	66 90                	xchg   %ax,%ax
8010540d:	66 90                	xchg   %ax,%ax
8010540f:	90                   	nop

80105410 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105416:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105419:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010541f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80105422:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105429:	5d                   	pop    %ebp
8010542a:	c3                   	ret    
8010542b:	90                   	nop
8010542c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105430 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80105433:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105436:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105439:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010543a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010543d:	31 c0                	xor    %eax,%eax
8010543f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105440:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80105446:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010544c:	77 1a                	ja     80105468 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010544e:	8b 5a 04             	mov    0x4(%edx),%ebx
80105451:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105454:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80105457:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105459:	83 f8 0a             	cmp    $0xa,%eax
8010545c:	75 e2                	jne    80105440 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010545e:	5b                   	pop    %ebx
8010545f:	5d                   	pop    %ebp
80105460:	c3                   	ret    
80105461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80105468:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010546f:	83 c0 01             	add    $0x1,%eax
80105472:	83 f8 0a             	cmp    $0xa,%eax
80105475:	74 e7                	je     8010545e <getcallerpcs+0x2e>
    pcs[i] = 0;
80105477:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010547e:	83 c0 01             	add    $0x1,%eax
80105481:	83 f8 0a             	cmp    $0xa,%eax
80105484:	75 e2                	jne    80105468 <getcallerpcs+0x38>
80105486:	eb d6                	jmp    8010545e <getcallerpcs+0x2e>
80105488:	90                   	nop
80105489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105490 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105496:	9c                   	pushf  
80105497:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
80105498:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
80105499:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010549f:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801054a5:	85 d2                	test   %edx,%edx
801054a7:	75 0c                	jne    801054b5 <acquire+0x25>
    cpu->intena = eflags & FL_IF;
801054a9:	81 e1 00 02 00 00    	and    $0x200,%ecx
801054af:	89 88 b0 00 00 00    	mov    %ecx,0xb0(%eax)
  cpu->ncli += 1;
801054b5:	83 c2 01             	add    $0x1,%edx
801054b8:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk)){
801054be:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
801054c1:	8b 0a                	mov    (%edx),%ecx
801054c3:	85 c9                	test   %ecx,%ecx
801054c5:	74 05                	je     801054cc <acquire+0x3c>
801054c7:	3b 42 08             	cmp    0x8(%edx),%eax
801054ca:	74 3e                	je     8010550a <acquire+0x7a>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801054cc:	b9 01 00 00 00       	mov    $0x1,%ecx
801054d1:	eb 08                	jmp    801054db <acquire+0x4b>
801054d3:	90                   	nop
801054d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054d8:	8b 55 08             	mov    0x8(%ebp),%edx
801054db:	89 c8                	mov    %ecx,%eax
801054dd:	f0 87 02             	lock xchg %eax,(%edx)
      cprintf("%s acquire\n",lk->name);
    //panic("acquire");
  }

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801054e0:	85 c0                	test   %eax,%eax
801054e2:	75 f4                	jne    801054d8 <acquire+0x48>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801054e4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801054e9:	8b 45 08             	mov    0x8(%ebp),%eax
801054ec:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  getcallerpcs(&lk, lk->pcs);
801054f3:	83 c0 0c             	add    $0xc,%eax
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801054f6:	89 50 fc             	mov    %edx,-0x4(%eax)
  getcallerpcs(&lk, lk->pcs);
801054f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801054fd:	8d 45 08             	lea    0x8(%ebp),%eax
80105500:	89 04 24             	mov    %eax,(%esp)
80105503:	e8 28 ff ff ff       	call   80105430 <getcallerpcs>
}
80105508:	c9                   	leave  
80105509:	c3                   	ret    
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk)){
      cprintf("%s acquire\n",lk->name);
8010550a:	8b 42 04             	mov    0x4(%edx),%eax
8010550d:	c7 04 24 8f 97 10 80 	movl   $0x8010978f,(%esp)
80105514:	89 44 24 04          	mov    %eax,0x4(%esp)
80105518:	e8 33 b1 ff ff       	call   80100650 <cprintf>
8010551d:	8b 55 08             	mov    0x8(%ebp),%edx
80105520:	eb aa                	jmp    801054cc <acquire+0x3c>
80105522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105530 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105530:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu;
80105531:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105533:	89 e5                	mov    %esp,%ebp
80105535:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
80105538:	8b 0a                	mov    (%edx),%ecx
8010553a:	85 c9                	test   %ecx,%ecx
8010553c:	74 0f                	je     8010554d <holding+0x1d>
8010553e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105544:	39 42 08             	cmp    %eax,0x8(%edx)
80105547:	0f 94 c0             	sete   %al
8010554a:	0f b6 c0             	movzbl %al,%eax
}
8010554d:	5d                   	pop    %ebp
8010554e:	c3                   	ret    
8010554f:	90                   	nop

80105550 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105553:	9c                   	pushf  
80105554:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
80105555:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
80105556:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010555c:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105562:	85 d2                	test   %edx,%edx
80105564:	75 0c                	jne    80105572 <pushcli+0x22>
    cpu->intena = eflags & FL_IF;
80105566:	81 e1 00 02 00 00    	and    $0x200,%ecx
8010556c:	89 88 b0 00 00 00    	mov    %ecx,0xb0(%eax)
  cpu->ncli += 1;
80105572:	83 c2 01             	add    $0x1,%edx
80105575:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
}
8010557b:	5d                   	pop    %ebp
8010557c:	c3                   	ret    
8010557d:	8d 76 00             	lea    0x0(%esi),%esi

80105580 <popcli>:

void
popcli(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105586:	9c                   	pushf  
80105587:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105588:	f6 c4 02             	test   $0x2,%ah
8010558b:	75 34                	jne    801055c1 <popcli+0x41>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
8010558d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105593:	8b 88 ac 00 00 00    	mov    0xac(%eax),%ecx
80105599:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010559c:	85 d2                	test   %edx,%edx
8010559e:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801055a4:	78 0f                	js     801055b5 <popcli+0x35>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
801055a6:	75 0b                	jne    801055b3 <popcli+0x33>
801055a8:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801055ae:	85 c0                	test   %eax,%eax
801055b0:	74 01                	je     801055b3 <popcli+0x33>
}

static inline void
sti(void)
{
  asm volatile("sti");
801055b2:	fb                   	sti    
    sti();
}
801055b3:	c9                   	leave  
801055b4:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
801055b5:	c7 04 24 b2 97 10 80 	movl   $0x801097b2,(%esp)
801055bc:	e8 9f ad ff ff       	call   80100360 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
801055c1:	c7 04 24 9b 97 10 80 	movl   $0x8010979b,(%esp)
801055c8:	e8 93 ad ff ff       	call   80100360 <panic>
801055cd:	8d 76 00             	lea    0x0(%esi),%esi

801055d0 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	83 ec 18             	sub    $0x18,%esp
801055d6:	8b 45 08             	mov    0x8(%ebp),%eax

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
801055d9:	8b 10                	mov    (%eax),%edx
801055db:	85 d2                	test   %edx,%edx
801055dd:	74 0c                	je     801055eb <release+0x1b>
801055df:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801055e6:	39 50 08             	cmp    %edx,0x8(%eax)
801055e9:	74 0d                	je     801055f8 <release+0x28>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
801055eb:	c7 04 24 b9 97 10 80 	movl   $0x801097b9,(%esp)
801055f2:	e8 69 ad ff ff       	call   80100360 <panic>
801055f7:	90                   	nop

  lk->pcs[0] = 0;
801055f8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801055ff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80105606:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010560b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
}
80105611:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80105612:	e9 69 ff ff ff       	jmp    80105580 <popcli>
80105617:	66 90                	xchg   %ax,%ax
80105619:	66 90                	xchg   %ax,%ax
8010561b:	66 90                	xchg   %ax,%ax
8010561d:	66 90                	xchg   %ax,%ax
8010561f:	90                   	nop

80105620 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	8b 55 08             	mov    0x8(%ebp),%edx
80105626:	57                   	push   %edi
80105627:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010562a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010562b:	f6 c2 03             	test   $0x3,%dl
8010562e:	75 05                	jne    80105635 <memset+0x15>
80105630:	f6 c1 03             	test   $0x3,%cl
80105633:	74 13                	je     80105648 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80105635:	89 d7                	mov    %edx,%edi
80105637:	8b 45 0c             	mov    0xc(%ebp),%eax
8010563a:	fc                   	cld    
8010563b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010563d:	5b                   	pop    %ebx
8010563e:	89 d0                	mov    %edx,%eax
80105640:	5f                   	pop    %edi
80105641:	5d                   	pop    %ebp
80105642:	c3                   	ret    
80105643:	90                   	nop
80105644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80105648:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010564c:	c1 e9 02             	shr    $0x2,%ecx
8010564f:	89 f8                	mov    %edi,%eax
80105651:	89 fb                	mov    %edi,%ebx
80105653:	c1 e0 18             	shl    $0x18,%eax
80105656:	c1 e3 10             	shl    $0x10,%ebx
80105659:	09 d8                	or     %ebx,%eax
8010565b:	09 f8                	or     %edi,%eax
8010565d:	c1 e7 08             	shl    $0x8,%edi
80105660:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80105662:	89 d7                	mov    %edx,%edi
80105664:	fc                   	cld    
80105665:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105667:	5b                   	pop    %ebx
80105668:	89 d0                	mov    %edx,%eax
8010566a:	5f                   	pop    %edi
8010566b:	5d                   	pop    %ebp
8010566c:	c3                   	ret    
8010566d:	8d 76 00             	lea    0x0(%esi),%esi

80105670 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	8b 45 10             	mov    0x10(%ebp),%eax
80105676:	57                   	push   %edi
80105677:	56                   	push   %esi
80105678:	8b 75 0c             	mov    0xc(%ebp),%esi
8010567b:	53                   	push   %ebx
8010567c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010567f:	85 c0                	test   %eax,%eax
80105681:	8d 78 ff             	lea    -0x1(%eax),%edi
80105684:	74 26                	je     801056ac <memcmp+0x3c>
    if(*s1 != *s2)
80105686:	0f b6 03             	movzbl (%ebx),%eax
80105689:	31 d2                	xor    %edx,%edx
8010568b:	0f b6 0e             	movzbl (%esi),%ecx
8010568e:	38 c8                	cmp    %cl,%al
80105690:	74 16                	je     801056a8 <memcmp+0x38>
80105692:	eb 24                	jmp    801056b8 <memcmp+0x48>
80105694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105698:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010569d:	83 c2 01             	add    $0x1,%edx
801056a0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801056a4:	38 c8                	cmp    %cl,%al
801056a6:	75 10                	jne    801056b8 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801056a8:	39 fa                	cmp    %edi,%edx
801056aa:	75 ec                	jne    80105698 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801056ac:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801056ad:	31 c0                	xor    %eax,%eax
}
801056af:	5e                   	pop    %esi
801056b0:	5f                   	pop    %edi
801056b1:	5d                   	pop    %ebp
801056b2:	c3                   	ret    
801056b3:	90                   	nop
801056b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056b8:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
801056b9:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
801056bb:	5e                   	pop    %esi
801056bc:	5f                   	pop    %edi
801056bd:	5d                   	pop    %ebp
801056be:	c3                   	ret    
801056bf:	90                   	nop

801056c0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	57                   	push   %edi
801056c4:	8b 45 08             	mov    0x8(%ebp),%eax
801056c7:	56                   	push   %esi
801056c8:	8b 75 0c             	mov    0xc(%ebp),%esi
801056cb:	53                   	push   %ebx
801056cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801056cf:	39 c6                	cmp    %eax,%esi
801056d1:	73 35                	jae    80105708 <memmove+0x48>
801056d3:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
801056d6:	39 c8                	cmp    %ecx,%eax
801056d8:	73 2e                	jae    80105708 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
801056da:	85 db                	test   %ebx,%ebx

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
801056dc:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
801056df:	8d 53 ff             	lea    -0x1(%ebx),%edx
801056e2:	74 1b                	je     801056ff <memmove+0x3f>
801056e4:	f7 db                	neg    %ebx
801056e6:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
801056e9:	01 fb                	add    %edi,%ebx
801056eb:	90                   	nop
801056ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801056f0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801056f4:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801056f7:	83 ea 01             	sub    $0x1,%edx
801056fa:	83 fa ff             	cmp    $0xffffffff,%edx
801056fd:	75 f1                	jne    801056f0 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801056ff:	5b                   	pop    %ebx
80105700:	5e                   	pop    %esi
80105701:	5f                   	pop    %edi
80105702:	5d                   	pop    %ebp
80105703:	c3                   	ret    
80105704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105708:	31 d2                	xor    %edx,%edx
8010570a:	85 db                	test   %ebx,%ebx
8010570c:	74 f1                	je     801056ff <memmove+0x3f>
8010570e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105710:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80105714:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105717:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010571a:	39 da                	cmp    %ebx,%edx
8010571c:	75 f2                	jne    80105710 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010571e:	5b                   	pop    %ebx
8010571f:	5e                   	pop    %esi
80105720:	5f                   	pop    %edi
80105721:	5d                   	pop    %ebp
80105722:	c3                   	ret    
80105723:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105730 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105733:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80105734:	e9 87 ff ff ff       	jmp    801056c0 <memmove>
80105739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105740 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	56                   	push   %esi
80105744:	8b 75 10             	mov    0x10(%ebp),%esi
80105747:	53                   	push   %ebx
80105748:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010574b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
8010574e:	85 f6                	test   %esi,%esi
80105750:	74 30                	je     80105782 <strncmp+0x42>
80105752:	0f b6 01             	movzbl (%ecx),%eax
80105755:	84 c0                	test   %al,%al
80105757:	74 2f                	je     80105788 <strncmp+0x48>
80105759:	0f b6 13             	movzbl (%ebx),%edx
8010575c:	38 d0                	cmp    %dl,%al
8010575e:	75 46                	jne    801057a6 <strncmp+0x66>
80105760:	8d 51 01             	lea    0x1(%ecx),%edx
80105763:	01 ce                	add    %ecx,%esi
80105765:	eb 14                	jmp    8010577b <strncmp+0x3b>
80105767:	90                   	nop
80105768:	0f b6 02             	movzbl (%edx),%eax
8010576b:	84 c0                	test   %al,%al
8010576d:	74 31                	je     801057a0 <strncmp+0x60>
8010576f:	0f b6 19             	movzbl (%ecx),%ebx
80105772:	83 c2 01             	add    $0x1,%edx
80105775:	38 d8                	cmp    %bl,%al
80105777:	75 17                	jne    80105790 <strncmp+0x50>
    n--, p++, q++;
80105779:	89 cb                	mov    %ecx,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010577b:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
8010577d:	8d 4b 01             	lea    0x1(%ebx),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105780:	75 e6                	jne    80105768 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105782:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80105783:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80105785:	5e                   	pop    %esi
80105786:	5d                   	pop    %ebp
80105787:	c3                   	ret    
80105788:	0f b6 1b             	movzbl (%ebx),%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010578b:	31 c0                	xor    %eax,%eax
8010578d:	8d 76 00             	lea    0x0(%esi),%esi
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105790:	0f b6 d3             	movzbl %bl,%edx
80105793:	29 d0                	sub    %edx,%eax
}
80105795:	5b                   	pop    %ebx
80105796:	5e                   	pop    %esi
80105797:	5d                   	pop    %ebp
80105798:	c3                   	ret    
80105799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057a0:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
801057a4:	eb ea                	jmp    80105790 <strncmp+0x50>
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801057a6:	89 d3                	mov    %edx,%ebx
801057a8:	eb e6                	jmp    80105790 <strncmp+0x50>
801057aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801057b0 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	8b 45 08             	mov    0x8(%ebp),%eax
801057b6:	56                   	push   %esi
801057b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801057ba:	53                   	push   %ebx
801057bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801057be:	89 c2                	mov    %eax,%edx
801057c0:	eb 19                	jmp    801057db <strncpy+0x2b>
801057c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801057c8:	83 c3 01             	add    $0x1,%ebx
801057cb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801057cf:	83 c2 01             	add    $0x1,%edx
801057d2:	84 c9                	test   %cl,%cl
801057d4:	88 4a ff             	mov    %cl,-0x1(%edx)
801057d7:	74 09                	je     801057e2 <strncpy+0x32>
801057d9:	89 f1                	mov    %esi,%ecx
801057db:	85 c9                	test   %ecx,%ecx
801057dd:	8d 71 ff             	lea    -0x1(%ecx),%esi
801057e0:	7f e6                	jg     801057c8 <strncpy+0x18>
    ;
  while(n-- > 0)
801057e2:	31 c9                	xor    %ecx,%ecx
801057e4:	85 f6                	test   %esi,%esi
801057e6:	7e 0f                	jle    801057f7 <strncpy+0x47>
    *s++ = 0;
801057e8:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801057ec:	89 f3                	mov    %esi,%ebx
801057ee:	83 c1 01             	add    $0x1,%ecx
801057f1:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801057f3:	85 db                	test   %ebx,%ebx
801057f5:	7f f1                	jg     801057e8 <strncpy+0x38>
    *s++ = 0;
  return os;
}
801057f7:	5b                   	pop    %ebx
801057f8:	5e                   	pop    %esi
801057f9:	5d                   	pop    %ebp
801057fa:	c3                   	ret    
801057fb:	90                   	nop
801057fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105800 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105806:	56                   	push   %esi
80105807:	8b 45 08             	mov    0x8(%ebp),%eax
8010580a:	53                   	push   %ebx
8010580b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010580e:	85 c9                	test   %ecx,%ecx
80105810:	7e 26                	jle    80105838 <safestrcpy+0x38>
80105812:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105816:	89 c1                	mov    %eax,%ecx
80105818:	eb 17                	jmp    80105831 <safestrcpy+0x31>
8010581a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105820:	83 c2 01             	add    $0x1,%edx
80105823:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105827:	83 c1 01             	add    $0x1,%ecx
8010582a:	84 db                	test   %bl,%bl
8010582c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010582f:	74 04                	je     80105835 <safestrcpy+0x35>
80105831:	39 f2                	cmp    %esi,%edx
80105833:	75 eb                	jne    80105820 <safestrcpy+0x20>
    ;
  *s = 0;
80105835:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105838:	5b                   	pop    %ebx
80105839:	5e                   	pop    %esi
8010583a:	5d                   	pop    %ebp
8010583b:	c3                   	ret    
8010583c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105840 <strlen>:

int
strlen(const char *s)
{
80105840:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105841:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80105843:	89 e5                	mov    %esp,%ebp
80105845:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80105848:	80 3a 00             	cmpb   $0x0,(%edx)
8010584b:	74 0c                	je     80105859 <strlen+0x19>
8010584d:	8d 76 00             	lea    0x0(%esi),%esi
80105850:	83 c0 01             	add    $0x1,%eax
80105853:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105857:	75 f7                	jne    80105850 <strlen+0x10>
    ;
  return n;
}
80105859:	5d                   	pop    %ebp
8010585a:	c3                   	ret    

8010585b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010585b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010585f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105863:	55                   	push   %ebp
  pushl %ebx
80105864:	53                   	push   %ebx
  pushl %esi
80105865:	56                   	push   %esi
  pushl %edi
80105866:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105867:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105869:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010586b:	5f                   	pop    %edi
  popl %esi
8010586c:	5e                   	pop    %esi
  popl %ebx
8010586d:	5b                   	pop    %ebx
  popl %ebp
8010586e:	5d                   	pop    %ebp
  ret
8010586f:	c3                   	ret    

80105870 <fetchint>:

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80105870:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105877:	55                   	push   %ebp
80105878:	89 e5                	mov    %esp,%ebp
8010587a:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
8010587d:	8b 12                	mov    (%edx),%edx
8010587f:	39 c2                	cmp    %eax,%edx
80105881:	76 15                	jbe    80105898 <fetchint+0x28>
80105883:	8d 48 04             	lea    0x4(%eax),%ecx
80105886:	39 ca                	cmp    %ecx,%edx
80105888:	72 0e                	jb     80105898 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
8010588a:	8b 10                	mov    (%eax),%edx
8010588c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010588f:	89 10                	mov    %edx,(%eax)
  return 0;
80105891:	31 c0                	xor    %eax,%eax
}
80105893:	5d                   	pop    %ebp
80105894:	c3                   	ret    
80105895:	8d 76 00             	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80105898:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  *ip = *(int*)(addr);
  return 0;
}
8010589d:	5d                   	pop    %ebp
8010589e:	c3                   	ret    
8010589f:	90                   	nop

801058a0 <fetchstr>:
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
801058a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801058a6:	55                   	push   %ebp
801058a7:	89 e5                	mov    %esp,%ebp
801058a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char *s, *ep;

  if(addr >= proc->sz)
801058ac:	39 08                	cmp    %ecx,(%eax)
801058ae:	76 2c                	jbe    801058dc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801058b0:	8b 55 0c             	mov    0xc(%ebp),%edx
801058b3:	89 c8                	mov    %ecx,%eax
801058b5:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
801058b7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801058be:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
801058c0:	39 d1                	cmp    %edx,%ecx
801058c2:	73 18                	jae    801058dc <fetchstr+0x3c>
    if(*s == 0)
801058c4:	80 39 00             	cmpb   $0x0,(%ecx)
801058c7:	75 0c                	jne    801058d5 <fetchstr+0x35>
801058c9:	eb 1d                	jmp    801058e8 <fetchstr+0x48>
801058cb:	90                   	nop
801058cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058d0:	80 38 00             	cmpb   $0x0,(%eax)
801058d3:	74 13                	je     801058e8 <fetchstr+0x48>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801058d5:	83 c0 01             	add    $0x1,%eax
801058d8:	39 c2                	cmp    %eax,%edx
801058da:	77 f4                	ja     801058d0 <fetchstr+0x30>
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
    return -1;
801058dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
  return -1;
}
801058e1:	5d                   	pop    %ebp
801058e2:	c3                   	ret    
801058e3:	90                   	nop
801058e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
801058e8:	29 c8                	sub    %ecx,%eax
  return -1;
}
801058ea:	5d                   	pop    %ebp
801058eb:	c3                   	ret    
801058ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058f0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801058f0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801058f7:	55                   	push   %ebp
801058f8:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801058fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
801058fd:	8b 42 18             	mov    0x18(%edx),%eax

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80105900:	8b 12                	mov    (%edx),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105902:	8b 40 44             	mov    0x44(%eax),%eax
80105905:	8d 04 88             	lea    (%eax,%ecx,4),%eax
80105908:	8d 48 04             	lea    0x4(%eax),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010590b:	39 d1                	cmp    %edx,%ecx
8010590d:	73 19                	jae    80105928 <argint+0x38>
8010590f:	8d 48 08             	lea    0x8(%eax),%ecx
80105912:	39 ca                	cmp    %ecx,%edx
80105914:	72 12                	jb     80105928 <argint+0x38>
    return -1;
  *ip = *(int*)(addr);
80105916:	8b 50 04             	mov    0x4(%eax),%edx
80105919:	8b 45 0c             	mov    0xc(%ebp),%eax
8010591c:	89 10                	mov    %edx,(%eax)
  return 0;
8010591e:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
80105920:	5d                   	pop    %ebp
80105921:	c3                   	ret    
80105922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80105928:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
8010592d:	5d                   	pop    %ebp
8010592e:	c3                   	ret    
8010592f:	90                   	nop

80105930 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105930:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105936:	55                   	push   %ebp
80105937:	89 e5                	mov    %esp,%ebp
80105939:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010593a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010593d:	8b 50 18             	mov    0x18(%eax),%edx
80105940:	8b 52 44             	mov    0x44(%edx),%edx
80105943:	8d 0c 8a             	lea    (%edx,%ecx,4),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80105946:	8b 10                	mov    (%eax),%edx
argptr(int n, char **pp, int size)
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
80105948:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010594d:	8d 59 04             	lea    0x4(%ecx),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80105950:	39 d3                	cmp    %edx,%ebx
80105952:	73 25                	jae    80105979 <argptr+0x49>
80105954:	8d 59 08             	lea    0x8(%ecx),%ebx
80105957:	39 da                	cmp    %ebx,%edx
80105959:	72 1e                	jb     80105979 <argptr+0x49>
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
8010595b:	8b 5d 10             	mov    0x10(%ebp),%ebx
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
8010595e:	8b 49 04             	mov    0x4(%ecx),%ecx
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
80105961:	85 db                	test   %ebx,%ebx
80105963:	78 14                	js     80105979 <argptr+0x49>
80105965:	39 d1                	cmp    %edx,%ecx
80105967:	73 10                	jae    80105979 <argptr+0x49>
80105969:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010596c:	01 cb                	add    %ecx,%ebx
8010596e:	39 d3                	cmp    %edx,%ebx
80105970:	77 07                	ja     80105979 <argptr+0x49>
    return -1;
  *pp = (char*)i;
80105972:	8b 45 0c             	mov    0xc(%ebp),%eax
80105975:	89 08                	mov    %ecx,(%eax)
  return 0;
80105977:	31 c0                	xor    %eax,%eax
}
80105979:	5b                   	pop    %ebx
8010597a:	5d                   	pop    %ebp
8010597b:	c3                   	ret    
8010597c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105980 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105980:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105986:	55                   	push   %ebp
80105987:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105989:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010598c:	8b 50 18             	mov    0x18(%eax),%edx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010598f:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105991:	8b 52 44             	mov    0x44(%edx),%edx
80105994:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
80105997:	8d 4a 04             	lea    0x4(%edx),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010599a:	39 c1                	cmp    %eax,%ecx
8010599c:	73 07                	jae    801059a5 <argstr+0x25>
8010599e:	8d 4a 08             	lea    0x8(%edx),%ecx
801059a1:	39 c8                	cmp    %ecx,%eax
801059a3:	73 0b                	jae    801059b0 <argstr+0x30>
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
801059a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
801059aa:	5d                   	pop    %ebp
801059ab:	c3                   	ret    
801059ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
801059b0:	8b 4a 04             	mov    0x4(%edx),%ecx
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
801059b3:	39 c1                	cmp    %eax,%ecx
801059b5:	73 ee                	jae    801059a5 <argstr+0x25>
    return -1;
  *pp = (char*)addr;
801059b7:	8b 55 0c             	mov    0xc(%ebp),%edx
801059ba:	89 c8                	mov    %ecx,%eax
801059bc:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
801059be:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801059c5:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
801059c7:	39 d1                	cmp    %edx,%ecx
801059c9:	73 da                	jae    801059a5 <argstr+0x25>
    if(*s == 0)
801059cb:	80 39 00             	cmpb   $0x0,(%ecx)
801059ce:	75 12                	jne    801059e2 <argstr+0x62>
801059d0:	eb 1e                	jmp    801059f0 <argstr+0x70>
801059d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801059d8:	80 38 00             	cmpb   $0x0,(%eax)
801059db:	90                   	nop
801059dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059e0:	74 0e                	je     801059f0 <argstr+0x70>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801059e2:	83 c0 01             	add    $0x1,%eax
801059e5:	39 c2                	cmp    %eax,%edx
801059e7:	77 ef                	ja     801059d8 <argstr+0x58>
801059e9:	eb ba                	jmp    801059a5 <argstr+0x25>
801059eb:	90                   	nop
801059ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s == 0)
      return s - *pp;
801059f0:	29 c8                	sub    %ecx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801059f2:	5d                   	pop    %ebp
801059f3:	c3                   	ret    
801059f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801059fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105a00 <syscall>:
[SYS_thread_join] sys_thread_join,
};

void
syscall(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	53                   	push   %ebx
80105a04:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80105a07:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105a0e:	8b 5a 18             	mov    0x18(%edx),%ebx
80105a11:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105a14:	8d 48 ff             	lea    -0x1(%eax),%ecx
80105a17:	83 f9 1c             	cmp    $0x1c,%ecx
80105a1a:	77 1c                	ja     80105a38 <syscall+0x38>
80105a1c:	8b 0c 85 e0 97 10 80 	mov    -0x7fef6820(,%eax,4),%ecx
80105a23:	85 c9                	test   %ecx,%ecx
80105a25:	74 11                	je     80105a38 <syscall+0x38>
    proc->tf->eax = syscalls[num]();
80105a27:	ff d1                	call   *%ecx
80105a29:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
80105a2c:	83 c4 14             	add    $0x14,%esp
80105a2f:	5b                   	pop    %ebx
80105a30:	5d                   	pop    %ebp
80105a31:	c3                   	ret    
80105a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105a38:	89 44 24 0c          	mov    %eax,0xc(%esp)
            proc->pid, proc->name, num);
80105a3c:	8d 42 6c             	lea    0x6c(%edx),%eax
80105a3f:	89 44 24 08          	mov    %eax,0x8(%esp)

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105a43:	8b 42 10             	mov    0x10(%edx),%eax
80105a46:	c7 04 24 c1 97 10 80 	movl   $0x801097c1,(%esp)
80105a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a51:	e8 fa ab ff ff       	call   80100650 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105a56:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a5c:	8b 40 18             	mov    0x18(%eax),%eax
80105a5f:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105a66:	83 c4 14             	add    $0x14,%esp
80105a69:	5b                   	pop    %ebx
80105a6a:	5d                   	pop    %ebp
80105a6b:	c3                   	ret    
80105a6c:	66 90                	xchg   %ax,%ax
80105a6e:	66 90                	xchg   %ax,%ax

80105a70 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	57                   	push   %edi
80105a74:	56                   	push   %esi
80105a75:	53                   	push   %ebx
80105a76:	83 ec 4c             	sub    $0x4c,%esp
80105a79:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80105a7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105a7f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80105a82:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105a86:	89 04 24             	mov    %eax,(%esp)
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105a89:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105a8c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105a8f:	e8 1c c6 ff ff       	call   801020b0 <nameiparent>
80105a94:	85 c0                	test   %eax,%eax
80105a96:	89 c7                	mov    %eax,%edi
80105a98:	0f 84 da 00 00 00    	je     80105b78 <create+0x108>
    return 0;
  ilock(dp);
80105a9e:	89 04 24             	mov    %eax,(%esp)
80105aa1:	e8 da bc ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105aa6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105aa9:	89 44 24 08          	mov    %eax,0x8(%esp)
80105aad:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105ab1:	89 3c 24             	mov    %edi,(%esp)
80105ab4:	e8 97 c2 ff ff       	call   80101d50 <dirlookup>
80105ab9:	85 c0                	test   %eax,%eax
80105abb:	89 c6                	mov    %eax,%esi
80105abd:	74 41                	je     80105b00 <create+0x90>
    iunlockput(dp);
80105abf:	89 3c 24             	mov    %edi,(%esp)
80105ac2:	e8 d9 bf ff ff       	call   80101aa0 <iunlockput>
    ilock(ip);
80105ac7:	89 34 24             	mov    %esi,(%esp)
80105aca:	e8 b1 bc ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105acf:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80105ad4:	75 12                	jne    80105ae8 <create+0x78>
80105ad6:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80105adb:	89 f0                	mov    %esi,%eax
80105add:	75 09                	jne    80105ae8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105adf:	83 c4 4c             	add    $0x4c,%esp
80105ae2:	5b                   	pop    %ebx
80105ae3:	5e                   	pop    %esi
80105ae4:	5f                   	pop    %edi
80105ae5:	5d                   	pop    %ebp
80105ae6:	c3                   	ret    
80105ae7:	90                   	nop
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80105ae8:	89 34 24             	mov    %esi,(%esp)
80105aeb:	e8 b0 bf ff ff       	call   80101aa0 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105af0:	83 c4 4c             	add    $0x4c,%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80105af3:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105af5:	5b                   	pop    %ebx
80105af6:	5e                   	pop    %esi
80105af7:	5f                   	pop    %edi
80105af8:	5d                   	pop    %ebp
80105af9:	c3                   	ret    
80105afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105b00:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105b04:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b08:	8b 07                	mov    (%edi),%eax
80105b0a:	89 04 24             	mov    %eax,(%esp)
80105b0d:	e8 de ba ff ff       	call   801015f0 <ialloc>
80105b12:	85 c0                	test   %eax,%eax
80105b14:	89 c6                	mov    %eax,%esi
80105b16:	0f 84 bf 00 00 00    	je     80105bdb <create+0x16b>
    panic("create: ialloc");

  ilock(ip);
80105b1c:	89 04 24             	mov    %eax,(%esp)
80105b1f:	e8 5c bc ff ff       	call   80101780 <ilock>
  ip->major = major;
80105b24:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105b28:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80105b2c:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105b30:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105b34:	b8 01 00 00 00       	mov    $0x1,%eax
80105b39:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80105b3d:	89 34 24             	mov    %esi,(%esp)
80105b40:	e8 7b bb ff ff       	call   801016c0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105b45:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80105b4a:	74 34                	je     80105b80 <create+0x110>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105b4c:	8b 46 04             	mov    0x4(%esi),%eax
80105b4f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105b53:	89 3c 24             	mov    %edi,(%esp)
80105b56:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b5a:	e8 51 c4 ff ff       	call   80101fb0 <dirlink>
80105b5f:	85 c0                	test   %eax,%eax
80105b61:	78 6c                	js     80105bcf <create+0x15f>
    panic("create: dirlink");

  iunlockput(dp);
80105b63:	89 3c 24             	mov    %edi,(%esp)
80105b66:	e8 35 bf ff ff       	call   80101aa0 <iunlockput>

  return ip;
}
80105b6b:	83 c4 4c             	add    $0x4c,%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80105b6e:	89 f0                	mov    %esi,%eax
}
80105b70:	5b                   	pop    %ebx
80105b71:	5e                   	pop    %esi
80105b72:	5f                   	pop    %edi
80105b73:	5d                   	pop    %ebp
80105b74:	c3                   	ret    
80105b75:	8d 76 00             	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80105b78:	31 c0                	xor    %eax,%eax
80105b7a:	e9 60 ff ff ff       	jmp    80105adf <create+0x6f>
80105b7f:	90                   	nop
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80105b80:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80105b85:	89 3c 24             	mov    %edi,(%esp)
80105b88:	e8 33 bb ff ff       	call   801016c0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105b8d:	8b 46 04             	mov    0x4(%esi),%eax
80105b90:	c7 44 24 04 74 98 10 	movl   $0x80109874,0x4(%esp)
80105b97:	80 
80105b98:	89 34 24             	mov    %esi,(%esp)
80105b9b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b9f:	e8 0c c4 ff ff       	call   80101fb0 <dirlink>
80105ba4:	85 c0                	test   %eax,%eax
80105ba6:	78 1b                	js     80105bc3 <create+0x153>
80105ba8:	8b 47 04             	mov    0x4(%edi),%eax
80105bab:	c7 44 24 04 73 98 10 	movl   $0x80109873,0x4(%esp)
80105bb2:	80 
80105bb3:	89 34 24             	mov    %esi,(%esp)
80105bb6:	89 44 24 08          	mov    %eax,0x8(%esp)
80105bba:	e8 f1 c3 ff ff       	call   80101fb0 <dirlink>
80105bbf:	85 c0                	test   %eax,%eax
80105bc1:	79 89                	jns    80105b4c <create+0xdc>
      panic("create dots");
80105bc3:	c7 04 24 67 98 10 80 	movl   $0x80109867,(%esp)
80105bca:	e8 91 a7 ff ff       	call   80100360 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80105bcf:	c7 04 24 76 98 10 80 	movl   $0x80109876,(%esp)
80105bd6:	e8 85 a7 ff ff       	call   80100360 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80105bdb:	c7 04 24 58 98 10 80 	movl   $0x80109858,(%esp)
80105be2:	e8 79 a7 ff ff       	call   80100360 <panic>
80105be7:	89 f6                	mov    %esi,%esi
80105be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bf0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	56                   	push   %esi
80105bf4:	89 c6                	mov    %eax,%esi
80105bf6:	53                   	push   %ebx
80105bf7:	89 d3                	mov    %edx,%ebx
80105bf9:	83 ec 20             	sub    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105bfc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bff:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c0a:	e8 e1 fc ff ff       	call   801058f0 <argint>
80105c0f:	85 c0                	test   %eax,%eax
80105c11:	78 35                	js     80105c48 <argfd.constprop.0+0x58>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105c13:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80105c16:	83 f9 0f             	cmp    $0xf,%ecx
80105c19:	77 2d                	ja     80105c48 <argfd.constprop.0+0x58>
80105c1b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c21:	8b 44 88 28          	mov    0x28(%eax,%ecx,4),%eax
80105c25:	85 c0                	test   %eax,%eax
80105c27:	74 1f                	je     80105c48 <argfd.constprop.0+0x58>
    return -1;
  if(pfd)
80105c29:	85 f6                	test   %esi,%esi
80105c2b:	74 02                	je     80105c2f <argfd.constprop.0+0x3f>
    *pfd = fd;
80105c2d:	89 0e                	mov    %ecx,(%esi)
  if(pf)
80105c2f:	85 db                	test   %ebx,%ebx
80105c31:	74 0d                	je     80105c40 <argfd.constprop.0+0x50>
    *pf = f;
80105c33:	89 03                	mov    %eax,(%ebx)
  return 0;
80105c35:	31 c0                	xor    %eax,%eax
}
80105c37:	83 c4 20             	add    $0x20,%esp
80105c3a:	5b                   	pop    %ebx
80105c3b:	5e                   	pop    %esi
80105c3c:	5d                   	pop    %ebp
80105c3d:	c3                   	ret    
80105c3e:	66 90                	xchg   %ax,%ax
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80105c40:	31 c0                	xor    %eax,%eax
80105c42:	eb f3                	jmp    80105c37 <argfd.constprop.0+0x47>
80105c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80105c48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c4d:	eb e8                	jmp    80105c37 <argfd.constprop.0+0x47>
80105c4f:	90                   	nop

80105c50 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105c50:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105c51:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80105c53:	89 e5                	mov    %esp,%ebp
80105c55:	53                   	push   %ebx
80105c56:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105c59:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105c5c:	e8 8f ff ff ff       	call   80105bf0 <argfd.constprop.0>
80105c61:	85 c0                	test   %eax,%eax
80105c63:	78 1b                	js     80105c80 <sys_dup+0x30>
    return -1;
  if((fd=fdalloc(f)) < 0)
80105c65:	8b 55 f4             	mov    -0xc(%ebp),%edx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105c68:	31 db                	xor    %ebx,%ebx
80105c6a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    if(proc->ofile[fd] == 0){
80105c70:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
80105c74:	85 c9                	test   %ecx,%ecx
80105c76:	74 18                	je     80105c90 <sys_dup+0x40>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105c78:	83 c3 01             	add    $0x1,%ebx
80105c7b:	83 fb 10             	cmp    $0x10,%ebx
80105c7e:	75 f0                	jne    80105c70 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105c80:	83 c4 24             	add    $0x24,%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80105c83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105c88:	5b                   	pop    %ebx
80105c89:	5d                   	pop    %ebp
80105c8a:	c3                   	ret    
80105c8b:	90                   	nop
80105c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105c90:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80105c94:	89 14 24             	mov    %edx,(%esp)
80105c97:	e8 54 b1 ff ff       	call   80100df0 <filedup>
  return fd;
}
80105c9c:	83 c4 24             	add    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80105c9f:	89 d8                	mov    %ebx,%eax
}
80105ca1:	5b                   	pop    %ebx
80105ca2:	5d                   	pop    %ebp
80105ca3:	c3                   	ret    
80105ca4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105caa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105cb0 <sys_read>:

int
sys_read(void)
{
80105cb0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105cb1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80105cb3:	89 e5                	mov    %esp,%ebp
80105cb5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105cb8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105cbb:	e8 30 ff ff ff       	call   80105bf0 <argfd.constprop.0>
80105cc0:	85 c0                	test   %eax,%eax
80105cc2:	78 54                	js     80105d18 <sys_read+0x68>
80105cc4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ccb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105cd2:	e8 19 fc ff ff       	call   801058f0 <argint>
80105cd7:	85 c0                	test   %eax,%eax
80105cd9:	78 3d                	js     80105d18 <sys_read+0x68>
80105cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cde:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105ce5:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ce9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cec:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cf0:	e8 3b fc ff ff       	call   80105930 <argptr>
80105cf5:	85 c0                	test   %eax,%eax
80105cf7:	78 1f                	js     80105d18 <sys_read+0x68>
    return -1;
  return fileread(f, p, n);
80105cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cfc:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d03:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d07:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105d0a:	89 04 24             	mov    %eax,(%esp)
80105d0d:	e8 3e b2 ff ff       	call   80100f50 <fileread>
}
80105d12:	c9                   	leave  
80105d13:	c3                   	ret    
80105d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105d18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80105d1d:	c9                   	leave  
80105d1e:	c3                   	ret    
80105d1f:	90                   	nop

80105d20 <sys_write>:

int
sys_write(void)
{
80105d20:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105d21:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80105d23:	89 e5                	mov    %esp,%ebp
80105d25:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105d28:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105d2b:	e8 c0 fe ff ff       	call   80105bf0 <argfd.constprop.0>
80105d30:	85 c0                	test   %eax,%eax
80105d32:	78 54                	js     80105d88 <sys_write+0x68>
80105d34:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d37:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d3b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105d42:	e8 a9 fb ff ff       	call   801058f0 <argint>
80105d47:	85 c0                	test   %eax,%eax
80105d49:	78 3d                	js     80105d88 <sys_write+0x68>
80105d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d4e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105d55:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d59:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d60:	e8 cb fb ff ff       	call   80105930 <argptr>
80105d65:	85 c0                	test   %eax,%eax
80105d67:	78 1f                	js     80105d88 <sys_write+0x68>
    return -1;
  return filewrite(f, p, n);
80105d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d6c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d73:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d77:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105d7a:	89 04 24             	mov    %eax,(%esp)
80105d7d:	e8 6e b2 ff ff       	call   80100ff0 <filewrite>
}
80105d82:	c9                   	leave  
80105d83:	c3                   	ret    
80105d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105d88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80105d8d:	c9                   	leave  
80105d8e:	c3                   	ret    
80105d8f:	90                   	nop

80105d90 <sys_close>:

int
sys_close(void)
{
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
80105d93:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105d96:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105d99:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d9c:	e8 4f fe ff ff       	call   80105bf0 <argfd.constprop.0>
80105da1:	85 c0                	test   %eax,%eax
80105da3:	78 23                	js     80105dc8 <sys_close+0x38>
    return -1;
  proc->ofile[fd] = 0;
80105da5:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105da8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105dae:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105db5:	00 
  fileclose(f);
80105db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105db9:	89 04 24             	mov    %eax,(%esp)
80105dbc:	e8 7f b0 ff ff       	call   80100e40 <fileclose>
  return 0;
80105dc1:	31 c0                	xor    %eax,%eax
}
80105dc3:	c9                   	leave  
80105dc4:	c3                   	ret    
80105dc5:	8d 76 00             	lea    0x0(%esi),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80105dc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  proc->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80105dcd:	c9                   	leave  
80105dce:	c3                   	ret    
80105dcf:	90                   	nop

80105dd0 <sys_fstat>:

int
sys_fstat(void)
{
80105dd0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105dd1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80105dd3:	89 e5                	mov    %esp,%ebp
80105dd5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105dd8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105ddb:	e8 10 fe ff ff       	call   80105bf0 <argfd.constprop.0>
80105de0:	85 c0                	test   %eax,%eax
80105de2:	78 34                	js     80105e18 <sys_fstat+0x48>
80105de4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105de7:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105dee:	00 
80105def:	89 44 24 04          	mov    %eax,0x4(%esp)
80105df3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105dfa:	e8 31 fb ff ff       	call   80105930 <argptr>
80105dff:	85 c0                	test   %eax,%eax
80105e01:	78 15                	js     80105e18 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
80105e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e06:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e0d:	89 04 24             	mov    %eax,(%esp)
80105e10:	e8 eb b0 ff ff       	call   80100f00 <filestat>
}
80105e15:	c9                   	leave  
80105e16:	c3                   	ret    
80105e17:	90                   	nop
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80105e18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80105e1d:	c9                   	leave  
80105e1e:	c3                   	ret    
80105e1f:	90                   	nop

80105e20 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105e20:	55                   	push   %ebp
80105e21:	89 e5                	mov    %esp,%ebp
80105e23:	57                   	push   %edi
80105e24:	56                   	push   %esi
80105e25:	53                   	push   %ebx
80105e26:	83 ec 3c             	sub    $0x3c,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105e29:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105e2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e30:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e37:	e8 44 fb ff ff       	call   80105980 <argstr>
80105e3c:	85 c0                	test   %eax,%eax
80105e3e:	0f 88 e6 00 00 00    	js     80105f2a <sys_link+0x10a>
80105e44:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105e47:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105e52:	e8 29 fb ff ff       	call   80105980 <argstr>
80105e57:	85 c0                	test   %eax,%eax
80105e59:	0f 88 cb 00 00 00    	js     80105f2a <sys_link+0x10a>
    return -1;

  begin_op();
80105e5f:	e8 cc ce ff ff       	call   80102d30 <begin_op>
  if((ip = namei(old)) == 0){
80105e64:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105e67:	89 04 24             	mov    %eax,(%esp)
80105e6a:	e8 21 c2 ff ff       	call   80102090 <namei>
80105e6f:	85 c0                	test   %eax,%eax
80105e71:	89 c3                	mov    %eax,%ebx
80105e73:	0f 84 ac 00 00 00    	je     80105f25 <sys_link+0x105>
    end_op();
    return -1;
  }

  ilock(ip);
80105e79:	89 04 24             	mov    %eax,(%esp)
80105e7c:	e8 ff b8 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
80105e81:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105e86:	0f 84 91 00 00 00    	je     80105f1d <sys_link+0xfd>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80105e8c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105e91:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105e94:	89 1c 24             	mov    %ebx,(%esp)
80105e97:	e8 24 b8 ff ff       	call   801016c0 <iupdate>
  iunlock(ip);
80105e9c:	89 1c 24             	mov    %ebx,(%esp)
80105e9f:	e8 ac b9 ff ff       	call   80101850 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105ea4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105ea7:	89 7c 24 04          	mov    %edi,0x4(%esp)
80105eab:	89 04 24             	mov    %eax,(%esp)
80105eae:	e8 fd c1 ff ff       	call   801020b0 <nameiparent>
80105eb3:	85 c0                	test   %eax,%eax
80105eb5:	89 c6                	mov    %eax,%esi
80105eb7:	74 4f                	je     80105f08 <sys_link+0xe8>
    goto bad;
  ilock(dp);
80105eb9:	89 04 24             	mov    %eax,(%esp)
80105ebc:	e8 bf b8 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105ec1:	8b 03                	mov    (%ebx),%eax
80105ec3:	39 06                	cmp    %eax,(%esi)
80105ec5:	75 39                	jne    80105f00 <sys_link+0xe0>
80105ec7:	8b 43 04             	mov    0x4(%ebx),%eax
80105eca:	89 7c 24 04          	mov    %edi,0x4(%esp)
80105ece:	89 34 24             	mov    %esi,(%esp)
80105ed1:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ed5:	e8 d6 c0 ff ff       	call   80101fb0 <dirlink>
80105eda:	85 c0                	test   %eax,%eax
80105edc:	78 22                	js     80105f00 <sys_link+0xe0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80105ede:	89 34 24             	mov    %esi,(%esp)
80105ee1:	e8 ba bb ff ff       	call   80101aa0 <iunlockput>
  iput(ip);
80105ee6:	89 1c 24             	mov    %ebx,(%esp)
80105ee9:	e8 a2 b9 ff ff       	call   80101890 <iput>

  end_op();
80105eee:	e8 ad ce ff ff       	call   80102da0 <end_op>
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80105ef3:	83 c4 3c             	add    $0x3c,%esp
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;
80105ef6:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80105ef8:	5b                   	pop    %ebx
80105ef9:	5e                   	pop    %esi
80105efa:	5f                   	pop    %edi
80105efb:	5d                   	pop    %ebp
80105efc:	c3                   	ret    
80105efd:	8d 76 00             	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80105f00:	89 34 24             	mov    %esi,(%esp)
80105f03:	e8 98 bb ff ff       	call   80101aa0 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80105f08:	89 1c 24             	mov    %ebx,(%esp)
80105f0b:	e8 70 b8 ff ff       	call   80101780 <ilock>
  ip->nlink--;
80105f10:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105f15:	89 1c 24             	mov    %ebx,(%esp)
80105f18:	e8 a3 b7 ff ff       	call   801016c0 <iupdate>
  iunlockput(ip);
80105f1d:	89 1c 24             	mov    %ebx,(%esp)
80105f20:	e8 7b bb ff ff       	call   80101aa0 <iunlockput>
  end_op();
80105f25:	e8 76 ce ff ff       	call   80102da0 <end_op>
  return -1;
}
80105f2a:	83 c4 3c             	add    $0x3c,%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80105f2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f32:	5b                   	pop    %ebx
80105f33:	5e                   	pop    %esi
80105f34:	5f                   	pop    %edi
80105f35:	5d                   	pop    %ebp
80105f36:	c3                   	ret    
80105f37:	89 f6                	mov    %esi,%esi
80105f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f40 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	57                   	push   %edi
80105f44:	56                   	push   %esi
80105f45:	53                   	push   %ebx
80105f46:	83 ec 5c             	sub    $0x5c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105f49:	8d 45 c0             	lea    -0x40(%ebp),%eax
80105f4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f50:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f57:	e8 24 fa ff ff       	call   80105980 <argstr>
80105f5c:	85 c0                	test   %eax,%eax
80105f5e:	0f 88 76 01 00 00    	js     801060da <sys_unlink+0x19a>
    return -1;

  begin_op();
80105f64:	e8 c7 cd ff ff       	call   80102d30 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105f69:	8b 45 c0             	mov    -0x40(%ebp),%eax
80105f6c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105f6f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105f73:	89 04 24             	mov    %eax,(%esp)
80105f76:	e8 35 c1 ff ff       	call   801020b0 <nameiparent>
80105f7b:	85 c0                	test   %eax,%eax
80105f7d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105f80:	0f 84 4f 01 00 00    	je     801060d5 <sys_unlink+0x195>
    end_op();
    return -1;
  }

  ilock(dp);
80105f86:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105f89:	89 34 24             	mov    %esi,(%esp)
80105f8c:	e8 ef b7 ff ff       	call   80101780 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105f91:	c7 44 24 04 74 98 10 	movl   $0x80109874,0x4(%esp)
80105f98:	80 
80105f99:	89 1c 24             	mov    %ebx,(%esp)
80105f9c:	e8 7f bd ff ff       	call   80101d20 <namecmp>
80105fa1:	85 c0                	test   %eax,%eax
80105fa3:	0f 84 21 01 00 00    	je     801060ca <sys_unlink+0x18a>
80105fa9:	c7 44 24 04 73 98 10 	movl   $0x80109873,0x4(%esp)
80105fb0:	80 
80105fb1:	89 1c 24             	mov    %ebx,(%esp)
80105fb4:	e8 67 bd ff ff       	call   80101d20 <namecmp>
80105fb9:	85 c0                	test   %eax,%eax
80105fbb:	0f 84 09 01 00 00    	je     801060ca <sys_unlink+0x18a>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105fc1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105fc4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105fc8:	89 44 24 08          	mov    %eax,0x8(%esp)
80105fcc:	89 34 24             	mov    %esi,(%esp)
80105fcf:	e8 7c bd ff ff       	call   80101d50 <dirlookup>
80105fd4:	85 c0                	test   %eax,%eax
80105fd6:	89 c3                	mov    %eax,%ebx
80105fd8:	0f 84 ec 00 00 00    	je     801060ca <sys_unlink+0x18a>
    goto bad;
  ilock(ip);
80105fde:	89 04 24             	mov    %eax,(%esp)
80105fe1:	e8 9a b7 ff ff       	call   80101780 <ilock>

  if(ip->nlink < 1)
80105fe6:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105feb:	0f 8e 24 01 00 00    	jle    80106115 <sys_unlink+0x1d5>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105ff1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ff6:	8d 75 d8             	lea    -0x28(%ebp),%esi
80105ff9:	74 7d                	je     80106078 <sys_unlink+0x138>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105ffb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80106002:	00 
80106003:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010600a:	00 
8010600b:	89 34 24             	mov    %esi,(%esp)
8010600e:	e8 0d f6 ff ff       	call   80105620 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106013:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80106016:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010601d:	00 
8010601e:	89 74 24 04          	mov    %esi,0x4(%esp)
80106022:	89 44 24 08          	mov    %eax,0x8(%esp)
80106026:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80106029:	89 04 24             	mov    %eax,(%esp)
8010602c:	e8 bf bb ff ff       	call   80101bf0 <writei>
80106031:	83 f8 10             	cmp    $0x10,%eax
80106034:	0f 85 cf 00 00 00    	jne    80106109 <sys_unlink+0x1c9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010603a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010603f:	0f 84 a3 00 00 00    	je     801060e8 <sys_unlink+0x1a8>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80106045:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80106048:	89 04 24             	mov    %eax,(%esp)
8010604b:	e8 50 ba ff ff       	call   80101aa0 <iunlockput>

  ip->nlink--;
80106050:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106055:	89 1c 24             	mov    %ebx,(%esp)
80106058:	e8 63 b6 ff ff       	call   801016c0 <iupdate>
  iunlockput(ip);
8010605d:	89 1c 24             	mov    %ebx,(%esp)
80106060:	e8 3b ba ff ff       	call   80101aa0 <iunlockput>

  end_op();
80106065:	e8 36 cd ff ff       	call   80102da0 <end_op>

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010606a:	83 c4 5c             	add    $0x5c,%esp
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;
8010606d:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010606f:	5b                   	pop    %ebx
80106070:	5e                   	pop    %esi
80106071:	5f                   	pop    %edi
80106072:	5d                   	pop    %ebp
80106073:	c3                   	ret    
80106074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106078:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
8010607c:	0f 86 79 ff ff ff    	jbe    80105ffb <sys_unlink+0xbb>
80106082:	bf 20 00 00 00       	mov    $0x20,%edi
80106087:	eb 15                	jmp    8010609e <sys_unlink+0x15e>
80106089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106090:	8d 57 10             	lea    0x10(%edi),%edx
80106093:	3b 53 58             	cmp    0x58(%ebx),%edx
80106096:	0f 83 5f ff ff ff    	jae    80105ffb <sys_unlink+0xbb>
8010609c:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010609e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801060a5:	00 
801060a6:	89 7c 24 08          	mov    %edi,0x8(%esp)
801060aa:	89 74 24 04          	mov    %esi,0x4(%esp)
801060ae:	89 1c 24             	mov    %ebx,(%esp)
801060b1:	e8 3a ba ff ff       	call   80101af0 <readi>
801060b6:	83 f8 10             	cmp    $0x10,%eax
801060b9:	75 42                	jne    801060fd <sys_unlink+0x1bd>
      panic("isdirempty: readi");
    if(de.inum != 0)
801060bb:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801060c0:	74 ce                	je     80106090 <sys_unlink+0x150>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
801060c2:	89 1c 24             	mov    %ebx,(%esp)
801060c5:	e8 d6 b9 ff ff       	call   80101aa0 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
801060ca:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801060cd:	89 04 24             	mov    %eax,(%esp)
801060d0:	e8 cb b9 ff ff       	call   80101aa0 <iunlockput>
  end_op();
801060d5:	e8 c6 cc ff ff       	call   80102da0 <end_op>
  return -1;
}
801060da:	83 c4 5c             	add    $0x5c,%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
801060dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060e2:	5b                   	pop    %ebx
801060e3:	5e                   	pop    %esi
801060e4:	5f                   	pop    %edi
801060e5:	5d                   	pop    %ebp
801060e6:	c3                   	ret    
801060e7:	90                   	nop

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801060e8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801060eb:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801060f0:	89 04 24             	mov    %eax,(%esp)
801060f3:	e8 c8 b5 ff ff       	call   801016c0 <iupdate>
801060f8:	e9 48 ff ff ff       	jmp    80106045 <sys_unlink+0x105>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
801060fd:	c7 04 24 98 98 10 80 	movl   $0x80109898,(%esp)
80106104:	e8 57 a2 ff ff       	call   80100360 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80106109:	c7 04 24 aa 98 10 80 	movl   $0x801098aa,(%esp)
80106110:	e8 4b a2 ff ff       	call   80100360 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80106115:	c7 04 24 86 98 10 80 	movl   $0x80109886,(%esp)
8010611c:	e8 3f a2 ff ff       	call   80100360 <panic>
80106121:	eb 0d                	jmp    80106130 <sys_open>
80106123:	90                   	nop
80106124:	90                   	nop
80106125:	90                   	nop
80106126:	90                   	nop
80106127:	90                   	nop
80106128:	90                   	nop
80106129:	90                   	nop
8010612a:	90                   	nop
8010612b:	90                   	nop
8010612c:	90                   	nop
8010612d:	90                   	nop
8010612e:	90                   	nop
8010612f:	90                   	nop

80106130 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	57                   	push   %edi
80106134:	56                   	push   %esi
80106135:	53                   	push   %ebx
80106136:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106139:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010613c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106140:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106147:	e8 34 f8 ff ff       	call   80105980 <argstr>
8010614c:	85 c0                	test   %eax,%eax
8010614e:	0f 88 81 00 00 00    	js     801061d5 <sys_open+0xa5>
80106154:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106157:	89 44 24 04          	mov    %eax,0x4(%esp)
8010615b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106162:	e8 89 f7 ff ff       	call   801058f0 <argint>
80106167:	85 c0                	test   %eax,%eax
80106169:	78 6a                	js     801061d5 <sys_open+0xa5>
    return -1;

  begin_op();
8010616b:	e8 c0 cb ff ff       	call   80102d30 <begin_op>

  if(omode & O_CREATE){
80106170:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80106174:	75 72                	jne    801061e8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80106176:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106179:	89 04 24             	mov    %eax,(%esp)
8010617c:	e8 0f bf ff ff       	call   80102090 <namei>
80106181:	85 c0                	test   %eax,%eax
80106183:	89 c7                	mov    %eax,%edi
80106185:	74 49                	je     801061d0 <sys_open+0xa0>
      end_op();
      return -1;
    }
    ilock(ip);
80106187:	89 04 24             	mov    %eax,(%esp)
8010618a:	e8 f1 b5 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
8010618f:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80106194:	0f 84 ae 00 00 00    	je     80106248 <sys_open+0x118>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010619a:	e8 e1 ab ff ff       	call   80100d80 <filealloc>
8010619f:	85 c0                	test   %eax,%eax
801061a1:	89 c6                	mov    %eax,%esi
801061a3:	74 23                	je     801061c8 <sys_open+0x98>
801061a5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801061ac:	31 db                	xor    %ebx,%ebx
801061ae:	66 90                	xchg   %ax,%ax
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
801061b0:	8b 44 9a 28          	mov    0x28(%edx,%ebx,4),%eax
801061b4:	85 c0                	test   %eax,%eax
801061b6:	74 50                	je     80106208 <sys_open+0xd8>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801061b8:	83 c3 01             	add    $0x1,%ebx
801061bb:	83 fb 10             	cmp    $0x10,%ebx
801061be:	75 f0                	jne    801061b0 <sys_open+0x80>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
801061c0:	89 34 24             	mov    %esi,(%esp)
801061c3:	e8 78 ac ff ff       	call   80100e40 <fileclose>
    iunlockput(ip);
801061c8:	89 3c 24             	mov    %edi,(%esp)
801061cb:	e8 d0 b8 ff ff       	call   80101aa0 <iunlockput>
    end_op();
801061d0:	e8 cb cb ff ff       	call   80102da0 <end_op>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801061d5:	83 c4 2c             	add    $0x2c,%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
801061d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801061dd:	5b                   	pop    %ebx
801061de:	5e                   	pop    %esi
801061df:	5f                   	pop    %edi
801061e0:	5d                   	pop    %ebp
801061e1:	c3                   	ret    
801061e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801061e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801061eb:	31 c9                	xor    %ecx,%ecx
801061ed:	ba 02 00 00 00       	mov    $0x2,%edx
801061f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061f9:	e8 72 f8 ff ff       	call   80105a70 <create>
    if(ip == 0){
801061fe:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80106200:	89 c7                	mov    %eax,%edi
    if(ip == 0){
80106202:	75 96                	jne    8010619a <sys_open+0x6a>
80106204:	eb ca                	jmp    801061d0 <sys_open+0xa0>
80106206:	66 90                	xchg   %ax,%ax
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80106208:	89 74 9a 28          	mov    %esi,0x28(%edx,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010620c:	89 3c 24             	mov    %edi,(%esp)
8010620f:	e8 3c b6 ff ff       	call   80101850 <iunlock>
  end_op();
80106214:	e8 87 cb ff ff       	call   80102da0 <end_op>

  f->type = FD_INODE;
80106219:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010621f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80106222:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
80106225:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
8010622c:	89 d0                	mov    %edx,%eax
8010622e:	83 e0 01             	and    $0x1,%eax
80106231:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106234:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80106237:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
8010623a:	89 d8                	mov    %ebx,%eax

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010623c:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
}
80106240:	83 c4 2c             	add    $0x2c,%esp
80106243:	5b                   	pop    %ebx
80106244:	5e                   	pop    %esi
80106245:	5f                   	pop    %edi
80106246:	5d                   	pop    %ebp
80106247:	c3                   	ret    
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80106248:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010624b:	85 d2                	test   %edx,%edx
8010624d:	0f 84 47 ff ff ff    	je     8010619a <sys_open+0x6a>
80106253:	e9 70 ff ff ff       	jmp    801061c8 <sys_open+0x98>
80106258:	90                   	nop
80106259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106260 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80106260:	55                   	push   %ebp
80106261:	89 e5                	mov    %esp,%ebp
80106263:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106266:	e8 c5 ca ff ff       	call   80102d30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010626b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010626e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106272:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106279:	e8 02 f7 ff ff       	call   80105980 <argstr>
8010627e:	85 c0                	test   %eax,%eax
80106280:	78 2e                	js     801062b0 <sys_mkdir+0x50>
80106282:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106285:	31 c9                	xor    %ecx,%ecx
80106287:	ba 01 00 00 00       	mov    $0x1,%edx
8010628c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106293:	e8 d8 f7 ff ff       	call   80105a70 <create>
80106298:	85 c0                	test   %eax,%eax
8010629a:	74 14                	je     801062b0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010629c:	89 04 24             	mov    %eax,(%esp)
8010629f:	e8 fc b7 ff ff       	call   80101aa0 <iunlockput>
  end_op();
801062a4:	e8 f7 ca ff ff       	call   80102da0 <end_op>
  return 0;
801062a9:	31 c0                	xor    %eax,%eax
}
801062ab:	c9                   	leave  
801062ac:	c3                   	ret    
801062ad:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801062b0:	e8 eb ca ff ff       	call   80102da0 <end_op>
    return -1;
801062b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801062ba:	c9                   	leave  
801062bb:	c3                   	ret    
801062bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801062c0 <sys_mknod>:

int
sys_mknod(void)
{
801062c0:	55                   	push   %ebp
801062c1:	89 e5                	mov    %esp,%ebp
801062c3:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801062c6:	e8 65 ca ff ff       	call   80102d30 <begin_op>
  if((argstr(0, &path)) < 0 ||
801062cb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801062ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801062d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062d9:	e8 a2 f6 ff ff       	call   80105980 <argstr>
801062de:	85 c0                	test   %eax,%eax
801062e0:	78 5e                	js     80106340 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801062e2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801062e5:	89 44 24 04          	mov    %eax,0x4(%esp)
801062e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801062f0:	e8 fb f5 ff ff       	call   801058f0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801062f5:	85 c0                	test   %eax,%eax
801062f7:	78 47                	js     80106340 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801062f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80106300:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106307:	e8 e4 f5 ff ff       	call   801058f0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010630c:	85 c0                	test   %eax,%eax
8010630e:	78 30                	js     80106340 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106310:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106314:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80106319:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
8010631d:	89 04 24             	mov    %eax,(%esp)
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106320:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106323:	e8 48 f7 ff ff       	call   80105a70 <create>
80106328:	85 c0                	test   %eax,%eax
8010632a:	74 14                	je     80106340 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010632c:	89 04 24             	mov    %eax,(%esp)
8010632f:	e8 6c b7 ff ff       	call   80101aa0 <iunlockput>
  end_op();
80106334:	e8 67 ca ff ff       	call   80102da0 <end_op>
  return 0;
80106339:	31 c0                	xor    %eax,%eax
}
8010633b:	c9                   	leave  
8010633c:	c3                   	ret    
8010633d:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106340:	e8 5b ca ff ff       	call   80102da0 <end_op>
    return -1;
80106345:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010634a:	c9                   	leave  
8010634b:	c3                   	ret    
8010634c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106350 <sys_chdir>:

int
sys_chdir(void)
{
80106350:	55                   	push   %ebp
80106351:	89 e5                	mov    %esp,%ebp
80106353:	53                   	push   %ebx
80106354:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106357:	e8 d4 c9 ff ff       	call   80102d30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010635c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010635f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106363:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010636a:	e8 11 f6 ff ff       	call   80105980 <argstr>
8010636f:	85 c0                	test   %eax,%eax
80106371:	78 5a                	js     801063cd <sys_chdir+0x7d>
80106373:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106376:	89 04 24             	mov    %eax,(%esp)
80106379:	e8 12 bd ff ff       	call   80102090 <namei>
8010637e:	85 c0                	test   %eax,%eax
80106380:	89 c3                	mov    %eax,%ebx
80106382:	74 49                	je     801063cd <sys_chdir+0x7d>
    end_op();
    return -1;
  }
  ilock(ip);
80106384:	89 04 24             	mov    %eax,(%esp)
80106387:	e8 f4 b3 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
8010638c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80106391:	89 1c 24             	mov    %ebx,(%esp)
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
80106394:	75 32                	jne    801063c8 <sys_chdir+0x78>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106396:	e8 b5 b4 ff ff       	call   80101850 <iunlock>
  iput(proc->cwd);
8010639b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063a1:	8b 40 68             	mov    0x68(%eax),%eax
801063a4:	89 04 24             	mov    %eax,(%esp)
801063a7:	e8 e4 b4 ff ff       	call   80101890 <iput>
  end_op();
801063ac:	e8 ef c9 ff ff       	call   80102da0 <end_op>
  proc->cwd = ip;
801063b1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063b7:	89 58 68             	mov    %ebx,0x68(%eax)
  return 0;
}
801063ba:	83 c4 24             	add    $0x24,%esp
  }
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
801063bd:	31 c0                	xor    %eax,%eax
}
801063bf:	5b                   	pop    %ebx
801063c0:	5d                   	pop    %ebp
801063c1:	c3                   	ret    
801063c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801063c8:	e8 d3 b6 ff ff       	call   80101aa0 <iunlockput>
    end_op();
801063cd:	e8 ce c9 ff ff       	call   80102da0 <end_op>
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
}
801063d2:	83 c4 24             	add    $0x24,%esp
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
801063d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
}
801063da:	5b                   	pop    %ebx
801063db:	5d                   	pop    %ebp
801063dc:	c3                   	ret    
801063dd:	8d 76 00             	lea    0x0(%esi),%esi

801063e0 <sys_exec>:

int
sys_exec(void)
{
801063e0:	55                   	push   %ebp
801063e1:	89 e5                	mov    %esp,%ebp
801063e3:	57                   	push   %edi
801063e4:	56                   	push   %esi
801063e5:	53                   	push   %ebx
801063e6:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801063ec:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801063f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801063f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801063fd:	e8 7e f5 ff ff       	call   80105980 <argstr>
80106402:	85 c0                	test   %eax,%eax
80106404:	0f 88 84 00 00 00    	js     8010648e <sys_exec+0xae>
8010640a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106410:	89 44 24 04          	mov    %eax,0x4(%esp)
80106414:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010641b:	e8 d0 f4 ff ff       	call   801058f0 <argint>
80106420:	85 c0                	test   %eax,%eax
80106422:	78 6a                	js     8010648e <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106424:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010642a:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010642c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80106433:	00 
80106434:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010643a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106441:	00 
80106442:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106448:	89 04 24             	mov    %eax,(%esp)
8010644b:	e8 d0 f1 ff ff       	call   80105620 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106450:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106456:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010645a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010645d:	89 04 24             	mov    %eax,(%esp)
80106460:	e8 0b f4 ff ff       	call   80105870 <fetchint>
80106465:	85 c0                	test   %eax,%eax
80106467:	78 25                	js     8010648e <sys_exec+0xae>
      return -1;
    if(uarg == 0){
80106469:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010646f:	85 c0                	test   %eax,%eax
80106471:	74 2d                	je     801064a0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106473:	89 74 24 04          	mov    %esi,0x4(%esp)
80106477:	89 04 24             	mov    %eax,(%esp)
8010647a:	e8 21 f4 ff ff       	call   801058a0 <fetchstr>
8010647f:	85 c0                	test   %eax,%eax
80106481:	78 0b                	js     8010648e <sys_exec+0xae>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106483:	83 c3 01             	add    $0x1,%ebx
80106486:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80106489:	83 fb 20             	cmp    $0x20,%ebx
8010648c:	75 c2                	jne    80106450 <sys_exec+0x70>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
8010648e:	81 c4 ac 00 00 00    	add    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80106494:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80106499:	5b                   	pop    %ebx
8010649a:	5e                   	pop    %esi
8010649b:	5f                   	pop    %edi
8010649c:	5d                   	pop    %ebp
8010649d:	c3                   	ret    
8010649e:	66 90                	xchg   %ax,%ax
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801064a0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801064a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801064aa:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801064b0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801064b7:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801064bb:	89 04 24             	mov    %eax,(%esp)
801064be:	e8 ed a4 ff ff       	call   801009b0 <exec>
}
801064c3:	81 c4 ac 00 00 00    	add    $0xac,%esp
801064c9:	5b                   	pop    %ebx
801064ca:	5e                   	pop    %esi
801064cb:	5f                   	pop    %edi
801064cc:	5d                   	pop    %ebp
801064cd:	c3                   	ret    
801064ce:	66 90                	xchg   %ax,%ax

801064d0 <sys_pipe>:

int
sys_pipe(void)
{
801064d0:	55                   	push   %ebp
801064d1:	89 e5                	mov    %esp,%ebp
801064d3:	57                   	push   %edi
801064d4:	56                   	push   %esi
801064d5:	53                   	push   %ebx
801064d6:	83 ec 2c             	sub    $0x2c,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801064d9:	8d 45 dc             	lea    -0x24(%ebp),%eax
801064dc:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801064e3:	00 
801064e4:	89 44 24 04          	mov    %eax,0x4(%esp)
801064e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801064ef:	e8 3c f4 ff ff       	call   80105930 <argptr>
801064f4:	85 c0                	test   %eax,%eax
801064f6:	78 7a                	js     80106572 <sys_pipe+0xa2>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801064f8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801064fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801064ff:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106502:	89 04 24             	mov    %eax,(%esp)
80106505:	e8 56 cf ff ff       	call   80103460 <pipealloc>
8010650a:	85 c0                	test   %eax,%eax
8010650c:	78 64                	js     80106572 <sys_pipe+0xa2>
8010650e:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106515:	31 c0                	xor    %eax,%eax
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  //cprintf(" pipe cur pid %d/ tid %d\n",proc->pid,proc->tid);
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106517:	8b 5d e0             	mov    -0x20(%ebp),%ebx
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
8010651a:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
8010651e:	85 d2                	test   %edx,%edx
80106520:	74 16                	je     80106538 <sys_pipe+0x68>
80106522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106528:	83 c0 01             	add    $0x1,%eax
8010652b:	83 f8 10             	cmp    $0x10,%eax
8010652e:	74 2f                	je     8010655f <sys_pipe+0x8f>
    if(proc->ofile[fd] == 0){
80106530:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
80106534:	85 d2                	test   %edx,%edx
80106536:	75 f0                	jne    80106528 <sys_pipe+0x58>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  //cprintf(" pipe cur pid %d/ tid %d\n",proc->pid,proc->tid);
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106538:	8b 7d e4             	mov    -0x1c(%ebp),%edi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
8010653b:	8d 70 08             	lea    0x8(%eax),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010653e:	31 d2                	xor    %edx,%edx
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80106540:	89 5c b1 08          	mov    %ebx,0x8(%ecx,%esi,4)
80106544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80106548:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
8010654d:	74 31                	je     80106580 <sys_pipe+0xb0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010654f:	83 c2 01             	add    $0x1,%edx
80106552:	83 fa 10             	cmp    $0x10,%edx
80106555:	75 f1                	jne    80106548 <sys_pipe+0x78>
    return -1;
  fd0 = -1;
  //cprintf(" pipe cur pid %d/ tid %d\n",proc->pid,proc->tid);
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
80106557:	c7 44 b1 08 00 00 00 	movl   $0x0,0x8(%ecx,%esi,4)
8010655e:	00 
    fileclose(rf);
8010655f:	89 1c 24             	mov    %ebx,(%esp)
80106562:	e8 d9 a8 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80106567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010656a:	89 04 24             	mov    %eax,(%esp)
8010656d:	e8 ce a8 ff ff       	call   80100e40 <fileclose>
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80106572:	83 c4 2c             	add    $0x2c,%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80106575:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010657a:	5b                   	pop    %ebx
8010657b:	5e                   	pop    %esi
8010657c:	5f                   	pop    %edi
8010657d:	5d                   	pop    %ebp
8010657e:	c3                   	ret    
8010657f:	90                   	nop
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80106580:	89 7c 91 28          	mov    %edi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80106584:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80106587:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
80106589:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010658c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
8010658f:	83 c4 2c             	add    $0x2c,%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80106592:	31 c0                	xor    %eax,%eax
}
80106594:	5b                   	pop    %ebx
80106595:	5e                   	pop    %esi
80106596:	5f                   	pop    %edi
80106597:	5d                   	pop    %ebp
80106598:	c3                   	ret    
80106599:	66 90                	xchg   %ax,%ax
8010659b:	66 90                	xchg   %ax,%ax
8010659d:	66 90                	xchg   %ax,%ax
8010659f:	90                   	nop

801065a0 <sys_fork>:
#include "mlfq.h"
#include "stride.h"

int
sys_fork(void)
{
801065a0:	55                   	push   %ebp
801065a1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801065a3:	5d                   	pop    %ebp
#include "stride.h"

int
sys_fork(void)
{
  return fork();
801065a4:	e9 e7 eb ff ff       	jmp    80105190 <fork>
801065a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065b0 <sys_exit>:
}

int
sys_exit(void)
{
801065b0:	55                   	push   %ebp
801065b1:	89 e5                	mov    %esp,%ebp
801065b3:	83 ec 08             	sub    $0x8,%esp
  exit();
801065b6:	e8 c5 e7 ff ff       	call   80104d80 <exit>
  return 0;  // not reached
}
801065bb:	31 c0                	xor    %eax,%eax
801065bd:	c9                   	leave  
801065be:	c3                   	ret    
801065bf:	90                   	nop

801065c0 <sys_wait>:

int
sys_wait(void)
{
801065c0:	55                   	push   %ebp
801065c1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801065c3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
801065c4:	e9 37 d7 ff ff       	jmp    80103d00 <wait>
801065c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065d0 <sys_kill>:
}

int
sys_kill(void)
{
801065d0:	55                   	push   %ebp
801065d1:	89 e5                	mov    %esp,%ebp
801065d3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801065d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801065dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801065e4:	e8 07 f3 ff ff       	call   801058f0 <argint>
801065e9:	85 c0                	test   %eax,%eax
801065eb:	78 13                	js     80106600 <sys_kill+0x30>
    return -1;
  return kill(pid);
801065ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065f0:	89 04 24             	mov    %eax,(%esp)
801065f3:	e8 68 d8 ff ff       	call   80103e60 <kill>
}
801065f8:	c9                   	leave  
801065f9:	c3                   	ret    
801065fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80106600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80106605:	c9                   	leave  
80106606:	c3                   	ret    
80106607:	89 f6                	mov    %esi,%esi
80106609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106610 <sys_getpid>:

int
sys_getpid(void)
{
  return proc->pid;
80106610:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
80106616:	55                   	push   %ebp
80106617:	89 e5                	mov    %esp,%ebp
  return proc->pid;
}
80106619:	5d                   	pop    %ebp
}

int
sys_getpid(void)
{
  return proc->pid;
8010661a:	8b 40 10             	mov    0x10(%eax),%eax
}
8010661d:	c3                   	ret    
8010661e:	66 90                	xchg   %ax,%ax

80106620 <sys_getppid>:

int
sys_getppid(void)
{
    return proc->parent->pid;
80106620:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return proc->pid;
}

int
sys_getppid(void)
{
80106626:	55                   	push   %ebp
80106627:	89 e5                	mov    %esp,%ebp
    return proc->parent->pid;
}
80106629:	5d                   	pop    %ebp
}

int
sys_getppid(void)
{
    return proc->parent->pid;
8010662a:	8b 40 14             	mov    0x14(%eax),%eax
8010662d:	8b 40 10             	mov    0x10(%eax),%eax
}
80106630:	c3                   	ret    
80106631:	eb 0d                	jmp    80106640 <sys_yield>
80106633:	90                   	nop
80106634:	90                   	nop
80106635:	90                   	nop
80106636:	90                   	nop
80106637:	90                   	nop
80106638:	90                   	nop
80106639:	90                   	nop
8010663a:	90                   	nop
8010663b:	90                   	nop
8010663c:	90                   	nop
8010663d:	90                   	nop
8010663e:	90                   	nop
8010663f:	90                   	nop

80106640 <sys_yield>:

void
sys_yield(void)
{
80106640:	55                   	push   %ebp
80106641:	89 e5                	mov    %esp,%ebp
    return yield();
}
80106643:	5d                   	pop    %ebp
}

void
sys_yield(void)
{
    return yield();
80106644:	e9 57 d5 ff ff       	jmp    80103ba0 <yield>
80106649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106650 <sys_getlev>:
}
int
sys_getlev(void)
{
80106650:	55                   	push   %ebp
    return curQ;
}
80106651:	a1 e0 1f 11 80       	mov    0x80111fe0,%eax
{
    return yield();
}
int
sys_getlev(void)
{
80106656:	89 e5                	mov    %esp,%ebp
    return curQ;
}
80106658:	5d                   	pop    %ebp
80106659:	c3                   	ret    
8010665a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106660 <sys_set_cpu_share>:
int
sys_set_cpu_share(void)
{
80106660:	55                   	push   %ebp
80106661:	89 e5                	mov    %esp,%ebp
80106663:	83 ec 28             	sub    $0x28,%esp
    int share;
    if(argint(0, &share) < 0)
80106666:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106669:	89 44 24 04          	mov    %eax,0x4(%esp)
8010666d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106674:	e8 77 f2 ff ff       	call   801058f0 <argint>
80106679:	85 c0                	test   %eax,%eax
8010667b:	78 13                	js     80106690 <sys_set_cpu_share+0x30>
        return -1;
    return set_cpu_share(share);
8010667d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106680:	89 04 24             	mov    %eax,(%esp)
80106683:	e8 c8 27 00 00       	call   80108e50 <set_cpu_share>
}
80106688:	c9                   	leave  
80106689:	c3                   	ret    
8010668a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
int
sys_set_cpu_share(void)
{
    int share;
    if(argint(0, &share) < 0)
        return -1;
80106690:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return set_cpu_share(share);
}
80106695:	c9                   	leave  
80106696:	c3                   	ret    
80106697:	89 f6                	mov    %esi,%esi
80106699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066a0 <sys_sbrk>:
int
sys_sbrk(void)
{
801066a0:	55                   	push   %ebp
801066a1:	89 e5                	mov    %esp,%ebp
801066a3:	53                   	push   %ebx
801066a4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801066a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801066ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801066b5:	e8 36 f2 ff ff       	call   801058f0 <argint>
801066ba:	85 c0                	test   %eax,%eax
801066bc:	78 3a                	js     801066f8 <sys_sbrk+0x58>
    return -1;
 //ADDED
  if(proc->isthread == 1){
801066be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066c4:	66 83 b8 8c 00 00 00 	cmpw   $0x1,0x8c(%eax)
801066cb:	01 
801066cc:	74 1a                	je     801066e8 <sys_sbrk+0x48>
      proc->sz = proc->parent->sz;
  }
  addr = proc->sz;

  if(growproc(n) < 0)
801066ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
    return -1;
 //ADDED
  if(proc->isthread == 1){
      proc->sz = proc->parent->sz;
  }
  addr = proc->sz;
801066d1:	8b 18                	mov    (%eax),%ebx

  if(growproc(n) < 0)
801066d3:	89 14 24             	mov    %edx,(%esp)
801066d6:	e8 75 d3 ff ff       	call   80103a50 <growproc>
801066db:	85 c0                	test   %eax,%eax
801066dd:	78 19                	js     801066f8 <sys_sbrk+0x58>
    return -1;
  return addr;
801066df:	89 d8                	mov    %ebx,%eax
}
801066e1:	83 c4 24             	add    $0x24,%esp
801066e4:	5b                   	pop    %ebx
801066e5:	5d                   	pop    %ebp
801066e6:	c3                   	ret    
801066e7:	90                   	nop

  if(argint(0, &n) < 0)
    return -1;
 //ADDED
  if(proc->isthread == 1){
      proc->sz = proc->parent->sz;
801066e8:	8b 50 14             	mov    0x14(%eax),%edx
801066eb:	8b 12                	mov    (%edx),%edx
801066ed:	89 10                	mov    %edx,(%eax)
801066ef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066f5:	eb d7                	jmp    801066ce <sys_sbrk+0x2e>
801066f7:	90                   	nop
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
801066f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066fd:	eb e2                	jmp    801066e1 <sys_sbrk+0x41>
801066ff:	90                   	nop

80106700 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80106700:	55                   	push   %ebp
80106701:	89 e5                	mov    %esp,%ebp
80106703:	53                   	push   %ebx
80106704:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106707:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010670a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010670e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106715:	e8 d6 f1 ff ff       	call   801058f0 <argint>
8010671a:	85 c0                	test   %eax,%eax
8010671c:	78 7e                	js     8010679c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010671e:	c7 04 24 60 78 11 80 	movl   $0x80117860,(%esp)
80106725:	e8 66 ed ff ff       	call   80105490 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010672a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
8010672d:	8b 1d a0 80 11 80    	mov    0x801180a0,%ebx
  while(ticks - ticks0 < n){
80106733:	85 d2                	test   %edx,%edx
80106735:	75 29                	jne    80106760 <sys_sleep+0x60>
80106737:	eb 4f                	jmp    80106788 <sys_sleep+0x88>
80106739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106740:	c7 44 24 04 60 78 11 	movl   $0x80117860,0x4(%esp)
80106747:	80 
80106748:	c7 04 24 a0 80 11 80 	movl   $0x801180a0,(%esp)
8010674f:	e8 ec d4 ff ff       	call   80103c40 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106754:	a1 a0 80 11 80       	mov    0x801180a0,%eax
80106759:	29 d8                	sub    %ebx,%eax
8010675b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010675e:	73 28                	jae    80106788 <sys_sleep+0x88>
    if(proc->killed){
80106760:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106766:	8b 40 24             	mov    0x24(%eax),%eax
80106769:	85 c0                	test   %eax,%eax
8010676b:	74 d3                	je     80106740 <sys_sleep+0x40>
      release(&tickslock);
8010676d:	c7 04 24 60 78 11 80 	movl   $0x80117860,(%esp)
80106774:	e8 57 ee ff ff       	call   801055d0 <release>
      return -1;
80106779:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
8010677e:	83 c4 24             	add    $0x24,%esp
80106781:	5b                   	pop    %ebx
80106782:	5d                   	pop    %ebp
80106783:	c3                   	ret    
80106784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106788:	c7 04 24 60 78 11 80 	movl   $0x80117860,(%esp)
8010678f:	e8 3c ee ff ff       	call   801055d0 <release>
  return 0;
}
80106794:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
80106797:	31 c0                	xor    %eax,%eax
}
80106799:	5b                   	pop    %ebx
8010679a:	5d                   	pop    %ebp
8010679b:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
8010679c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067a1:	eb db                	jmp    8010677e <sys_sleep+0x7e>
801067a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801067a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067b0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801067b0:	55                   	push   %ebp
801067b1:	89 e5                	mov    %esp,%ebp
801067b3:	53                   	push   %ebx
801067b4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
801067b7:	c7 04 24 60 78 11 80 	movl   $0x80117860,(%esp)
801067be:	e8 cd ec ff ff       	call   80105490 <acquire>
  xticks = ticks;
801067c3:	8b 1d a0 80 11 80    	mov    0x801180a0,%ebx
  release(&tickslock);
801067c9:	c7 04 24 60 78 11 80 	movl   $0x80117860,(%esp)
801067d0:	e8 fb ed ff ff       	call   801055d0 <release>
  return xticks;
}
801067d5:	83 c4 14             	add    $0x14,%esp
801067d8:	89 d8                	mov    %ebx,%eax
801067da:	5b                   	pop    %ebx
801067db:	5d                   	pop    %ebp
801067dc:	c3                   	ret    
801067dd:	8d 76 00             	lea    0x0(%esi),%esi

801067e0 <sys_thread_create>:

int
sys_thread_create(void)
{
801067e0:	55                   	push   %ebp
801067e1:	89 e5                	mov    %esp,%ebp
801067e3:	83 ec 28             	sub    $0x28,%esp
    int thread;
    int addrOfStartRoutine;
    int arg;

    if(argint(0, &thread) < 0)
801067e6:	8d 45 ec             	lea    -0x14(%ebp),%eax
801067e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801067ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801067f4:	e8 f7 f0 ff ff       	call   801058f0 <argint>
801067f9:	85 c0                	test   %eax,%eax
801067fb:	78 4b                	js     80106848 <sys_thread_create+0x68>
        return -1;
    if(argint(1, &addrOfStartRoutine) < 0)
801067fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106800:	89 44 24 04          	mov    %eax,0x4(%esp)
80106804:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010680b:	e8 e0 f0 ff ff       	call   801058f0 <argint>
80106810:	85 c0                	test   %eax,%eax
80106812:	78 34                	js     80106848 <sys_thread_create+0x68>
        return -1;
    if(argint(2, &arg) < 0)
80106814:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106817:	89 44 24 04          	mov    %eax,0x4(%esp)
8010681b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106822:	e8 c9 f0 ff ff       	call   801058f0 <argint>
80106827:	85 c0                	test   %eax,%eax
80106829:	78 1d                	js     80106848 <sys_thread_create+0x68>
        return -1;

    return thread_create((thread_t *)thread, (void*)addrOfStartRoutine,(void*)arg);
8010682b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010682e:	89 44 24 08          	mov    %eax,0x8(%esp)
80106832:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106835:	89 44 24 04          	mov    %eax,0x4(%esp)
80106839:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010683c:	89 04 24             	mov    %eax,(%esp)
8010683f:	e8 ac dc ff ff       	call   801044f0 <thread_create>

}
80106844:	c9                   	leave  
80106845:	c3                   	ret    
80106846:	66 90                	xchg   %ax,%ax
    int thread;
    int addrOfStartRoutine;
    int arg;

    if(argint(0, &thread) < 0)
        return -1;
80106848:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(argint(2, &arg) < 0)
        return -1;

    return thread_create((thread_t *)thread, (void*)addrOfStartRoutine,(void*)arg);

}
8010684d:	c9                   	leave  
8010684e:	c3                   	ret    
8010684f:	90                   	nop

80106850 <sys_thread_exit>:

void
sys_thread_exit(void)
{
80106850:	55                   	push   %ebp
80106851:	89 e5                	mov    %esp,%ebp
80106853:	83 ec 28             	sub    $0x28,%esp
    int retval;

    if(argint(0, &retval) < 0){
80106856:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106859:	89 44 24 04          	mov    %eax,0x4(%esp)
8010685d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106864:	e8 87 f0 ff ff       	call   801058f0 <argint>
    }

    return thread_exit((void*)retval);
80106869:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010686c:	89 04 24             	mov    %eax,(%esp)
8010686f:	e8 2c df ff ff       	call   801047a0 <thread_exit>
80106874:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010687a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106880 <sys_thread_join>:
}

int
sys_thread_join(void)
{
80106880:	55                   	push   %ebp
80106881:	89 e5                	mov    %esp,%ebp
80106883:	83 ec 28             	sub    $0x28,%esp
    int thread;
    int retval;
    
    if(argint(0, &thread) < 0)
80106886:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106889:	89 44 24 04          	mov    %eax,0x4(%esp)
8010688d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106894:	e8 57 f0 ff ff       	call   801058f0 <argint>
80106899:	85 c0                	test   %eax,%eax
8010689b:	78 2b                	js     801068c8 <sys_thread_join+0x48>
        return -1;
    if(argint(1, &retval) < 0)
8010689d:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801068a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801068ab:	e8 40 f0 ff ff       	call   801058f0 <argint>
801068b0:	85 c0                	test   %eax,%eax
801068b2:	78 14                	js     801068c8 <sys_thread_join+0x48>
        return -1;
    return thread_join((thread_t)thread, (void**)retval);
801068b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801068bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068be:	89 04 24             	mov    %eax,(%esp)
801068c1:	e8 9a e0 ff ff       	call   80104960 <thread_join>
}
801068c6:	c9                   	leave  
801068c7:	c3                   	ret    
{
    int thread;
    int retval;
    
    if(argint(0, &thread) < 0)
        return -1;
801068c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(argint(1, &retval) < 0)
        return -1;
    return thread_join((thread_t)thread, (void**)retval);
}
801068cd:	c9                   	leave  
801068ce:	c3                   	ret    
801068cf:	90                   	nop

801068d0 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801068d0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801068d1:	ba 43 00 00 00       	mov    $0x43,%edx
801068d6:	89 e5                	mov    %esp,%ebp
801068d8:	b8 34 00 00 00       	mov    $0x34,%eax
801068dd:	83 ec 18             	sub    $0x18,%esp
801068e0:	ee                   	out    %al,(%dx)
801068e1:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
801068e6:	b2 40                	mov    $0x40,%dl
801068e8:	ee                   	out    %al,(%dx)
801068e9:	b8 2e 00 00 00       	mov    $0x2e,%eax
801068ee:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
801068ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801068f6:	e8 a5 ca ff ff       	call   801033a0 <picenable>
}
801068fb:	c9                   	leave  
801068fc:	c3                   	ret    

801068fd <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801068fd:	1e                   	push   %ds
  pushl %es
801068fe:	06                   	push   %es
  pushl %fs
801068ff:	0f a0                	push   %fs
  pushl %gs
80106901:	0f a8                	push   %gs
  pushal
80106903:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106904:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106908:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010690a:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010690c:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106910:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106912:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106914:	54                   	push   %esp
  call trap
80106915:	e8 16 01 00 00       	call   80106a30 <trap>
  addl $4, %esp
8010691a:	83 c4 04             	add    $0x4,%esp

8010691d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010691d:	61                   	popa   
  popl %gs
8010691e:	0f a9                	pop    %gs
  popl %fs
80106920:	0f a1                	pop    %fs
  popl %es
80106922:	07                   	pop    %es
  popl %ds
80106923:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106924:	83 c4 08             	add    $0x8,%esp
  iret
80106927:	cf                   	iret   
80106928:	66 90                	xchg   %ax,%ax
8010692a:	66 90                	xchg   %ax,%ax
8010692c:	66 90                	xchg   %ax,%ax
8010692e:	66 90                	xchg   %ax,%ax

80106930 <tvinit>:
    void
tvinit(void)
{
    int i;

    for(i = 0; i < 256; i++)
80106930:	31 c0                	xor    %eax,%eax
80106932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106938:	8b 14 85 10 c0 10 80 	mov    -0x7fef3ff0(,%eax,4),%edx
8010693f:	b9 08 00 00 00       	mov    $0x8,%ecx
80106944:	66 89 0c c5 a2 78 11 	mov    %cx,-0x7fee875e(,%eax,8)
8010694b:	80 
8010694c:	c6 04 c5 a4 78 11 80 	movb   $0x0,-0x7fee875c(,%eax,8)
80106953:	00 
80106954:	c6 04 c5 a5 78 11 80 	movb   $0x8e,-0x7fee875b(,%eax,8)
8010695b:	8e 
8010695c:	66 89 14 c5 a0 78 11 	mov    %dx,-0x7fee8760(,%eax,8)
80106963:	80 
80106964:	c1 ea 10             	shr    $0x10,%edx
80106967:	66 89 14 c5 a6 78 11 	mov    %dx,-0x7fee875a(,%eax,8)
8010696e:	80 
    void
tvinit(void)
{
    int i;

    for(i = 0; i < 256; i++)
8010696f:	83 c0 01             	add    $0x1,%eax
80106972:	3d 00 01 00 00       	cmp    $0x100,%eax
80106977:	75 bf                	jne    80106938 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

    void
tvinit(void)
{
80106979:	55                   	push   %ebp
    int i;

    for(i = 0; i < 256; i++)
        SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010697a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

    void
tvinit(void)
{
8010697f:	89 e5                	mov    %esp,%ebp
80106981:	83 ec 18             	sub    $0x18,%esp
    int i;

    for(i = 0; i < 256; i++)
        SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106984:	a1 10 c1 10 80       	mov    0x8010c110,%eax
    SETGATE(idt[T_LAB4], 1, SEG_KCODE<<3, vectors[T_LAB4], DPL_USER);
80106989:	b9 08 00 00 00       	mov    $0x8,%ecx

    initlock(&tickslock, "time");
8010698e:	c7 44 24 04 b9 98 10 	movl   $0x801098b9,0x4(%esp)
80106995:	80 
80106996:	c7 04 24 60 78 11 80 	movl   $0x80117860,(%esp)
{
    int i;

    for(i = 0; i < 256; i++)
        SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010699d:	66 a3 a0 7a 11 80    	mov    %ax,0x80117aa0
801069a3:	c1 e8 10             	shr    $0x10,%eax
801069a6:	66 a3 a6 7a 11 80    	mov    %ax,0x80117aa6
    SETGATE(idt[T_LAB4], 1, SEG_KCODE<<3, vectors[T_LAB4], DPL_USER);
801069ac:	a1 10 c2 10 80       	mov    0x8010c210,%eax
{
    int i;

    for(i = 0; i < 256; i++)
        SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801069b1:	66 89 15 a2 7a 11 80 	mov    %dx,0x80117aa2
801069b8:	c6 05 a4 7a 11 80 00 	movb   $0x0,0x80117aa4
801069bf:	c6 05 a5 7a 11 80 ef 	movb   $0xef,0x80117aa5
    SETGATE(idt[T_LAB4], 1, SEG_KCODE<<3, vectors[T_LAB4], DPL_USER);
801069c6:	66 a3 a0 7c 11 80    	mov    %ax,0x80117ca0
801069cc:	c1 e8 10             	shr    $0x10,%eax
801069cf:	66 89 0d a2 7c 11 80 	mov    %cx,0x80117ca2
801069d6:	c6 05 a4 7c 11 80 00 	movb   $0x0,0x80117ca4
801069dd:	c6 05 a5 7c 11 80 ef 	movb   $0xef,0x80117ca5
801069e4:	66 a3 a6 7c 11 80    	mov    %ax,0x80117ca6

    initlock(&tickslock, "time");
801069ea:	e8 21 ea ff ff       	call   80105410 <initlock>
}
801069ef:	c9                   	leave  
801069f0:	c3                   	ret    
801069f1:	eb 0d                	jmp    80106a00 <idtinit>
801069f3:	90                   	nop
801069f4:	90                   	nop
801069f5:	90                   	nop
801069f6:	90                   	nop
801069f7:	90                   	nop
801069f8:	90                   	nop
801069f9:	90                   	nop
801069fa:	90                   	nop
801069fb:	90                   	nop
801069fc:	90                   	nop
801069fd:	90                   	nop
801069fe:	90                   	nop
801069ff:	90                   	nop

80106a00 <idtinit>:

    void
idtinit(void)
{
80106a00:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106a01:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106a06:	89 e5                	mov    %esp,%ebp
80106a08:	83 ec 10             	sub    $0x10,%esp
80106a0b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106a0f:	b8 a0 78 11 80       	mov    $0x801178a0,%eax
80106a14:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106a18:	c1 e8 10             	shr    $0x10,%eax
80106a1b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106a1f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106a22:	0f 01 18             	lidtl  (%eax)
    lidt(idt, sizeof(idt));
}
80106a25:	c9                   	leave  
80106a26:	c3                   	ret    
80106a27:	89 f6                	mov    %esi,%esi
80106a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a30 <trap>:

//PAGEBREAK: 41
    void
trap(struct trapframe *tf)
{
80106a30:	55                   	push   %ebp
80106a31:	89 e5                	mov    %esp,%ebp
80106a33:	57                   	push   %edi
80106a34:	56                   	push   %esi
80106a35:	53                   	push   %ebx
80106a36:	83 ec 3c             	sub    $0x3c,%esp
80106a39:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(tf->trapno == T_SYSCALL){
80106a3c:	8b 43 30             	mov    0x30(%ebx),%eax
80106a3f:	83 f8 40             	cmp    $0x40,%eax
80106a42:	74 1c                	je     80106a60 <trap+0x30>
        if(proc->killed)
            exit();
        return;
    }

    if(tf->trapno == T_LAB4){
80106a44:	3d 80 00 00 00       	cmp    $0x80,%eax
80106a49:	74 45                	je     80106a90 <trap+0x60>
        cprintf("user Interrupt %d called!\n", T_LAB4);
        exit();
        return;
    }

    switch(tf->trapno){
80106a4b:	83 e8 20             	sub    $0x20,%eax
80106a4e:	83 f8 1f             	cmp    $0x1f,%eax
80106a51:	0f 87 79 01 00 00    	ja     80106bd0 <trap+0x1a0>
80106a57:	ff 24 85 9c 99 10 80 	jmp    *-0x7fef6664(,%eax,4)
80106a5e:	66 90                	xchg   %ax,%ax
    void
trap(struct trapframe *tf)
{
    if(tf->trapno == T_SYSCALL){
        //ADDED
        if(proc->killed){
80106a60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a66:	8b 70 24             	mov    0x24(%eax),%esi
80106a69:	85 f6                	test   %esi,%esi
80106a6b:	0f 85 4f 01 00 00    	jne    80106bc0 <trap+0x190>
            exit();
        }
        proc->tf = tf;
80106a71:	89 58 18             	mov    %ebx,0x18(%eax)
        syscall();
80106a74:	e8 87 ef ff ff       	call   80105a00 <syscall>
        if(proc->killed)
80106a79:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a7f:	8b 58 24             	mov    0x24(%eax),%ebx
80106a82:	85 db                	test   %ebx,%ebx
80106a84:	75 1e                	jne    80106aa4 <trap+0x74>

    // Check if the process has been killed since we yielded
    if(proc && proc->killed && (tf->cs&3) == DPL_USER){
        exit();
    }
}
80106a86:	83 c4 3c             	add    $0x3c,%esp
80106a89:	5b                   	pop    %ebx
80106a8a:	5e                   	pop    %esi
80106a8b:	5f                   	pop    %edi
80106a8c:	5d                   	pop    %ebp
80106a8d:	c3                   	ret    
80106a8e:	66 90                	xchg   %ax,%ax
            exit();
        return;
    }

    if(tf->trapno == T_LAB4){
        cprintf("user Interrupt %d called!\n", T_LAB4);
80106a90:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106a97:	00 
80106a98:	c7 04 24 be 98 10 80 	movl   $0x801098be,(%esp)
80106a9f:	e8 ac 9b ff ff       	call   80100650 <cprintf>

    // Check if the process has been killed since we yielded
    if(proc && proc->killed && (tf->cs&3) == DPL_USER){
        exit();
    }
}
80106aa4:	83 c4 3c             	add    $0x3c,%esp
80106aa7:	5b                   	pop    %ebx
80106aa8:	5e                   	pop    %esi
80106aa9:	5f                   	pop    %edi
80106aaa:	5d                   	pop    %ebp
        return;
    }

    if(tf->trapno == T_LAB4){
        cprintf("user Interrupt %d called!\n", T_LAB4);
        exit();
80106aab:	e9 d0 e2 ff ff       	jmp    80104d80 <exit>
        return;
    }

    switch(tf->trapno){
        case T_IRQ0 + IRQ_TIMER:
            if(cpunum() == 0){
80106ab0:	e8 4b be ff ff       	call   80102900 <cpunum>
80106ab5:	85 c0                	test   %eax,%eax
80106ab7:	0f 84 bb 01 00 00    	je     80106c78 <trap+0x248>
80106abd:	8d 76 00             	lea    0x0(%esi),%esi
                    //cprintf("t\t");
                ticks++;
                wakeup(&ticks);
                release(&tickslock);
            }
            lapiceoi();
80106ac0:	e8 db be ff ff       	call   801029a0 <lapiceoi>
80106ac5:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if(proc && proc->killed && (tf->cs&3) == DPL_USER){
80106acc:	85 c9                	test   %ecx,%ecx
80106ace:	74 b6                	je     80106a86 <trap+0x56>
80106ad0:	8b 51 24             	mov    0x24(%ecx),%edx
80106ad3:	85 d2                	test   %edx,%edx
80106ad5:	0f 85 6c 01 00 00    	jne    80106c47 <trap+0x217>
        exit();
    }

    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80106adb:	83 79 0c 04          	cmpl   $0x4,0xc(%ecx)
80106adf:	74 1f                	je     80106b00 <trap+0xd0>
            yield();
        }
    }

    // Check if the process has been killed since we yielded
    if(proc && proc->killed && (tf->cs&3) == DPL_USER){
80106ae1:	89 ce                	mov    %ecx,%esi
80106ae3:	8b 46 24             	mov    0x24(%esi),%eax
80106ae6:	85 c0                	test   %eax,%eax
80106ae8:	74 9c                	je     80106a86 <trap+0x56>
80106aea:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106aee:	83 e0 03             	and    $0x3,%eax
80106af1:	66 83 f8 03          	cmp    $0x3,%ax
80106af5:	74 ad                	je     80106aa4 <trap+0x74>
        exit();
    }
}
80106af7:	83 c4 3c             	add    $0x3c,%esp
80106afa:	5b                   	pop    %ebx
80106afb:	5e                   	pop    %esi
80106afc:	5f                   	pop    %edi
80106afd:	5d                   	pop    %ebp
80106afe:	c3                   	ret    
80106aff:	90                   	nop
        exit();
    }

    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80106b00:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106b04:	75 db                	jne    80106ae1 <trap+0xb1>
        //schedulerMode == means Now cuurent proc is Mlfq
        if(schedulerMode == 1)
80106b06:	83 3d f0 1f 11 80 01 	cmpl   $0x1,0x80111ff0
80106b0d:	0f 84 ad 01 00 00    	je     80106cc0 <trap+0x290>
                    yield();
                }
            }

            //Stride context switching
        } else if(proc->consumedTime % TIME_PER_ONE_PASS  == 0){
80106b13:	f6 81 88 00 00 00 07 	testb  $0x7,0x88(%ecx)
80106b1a:	75 c5                	jne    80106ae1 <trap+0xb1>
            yieldbytimer = 1;
80106b1c:	c7 05 e4 1f 11 80 01 	movl   $0x1,0x80111fe4
80106b23:	00 00 00 
            yield();
80106b26:	e8 75 d0 ff ff       	call   80103ba0 <yield>
80106b2b:	65 8b 35 04 00 00 00 	mov    %gs:0x4,%esi
        }
    }

    // Check if the process has been killed since we yielded
    if(proc && proc->killed && (tf->cs&3) == DPL_USER){
80106b32:	85 f6                	test   %esi,%esi
80106b34:	75 ad                	jne    80106ae3 <trap+0xb3>
80106b36:	e9 4b ff ff ff       	jmp    80106a86 <trap+0x56>
80106b3b:	90                   	nop
80106b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            break;
        case T_IRQ0 + IRQ_IDE+1:
            // Bochs generates spurious IDE1 interrupts.
            break;
        case T_IRQ0 + IRQ_KBD:
            kbdintr();
80106b40:	e8 2b bc ff ff       	call   80102770 <kbdintr>
            lapiceoi();
80106b45:	e8 56 be ff ff       	call   801029a0 <lapiceoi>
80106b4a:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
            break;
80106b51:	e9 76 ff ff ff       	jmp    80106acc <trap+0x9c>
80106b56:	66 90                	xchg   %ax,%ax
        case T_IRQ0 + IRQ_COM1:
            uartintr();
80106b58:	e8 43 04 00 00       	call   80106fa0 <uartintr>
            lapiceoi();
80106b5d:	e8 3e be ff ff       	call   801029a0 <lapiceoi>
80106b62:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
            break;
80106b69:	e9 5e ff ff ff       	jmp    80106acc <trap+0x9c>
80106b6e:	66 90                	xchg   %ax,%ax
        case T_IRQ0 + 7:
        case T_IRQ0 + IRQ_SPURIOUS:
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b70:	8b 7b 38             	mov    0x38(%ebx),%edi
80106b73:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106b77:	e8 84 bd ff ff       	call   80102900 <cpunum>
80106b7c:	c7 04 24 f8 98 10 80 	movl   $0x801098f8,(%esp)
80106b83:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106b87:	89 74 24 08          	mov    %esi,0x8(%esp)
80106b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b8f:	e8 bc 9a ff ff       	call   80100650 <cprintf>
                    cpunum(), tf->cs, tf->eip);
            lapiceoi();
80106b94:	e8 07 be ff ff       	call   801029a0 <lapiceoi>
80106b99:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
            break;
80106ba0:	e9 27 ff ff ff       	jmp    80106acc <trap+0x9c>
80106ba5:	8d 76 00             	lea    0x0(%esi),%esi
                release(&tickslock);
            }
            lapiceoi();
            break;
        case T_IRQ0 + IRQ_IDE:
            ideintr();
80106ba8:	e8 73 b6 ff ff       	call   80102220 <ideintr>
            lapiceoi();
80106bad:	e8 ee bd ff ff       	call   801029a0 <lapiceoi>
80106bb2:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
            break;
80106bb9:	e9 0e ff ff ff       	jmp    80106acc <trap+0x9c>
80106bbe:	66 90                	xchg   %ax,%ax
trap(struct trapframe *tf)
{
    if(tf->trapno == T_SYSCALL){
        //ADDED
        if(proc->killed){
            exit();
80106bc0:	e8 bb e1 ff ff       	call   80104d80 <exit>
80106bc5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bcb:	e9 a1 fe ff ff       	jmp    80106a71 <trap+0x41>
            lapiceoi();
            break;

            //PAGEBREAK: 13
        default:
            if(proc == 0 || (tf->cs&3) == 0){
80106bd0:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80106bd7:	85 c9                	test   %ecx,%ecx
80106bd9:	0f 84 24 02 00 00    	je     80106e03 <trap+0x3d3>
80106bdf:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106be3:	0f 84 1a 02 00 00    	je     80106e03 <trap+0x3d3>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106be9:	0f 20 d7             	mov    %cr2,%edi
                        tf->trapno, cpunum(), tf->eip, rcr2());
                cprintf(" [cause] pid %d / tid %d\n",proc->pid,proc->tid);
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d tid %d %s: trap %d err %d on cpu %d "
80106bec:	8b 73 38             	mov    0x38(%ebx),%esi
80106bef:	e8 0c bd ff ff       	call   80102900 <cpunum>
                    "eip 0x%x addr 0x%x--kill proc\n",
                    proc->pid, proc->tid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80106bf4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
                        tf->trapno, cpunum(), tf->eip, rcr2());
                cprintf(" [cause] pid %d / tid %d\n",proc->pid,proc->tid);
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d tid %d %s: trap %d err %d on cpu %d "
80106bfb:	89 7c 24 20          	mov    %edi,0x20(%esp)
80106bff:	89 74 24 1c          	mov    %esi,0x1c(%esp)
80106c03:	89 44 24 18          	mov    %eax,0x18(%esp)
80106c07:	8b 43 34             	mov    0x34(%ebx),%eax
80106c0a:	89 44 24 14          	mov    %eax,0x14(%esp)
80106c0e:	8b 43 30             	mov    0x30(%ebx),%eax
80106c11:	89 44 24 10          	mov    %eax,0x10(%esp)
                    "eip 0x%x addr 0x%x--kill proc\n",
                    proc->pid, proc->tid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80106c15:	8d 42 6c             	lea    0x6c(%edx),%eax
80106c18:	89 44 24 0c          	mov    %eax,0xc(%esp)
                        tf->trapno, cpunum(), tf->eip, rcr2());
                cprintf(" [cause] pid %d / tid %d\n",proc->pid,proc->tid);
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d tid %d %s: trap %d err %d on cpu %d "
80106c1c:	8b 82 98 00 00 00    	mov    0x98(%edx),%eax
80106c22:	89 44 24 08          	mov    %eax,0x8(%esp)
80106c26:	8b 42 10             	mov    0x10(%edx),%eax
80106c29:	c7 04 24 50 99 10 80 	movl   $0x80109950,(%esp)
80106c30:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c34:	e8 17 9a ff ff       	call   80100650 <cprintf>
                    "eip 0x%x addr 0x%x--kill proc\n",
                    proc->pid, proc->tid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
                    rcr2());
            proc->killed = 1;
80106c39:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80106c40:	c7 41 24 01 00 00 00 	movl   $0x1,0x24(%ecx)
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if(proc && proc->killed && (tf->cs&3) == DPL_USER){
80106c47:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106c4b:	83 e0 03             	and    $0x3,%eax
80106c4e:	66 83 f8 03          	cmp    $0x3,%ax
80106c52:	0f 85 83 fe ff ff    	jne    80106adb <trap+0xab>

        exit();
80106c58:	e8 23 e1 ff ff       	call   80104d80 <exit>
    }

    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80106c5d:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80106c64:	85 c9                	test   %ecx,%ecx
80106c66:	0f 85 6f fe ff ff    	jne    80106adb <trap+0xab>
80106c6c:	e9 15 fe ff ff       	jmp    80106a86 <trap+0x56>
80106c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }

    switch(tf->trapno){
        case T_IRQ0 + IRQ_TIMER:
            if(cpunum() == 0){
                acquire(&tickslock);
80106c78:	c7 04 24 60 78 11 80 	movl   $0x80117860,(%esp)
80106c7f:	e8 0c e8 ff ff       	call   80105490 <acquire>
                if(proc != 0){
80106c84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c8a:	85 c0                	test   %eax,%eax
80106c8c:	74 07                	je     80106c95 <trap+0x265>
                    proc->consumedTime++;
80106c8e:	83 80 88 00 00 00 01 	addl   $0x1,0x88(%eax)
                }
                    //cprintf("t\t");
                ticks++;
80106c95:	83 05 a0 80 11 80 01 	addl   $0x1,0x801180a0
                wakeup(&ticks);
80106c9c:	c7 04 24 a0 80 11 80 	movl   $0x801180a0,(%esp)
80106ca3:	e8 48 d1 ff ff       	call   80103df0 <wakeup>
                release(&tickslock);
80106ca8:	c7 04 24 60 78 11 80 	movl   $0x80117860,(%esp)
80106caf:	e8 1c e9 ff ff       	call   801055d0 <release>
80106cb4:	e9 04 fe ff ff       	jmp    80106abd <trap+0x8d>
80106cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
        //schedulerMode == means Now cuurent proc is Mlfq
        if(schedulerMode == 1)
        {
            //when the boost time comes
            if(ticks % MLFQ_BOOST_TIME ==0){
80106cc0:	8b 35 a0 80 11 80    	mov    0x801180a0,%esi
80106cc6:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80106ccb:	89 f0                	mov    %esi,%eax
80106ccd:	f7 e2                	mul    %edx
80106ccf:	c1 ea 05             	shr    $0x5,%edx
80106cd2:	6b d2 64             	imul   $0x64,%edx,%edx
80106cd5:	39 d6                	cmp    %edx,%esi
80106cd7:	0f 84 06 01 00 00    	je     80106de3 <trap+0x3b3>
                boostMlfq();
                yieldbytimer = 1; //flag that notify yield is called by timer
                yield();
                //The procedure that moving monopolying process to lower queue
            }else if(proc->pid > 2 && proc->state == RUNNING){
80106cdd:	83 79 10 02          	cmpl   $0x2,0x10(%ecx)
80106ce1:	0f 8e fa fd ff ff    	jle    80106ae1 <trap+0xb1>
                if(proc->consumedTime % qOfM[proc->qPosi].timeAllot == 0){
80106ce7:	0f b7 79 7c          	movzwl 0x7c(%ecx),%edi
80106ceb:	31 d2                	xor    %edx,%edx
80106ced:	0f b7 f7             	movzwl %di,%esi
80106cf0:	69 f6 10 01 00 00    	imul   $0x110,%esi,%esi
80106cf6:	0f b7 86 0c 21 11 80 	movzwl -0x7feedef4(%esi),%eax
80106cfd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d00:	8b 81 88 00 00 00    	mov    0x88(%ecx),%eax
80106d06:	f7 75 e4             	divl   -0x1c(%ebp)
80106d09:	85 d2                	test   %edx,%edx
80106d0b:	75 5f                	jne    80106d6c <trap+0x33c>
                    if(proc->qPosi != MAX_QUEUE_NUM-1){
80106d0d:	66 83 ff 02          	cmp    $0x2,%di
80106d11:	74 59                	je     80106d6c <trap+0x33c>
                        dequeue(&qOfM[proc->qPosi],proc);
80106d13:	81 c6 00 20 11 80    	add    $0x80112000,%esi
80106d19:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80106d1d:	89 34 24             	mov    %esi,(%esp)
80106d20:	e8 3b 1b 00 00       	call   80108860 <dequeue>
                        if(proc->qPosi == 2) enqueue(&qOfM[proc->qPosi], proc);
80106d25:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d2b:	0f b7 50 7c          	movzwl 0x7c(%eax),%edx
80106d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d33:	66 83 fa 02          	cmp    $0x2,%dx
80106d37:	0f 84 1f 01 00 00    	je     80106e5c <trap+0x42c>
                        else enqueue(&qOfM[proc->qPosi+1], proc);
80106d3d:	0f b7 c2             	movzwl %dx,%eax
80106d40:	83 c0 01             	add    $0x1,%eax
80106d43:	69 c0 10 01 00 00    	imul   $0x110,%eax,%eax
80106d49:	05 00 20 11 80       	add    $0x80112000,%eax
80106d4e:	89 04 24             	mov    %eax,(%esp)
80106d51:	e8 6a 19 00 00       	call   801086c0 <enqueue>
                        yieldbytimer = 1;
80106d56:	c7 05 e4 1f 11 80 01 	movl   $0x1,0x80111fe4
80106d5d:	00 00 00 
                        yield();
80106d60:	e8 3b ce ff ff       	call   80103ba0 <yield>
80106d65:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
                    }

                }
                //The procedure that switching context when every timeQuantum meets
                if(proc->consumedTime % qOfM[proc->qPosi].timeQuan == 0){
80106d6c:	0f b7 79 7c          	movzwl 0x7c(%ecx),%edi
80106d70:	31 d2                	xor    %edx,%edx
80106d72:	89 ce                	mov    %ecx,%esi
80106d74:	69 ff 10 01 00 00    	imul   $0x110,%edi,%edi
80106d7a:	0f b7 87 0a 21 11 80 	movzwl -0x7feedef6(%edi),%eax
80106d81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d84:	8b 81 88 00 00 00    	mov    0x88(%ecx),%eax
80106d8a:	f7 75 e4             	divl   -0x1c(%ebp)
80106d8d:	85 d2                	test   %edx,%edx
80106d8f:	0f 85 4e fd ff ff    	jne    80106ae3 <trap+0xb3>
                    dequeue(&qOfM[proc->qPosi],proc);
80106d95:	81 c7 00 20 11 80    	add    $0x80112000,%edi
80106d9b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80106d9f:	89 3c 24             	mov    %edi,(%esp)
80106da2:	e8 b9 1a 00 00       	call   80108860 <dequeue>
                    enqueue(&qOfM[proc->qPosi], proc);
80106da7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dad:	89 44 24 04          	mov    %eax,0x4(%esp)
80106db1:	0f b7 40 7c          	movzwl 0x7c(%eax),%eax
80106db5:	69 c0 10 01 00 00    	imul   $0x110,%eax,%eax
80106dbb:	05 00 20 11 80       	add    $0x80112000,%eax
80106dc0:	89 04 24             	mov    %eax,(%esp)
80106dc3:	e8 f8 18 00 00       	call   801086c0 <enqueue>
                    yieldbytimer = 1;
80106dc8:	c7 05 e4 1f 11 80 01 	movl   $0x1,0x80111fe4
80106dcf:	00 00 00 
                    yield();
80106dd2:	e8 c9 cd ff ff       	call   80103ba0 <yield>
80106dd7:	65 8b 35 04 00 00 00 	mov    %gs:0x4,%esi
80106dde:	e9 4f fd ff ff       	jmp    80106b32 <trap+0x102>
        //schedulerMode == means Now cuurent proc is Mlfq
        if(schedulerMode == 1)
        {
            //when the boost time comes
            if(ticks % MLFQ_BOOST_TIME ==0){
                boostMlfq();
80106de3:	e8 08 1f 00 00       	call   80108cf0 <boostMlfq>
                yieldbytimer = 1; //flag that notify yield is called by timer
80106de8:	c7 05 e4 1f 11 80 01 	movl   $0x1,0x80111fe4
80106def:	00 00 00 
                yield();
80106df2:	e8 a9 cd ff ff       	call   80103ba0 <yield>
80106df7:	65 8b 35 04 00 00 00 	mov    %gs:0x4,%esi
80106dfe:	e9 2f fd ff ff       	jmp    80106b32 <trap+0x102>
80106e03:	0f 20 d7             	mov    %cr2,%edi

            //PAGEBREAK: 13
        default:
            if(proc == 0 || (tf->cs&3) == 0){
                // In kernel, it must be our mistake.
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106e06:	8b 73 38             	mov    0x38(%ebx),%esi
80106e09:	e8 f2 ba ff ff       	call   80102900 <cpunum>
80106e0e:	89 7c 24 10          	mov    %edi,0x10(%esp)
80106e12:	89 74 24 0c          	mov    %esi,0xc(%esp)
80106e16:	89 44 24 08          	mov    %eax,0x8(%esp)
80106e1a:	8b 43 30             	mov    0x30(%ebx),%eax
80106e1d:	c7 04 24 1c 99 10 80 	movl   $0x8010991c,(%esp)
80106e24:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e28:	e8 23 98 ff ff       	call   80100650 <cprintf>
                        tf->trapno, cpunum(), tf->eip, rcr2());
                cprintf(" [cause] pid %d / tid %d\n",proc->pid,proc->tid);
80106e2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e33:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80106e39:	89 54 24 08          	mov    %edx,0x8(%esp)
80106e3d:	8b 40 10             	mov    0x10(%eax),%eax
80106e40:	c7 04 24 d9 98 10 80 	movl   $0x801098d9,(%esp)
80106e47:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e4b:	e8 00 98 ff ff       	call   80100650 <cprintf>
                panic("trap");
80106e50:	c7 04 24 f3 98 10 80 	movl   $0x801098f3,(%esp)
80106e57:	e8 04 95 ff ff       	call   80100360 <panic>
                //The procedure that moving monopolying process to lower queue
            }else if(proc->pid > 2 && proc->state == RUNNING){
                if(proc->consumedTime % qOfM[proc->qPosi].timeAllot == 0){
                    if(proc->qPosi != MAX_QUEUE_NUM-1){
                        dequeue(&qOfM[proc->qPosi],proc);
                        if(proc->qPosi == 2) enqueue(&qOfM[proc->qPosi], proc);
80106e5c:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80106e63:	e8 58 18 00 00       	call   801086c0 <enqueue>
80106e68:	e9 e9 fe ff ff       	jmp    80106d56 <trap+0x326>
80106e6d:	66 90                	xchg   %ax,%ax
80106e6f:	90                   	nop

80106e70 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106e70:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106e75:	55                   	push   %ebp
80106e76:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106e78:	85 c0                	test   %eax,%eax
80106e7a:	74 14                	je     80106e90 <uartgetc+0x20>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106e7c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106e81:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106e82:	a8 01                	test   $0x1,%al
80106e84:	74 0a                	je     80106e90 <uartgetc+0x20>
80106e86:	b2 f8                	mov    $0xf8,%dl
80106e88:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106e89:	0f b6 c0             	movzbl %al,%eax
}
80106e8c:	5d                   	pop    %ebp
80106e8d:	c3                   	ret    
80106e8e:	66 90                	xchg   %ax,%ax

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80106e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80106e95:	5d                   	pop    %ebp
80106e96:	c3                   	ret    
80106e97:	89 f6                	mov    %esi,%esi
80106e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ea0 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106ea0:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
80106ea5:	85 c0                	test   %eax,%eax
80106ea7:	74 3f                	je     80106ee8 <uartputc+0x48>
    uartputc(*p);
}

void
uartputc(int c)
{
80106ea9:	55                   	push   %ebp
80106eaa:	89 e5                	mov    %esp,%ebp
80106eac:	56                   	push   %esi
80106ead:	be fd 03 00 00       	mov    $0x3fd,%esi
80106eb2:	53                   	push   %ebx
  int i;

  if(!uart)
80106eb3:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
80106eb8:	83 ec 10             	sub    $0x10,%esp
80106ebb:	eb 14                	jmp    80106ed1 <uartputc+0x31>
80106ebd:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80106ec0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106ec7:	e8 f4 ba ff ff       	call   801029c0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106ecc:	83 eb 01             	sub    $0x1,%ebx
80106ecf:	74 07                	je     80106ed8 <uartputc+0x38>
80106ed1:	89 f2                	mov    %esi,%edx
80106ed3:	ec                   	in     (%dx),%al
80106ed4:	a8 20                	test   $0x20,%al
80106ed6:	74 e8                	je     80106ec0 <uartputc+0x20>
    microdelay(10);
  outb(COM1+0, c);
80106ed8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106edc:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106ee1:	ee                   	out    %al,(%dx)
}
80106ee2:	83 c4 10             	add    $0x10,%esp
80106ee5:	5b                   	pop    %ebx
80106ee6:	5e                   	pop    %esi
80106ee7:	5d                   	pop    %ebp
80106ee8:	f3 c3                	repz ret 
80106eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ef0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106ef0:	55                   	push   %ebp
80106ef1:	31 c9                	xor    %ecx,%ecx
80106ef3:	89 e5                	mov    %esp,%ebp
80106ef5:	89 c8                	mov    %ecx,%eax
80106ef7:	57                   	push   %edi
80106ef8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80106efd:	56                   	push   %esi
80106efe:	89 fa                	mov    %edi,%edx
80106f00:	53                   	push   %ebx
80106f01:	83 ec 1c             	sub    $0x1c,%esp
80106f04:	ee                   	out    %al,(%dx)
80106f05:	be fb 03 00 00       	mov    $0x3fb,%esi
80106f0a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106f0f:	89 f2                	mov    %esi,%edx
80106f11:	ee                   	out    %al,(%dx)
80106f12:	b8 0c 00 00 00       	mov    $0xc,%eax
80106f17:	b2 f8                	mov    $0xf8,%dl
80106f19:	ee                   	out    %al,(%dx)
80106f1a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106f1f:	89 c8                	mov    %ecx,%eax
80106f21:	89 da                	mov    %ebx,%edx
80106f23:	ee                   	out    %al,(%dx)
80106f24:	b8 03 00 00 00       	mov    $0x3,%eax
80106f29:	89 f2                	mov    %esi,%edx
80106f2b:	ee                   	out    %al,(%dx)
80106f2c:	b2 fc                	mov    $0xfc,%dl
80106f2e:	89 c8                	mov    %ecx,%eax
80106f30:	ee                   	out    %al,(%dx)
80106f31:	b8 01 00 00 00       	mov    $0x1,%eax
80106f36:	89 da                	mov    %ebx,%edx
80106f38:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106f39:	b2 fd                	mov    $0xfd,%dl
80106f3b:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106f3c:	3c ff                	cmp    $0xff,%al
80106f3e:	74 52                	je     80106f92 <uartinit+0xa2>
    return;
  uart = 1;
80106f40:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
80106f47:	00 00 00 
80106f4a:	89 fa                	mov    %edi,%edx
80106f4c:	ec                   	in     (%dx),%al
80106f4d:	b2 f8                	mov    $0xf8,%dl
80106f4f:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
80106f50:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106f57:	bb 1c 9a 10 80       	mov    $0x80109a1c,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
80106f5c:	e8 3f c4 ff ff       	call   801033a0 <picenable>
  ioapicenable(IRQ_COM1, 0);
80106f61:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106f68:	00 
80106f69:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106f70:	e8 db b4 ff ff       	call   80102450 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106f75:	b8 78 00 00 00       	mov    $0x78,%eax
80106f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    uartputc(*p);
80106f80:	89 04 24             	mov    %eax,(%esp)
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106f83:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80106f86:	e8 15 ff ff ff       	call   80106ea0 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106f8b:	0f be 03             	movsbl (%ebx),%eax
80106f8e:	84 c0                	test   %al,%al
80106f90:	75 ee                	jne    80106f80 <uartinit+0x90>
    uartputc(*p);
}
80106f92:	83 c4 1c             	add    $0x1c,%esp
80106f95:	5b                   	pop    %ebx
80106f96:	5e                   	pop    %esi
80106f97:	5f                   	pop    %edi
80106f98:	5d                   	pop    %ebp
80106f99:	c3                   	ret    
80106f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106fa0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106fa6:	c7 04 24 70 6e 10 80 	movl   $0x80106e70,(%esp)
80106fad:	e8 fe 97 ff ff       	call   801007b0 <consoleintr>
}
80106fb2:	c9                   	leave  
80106fb3:	c3                   	ret    

80106fb4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106fb4:	6a 00                	push   $0x0
  pushl $0
80106fb6:	6a 00                	push   $0x0
  jmp alltraps
80106fb8:	e9 40 f9 ff ff       	jmp    801068fd <alltraps>

80106fbd <vector1>:
.globl vector1
vector1:
  pushl $0
80106fbd:	6a 00                	push   $0x0
  pushl $1
80106fbf:	6a 01                	push   $0x1
  jmp alltraps
80106fc1:	e9 37 f9 ff ff       	jmp    801068fd <alltraps>

80106fc6 <vector2>:
.globl vector2
vector2:
  pushl $0
80106fc6:	6a 00                	push   $0x0
  pushl $2
80106fc8:	6a 02                	push   $0x2
  jmp alltraps
80106fca:	e9 2e f9 ff ff       	jmp    801068fd <alltraps>

80106fcf <vector3>:
.globl vector3
vector3:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $3
80106fd1:	6a 03                	push   $0x3
  jmp alltraps
80106fd3:	e9 25 f9 ff ff       	jmp    801068fd <alltraps>

80106fd8 <vector4>:
.globl vector4
vector4:
  pushl $0
80106fd8:	6a 00                	push   $0x0
  pushl $4
80106fda:	6a 04                	push   $0x4
  jmp alltraps
80106fdc:	e9 1c f9 ff ff       	jmp    801068fd <alltraps>

80106fe1 <vector5>:
.globl vector5
vector5:
  pushl $0
80106fe1:	6a 00                	push   $0x0
  pushl $5
80106fe3:	6a 05                	push   $0x5
  jmp alltraps
80106fe5:	e9 13 f9 ff ff       	jmp    801068fd <alltraps>

80106fea <vector6>:
.globl vector6
vector6:
  pushl $0
80106fea:	6a 00                	push   $0x0
  pushl $6
80106fec:	6a 06                	push   $0x6
  jmp alltraps
80106fee:	e9 0a f9 ff ff       	jmp    801068fd <alltraps>

80106ff3 <vector7>:
.globl vector7
vector7:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $7
80106ff5:	6a 07                	push   $0x7
  jmp alltraps
80106ff7:	e9 01 f9 ff ff       	jmp    801068fd <alltraps>

80106ffc <vector8>:
.globl vector8
vector8:
  pushl $8
80106ffc:	6a 08                	push   $0x8
  jmp alltraps
80106ffe:	e9 fa f8 ff ff       	jmp    801068fd <alltraps>

80107003 <vector9>:
.globl vector9
vector9:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $9
80107005:	6a 09                	push   $0x9
  jmp alltraps
80107007:	e9 f1 f8 ff ff       	jmp    801068fd <alltraps>

8010700c <vector10>:
.globl vector10
vector10:
  pushl $10
8010700c:	6a 0a                	push   $0xa
  jmp alltraps
8010700e:	e9 ea f8 ff ff       	jmp    801068fd <alltraps>

80107013 <vector11>:
.globl vector11
vector11:
  pushl $11
80107013:	6a 0b                	push   $0xb
  jmp alltraps
80107015:	e9 e3 f8 ff ff       	jmp    801068fd <alltraps>

8010701a <vector12>:
.globl vector12
vector12:
  pushl $12
8010701a:	6a 0c                	push   $0xc
  jmp alltraps
8010701c:	e9 dc f8 ff ff       	jmp    801068fd <alltraps>

80107021 <vector13>:
.globl vector13
vector13:
  pushl $13
80107021:	6a 0d                	push   $0xd
  jmp alltraps
80107023:	e9 d5 f8 ff ff       	jmp    801068fd <alltraps>

80107028 <vector14>:
.globl vector14
vector14:
  pushl $14
80107028:	6a 0e                	push   $0xe
  jmp alltraps
8010702a:	e9 ce f8 ff ff       	jmp    801068fd <alltraps>

8010702f <vector15>:
.globl vector15
vector15:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $15
80107031:	6a 0f                	push   $0xf
  jmp alltraps
80107033:	e9 c5 f8 ff ff       	jmp    801068fd <alltraps>

80107038 <vector16>:
.globl vector16
vector16:
  pushl $0
80107038:	6a 00                	push   $0x0
  pushl $16
8010703a:	6a 10                	push   $0x10
  jmp alltraps
8010703c:	e9 bc f8 ff ff       	jmp    801068fd <alltraps>

80107041 <vector17>:
.globl vector17
vector17:
  pushl $17
80107041:	6a 11                	push   $0x11
  jmp alltraps
80107043:	e9 b5 f8 ff ff       	jmp    801068fd <alltraps>

80107048 <vector18>:
.globl vector18
vector18:
  pushl $0
80107048:	6a 00                	push   $0x0
  pushl $18
8010704a:	6a 12                	push   $0x12
  jmp alltraps
8010704c:	e9 ac f8 ff ff       	jmp    801068fd <alltraps>

80107051 <vector19>:
.globl vector19
vector19:
  pushl $0
80107051:	6a 00                	push   $0x0
  pushl $19
80107053:	6a 13                	push   $0x13
  jmp alltraps
80107055:	e9 a3 f8 ff ff       	jmp    801068fd <alltraps>

8010705a <vector20>:
.globl vector20
vector20:
  pushl $0
8010705a:	6a 00                	push   $0x0
  pushl $20
8010705c:	6a 14                	push   $0x14
  jmp alltraps
8010705e:	e9 9a f8 ff ff       	jmp    801068fd <alltraps>

80107063 <vector21>:
.globl vector21
vector21:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $21
80107065:	6a 15                	push   $0x15
  jmp alltraps
80107067:	e9 91 f8 ff ff       	jmp    801068fd <alltraps>

8010706c <vector22>:
.globl vector22
vector22:
  pushl $0
8010706c:	6a 00                	push   $0x0
  pushl $22
8010706e:	6a 16                	push   $0x16
  jmp alltraps
80107070:	e9 88 f8 ff ff       	jmp    801068fd <alltraps>

80107075 <vector23>:
.globl vector23
vector23:
  pushl $0
80107075:	6a 00                	push   $0x0
  pushl $23
80107077:	6a 17                	push   $0x17
  jmp alltraps
80107079:	e9 7f f8 ff ff       	jmp    801068fd <alltraps>

8010707e <vector24>:
.globl vector24
vector24:
  pushl $0
8010707e:	6a 00                	push   $0x0
  pushl $24
80107080:	6a 18                	push   $0x18
  jmp alltraps
80107082:	e9 76 f8 ff ff       	jmp    801068fd <alltraps>

80107087 <vector25>:
.globl vector25
vector25:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $25
80107089:	6a 19                	push   $0x19
  jmp alltraps
8010708b:	e9 6d f8 ff ff       	jmp    801068fd <alltraps>

80107090 <vector26>:
.globl vector26
vector26:
  pushl $0
80107090:	6a 00                	push   $0x0
  pushl $26
80107092:	6a 1a                	push   $0x1a
  jmp alltraps
80107094:	e9 64 f8 ff ff       	jmp    801068fd <alltraps>

80107099 <vector27>:
.globl vector27
vector27:
  pushl $0
80107099:	6a 00                	push   $0x0
  pushl $27
8010709b:	6a 1b                	push   $0x1b
  jmp alltraps
8010709d:	e9 5b f8 ff ff       	jmp    801068fd <alltraps>

801070a2 <vector28>:
.globl vector28
vector28:
  pushl $0
801070a2:	6a 00                	push   $0x0
  pushl $28
801070a4:	6a 1c                	push   $0x1c
  jmp alltraps
801070a6:	e9 52 f8 ff ff       	jmp    801068fd <alltraps>

801070ab <vector29>:
.globl vector29
vector29:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $29
801070ad:	6a 1d                	push   $0x1d
  jmp alltraps
801070af:	e9 49 f8 ff ff       	jmp    801068fd <alltraps>

801070b4 <vector30>:
.globl vector30
vector30:
  pushl $0
801070b4:	6a 00                	push   $0x0
  pushl $30
801070b6:	6a 1e                	push   $0x1e
  jmp alltraps
801070b8:	e9 40 f8 ff ff       	jmp    801068fd <alltraps>

801070bd <vector31>:
.globl vector31
vector31:
  pushl $0
801070bd:	6a 00                	push   $0x0
  pushl $31
801070bf:	6a 1f                	push   $0x1f
  jmp alltraps
801070c1:	e9 37 f8 ff ff       	jmp    801068fd <alltraps>

801070c6 <vector32>:
.globl vector32
vector32:
  pushl $0
801070c6:	6a 00                	push   $0x0
  pushl $32
801070c8:	6a 20                	push   $0x20
  jmp alltraps
801070ca:	e9 2e f8 ff ff       	jmp    801068fd <alltraps>

801070cf <vector33>:
.globl vector33
vector33:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $33
801070d1:	6a 21                	push   $0x21
  jmp alltraps
801070d3:	e9 25 f8 ff ff       	jmp    801068fd <alltraps>

801070d8 <vector34>:
.globl vector34
vector34:
  pushl $0
801070d8:	6a 00                	push   $0x0
  pushl $34
801070da:	6a 22                	push   $0x22
  jmp alltraps
801070dc:	e9 1c f8 ff ff       	jmp    801068fd <alltraps>

801070e1 <vector35>:
.globl vector35
vector35:
  pushl $0
801070e1:	6a 00                	push   $0x0
  pushl $35
801070e3:	6a 23                	push   $0x23
  jmp alltraps
801070e5:	e9 13 f8 ff ff       	jmp    801068fd <alltraps>

801070ea <vector36>:
.globl vector36
vector36:
  pushl $0
801070ea:	6a 00                	push   $0x0
  pushl $36
801070ec:	6a 24                	push   $0x24
  jmp alltraps
801070ee:	e9 0a f8 ff ff       	jmp    801068fd <alltraps>

801070f3 <vector37>:
.globl vector37
vector37:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $37
801070f5:	6a 25                	push   $0x25
  jmp alltraps
801070f7:	e9 01 f8 ff ff       	jmp    801068fd <alltraps>

801070fc <vector38>:
.globl vector38
vector38:
  pushl $0
801070fc:	6a 00                	push   $0x0
  pushl $38
801070fe:	6a 26                	push   $0x26
  jmp alltraps
80107100:	e9 f8 f7 ff ff       	jmp    801068fd <alltraps>

80107105 <vector39>:
.globl vector39
vector39:
  pushl $0
80107105:	6a 00                	push   $0x0
  pushl $39
80107107:	6a 27                	push   $0x27
  jmp alltraps
80107109:	e9 ef f7 ff ff       	jmp    801068fd <alltraps>

8010710e <vector40>:
.globl vector40
vector40:
  pushl $0
8010710e:	6a 00                	push   $0x0
  pushl $40
80107110:	6a 28                	push   $0x28
  jmp alltraps
80107112:	e9 e6 f7 ff ff       	jmp    801068fd <alltraps>

80107117 <vector41>:
.globl vector41
vector41:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $41
80107119:	6a 29                	push   $0x29
  jmp alltraps
8010711b:	e9 dd f7 ff ff       	jmp    801068fd <alltraps>

80107120 <vector42>:
.globl vector42
vector42:
  pushl $0
80107120:	6a 00                	push   $0x0
  pushl $42
80107122:	6a 2a                	push   $0x2a
  jmp alltraps
80107124:	e9 d4 f7 ff ff       	jmp    801068fd <alltraps>

80107129 <vector43>:
.globl vector43
vector43:
  pushl $0
80107129:	6a 00                	push   $0x0
  pushl $43
8010712b:	6a 2b                	push   $0x2b
  jmp alltraps
8010712d:	e9 cb f7 ff ff       	jmp    801068fd <alltraps>

80107132 <vector44>:
.globl vector44
vector44:
  pushl $0
80107132:	6a 00                	push   $0x0
  pushl $44
80107134:	6a 2c                	push   $0x2c
  jmp alltraps
80107136:	e9 c2 f7 ff ff       	jmp    801068fd <alltraps>

8010713b <vector45>:
.globl vector45
vector45:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $45
8010713d:	6a 2d                	push   $0x2d
  jmp alltraps
8010713f:	e9 b9 f7 ff ff       	jmp    801068fd <alltraps>

80107144 <vector46>:
.globl vector46
vector46:
  pushl $0
80107144:	6a 00                	push   $0x0
  pushl $46
80107146:	6a 2e                	push   $0x2e
  jmp alltraps
80107148:	e9 b0 f7 ff ff       	jmp    801068fd <alltraps>

8010714d <vector47>:
.globl vector47
vector47:
  pushl $0
8010714d:	6a 00                	push   $0x0
  pushl $47
8010714f:	6a 2f                	push   $0x2f
  jmp alltraps
80107151:	e9 a7 f7 ff ff       	jmp    801068fd <alltraps>

80107156 <vector48>:
.globl vector48
vector48:
  pushl $0
80107156:	6a 00                	push   $0x0
  pushl $48
80107158:	6a 30                	push   $0x30
  jmp alltraps
8010715a:	e9 9e f7 ff ff       	jmp    801068fd <alltraps>

8010715f <vector49>:
.globl vector49
vector49:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $49
80107161:	6a 31                	push   $0x31
  jmp alltraps
80107163:	e9 95 f7 ff ff       	jmp    801068fd <alltraps>

80107168 <vector50>:
.globl vector50
vector50:
  pushl $0
80107168:	6a 00                	push   $0x0
  pushl $50
8010716a:	6a 32                	push   $0x32
  jmp alltraps
8010716c:	e9 8c f7 ff ff       	jmp    801068fd <alltraps>

80107171 <vector51>:
.globl vector51
vector51:
  pushl $0
80107171:	6a 00                	push   $0x0
  pushl $51
80107173:	6a 33                	push   $0x33
  jmp alltraps
80107175:	e9 83 f7 ff ff       	jmp    801068fd <alltraps>

8010717a <vector52>:
.globl vector52
vector52:
  pushl $0
8010717a:	6a 00                	push   $0x0
  pushl $52
8010717c:	6a 34                	push   $0x34
  jmp alltraps
8010717e:	e9 7a f7 ff ff       	jmp    801068fd <alltraps>

80107183 <vector53>:
.globl vector53
vector53:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $53
80107185:	6a 35                	push   $0x35
  jmp alltraps
80107187:	e9 71 f7 ff ff       	jmp    801068fd <alltraps>

8010718c <vector54>:
.globl vector54
vector54:
  pushl $0
8010718c:	6a 00                	push   $0x0
  pushl $54
8010718e:	6a 36                	push   $0x36
  jmp alltraps
80107190:	e9 68 f7 ff ff       	jmp    801068fd <alltraps>

80107195 <vector55>:
.globl vector55
vector55:
  pushl $0
80107195:	6a 00                	push   $0x0
  pushl $55
80107197:	6a 37                	push   $0x37
  jmp alltraps
80107199:	e9 5f f7 ff ff       	jmp    801068fd <alltraps>

8010719e <vector56>:
.globl vector56
vector56:
  pushl $0
8010719e:	6a 00                	push   $0x0
  pushl $56
801071a0:	6a 38                	push   $0x38
  jmp alltraps
801071a2:	e9 56 f7 ff ff       	jmp    801068fd <alltraps>

801071a7 <vector57>:
.globl vector57
vector57:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $57
801071a9:	6a 39                	push   $0x39
  jmp alltraps
801071ab:	e9 4d f7 ff ff       	jmp    801068fd <alltraps>

801071b0 <vector58>:
.globl vector58
vector58:
  pushl $0
801071b0:	6a 00                	push   $0x0
  pushl $58
801071b2:	6a 3a                	push   $0x3a
  jmp alltraps
801071b4:	e9 44 f7 ff ff       	jmp    801068fd <alltraps>

801071b9 <vector59>:
.globl vector59
vector59:
  pushl $0
801071b9:	6a 00                	push   $0x0
  pushl $59
801071bb:	6a 3b                	push   $0x3b
  jmp alltraps
801071bd:	e9 3b f7 ff ff       	jmp    801068fd <alltraps>

801071c2 <vector60>:
.globl vector60
vector60:
  pushl $0
801071c2:	6a 00                	push   $0x0
  pushl $60
801071c4:	6a 3c                	push   $0x3c
  jmp alltraps
801071c6:	e9 32 f7 ff ff       	jmp    801068fd <alltraps>

801071cb <vector61>:
.globl vector61
vector61:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $61
801071cd:	6a 3d                	push   $0x3d
  jmp alltraps
801071cf:	e9 29 f7 ff ff       	jmp    801068fd <alltraps>

801071d4 <vector62>:
.globl vector62
vector62:
  pushl $0
801071d4:	6a 00                	push   $0x0
  pushl $62
801071d6:	6a 3e                	push   $0x3e
  jmp alltraps
801071d8:	e9 20 f7 ff ff       	jmp    801068fd <alltraps>

801071dd <vector63>:
.globl vector63
vector63:
  pushl $0
801071dd:	6a 00                	push   $0x0
  pushl $63
801071df:	6a 3f                	push   $0x3f
  jmp alltraps
801071e1:	e9 17 f7 ff ff       	jmp    801068fd <alltraps>

801071e6 <vector64>:
.globl vector64
vector64:
  pushl $0
801071e6:	6a 00                	push   $0x0
  pushl $64
801071e8:	6a 40                	push   $0x40
  jmp alltraps
801071ea:	e9 0e f7 ff ff       	jmp    801068fd <alltraps>

801071ef <vector65>:
.globl vector65
vector65:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $65
801071f1:	6a 41                	push   $0x41
  jmp alltraps
801071f3:	e9 05 f7 ff ff       	jmp    801068fd <alltraps>

801071f8 <vector66>:
.globl vector66
vector66:
  pushl $0
801071f8:	6a 00                	push   $0x0
  pushl $66
801071fa:	6a 42                	push   $0x42
  jmp alltraps
801071fc:	e9 fc f6 ff ff       	jmp    801068fd <alltraps>

80107201 <vector67>:
.globl vector67
vector67:
  pushl $0
80107201:	6a 00                	push   $0x0
  pushl $67
80107203:	6a 43                	push   $0x43
  jmp alltraps
80107205:	e9 f3 f6 ff ff       	jmp    801068fd <alltraps>

8010720a <vector68>:
.globl vector68
vector68:
  pushl $0
8010720a:	6a 00                	push   $0x0
  pushl $68
8010720c:	6a 44                	push   $0x44
  jmp alltraps
8010720e:	e9 ea f6 ff ff       	jmp    801068fd <alltraps>

80107213 <vector69>:
.globl vector69
vector69:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $69
80107215:	6a 45                	push   $0x45
  jmp alltraps
80107217:	e9 e1 f6 ff ff       	jmp    801068fd <alltraps>

8010721c <vector70>:
.globl vector70
vector70:
  pushl $0
8010721c:	6a 00                	push   $0x0
  pushl $70
8010721e:	6a 46                	push   $0x46
  jmp alltraps
80107220:	e9 d8 f6 ff ff       	jmp    801068fd <alltraps>

80107225 <vector71>:
.globl vector71
vector71:
  pushl $0
80107225:	6a 00                	push   $0x0
  pushl $71
80107227:	6a 47                	push   $0x47
  jmp alltraps
80107229:	e9 cf f6 ff ff       	jmp    801068fd <alltraps>

8010722e <vector72>:
.globl vector72
vector72:
  pushl $0
8010722e:	6a 00                	push   $0x0
  pushl $72
80107230:	6a 48                	push   $0x48
  jmp alltraps
80107232:	e9 c6 f6 ff ff       	jmp    801068fd <alltraps>

80107237 <vector73>:
.globl vector73
vector73:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $73
80107239:	6a 49                	push   $0x49
  jmp alltraps
8010723b:	e9 bd f6 ff ff       	jmp    801068fd <alltraps>

80107240 <vector74>:
.globl vector74
vector74:
  pushl $0
80107240:	6a 00                	push   $0x0
  pushl $74
80107242:	6a 4a                	push   $0x4a
  jmp alltraps
80107244:	e9 b4 f6 ff ff       	jmp    801068fd <alltraps>

80107249 <vector75>:
.globl vector75
vector75:
  pushl $0
80107249:	6a 00                	push   $0x0
  pushl $75
8010724b:	6a 4b                	push   $0x4b
  jmp alltraps
8010724d:	e9 ab f6 ff ff       	jmp    801068fd <alltraps>

80107252 <vector76>:
.globl vector76
vector76:
  pushl $0
80107252:	6a 00                	push   $0x0
  pushl $76
80107254:	6a 4c                	push   $0x4c
  jmp alltraps
80107256:	e9 a2 f6 ff ff       	jmp    801068fd <alltraps>

8010725b <vector77>:
.globl vector77
vector77:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $77
8010725d:	6a 4d                	push   $0x4d
  jmp alltraps
8010725f:	e9 99 f6 ff ff       	jmp    801068fd <alltraps>

80107264 <vector78>:
.globl vector78
vector78:
  pushl $0
80107264:	6a 00                	push   $0x0
  pushl $78
80107266:	6a 4e                	push   $0x4e
  jmp alltraps
80107268:	e9 90 f6 ff ff       	jmp    801068fd <alltraps>

8010726d <vector79>:
.globl vector79
vector79:
  pushl $0
8010726d:	6a 00                	push   $0x0
  pushl $79
8010726f:	6a 4f                	push   $0x4f
  jmp alltraps
80107271:	e9 87 f6 ff ff       	jmp    801068fd <alltraps>

80107276 <vector80>:
.globl vector80
vector80:
  pushl $0
80107276:	6a 00                	push   $0x0
  pushl $80
80107278:	6a 50                	push   $0x50
  jmp alltraps
8010727a:	e9 7e f6 ff ff       	jmp    801068fd <alltraps>

8010727f <vector81>:
.globl vector81
vector81:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $81
80107281:	6a 51                	push   $0x51
  jmp alltraps
80107283:	e9 75 f6 ff ff       	jmp    801068fd <alltraps>

80107288 <vector82>:
.globl vector82
vector82:
  pushl $0
80107288:	6a 00                	push   $0x0
  pushl $82
8010728a:	6a 52                	push   $0x52
  jmp alltraps
8010728c:	e9 6c f6 ff ff       	jmp    801068fd <alltraps>

80107291 <vector83>:
.globl vector83
vector83:
  pushl $0
80107291:	6a 00                	push   $0x0
  pushl $83
80107293:	6a 53                	push   $0x53
  jmp alltraps
80107295:	e9 63 f6 ff ff       	jmp    801068fd <alltraps>

8010729a <vector84>:
.globl vector84
vector84:
  pushl $0
8010729a:	6a 00                	push   $0x0
  pushl $84
8010729c:	6a 54                	push   $0x54
  jmp alltraps
8010729e:	e9 5a f6 ff ff       	jmp    801068fd <alltraps>

801072a3 <vector85>:
.globl vector85
vector85:
  pushl $0
801072a3:	6a 00                	push   $0x0
  pushl $85
801072a5:	6a 55                	push   $0x55
  jmp alltraps
801072a7:	e9 51 f6 ff ff       	jmp    801068fd <alltraps>

801072ac <vector86>:
.globl vector86
vector86:
  pushl $0
801072ac:	6a 00                	push   $0x0
  pushl $86
801072ae:	6a 56                	push   $0x56
  jmp alltraps
801072b0:	e9 48 f6 ff ff       	jmp    801068fd <alltraps>

801072b5 <vector87>:
.globl vector87
vector87:
  pushl $0
801072b5:	6a 00                	push   $0x0
  pushl $87
801072b7:	6a 57                	push   $0x57
  jmp alltraps
801072b9:	e9 3f f6 ff ff       	jmp    801068fd <alltraps>

801072be <vector88>:
.globl vector88
vector88:
  pushl $0
801072be:	6a 00                	push   $0x0
  pushl $88
801072c0:	6a 58                	push   $0x58
  jmp alltraps
801072c2:	e9 36 f6 ff ff       	jmp    801068fd <alltraps>

801072c7 <vector89>:
.globl vector89
vector89:
  pushl $0
801072c7:	6a 00                	push   $0x0
  pushl $89
801072c9:	6a 59                	push   $0x59
  jmp alltraps
801072cb:	e9 2d f6 ff ff       	jmp    801068fd <alltraps>

801072d0 <vector90>:
.globl vector90
vector90:
  pushl $0
801072d0:	6a 00                	push   $0x0
  pushl $90
801072d2:	6a 5a                	push   $0x5a
  jmp alltraps
801072d4:	e9 24 f6 ff ff       	jmp    801068fd <alltraps>

801072d9 <vector91>:
.globl vector91
vector91:
  pushl $0
801072d9:	6a 00                	push   $0x0
  pushl $91
801072db:	6a 5b                	push   $0x5b
  jmp alltraps
801072dd:	e9 1b f6 ff ff       	jmp    801068fd <alltraps>

801072e2 <vector92>:
.globl vector92
vector92:
  pushl $0
801072e2:	6a 00                	push   $0x0
  pushl $92
801072e4:	6a 5c                	push   $0x5c
  jmp alltraps
801072e6:	e9 12 f6 ff ff       	jmp    801068fd <alltraps>

801072eb <vector93>:
.globl vector93
vector93:
  pushl $0
801072eb:	6a 00                	push   $0x0
  pushl $93
801072ed:	6a 5d                	push   $0x5d
  jmp alltraps
801072ef:	e9 09 f6 ff ff       	jmp    801068fd <alltraps>

801072f4 <vector94>:
.globl vector94
vector94:
  pushl $0
801072f4:	6a 00                	push   $0x0
  pushl $94
801072f6:	6a 5e                	push   $0x5e
  jmp alltraps
801072f8:	e9 00 f6 ff ff       	jmp    801068fd <alltraps>

801072fd <vector95>:
.globl vector95
vector95:
  pushl $0
801072fd:	6a 00                	push   $0x0
  pushl $95
801072ff:	6a 5f                	push   $0x5f
  jmp alltraps
80107301:	e9 f7 f5 ff ff       	jmp    801068fd <alltraps>

80107306 <vector96>:
.globl vector96
vector96:
  pushl $0
80107306:	6a 00                	push   $0x0
  pushl $96
80107308:	6a 60                	push   $0x60
  jmp alltraps
8010730a:	e9 ee f5 ff ff       	jmp    801068fd <alltraps>

8010730f <vector97>:
.globl vector97
vector97:
  pushl $0
8010730f:	6a 00                	push   $0x0
  pushl $97
80107311:	6a 61                	push   $0x61
  jmp alltraps
80107313:	e9 e5 f5 ff ff       	jmp    801068fd <alltraps>

80107318 <vector98>:
.globl vector98
vector98:
  pushl $0
80107318:	6a 00                	push   $0x0
  pushl $98
8010731a:	6a 62                	push   $0x62
  jmp alltraps
8010731c:	e9 dc f5 ff ff       	jmp    801068fd <alltraps>

80107321 <vector99>:
.globl vector99
vector99:
  pushl $0
80107321:	6a 00                	push   $0x0
  pushl $99
80107323:	6a 63                	push   $0x63
  jmp alltraps
80107325:	e9 d3 f5 ff ff       	jmp    801068fd <alltraps>

8010732a <vector100>:
.globl vector100
vector100:
  pushl $0
8010732a:	6a 00                	push   $0x0
  pushl $100
8010732c:	6a 64                	push   $0x64
  jmp alltraps
8010732e:	e9 ca f5 ff ff       	jmp    801068fd <alltraps>

80107333 <vector101>:
.globl vector101
vector101:
  pushl $0
80107333:	6a 00                	push   $0x0
  pushl $101
80107335:	6a 65                	push   $0x65
  jmp alltraps
80107337:	e9 c1 f5 ff ff       	jmp    801068fd <alltraps>

8010733c <vector102>:
.globl vector102
vector102:
  pushl $0
8010733c:	6a 00                	push   $0x0
  pushl $102
8010733e:	6a 66                	push   $0x66
  jmp alltraps
80107340:	e9 b8 f5 ff ff       	jmp    801068fd <alltraps>

80107345 <vector103>:
.globl vector103
vector103:
  pushl $0
80107345:	6a 00                	push   $0x0
  pushl $103
80107347:	6a 67                	push   $0x67
  jmp alltraps
80107349:	e9 af f5 ff ff       	jmp    801068fd <alltraps>

8010734e <vector104>:
.globl vector104
vector104:
  pushl $0
8010734e:	6a 00                	push   $0x0
  pushl $104
80107350:	6a 68                	push   $0x68
  jmp alltraps
80107352:	e9 a6 f5 ff ff       	jmp    801068fd <alltraps>

80107357 <vector105>:
.globl vector105
vector105:
  pushl $0
80107357:	6a 00                	push   $0x0
  pushl $105
80107359:	6a 69                	push   $0x69
  jmp alltraps
8010735b:	e9 9d f5 ff ff       	jmp    801068fd <alltraps>

80107360 <vector106>:
.globl vector106
vector106:
  pushl $0
80107360:	6a 00                	push   $0x0
  pushl $106
80107362:	6a 6a                	push   $0x6a
  jmp alltraps
80107364:	e9 94 f5 ff ff       	jmp    801068fd <alltraps>

80107369 <vector107>:
.globl vector107
vector107:
  pushl $0
80107369:	6a 00                	push   $0x0
  pushl $107
8010736b:	6a 6b                	push   $0x6b
  jmp alltraps
8010736d:	e9 8b f5 ff ff       	jmp    801068fd <alltraps>

80107372 <vector108>:
.globl vector108
vector108:
  pushl $0
80107372:	6a 00                	push   $0x0
  pushl $108
80107374:	6a 6c                	push   $0x6c
  jmp alltraps
80107376:	e9 82 f5 ff ff       	jmp    801068fd <alltraps>

8010737b <vector109>:
.globl vector109
vector109:
  pushl $0
8010737b:	6a 00                	push   $0x0
  pushl $109
8010737d:	6a 6d                	push   $0x6d
  jmp alltraps
8010737f:	e9 79 f5 ff ff       	jmp    801068fd <alltraps>

80107384 <vector110>:
.globl vector110
vector110:
  pushl $0
80107384:	6a 00                	push   $0x0
  pushl $110
80107386:	6a 6e                	push   $0x6e
  jmp alltraps
80107388:	e9 70 f5 ff ff       	jmp    801068fd <alltraps>

8010738d <vector111>:
.globl vector111
vector111:
  pushl $0
8010738d:	6a 00                	push   $0x0
  pushl $111
8010738f:	6a 6f                	push   $0x6f
  jmp alltraps
80107391:	e9 67 f5 ff ff       	jmp    801068fd <alltraps>

80107396 <vector112>:
.globl vector112
vector112:
  pushl $0
80107396:	6a 00                	push   $0x0
  pushl $112
80107398:	6a 70                	push   $0x70
  jmp alltraps
8010739a:	e9 5e f5 ff ff       	jmp    801068fd <alltraps>

8010739f <vector113>:
.globl vector113
vector113:
  pushl $0
8010739f:	6a 00                	push   $0x0
  pushl $113
801073a1:	6a 71                	push   $0x71
  jmp alltraps
801073a3:	e9 55 f5 ff ff       	jmp    801068fd <alltraps>

801073a8 <vector114>:
.globl vector114
vector114:
  pushl $0
801073a8:	6a 00                	push   $0x0
  pushl $114
801073aa:	6a 72                	push   $0x72
  jmp alltraps
801073ac:	e9 4c f5 ff ff       	jmp    801068fd <alltraps>

801073b1 <vector115>:
.globl vector115
vector115:
  pushl $0
801073b1:	6a 00                	push   $0x0
  pushl $115
801073b3:	6a 73                	push   $0x73
  jmp alltraps
801073b5:	e9 43 f5 ff ff       	jmp    801068fd <alltraps>

801073ba <vector116>:
.globl vector116
vector116:
  pushl $0
801073ba:	6a 00                	push   $0x0
  pushl $116
801073bc:	6a 74                	push   $0x74
  jmp alltraps
801073be:	e9 3a f5 ff ff       	jmp    801068fd <alltraps>

801073c3 <vector117>:
.globl vector117
vector117:
  pushl $0
801073c3:	6a 00                	push   $0x0
  pushl $117
801073c5:	6a 75                	push   $0x75
  jmp alltraps
801073c7:	e9 31 f5 ff ff       	jmp    801068fd <alltraps>

801073cc <vector118>:
.globl vector118
vector118:
  pushl $0
801073cc:	6a 00                	push   $0x0
  pushl $118
801073ce:	6a 76                	push   $0x76
  jmp alltraps
801073d0:	e9 28 f5 ff ff       	jmp    801068fd <alltraps>

801073d5 <vector119>:
.globl vector119
vector119:
  pushl $0
801073d5:	6a 00                	push   $0x0
  pushl $119
801073d7:	6a 77                	push   $0x77
  jmp alltraps
801073d9:	e9 1f f5 ff ff       	jmp    801068fd <alltraps>

801073de <vector120>:
.globl vector120
vector120:
  pushl $0
801073de:	6a 00                	push   $0x0
  pushl $120
801073e0:	6a 78                	push   $0x78
  jmp alltraps
801073e2:	e9 16 f5 ff ff       	jmp    801068fd <alltraps>

801073e7 <vector121>:
.globl vector121
vector121:
  pushl $0
801073e7:	6a 00                	push   $0x0
  pushl $121
801073e9:	6a 79                	push   $0x79
  jmp alltraps
801073eb:	e9 0d f5 ff ff       	jmp    801068fd <alltraps>

801073f0 <vector122>:
.globl vector122
vector122:
  pushl $0
801073f0:	6a 00                	push   $0x0
  pushl $122
801073f2:	6a 7a                	push   $0x7a
  jmp alltraps
801073f4:	e9 04 f5 ff ff       	jmp    801068fd <alltraps>

801073f9 <vector123>:
.globl vector123
vector123:
  pushl $0
801073f9:	6a 00                	push   $0x0
  pushl $123
801073fb:	6a 7b                	push   $0x7b
  jmp alltraps
801073fd:	e9 fb f4 ff ff       	jmp    801068fd <alltraps>

80107402 <vector124>:
.globl vector124
vector124:
  pushl $0
80107402:	6a 00                	push   $0x0
  pushl $124
80107404:	6a 7c                	push   $0x7c
  jmp alltraps
80107406:	e9 f2 f4 ff ff       	jmp    801068fd <alltraps>

8010740b <vector125>:
.globl vector125
vector125:
  pushl $0
8010740b:	6a 00                	push   $0x0
  pushl $125
8010740d:	6a 7d                	push   $0x7d
  jmp alltraps
8010740f:	e9 e9 f4 ff ff       	jmp    801068fd <alltraps>

80107414 <vector126>:
.globl vector126
vector126:
  pushl $0
80107414:	6a 00                	push   $0x0
  pushl $126
80107416:	6a 7e                	push   $0x7e
  jmp alltraps
80107418:	e9 e0 f4 ff ff       	jmp    801068fd <alltraps>

8010741d <vector127>:
.globl vector127
vector127:
  pushl $0
8010741d:	6a 00                	push   $0x0
  pushl $127
8010741f:	6a 7f                	push   $0x7f
  jmp alltraps
80107421:	e9 d7 f4 ff ff       	jmp    801068fd <alltraps>

80107426 <vector128>:
.globl vector128
vector128:
  pushl $0
80107426:	6a 00                	push   $0x0
  pushl $128
80107428:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010742d:	e9 cb f4 ff ff       	jmp    801068fd <alltraps>

80107432 <vector129>:
.globl vector129
vector129:
  pushl $0
80107432:	6a 00                	push   $0x0
  pushl $129
80107434:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107439:	e9 bf f4 ff ff       	jmp    801068fd <alltraps>

8010743e <vector130>:
.globl vector130
vector130:
  pushl $0
8010743e:	6a 00                	push   $0x0
  pushl $130
80107440:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107445:	e9 b3 f4 ff ff       	jmp    801068fd <alltraps>

8010744a <vector131>:
.globl vector131
vector131:
  pushl $0
8010744a:	6a 00                	push   $0x0
  pushl $131
8010744c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107451:	e9 a7 f4 ff ff       	jmp    801068fd <alltraps>

80107456 <vector132>:
.globl vector132
vector132:
  pushl $0
80107456:	6a 00                	push   $0x0
  pushl $132
80107458:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010745d:	e9 9b f4 ff ff       	jmp    801068fd <alltraps>

80107462 <vector133>:
.globl vector133
vector133:
  pushl $0
80107462:	6a 00                	push   $0x0
  pushl $133
80107464:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107469:	e9 8f f4 ff ff       	jmp    801068fd <alltraps>

8010746e <vector134>:
.globl vector134
vector134:
  pushl $0
8010746e:	6a 00                	push   $0x0
  pushl $134
80107470:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107475:	e9 83 f4 ff ff       	jmp    801068fd <alltraps>

8010747a <vector135>:
.globl vector135
vector135:
  pushl $0
8010747a:	6a 00                	push   $0x0
  pushl $135
8010747c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107481:	e9 77 f4 ff ff       	jmp    801068fd <alltraps>

80107486 <vector136>:
.globl vector136
vector136:
  pushl $0
80107486:	6a 00                	push   $0x0
  pushl $136
80107488:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010748d:	e9 6b f4 ff ff       	jmp    801068fd <alltraps>

80107492 <vector137>:
.globl vector137
vector137:
  pushl $0
80107492:	6a 00                	push   $0x0
  pushl $137
80107494:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107499:	e9 5f f4 ff ff       	jmp    801068fd <alltraps>

8010749e <vector138>:
.globl vector138
vector138:
  pushl $0
8010749e:	6a 00                	push   $0x0
  pushl $138
801074a0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801074a5:	e9 53 f4 ff ff       	jmp    801068fd <alltraps>

801074aa <vector139>:
.globl vector139
vector139:
  pushl $0
801074aa:	6a 00                	push   $0x0
  pushl $139
801074ac:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801074b1:	e9 47 f4 ff ff       	jmp    801068fd <alltraps>

801074b6 <vector140>:
.globl vector140
vector140:
  pushl $0
801074b6:	6a 00                	push   $0x0
  pushl $140
801074b8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801074bd:	e9 3b f4 ff ff       	jmp    801068fd <alltraps>

801074c2 <vector141>:
.globl vector141
vector141:
  pushl $0
801074c2:	6a 00                	push   $0x0
  pushl $141
801074c4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801074c9:	e9 2f f4 ff ff       	jmp    801068fd <alltraps>

801074ce <vector142>:
.globl vector142
vector142:
  pushl $0
801074ce:	6a 00                	push   $0x0
  pushl $142
801074d0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801074d5:	e9 23 f4 ff ff       	jmp    801068fd <alltraps>

801074da <vector143>:
.globl vector143
vector143:
  pushl $0
801074da:	6a 00                	push   $0x0
  pushl $143
801074dc:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801074e1:	e9 17 f4 ff ff       	jmp    801068fd <alltraps>

801074e6 <vector144>:
.globl vector144
vector144:
  pushl $0
801074e6:	6a 00                	push   $0x0
  pushl $144
801074e8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801074ed:	e9 0b f4 ff ff       	jmp    801068fd <alltraps>

801074f2 <vector145>:
.globl vector145
vector145:
  pushl $0
801074f2:	6a 00                	push   $0x0
  pushl $145
801074f4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801074f9:	e9 ff f3 ff ff       	jmp    801068fd <alltraps>

801074fe <vector146>:
.globl vector146
vector146:
  pushl $0
801074fe:	6a 00                	push   $0x0
  pushl $146
80107500:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107505:	e9 f3 f3 ff ff       	jmp    801068fd <alltraps>

8010750a <vector147>:
.globl vector147
vector147:
  pushl $0
8010750a:	6a 00                	push   $0x0
  pushl $147
8010750c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107511:	e9 e7 f3 ff ff       	jmp    801068fd <alltraps>

80107516 <vector148>:
.globl vector148
vector148:
  pushl $0
80107516:	6a 00                	push   $0x0
  pushl $148
80107518:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010751d:	e9 db f3 ff ff       	jmp    801068fd <alltraps>

80107522 <vector149>:
.globl vector149
vector149:
  pushl $0
80107522:	6a 00                	push   $0x0
  pushl $149
80107524:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107529:	e9 cf f3 ff ff       	jmp    801068fd <alltraps>

8010752e <vector150>:
.globl vector150
vector150:
  pushl $0
8010752e:	6a 00                	push   $0x0
  pushl $150
80107530:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107535:	e9 c3 f3 ff ff       	jmp    801068fd <alltraps>

8010753a <vector151>:
.globl vector151
vector151:
  pushl $0
8010753a:	6a 00                	push   $0x0
  pushl $151
8010753c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107541:	e9 b7 f3 ff ff       	jmp    801068fd <alltraps>

80107546 <vector152>:
.globl vector152
vector152:
  pushl $0
80107546:	6a 00                	push   $0x0
  pushl $152
80107548:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010754d:	e9 ab f3 ff ff       	jmp    801068fd <alltraps>

80107552 <vector153>:
.globl vector153
vector153:
  pushl $0
80107552:	6a 00                	push   $0x0
  pushl $153
80107554:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107559:	e9 9f f3 ff ff       	jmp    801068fd <alltraps>

8010755e <vector154>:
.globl vector154
vector154:
  pushl $0
8010755e:	6a 00                	push   $0x0
  pushl $154
80107560:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107565:	e9 93 f3 ff ff       	jmp    801068fd <alltraps>

8010756a <vector155>:
.globl vector155
vector155:
  pushl $0
8010756a:	6a 00                	push   $0x0
  pushl $155
8010756c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107571:	e9 87 f3 ff ff       	jmp    801068fd <alltraps>

80107576 <vector156>:
.globl vector156
vector156:
  pushl $0
80107576:	6a 00                	push   $0x0
  pushl $156
80107578:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010757d:	e9 7b f3 ff ff       	jmp    801068fd <alltraps>

80107582 <vector157>:
.globl vector157
vector157:
  pushl $0
80107582:	6a 00                	push   $0x0
  pushl $157
80107584:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107589:	e9 6f f3 ff ff       	jmp    801068fd <alltraps>

8010758e <vector158>:
.globl vector158
vector158:
  pushl $0
8010758e:	6a 00                	push   $0x0
  pushl $158
80107590:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107595:	e9 63 f3 ff ff       	jmp    801068fd <alltraps>

8010759a <vector159>:
.globl vector159
vector159:
  pushl $0
8010759a:	6a 00                	push   $0x0
  pushl $159
8010759c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801075a1:	e9 57 f3 ff ff       	jmp    801068fd <alltraps>

801075a6 <vector160>:
.globl vector160
vector160:
  pushl $0
801075a6:	6a 00                	push   $0x0
  pushl $160
801075a8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801075ad:	e9 4b f3 ff ff       	jmp    801068fd <alltraps>

801075b2 <vector161>:
.globl vector161
vector161:
  pushl $0
801075b2:	6a 00                	push   $0x0
  pushl $161
801075b4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801075b9:	e9 3f f3 ff ff       	jmp    801068fd <alltraps>

801075be <vector162>:
.globl vector162
vector162:
  pushl $0
801075be:	6a 00                	push   $0x0
  pushl $162
801075c0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801075c5:	e9 33 f3 ff ff       	jmp    801068fd <alltraps>

801075ca <vector163>:
.globl vector163
vector163:
  pushl $0
801075ca:	6a 00                	push   $0x0
  pushl $163
801075cc:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801075d1:	e9 27 f3 ff ff       	jmp    801068fd <alltraps>

801075d6 <vector164>:
.globl vector164
vector164:
  pushl $0
801075d6:	6a 00                	push   $0x0
  pushl $164
801075d8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801075dd:	e9 1b f3 ff ff       	jmp    801068fd <alltraps>

801075e2 <vector165>:
.globl vector165
vector165:
  pushl $0
801075e2:	6a 00                	push   $0x0
  pushl $165
801075e4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801075e9:	e9 0f f3 ff ff       	jmp    801068fd <alltraps>

801075ee <vector166>:
.globl vector166
vector166:
  pushl $0
801075ee:	6a 00                	push   $0x0
  pushl $166
801075f0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801075f5:	e9 03 f3 ff ff       	jmp    801068fd <alltraps>

801075fa <vector167>:
.globl vector167
vector167:
  pushl $0
801075fa:	6a 00                	push   $0x0
  pushl $167
801075fc:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107601:	e9 f7 f2 ff ff       	jmp    801068fd <alltraps>

80107606 <vector168>:
.globl vector168
vector168:
  pushl $0
80107606:	6a 00                	push   $0x0
  pushl $168
80107608:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010760d:	e9 eb f2 ff ff       	jmp    801068fd <alltraps>

80107612 <vector169>:
.globl vector169
vector169:
  pushl $0
80107612:	6a 00                	push   $0x0
  pushl $169
80107614:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107619:	e9 df f2 ff ff       	jmp    801068fd <alltraps>

8010761e <vector170>:
.globl vector170
vector170:
  pushl $0
8010761e:	6a 00                	push   $0x0
  pushl $170
80107620:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107625:	e9 d3 f2 ff ff       	jmp    801068fd <alltraps>

8010762a <vector171>:
.globl vector171
vector171:
  pushl $0
8010762a:	6a 00                	push   $0x0
  pushl $171
8010762c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107631:	e9 c7 f2 ff ff       	jmp    801068fd <alltraps>

80107636 <vector172>:
.globl vector172
vector172:
  pushl $0
80107636:	6a 00                	push   $0x0
  pushl $172
80107638:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010763d:	e9 bb f2 ff ff       	jmp    801068fd <alltraps>

80107642 <vector173>:
.globl vector173
vector173:
  pushl $0
80107642:	6a 00                	push   $0x0
  pushl $173
80107644:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107649:	e9 af f2 ff ff       	jmp    801068fd <alltraps>

8010764e <vector174>:
.globl vector174
vector174:
  pushl $0
8010764e:	6a 00                	push   $0x0
  pushl $174
80107650:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107655:	e9 a3 f2 ff ff       	jmp    801068fd <alltraps>

8010765a <vector175>:
.globl vector175
vector175:
  pushl $0
8010765a:	6a 00                	push   $0x0
  pushl $175
8010765c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107661:	e9 97 f2 ff ff       	jmp    801068fd <alltraps>

80107666 <vector176>:
.globl vector176
vector176:
  pushl $0
80107666:	6a 00                	push   $0x0
  pushl $176
80107668:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010766d:	e9 8b f2 ff ff       	jmp    801068fd <alltraps>

80107672 <vector177>:
.globl vector177
vector177:
  pushl $0
80107672:	6a 00                	push   $0x0
  pushl $177
80107674:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107679:	e9 7f f2 ff ff       	jmp    801068fd <alltraps>

8010767e <vector178>:
.globl vector178
vector178:
  pushl $0
8010767e:	6a 00                	push   $0x0
  pushl $178
80107680:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107685:	e9 73 f2 ff ff       	jmp    801068fd <alltraps>

8010768a <vector179>:
.globl vector179
vector179:
  pushl $0
8010768a:	6a 00                	push   $0x0
  pushl $179
8010768c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107691:	e9 67 f2 ff ff       	jmp    801068fd <alltraps>

80107696 <vector180>:
.globl vector180
vector180:
  pushl $0
80107696:	6a 00                	push   $0x0
  pushl $180
80107698:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010769d:	e9 5b f2 ff ff       	jmp    801068fd <alltraps>

801076a2 <vector181>:
.globl vector181
vector181:
  pushl $0
801076a2:	6a 00                	push   $0x0
  pushl $181
801076a4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801076a9:	e9 4f f2 ff ff       	jmp    801068fd <alltraps>

801076ae <vector182>:
.globl vector182
vector182:
  pushl $0
801076ae:	6a 00                	push   $0x0
  pushl $182
801076b0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801076b5:	e9 43 f2 ff ff       	jmp    801068fd <alltraps>

801076ba <vector183>:
.globl vector183
vector183:
  pushl $0
801076ba:	6a 00                	push   $0x0
  pushl $183
801076bc:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801076c1:	e9 37 f2 ff ff       	jmp    801068fd <alltraps>

801076c6 <vector184>:
.globl vector184
vector184:
  pushl $0
801076c6:	6a 00                	push   $0x0
  pushl $184
801076c8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801076cd:	e9 2b f2 ff ff       	jmp    801068fd <alltraps>

801076d2 <vector185>:
.globl vector185
vector185:
  pushl $0
801076d2:	6a 00                	push   $0x0
  pushl $185
801076d4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801076d9:	e9 1f f2 ff ff       	jmp    801068fd <alltraps>

801076de <vector186>:
.globl vector186
vector186:
  pushl $0
801076de:	6a 00                	push   $0x0
  pushl $186
801076e0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801076e5:	e9 13 f2 ff ff       	jmp    801068fd <alltraps>

801076ea <vector187>:
.globl vector187
vector187:
  pushl $0
801076ea:	6a 00                	push   $0x0
  pushl $187
801076ec:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801076f1:	e9 07 f2 ff ff       	jmp    801068fd <alltraps>

801076f6 <vector188>:
.globl vector188
vector188:
  pushl $0
801076f6:	6a 00                	push   $0x0
  pushl $188
801076f8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801076fd:	e9 fb f1 ff ff       	jmp    801068fd <alltraps>

80107702 <vector189>:
.globl vector189
vector189:
  pushl $0
80107702:	6a 00                	push   $0x0
  pushl $189
80107704:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107709:	e9 ef f1 ff ff       	jmp    801068fd <alltraps>

8010770e <vector190>:
.globl vector190
vector190:
  pushl $0
8010770e:	6a 00                	push   $0x0
  pushl $190
80107710:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107715:	e9 e3 f1 ff ff       	jmp    801068fd <alltraps>

8010771a <vector191>:
.globl vector191
vector191:
  pushl $0
8010771a:	6a 00                	push   $0x0
  pushl $191
8010771c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107721:	e9 d7 f1 ff ff       	jmp    801068fd <alltraps>

80107726 <vector192>:
.globl vector192
vector192:
  pushl $0
80107726:	6a 00                	push   $0x0
  pushl $192
80107728:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010772d:	e9 cb f1 ff ff       	jmp    801068fd <alltraps>

80107732 <vector193>:
.globl vector193
vector193:
  pushl $0
80107732:	6a 00                	push   $0x0
  pushl $193
80107734:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107739:	e9 bf f1 ff ff       	jmp    801068fd <alltraps>

8010773e <vector194>:
.globl vector194
vector194:
  pushl $0
8010773e:	6a 00                	push   $0x0
  pushl $194
80107740:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107745:	e9 b3 f1 ff ff       	jmp    801068fd <alltraps>

8010774a <vector195>:
.globl vector195
vector195:
  pushl $0
8010774a:	6a 00                	push   $0x0
  pushl $195
8010774c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107751:	e9 a7 f1 ff ff       	jmp    801068fd <alltraps>

80107756 <vector196>:
.globl vector196
vector196:
  pushl $0
80107756:	6a 00                	push   $0x0
  pushl $196
80107758:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010775d:	e9 9b f1 ff ff       	jmp    801068fd <alltraps>

80107762 <vector197>:
.globl vector197
vector197:
  pushl $0
80107762:	6a 00                	push   $0x0
  pushl $197
80107764:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107769:	e9 8f f1 ff ff       	jmp    801068fd <alltraps>

8010776e <vector198>:
.globl vector198
vector198:
  pushl $0
8010776e:	6a 00                	push   $0x0
  pushl $198
80107770:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107775:	e9 83 f1 ff ff       	jmp    801068fd <alltraps>

8010777a <vector199>:
.globl vector199
vector199:
  pushl $0
8010777a:	6a 00                	push   $0x0
  pushl $199
8010777c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107781:	e9 77 f1 ff ff       	jmp    801068fd <alltraps>

80107786 <vector200>:
.globl vector200
vector200:
  pushl $0
80107786:	6a 00                	push   $0x0
  pushl $200
80107788:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010778d:	e9 6b f1 ff ff       	jmp    801068fd <alltraps>

80107792 <vector201>:
.globl vector201
vector201:
  pushl $0
80107792:	6a 00                	push   $0x0
  pushl $201
80107794:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107799:	e9 5f f1 ff ff       	jmp    801068fd <alltraps>

8010779e <vector202>:
.globl vector202
vector202:
  pushl $0
8010779e:	6a 00                	push   $0x0
  pushl $202
801077a0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801077a5:	e9 53 f1 ff ff       	jmp    801068fd <alltraps>

801077aa <vector203>:
.globl vector203
vector203:
  pushl $0
801077aa:	6a 00                	push   $0x0
  pushl $203
801077ac:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801077b1:	e9 47 f1 ff ff       	jmp    801068fd <alltraps>

801077b6 <vector204>:
.globl vector204
vector204:
  pushl $0
801077b6:	6a 00                	push   $0x0
  pushl $204
801077b8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801077bd:	e9 3b f1 ff ff       	jmp    801068fd <alltraps>

801077c2 <vector205>:
.globl vector205
vector205:
  pushl $0
801077c2:	6a 00                	push   $0x0
  pushl $205
801077c4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801077c9:	e9 2f f1 ff ff       	jmp    801068fd <alltraps>

801077ce <vector206>:
.globl vector206
vector206:
  pushl $0
801077ce:	6a 00                	push   $0x0
  pushl $206
801077d0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801077d5:	e9 23 f1 ff ff       	jmp    801068fd <alltraps>

801077da <vector207>:
.globl vector207
vector207:
  pushl $0
801077da:	6a 00                	push   $0x0
  pushl $207
801077dc:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801077e1:	e9 17 f1 ff ff       	jmp    801068fd <alltraps>

801077e6 <vector208>:
.globl vector208
vector208:
  pushl $0
801077e6:	6a 00                	push   $0x0
  pushl $208
801077e8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801077ed:	e9 0b f1 ff ff       	jmp    801068fd <alltraps>

801077f2 <vector209>:
.globl vector209
vector209:
  pushl $0
801077f2:	6a 00                	push   $0x0
  pushl $209
801077f4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801077f9:	e9 ff f0 ff ff       	jmp    801068fd <alltraps>

801077fe <vector210>:
.globl vector210
vector210:
  pushl $0
801077fe:	6a 00                	push   $0x0
  pushl $210
80107800:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107805:	e9 f3 f0 ff ff       	jmp    801068fd <alltraps>

8010780a <vector211>:
.globl vector211
vector211:
  pushl $0
8010780a:	6a 00                	push   $0x0
  pushl $211
8010780c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107811:	e9 e7 f0 ff ff       	jmp    801068fd <alltraps>

80107816 <vector212>:
.globl vector212
vector212:
  pushl $0
80107816:	6a 00                	push   $0x0
  pushl $212
80107818:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010781d:	e9 db f0 ff ff       	jmp    801068fd <alltraps>

80107822 <vector213>:
.globl vector213
vector213:
  pushl $0
80107822:	6a 00                	push   $0x0
  pushl $213
80107824:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107829:	e9 cf f0 ff ff       	jmp    801068fd <alltraps>

8010782e <vector214>:
.globl vector214
vector214:
  pushl $0
8010782e:	6a 00                	push   $0x0
  pushl $214
80107830:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107835:	e9 c3 f0 ff ff       	jmp    801068fd <alltraps>

8010783a <vector215>:
.globl vector215
vector215:
  pushl $0
8010783a:	6a 00                	push   $0x0
  pushl $215
8010783c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107841:	e9 b7 f0 ff ff       	jmp    801068fd <alltraps>

80107846 <vector216>:
.globl vector216
vector216:
  pushl $0
80107846:	6a 00                	push   $0x0
  pushl $216
80107848:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010784d:	e9 ab f0 ff ff       	jmp    801068fd <alltraps>

80107852 <vector217>:
.globl vector217
vector217:
  pushl $0
80107852:	6a 00                	push   $0x0
  pushl $217
80107854:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107859:	e9 9f f0 ff ff       	jmp    801068fd <alltraps>

8010785e <vector218>:
.globl vector218
vector218:
  pushl $0
8010785e:	6a 00                	push   $0x0
  pushl $218
80107860:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107865:	e9 93 f0 ff ff       	jmp    801068fd <alltraps>

8010786a <vector219>:
.globl vector219
vector219:
  pushl $0
8010786a:	6a 00                	push   $0x0
  pushl $219
8010786c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107871:	e9 87 f0 ff ff       	jmp    801068fd <alltraps>

80107876 <vector220>:
.globl vector220
vector220:
  pushl $0
80107876:	6a 00                	push   $0x0
  pushl $220
80107878:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010787d:	e9 7b f0 ff ff       	jmp    801068fd <alltraps>

80107882 <vector221>:
.globl vector221
vector221:
  pushl $0
80107882:	6a 00                	push   $0x0
  pushl $221
80107884:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107889:	e9 6f f0 ff ff       	jmp    801068fd <alltraps>

8010788e <vector222>:
.globl vector222
vector222:
  pushl $0
8010788e:	6a 00                	push   $0x0
  pushl $222
80107890:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107895:	e9 63 f0 ff ff       	jmp    801068fd <alltraps>

8010789a <vector223>:
.globl vector223
vector223:
  pushl $0
8010789a:	6a 00                	push   $0x0
  pushl $223
8010789c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801078a1:	e9 57 f0 ff ff       	jmp    801068fd <alltraps>

801078a6 <vector224>:
.globl vector224
vector224:
  pushl $0
801078a6:	6a 00                	push   $0x0
  pushl $224
801078a8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801078ad:	e9 4b f0 ff ff       	jmp    801068fd <alltraps>

801078b2 <vector225>:
.globl vector225
vector225:
  pushl $0
801078b2:	6a 00                	push   $0x0
  pushl $225
801078b4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801078b9:	e9 3f f0 ff ff       	jmp    801068fd <alltraps>

801078be <vector226>:
.globl vector226
vector226:
  pushl $0
801078be:	6a 00                	push   $0x0
  pushl $226
801078c0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801078c5:	e9 33 f0 ff ff       	jmp    801068fd <alltraps>

801078ca <vector227>:
.globl vector227
vector227:
  pushl $0
801078ca:	6a 00                	push   $0x0
  pushl $227
801078cc:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801078d1:	e9 27 f0 ff ff       	jmp    801068fd <alltraps>

801078d6 <vector228>:
.globl vector228
vector228:
  pushl $0
801078d6:	6a 00                	push   $0x0
  pushl $228
801078d8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801078dd:	e9 1b f0 ff ff       	jmp    801068fd <alltraps>

801078e2 <vector229>:
.globl vector229
vector229:
  pushl $0
801078e2:	6a 00                	push   $0x0
  pushl $229
801078e4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801078e9:	e9 0f f0 ff ff       	jmp    801068fd <alltraps>

801078ee <vector230>:
.globl vector230
vector230:
  pushl $0
801078ee:	6a 00                	push   $0x0
  pushl $230
801078f0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801078f5:	e9 03 f0 ff ff       	jmp    801068fd <alltraps>

801078fa <vector231>:
.globl vector231
vector231:
  pushl $0
801078fa:	6a 00                	push   $0x0
  pushl $231
801078fc:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107901:	e9 f7 ef ff ff       	jmp    801068fd <alltraps>

80107906 <vector232>:
.globl vector232
vector232:
  pushl $0
80107906:	6a 00                	push   $0x0
  pushl $232
80107908:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010790d:	e9 eb ef ff ff       	jmp    801068fd <alltraps>

80107912 <vector233>:
.globl vector233
vector233:
  pushl $0
80107912:	6a 00                	push   $0x0
  pushl $233
80107914:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107919:	e9 df ef ff ff       	jmp    801068fd <alltraps>

8010791e <vector234>:
.globl vector234
vector234:
  pushl $0
8010791e:	6a 00                	push   $0x0
  pushl $234
80107920:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107925:	e9 d3 ef ff ff       	jmp    801068fd <alltraps>

8010792a <vector235>:
.globl vector235
vector235:
  pushl $0
8010792a:	6a 00                	push   $0x0
  pushl $235
8010792c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107931:	e9 c7 ef ff ff       	jmp    801068fd <alltraps>

80107936 <vector236>:
.globl vector236
vector236:
  pushl $0
80107936:	6a 00                	push   $0x0
  pushl $236
80107938:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010793d:	e9 bb ef ff ff       	jmp    801068fd <alltraps>

80107942 <vector237>:
.globl vector237
vector237:
  pushl $0
80107942:	6a 00                	push   $0x0
  pushl $237
80107944:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107949:	e9 af ef ff ff       	jmp    801068fd <alltraps>

8010794e <vector238>:
.globl vector238
vector238:
  pushl $0
8010794e:	6a 00                	push   $0x0
  pushl $238
80107950:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107955:	e9 a3 ef ff ff       	jmp    801068fd <alltraps>

8010795a <vector239>:
.globl vector239
vector239:
  pushl $0
8010795a:	6a 00                	push   $0x0
  pushl $239
8010795c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107961:	e9 97 ef ff ff       	jmp    801068fd <alltraps>

80107966 <vector240>:
.globl vector240
vector240:
  pushl $0
80107966:	6a 00                	push   $0x0
  pushl $240
80107968:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010796d:	e9 8b ef ff ff       	jmp    801068fd <alltraps>

80107972 <vector241>:
.globl vector241
vector241:
  pushl $0
80107972:	6a 00                	push   $0x0
  pushl $241
80107974:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107979:	e9 7f ef ff ff       	jmp    801068fd <alltraps>

8010797e <vector242>:
.globl vector242
vector242:
  pushl $0
8010797e:	6a 00                	push   $0x0
  pushl $242
80107980:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107985:	e9 73 ef ff ff       	jmp    801068fd <alltraps>

8010798a <vector243>:
.globl vector243
vector243:
  pushl $0
8010798a:	6a 00                	push   $0x0
  pushl $243
8010798c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107991:	e9 67 ef ff ff       	jmp    801068fd <alltraps>

80107996 <vector244>:
.globl vector244
vector244:
  pushl $0
80107996:	6a 00                	push   $0x0
  pushl $244
80107998:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010799d:	e9 5b ef ff ff       	jmp    801068fd <alltraps>

801079a2 <vector245>:
.globl vector245
vector245:
  pushl $0
801079a2:	6a 00                	push   $0x0
  pushl $245
801079a4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801079a9:	e9 4f ef ff ff       	jmp    801068fd <alltraps>

801079ae <vector246>:
.globl vector246
vector246:
  pushl $0
801079ae:	6a 00                	push   $0x0
  pushl $246
801079b0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801079b5:	e9 43 ef ff ff       	jmp    801068fd <alltraps>

801079ba <vector247>:
.globl vector247
vector247:
  pushl $0
801079ba:	6a 00                	push   $0x0
  pushl $247
801079bc:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801079c1:	e9 37 ef ff ff       	jmp    801068fd <alltraps>

801079c6 <vector248>:
.globl vector248
vector248:
  pushl $0
801079c6:	6a 00                	push   $0x0
  pushl $248
801079c8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801079cd:	e9 2b ef ff ff       	jmp    801068fd <alltraps>

801079d2 <vector249>:
.globl vector249
vector249:
  pushl $0
801079d2:	6a 00                	push   $0x0
  pushl $249
801079d4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801079d9:	e9 1f ef ff ff       	jmp    801068fd <alltraps>

801079de <vector250>:
.globl vector250
vector250:
  pushl $0
801079de:	6a 00                	push   $0x0
  pushl $250
801079e0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801079e5:	e9 13 ef ff ff       	jmp    801068fd <alltraps>

801079ea <vector251>:
.globl vector251
vector251:
  pushl $0
801079ea:	6a 00                	push   $0x0
  pushl $251
801079ec:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801079f1:	e9 07 ef ff ff       	jmp    801068fd <alltraps>

801079f6 <vector252>:
.globl vector252
vector252:
  pushl $0
801079f6:	6a 00                	push   $0x0
  pushl $252
801079f8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801079fd:	e9 fb ee ff ff       	jmp    801068fd <alltraps>

80107a02 <vector253>:
.globl vector253
vector253:
  pushl $0
80107a02:	6a 00                	push   $0x0
  pushl $253
80107a04:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107a09:	e9 ef ee ff ff       	jmp    801068fd <alltraps>

80107a0e <vector254>:
.globl vector254
vector254:
  pushl $0
80107a0e:	6a 00                	push   $0x0
  pushl $254
80107a10:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107a15:	e9 e3 ee ff ff       	jmp    801068fd <alltraps>

80107a1a <vector255>:
.globl vector255
vector255:
  pushl $0
80107a1a:	6a 00                	push   $0x0
  pushl $255
80107a1c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107a21:	e9 d7 ee ff ff       	jmp    801068fd <alltraps>
80107a26:	66 90                	xchg   %ax,%ax
80107a28:	66 90                	xchg   %ax,%ax
80107a2a:	66 90                	xchg   %ax,%ax
80107a2c:	66 90                	xchg   %ax,%ax
80107a2e:	66 90                	xchg   %ax,%ax

80107a30 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
    static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107a30:	55                   	push   %ebp
80107a31:	89 e5                	mov    %esp,%ebp
80107a33:	57                   	push   %edi
80107a34:	56                   	push   %esi
80107a35:	89 d6                	mov    %edx,%esi
    pde_t *pde;
    pte_t *pgtab;

    pde = &pgdir[PDX(va)];
80107a37:	c1 ea 16             	shr    $0x16,%edx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
    static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107a3a:	53                   	push   %ebx
    pde_t *pde;
    pte_t *pgtab;

    pde = &pgdir[PDX(va)];
80107a3b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
    static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107a3e:	83 ec 1c             	sub    $0x1c,%esp
    pde_t *pde;
    pte_t *pgtab;

    pde = &pgdir[PDX(va)];
    if(*pde & PTE_P){
80107a41:	8b 1f                	mov    (%edi),%ebx
80107a43:	f6 c3 01             	test   $0x1,%bl
80107a46:	74 28                	je     80107a70 <walkpgdir+0x40>
        pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a48:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107a4e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
        // The permissions here are overly generous, but they can
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
    return &pgtab[PTX(va)];
80107a54:	c1 ee 0a             	shr    $0xa,%esi
}
80107a57:	83 c4 1c             	add    $0x1c,%esp
        // The permissions here are overly generous, but they can
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
    return &pgtab[PTX(va)];
80107a5a:	89 f2                	mov    %esi,%edx
80107a5c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107a62:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107a65:	5b                   	pop    %ebx
80107a66:	5e                   	pop    %esi
80107a67:	5f                   	pop    %edi
80107a68:	5d                   	pop    %ebp
80107a69:	c3                   	ret    
80107a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    pde = &pgdir[PDX(va)];
    if(*pde & PTE_P){
        pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
    } else {
        if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107a70:	85 c9                	test   %ecx,%ecx
80107a72:	74 34                	je     80107aa8 <walkpgdir+0x78>
80107a74:	e8 c7 ab ff ff       	call   80102640 <kalloc>
80107a79:	85 c0                	test   %eax,%eax
80107a7b:	89 c3                	mov    %eax,%ebx
80107a7d:	74 29                	je     80107aa8 <walkpgdir+0x78>
            return 0;
        // Make sure all those PTE_P bits are zero.
        memset(pgtab, 0, PGSIZE);
80107a7f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107a86:	00 
80107a87:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107a8e:	00 
80107a8f:	89 04 24             	mov    %eax,(%esp)
80107a92:	e8 89 db ff ff       	call   80105620 <memset>
        // The permissions here are overly generous, but they can
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107a97:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107a9d:	83 c8 07             	or     $0x7,%eax
80107aa0:	89 07                	mov    %eax,(%edi)
80107aa2:	eb b0                	jmp    80107a54 <walkpgdir+0x24>
80107aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    return &pgtab[PTX(va)];
}
80107aa8:	83 c4 1c             	add    $0x1c,%esp
    pde = &pgdir[PDX(va)];
    if(*pde & PTE_P){
        pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
    } else {
        if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
            return 0;
80107aab:	31 c0                	xor    %eax,%eax
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
    return &pgtab[PTX(va)];
}
80107aad:	5b                   	pop    %ebx
80107aae:	5e                   	pop    %esi
80107aaf:	5f                   	pop    %edi
80107ab0:	5d                   	pop    %ebp
80107ab1:	c3                   	ret    
80107ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ac0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
    static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107ac0:	55                   	push   %ebp
80107ac1:	89 e5                	mov    %esp,%ebp
80107ac3:	57                   	push   %edi
80107ac4:	56                   	push   %esi
80107ac5:	53                   	push   %ebx
    char *a, *last;
    pte_t *pte;

    a = (char*)PGROUNDDOWN((uint)va);
80107ac6:	89 d3                	mov    %edx,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
    static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107ac8:	83 ec 1c             	sub    $0x1c,%esp
80107acb:	8b 7d 08             	mov    0x8(%ebp),%edi
    char *a, *last;
    pte_t *pte;

    a = (char*)PGROUNDDOWN((uint)va);
80107ace:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
    static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107ad4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    char *a, *last;
    pte_t *pte;

    a = (char*)PGROUNDDOWN((uint)va);
    last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107ad7:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107adb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(;;){
        if((pte = walkpgdir(pgdir, a, 1)) == 0)
            return -1;
        if(*pte & PTE_P)
            panic("remap");
        *pte = pa | perm | PTE_P;
80107ade:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
{
    char *a, *last;
    pte_t *pte;

    a = (char*)PGROUNDDOWN((uint)va);
    last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107ae2:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
80107ae9:	29 df                	sub    %ebx,%edi
80107aeb:	eb 18                	jmp    80107b05 <mappages+0x45>
80107aed:	8d 76 00             	lea    0x0(%esi),%esi
    for(;;){
        if((pte = walkpgdir(pgdir, a, 1)) == 0)
            return -1;
        if(*pte & PTE_P)
80107af0:	f6 00 01             	testb  $0x1,(%eax)
80107af3:	75 3d                	jne    80107b32 <mappages+0x72>
            panic("remap");
        *pte = pa | perm | PTE_P;
80107af5:	0b 75 0c             	or     0xc(%ebp),%esi
        if(a == last)
80107af8:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
    for(;;){
        if((pte = walkpgdir(pgdir, a, 1)) == 0)
            return -1;
        if(*pte & PTE_P)
            panic("remap");
        *pte = pa | perm | PTE_P;
80107afb:	89 30                	mov    %esi,(%eax)
        if(a == last)
80107afd:	74 29                	je     80107b28 <mappages+0x68>
            break;
        a += PGSIZE;
80107aff:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pte_t *pte;

    a = (char*)PGROUNDDOWN((uint)va);
    last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
    for(;;){
        if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107b05:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107b08:	b9 01 00 00 00       	mov    $0x1,%ecx
80107b0d:	89 da                	mov    %ebx,%edx
80107b0f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107b12:	e8 19 ff ff ff       	call   80107a30 <walkpgdir>
80107b17:	85 c0                	test   %eax,%eax
80107b19:	75 d5                	jne    80107af0 <mappages+0x30>
            break;
        a += PGSIZE;
        pa += PGSIZE;
    }
    return 0;
}
80107b1b:	83 c4 1c             	add    $0x1c,%esp

    a = (char*)PGROUNDDOWN((uint)va);
    last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
    for(;;){
        if((pte = walkpgdir(pgdir, a, 1)) == 0)
            return -1;
80107b1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
            break;
        a += PGSIZE;
        pa += PGSIZE;
    }
    return 0;
}
80107b23:	5b                   	pop    %ebx
80107b24:	5e                   	pop    %esi
80107b25:	5f                   	pop    %edi
80107b26:	5d                   	pop    %ebp
80107b27:	c3                   	ret    
80107b28:	83 c4 1c             	add    $0x1c,%esp
        if(a == last)
            break;
        a += PGSIZE;
        pa += PGSIZE;
    }
    return 0;
80107b2b:	31 c0                	xor    %eax,%eax
}
80107b2d:	5b                   	pop    %ebx
80107b2e:	5e                   	pop    %esi
80107b2f:	5f                   	pop    %edi
80107b30:	5d                   	pop    %ebp
80107b31:	c3                   	ret    
    last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
    for(;;){
        if((pte = walkpgdir(pgdir, a, 1)) == 0)
            return -1;
        if(*pte & PTE_P)
            panic("remap");
80107b32:	c7 04 24 24 9a 10 80 	movl   $0x80109a24,(%esp)
80107b39:	e8 22 88 ff ff       	call   80100360 <panic>
80107b3e:	66 90                	xchg   %ax,%ax

80107b40 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
    int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107b40:	55                   	push   %ebp
80107b41:	89 e5                	mov    %esp,%ebp
80107b43:	57                   	push   %edi
80107b44:	89 c7                	mov    %eax,%edi
80107b46:	56                   	push   %esi
80107b47:	89 d6                	mov    %edx,%esi
80107b49:	53                   	push   %ebx
    uint a, pa;

    if(newsz >= oldsz)
        return oldsz;

    a = PGROUNDUP(newsz);
80107b4a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
    int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107b50:	83 ec 1c             	sub    $0x1c,%esp
    uint a, pa;

    if(newsz >= oldsz)
        return oldsz;

    a = PGROUNDUP(newsz);
80107b53:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for(; a  < oldsz; a += PGSIZE){
80107b59:	39 d3                	cmp    %edx,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
    int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107b5b:	89 4d e0             	mov    %ecx,-0x20(%ebp)

    if(newsz >= oldsz)
        return oldsz;

    a = PGROUNDUP(newsz);
    for(; a  < oldsz; a += PGSIZE){
80107b5e:	72 3b                	jb     80107b9b <deallocuvm.part.0+0x5b>
80107b60:	eb 5e                	jmp    80107bc0 <deallocuvm.part.0+0x80>
80107b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        pte = walkpgdir(pgdir, (char*)a, 0);
        if(!pte)
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
        else if((*pte & PTE_P) != 0){
80107b68:	8b 10                	mov    (%eax),%edx
80107b6a:	f6 c2 01             	test   $0x1,%dl
80107b6d:	74 22                	je     80107b91 <deallocuvm.part.0+0x51>
            pa = PTE_ADDR(*pte);
            if(pa == 0)
80107b6f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107b75:	74 54                	je     80107bcb <deallocuvm.part.0+0x8b>
                panic("kfree");
            char *v = P2V(pa);
80107b77:	81 c2 00 00 00 80    	add    $0x80000000,%edx
            kfree(v);
80107b7d:	89 14 24             	mov    %edx,(%esp)
80107b80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107b83:	e8 08 a9 ff ff       	call   80102490 <kfree>
            *pte = 0;
80107b88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    if(newsz >= oldsz)
        return oldsz;

    a = PGROUNDUP(newsz);
    for(; a  < oldsz; a += PGSIZE){
80107b91:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107b97:	39 f3                	cmp    %esi,%ebx
80107b99:	73 25                	jae    80107bc0 <deallocuvm.part.0+0x80>
        pte = walkpgdir(pgdir, (char*)a, 0);
80107b9b:	31 c9                	xor    %ecx,%ecx
80107b9d:	89 da                	mov    %ebx,%edx
80107b9f:	89 f8                	mov    %edi,%eax
80107ba1:	e8 8a fe ff ff       	call   80107a30 <walkpgdir>
        if(!pte)
80107ba6:	85 c0                	test   %eax,%eax
80107ba8:	75 be                	jne    80107b68 <deallocuvm.part.0+0x28>
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107baa:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107bb0:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

    if(newsz >= oldsz)
        return oldsz;

    a = PGROUNDUP(newsz);
    for(; a  < oldsz; a += PGSIZE){
80107bb6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107bbc:	39 f3                	cmp    %esi,%ebx
80107bbe:	72 db                	jb     80107b9b <deallocuvm.part.0+0x5b>
            kfree(v);
            *pte = 0;
        }
    }
    return newsz;
}
80107bc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107bc3:	83 c4 1c             	add    $0x1c,%esp
80107bc6:	5b                   	pop    %ebx
80107bc7:	5e                   	pop    %esi
80107bc8:	5f                   	pop    %edi
80107bc9:	5d                   	pop    %ebp
80107bca:	c3                   	ret    
        if(!pte)
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
        else if((*pte & PTE_P) != 0){
            pa = PTE_ADDR(*pte);
            if(pa == 0)
                panic("kfree");
80107bcb:	c7 04 24 32 92 10 80 	movl   $0x80109232,(%esp)
80107bd2:	e8 89 87 ff ff       	call   80100360 <panic>
80107bd7:	89 f6                	mov    %esi,%esi
80107bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107be0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
    void
seginit(void)
{
80107be0:	55                   	push   %ebp
80107be1:	89 e5                	mov    %esp,%ebp
80107be3:	83 ec 18             	sub    $0x18,%esp

    // Map "logical" addresses to virtual addresses using identity map.
    // Cannot share a CODE descriptor for both kernel and user
    // because it would have to have DPL_USR, but the CPU forbids
    // an interrupt from CPL=0 to DPL=3.
    c = &cpus[cpunum()];
80107be6:	e8 15 ad ff ff       	call   80102900 <cpunum>
    c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107beb:	31 c9                	xor    %ecx,%ecx
80107bed:	ba ff ff ff ff       	mov    $0xffffffff,%edx

    // Map "logical" addresses to virtual addresses using identity map.
    // Cannot share a CODE descriptor for both kernel and user
    // because it would have to have DPL_USR, but the CPU forbids
    // an interrupt from CPL=0 to DPL=3.
    c = &cpus[cpunum()];
80107bf2:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107bf8:	05 00 4b 11 80       	add    $0x80114b00,%eax
    c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107bfd:	66 89 50 78          	mov    %dx,0x78(%eax)
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107c01:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    // Map "logical" addresses to virtual addresses using identity map.
    // Cannot share a CODE descriptor for both kernel and user
    // because it would have to have DPL_USR, but the CPU forbids
    // an interrupt from CPL=0 to DPL=3.
    c = &cpus[cpunum()];
    c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107c06:	66 89 48 7a          	mov    %cx,0x7a(%eax)
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107c0a:	31 c9                	xor    %ecx,%ecx
80107c0c:	66 89 90 80 00 00 00 	mov    %dx,0x80(%eax)
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107c13:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    // Cannot share a CODE descriptor for both kernel and user
    // because it would have to have DPL_USR, but the CPU forbids
    // an interrupt from CPL=0 to DPL=3.
    c = &cpus[cpunum()];
    c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107c18:	66 89 88 82 00 00 00 	mov    %cx,0x82(%eax)
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107c1f:	31 c9                	xor    %ecx,%ecx
80107c21:	66 89 90 90 00 00 00 	mov    %dx,0x90(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107c28:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    // because it would have to have DPL_USR, but the CPU forbids
    // an interrupt from CPL=0 to DPL=3.
    c = &cpus[cpunum()];
    c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107c2d:	66 89 88 92 00 00 00 	mov    %cx,0x92(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107c34:	31 c9                	xor    %ecx,%ecx
80107c36:	66 89 90 98 00 00 00 	mov    %dx,0x98(%eax)

    // Map cpu and proc -- these are private per cpu.
    c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107c3d:	8d 90 b4 00 00 00    	lea    0xb4(%eax),%edx
    // an interrupt from CPL=0 to DPL=3.
    c = &cpus[cpunum()];
    c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
    c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107c43:	66 89 88 9a 00 00 00 	mov    %cx,0x9a(%eax)

    // Map cpu and proc -- these are private per cpu.
    c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107c4a:	31 c9                	xor    %ecx,%ecx
80107c4c:	66 89 88 88 00 00 00 	mov    %cx,0x88(%eax)
80107c53:	89 d1                	mov    %edx,%ecx
80107c55:	c1 e9 10             	shr    $0x10,%ecx
80107c58:	66 89 90 8a 00 00 00 	mov    %dx,0x8a(%eax)
80107c5f:	c1 ea 18             	shr    $0x18,%edx
80107c62:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80107c68:	b9 37 00 00 00       	mov    $0x37,%ecx
80107c6d:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

    lgdt(c->gdt, sizeof(c->gdt));
80107c73:	8d 50 70             	lea    0x70(%eax),%edx
    // Map "logical" addresses to virtual addresses using identity map.
    // Cannot share a CODE descriptor for both kernel and user
    // because it would have to have DPL_USR, but the CPU forbids
    // an interrupt from CPL=0 to DPL=3.
    c = &cpus[cpunum()];
    c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107c76:	c6 40 7d 9a          	movb   $0x9a,0x7d(%eax)
80107c7a:	c6 40 7e cf          	movb   $0xcf,0x7e(%eax)
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107c7e:	c6 80 85 00 00 00 92 	movb   $0x92,0x85(%eax)
80107c85:	c6 80 86 00 00 00 cf 	movb   $0xcf,0x86(%eax)
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107c8c:	c6 80 95 00 00 00 fa 	movb   $0xfa,0x95(%eax)
80107c93:	c6 80 96 00 00 00 cf 	movb   $0xcf,0x96(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107c9a:	c6 80 9d 00 00 00 f2 	movb   $0xf2,0x9d(%eax)
80107ca1:	c6 80 9e 00 00 00 cf 	movb   $0xcf,0x9e(%eax)

    // Map cpu and proc -- these are private per cpu.
    c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107ca8:	c6 80 8d 00 00 00 92 	movb   $0x92,0x8d(%eax)
80107caf:	c6 80 8e 00 00 00 c0 	movb   $0xc0,0x8e(%eax)
80107cb6:	66 89 4d f2          	mov    %cx,-0xe(%ebp)
  pd[1] = (uint)p;
80107cba:	66 89 55 f4          	mov    %dx,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107cbe:	c1 ea 10             	shr    $0x10,%edx
80107cc1:	66 89 55 f6          	mov    %dx,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107cc5:	8d 55 f2             	lea    -0xe(%ebp),%edx
    // Map "logical" addresses to virtual addresses using identity map.
    // Cannot share a CODE descriptor for both kernel and user
    // because it would have to have DPL_USR, but the CPU forbids
    // an interrupt from CPL=0 to DPL=3.
    c = &cpus[cpunum()];
    c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107cc8:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107ccc:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107cd0:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107cd7:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107cde:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107ce5:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107cec:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107cf3:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)
80107cfa:	0f 01 12             	lgdtl  (%edx)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
80107cfd:	ba 18 00 00 00       	mov    $0x18,%edx
80107d02:	8e ea                	mov    %edx,%gs
    lgdt(c->gdt, sizeof(c->gdt));
    loadgs(SEG_KCPU << 3);

    // Initialize cpu-local storage.
    cpu = c;
    proc = 0;
80107d04:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107d0b:	00 00 00 00 

    lgdt(c->gdt, sizeof(c->gdt));
    loadgs(SEG_KCPU << 3);

    // Initialize cpu-local storage.
    cpu = c;
80107d0f:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
    proc = 0;
}
80107d15:	c9                   	leave  
80107d16:	c3                   	ret    
80107d17:	89 f6                	mov    %esi,%esi
80107d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107d20 <setupkvm>:
};

// Set up kernel part of a page table.
    pde_t*
setupkvm(void)
{
80107d20:	55                   	push   %ebp
80107d21:	89 e5                	mov    %esp,%ebp
80107d23:	56                   	push   %esi
80107d24:	53                   	push   %ebx
80107d25:	83 ec 10             	sub    $0x10,%esp
    pde_t *pgdir;
    struct kmap *k;

    if((pgdir = (pde_t*)kalloc()) == 0)
80107d28:	e8 13 a9 ff ff       	call   80102640 <kalloc>
80107d2d:	85 c0                	test   %eax,%eax
80107d2f:	89 c6                	mov    %eax,%esi
80107d31:	74 55                	je     80107d88 <setupkvm+0x68>
        return 0;
    memset(pgdir, 0, PGSIZE);
80107d33:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107d3a:	00 
    if (P2V(PHYSTOP) > (void*)DEVSPACE)
        panic("PHYSTOP too high");
    for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d3b:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
    pde_t *pgdir;
    struct kmap *k;

    if((pgdir = (pde_t*)kalloc()) == 0)
        return 0;
    memset(pgdir, 0, PGSIZE);
80107d40:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107d47:	00 
80107d48:	89 04 24             	mov    %eax,(%esp)
80107d4b:	e8 d0 d8 ff ff       	call   80105620 <memset>
    if (P2V(PHYSTOP) > (void*)DEVSPACE)
        panic("PHYSTOP too high");
    for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
        if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107d50:	8b 53 0c             	mov    0xc(%ebx),%edx
80107d53:	8b 43 04             	mov    0x4(%ebx),%eax
80107d56:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107d59:	89 54 24 04          	mov    %edx,0x4(%esp)
80107d5d:	8b 13                	mov    (%ebx),%edx
80107d5f:	89 04 24             	mov    %eax,(%esp)
80107d62:	29 c1                	sub    %eax,%ecx
80107d64:	89 f0                	mov    %esi,%eax
80107d66:	e8 55 fd ff ff       	call   80107ac0 <mappages>
80107d6b:	85 c0                	test   %eax,%eax
80107d6d:	78 19                	js     80107d88 <setupkvm+0x68>
    if((pgdir = (pde_t*)kalloc()) == 0)
        return 0;
    memset(pgdir, 0, PGSIZE);
    if (P2V(PHYSTOP) > (void*)DEVSPACE)
        panic("PHYSTOP too high");
    for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d6f:	83 c3 10             	add    $0x10,%ebx
80107d72:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107d78:	72 d6                	jb     80107d50 <setupkvm+0x30>
        if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                    (uint)k->phys_start, k->perm) < 0)
            return 0;
    return pgdir;
}
80107d7a:	83 c4 10             	add    $0x10,%esp
80107d7d:	89 f0                	mov    %esi,%eax
80107d7f:	5b                   	pop    %ebx
80107d80:	5e                   	pop    %esi
80107d81:	5d                   	pop    %ebp
80107d82:	c3                   	ret    
80107d83:	90                   	nop
80107d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107d88:	83 c4 10             	add    $0x10,%esp
{
    pde_t *pgdir;
    struct kmap *k;

    if((pgdir = (pde_t*)kalloc()) == 0)
        return 0;
80107d8b:	31 c0                	xor    %eax,%eax
    for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
        if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                    (uint)k->phys_start, k->perm) < 0)
            return 0;
    return pgdir;
}
80107d8d:	5b                   	pop    %ebx
80107d8e:	5e                   	pop    %esi
80107d8f:	5d                   	pop    %ebp
80107d90:	c3                   	ret    
80107d91:	eb 0d                	jmp    80107da0 <kvmalloc>
80107d93:	90                   	nop
80107d94:	90                   	nop
80107d95:	90                   	nop
80107d96:	90                   	nop
80107d97:	90                   	nop
80107d98:	90                   	nop
80107d99:	90                   	nop
80107d9a:	90                   	nop
80107d9b:	90                   	nop
80107d9c:	90                   	nop
80107d9d:	90                   	nop
80107d9e:	90                   	nop
80107d9f:	90                   	nop

80107da0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
    void
kvmalloc(void)
{
80107da0:	55                   	push   %ebp
80107da1:	89 e5                	mov    %esp,%ebp
80107da3:	83 ec 08             	sub    $0x8,%esp
    kpgdir = setupkvm();
80107da6:	e8 75 ff ff ff       	call   80107d20 <setupkvm>
80107dab:	a3 a4 80 11 80       	mov    %eax,0x801180a4
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
    void
switchkvm(void)
{
    lcr3(V2P(kpgdir));   // switch to the kernel page table
80107db0:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107db5:	0f 22 d8             	mov    %eax,%cr3
    void
kvmalloc(void)
{
    kpgdir = setupkvm();
    switchkvm();
}
80107db8:	c9                   	leave  
80107db9:	c3                   	ret    
80107dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107dc0 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
    void
switchkvm(void)
{
    lcr3(V2P(kpgdir));   // switch to the kernel page table
80107dc0:	a1 a4 80 11 80       	mov    0x801180a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
    void
switchkvm(void)
{
80107dc5:	55                   	push   %ebp
80107dc6:	89 e5                	mov    %esp,%ebp
    lcr3(V2P(kpgdir));   // switch to the kernel page table
80107dc8:	05 00 00 00 80       	add    $0x80000000,%eax
80107dcd:	0f 22 d8             	mov    %eax,%cr3
}
80107dd0:	5d                   	pop    %ebp
80107dd1:	c3                   	ret    
80107dd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107de0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
    void
switchuvm(struct proc *p)
{
80107de0:	55                   	push   %ebp
80107de1:	89 e5                	mov    %esp,%ebp
80107de3:	53                   	push   %ebx
80107de4:	83 ec 14             	sub    $0x14,%esp
80107de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(p == 0)
80107dea:	85 db                	test   %ebx,%ebx
80107dec:	0f 84 94 00 00 00    	je     80107e86 <switchuvm+0xa6>
        panic("switchuvm: no process");
    if(p->kstack == 0)
80107df2:	8b 43 08             	mov    0x8(%ebx),%eax
80107df5:	85 c0                	test   %eax,%eax
80107df7:	0f 84 a1 00 00 00    	je     80107e9e <switchuvm+0xbe>
        panic("switchuvm: no kstack");
    if(p->pgdir == 0)
80107dfd:	8b 43 04             	mov    0x4(%ebx),%eax
80107e00:	85 c0                	test   %eax,%eax
80107e02:	0f 84 8a 00 00 00    	je     80107e92 <switchuvm+0xb2>
        panic("switchuvm: no pgdir");

    pushcli();
80107e08:	e8 43 d7 ff ff       	call   80105550 <pushcli>
    cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107e0d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e13:	b9 67 00 00 00       	mov    $0x67,%ecx
80107e18:	8d 50 08             	lea    0x8(%eax),%edx
80107e1b:	66 89 88 a0 00 00 00 	mov    %cx,0xa0(%eax)
80107e22:	89 d1                	mov    %edx,%ecx
80107e24:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80107e2b:	c1 ea 18             	shr    $0x18,%edx
80107e2e:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
80107e34:	c1 e9 10             	shr    $0x10,%ecx
    cpu->gdt[SEG_TSS].s = 0;
    cpu->ts.ss0 = SEG_KDATA << 3;
80107e37:	ba 10 00 00 00       	mov    $0x10,%edx
80107e3c:	66 89 50 10          	mov    %dx,0x10(%eax)
        panic("switchuvm: no kstack");
    if(p->pgdir == 0)
        panic("switchuvm: no pgdir");

    pushcli();
    cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107e40:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80107e46:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
    cpu->gdt[SEG_TSS].s = 0;
80107e4d:	c6 80 a5 00 00 00 89 	movb   $0x89,0xa5(%eax)
    cpu->ts.ss0 = SEG_KDATA << 3;
    cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107e54:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107e57:	8d 91 00 10 00 00    	lea    0x1000(%ecx),%edx
    // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
    // forbids I/O instructions (e.g., inb and outb) from user space
    cpu->ts.iomb = (ushort) 0xFFFF;
80107e5d:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx

    pushcli();
    cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
    cpu->gdt[SEG_TSS].s = 0;
    cpu->ts.ss0 = SEG_KDATA << 3;
    cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107e62:	89 50 0c             	mov    %edx,0xc(%eax)
    // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
    // forbids I/O instructions (e.g., inb and outb) from user space
    cpu->ts.iomb = (ushort) 0xFFFF;
80107e65:	66 89 48 6e          	mov    %cx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80107e69:	b8 30 00 00 00       	mov    $0x30,%eax
80107e6e:	0f 00 d8             	ltr    %ax
    ltr(SEG_TSS << 3);
    lcr3(V2P(p->pgdir));  // switch to process's address space
80107e71:	8b 43 04             	mov    0x4(%ebx),%eax
80107e74:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107e79:	0f 22 d8             	mov    %eax,%cr3
    popcli();
}
80107e7c:	83 c4 14             	add    $0x14,%esp
80107e7f:	5b                   	pop    %ebx
80107e80:	5d                   	pop    %ebp
    // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
    // forbids I/O instructions (e.g., inb and outb) from user space
    cpu->ts.iomb = (ushort) 0xFFFF;
    ltr(SEG_TSS << 3);
    lcr3(V2P(p->pgdir));  // switch to process's address space
    popcli();
80107e81:	e9 fa d6 ff ff       	jmp    80105580 <popcli>
// Switch TSS and h/w page table to correspond to process p.
    void
switchuvm(struct proc *p)
{
    if(p == 0)
        panic("switchuvm: no process");
80107e86:	c7 04 24 2a 9a 10 80 	movl   $0x80109a2a,(%esp)
80107e8d:	e8 ce 84 ff ff       	call   80100360 <panic>
    if(p->kstack == 0)
        panic("switchuvm: no kstack");
    if(p->pgdir == 0)
        panic("switchuvm: no pgdir");
80107e92:	c7 04 24 55 9a 10 80 	movl   $0x80109a55,(%esp)
80107e99:	e8 c2 84 ff ff       	call   80100360 <panic>
switchuvm(struct proc *p)
{
    if(p == 0)
        panic("switchuvm: no process");
    if(p->kstack == 0)
        panic("switchuvm: no kstack");
80107e9e:	c7 04 24 40 9a 10 80 	movl   $0x80109a40,(%esp)
80107ea5:	e8 b6 84 ff ff       	call   80100360 <panic>
80107eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107eb0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
    void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107eb0:	55                   	push   %ebp
80107eb1:	89 e5                	mov    %esp,%ebp
80107eb3:	57                   	push   %edi
80107eb4:	56                   	push   %esi
80107eb5:	53                   	push   %ebx
80107eb6:	83 ec 1c             	sub    $0x1c,%esp
80107eb9:	8b 75 10             	mov    0x10(%ebp),%esi
80107ebc:	8b 45 08             	mov    0x8(%ebp),%eax
80107ebf:	8b 7d 0c             	mov    0xc(%ebp),%edi
    char *mem;

    if(sz >= PGSIZE)
80107ec2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
    void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107ec8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    char *mem;

    if(sz >= PGSIZE)
80107ecb:	77 54                	ja     80107f21 <inituvm+0x71>
        panic("inituvm: more than a page");
    mem = kalloc();
80107ecd:	e8 6e a7 ff ff       	call   80102640 <kalloc>
    memset(mem, 0, PGSIZE);
80107ed2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107ed9:	00 
80107eda:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107ee1:	00 
{
    char *mem;

    if(sz >= PGSIZE)
        panic("inituvm: more than a page");
    mem = kalloc();
80107ee2:	89 c3                	mov    %eax,%ebx
    memset(mem, 0, PGSIZE);
80107ee4:	89 04 24             	mov    %eax,(%esp)
80107ee7:	e8 34 d7 ff ff       	call   80105620 <memset>
    mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107eec:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107ef2:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107ef7:	89 04 24             	mov    %eax,(%esp)
80107efa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107efd:	31 d2                	xor    %edx,%edx
80107eff:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80107f06:	00 
80107f07:	e8 b4 fb ff ff       	call   80107ac0 <mappages>
    memmove(mem, init, sz);
80107f0c:	89 75 10             	mov    %esi,0x10(%ebp)
80107f0f:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107f12:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107f15:	83 c4 1c             	add    $0x1c,%esp
80107f18:	5b                   	pop    %ebx
80107f19:	5e                   	pop    %esi
80107f1a:	5f                   	pop    %edi
80107f1b:	5d                   	pop    %ebp
    if(sz >= PGSIZE)
        panic("inituvm: more than a page");
    mem = kalloc();
    memset(mem, 0, PGSIZE);
    mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
    memmove(mem, init, sz);
80107f1c:	e9 9f d7 ff ff       	jmp    801056c0 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
    char *mem;

    if(sz >= PGSIZE)
        panic("inituvm: more than a page");
80107f21:	c7 04 24 69 9a 10 80 	movl   $0x80109a69,(%esp)
80107f28:	e8 33 84 ff ff       	call   80100360 <panic>
80107f2d:	8d 76 00             	lea    0x0(%esi),%esi

80107f30 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
    int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107f30:	55                   	push   %ebp
80107f31:	89 e5                	mov    %esp,%ebp
80107f33:	57                   	push   %edi
80107f34:	56                   	push   %esi
80107f35:	53                   	push   %ebx
80107f36:	83 ec 1c             	sub    $0x1c,%esp
    uint i, pa, n;
    pte_t *pte;

    if((uint) addr % PGSIZE != 0)
80107f39:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107f40:	0f 85 98 00 00 00    	jne    80107fde <loaduvm+0xae>
        panic("loaduvm: addr must be page aligned");
    for(i = 0; i < sz; i += PGSIZE){
80107f46:	8b 75 18             	mov    0x18(%ebp),%esi
80107f49:	31 db                	xor    %ebx,%ebx
80107f4b:	85 f6                	test   %esi,%esi
80107f4d:	75 1a                	jne    80107f69 <loaduvm+0x39>
80107f4f:	eb 77                	jmp    80107fc8 <loaduvm+0x98>
80107f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f58:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107f5e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107f64:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107f67:	76 5f                	jbe    80107fc8 <loaduvm+0x98>
80107f69:	8b 55 0c             	mov    0xc(%ebp),%edx
        if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107f6c:	31 c9                	xor    %ecx,%ecx
80107f6e:	8b 45 08             	mov    0x8(%ebp),%eax
80107f71:	01 da                	add    %ebx,%edx
80107f73:	e8 b8 fa ff ff       	call   80107a30 <walkpgdir>
80107f78:	85 c0                	test   %eax,%eax
80107f7a:	74 56                	je     80107fd2 <loaduvm+0xa2>
            panic("loaduvm: address should exist");
        pa = PTE_ADDR(*pte);
80107f7c:	8b 00                	mov    (%eax),%eax
        if(sz - i < PGSIZE)
            n = sz - i;
        else
            n = PGSIZE;
80107f7e:	bf 00 10 00 00       	mov    $0x1000,%edi
80107f83:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if((uint) addr % PGSIZE != 0)
        panic("loaduvm: addr must be page aligned");
    for(i = 0; i < sz; i += PGSIZE){
        if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
            panic("loaduvm: address should exist");
        pa = PTE_ADDR(*pte);
80107f86:	25 00 f0 ff ff       	and    $0xfffff000,%eax
        if(sz - i < PGSIZE)
            n = sz - i;
        else
            n = PGSIZE;
80107f8b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80107f91:	0f 42 fe             	cmovb  %esi,%edi
        if(readi(ip, P2V(pa), offset+i, n) != n)
80107f94:	05 00 00 00 80       	add    $0x80000000,%eax
80107f99:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f9d:	8b 45 10             	mov    0x10(%ebp),%eax
80107fa0:	01 d9                	add    %ebx,%ecx
80107fa2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80107fa6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80107faa:	89 04 24             	mov    %eax,(%esp)
80107fad:	e8 3e 9b ff ff       	call   80101af0 <readi>
80107fb2:	39 f8                	cmp    %edi,%eax
80107fb4:	74 a2                	je     80107f58 <loaduvm+0x28>
            return -1;
    }
    return 0;
}
80107fb6:	83 c4 1c             	add    $0x1c,%esp
        if(sz - i < PGSIZE)
            n = sz - i;
        else
            n = PGSIZE;
        if(readi(ip, P2V(pa), offset+i, n) != n)
            return -1;
80107fb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    return 0;
}
80107fbe:	5b                   	pop    %ebx
80107fbf:	5e                   	pop    %esi
80107fc0:	5f                   	pop    %edi
80107fc1:	5d                   	pop    %ebp
80107fc2:	c3                   	ret    
80107fc3:	90                   	nop
80107fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107fc8:	83 c4 1c             	add    $0x1c,%esp
        else
            n = PGSIZE;
        if(readi(ip, P2V(pa), offset+i, n) != n)
            return -1;
    }
    return 0;
80107fcb:	31 c0                	xor    %eax,%eax
}
80107fcd:	5b                   	pop    %ebx
80107fce:	5e                   	pop    %esi
80107fcf:	5f                   	pop    %edi
80107fd0:	5d                   	pop    %ebp
80107fd1:	c3                   	ret    

    if((uint) addr % PGSIZE != 0)
        panic("loaduvm: addr must be page aligned");
    for(i = 0; i < sz; i += PGSIZE){
        if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
            panic("loaduvm: address should exist");
80107fd2:	c7 04 24 83 9a 10 80 	movl   $0x80109a83,(%esp)
80107fd9:	e8 82 83 ff ff       	call   80100360 <panic>
{
    uint i, pa, n;
    pte_t *pte;

    if((uint) addr % PGSIZE != 0)
        panic("loaduvm: addr must be page aligned");
80107fde:	c7 04 24 24 9b 10 80 	movl   $0x80109b24,(%esp)
80107fe5:	e8 76 83 ff ff       	call   80100360 <panic>
80107fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107ff0 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
    int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107ff0:	55                   	push   %ebp
80107ff1:	89 e5                	mov    %esp,%ebp
80107ff3:	57                   	push   %edi
80107ff4:	56                   	push   %esi
80107ff5:	53                   	push   %ebx
80107ff6:	83 ec 1c             	sub    $0x1c,%esp
80107ff9:	8b 7d 10             	mov    0x10(%ebp),%edi
    char *mem;
    uint a;

    if(newsz >= KERNBASE)
80107ffc:	85 ff                	test   %edi,%edi
80107ffe:	0f 88 7e 00 00 00    	js     80108082 <allocuvm+0x92>
        return 0;
    if(newsz < oldsz)
80108004:	3b 7d 0c             	cmp    0xc(%ebp),%edi
        return oldsz;
80108007:	8b 45 0c             	mov    0xc(%ebp),%eax
    char *mem;
    uint a;

    if(newsz >= KERNBASE)
        return 0;
    if(newsz < oldsz)
8010800a:	72 78                	jb     80108084 <allocuvm+0x94>
        return oldsz;

    a = PGROUNDUP(oldsz);
8010800c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80108012:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for(; a < newsz; a += PGSIZE){
80108018:	39 df                	cmp    %ebx,%edi
8010801a:	77 4a                	ja     80108066 <allocuvm+0x76>
8010801c:	eb 72                	jmp    80108090 <allocuvm+0xa0>
8010801e:	66 90                	xchg   %ax,%ax
        if(mem == 0){
            cprintf("allocuvm out of memory\n");
            deallocuvm(pgdir, newsz, oldsz);
            return 0;
        }
        memset(mem, 0, PGSIZE);
80108020:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108027:	00 
80108028:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010802f:	00 
80108030:	89 04 24             	mov    %eax,(%esp)
80108033:	e8 e8 d5 ff ff       	call   80105620 <memset>
        if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108038:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010803e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108043:	89 04 24             	mov    %eax,(%esp)
80108046:	8b 45 08             	mov    0x8(%ebp),%eax
80108049:	89 da                	mov    %ebx,%edx
8010804b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80108052:	00 
80108053:	e8 68 fa ff ff       	call   80107ac0 <mappages>
80108058:	85 c0                	test   %eax,%eax
8010805a:	78 44                	js     801080a0 <allocuvm+0xb0>
        return 0;
    if(newsz < oldsz)
        return oldsz;

    a = PGROUNDUP(oldsz);
    for(; a < newsz; a += PGSIZE){
8010805c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108062:	39 df                	cmp    %ebx,%edi
80108064:	76 2a                	jbe    80108090 <allocuvm+0xa0>
        mem = kalloc();
80108066:	e8 d5 a5 ff ff       	call   80102640 <kalloc>
        if(mem == 0){
8010806b:	85 c0                	test   %eax,%eax
    if(newsz < oldsz)
        return oldsz;

    a = PGROUNDUP(oldsz);
    for(; a < newsz; a += PGSIZE){
        mem = kalloc();
8010806d:	89 c6                	mov    %eax,%esi
        if(mem == 0){
8010806f:	75 af                	jne    80108020 <allocuvm+0x30>
            cprintf("allocuvm out of memory\n");
80108071:	c7 04 24 a1 9a 10 80 	movl   $0x80109aa1,(%esp)
80108078:	e8 d3 85 ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
    pte_t *pte;
    uint a, pa;

    if(newsz >= oldsz)
8010807d:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80108080:	77 48                	ja     801080ca <allocuvm+0xda>
        memset(mem, 0, PGSIZE);
        if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
            cprintf("allocuvm out of memory (2)\n");
            deallocuvm(pgdir, newsz, oldsz);
            kfree(mem);
            return 0;
80108082:	31 c0                	xor    %eax,%eax
        }
    }
    return newsz;
}
80108084:	83 c4 1c             	add    $0x1c,%esp
80108087:	5b                   	pop    %ebx
80108088:	5e                   	pop    %esi
80108089:	5f                   	pop    %edi
8010808a:	5d                   	pop    %ebp
8010808b:	c3                   	ret    
8010808c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108090:	83 c4 1c             	add    $0x1c,%esp
80108093:	89 f8                	mov    %edi,%eax
80108095:	5b                   	pop    %ebx
80108096:	5e                   	pop    %esi
80108097:	5f                   	pop    %edi
80108098:	5d                   	pop    %ebp
80108099:	c3                   	ret    
8010809a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            deallocuvm(pgdir, newsz, oldsz);
            return 0;
        }
        memset(mem, 0, PGSIZE);
        if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
            cprintf("allocuvm out of memory (2)\n");
801080a0:	c7 04 24 b9 9a 10 80 	movl   $0x80109ab9,(%esp)
801080a7:	e8 a4 85 ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
    pte_t *pte;
    uint a, pa;

    if(newsz >= oldsz)
801080ac:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801080af:	76 0d                	jbe    801080be <allocuvm+0xce>
801080b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801080b4:	89 fa                	mov    %edi,%edx
801080b6:	8b 45 08             	mov    0x8(%ebp),%eax
801080b9:	e8 82 fa ff ff       	call   80107b40 <deallocuvm.part.0>
        }
        memset(mem, 0, PGSIZE);
        if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
            cprintf("allocuvm out of memory (2)\n");
            deallocuvm(pgdir, newsz, oldsz);
            kfree(mem);
801080be:	89 34 24             	mov    %esi,(%esp)
801080c1:	e8 ca a3 ff ff       	call   80102490 <kfree>
            return 0;
801080c6:	31 c0                	xor    %eax,%eax
801080c8:	eb ba                	jmp    80108084 <allocuvm+0x94>
801080ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801080cd:	89 fa                	mov    %edi,%edx
801080cf:	8b 45 08             	mov    0x8(%ebp),%eax
801080d2:	e8 69 fa ff ff       	call   80107b40 <deallocuvm.part.0>
    for(; a < newsz; a += PGSIZE){
        mem = kalloc();
        if(mem == 0){
            cprintf("allocuvm out of memory\n");
            deallocuvm(pgdir, newsz, oldsz);
            return 0;
801080d7:	31 c0                	xor    %eax,%eax
801080d9:	eb a9                	jmp    80108084 <allocuvm+0x94>
801080db:	90                   	nop
801080dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801080e0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
    int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801080e0:	55                   	push   %ebp
801080e1:	89 e5                	mov    %esp,%ebp
801080e3:	8b 55 0c             	mov    0xc(%ebp),%edx
801080e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801080e9:	8b 45 08             	mov    0x8(%ebp),%eax
    pte_t *pte;
    uint a, pa;

    if(newsz >= oldsz)
801080ec:	39 d1                	cmp    %edx,%ecx
801080ee:	73 08                	jae    801080f8 <deallocuvm+0x18>
            kfree(v);
            *pte = 0;
        }
    }
    return newsz;
}
801080f0:	5d                   	pop    %ebp
801080f1:	e9 4a fa ff ff       	jmp    80107b40 <deallocuvm.part.0>
801080f6:	66 90                	xchg   %ax,%ax
801080f8:	89 d0                	mov    %edx,%eax
801080fa:	5d                   	pop    %ebp
801080fb:	c3                   	ret    
801080fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108100 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
    void
freevm(pde_t *pgdir)
{
80108100:	55                   	push   %ebp
80108101:	89 e5                	mov    %esp,%ebp
80108103:	56                   	push   %esi
80108104:	53                   	push   %ebx
80108105:	83 ec 10             	sub    $0x10,%esp
80108108:	8b 75 08             	mov    0x8(%ebp),%esi
    uint i;

    if(pgdir == 0)
8010810b:	85 f6                	test   %esi,%esi
8010810d:	74 59                	je     80108168 <freevm+0x68>
8010810f:	31 c9                	xor    %ecx,%ecx
80108111:	ba 00 00 00 80       	mov    $0x80000000,%edx
80108116:	89 f0                	mov    %esi,%eax
        panic("freevm: no pgdir");
    deallocuvm(pgdir, KERNBASE, 0);
    for(i = 0; i < NPDENTRIES; i++){
80108118:	31 db                	xor    %ebx,%ebx
8010811a:	e8 21 fa ff ff       	call   80107b40 <deallocuvm.part.0>
8010811f:	eb 12                	jmp    80108133 <freevm+0x33>
80108121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108128:	83 c3 01             	add    $0x1,%ebx
8010812b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80108131:	74 27                	je     8010815a <freevm+0x5a>
        if(pgdir[i] & PTE_P){
80108133:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80108136:	f6 c2 01             	test   $0x1,%dl
80108139:	74 ed                	je     80108128 <freevm+0x28>
            char * v = P2V(PTE_ADDR(pgdir[i]));
8010813b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    uint i;

    if(pgdir == 0)
        panic("freevm: no pgdir");
    deallocuvm(pgdir, KERNBASE, 0);
    for(i = 0; i < NPDENTRIES; i++){
80108141:	83 c3 01             	add    $0x1,%ebx
        if(pgdir[i] & PTE_P){
            char * v = P2V(PTE_ADDR(pgdir[i]));
80108144:	81 c2 00 00 00 80    	add    $0x80000000,%edx
            kfree(v);
8010814a:	89 14 24             	mov    %edx,(%esp)
8010814d:	e8 3e a3 ff ff       	call   80102490 <kfree>
    uint i;

    if(pgdir == 0)
        panic("freevm: no pgdir");
    deallocuvm(pgdir, KERNBASE, 0);
    for(i = 0; i < NPDENTRIES; i++){
80108152:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80108158:	75 d9                	jne    80108133 <freevm+0x33>
        if(pgdir[i] & PTE_P){
            char * v = P2V(PTE_ADDR(pgdir[i]));
            kfree(v);
        }
    }
    kfree((char*)pgdir);
8010815a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010815d:	83 c4 10             	add    $0x10,%esp
80108160:	5b                   	pop    %ebx
80108161:	5e                   	pop    %esi
80108162:	5d                   	pop    %ebp
        if(pgdir[i] & PTE_P){
            char * v = P2V(PTE_ADDR(pgdir[i]));
            kfree(v);
        }
    }
    kfree((char*)pgdir);
80108163:	e9 28 a3 ff ff       	jmp    80102490 <kfree>
freevm(pde_t *pgdir)
{
    uint i;

    if(pgdir == 0)
        panic("freevm: no pgdir");
80108168:	c7 04 24 d5 9a 10 80 	movl   $0x80109ad5,(%esp)
8010816f:	e8 ec 81 ff ff       	call   80100360 <panic>
80108174:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010817a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80108180 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
    void
clearpteu(pde_t *pgdir, char *uva)
{
80108180:	55                   	push   %ebp
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
80108181:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
    void
clearpteu(pde_t *pgdir, char *uva)
{
80108183:	89 e5                	mov    %esp,%ebp
80108185:	83 ec 18             	sub    $0x18,%esp
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
80108188:	8b 55 0c             	mov    0xc(%ebp),%edx
8010818b:	8b 45 08             	mov    0x8(%ebp),%eax
8010818e:	e8 9d f8 ff ff       	call   80107a30 <walkpgdir>
    if(pte == 0)
80108193:	85 c0                	test   %eax,%eax
80108195:	74 05                	je     8010819c <clearpteu+0x1c>
        panic("clearpteu");
    *pte &= ~PTE_U;
80108197:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010819a:	c9                   	leave  
8010819b:	c3                   	ret    
{
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
    if(pte == 0)
        panic("clearpteu");
8010819c:	c7 04 24 e6 9a 10 80 	movl   $0x80109ae6,(%esp)
801081a3:	e8 b8 81 ff ff       	call   80100360 <panic>
801081a8:	90                   	nop
801081a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801081b0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
    pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801081b0:	55                   	push   %ebp
801081b1:	89 e5                	mov    %esp,%ebp
801081b3:	57                   	push   %edi
801081b4:	56                   	push   %esi
801081b5:	53                   	push   %ebx
801081b6:	83 ec 2c             	sub    $0x2c,%esp
    pde_t *d;
    pte_t *pte;
    uint pa, i, flags;
    char *mem;

    if((d = setupkvm()) == 0)
801081b9:	e8 62 fb ff ff       	call   80107d20 <setupkvm>
801081be:	85 c0                	test   %eax,%eax
801081c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801081c3:	0f 84 b2 00 00 00    	je     8010827b <copyuvm+0xcb>
        return 0;
    for(i = 0; i < sz; i += PGSIZE){
801081c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801081cc:	85 c0                	test   %eax,%eax
801081ce:	0f 84 9c 00 00 00    	je     80108270 <copyuvm+0xc0>
801081d4:	31 db                	xor    %ebx,%ebx
801081d6:	eb 48                	jmp    80108220 <copyuvm+0x70>
            panic("copyuvm: page not present");
        pa = PTE_ADDR(*pte);
        flags = PTE_FLAGS(*pte);
        if((mem = kalloc()) == 0)
            goto bad;
        memmove(mem, (char*)P2V(pa), PGSIZE);
801081d8:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801081de:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801081e5:	00 
801081e6:	89 7c 24 04          	mov    %edi,0x4(%esp)
801081ea:	89 04 24             	mov    %eax,(%esp)
801081ed:	e8 ce d4 ff ff       	call   801056c0 <memmove>
        if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
801081f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801081f5:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
801081fb:	89 14 24             	mov    %edx,(%esp)
801081fe:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108203:	89 da                	mov    %ebx,%edx
80108205:	89 44 24 04          	mov    %eax,0x4(%esp)
80108209:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010820c:	e8 af f8 ff ff       	call   80107ac0 <mappages>
80108211:	85 c0                	test   %eax,%eax
80108213:	78 41                	js     80108256 <copyuvm+0xa6>
    uint pa, i, flags;
    char *mem;

    if((d = setupkvm()) == 0)
        return 0;
    for(i = 0; i < sz; i += PGSIZE){
80108215:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010821b:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
8010821e:	76 50                	jbe    80108270 <copyuvm+0xc0>
        if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108220:	8b 45 08             	mov    0x8(%ebp),%eax
80108223:	31 c9                	xor    %ecx,%ecx
80108225:	89 da                	mov    %ebx,%edx
80108227:	e8 04 f8 ff ff       	call   80107a30 <walkpgdir>
8010822c:	85 c0                	test   %eax,%eax
8010822e:	74 5b                	je     8010828b <copyuvm+0xdb>
            panic("copyuvm: pte should exist");
        if(!(*pte & PTE_P))
80108230:	8b 30                	mov    (%eax),%esi
80108232:	f7 c6 01 00 00 00    	test   $0x1,%esi
80108238:	74 45                	je     8010827f <copyuvm+0xcf>
            panic("copyuvm: page not present");
        pa = PTE_ADDR(*pte);
8010823a:	89 f7                	mov    %esi,%edi
        flags = PTE_FLAGS(*pte);
8010823c:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80108242:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    for(i = 0; i < sz; i += PGSIZE){
        if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
            panic("copyuvm: pte should exist");
        if(!(*pte & PTE_P))
            panic("copyuvm: page not present");
        pa = PTE_ADDR(*pte);
80108245:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
        flags = PTE_FLAGS(*pte);
        if((mem = kalloc()) == 0)
8010824b:	e8 f0 a3 ff ff       	call   80102640 <kalloc>
80108250:	85 c0                	test   %eax,%eax
80108252:	89 c6                	mov    %eax,%esi
80108254:	75 82                	jne    801081d8 <copyuvm+0x28>
            goto bad;
    }
    return d;

bad:
    freevm(d);
80108256:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108259:	89 04 24             	mov    %eax,(%esp)
8010825c:	e8 9f fe ff ff       	call   80108100 <freevm>
    return 0;
80108261:	31 c0                	xor    %eax,%eax
}
80108263:	83 c4 2c             	add    $0x2c,%esp
80108266:	5b                   	pop    %ebx
80108267:	5e                   	pop    %esi
80108268:	5f                   	pop    %edi
80108269:	5d                   	pop    %ebp
8010826a:	c3                   	ret    
8010826b:	90                   	nop
8010826c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108270:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108273:	83 c4 2c             	add    $0x2c,%esp
80108276:	5b                   	pop    %ebx
80108277:	5e                   	pop    %esi
80108278:	5f                   	pop    %edi
80108279:	5d                   	pop    %ebp
8010827a:	c3                   	ret    
    pte_t *pte;
    uint pa, i, flags;
    char *mem;

    if((d = setupkvm()) == 0)
        return 0;
8010827b:	31 c0                	xor    %eax,%eax
8010827d:	eb e4                	jmp    80108263 <copyuvm+0xb3>
    for(i = 0; i < sz; i += PGSIZE){
        if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
            panic("copyuvm: pte should exist");
        if(!(*pte & PTE_P))
            panic("copyuvm: page not present");
8010827f:	c7 04 24 0a 9b 10 80 	movl   $0x80109b0a,(%esp)
80108286:	e8 d5 80 ff ff       	call   80100360 <panic>

    if((d = setupkvm()) == 0)
        return 0;
    for(i = 0; i < sz; i += PGSIZE){
        if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
            panic("copyuvm: pte should exist");
8010828b:	c7 04 24 f0 9a 10 80 	movl   $0x80109af0,(%esp)
80108292:	e8 c9 80 ff ff       	call   80100360 <panic>
80108297:	89 f6                	mov    %esi,%esi
80108299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801082a0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
    char*
uva2ka(pde_t *pgdir, char *uva)
{
801082a0:	55                   	push   %ebp
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
801082a1:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
    char*
uva2ka(pde_t *pgdir, char *uva)
{
801082a3:	89 e5                	mov    %esp,%ebp
801082a5:	83 ec 08             	sub    $0x8,%esp
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
801082a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801082ab:	8b 45 08             	mov    0x8(%ebp),%eax
801082ae:	e8 7d f7 ff ff       	call   80107a30 <walkpgdir>
    if((*pte & PTE_P) == 0)
801082b3:	8b 00                	mov    (%eax),%eax
801082b5:	89 c2                	mov    %eax,%edx
801082b7:	83 e2 05             	and    $0x5,%edx
        return 0;
    if((*pte & PTE_U) == 0)
801082ba:	83 fa 05             	cmp    $0x5,%edx
801082bd:	75 11                	jne    801082d0 <uva2ka+0x30>
        return 0;
    return (char*)P2V(PTE_ADDR(*pte));
801082bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082c4:	05 00 00 00 80       	add    $0x80000000,%eax
}
801082c9:	c9                   	leave  
801082ca:	c3                   	ret    
801082cb:	90                   	nop
801082cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    pte = walkpgdir(pgdir, uva, 0);
    if((*pte & PTE_P) == 0)
        return 0;
    if((*pte & PTE_U) == 0)
        return 0;
801082d0:	31 c0                	xor    %eax,%eax
    return (char*)P2V(PTE_ADDR(*pte));
}
801082d2:	c9                   	leave  
801082d3:	c3                   	ret    
801082d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801082da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801082e0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
    int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801082e0:	55                   	push   %ebp
801082e1:	89 e5                	mov    %esp,%ebp
801082e3:	57                   	push   %edi
801082e4:	56                   	push   %esi
801082e5:	53                   	push   %ebx
801082e6:	83 ec 1c             	sub    $0x1c,%esp
801082e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801082ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801082ef:	8b 7d 10             	mov    0x10(%ebp),%edi
    char *buf, *pa0;
    uint n, va0;

    buf = (char*)p;
    while(len > 0){
801082f2:	85 db                	test   %ebx,%ebx
801082f4:	75 3a                	jne    80108330 <copyout+0x50>
801082f6:	eb 68                	jmp    80108360 <copyout+0x80>
        va0 = (uint)PGROUNDDOWN(va);
        pa0 = uva2ka(pgdir, (char*)va0);
        if(pa0 == 0)
            return -1;
        n = PGSIZE - (va - va0);
801082f8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801082fb:	89 f2                	mov    %esi,%edx
        if(n > len)
            n = len;
        memmove(pa0 + (va - va0), buf, n);
801082fd:	89 7c 24 04          	mov    %edi,0x4(%esp)
    while(len > 0){
        va0 = (uint)PGROUNDDOWN(va);
        pa0 = uva2ka(pgdir, (char*)va0);
        if(pa0 == 0)
            return -1;
        n = PGSIZE - (va - va0);
80108301:	29 ca                	sub    %ecx,%edx
80108303:	81 c2 00 10 00 00    	add    $0x1000,%edx
80108309:	39 da                	cmp    %ebx,%edx
8010830b:	0f 47 d3             	cmova  %ebx,%edx
        if(n > len)
            n = len;
        memmove(pa0 + (va - va0), buf, n);
8010830e:	29 f1                	sub    %esi,%ecx
80108310:	01 c8                	add    %ecx,%eax
80108312:	89 54 24 08          	mov    %edx,0x8(%esp)
80108316:	89 04 24             	mov    %eax,(%esp)
80108319:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010831c:	e8 9f d3 ff ff       	call   801056c0 <memmove>
        len -= n;
        buf += n;
80108321:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        va = va0 + PGSIZE;
80108324:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
        n = PGSIZE - (va - va0);
        if(n > len)
            n = len;
        memmove(pa0 + (va - va0), buf, n);
        len -= n;
        buf += n;
8010832a:	01 d7                	add    %edx,%edi
{
    char *buf, *pa0;
    uint n, va0;

    buf = (char*)p;
    while(len > 0){
8010832c:	29 d3                	sub    %edx,%ebx
8010832e:	74 30                	je     80108360 <copyout+0x80>
        va0 = (uint)PGROUNDDOWN(va);
        pa0 = uva2ka(pgdir, (char*)va0);
80108330:	8b 45 08             	mov    0x8(%ebp),%eax
    char *buf, *pa0;
    uint n, va0;

    buf = (char*)p;
    while(len > 0){
        va0 = (uint)PGROUNDDOWN(va);
80108333:	89 ce                	mov    %ecx,%esi
80108335:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
        pa0 = uva2ka(pgdir, (char*)va0);
8010833b:	89 74 24 04          	mov    %esi,0x4(%esp)
    char *buf, *pa0;
    uint n, va0;

    buf = (char*)p;
    while(len > 0){
        va0 = (uint)PGROUNDDOWN(va);
8010833f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
        pa0 = uva2ka(pgdir, (char*)va0);
80108342:	89 04 24             	mov    %eax,(%esp)
80108345:	e8 56 ff ff ff       	call   801082a0 <uva2ka>
        if(pa0 == 0)
8010834a:	85 c0                	test   %eax,%eax
8010834c:	75 aa                	jne    801082f8 <copyout+0x18>
        len -= n;
        buf += n;
        va = va0 + PGSIZE;
    }
    return 0;
}
8010834e:	83 c4 1c             	add    $0x1c,%esp
    buf = (char*)p;
    while(len > 0){
        va0 = (uint)PGROUNDDOWN(va);
        pa0 = uva2ka(pgdir, (char*)va0);
        if(pa0 == 0)
            return -1;
80108351:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        len -= n;
        buf += n;
        va = va0 + PGSIZE;
    }
    return 0;
}
80108356:	5b                   	pop    %ebx
80108357:	5e                   	pop    %esi
80108358:	5f                   	pop    %edi
80108359:	5d                   	pop    %ebp
8010835a:	c3                   	ret    
8010835b:	90                   	nop
8010835c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108360:	83 c4 1c             	add    $0x1c,%esp
        memmove(pa0 + (va - va0), buf, n);
        len -= n;
        buf += n;
        va = va0 + PGSIZE;
    }
    return 0;
80108363:	31 c0                	xor    %eax,%eax
}
80108365:	5b                   	pop    %ebx
80108366:	5e                   	pop    %esi
80108367:	5f                   	pop    %edi
80108368:	5d                   	pop    %ebp
80108369:	c3                   	ret    
8010836a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108370 <empty_stack_clean>:
// Blank page.

//ADDED
//HW3
void
empty_stack_clean(struct proc *p){
80108370:	55                   	push   %ebp
80108371:	89 e5                	mov    %esp,%ebp
80108373:	56                   	push   %esi
80108374:	8b 75 08             	mov    0x8(%ebp),%esi
80108377:	53                   	push   %ebx
    int* run;
    pte_t *pte;
    uint pa;

    run = (int*)p->sz;
    for(;(int)run > p->tf->ebp; run -= 1){
80108378:	8b 46 18             	mov    0x18(%esi),%eax
empty_stack_clean(struct proc *p){
    int* run;
    pte_t *pte;
    uint pa;

    run = (int*)p->sz;
8010837b:	8b 1e                	mov    (%esi),%ebx
    for(;(int)run > p->tf->ebp; run -= 1){
8010837d:	3b 58 08             	cmp    0x8(%eax),%ebx
80108380:	76 2e                	jbe    801083b0 <empty_stack_clean+0x40>

        pte = walkpgdir(p->pgdir, run, 0);
80108382:	8b 46 04             	mov    0x4(%esi),%eax
80108385:	31 c9                	xor    %ecx,%ecx
80108387:	89 da                	mov    %ebx,%edx
80108389:	e8 a2 f6 ff ff       	call   80107a30 <walkpgdir>
        if(!pte){
8010838e:	85 c0                	test   %eax,%eax
80108390:	74 26                	je     801083b8 <empty_stack_clean+0x48>
            run = (int*)(PGADDR(PDX(*run) + 1, 0, 0) - PGSIZE);
        }else if((*pte & PTE_P) != 0){
80108392:	8b 00                	mov    (%eax),%eax
80108394:	a8 01                	test   $0x1,%al
80108396:	74 07                	je     8010839f <empty_stack_clean+0x2f>
            pa = PTE_ADDR(*pte);
            if(pa == 0) continue;
80108398:	a9 00 f0 ff ff       	test   $0xfffff000,%eax
8010839d:	75 11                	jne    801083b0 <empty_stack_clean+0x40>
    int* run;
    pte_t *pte;
    uint pa;

    run = (int*)p->sz;
    for(;(int)run > p->tf->ebp; run -= 1){
8010839f:	8b 46 18             	mov    0x18(%esi),%eax
801083a2:	83 eb 04             	sub    $0x4,%ebx
801083a5:	3b 58 08             	cmp    0x8(%eax),%ebx
801083a8:	77 d8                	ja     80108382 <empty_stack_clean+0x12>
801083aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            pa = PTE_ADDR(*pte);
            if(pa == 0) continue;
            break;
        }
    }
    p->sz = (int)run;
801083b0:	89 1e                	mov    %ebx,(%esi)

}
801083b2:	5b                   	pop    %ebx
801083b3:	5e                   	pop    %esi
801083b4:	5d                   	pop    %ebp
801083b5:	c3                   	ret    
801083b6:	66 90                	xchg   %ax,%ax
    run = (int*)p->sz;
    for(;(int)run > p->tf->ebp; run -= 1){

        pte = walkpgdir(p->pgdir, run, 0);
        if(!pte){
            run = (int*)(PGADDR(PDX(*run) + 1, 0, 0) - PGSIZE);
801083b8:	8b 1b                	mov    (%ebx),%ebx
801083ba:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801083c0:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
801083c6:	eb d7                	jmp    8010839f <empty_stack_clean+0x2f>
801083c8:	90                   	nop
801083c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801083d0 <copyuvm_force>:
}
// Given a parent process's page table, create a copy
// of it for a child.
    pde_t*
copyuvm_force(pde_t *pgdir, uint sz)
{
801083d0:	55                   	push   %ebp
801083d1:	89 e5                	mov    %esp,%ebp
801083d3:	57                   	push   %edi
801083d4:	56                   	push   %esi
801083d5:	53                   	push   %ebx
801083d6:	83 ec 2c             	sub    $0x2c,%esp
    pde_t *d;
    pte_t *pte;
    uint pa, i, flags;
    char *mem;

    if((d = setupkvm()) == 0)
801083d9:	e8 42 f9 ff ff       	call   80107d20 <setupkvm>
801083de:	85 c0                	test   %eax,%eax
801083e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801083e3:	0f 84 d2 00 00 00    	je     801084bb <copyuvm_force+0xeb>
        return 0;
    for(i = 0; i < sz; i += PGSIZE){
801083e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801083ec:	85 c0                	test   %eax,%eax
801083ee:	0f 84 bc 00 00 00    	je     801084b0 <copyuvm_force+0xe0>
801083f4:	31 db                	xor    %ebx,%ebx
801083f6:	8b 7d 08             	mov    0x8(%ebp),%edi
801083f9:	eb 14                	jmp    8010840f <copyuvm_force+0x3f>
801083fb:	90                   	nop
801083fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108400:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108406:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80108409:	0f 86 a1 00 00 00    	jbe    801084b0 <copyuvm_force+0xe0>
        if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010840f:	31 c9                	xor    %ecx,%ecx
80108411:	89 da                	mov    %ebx,%edx
80108413:	89 f8                	mov    %edi,%eax
80108415:	e8 16 f6 ff ff       	call   80107a30 <walkpgdir>
8010841a:	85 c0                	test   %eax,%eax
8010841c:	0f 84 9d 00 00 00    	je     801084bf <copyuvm_force+0xef>
            panic("copyuvm: pte should exist");
        if(!(*pte & PTE_P))
80108422:	8b 30                	mov    (%eax),%esi
80108424:	f7 c6 01 00 00 00    	test   $0x1,%esi
8010842a:	74 d4                	je     80108400 <copyuvm_force+0x30>
            continue;
        pa = PTE_ADDR(*pte);
        *pte = *pte | PTE_P;
8010842c:	89 f2                	mov    %esi,%edx
    for(i = 0; i < sz; i += PGSIZE){
        if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
            panic("copyuvm: pte should exist");
        if(!(*pte & PTE_P))
            continue;
        pa = PTE_ADDR(*pte);
8010842e:	89 f1                	mov    %esi,%ecx
        *pte = *pte | PTE_P;
80108430:	83 ca 01             	or     $0x1,%edx
    for(i = 0; i < sz; i += PGSIZE){
        if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
            panic("copyuvm: pte should exist");
        if(!(*pte & PTE_P))
            continue;
        pa = PTE_ADDR(*pte);
80108433:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
        *pte = *pte | PTE_P;
80108439:	89 10                	mov    %edx,(%eax)
        flags = PTE_FLAGS(*pte);
8010843b:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
    for(i = 0; i < sz; i += PGSIZE){
        if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
            panic("copyuvm: pte should exist");
        if(!(*pte & PTE_P))
            continue;
        pa = PTE_ADDR(*pte);
80108441:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
        *pte = *pte | PTE_P;
        flags = PTE_FLAGS(*pte);
80108444:	83 ce 01             	or     $0x1,%esi
        if((mem = kalloc()) == 0)
80108447:	e8 f4 a1 ff ff       	call   80102640 <kalloc>
8010844c:	85 c0                	test   %eax,%eax
8010844e:	89 c2                	mov    %eax,%edx
80108450:	74 46                	je     80108498 <copyuvm_force+0xc8>
            goto bad;
        memmove(mem, (char*)P2V(pa), PGSIZE);
80108452:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108455:	89 14 24             	mov    %edx,(%esp)
80108458:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010845f:	00 
80108460:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80108463:	05 00 00 00 80       	add    $0x80000000,%eax
80108468:	89 44 24 04          	mov    %eax,0x4(%esp)
8010846c:	e8 4f d2 ff ff       	call   801056c0 <memmove>
        if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80108471:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108474:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108479:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010847c:	89 74 24 04          	mov    %esi,0x4(%esp)
80108480:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108486:	89 14 24             	mov    %edx,(%esp)
80108489:	89 da                	mov    %ebx,%edx
8010848b:	e8 30 f6 ff ff       	call   80107ac0 <mappages>
80108490:	85 c0                	test   %eax,%eax
80108492:	0f 89 68 ff ff ff    	jns    80108400 <copyuvm_force+0x30>
            goto bad;
    }
    return d;

bad:
    freevm(d);
80108498:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010849b:	89 04 24             	mov    %eax,(%esp)
8010849e:	e8 5d fc ff ff       	call   80108100 <freevm>
    return 0;
}
801084a3:	83 c4 2c             	add    $0x2c,%esp
    }
    return d;

bad:
    freevm(d);
    return 0;
801084a6:	31 c0                	xor    %eax,%eax
}
801084a8:	5b                   	pop    %ebx
801084a9:	5e                   	pop    %esi
801084aa:	5f                   	pop    %edi
801084ab:	5d                   	pop    %ebp
801084ac:	c3                   	ret    
801084ad:	8d 76 00             	lea    0x0(%esi),%esi
    uint pa, i, flags;
    char *mem;

    if((d = setupkvm()) == 0)
        return 0;
    for(i = 0; i < sz; i += PGSIZE){
801084b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
    return d;

bad:
    freevm(d);
    return 0;
}
801084b3:	83 c4 2c             	add    $0x2c,%esp
801084b6:	5b                   	pop    %ebx
801084b7:	5e                   	pop    %esi
801084b8:	5f                   	pop    %edi
801084b9:	5d                   	pop    %ebp
801084ba:	c3                   	ret    
    pte_t *pte;
    uint pa, i, flags;
    char *mem;

    if((d = setupkvm()) == 0)
        return 0;
801084bb:	31 c0                	xor    %eax,%eax
801084bd:	eb f4                	jmp    801084b3 <copyuvm_force+0xe3>
    for(i = 0; i < sz; i += PGSIZE){
        if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
            panic("copyuvm: pte should exist");
801084bf:	c7 04 24 f0 9a 10 80 	movl   $0x80109af0,(%esp)
801084c6:	e8 95 7e ff ff       	call   80100360 <panic>
801084cb:	66 90                	xchg   %ax,%ax
801084cd:	66 90                	xchg   %ax,%ax
801084cf:	90                   	nop

801084d0 <my_syscall>:
#include "defs.h"
#include "syscall.h"

//Simple system call
int 
my_syscall(char *str){
801084d0:	55                   	push   %ebp
801084d1:	89 e5                	mov    %esp,%ebp
801084d3:	83 ec 18             	sub    $0x18,%esp
    cprintf("%s\n", str);
801084d6:	8b 45 08             	mov    0x8(%ebp),%eax
801084d9:	c7 04 24 c3 9b 10 80 	movl   $0x80109bc3,(%esp)
801084e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801084e4:	e8 67 81 ff ff       	call   80100650 <cprintf>
    return 0xABCD;
}
801084e9:	b8 cd ab 00 00       	mov    $0xabcd,%eax
801084ee:	c9                   	leave  
801084ef:	c3                   	ret    

801084f0 <sys_my_syscall>:

// Wrapper for my_syscall
int
sys_my_syscall(void){
801084f0:	55                   	push   %ebp
801084f1:	89 e5                	mov    %esp,%ebp
801084f3:	83 ec 28             	sub    $0x28,%esp
    char *str;
    cprintf("Wrapper\n");
801084f6:	c7 04 24 47 9b 10 80 	movl   $0x80109b47,(%esp)
801084fd:	e8 4e 81 ff ff       	call   80100650 <cprintf>
    //Decode argument using argstr
    if(argstr(0, &str) <0)
80108502:	8d 45 f4             	lea    -0xc(%ebp),%eax
80108505:	89 44 24 04          	mov    %eax,0x4(%esp)
80108509:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80108510:	e8 6b d4 ff ff       	call   80105980 <argstr>
80108515:	85 c0                	test   %eax,%eax
80108517:	78 1f                	js     80108538 <sys_my_syscall+0x48>
#include "syscall.h"

//Simple system call
int 
my_syscall(char *str){
    cprintf("%s\n", str);
80108519:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010851c:	c7 04 24 c3 9b 10 80 	movl   $0x80109bc3,(%esp)
80108523:	89 44 24 04          	mov    %eax,0x4(%esp)
80108527:	e8 24 81 ff ff       	call   80100650 <cprintf>
    char *str;
    cprintf("Wrapper\n");
    //Decode argument using argstr
    if(argstr(0, &str) <0)
        return -1;
    return my_syscall(str);
8010852c:	b8 cd ab 00 00       	mov    $0xabcd,%eax
}
80108531:	c9                   	leave  
80108532:	c3                   	ret    
80108533:	90                   	nop
80108534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_my_syscall(void){
    char *str;
    cprintf("Wrapper\n");
    //Decode argument using argstr
    if(argstr(0, &str) <0)
        return -1;
80108538:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return my_syscall(str);
}
8010853d:	c9                   	leave  
8010853e:	c3                   	ret    
8010853f:	90                   	nop

80108540 <error>:
#include "mlfq.h"
#include "stride.h"
#include "spinlock.h"

void error(char *message)
{
80108540:	55                   	push   %ebp
80108541:	89 e5                	mov    %esp,%ebp
80108543:	83 ec 18             	sub    $0x18,%esp
    cprintf("%s\n",message);
80108546:	8b 45 08             	mov    0x8(%ebp),%eax
80108549:	c7 04 24 c3 9b 10 80 	movl   $0x80109bc3,(%esp)
80108550:	89 44 24 04          	mov    %eax,0x4(%esp)
80108554:	e8 f7 80 ff ff       	call   80100650 <cprintf>
    return ;
}
80108559:	c9                   	leave  
8010855a:	c3                   	ret    
8010855b:	90                   	nop
8010855c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108560 <initMlfq>:

void initMlfq(struct Mlfq* q)
{
80108560:	55                   	push   %ebp
    int i;
    q->front = 0;
80108561:	31 c0                	xor    %eax,%eax
    cprintf("%s\n",message);
    return ;
}

void initMlfq(struct Mlfq* q)
{
80108563:	89 e5                	mov    %esp,%ebp
80108565:	8b 55 08             	mov    0x8(%ebp),%edx
    int i;
    q->front = 0;
80108568:	66 89 82 02 01 00 00 	mov    %ax,0x102(%edx)
    q->rear = 0;
8010856f:	31 c0                	xor    %eax,%eax
80108571:	66 89 82 04 01 00 00 	mov    %ax,0x104(%edx)
    q->count = 0;
80108578:	31 c0                	xor    %eax,%eax
8010857a:	66 89 82 06 01 00 00 	mov    %ax,0x106(%edx)
    q->rCount = 0;
80108581:	31 c0                	xor    %eax,%eax
80108583:	66 89 82 08 01 00 00 	mov    %ax,0x108(%edx)
    for(i=0; i<MAX_QUEUE_SIZE;i++){
8010858a:	31 c0                	xor    %eax,%eax
8010858c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return ret;
}

    //Erase the pointer that pointing front of q
void deleteProcPointerOfQ(struct proc** p){
    if(*p) *p=0;
80108590:	8b 0c 82             	mov    (%edx,%eax,4),%ecx
80108593:	85 c9                	test   %ecx,%ecx
80108595:	74 07                	je     8010859e <initMlfq+0x3e>
80108597:	c7 04 82 00 00 00 00 	movl   $0x0,(%edx,%eax,4)
    int i;
    q->front = 0;
    q->rear = 0;
    q->count = 0;
    q->rCount = 0;
    for(i=0; i<MAX_QUEUE_SIZE;i++){
8010859e:	83 c0 01             	add    $0x1,%eax
801085a1:	83 f8 40             	cmp    $0x40,%eax
801085a4:	75 ea                	jne    80108590 <initMlfq+0x30>
        deleteProcPointerOfQ(&q->queue[i]);
    }
}
801085a6:	5d                   	pop    %ebp
801085a7:	c3                   	ret    
801085a8:	90                   	nop
801085a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801085b0 <initMlfqGlobal>:
void initMlfqGlobal(){
    qOfM[0].level = 0;
801085b0:	31 c0                	xor    %eax,%eax
    qOfM[1].level = 1;
801085b2:	ba 01 00 00 00       	mov    $0x1,%edx
    for(i=0; i<MAX_QUEUE_SIZE;i++){
        deleteProcPointerOfQ(&q->queue[i]);
    }
}
void initMlfqGlobal(){
    qOfM[0].level = 0;
801085b7:	66 a3 00 21 11 80    	mov    %ax,0x80112100
    qOfM[1].level = 1;
    qOfM[2].level = 2;
    qOfM[0].timeQuan = Q0_TIME_QUANTUM;
801085bd:	b8 01 00 00 00       	mov    $0x1,%eax
    }
}
void initMlfqGlobal(){
    qOfM[0].level = 0;
    qOfM[1].level = 1;
    qOfM[2].level = 2;
801085c2:	b9 02 00 00 00       	mov    $0x2,%ecx
    qOfM[0].timeQuan = Q0_TIME_QUANTUM;
801085c7:	66 a3 0a 21 11 80    	mov    %ax,0x8011210a
    qOfM[1].timeQuan = Q1_TIME_QUANTUM;
801085cd:	b8 01 00 00 00       	mov    $0x1,%eax
801085d2:	66 a3 1a 22 11 80    	mov    %ax,0x8011221a
    qOfM[2].timeQuan = Q2_TIME_QUANTUM;
801085d8:	b8 01 00 00 00       	mov    $0x1,%eax
801085dd:	66 a3 2a 23 11 80    	mov    %ax,0x8011232a
    qOfM[0].timeAllot = Q0_TIME_ALLOT; 
801085e3:	b8 05 00 00 00       	mov    $0x5,%eax
801085e8:	66 a3 0c 21 11 80    	mov    %ax,0x8011210c
    qOfM[1].timeAllot = Q1_TIME_ALLOT; 
801085ee:	b8 0a 00 00 00       	mov    $0xa,%eax
    q->rCount = 0;
    for(i=0; i<MAX_QUEUE_SIZE;i++){
        deleteProcPointerOfQ(&q->queue[i]);
    }
}
void initMlfqGlobal(){
801085f3:	55                   	push   %ebp
801085f4:	89 e5                	mov    %esp,%ebp
    qOfM[0].level = 0;
    qOfM[1].level = 1;
801085f6:	66 89 15 10 22 11 80 	mov    %dx,0x80112210
    qOfM[2].timeQuan = Q2_TIME_QUANTUM;
    qOfM[0].timeAllot = Q0_TIME_ALLOT; 
    qOfM[1].timeAllot = Q1_TIME_ALLOT; 
    qOfM[2].timeAllot = Q2_TIME_ALLOT; 
    MlfqPass = 0;
    MlfqStride = STRIDE_LARGE_NUMBER / MLFQ_CPU_SHARE;
801085fd:	ba f4 01 00 00       	mov    $0x1f4,%edx
    qOfM[2].level = 2;
    qOfM[0].timeQuan = Q0_TIME_QUANTUM;
    qOfM[1].timeQuan = Q1_TIME_QUANTUM;
    qOfM[2].timeQuan = Q2_TIME_QUANTUM;
    qOfM[0].timeAllot = Q0_TIME_ALLOT; 
    qOfM[1].timeAllot = Q1_TIME_ALLOT; 
80108602:	66 a3 1c 22 11 80    	mov    %ax,0x8011221c
    qOfM[2].timeAllot = Q2_TIME_ALLOT; 
80108608:	b8 14 00 00 00       	mov    $0x14,%eax
    }
}
void initMlfqGlobal(){
    qOfM[0].level = 0;
    qOfM[1].level = 1;
    qOfM[2].level = 2;
8010860d:	66 89 0d 20 23 11 80 	mov    %cx,0x80112320
    qOfM[0].timeQuan = Q0_TIME_QUANTUM;
    qOfM[1].timeQuan = Q1_TIME_QUANTUM;
    qOfM[2].timeQuan = Q2_TIME_QUANTUM;
    qOfM[0].timeAllot = Q0_TIME_ALLOT; 
    qOfM[1].timeAllot = Q1_TIME_ALLOT; 
    qOfM[2].timeAllot = Q2_TIME_ALLOT; 
80108614:	66 a3 2c 23 11 80    	mov    %ax,0x8011232c
    MlfqPass = 0;
8010861a:	c7 05 38 23 11 80 00 	movl   $0x0,0x80112338
80108621:	00 00 00 
    MlfqStride = STRIDE_LARGE_NUMBER / MLFQ_CPU_SHARE;
80108624:	66 89 15 e8 1f 11 80 	mov    %dx,0x80111fe8
    MlfqCPUShare = MLFQ_CPU_SHARE;
8010862b:	c7 05 34 23 11 80 14 	movl   $0x14,0x80112334
80108632:	00 00 00 

}
80108635:	5d                   	pop    %ebp
80108636:	c3                   	ret    
80108637:	89 f6                	mov    %esi,%esi
80108639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108640 <is_empty>:

int is_empty(struct Mlfq* q)
{
80108640:	55                   	push   %ebp
    if(q->front == q->rear && q->count == 0 ){
        cprintf("Queue is empty\n");
        return 1;
    }else return 0;
80108641:	31 c0                	xor    %eax,%eax
    MlfqCPUShare = MLFQ_CPU_SHARE;

}

int is_empty(struct Mlfq* q)
{
80108643:	89 e5                	mov    %esp,%ebp
80108645:	83 ec 18             	sub    $0x18,%esp
80108648:	8b 55 08             	mov    0x8(%ebp),%edx
    if(q->front == q->rear && q->count == 0 ){
8010864b:	0f b7 8a 04 01 00 00 	movzwl 0x104(%edx),%ecx
80108652:	66 39 8a 02 01 00 00 	cmp    %cx,0x102(%edx)
80108659:	74 05                	je     80108660 <is_empty+0x20>
        cprintf("Queue is empty\n");
        return 1;
    }else return 0;

}
8010865b:	c9                   	leave  
8010865c:	c3                   	ret    
8010865d:	8d 76 00             	lea    0x0(%esi),%esi

}

int is_empty(struct Mlfq* q)
{
    if(q->front == q->rear && q->count == 0 ){
80108660:	66 83 ba 06 01 00 00 	cmpw   $0x0,0x106(%edx)
80108667:	00 
80108668:	75 f1                	jne    8010865b <is_empty+0x1b>
        cprintf("Queue is empty\n");
8010866a:	c7 04 24 50 9b 10 80 	movl   $0x80109b50,(%esp)
80108671:	e8 da 7f ff ff       	call   80100650 <cprintf>
        return 1;
80108676:	b8 01 00 00 00       	mov    $0x1,%eax
    }else return 0;

}
8010867b:	c9                   	leave  
8010867c:	c3                   	ret    
8010867d:	8d 76 00             	lea    0x0(%esi),%esi

80108680 <is_full>:
int is_full (struct Mlfq* q)
{
80108680:	55                   	push   %ebp
    if((q->rear)%MAX_QUEUE_SIZE == q->front && q->count == MAX_QUEUE_SIZE){
        cprintf("Queue is full\n");
        return 1;
    }
    else return 0;
80108681:	31 c0                	xor    %eax,%eax
        return 1;
    }else return 0;

}
int is_full (struct Mlfq* q)
{
80108683:	89 e5                	mov    %esp,%ebp
80108685:	83 ec 18             	sub    $0x18,%esp
80108688:	8b 4d 08             	mov    0x8(%ebp),%ecx
    if((q->rear)%MAX_QUEUE_SIZE == q->front && q->count == MAX_QUEUE_SIZE){
8010868b:	0f b7 91 04 01 00 00 	movzwl 0x104(%ecx),%edx
80108692:	83 e2 3f             	and    $0x3f,%edx
80108695:	66 3b 91 02 01 00 00 	cmp    0x102(%ecx),%dx
8010869c:	74 02                	je     801086a0 <is_full+0x20>
        cprintf("Queue is full\n");
        return 1;
    }
    else return 0;
}
8010869e:	c9                   	leave  
8010869f:	c3                   	ret    
    }else return 0;

}
int is_full (struct Mlfq* q)
{
    if((q->rear)%MAX_QUEUE_SIZE == q->front && q->count == MAX_QUEUE_SIZE){
801086a0:	66 83 b9 06 01 00 00 	cmpw   $0x40,0x106(%ecx)
801086a7:	40 
801086a8:	75 f4                	jne    8010869e <is_full+0x1e>
        cprintf("Queue is full\n");
801086aa:	c7 04 24 60 9b 10 80 	movl   $0x80109b60,(%esp)
801086b1:	e8 9a 7f ff ff       	call   80100650 <cprintf>
        return 1;
801086b6:	b8 01 00 00 00       	mov    $0x1,%eax
    }
    else return 0;
}
801086bb:	c9                   	leave  
801086bc:	c3                   	ret    
801086bd:	8d 76 00             	lea    0x0(%esi),%esi

801086c0 <enqueue>:
int enqueue( struct Mlfq* q, struct proc* item )
{
801086c0:	55                   	push   %ebp
801086c1:	89 e5                	mov    %esp,%ebp
801086c3:	56                   	push   %esi
801086c4:	53                   	push   %ebx
801086c5:	83 ec 10             	sub    $0x10,%esp
801086c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801086cb:	8b 75 0c             	mov    0xc(%ebp),%esi
    if(is_full(q)) return -1;
801086ce:	89 1c 24             	mov    %ebx,(%esp)
801086d1:	e8 aa ff ff ff       	call   80108680 <is_full>
801086d6:	85 c0                	test   %eax,%eax
801086d8:	75 3e                	jne    80108718 <enqueue+0x58>
    if(item->stride > 0) return -1;
801086da:	66 83 7e 7e 00       	cmpw   $0x0,0x7e(%esi)
801086df:	75 37                	jne    80108718 <enqueue+0x58>
    q->rear = (q->rear + 1)% MAX_QUEUE_SIZE;
801086e1:	0f b7 93 04 01 00 00 	movzwl 0x104(%ebx),%edx
801086e8:	83 c2 01             	add    $0x1,%edx
801086eb:	83 e2 3f             	and    $0x3f,%edx
801086ee:	66 89 93 04 01 00 00 	mov    %dx,0x104(%ebx)
    q->queue[q->rear] = item;
801086f5:	89 34 93             	mov    %esi,(%ebx,%edx,4)
    item->qPosi = q->level;
801086f8:	0f b7 93 00 01 00 00 	movzwl 0x100(%ebx),%edx
801086ff:	66 89 56 7c          	mov    %dx,0x7c(%esi)
    q->count++;
80108703:	66 83 83 06 01 00 00 	addw   $0x1,0x106(%ebx)
8010870a:	01 

    return 0;
}
8010870b:	83 c4 10             	add    $0x10,%esp
8010870e:	5b                   	pop    %ebx
8010870f:	5e                   	pop    %esi
80108710:	5d                   	pop    %ebp
80108711:	c3                   	ret    
80108712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }
    else return 0;
}
int enqueue( struct Mlfq* q, struct proc* item )
{
    if(is_full(q)) return -1;
80108718:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010871d:	eb ec                	jmp    8010870b <enqueue+0x4b>
8010871f:	90                   	nop

80108720 <normalDequeue>:
    }

    return ret;
}
struct proc* normalDequeue(struct Mlfq* q)
{
80108720:	55                   	push   %ebp
80108721:	89 e5                	mov    %esp,%ebp
80108723:	53                   	push   %ebx
80108724:	83 ec 14             	sub    $0x14,%esp
80108727:	8b 55 08             	mov    0x8(%ebp),%edx

}

int is_empty(struct Mlfq* q)
{
    if(q->front == q->rear && q->count == 0 ){
8010872a:	0f b7 82 02 01 00 00 	movzwl 0x102(%edx),%eax
80108731:	66 3b 82 04 01 00 00 	cmp    0x104(%edx),%ax
80108738:	0f b7 9a 06 01 00 00 	movzwl 0x106(%edx),%ebx
8010873f:	74 2f                	je     80108770 <normalDequeue+0x50>
{
    struct proc* ret;

    if(is_empty(q)) return 0;

    q->front = (q->front + 1)% MAX_QUEUE_SIZE;
80108741:	83 c0 01             	add    $0x1,%eax
    ret = q->queue[q->front];
    q->count--;
80108744:	83 eb 01             	sub    $0x1,%ebx
{
    struct proc* ret;

    if(is_empty(q)) return 0;

    q->front = (q->front + 1)% MAX_QUEUE_SIZE;
80108747:	83 e0 3f             	and    $0x3f,%eax
8010874a:	8d 0c 82             	lea    (%edx,%eax,4),%ecx
8010874d:	66 89 82 02 01 00 00 	mov    %ax,0x102(%edx)
    ret = q->queue[q->front];
80108754:	8b 01                	mov    (%ecx),%eax
    q->count--;
80108756:	66 89 9a 06 01 00 00 	mov    %bx,0x106(%edx)
    return ret;
}

    //Erase the pointer that pointing front of q
void deleteProcPointerOfQ(struct proc** p){
    if(*p) *p=0;
8010875d:	85 c0                	test   %eax,%eax
8010875f:	74 27                	je     80108788 <normalDequeue+0x68>
80108761:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
    ret = q->queue[q->front];
    q->count--;
    deleteProcPointerOfQ(&q->queue[q->front]);

    return ret;
}
80108767:	83 c4 14             	add    $0x14,%esp
8010876a:	5b                   	pop    %ebx
8010876b:	5d                   	pop    %ebp
8010876c:	c3                   	ret    
8010876d:	8d 76 00             	lea    0x0(%esi),%esi

}

int is_empty(struct Mlfq* q)
{
    if(q->front == q->rear && q->count == 0 ){
80108770:	66 85 db             	test   %bx,%bx
80108773:	75 cc                	jne    80108741 <normalDequeue+0x21>
        cprintf("Queue is empty\n");
80108775:	c7 04 24 50 9b 10 80 	movl   $0x80109b50,(%esp)
8010877c:	e8 cf 7e ff ff       	call   80100650 <cprintf>
}
struct proc* normalDequeue(struct Mlfq* q)
{
    struct proc* ret;

    if(is_empty(q)) return 0;
80108781:	31 c0                	xor    %eax,%eax
80108783:	eb e2                	jmp    80108767 <normalDequeue+0x47>
80108785:	8d 76 00             	lea    0x0(%esi),%esi
    ret = q->queue[q->front];
    q->count--;
    deleteProcPointerOfQ(&q->queue[q->front]);

    return ret;
}
80108788:	83 c4 14             	add    $0x14,%esp

    //Erase the pointer that pointing front of q
void deleteProcPointerOfQ(struct proc** p){
    if(*p) *p=0;
8010878b:	31 c0                	xor    %eax,%eax
    ret = q->queue[q->front];
    q->count--;
    deleteProcPointerOfQ(&q->queue[q->front]);

    return ret;
}
8010878d:	5b                   	pop    %ebx
8010878e:	5d                   	pop    %ebp
8010878f:	c3                   	ret    

80108790 <deleteProcPointerOfQ>:

    //Erase the pointer that pointing front of q
void deleteProcPointerOfQ(struct proc** p){
80108790:	55                   	push   %ebp
80108791:	89 e5                	mov    %esp,%ebp
80108793:	8b 45 08             	mov    0x8(%ebp),%eax
    if(*p) *p=0;
80108796:	8b 10                	mov    (%eax),%edx
80108798:	85 d2                	test   %edx,%edx
8010879a:	74 06                	je     801087a2 <deleteProcPointerOfQ+0x12>
8010879c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
801087a2:	5d                   	pop    %ebp
801087a3:	c3                   	ret    
801087a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801087aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801087b0 <peekMlfq>:
struct proc* peekMlfq(struct Mlfq* q)
{
801087b0:	55                   	push   %ebp
801087b1:	89 e5                	mov    %esp,%ebp
801087b3:	8b 55 08             	mov    0x8(%ebp),%edx

    struct proc* ret;
    ret = q->queue[(q->front+1) % MAX_QUEUE_SIZE];
    return ret;
}
801087b6:	5d                   	pop    %ebp
}
struct proc* peekMlfq(struct Mlfq* q)
{

    struct proc* ret;
    ret = q->queue[(q->front+1) % MAX_QUEUE_SIZE];
801087b7:	0f b7 82 02 01 00 00 	movzwl 0x102(%edx),%eax
801087be:	83 c0 01             	add    $0x1,%eax
801087c1:	83 e0 3f             	and    $0x3f,%eax
    return ret;
801087c4:	8b 04 82             	mov    (%edx,%eax,4),%eax
}
801087c7:	c3                   	ret    
801087c8:	90                   	nop
801087c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801087d0 <idxPeekMlfq>:


struct proc* idxPeekMlfq(struct Mlfq* q, int index)
{
801087d0:	55                   	push   %ebp
801087d1:	89 e5                	mov    %esp,%ebp
801087d3:	8b 4d 08             	mov    0x8(%ebp),%ecx

    struct proc* ret;
    ret = q->queue[(q->front+1+index) % MAX_QUEUE_SIZE];
801087d6:	0f b7 81 02 01 00 00 	movzwl 0x102(%ecx),%eax
801087dd:	83 c0 01             	add    $0x1,%eax
801087e0:	03 45 0c             	add    0xc(%ebp),%eax
    return ret;
}
801087e3:	5d                   	pop    %ebp

struct proc* idxPeekMlfq(struct Mlfq* q, int index)
{

    struct proc* ret;
    ret = q->queue[(q->front+1+index) % MAX_QUEUE_SIZE];
801087e4:	99                   	cltd   
801087e5:	c1 ea 1a             	shr    $0x1a,%edx
801087e8:	01 d0                	add    %edx,%eax
801087ea:	83 e0 3f             	and    $0x3f,%eax
801087ed:	29 d0                	sub    %edx,%eax
    return ret;
801087ef:	8b 04 81             	mov    (%ecx,%eax,4),%eax
}
801087f2:	c3                   	ret    
801087f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801087f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108800 <checkRcount>:

void checkRcount(struct Mlfq* q){
80108800:	55                   	push   %ebp
80108801:	89 e5                	mov    %esp,%ebp
80108803:	8b 4d 08             	mov    0x8(%ebp),%ecx
    int i=0;
    struct proc* p;

    q->rCount = q->count;
80108806:	0f b7 81 06 01 00 00 	movzwl 0x106(%ecx),%eax
}
struct proc* peekMlfq(struct Mlfq* q)
{

    struct proc* ret;
    ret = q->queue[(q->front+1) % MAX_QUEUE_SIZE];
8010880d:	0f b7 91 02 01 00 00 	movzwl 0x102(%ecx),%edx

void checkRcount(struct Mlfq* q){
    int i=0;
    struct proc* p;

    q->rCount = q->count;
80108814:	66 89 81 08 01 00 00 	mov    %ax,0x108(%ecx)
}
struct proc* peekMlfq(struct Mlfq* q)
{

    struct proc* ret;
    ret = q->queue[(q->front+1) % MAX_QUEUE_SIZE];
8010881b:	8d 42 01             	lea    0x1(%edx),%eax
8010881e:	83 c2 02             	add    $0x2,%edx
80108821:	83 e0 3f             	and    $0x3f,%eax
80108824:	8b 04 81             	mov    (%ecx,%eax,4),%eax
    int i=0;
    struct proc* p;

    q->rCount = q->count;
    //check q, how many procs are SLEEPING
    for(p = peekMlfq(q);(int)p; p = idxPeekMlfq(q,i)){
80108827:	85 c0                	test   %eax,%eax
80108829:	74 27                	je     80108852 <checkRcount+0x52>
8010882b:	90                   	nop
8010882c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(p->state != RUNNING && p->state != RUNNABLE){
80108830:	8b 40 0c             	mov    0xc(%eax),%eax
80108833:	83 e8 03             	sub    $0x3,%eax
80108836:	83 f8 01             	cmp    $0x1,%eax
80108839:	76 08                	jbe    80108843 <checkRcount+0x43>
            q->rCount--;
8010883b:	66 83 a9 08 01 00 00 	subw   $0x1,0x108(%ecx)
80108842:	01 

struct proc* idxPeekMlfq(struct Mlfq* q, int index)
{

    struct proc* ret;
    ret = q->queue[(q->front+1+index) % MAX_QUEUE_SIZE];
80108843:	89 d0                	mov    %edx,%eax
80108845:	83 c2 01             	add    $0x1,%edx
80108848:	83 e0 3f             	and    $0x3f,%eax
8010884b:	8b 04 81             	mov    (%ecx,%eax,4),%eax
    int i=0;
    struct proc* p;

    q->rCount = q->count;
    //check q, how many procs are SLEEPING
    for(p = peekMlfq(q);(int)p; p = idxPeekMlfq(q,i)){
8010884e:	85 c0                	test   %eax,%eax
80108850:	75 de                	jne    80108830 <checkRcount+0x30>
        if(p->state != RUNNING && p->state != RUNNABLE){
            q->rCount--;
        }
        i++;
    }
}
80108852:	5d                   	pop    %ebp
80108853:	c3                   	ret    
80108854:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010885a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80108860 <dequeue>:
    return 0;
}


struct proc* dequeue(struct Mlfq* q, struct proc* p)
{
80108860:	55                   	push   %ebp
80108861:	89 e5                	mov    %esp,%ebp
80108863:	56                   	push   %esi
80108864:	53                   	push   %ebx
80108865:	83 ec 10             	sub    $0x10,%esp
80108868:	8b 5d 08             	mov    0x8(%ebp),%ebx

}

int is_empty(struct Mlfq* q)
{
    if(q->front == q->rear && q->count == 0 ){
8010886b:	0f b7 83 04 01 00 00 	movzwl 0x104(%ebx),%eax
80108872:	66 39 83 02 01 00 00 	cmp    %ax,0x102(%ebx)
80108879:	0f 84 a1 00 00 00    	je     80108920 <dequeue+0xc0>
{
    struct proc* ret;

    if(is_empty(q)) return 0;
    // checks if q is full of SLEEPING of empty
    checkRcount(q);
8010887f:	89 1c 24             	mov    %ebx,(%esp)
80108882:	e8 79 ff ff ff       	call   80108800 <checkRcount>
    if(q->rCount == 0) return 0;
80108887:	66 83 bb 08 01 00 00 	cmpw   $0x0,0x108(%ebx)
8010888e:	00 
8010888f:	0f 84 ab 00 00 00    	je     80108940 <dequeue+0xe0>

    q->front = (q->front + 1)% MAX_QUEUE_SIZE;
80108895:	0f b7 83 02 01 00 00 	movzwl 0x102(%ebx),%eax
8010889c:	83 c0 01             	add    $0x1,%eax
8010889f:	83 e0 3f             	and    $0x3f,%eax
801088a2:	66 89 83 02 01 00 00 	mov    %ax,0x102(%ebx)
801088a9:	8d 04 83             	lea    (%ebx,%eax,4),%eax
    ret = q->queue[q->front];
801088ac:	8b 30                	mov    (%eax),%esi
    q->count--;
801088ae:	66 83 ab 06 01 00 00 	subw   $0x1,0x106(%ebx)
801088b5:	01 
    return ret;
}

    //Erase the pointer that pointing front of q
void deleteProcPointerOfQ(struct proc** p){
    if(*p) *p=0;
801088b6:	85 f6                	test   %esi,%esi
801088b8:	74 06                	je     801088c0 <dequeue+0x60>
801088ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    //Erase the pointer that pointing front of q
    deleteProcPointerOfQ(&q->queue[q->front]);
    //cprintf("dequeue %d/ %d \n",ret->pid,ret->tid);
    //printMLFQAll();

    if(schedulerMode == 1){
801088c0:	83 3d f0 1f 11 80 01 	cmpl   $0x1,0x80111ff0
    // checks if q is full of SLEEPING of empty
    checkRcount(q);
    if(q->rCount == 0) return 0;

    q->front = (q->front + 1)% MAX_QUEUE_SIZE;
    ret = q->queue[q->front];
801088c7:	89 f0                	mov    %esi,%eax
    //Erase the pointer that pointing front of q
    deleteProcPointerOfQ(&q->queue[q->front]);
    //cprintf("dequeue %d/ %d \n",ret->pid,ret->tid);
    //printMLFQAll();

    if(schedulerMode == 1){
801088c9:	74 0d                	je     801088d8 <dequeue+0x78>
            dequeue(q,p);
        }
    }

    return ret;
}
801088cb:	83 c4 10             	add    $0x10,%esp
801088ce:	5b                   	pop    %ebx
801088cf:	5e                   	pop    %esi
801088d0:	5d                   	pop    %ebp
801088d1:	c3                   	ret    
801088d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    deleteProcPointerOfQ(&q->queue[q->front]);
    //cprintf("dequeue %d/ %d \n",ret->pid,ret->tid);
    //printMLFQAll();

    if(schedulerMode == 1){
        if(ret->pid != p->pid || ret->tid != p->tid){
801088d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801088db:	8b 40 10             	mov    0x10(%eax),%eax
801088de:	39 46 10             	cmp    %eax,0x10(%esi)
801088e1:	75 13                	jne    801088f6 <dequeue+0x96>
801088e3:	8b 55 0c             	mov    0xc(%ebp),%edx
801088e6:	89 f0                	mov    %esi,%eax
801088e8:	8b 8a 98 00 00 00    	mov    0x98(%edx),%ecx
801088ee:	39 8e 98 00 00 00    	cmp    %ecx,0x98(%esi)
801088f4:	74 d5                	je     801088cb <dequeue+0x6b>
            enqueue(q,ret);     //move SLEEPING process to rear
801088f6:	89 74 24 04          	mov    %esi,0x4(%esp)
801088fa:	89 1c 24             	mov    %ebx,(%esp)
801088fd:	e8 be fd ff ff       	call   801086c0 <enqueue>
            dequeue(q,p);
80108902:	8b 45 0c             	mov    0xc(%ebp),%eax
80108905:	89 1c 24             	mov    %ebx,(%esp)
80108908:	89 44 24 04          	mov    %eax,0x4(%esp)
8010890c:	e8 4f ff ff ff       	call   80108860 <dequeue>
        }
    }

    return ret;
}
80108911:	83 c4 10             	add    $0x10,%esp
    //printMLFQAll();

    if(schedulerMode == 1){
        if(ret->pid != p->pid || ret->tid != p->tid){
            enqueue(q,ret);     //move SLEEPING process to rear
            dequeue(q,p);
80108914:	89 f0                	mov    %esi,%eax
        }
    }

    return ret;
}
80108916:	5b                   	pop    %ebx
80108917:	5e                   	pop    %esi
80108918:	5d                   	pop    %ebp
80108919:	c3                   	ret    
8010891a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

}

int is_empty(struct Mlfq* q)
{
    if(q->front == q->rear && q->count == 0 ){
80108920:	66 83 bb 06 01 00 00 	cmpw   $0x0,0x106(%ebx)
80108927:	00 
80108928:	0f 85 51 ff ff ff    	jne    8010887f <dequeue+0x1f>
        cprintf("Queue is empty\n");
8010892e:	c7 04 24 50 9b 10 80 	movl   $0x80109b50,(%esp)
80108935:	e8 16 7d ff ff       	call   80100650 <cprintf>

struct proc* dequeue(struct Mlfq* q, struct proc* p)
{
    struct proc* ret;

    if(is_empty(q)) return 0;
8010893a:	31 c0                	xor    %eax,%eax
8010893c:	eb 8d                	jmp    801088cb <dequeue+0x6b>
8010893e:	66 90                	xchg   %ax,%ax
    // checks if q is full of SLEEPING of empty
    checkRcount(q);
    if(q->rCount == 0) return 0;
80108940:	31 c0                	xor    %eax,%eax
80108942:	eb 87                	jmp    801088cb <dequeue+0x6b>
80108944:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010894a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80108950 <printMlfq>:
        }
        i++;
    }
}
void printMlfq(void)
{
80108950:	55                   	push   %ebp
80108951:	89 e5                	mov    %esp,%ebp
80108953:	53                   	push   %ebx
80108954:	83 ec 14             	sub    $0x14,%esp
    int j=0;

    checkRcount(&qOfM[0]);
80108957:	c7 04 24 00 20 11 80 	movl   $0x80112000,(%esp)
8010895e:	e8 9d fe ff ff       	call   80108800 <checkRcount>
    checkRcount(&qOfM[1]);
80108963:	c7 04 24 10 21 11 80 	movl   $0x80112110,(%esp)
8010896a:	e8 91 fe ff ff       	call   80108800 <checkRcount>
    checkRcount(&qOfM[2]);
8010896f:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80108976:	e8 85 fe ff ff       	call   80108800 <checkRcount>
    cprintf("\n curQ : %d -----------------------------------------\n",curQ);
8010897b:	a1 e0 1f 11 80       	mov    0x80111fe0,%eax
80108980:	c7 04 24 1c 9c 10 80 	movl   $0x80109c1c,(%esp)
80108987:	89 44 24 04          	mov    %eax,0x4(%esp)
8010898b:	e8 c0 7c ff ff       	call   80100650 <cprintf>
    cprintf("\n ticks : %d -----------------------------------------\n",ticks);
80108990:	a1 a0 80 11 80       	mov    0x801180a0,%eax
80108995:	c7 04 24 54 9c 10 80 	movl   $0x80109c54,(%esp)
8010899c:	89 44 24 04          	mov    %eax,0x4(%esp)
801089a0:	e8 ab 7c ff ff       	call   80100650 <cprintf>
    cprintf(" Q0 -----------------------------------------\n");
801089a5:	c7 04 24 8c 9c 10 80 	movl   $0x80109c8c,(%esp)
801089ac:	e8 9f 7c ff ff       	call   80100650 <cprintf>
    cprintf("                   count : %d\n",qOfM[0].count);
801089b1:	0f b7 05 06 21 11 80 	movzwl 0x80112106,%eax
801089b8:	c7 04 24 bc 9c 10 80 	movl   $0x80109cbc,(%esp)
801089bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801089c3:	e8 88 7c ff ff       	call   80100650 <cprintf>
    cprintf("                   rCount: %d\n",qOfM[0].rCount);
801089c8:	0f bf 05 08 21 11 80 	movswl 0x80112108,%eax
801089cf:	c7 04 24 dc 9c 10 80 	movl   $0x80109cdc,(%esp)
801089d6:	89 44 24 04          	mov    %eax,0x4(%esp)
801089da:	e8 71 7c ff ff       	call   80100650 <cprintf>
    cprintf("                   front : %d\n",qOfM[0].front);
801089df:	0f b7 05 02 21 11 80 	movzwl 0x80112102,%eax
801089e6:	c7 04 24 fc 9c 10 80 	movl   $0x80109cfc,(%esp)
801089ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801089f1:	e8 5a 7c ff ff       	call   80100650 <cprintf>
    cprintf("                   rear: %d\n",qOfM[0].rear);
801089f6:	0f b7 05 04 21 11 80 	movzwl 0x80112104,%eax
801089fd:	c7 04 24 6f 9b 10 80 	movl   $0x80109b6f,(%esp)
80108a04:	89 44 24 04          	mov    %eax,0x4(%esp)
80108a08:	e8 43 7c ff ff       	call   80100650 <cprintf>
    for(j = qOfM[0].front+1; j <= qOfM[0].rear; j++){
80108a0d:	0f b7 1d 02 21 11 80 	movzwl 0x80112102,%ebx
80108a14:	0f b7 05 04 21 11 80 	movzwl 0x80112104,%eax
80108a1b:	83 c3 01             	add    $0x1,%ebx
80108a1e:	39 c3                	cmp    %eax,%ebx
80108a20:	0f 8f 8f 00 00 00    	jg     80108ab5 <printMlfq+0x165>
80108a26:	66 90                	xchg   %ax,%ax
        cprintf("\n                   pid: %d\n",qOfM[0].queue[j]->pid);
80108a28:	8b 04 9d 00 20 11 80 	mov    -0x7feee000(,%ebx,4),%eax
80108a2f:	8b 40 10             	mov    0x10(%eax),%eax
80108a32:	c7 04 24 8c 9b 10 80 	movl   $0x80109b8c,(%esp)
80108a39:	89 44 24 04          	mov    %eax,0x4(%esp)
80108a3d:	e8 0e 7c ff ff       	call   80100650 <cprintf>
        cprintf("                   name : %s\n",qOfM[0].queue[j]->name);
80108a42:	8b 04 9d 00 20 11 80 	mov    -0x7feee000(,%ebx,4),%eax
80108a49:	c7 04 24 a9 9b 10 80 	movl   $0x80109ba9,(%esp)
80108a50:	83 c0 6c             	add    $0x6c,%eax
80108a53:	89 44 24 04          	mov    %eax,0x4(%esp)
80108a57:	e8 f4 7b ff ff       	call   80100650 <cprintf>
        cprintf("                   state: %d\n",qOfM[0].queue[j]->state);
80108a5c:	8b 04 9d 00 20 11 80 	mov    -0x7feee000(,%ebx,4),%eax
80108a63:	8b 40 0c             	mov    0xc(%eax),%eax
80108a66:	c7 04 24 c7 9b 10 80 	movl   $0x80109bc7,(%esp)
80108a6d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108a71:	e8 da 7b ff ff       	call   80100650 <cprintf>
        cprintf("                   cT: %d\n",qOfM[0].queue[j]->consumedTime);
80108a76:	8b 04 9d 00 20 11 80 	mov    -0x7feee000(,%ebx,4),%eax
80108a7d:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80108a83:	c7 04 24 e5 9b 10 80 	movl   $0x80109be5,(%esp)
80108a8a:	89 44 24 04          	mov    %eax,0x4(%esp)
80108a8e:	e8 bd 7b ff ff       	call   80100650 <cprintf>
        cprintf("                   j : %d\n\n",j);
80108a93:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    cprintf(" Q0 -----------------------------------------\n");
    cprintf("                   count : %d\n",qOfM[0].count);
    cprintf("                   rCount: %d\n",qOfM[0].rCount);
    cprintf("                   front : %d\n",qOfM[0].front);
    cprintf("                   rear: %d\n",qOfM[0].rear);
    for(j = qOfM[0].front+1; j <= qOfM[0].rear; j++){
80108a97:	83 c3 01             	add    $0x1,%ebx
        cprintf("\n                   pid: %d\n",qOfM[0].queue[j]->pid);
        cprintf("                   name : %s\n",qOfM[0].queue[j]->name);
        cprintf("                   state: %d\n",qOfM[0].queue[j]->state);
        cprintf("                   cT: %d\n",qOfM[0].queue[j]->consumedTime);
        cprintf("                   j : %d\n\n",j);
80108a9a:	c7 04 24 00 9c 10 80 	movl   $0x80109c00,(%esp)
80108aa1:	e8 aa 7b ff ff       	call   80100650 <cprintf>
    cprintf(" Q0 -----------------------------------------\n");
    cprintf("                   count : %d\n",qOfM[0].count);
    cprintf("                   rCount: %d\n",qOfM[0].rCount);
    cprintf("                   front : %d\n",qOfM[0].front);
    cprintf("                   rear: %d\n",qOfM[0].rear);
    for(j = qOfM[0].front+1; j <= qOfM[0].rear; j++){
80108aa6:	0f b7 05 04 21 11 80 	movzwl 0x80112104,%eax
80108aad:	39 d8                	cmp    %ebx,%eax
80108aaf:	0f 8d 73 ff ff ff    	jge    80108a28 <printMlfq+0xd8>
        cprintf("                   name : %s\n",qOfM[0].queue[j]->name);
        cprintf("                   state: %d\n",qOfM[0].queue[j]->state);
        cprintf("                   cT: %d\n",qOfM[0].queue[j]->consumedTime);
        cprintf("                   j : %d\n\n",j);
    }
    cprintf(" Q1 -----------------------------------------\n");
80108ab5:	c7 04 24 1c 9d 10 80 	movl   $0x80109d1c,(%esp)
80108abc:	e8 8f 7b ff ff       	call   80100650 <cprintf>
    cprintf("                   count : %d\n",qOfM[1].count);
80108ac1:	0f b7 05 16 22 11 80 	movzwl 0x80112216,%eax
80108ac8:	c7 04 24 bc 9c 10 80 	movl   $0x80109cbc,(%esp)
80108acf:	89 44 24 04          	mov    %eax,0x4(%esp)
80108ad3:	e8 78 7b ff ff       	call   80100650 <cprintf>
    cprintf("                   rCount: %d\n",qOfM[1].rCount);
80108ad8:	0f bf 05 18 22 11 80 	movswl 0x80112218,%eax
80108adf:	c7 04 24 dc 9c 10 80 	movl   $0x80109cdc,(%esp)
80108ae6:	89 44 24 04          	mov    %eax,0x4(%esp)
80108aea:	e8 61 7b ff ff       	call   80100650 <cprintf>
    cprintf("                   front : %d\n",qOfM[1].front);
80108aef:	0f b7 05 12 22 11 80 	movzwl 0x80112212,%eax
80108af6:	c7 04 24 fc 9c 10 80 	movl   $0x80109cfc,(%esp)
80108afd:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b01:	e8 4a 7b ff ff       	call   80100650 <cprintf>
    cprintf("                   rear: %d\n",qOfM[1].rear);
80108b06:	0f b7 05 14 22 11 80 	movzwl 0x80112214,%eax
80108b0d:	c7 04 24 6f 9b 10 80 	movl   $0x80109b6f,(%esp)
80108b14:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b18:	e8 33 7b ff ff       	call   80100650 <cprintf>
    for(j = qOfM[1].front+1; j <= qOfM[1].rear; j++){
80108b1d:	0f b7 1d 12 22 11 80 	movzwl 0x80112212,%ebx
80108b24:	0f b7 05 14 22 11 80 	movzwl 0x80112214,%eax
80108b2b:	83 c3 01             	add    $0x1,%ebx
80108b2e:	39 c3                	cmp    %eax,%ebx
80108b30:	0f 8f 8f 00 00 00    	jg     80108bc5 <printMlfq+0x275>
80108b36:	66 90                	xchg   %ax,%ax
        cprintf("\n                   pid: %d\n",qOfM[1].queue[j]->pid);
80108b38:	8b 04 9d 10 21 11 80 	mov    -0x7feedef0(,%ebx,4),%eax
80108b3f:	8b 40 10             	mov    0x10(%eax),%eax
80108b42:	c7 04 24 8c 9b 10 80 	movl   $0x80109b8c,(%esp)
80108b49:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b4d:	e8 fe 7a ff ff       	call   80100650 <cprintf>
        cprintf("                   name : %s\n",qOfM[1].queue[j]->name);
80108b52:	8b 04 9d 10 21 11 80 	mov    -0x7feedef0(,%ebx,4),%eax
80108b59:	c7 04 24 a9 9b 10 80 	movl   $0x80109ba9,(%esp)
80108b60:	83 c0 6c             	add    $0x6c,%eax
80108b63:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b67:	e8 e4 7a ff ff       	call   80100650 <cprintf>
        cprintf("                   state: %d\n",qOfM[1].queue[j]->state);
80108b6c:	8b 04 9d 10 21 11 80 	mov    -0x7feedef0(,%ebx,4),%eax
80108b73:	8b 40 0c             	mov    0xc(%eax),%eax
80108b76:	c7 04 24 c7 9b 10 80 	movl   $0x80109bc7,(%esp)
80108b7d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b81:	e8 ca 7a ff ff       	call   80100650 <cprintf>
        cprintf("                   cT: %d\n",qOfM[1].queue[j]->consumedTime);
80108b86:	8b 04 9d 10 21 11 80 	mov    -0x7feedef0(,%ebx,4),%eax
80108b8d:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80108b93:	c7 04 24 e5 9b 10 80 	movl   $0x80109be5,(%esp)
80108b9a:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b9e:	e8 ad 7a ff ff       	call   80100650 <cprintf>
        cprintf("                   j : %d\n\n",j);
80108ba3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    cprintf(" Q1 -----------------------------------------\n");
    cprintf("                   count : %d\n",qOfM[1].count);
    cprintf("                   rCount: %d\n",qOfM[1].rCount);
    cprintf("                   front : %d\n",qOfM[1].front);
    cprintf("                   rear: %d\n",qOfM[1].rear);
    for(j = qOfM[1].front+1; j <= qOfM[1].rear; j++){
80108ba7:	83 c3 01             	add    $0x1,%ebx
        cprintf("\n                   pid: %d\n",qOfM[1].queue[j]->pid);
        cprintf("                   name : %s\n",qOfM[1].queue[j]->name);
        cprintf("                   state: %d\n",qOfM[1].queue[j]->state);
        cprintf("                   cT: %d\n",qOfM[1].queue[j]->consumedTime);
        cprintf("                   j : %d\n\n",j);
80108baa:	c7 04 24 00 9c 10 80 	movl   $0x80109c00,(%esp)
80108bb1:	e8 9a 7a ff ff       	call   80100650 <cprintf>
    cprintf(" Q1 -----------------------------------------\n");
    cprintf("                   count : %d\n",qOfM[1].count);
    cprintf("                   rCount: %d\n",qOfM[1].rCount);
    cprintf("                   front : %d\n",qOfM[1].front);
    cprintf("                   rear: %d\n",qOfM[1].rear);
    for(j = qOfM[1].front+1; j <= qOfM[1].rear; j++){
80108bb6:	0f b7 05 14 22 11 80 	movzwl 0x80112214,%eax
80108bbd:	39 d8                	cmp    %ebx,%eax
80108bbf:	0f 8d 73 ff ff ff    	jge    80108b38 <printMlfq+0x1e8>
        cprintf("                   state: %d\n",qOfM[1].queue[j]->state);
        cprintf("                   cT: %d\n",qOfM[1].queue[j]->consumedTime);
        cprintf("                   j : %d\n\n",j);
    }

    cprintf(" Q2 -----------------------------------------\n");
80108bc5:	c7 04 24 4c 9d 10 80 	movl   $0x80109d4c,(%esp)
80108bcc:	e8 7f 7a ff ff       	call   80100650 <cprintf>
    cprintf("                   count : %d\n",qOfM[2].count);
80108bd1:	0f b7 05 26 23 11 80 	movzwl 0x80112326,%eax
80108bd8:	c7 04 24 bc 9c 10 80 	movl   $0x80109cbc,(%esp)
80108bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
80108be3:	e8 68 7a ff ff       	call   80100650 <cprintf>
    cprintf("                   rCount: %d\n",qOfM[2].rCount);
80108be8:	0f bf 05 28 23 11 80 	movswl 0x80112328,%eax
80108bef:	c7 04 24 dc 9c 10 80 	movl   $0x80109cdc,(%esp)
80108bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
80108bfa:	e8 51 7a ff ff       	call   80100650 <cprintf>
    cprintf("                   front : %d\n",qOfM[2].front);
80108bff:	0f b7 05 22 23 11 80 	movzwl 0x80112322,%eax
80108c06:	c7 04 24 fc 9c 10 80 	movl   $0x80109cfc,(%esp)
80108c0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108c11:	e8 3a 7a ff ff       	call   80100650 <cprintf>
    cprintf("                   rear: %d\n",qOfM[2].rear);
80108c16:	0f b7 05 24 23 11 80 	movzwl 0x80112324,%eax
80108c1d:	c7 04 24 6f 9b 10 80 	movl   $0x80109b6f,(%esp)
80108c24:	89 44 24 04          	mov    %eax,0x4(%esp)
80108c28:	e8 23 7a ff ff       	call   80100650 <cprintf>
    for(j = qOfM[2].front+1; j <= qOfM[2].rear; j++){
80108c2d:	0f b7 1d 22 23 11 80 	movzwl 0x80112322,%ebx
80108c34:	0f b7 05 24 23 11 80 	movzwl 0x80112324,%eax
80108c3b:	83 c3 01             	add    $0x1,%ebx
80108c3e:	39 c3                	cmp    %eax,%ebx
80108c40:	0f 8f 8f 00 00 00    	jg     80108cd5 <printMlfq+0x385>
80108c46:	66 90                	xchg   %ax,%ax
        cprintf("\n                   pid: %d\n",qOfM[2].queue[j]->pid);
80108c48:	8b 04 9d 20 22 11 80 	mov    -0x7feedde0(,%ebx,4),%eax
80108c4f:	8b 40 10             	mov    0x10(%eax),%eax
80108c52:	c7 04 24 8c 9b 10 80 	movl   $0x80109b8c,(%esp)
80108c59:	89 44 24 04          	mov    %eax,0x4(%esp)
80108c5d:	e8 ee 79 ff ff       	call   80100650 <cprintf>
        cprintf("                   name : %s\n",qOfM[2].queue[j]->name);
80108c62:	8b 04 9d 20 22 11 80 	mov    -0x7feedde0(,%ebx,4),%eax
80108c69:	c7 04 24 a9 9b 10 80 	movl   $0x80109ba9,(%esp)
80108c70:	83 c0 6c             	add    $0x6c,%eax
80108c73:	89 44 24 04          	mov    %eax,0x4(%esp)
80108c77:	e8 d4 79 ff ff       	call   80100650 <cprintf>
        cprintf("                   state: %d\n",qOfM[2].queue[j]->state);
80108c7c:	8b 04 9d 20 22 11 80 	mov    -0x7feedde0(,%ebx,4),%eax
80108c83:	8b 40 0c             	mov    0xc(%eax),%eax
80108c86:	c7 04 24 c7 9b 10 80 	movl   $0x80109bc7,(%esp)
80108c8d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108c91:	e8 ba 79 ff ff       	call   80100650 <cprintf>
        cprintf("                   cT: %d\n",qOfM[2].queue[j]->consumedTime);
80108c96:	8b 04 9d 20 22 11 80 	mov    -0x7feedde0(,%ebx,4),%eax
80108c9d:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80108ca3:	c7 04 24 e5 9b 10 80 	movl   $0x80109be5,(%esp)
80108caa:	89 44 24 04          	mov    %eax,0x4(%esp)
80108cae:	e8 9d 79 ff ff       	call   80100650 <cprintf>
        cprintf("                   j : %d\n\n",j);
80108cb3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    cprintf(" Q2 -----------------------------------------\n");
    cprintf("                   count : %d\n",qOfM[2].count);
    cprintf("                   rCount: %d\n",qOfM[2].rCount);
    cprintf("                   front : %d\n",qOfM[2].front);
    cprintf("                   rear: %d\n",qOfM[2].rear);
    for(j = qOfM[2].front+1; j <= qOfM[2].rear; j++){
80108cb7:	83 c3 01             	add    $0x1,%ebx
        cprintf("\n                   pid: %d\n",qOfM[2].queue[j]->pid);
        cprintf("                   name : %s\n",qOfM[2].queue[j]->name);
        cprintf("                   state: %d\n",qOfM[2].queue[j]->state);
        cprintf("                   cT: %d\n",qOfM[2].queue[j]->consumedTime);
        cprintf("                   j : %d\n\n",j);
80108cba:	c7 04 24 00 9c 10 80 	movl   $0x80109c00,(%esp)
80108cc1:	e8 8a 79 ff ff       	call   80100650 <cprintf>
    cprintf(" Q2 -----------------------------------------\n");
    cprintf("                   count : %d\n",qOfM[2].count);
    cprintf("                   rCount: %d\n",qOfM[2].rCount);
    cprintf("                   front : %d\n",qOfM[2].front);
    cprintf("                   rear: %d\n",qOfM[2].rear);
    for(j = qOfM[2].front+1; j <= qOfM[2].rear; j++){
80108cc6:	0f b7 05 24 23 11 80 	movzwl 0x80112324,%eax
80108ccd:	39 d8                	cmp    %ebx,%eax
80108ccf:	0f 8d 73 ff ff ff    	jge    80108c48 <printMlfq+0x2f8>
        cprintf("                   name : %s\n",qOfM[2].queue[j]->name);
        cprintf("                   state: %d\n",qOfM[2].queue[j]->state);
        cprintf("                   cT: %d\n",qOfM[2].queue[j]->consumedTime);
        cprintf("                   j : %d\n\n",j);
    }
    cprintf(" End -----------------------------------------\n");
80108cd5:	c7 04 24 7c 9d 10 80 	movl   $0x80109d7c,(%esp)
80108cdc:	e8 6f 79 ff ff       	call   80100650 <cprintf>
}
80108ce1:	83 c4 14             	add    $0x14,%esp
80108ce4:	5b                   	pop    %ebx
80108ce5:	5d                   	pop    %ebp
80108ce6:	c3                   	ret    
80108ce7:	89 f6                	mov    %esi,%esi
80108ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108cf0 <boostMlfq>:
void boostMlfq(void)
{
80108cf0:	55                   	push   %ebp
80108cf1:	89 e5                	mov    %esp,%ebp
80108cf3:	57                   	push   %edi
80108cf4:	56                   	push   %esi
80108cf5:	53                   	push   %ebx
80108cf6:	bb 10 21 11 80       	mov    $0x80112110,%ebx
80108cfb:	83 ec 1c             	sub    $0x1c,%esp
    int i = 0, j = 1, h=0;
    int qCount;
    struct proc* p;

    while(j<MAX_QUEUE_NUM){
        qCount = qOfM[j].count;
80108cfe:	0f b7 83 06 01 00 00 	movzwl 0x106(%ebx),%eax
80108d05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
struct proc* peekMlfq(struct Mlfq* q)
{

    struct proc* ret;
    ret = q->queue[(q->front+1) % MAX_QUEUE_SIZE];
80108d08:	0f b7 93 02 01 00 00 	movzwl 0x102(%ebx),%edx
80108d0f:	8d 42 01             	lea    0x1(%edx),%eax
80108d12:	83 e0 3f             	and    $0x3f,%eax
80108d15:	8b 3c 83             	mov    (%ebx,%eax,4),%edi
    int qCount;
    struct proc* p;

    while(j<MAX_QUEUE_NUM){
        qCount = qOfM[j].count;
        for(p = peekMlfq(&qOfM[j]);(int)p; p = idxPeekMlfq(&qOfM[j],i)){
80108d18:	85 ff                	test   %edi,%edi
80108d1a:	74 44                	je     80108d60 <boostMlfq+0x70>
            h = 0;
            if(qCount == 0) break;
80108d1c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80108d1f:	85 c9                	test   %ecx,%ecx
80108d21:	74 3d                	je     80108d60 <boostMlfq+0x70>
            if(p && p->state != UNUSED){
80108d23:	8b 47 0c             	mov    0xc(%edi),%eax
80108d26:	85 c0                	test   %eax,%eax
80108d28:	74 e5                	je     80108d0f <boostMlfq+0x1f>
                normalDequeue(&qOfM[j]);
80108d2a:	89 1c 24             	mov    %ebx,(%esp)
                qCount--;
                while(enqueue(&qOfM[h],p) == -1 && h < MAX_QUEUE_NUM){
80108d2d:	be 00 20 11 80       	mov    $0x80112000,%esi
        qCount = qOfM[j].count;
        for(p = peekMlfq(&qOfM[j]);(int)p; p = idxPeekMlfq(&qOfM[j],i)){
            h = 0;
            if(qCount == 0) break;
            if(p && p->state != UNUSED){
                normalDequeue(&qOfM[j]);
80108d32:	e8 e9 f9 ff ff       	call   80108720 <normalDequeue>
                qCount--;
80108d37:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
                while(enqueue(&qOfM[h],p) == -1 && h < MAX_QUEUE_NUM){
80108d3b:	89 7c 24 04          	mov    %edi,0x4(%esp)
80108d3f:	89 34 24             	mov    %esi,(%esp)
80108d42:	e8 79 f9 ff ff       	call   801086c0 <enqueue>
80108d47:	83 f8 ff             	cmp    $0xffffffff,%eax
80108d4a:	75 bc                	jne    80108d08 <boostMlfq+0x18>
80108d4c:	81 c6 10 01 00 00    	add    $0x110,%esi
80108d52:	81 fe 40 24 11 80    	cmp    $0x80112440,%esi
80108d58:	75 e1                	jne    80108d3b <boostMlfq+0x4b>
80108d5a:	eb ac                	jmp    80108d08 <boostMlfq+0x18>
80108d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108d60:	81 c3 10 01 00 00    	add    $0x110,%ebx
{
    int i = 0, j = 1, h=0;
    int qCount;
    struct proc* p;

    while(j<MAX_QUEUE_NUM){
80108d66:	81 fb 30 23 11 80    	cmp    $0x80112330,%ebx
80108d6c:	75 90                	jne    80108cfe <boostMlfq+0xe>
            //i++;
        }
        i=0;
        j++;
    }
}
80108d6e:	83 c4 1c             	add    $0x1c,%esp
80108d71:	5b                   	pop    %ebx
80108d72:	5e                   	pop    %esi
80108d73:	5f                   	pop    %edi
80108d74:	5d                   	pop    %ebp
80108d75:	c3                   	ret    
80108d76:	8d 76 00             	lea    0x0(%esi),%esi
80108d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108d80 <printMLFQAll>:


void printMLFQAll(){
80108d80:	55                   	push   %ebp
80108d81:	89 e5                	mov    %esp,%ebp
80108d83:	57                   	push   %edi
80108d84:	56                   	push   %esi
    int i=0, j=0;
    cprintf("\n----------------------------------------------------------------------------------------\n");
    for(i=0;i<MAX_QUEUE_NUM;i++){
80108d85:	31 f6                	xor    %esi,%esi
        j++;
    }
}


void printMLFQAll(){
80108d87:	53                   	push   %ebx
    int i=0, j=0;
    cprintf("\n----------------------------------------------------------------------------------------\n");
80108d88:	31 db                	xor    %ebx,%ebx
        j++;
    }
}


void printMLFQAll(){
80108d8a:	83 ec 3c             	sub    $0x3c,%esp
    int i=0, j=0;
    cprintf("\n----------------------------------------------------------------------------------------\n");
80108d8d:	c7 04 24 ac 9d 10 80 	movl   $0x80109dac,(%esp)
80108d94:	e8 b7 78 ff ff       	call   80100650 <cprintf>
    for(i=0;i<MAX_QUEUE_NUM;i++){
        cprintf("\nQ%d-------------------------------------\n",i);
80108d99:	89 74 24 04          	mov    %esi,0x4(%esp)
        for(j=0;j<MAX_QUEUE_SIZE;j++){
80108d9d:	31 ff                	xor    %edi,%edi

void printMLFQAll(){
    int i=0, j=0;
    cprintf("\n----------------------------------------------------------------------------------------\n");
    for(i=0;i<MAX_QUEUE_NUM;i++){
        cprintf("\nQ%d-------------------------------------\n",i);
80108d9f:	c7 04 24 08 9e 10 80 	movl   $0x80109e08,(%esp)
80108da6:	e8 a5 78 ff ff       	call   80100650 <cprintf>
80108dab:	90                   	nop
80108dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        for(j=0;j<MAX_QUEUE_SIZE;j++){
            if(qOfM[i].queue[j])
80108db0:	8b 84 bb 00 20 11 80 	mov    -0x7feee000(%ebx,%edi,4),%eax
80108db7:	85 c0                	test   %eax,%eax
80108db9:	74 4d                	je     80108e08 <printMLFQAll+0x88>
                cprintf(" pid %d tid %d/name %s /  state %d / cT %d / pass %d/ stride %d/ sz %d\n",\
80108dbb:	8b 10                	mov    (%eax),%edx
80108dbd:	89 54 24 20          	mov    %edx,0x20(%esp)
80108dc1:	0f b7 50 7e          	movzwl 0x7e(%eax),%edx
80108dc5:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80108dc9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80108dcf:	89 54 24 18          	mov    %edx,0x18(%esp)
80108dd3:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80108dd9:	89 54 24 14          	mov    %edx,0x14(%esp)
80108ddd:	8b 50 0c             	mov    0xc(%eax),%edx
80108de0:	89 54 24 10          	mov    %edx,0x10(%esp)
                        qOfM[i].queue[j]->pid,qOfM[i].queue[j]->tid,qOfM[i].queue[j]->name,qOfM[i].queue[j]->state,qOfM[i].queue[j]->consumedTime, qOfM[i].queue[j]->pass, qOfM[i].queue[j]->stride,qOfM[i].queue[j]->sz);
80108de4:	8d 50 6c             	lea    0x6c(%eax),%edx
80108de7:	89 54 24 0c          	mov    %edx,0xc(%esp)
    cprintf("\n----------------------------------------------------------------------------------------\n");
    for(i=0;i<MAX_QUEUE_NUM;i++){
        cprintf("\nQ%d-------------------------------------\n",i);
        for(j=0;j<MAX_QUEUE_SIZE;j++){
            if(qOfM[i].queue[j])
                cprintf(" pid %d tid %d/name %s /  state %d / cT %d / pass %d/ stride %d/ sz %d\n",\
80108deb:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80108df1:	89 54 24 08          	mov    %edx,0x8(%esp)
80108df5:	8b 40 10             	mov    0x10(%eax),%eax
80108df8:	c7 04 24 34 9e 10 80 	movl   $0x80109e34,(%esp)
80108dff:	89 44 24 04          	mov    %eax,0x4(%esp)
80108e03:	e8 48 78 ff ff       	call   80100650 <cprintf>
void printMLFQAll(){
    int i=0, j=0;
    cprintf("\n----------------------------------------------------------------------------------------\n");
    for(i=0;i<MAX_QUEUE_NUM;i++){
        cprintf("\nQ%d-------------------------------------\n",i);
        for(j=0;j<MAX_QUEUE_SIZE;j++){
80108e08:	83 c7 01             	add    $0x1,%edi
80108e0b:	83 ff 40             	cmp    $0x40,%edi
80108e0e:	75 a0                	jne    80108db0 <printMLFQAll+0x30>


void printMLFQAll(){
    int i=0, j=0;
    cprintf("\n----------------------------------------------------------------------------------------\n");
    for(i=0;i<MAX_QUEUE_NUM;i++){
80108e10:	83 c6 01             	add    $0x1,%esi
80108e13:	81 c3 10 01 00 00    	add    $0x110,%ebx
80108e19:	83 fe 03             	cmp    $0x3,%esi
80108e1c:	0f 85 77 ff ff ff    	jne    80108d99 <printMLFQAll+0x19>
                        qOfM[i].queue[j]->pid,qOfM[i].queue[j]->tid,qOfM[i].queue[j]->name,qOfM[i].queue[j]->state,qOfM[i].queue[j]->consumedTime, qOfM[i].queue[j]->pass, qOfM[i].queue[j]->stride,qOfM[i].queue[j]->sz);

        }
    }

}
80108e22:	83 c4 3c             	add    $0x3c,%esp
80108e25:	5b                   	pop    %ebx
80108e26:	5e                   	pop    %esi
80108e27:	5f                   	pop    %edi
80108e28:	5d                   	pop    %ebp
80108e29:	c3                   	ret    
80108e2a:	66 90                	xchg   %ax,%ax
80108e2c:	66 90                	xchg   %ax,%ax
80108e2e:	66 90                	xchg   %ax,%ax

80108e30 <initStride>:
#include "mlfq.h"
#include "stride.h"

void initStride(void){
    curStridePor = 0;
    curStridePor += MlfqCPUShare;
80108e30:	a1 34 23 11 80       	mov    0x80112334,%eax
#include "x86.h"
#include "proc.h"
#include "mlfq.h"
#include "stride.h"

void initStride(void){
80108e35:	55                   	push   %ebp
80108e36:	89 e5                	mov    %esp,%ebp
    curStridePor = 0;
    curStridePor += MlfqCPUShare;
    minPass = 999999999;
80108e38:	c7 05 00 51 11 80 ff 	movl   $0x3b9ac9ff,0x80115100
80108e3f:	c9 9a 3b 
#include "mlfq.h"
#include "stride.h"

void initStride(void){
    curStridePor = 0;
    curStridePor += MlfqCPUShare;
80108e42:	a3 04 51 11 80       	mov    %eax,0x80115104
    minPass = 999999999;
}
80108e47:	5d                   	pop    %ebp
80108e48:	c3                   	ret    
80108e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108e50 <set_cpu_share>:
unsigned long int set_cpu_share(int share){
80108e50:	55                   	push   %ebp
80108e51:	89 e5                	mov    %esp,%ebp
80108e53:	53                   	push   %ebx
80108e54:	83 ec 14             	sub    $0x14,%esp
80108e57:	8b 4d 08             	mov    0x8(%ebp),%ecx
    ushort stride;

    if(STRIDE_MAXIMUM_PORTION < curStridePor + share){
80108e5a:	8b 15 04 51 11 80    	mov    0x80115104,%edx
80108e60:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
80108e63:	83 f8 64             	cmp    $0x64,%eax
80108e66:	7f 50                	jg     80108eb8 <set_cpu_share+0x68>
        proc->stride = 0;
        stride = 0;
        return -1;
    }

    curStridePor += share;
80108e68:	a3 04 51 11 80       	mov    %eax,0x80115104
    stride = STRIDE_LARGE_NUMBER / share;
80108e6d:	b8 10 27 00 00       	mov    $0x2710,%eax
80108e72:	99                   	cltd   
80108e73:	f7 f9                	idiv   %ecx
    if(proc && proc->pid > 2){
80108e75:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80108e7c:	85 c9                	test   %ecx,%ecx
        stride = 0;
        return -1;
    }

    curStridePor += share;
    stride = STRIDE_LARGE_NUMBER / share;
80108e7e:	89 c3                	mov    %eax,%ebx
    if(proc && proc->pid > 2){
80108e80:	74 76                	je     80108ef8 <set_cpu_share+0xa8>
80108e82:	83 79 10 02          	cmpl   $0x2,0x10(%ecx)
80108e86:	7f 78                	jg     80108f00 <set_cpu_share+0xb0>
        }else{
            proc->pstride = stride;
            share_stride_in_proc(proc);
        }
    }
    dequeue(&qOfM[proc->qPosi],proc);
80108e88:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80108e8c:	0f b7 41 7c          	movzwl 0x7c(%ecx),%eax
80108e90:	69 c0 10 01 00 00    	imul   $0x110,%eax,%eax
80108e96:	05 00 20 11 80       	add    $0x80112000,%eax
80108e9b:	89 04 24             	mov    %eax,(%esp)
80108e9e:	e8 bd f9 ff ff       	call   80108860 <dequeue>
    yield();
80108ea3:	e8 f8 ac ff ff       	call   80103ba0 <yield>

    return stride;

}
80108ea8:	83 c4 14             	add    $0x14,%esp
80108eab:	0f b7 c3             	movzwl %bx,%eax
80108eae:	5b                   	pop    %ebx
80108eaf:	5d                   	pop    %ebp
80108eb0:	c3                   	ret    
80108eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
unsigned long int set_cpu_share(int share){
    ushort stride;

    if(STRIDE_MAXIMUM_PORTION < curStridePor + share){
        cprintf("Ther is no cpu_share for %s / pid %d / curStridePor is %d\n",proc->name,proc->pid, curStridePor);
80108eb8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108ebe:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108ec2:	8b 50 10             	mov    0x10(%eax),%edx
80108ec5:	83 c0 6c             	add    $0x6c,%eax
80108ec8:	89 44 24 04          	mov    %eax,0x4(%esp)
80108ecc:	c7 04 24 7c 9e 10 80 	movl   $0x80109e7c,(%esp)
80108ed3:	89 54 24 08          	mov    %edx,0x8(%esp)
80108ed7:	e8 74 77 ff ff       	call   80100650 <cprintf>
        proc->stride = 0;
80108edc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108ee2:	31 d2                	xor    %edx,%edx
80108ee4:	66 89 50 7e          	mov    %dx,0x7e(%eax)
    dequeue(&qOfM[proc->qPosi],proc);
    yield();

    return stride;

}
80108ee8:	83 c4 14             	add    $0x14,%esp

    if(STRIDE_MAXIMUM_PORTION < curStridePor + share){
        cprintf("Ther is no cpu_share for %s / pid %d / curStridePor is %d\n",proc->name,proc->pid, curStridePor);
        proc->stride = 0;
        stride = 0;
        return -1;
80108eeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    dequeue(&qOfM[proc->qPosi],proc);
    yield();

    return stride;

}
80108ef0:	5b                   	pop    %ebx
80108ef1:	5d                   	pop    %ebp
80108ef2:	c3                   	ret    
80108ef3:	90                   	nop
80108ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108ef8:	31 c9                	xor    %ecx,%ecx
80108efa:	eb 8c                	jmp    80108e88 <set_cpu_share+0x38>
80108efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }

    curStridePor += share;
    stride = STRIDE_LARGE_NUMBER / share;
    if(proc && proc->pid > 2){
        findMinPassStride();
80108f00:	e8 ab b0 ff ff       	call   80103fb0 <findMinPassStride>
        proc->pass = minPass-10;
80108f05:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108f0b:	8b 15 00 51 11 80    	mov    0x80115100,%edx
        proc->stride = stride;
80108f11:	66 89 58 7e          	mov    %bx,0x7e(%eax)

    curStridePor += share;
    stride = STRIDE_LARGE_NUMBER / share;
    if(proc && proc->pid > 2){
        findMinPassStride();
        proc->pass = minPass-10;
80108f15:	83 ea 0a             	sub    $0xa,%edx
        proc->stride = stride;
        if(proc->isthread == 1){
80108f18:	66 83 b8 8c 00 00 00 	cmpw   $0x1,0x8c(%eax)
80108f1f:	01 

    curStridePor += share;
    stride = STRIDE_LARGE_NUMBER / share;
    if(proc && proc->pid > 2){
        findMinPassStride();
        proc->pass = minPass-10;
80108f20:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
        proc->stride = stride;
        if(proc->isthread == 1){
80108f26:	74 20                	je     80108f48 <set_cpu_share+0xf8>
            proc->parent->pstride = stride;
            share_stride_in_proc(proc->parent);
        }else{
            proc->pstride = stride;
80108f28:	66 89 98 80 00 00 00 	mov    %bx,0x80(%eax)
            share_stride_in_proc(proc);
80108f2f:	89 04 24             	mov    %eax,(%esp)
80108f32:	e8 a9 c3 ff ff       	call   801052e0 <share_stride_in_proc>
80108f37:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80108f3e:	e9 45 ff ff ff       	jmp    80108e88 <set_cpu_share+0x38>
80108f43:	90                   	nop
80108f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc && proc->pid > 2){
        findMinPassStride();
        proc->pass = minPass-10;
        proc->stride = stride;
        if(proc->isthread == 1){
            proc->parent->pstride = stride;
80108f48:	8b 50 14             	mov    0x14(%eax),%edx
80108f4b:	66 89 9a 80 00 00 00 	mov    %bx,0x80(%edx)
            share_stride_in_proc(proc->parent);
80108f52:	8b 40 14             	mov    0x14(%eax),%eax
80108f55:	89 04 24             	mov    %eax,(%esp)
80108f58:	e8 83 c3 ff ff       	call   801052e0 <share_stride_in_proc>
80108f5d:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80108f64:	e9 1f ff ff ff       	jmp    80108e88 <set_cpu_share+0x38>
80108f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108f70 <set_Mlfq_cpu_share>:
    yield();

    return stride;

}
unsigned long int set_Mlfq_cpu_share(int share){
80108f70:	55                   	push   %ebp
    ushort stride;

    if(STRIDE_MAXIMUM_PORTION < curStridePor + share) return -1;
80108f71:	8b 15 04 51 11 80    	mov    0x80115104,%edx
80108f77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    yield();

    return stride;

}
unsigned long int set_Mlfq_cpu_share(int share){
80108f7c:	89 e5                	mov    %esp,%ebp
80108f7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    ushort stride;

    if(STRIDE_MAXIMUM_PORTION < curStridePor + share) return -1;
80108f81:	01 ca                	add    %ecx,%edx
80108f83:	83 fa 64             	cmp    $0x64,%edx
80108f86:	7e 08                	jle    80108f90 <set_Mlfq_cpu_share+0x20>
    stride = STRIDE_LARGE_NUMBER / share;
    MlfqProc->stride = stride;

    return stride;

}
80108f88:	5d                   	pop    %ebp
80108f89:	c3                   	ret    
80108f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ushort stride;

    if(STRIDE_MAXIMUM_PORTION < curStridePor + share) return -1;

    curStridePor += share;
    stride = STRIDE_LARGE_NUMBER / share;
80108f90:	b8 10 27 00 00       	mov    $0x2710,%eax
unsigned long int set_Mlfq_cpu_share(int share){
    ushort stride;

    if(STRIDE_MAXIMUM_PORTION < curStridePor + share) return -1;

    curStridePor += share;
80108f95:	89 15 04 51 11 80    	mov    %edx,0x80115104
    stride = STRIDE_LARGE_NUMBER / share;
80108f9b:	99                   	cltd   
80108f9c:	f7 f9                	idiv   %ecx
    MlfqProc->stride = stride;
80108f9e:	8b 15 30 23 11 80    	mov    0x80112330,%edx
    ushort stride;

    if(STRIDE_MAXIMUM_PORTION < curStridePor + share) return -1;

    curStridePor += share;
    stride = STRIDE_LARGE_NUMBER / share;
80108fa4:	66 89 42 7e          	mov    %ax,0x7e(%edx)
80108fa8:	0f b7 c0             	movzwl %ax,%eax
    MlfqProc->stride = stride;

    return stride;

}
80108fab:	5d                   	pop    %ebp
80108fac:	c3                   	ret    
80108fad:	8d 76 00             	lea    0x0(%esi),%esi

80108fb0 <cut_cpu_share>:

void cut_cpu_share(ushort stride){
80108fb0:	55                   	push   %ebp
    int share;
    int tmp;

   if(stride != 0) share = STRIDE_LARGE_NUMBER / stride;
   else share=0;
80108fb1:	31 c0                	xor    %eax,%eax

    return stride;

}

void cut_cpu_share(ushort stride){
80108fb3:	89 e5                	mov    %esp,%ebp
80108fb5:	8b 55 08             	mov    0x8(%ebp),%edx
    int share;
    int tmp;

   if(stride != 0) share = STRIDE_LARGE_NUMBER / stride;
80108fb8:	66 85 d2             	test   %dx,%dx
80108fbb:	74 0a                	je     80108fc7 <cut_cpu_share+0x17>
80108fbd:	66 b8 10 27          	mov    $0x2710,%ax
80108fc1:	0f b7 ca             	movzwl %dx,%ecx
80108fc4:	99                   	cltd   
80108fc5:	f7 f9                	idiv   %ecx
   else share=0;
    tmp = curStridePor - share;
80108fc7:	29 05 04 51 11 80    	sub    %eax,0x80115104
    curStridePor = tmp;

}
80108fcd:	5d                   	pop    %ebp
80108fce:	c3                   	ret    
