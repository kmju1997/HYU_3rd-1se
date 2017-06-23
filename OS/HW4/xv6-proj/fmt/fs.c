5950 // File system implementation.  Five layers:
5951 //   + Blocks: allocator for raw disk blocks.
5952 //   + Log: crash recovery for multi-step updates.
5953 //   + Files: inode allocator, reading, writing, metadata.
5954 //   + Directories: inode with special contents (list of other inodes!)
5955 //   + Names: paths like /usr/rtm/xv6/fs.c for convenient naming.
5956 //
5957 // This file contains the low-level file system manipulation
5958 // routines.  The (higher-level) system call implementations
5959 // are in sysfile.c.
5960 
5961 #include "types.h"
5962 #include "defs.h"
5963 #include "param.h"
5964 #include "stat.h"
5965 #include "mmu.h"
5966 #include "proc.h"
5967 #include "spinlock.h"
5968 #include "sleeplock.h"
5969 #include "fs.h"
5970 #include "buf.h"
5971 #include "file.h"
5972 
5973 #define min(a, b) ((a) < (b) ? (a) : (b))
5974 static void itrunc(struct inode*);
5975 // there should be one superblock per disk device, but we run with
5976 // only one device
5977 struct superblock sb;
5978 
5979 // Read the super block.
5980 void
5981 readsb(int dev, struct superblock *sb)
5982 {
5983   struct buf *bp;
5984 
5985   bp = bread(dev, 1);
5986   memmove(sb, bp->data, sizeof(*sb));
5987   brelse(bp);
5988 }
5989 
5990 
5991 
5992 
5993 
5994 
5995 
5996 
5997 
5998 
5999 
6000 // Zero a block.
6001 static void
6002 bzero(int dev, int bno)
6003 {
6004   struct buf *bp;
6005 
6006   bp = bread(dev, bno);
6007   memset(bp->data, 0, BSIZE);
6008   log_write(bp);
6009   brelse(bp);
6010 }
6011 
6012 // Blocks.
6013 
6014 // Allocate a zeroed disk block.
6015 static uint
6016 balloc(uint dev)
6017 {
6018   int b, bi, m;
6019   struct buf *bp;
6020 
6021   bp = 0;
6022   for(b = 0; b < sb.size; b += BPB){
6023     bp = bread(dev, BBLOCK(b, sb));
6024     for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
6025       m = 1 << (bi % 8);
6026       if((bp->data[bi/8] & m) == 0){  // Is block free?
6027         bp->data[bi/8] |= m;  // Mark block in use.
6028         log_write(bp);
6029         brelse(bp);
6030         bzero(dev, b + bi);
6031         return b + bi;
6032       }
6033     }
6034     brelse(bp);
6035   }
6036   panic("balloc: out of blocks");
6037 }
6038 
6039 
6040 
6041 
6042 
6043 
6044 
6045 
6046 
6047 
6048 
6049 
6050 // Free a disk block.
6051 static void
6052 bfree(int dev, uint b)
6053 {
6054   struct buf *bp;
6055   int bi, m;
6056 
6057   readsb(dev, &sb);
6058   bp = bread(dev, BBLOCK(b, sb));
6059   bi = b % BPB;
6060   m = 1 << (bi % 8);
6061   if((bp->data[bi/8] & m) == 0)
6062     panic("freeing free block");
6063   bp->data[bi/8] &= ~m;
6064   log_write(bp);
6065   brelse(bp);
6066 }
6067 
6068 // Inodes.
6069 //
6070 // An inode describes a single unnamed file.
6071 // The inode disk structure holds metadata: the file's type,
6072 // its size, the number of links referring to it, and the
6073 // list of blocks holding the file's content.
6074 //
6075 // The inodes are laid out sequentially on disk at
6076 // sb.startinode. Each inode has a number, indicating its
6077 // position on the disk.
6078 //
6079 // The kernel keeps a cache of in-use inodes in memory
6080 // to provide a place for synchronizing access
6081 // to inodes used by multiple processes. The cached
6082 // inodes include book-keeping information that is
6083 // not stored on disk: ip->ref and ip->flags.
6084 //
6085 // An inode and its in-memory represtative go through a
6086 // sequence of states before they can be used by the
6087 // rest of the file system code.
6088 //
6089 // * Allocation: an inode is allocated if its type (on disk)
6090 //   is non-zero. ialloc() allocates, iput() frees if
6091 //   the link count has fallen to zero.
6092 //
6093 // * Referencing in cache: an entry in the inode cache
6094 //   is free if ip->ref is zero. Otherwise ip->ref tracks
6095 //   the number of in-memory pointers to the entry (open
6096 //   files and current directories). iget() to find or
6097 //   create a cache entry and increment its ref, iput()
6098 //   to decrement ref.
6099 //
6100 // * Valid: the information (type, size, &c) in an inode
6101 //   cache entry is only correct when the I_VALID bit
6102 //   is set in ip->flags. ilock() reads the inode from
6103 //   the disk and sets I_VALID, while iput() clears
6104 //   I_VALID if ip->ref has fallen to zero.
6105 //
6106 // * Locked: file system code may only examine and modify
6107 //   the information in an inode and its content if it
6108 //   has first locked the inode.
6109 //
6110 // Thus a typical sequence is:
6111 //   ip = iget(dev, inum)
6112 //   ilock(ip)
6113 //   ... examine and modify ip->xxx ...
6114 //   iunlock(ip)
6115 //   iput(ip)
6116 //
6117 // ilock() is separate from iget() so that system calls can
6118 // get a long-term reference to an inode (as for an open file)
6119 // and only lock it for short periods (e.g., in read()).
6120 // The separation also helps avoid deadlock and races during
6121 // pathname lookup. iget() increments ip->ref so that the inode
6122 // stays cached and pointers to it remain valid.
6123 //
6124 // Many internal file system functions expect the caller to
6125 // have locked the inodes involved; this lets callers create
6126 // multi-step atomic operations.
6127 
6128 struct {
6129   struct spinlock lock;
6130   struct inode inode[NINODE];
6131 } icache;
6132 
6133 void
6134 iinit(int dev)
6135 {
6136   int i = 0;
6137 
6138   initlock(&icache.lock, "icache");
6139   for(i = 0; i < NINODE; i++) {
6140     initsleeplock(&icache.inode[i].lock, "inode");
6141   }
6142 
6143   readsb(dev, &sb);
6144   cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
6145  inodestart %d bmap start %d\n", sb.size, sb.nblocks,
6146           sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
6147           sb.bmapstart);
6148 }
6149 
6150 static struct inode* iget(uint dev, uint inum);
6151 
6152 
6153 
6154 
6155 
6156 
6157 
6158 
6159 
6160 
6161 
6162 
6163 
6164 
6165 
6166 
6167 
6168 
6169 
6170 
6171 
6172 
6173 
6174 
6175 
6176 
6177 
6178 
6179 
6180 
6181 
6182 
6183 
6184 
6185 
6186 
6187 
6188 
6189 
6190 
6191 
6192 
6193 
6194 
6195 
6196 
6197 
6198 
6199 
6200 // Allocate a new inode with the given type on device dev.
6201 // A free inode has a type of zero.
6202 struct inode*
6203 ialloc(uint dev, short type)
6204 {
6205   int inum;
6206   struct buf *bp;
6207   struct dinode *dip;
6208 
6209   for(inum = 1; inum < sb.ninodes; inum++){
6210     bp = bread(dev, IBLOCK(inum, sb));
6211     dip = (struct dinode*)bp->data + inum%IPB;
6212     if(dip->type == 0){  // a free inode
6213       memset(dip, 0, sizeof(*dip));
6214       dip->type = type;
6215       log_write(bp);   // mark it allocated on the disk
6216       brelse(bp);
6217       return iget(dev, inum);
6218     }
6219     brelse(bp);
6220   }
6221   panic("ialloc: no inodes");
6222 }
6223 
6224 // Copy a modified in-memory inode to disk.
6225 void
6226 iupdate(struct inode *ip)
6227 {
6228   struct buf *bp;
6229   struct dinode *dip;
6230 
6231   bp = bread(ip->dev, IBLOCK(ip->inum, sb));
6232   dip = (struct dinode*)bp->data + ip->inum%IPB;
6233   dip->type = ip->type;
6234   dip->major = ip->major;
6235   dip->minor = ip->minor;
6236   dip->nlink = ip->nlink;
6237   dip->size = ip->size;
6238   memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
6239   log_write(bp);
6240   brelse(bp);
6241 }
6242 
6243 
6244 
6245 
6246 
6247 
6248 
6249 
6250 // Find the inode with number inum on device dev
6251 // and return the in-memory copy. Does not lock
6252 // the inode and does not read it from disk.
6253 static struct inode*
6254 iget(uint dev, uint inum)
6255 {
6256   struct inode *ip, *empty;
6257 
6258   acquire(&icache.lock);
6259 
6260   // Is the inode already cached?
6261   empty = 0;
6262   for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
6263     if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
6264       ip->ref++;
6265       release(&icache.lock);
6266       return ip;
6267     }
6268     if(empty == 0 && ip->ref == 0)    // Remember empty slot.
6269       empty = ip;
6270   }
6271 
6272   // Recycle an inode cache entry.
6273   if(empty == 0)
6274     panic("iget: no inodes");
6275 
6276   ip = empty;
6277   ip->dev = dev;
6278   ip->inum = inum;
6279   ip->ref = 1;
6280   ip->flags = 0;
6281   release(&icache.lock);
6282 
6283   return ip;
6284 }
6285 
6286 // Increment reference count for ip.
6287 // Returns ip to enable ip = idup(ip1) idiom.
6288 struct inode*
6289 idup(struct inode *ip)
6290 {
6291   acquire(&icache.lock);
6292   ip->ref++;
6293   release(&icache.lock);
6294   return ip;
6295 }
6296 
6297 
6298 
6299 
6300 // Lock the given inode.
6301 // Reads the inode from disk if necessary.
6302 void
6303 ilock(struct inode *ip)
6304 {
6305   struct buf *bp;
6306   struct dinode *dip;
6307 
6308   if(ip == 0 || ip->ref < 1)
6309     panic("ilock");
6310 
6311   acquiresleep(&ip->lock);
6312 
6313   if(!(ip->flags & I_VALID)){
6314     bp = bread(ip->dev, IBLOCK(ip->inum, sb));
6315     dip = (struct dinode*)bp->data + ip->inum%IPB;
6316     ip->type = dip->type;
6317     ip->major = dip->major;
6318     ip->minor = dip->minor;
6319     ip->nlink = dip->nlink;
6320     ip->size = dip->size;
6321     memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
6322     brelse(bp);
6323     ip->flags |= I_VALID;
6324     if(ip->type == 0)
6325       panic("ilock: no type");
6326   }
6327 }
6328 
6329 // Unlock the given inode.
6330 void
6331 iunlock(struct inode *ip)
6332 {
6333   if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
6334     panic("iunlock");
6335 
6336   releasesleep(&ip->lock);
6337 }
6338 
6339 
6340 
6341 
6342 
6343 
6344 
6345 
6346 
6347 
6348 
6349 
6350 // Drop a reference to an in-memory inode.
6351 // If that was the last reference, the inode cache entry can
6352 // be recycled.
6353 // If that was the last reference and the inode has no links
6354 // to it, free the inode (and its content) on disk.
6355 // All calls to iput() must be inside a transaction in
6356 // case it has to free the inode.
6357 void
6358 iput(struct inode *ip)
6359 {
6360   acquire(&icache.lock);
6361   if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
6362     // inode has no links and no other references: truncate and free.
6363     release(&icache.lock);
6364     itrunc(ip);
6365     ip->type = 0;
6366     iupdate(ip);
6367     acquire(&icache.lock);
6368     ip->flags = 0;
6369   }
6370   ip->ref--;
6371   release(&icache.lock);
6372 }
6373 
6374 // Common idiom: unlock, then put.
6375 void
6376 iunlockput(struct inode *ip)
6377 {
6378   iunlock(ip);
6379   iput(ip);
6380 }
6381 
6382 
6383 
6384 
6385 
6386 
6387 
6388 
6389 
6390 
6391 
6392 
6393 
6394 
6395 
6396 
6397 
6398 
6399 
6400 // Inode content
6401 //
6402 // The content (data) associated with each inode is stored
6403 // in blocks on the disk. The first NDIRECT block numbers
6404 // are listed in ip->addrs[].  The next NINDIRECT blocks are
6405 // listed in block ip->addrs[NDIRECT].
6406 
6407 // Return the disk block address of the nth block in inode ip.
6408 // If there is no such block, bmap allocates one.
6409 static uint
6410 bmap(struct inode *ip, uint bn)
6411 {
6412   uint addr, *a;
6413   struct buf *bp;
6414 
6415   if(bn < NDIRECT){
6416     if((addr = ip->addrs[bn]) == 0)
6417       ip->addrs[bn] = addr = balloc(ip->dev);
6418     return addr;
6419   }
6420   bn -= NDIRECT;
6421 
6422   if(bn < NINDIRECT){
6423     // Load indirect block, allocating if necessary.
6424     if((addr = ip->addrs[NDIRECT]) == 0)
6425       ip->addrs[NDIRECT] = addr = balloc(ip->dev);
6426     bp = bread(ip->dev, addr);
6427     a = (uint*)bp->data;
6428     if((addr = a[bn]) == 0){
6429       a[bn] = addr = balloc(ip->dev);
6430       log_write(bp);
6431     }
6432     brelse(bp);
6433     return addr;
6434   }
6435 
6436   panic("bmap: out of range");
6437 }
6438 
6439 
6440 
6441 
6442 
6443 
6444 
6445 
6446 
6447 
6448 
6449 
6450 // Truncate inode (discard contents).
6451 // Only called when the inode has no links
6452 // to it (no directory entries referring to it)
6453 // and has no in-memory reference to it (is
6454 // not an open file or current directory).
6455 static void
6456 itrunc(struct inode *ip)
6457 {
6458   int i, j;
6459   struct buf *bp;
6460   uint *a;
6461 
6462   for(i = 0; i < NDIRECT; i++){
6463     if(ip->addrs[i]){
6464       bfree(ip->dev, ip->addrs[i]);
6465       ip->addrs[i] = 0;
6466     }
6467   }
6468 
6469   if(ip->addrs[NDIRECT]){
6470     bp = bread(ip->dev, ip->addrs[NDIRECT]);
6471     a = (uint*)bp->data;
6472     for(j = 0; j < NINDIRECT; j++){
6473       if(a[j])
6474         bfree(ip->dev, a[j]);
6475     }
6476     brelse(bp);
6477     bfree(ip->dev, ip->addrs[NDIRECT]);
6478     ip->addrs[NDIRECT] = 0;
6479   }
6480 
6481   ip->size = 0;
6482   iupdate(ip);
6483 }
6484 
6485 // Copy stat information from inode.
6486 void
6487 stati(struct inode *ip, struct stat *st)
6488 {
6489   st->dev = ip->dev;
6490   st->ino = ip->inum;
6491   st->type = ip->type;
6492   st->nlink = ip->nlink;
6493   st->size = ip->size;
6494 }
6495 
6496 
6497 
6498 
6499 
6500 // Read data from inode.
6501 int
6502 readi(struct inode *ip, char *dst, uint off, uint n)
6503 {
6504   uint tot, m;
6505   struct buf *bp;
6506 
6507   if(ip->type == T_DEV){
6508     if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
6509       return -1;
6510     return devsw[ip->major].read(ip, dst, n);
6511   }
6512 
6513   if(off > ip->size || off + n < off)
6514     return -1;
6515   if(off + n > ip->size)
6516     n = ip->size - off;
6517 
6518   for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
6519     bp = bread(ip->dev, bmap(ip, off/BSIZE));
6520     m = min(n - tot, BSIZE - off%BSIZE);
6521     /*
6522     cprintf("data off %d:\n", off);
6523     for (int j = 0; j < min(m, 10); j++) {
6524       cprintf("%x ", bp->data[off%BSIZE+j]);
6525     }
6526     cprintf("\n");
6527     */
6528     memmove(dst, bp->data + off%BSIZE, m);
6529     brelse(bp);
6530   }
6531   return n;
6532 }
6533 
6534 
6535 
6536 
6537 
6538 
6539 
6540 
6541 
6542 
6543 
6544 
6545 
6546 
6547 
6548 
6549 
6550 // Write data to inode.
6551 int
6552 writei(struct inode *ip, char *src, uint off, uint n)
6553 {
6554   uint tot, m;
6555   struct buf *bp;
6556 
6557   if(ip->type == T_DEV){
6558     if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
6559       return -1;
6560     return devsw[ip->major].write(ip, src, n);
6561   }
6562 
6563   if(off > ip->size || off + n < off)
6564     return -1;
6565   if(off + n > MAXFILE*BSIZE)
6566     return -1;
6567 
6568   for(tot=0; tot<n; tot+=m, off+=m, src+=m){
6569     bp = bread(ip->dev, bmap(ip, off/BSIZE));
6570     m = min(n - tot, BSIZE - off%BSIZE);
6571     memmove(bp->data + off%BSIZE, src, m);
6572     log_write(bp);
6573     brelse(bp);
6574   }
6575 
6576   if(n > 0 && off > ip->size){
6577     ip->size = off;
6578     iupdate(ip);
6579   }
6580   return n;
6581 }
6582 
6583 
6584 
6585 
6586 
6587 
6588 
6589 
6590 
6591 
6592 
6593 
6594 
6595 
6596 
6597 
6598 
6599 
6600 // Directories
6601 
6602 int
6603 namecmp(const char *s, const char *t)
6604 {
6605   return strncmp(s, t, DIRSIZ);
6606 }
6607 
6608 // Look for a directory entry in a directory.
6609 // If found, set *poff to byte offset of entry.
6610 struct inode*
6611 dirlookup(struct inode *dp, char *name, uint *poff)
6612 {
6613   uint off, inum;
6614   struct dirent de;
6615 
6616   if(dp->type != T_DIR)
6617     panic("dirlookup not DIR");
6618 
6619   for(off = 0; off < dp->size; off += sizeof(de)){
6620     if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
6621       panic("dirlink read");
6622     if(de.inum == 0)
6623       continue;
6624     if(namecmp(name, de.name) == 0){
6625       // entry matches path element
6626       if(poff)
6627         *poff = off;
6628       inum = de.inum;
6629       return iget(dp->dev, inum);
6630     }
6631   }
6632 
6633   return 0;
6634 }
6635 
6636 
6637 
6638 
6639 
6640 
6641 
6642 
6643 
6644 
6645 
6646 
6647 
6648 
6649 
6650 // Write a new directory entry (name, inum) into the directory dp.
6651 int
6652 dirlink(struct inode *dp, char *name, uint inum)
6653 {
6654   int off;
6655   struct dirent de;
6656   struct inode *ip;
6657 
6658   // Check that name is not present.
6659   if((ip = dirlookup(dp, name, 0)) != 0){
6660     iput(ip);
6661     return -1;
6662   }
6663 
6664   // Look for an empty dirent.
6665   for(off = 0; off < dp->size; off += sizeof(de)){
6666     if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
6667       panic("dirlink read");
6668     if(de.inum == 0)
6669       break;
6670   }
6671 
6672   strncpy(de.name, name, DIRSIZ);
6673   de.inum = inum;
6674   if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
6675     panic("dirlink");
6676 
6677   return 0;
6678 }
6679 
6680 
6681 
6682 
6683 
6684 
6685 
6686 
6687 
6688 
6689 
6690 
6691 
6692 
6693 
6694 
6695 
6696 
6697 
6698 
6699 
6700 // Paths
6701 
6702 // Copy the next path element from path into name.
6703 // Return a pointer to the element following the copied one.
6704 // The returned path has no leading slashes,
6705 // so the caller can check *path=='\0' to see if the name is the last one.
6706 // If no name to remove, return 0.
6707 //
6708 // Examples:
6709 //   skipelem("a/bb/c", name) = "bb/c", setting name = "a"
6710 //   skipelem("///a//bb", name) = "bb", setting name = "a"
6711 //   skipelem("a", name) = "", setting name = "a"
6712 //   skipelem("", name) = skipelem("////", name) = 0
6713 //
6714 static char*
6715 skipelem(char *path, char *name)
6716 {
6717   char *s;
6718   int len;
6719 
6720   while(*path == '/')
6721     path++;
6722   if(*path == 0)
6723     return 0;
6724   s = path;
6725   while(*path != '/' && *path != 0)
6726     path++;
6727   len = path - s;
6728   if(len >= DIRSIZ)
6729     memmove(name, s, DIRSIZ);
6730   else {
6731     memmove(name, s, len);
6732     name[len] = 0;
6733   }
6734   while(*path == '/')
6735     path++;
6736   return path;
6737 }
6738 
6739 
6740 
6741 
6742 
6743 
6744 
6745 
6746 
6747 
6748 
6749 
6750 // Look up and return the inode for a path name.
6751 // If parent != 0, return the inode for the parent and copy the final
6752 // path element into name, which must have room for DIRSIZ bytes.
6753 // Must be called inside a transaction since it calls iput().
6754 static struct inode*
6755 namex(char *path, int nameiparent, char *name)
6756 {
6757   struct inode *ip, *next;
6758 
6759   if(*path == '/')
6760     ip = iget(ROOTDEV, ROOTINO);
6761   else
6762     ip = idup(proc->cwd);
6763 
6764   while((path = skipelem(path, name)) != 0){
6765     ilock(ip);
6766     if(ip->type != T_DIR){
6767       iunlockput(ip);
6768       return 0;
6769     }
6770     if(nameiparent && *path == '\0'){
6771       // Stop one level early.
6772       iunlock(ip);
6773       return ip;
6774     }
6775     if((next = dirlookup(ip, name, 0)) == 0){
6776       iunlockput(ip);
6777       return 0;
6778     }
6779     iunlockput(ip);
6780     ip = next;
6781   }
6782   if(nameiparent){
6783     iput(ip);
6784     return 0;
6785   }
6786   return ip;
6787 }
6788 
6789 struct inode*
6790 namei(char *path)
6791 {
6792   char name[DIRSIZ];
6793   return namex(path, 0, name);
6794 }
6795 
6796 
6797 
6798 
6799 
6800 struct inode*
6801 nameiparent(char *path, char *name)
6802 {
6803   return namex(path, 1, name);
6804 }
6805 
6806 
6807 
6808 
6809 
6810 
6811 
6812 
6813 
6814 
6815 
6816 
6817 
6818 
6819 
6820 
6821 
6822 
6823 
6824 
6825 
6826 
6827 
6828 
6829 
6830 
6831 
6832 
6833 
6834 
6835 
6836 
6837 
6838 
6839 
6840 
6841 
6842 
6843 
6844 
6845 
6846 
6847 
6848 
6849 
