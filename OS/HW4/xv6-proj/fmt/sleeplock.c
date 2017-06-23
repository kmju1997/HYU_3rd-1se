5600 // Sleeping locks
5601 
5602 #include "types.h"
5603 #include "defs.h"
5604 #include "param.h"
5605 #include "x86.h"
5606 #include "memlayout.h"
5607 #include "mmu.h"
5608 #include "proc.h"
5609 #include "spinlock.h"
5610 #include "sleeplock.h"
5611 
5612 void
5613 initsleeplock(struct sleeplock *lk, char *name)
5614 {
5615   initlock(&lk->lk, "sleep lock");
5616   lk->name = name;
5617   lk->locked = 0;
5618   lk->pid = 0;
5619 }
5620 
5621 void
5622 acquiresleep(struct sleeplock *lk)
5623 {
5624   acquire(&lk->lk);
5625   while (lk->locked) {
5626     sleep(lk, &lk->lk);
5627   }
5628   lk->locked = 1;
5629   lk->pid = proc->pid;
5630   release(&lk->lk);
5631 }
5632 
5633 void
5634 releasesleep(struct sleeplock *lk)
5635 {
5636   acquire(&lk->lk);
5637   lk->locked = 0;
5638   lk->pid = 0;
5639   wakeup(lk);
5640   release(&lk->lk);
5641 }
5642 
5643 
5644 
5645 
5646 
5647 
5648 
5649 
5650 int
5651 holdingsleep(struct sleeplock *lk)
5652 {
5653   int r;
5654 
5655   acquire(&lk->lk);
5656   r = lk->locked;
5657   release(&lk->lk);
5658   return r;
5659 }
5660 
5661 
5662 
5663 
5664 
5665 
5666 
5667 
5668 
5669 
5670 
5671 
5672 
5673 
5674 
5675 
5676 
5677 
5678 
5679 
5680 
5681 
5682 
5683 
5684 
5685 
5686 
5687 
5688 
5689 
5690 
5691 
5692 
5693 
5694 
5695 
5696 
5697 
5698 
5699 
