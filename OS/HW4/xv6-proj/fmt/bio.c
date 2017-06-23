5400 // Buffer cache.
5401 //
5402 // The buffer cache is a linked list of buf structures holding
5403 // cached copies of disk block contents.  Caching disk blocks
5404 // in memory reduces the number of disk reads and also provides
5405 // a synchronization point for disk blocks used by multiple processes.
5406 //
5407 // Interface:
5408 // * To get a buffer for a particular disk block, call bread.
5409 // * After changing buffer data, call bwrite to write it to disk.
5410 // * When done with the buffer, call brelse.
5411 // * Do not use the buffer after calling brelse.
5412 // * Only one process at a time can use a buffer,
5413 //     so do not keep them longer than necessary.
5414 //
5415 // The implementation uses two state flags internally:
5416 // * B_VALID: the buffer data has been read from the disk.
5417 // * B_DIRTY: the buffer data has been modified
5418 //     and needs to be written to disk.
5419 
5420 #include "types.h"
5421 #include "defs.h"
5422 #include "param.h"
5423 #include "spinlock.h"
5424 #include "sleeplock.h"
5425 #include "fs.h"
5426 #include "buf.h"
5427 
5428 struct {
5429   struct spinlock lock;
5430   struct buf buf[NBUF];
5431 
5432   // Linked list of all buffers, through prev/next.
5433   // head.next is most recently used.
5434   struct buf head;
5435 } bcache;
5436 
5437 void
5438 binit(void)
5439 {
5440   struct buf *b;
5441 
5442   initlock(&bcache.lock, "bcache");
5443 
5444 
5445 
5446 
5447 
5448 
5449 
5450   // Create linked list of buffers
5451   bcache.head.prev = &bcache.head;
5452   bcache.head.next = &bcache.head;
5453   for(b = bcache.buf; b < bcache.buf+NBUF; b++){
5454     b->next = bcache.head.next;
5455     b->prev = &bcache.head;
5456     initsleeplock(&b->lock, "buffer");
5457     bcache.head.next->prev = b;
5458     bcache.head.next = b;
5459   }
5460 }
5461 
5462 // Look through buffer cache for block on device dev.
5463 // If not found, allocate a buffer.
5464 // In either case, return locked buffer.
5465 static struct buf*
5466 bget(uint dev, uint blockno)
5467 {
5468   struct buf *b;
5469 
5470   acquire(&bcache.lock);
5471 
5472   // Is the block already cached?
5473   for(b = bcache.head.next; b != &bcache.head; b = b->next){
5474     if(b->dev == dev && b->blockno == blockno){
5475       b->refcnt++;
5476       release(&bcache.lock);
5477       acquiresleep(&b->lock);
5478       return b;
5479     }
5480   }
5481 
5482   // Not cached; recycle some unused buffer and clean buffer
5483   // "clean" because B_DIRTY and not locked means log.c
5484   // hasn't yet committed the changes to the buffer.
5485   for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
5486     if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
5487       b->dev = dev;
5488       b->blockno = blockno;
5489       b->flags = 0;
5490       b->refcnt = 1;
5491       release(&bcache.lock);
5492       acquiresleep(&b->lock);
5493       return b;
5494     }
5495   }
5496   panic("bget: no buffers");
5497 }
5498 
5499 
5500 // Return a locked buf with the contents of the indicated block.
5501 struct buf*
5502 bread(uint dev, uint blockno)
5503 {
5504   struct buf *b;
5505 
5506   b = bget(dev, blockno);
5507   if(!(b->flags & B_VALID)) {
5508     iderw(b);
5509   }
5510   return b;
5511 }
5512 
5513 // Write b's contents to disk.  Must be locked.
5514 void
5515 bwrite(struct buf *b)
5516 {
5517   if(!holdingsleep(&b->lock))
5518     panic("bwrite");
5519   b->flags |= B_DIRTY;
5520   iderw(b);
5521 }
5522 
5523 // Release a locked buffer.
5524 // Move to the head of the MRU list.
5525 void
5526 brelse(struct buf *b)
5527 {
5528   if(!holdingsleep(&b->lock))
5529     panic("brelse");
5530 
5531   releasesleep(&b->lock);
5532 
5533   acquire(&bcache.lock);
5534   b->refcnt--;
5535   if (b->refcnt == 0) {
5536     // no one is waiting for it.
5537     b->next->prev = b->prev;
5538     b->prev->next = b->next;
5539     b->next = bcache.head.next;
5540     b->prev = &bcache.head;
5541     bcache.head.next->prev = b;
5542     bcache.head.next = b;
5543   }
5544 
5545   release(&bcache.lock);
5546 }
5547 
5548 
5549 
5550 // Blank page.
5551 
5552 
5553 
5554 
5555 
5556 
5557 
5558 
5559 
5560 
5561 
5562 
5563 
5564 
5565 
5566 
5567 
5568 
5569 
5570 
5571 
5572 
5573 
5574 
5575 
5576 
5577 
5578 
5579 
5580 
5581 
5582 
5583 
5584 
5585 
5586 
5587 
5588 
5589 
5590 
5591 
5592 
5593 
5594 
5595 
5596 
5597 
5598 
5599 
