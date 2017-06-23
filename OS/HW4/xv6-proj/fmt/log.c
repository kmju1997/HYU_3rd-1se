5700 #include "types.h"
5701 #include "defs.h"
5702 #include "param.h"
5703 #include "spinlock.h"
5704 #include "sleeplock.h"
5705 #include "fs.h"
5706 #include "buf.h"
5707 
5708 // Simple logging that allows concurrent FS system calls.
5709 //
5710 // A log transaction contains the updates of multiple FS system
5711 // calls. The logging system only commits when there are
5712 // no FS system calls active. Thus there is never
5713 // any reasoning required about whether a commit might
5714 // write an uncommitted system call's updates to disk.
5715 //
5716 // A system call should call begin_op()/end_op() to mark
5717 // its start and end. Usually begin_op() just increments
5718 // the count of in-progress FS system calls and returns.
5719 // But if it thinks the log is close to running out, it
5720 // sleeps until the last outstanding end_op() commits.
5721 //
5722 // The log is a physical re-do log containing disk blocks.
5723 // The on-disk log format:
5724 //   header block, containing block #s for block A, B, C, ...
5725 //   block A
5726 //   block B
5727 //   block C
5728 //   ...
5729 // Log appends are synchronous.
5730 
5731 // Contents of the header block, used for both the on-disk header block
5732 // and to keep track in memory of logged block# before commit.
5733 struct logheader {
5734   int n;
5735   int block[LOGSIZE];
5736 };
5737 
5738 struct log {
5739   struct spinlock lock;
5740   int start;
5741   int size;
5742   int outstanding; // how many FS sys calls are executing.
5743   int committing;  // in commit(), please wait.
5744   int dev;
5745   struct logheader lh;
5746 };
5747 
5748 
5749 
5750 struct log log;
5751 
5752 static void recover_from_log(void);
5753 static void commit();
5754 
5755 void
5756 initlog(int dev)
5757 {
5758   if (sizeof(struct logheader) >= BSIZE)
5759     panic("initlog: too big logheader");
5760 
5761   struct superblock sb;
5762   initlock(&log.lock, "log");
5763   readsb(dev, &sb);
5764   log.start = sb.logstart;
5765   log.size = sb.nlog;
5766   log.dev = dev;
5767   recover_from_log();
5768 }
5769 
5770 // Copy committed blocks from log to their home location
5771 static void
5772 install_trans(void)
5773 {
5774   int tail;
5775 
5776   for (tail = 0; tail < log.lh.n; tail++) {
5777     struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
5778     struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
5779     memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
5780     bwrite(dbuf);  // write dst to disk
5781     brelse(lbuf);
5782     brelse(dbuf);
5783   }
5784 }
5785 
5786 // Read the log header from disk into the in-memory log header
5787 static void
5788 read_head(void)
5789 {
5790   struct buf *buf = bread(log.dev, log.start);
5791   struct logheader *lh = (struct logheader *) (buf->data);
5792   int i;
5793   log.lh.n = lh->n;
5794   for (i = 0; i < log.lh.n; i++) {
5795     log.lh.block[i] = lh->block[i];
5796   }
5797   brelse(buf);
5798 }
5799 
5800 // Write in-memory log header to disk.
5801 // This is the true point at which the
5802 // current transaction commits.
5803 static void
5804 write_head(void)
5805 {
5806   struct buf *buf = bread(log.dev, log.start);
5807   struct logheader *hb = (struct logheader *) (buf->data);
5808   int i;
5809   hb->n = log.lh.n;
5810   for (i = 0; i < log.lh.n; i++) {
5811     hb->block[i] = log.lh.block[i];
5812   }
5813   bwrite(buf);
5814   brelse(buf);
5815 }
5816 
5817 static void
5818 recover_from_log(void)
5819 {
5820   read_head();
5821   install_trans(); // if committed, copy from log to disk
5822   log.lh.n = 0;
5823   write_head(); // clear the log
5824 }
5825 
5826 // called at the start of each FS system call.
5827 void
5828 begin_op(void)
5829 {
5830   acquire(&log.lock);
5831   while(1){
5832     if(log.committing){
5833       sleep(&log, &log.lock);
5834     } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
5835       // this op might exhaust log space; wait for commit.
5836       sleep(&log, &log.lock);
5837     } else {
5838       log.outstanding += 1;
5839       release(&log.lock);
5840       break;
5841     }
5842   }
5843 }
5844 
5845 
5846 
5847 
5848 
5849 
5850 // called at the end of each FS system call.
5851 // commits if this was the last outstanding operation.
5852 void
5853 end_op(void)
5854 {
5855   int do_commit = 0;
5856 
5857   acquire(&log.lock);
5858   log.outstanding -= 1;
5859   if(log.committing)
5860     panic("log.committing");
5861   if(log.outstanding == 0){
5862     do_commit = 1;
5863     log.committing = 1;
5864   } else {
5865     // begin_op() may be waiting for log space.
5866     wakeup(&log);
5867   }
5868   release(&log.lock);
5869 
5870   if(do_commit){
5871     // call commit w/o holding locks, since not allowed
5872     // to sleep with locks.
5873     commit();
5874     acquire(&log.lock);
5875     log.committing = 0;
5876     wakeup(&log);
5877     release(&log.lock);
5878   }
5879 }
5880 
5881 // Copy modified blocks from cache to log.
5882 static void
5883 write_log(void)
5884 {
5885   int tail;
5886 
5887   for (tail = 0; tail < log.lh.n; tail++) {
5888     struct buf *to = bread(log.dev, log.start+tail+1); // log block
5889     struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
5890     memmove(to->data, from->data, BSIZE);
5891     bwrite(to);  // write the log
5892     brelse(from);
5893     brelse(to);
5894   }
5895 }
5896 
5897 
5898 
5899 
5900 static void
5901 commit()
5902 {
5903   if (log.lh.n > 0) {
5904     write_log();     // Write modified blocks from cache to log
5905     write_head();    // Write header to disk -- the real commit
5906     install_trans(); // Now install writes to home locations
5907     log.lh.n = 0;
5908     write_head();    // Erase the transaction from the log
5909   }
5910 }
5911 
5912 // Caller has modified b->data and is done with the buffer.
5913 // Record the block number and pin in the cache with B_DIRTY.
5914 // commit()/write_log() will do the disk write.
5915 //
5916 // log_write() replaces bwrite(); a typical use is:
5917 //   bp = bread(...)
5918 //   modify bp->data[]
5919 //   log_write(bp)
5920 //   brelse(bp)
5921 void
5922 log_write(struct buf *b)
5923 {
5924   int i;
5925 
5926   if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
5927     panic("too big a transaction");
5928   if (log.outstanding < 1)
5929     panic("log_write outside of trans");
5930 
5931   acquire(&log.lock);
5932   for (i = 0; i < log.lh.n; i++) {
5933     if (log.lh.block[i] == b->blockno)   // log absorbtion
5934       break;
5935   }
5936   log.lh.block[i] = b->blockno;
5937   if (i == log.lh.n)
5938     log.lh.n++;
5939   b->flags |= B_DIRTY; // prevent eviction
5940   release(&log.lock);
5941 }
5942 
5943 
5944 
5945 
5946 
5947 
5948 
5949 
