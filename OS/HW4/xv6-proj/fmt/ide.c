5200 // Simple PIO-based (non-DMA) IDE driver code.
5201 
5202 #include "types.h"
5203 #include "defs.h"
5204 #include "param.h"
5205 #include "memlayout.h"
5206 #include "mmu.h"
5207 #include "proc.h"
5208 #include "x86.h"
5209 #include "traps.h"
5210 #include "spinlock.h"
5211 #include "sleeplock.h"
5212 #include "fs.h"
5213 #include "buf.h"
5214 
5215 #define SECTOR_SIZE   512
5216 #define IDE_BSY       0x80
5217 #define IDE_DRDY      0x40
5218 #define IDE_DF        0x20
5219 #define IDE_ERR       0x01
5220 
5221 #define IDE_CMD_READ  0x20
5222 #define IDE_CMD_WRITE 0x30
5223 #define IDE_CMD_RDMUL 0xc4
5224 #define IDE_CMD_WRMUL 0xc5
5225 
5226 // idequeue points to the buf now being read/written to the disk.
5227 // idequeue->qnext points to the next buf to be processed.
5228 // You must hold idelock while manipulating queue.
5229 
5230 static struct spinlock idelock;
5231 static struct buf *idequeue;
5232 
5233 static int havedisk1;
5234 static void idestart(struct buf*);
5235 
5236 // Wait for IDE disk to become ready.
5237 static int
5238 idewait(int checkerr)
5239 {
5240   int r;
5241 
5242   while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
5243     ;
5244   if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
5245     return -1;
5246   return 0;
5247 }
5248 
5249 
5250 void
5251 ideinit(void)
5252 {
5253   int i;
5254 
5255   initlock(&idelock, "ide");
5256   picenable(IRQ_IDE);
5257   ioapicenable(IRQ_IDE, ncpu - 1);
5258   idewait(0);
5259 
5260   // Check if disk 1 is present
5261   outb(0x1f6, 0xe0 | (1<<4));
5262   for(i=0; i<1000; i++){
5263     if(inb(0x1f7) != 0){
5264       havedisk1 = 1;
5265       break;
5266     }
5267   }
5268 
5269   // Switch back to disk 0.
5270   outb(0x1f6, 0xe0 | (0<<4));
5271 }
5272 
5273 // Start the request for b.  Caller must hold idelock.
5274 static void
5275 idestart(struct buf *b)
5276 {
5277   if(b == 0)
5278     panic("idestart");
5279   if(b->blockno >= FSSIZE)
5280     panic("incorrect blockno");
5281   int sector_per_block =  BSIZE/SECTOR_SIZE;
5282   int sector = b->blockno * sector_per_block;
5283   int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
5284   int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
5285 
5286   if (sector_per_block > 7) panic("idestart");
5287 
5288   idewait(0);
5289   outb(0x3f6, 0);  // generate interrupt
5290   outb(0x1f2, sector_per_block);  // number of sectors
5291   outb(0x1f3, sector & 0xff);
5292   outb(0x1f4, (sector >> 8) & 0xff);
5293   outb(0x1f5, (sector >> 16) & 0xff);
5294   outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
5295   if(b->flags & B_DIRTY){
5296     outb(0x1f7, write_cmd);
5297     outsl(0x1f0, b->data, BSIZE/4);
5298   } else {
5299     outb(0x1f7, read_cmd);
5300   }
5301 }
5302 
5303 // Interrupt handler.
5304 void
5305 ideintr(void)
5306 {
5307   struct buf *b;
5308 
5309   // First queued buffer is the active request.
5310   acquire(&idelock);
5311   if((b = idequeue) == 0){
5312     release(&idelock);
5313     // cprintf("spurious IDE interrupt\n");
5314     return;
5315   }
5316   idequeue = b->qnext;
5317 
5318   // Read data if needed.
5319   if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
5320     insl(0x1f0, b->data, BSIZE/4);
5321 
5322   // Wake process waiting for this buf.
5323   b->flags |= B_VALID;
5324   b->flags &= ~B_DIRTY;
5325   wakeup(b);
5326 
5327   // Start disk on next buf in queue.
5328   if(idequeue != 0)
5329     idestart(idequeue);
5330 
5331   release(&idelock);
5332 }
5333 
5334 
5335 
5336 
5337 
5338 
5339 
5340 
5341 
5342 
5343 
5344 
5345 
5346 
5347 
5348 
5349 
5350 // Sync buf with disk.
5351 // If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
5352 // Else if B_VALID is not set, read buf from disk, set B_VALID.
5353 void
5354 iderw(struct buf *b)
5355 {
5356   struct buf **pp;
5357 
5358   if(!holdingsleep(&b->lock))
5359     panic("iderw: buf not locked");
5360   if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
5361     panic("iderw: nothing to do");
5362   if(b->dev != 0 && !havedisk1)
5363     panic("iderw: ide disk 1 not present");
5364 
5365   acquire(&idelock);  //DOC:acquire-lock
5366 
5367   // Append b to idequeue.
5368   b->qnext = 0;
5369   for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
5370     ;
5371   *pp = b;
5372 
5373   // Start disk if necessary.
5374   if(idequeue == b)
5375     idestart(b);
5376 
5377   // Wait for request to finish.
5378   while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
5379     sleep(b, &idelock);
5380   }
5381 
5382   release(&idelock);
5383 }
5384 
5385 
5386 
5387 
5388 
5389 
5390 
5391 
5392 
5393 
5394 
5395 
5396 
5397 
5398 
5399 
