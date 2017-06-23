6850 //
6851 // File descriptors
6852 //
6853 
6854 #include "types.h"
6855 #include "defs.h"
6856 #include "param.h"
6857 #include "fs.h"
6858 #include "spinlock.h"
6859 #include "sleeplock.h"
6860 #include "file.h"
6861 
6862 struct devsw devsw[NDEV];
6863 struct {
6864   struct spinlock lock;
6865   struct file file[NFILE];
6866 } ftable;
6867 
6868 void
6869 fileinit(void)
6870 {
6871   initlock(&ftable.lock, "ftable");
6872 }
6873 
6874 // Allocate a file structure.
6875 struct file*
6876 filealloc(void)
6877 {
6878   struct file *f;
6879 
6880   acquire(&ftable.lock);
6881   for(f = ftable.file; f < ftable.file + NFILE; f++){
6882     if(f->ref == 0){
6883       f->ref = 1;
6884       release(&ftable.lock);
6885       return f;
6886     }
6887   }
6888   release(&ftable.lock);
6889   return 0;
6890 }
6891 
6892 
6893 
6894 
6895 
6896 
6897 
6898 
6899 
6900 // Increment ref count for file f.
6901 struct file*
6902 filedup(struct file *f)
6903 {
6904   acquire(&ftable.lock);
6905   if(f->ref < 1)
6906     panic("filedup");
6907   f->ref++;
6908   release(&ftable.lock);
6909   return f;
6910 }
6911 
6912 // Close file f.  (Decrement ref count, close when reaches 0.)
6913 void
6914 fileclose(struct file *f)
6915 {
6916   struct file ff;
6917 
6918   acquire(&ftable.lock);
6919   if(f->ref < 1)
6920     panic("fileclose");
6921   if(--f->ref > 0){
6922     release(&ftable.lock);
6923     return;
6924   }
6925   ff = *f;
6926   f->ref = 0;
6927   f->type = FD_NONE;
6928   release(&ftable.lock);
6929 
6930   if(ff.type == FD_PIPE)
6931     pipeclose(ff.pipe, ff.writable);
6932   else if(ff.type == FD_INODE){
6933     begin_op();
6934     iput(ff.ip);
6935     end_op();
6936   }
6937 }
6938 
6939 
6940 
6941 
6942 
6943 
6944 
6945 
6946 
6947 
6948 
6949 
6950 // Get metadata about file f.
6951 int
6952 filestat(struct file *f, struct stat *st)
6953 {
6954   if(f->type == FD_INODE){
6955     ilock(f->ip);
6956     stati(f->ip, st);
6957     iunlock(f->ip);
6958     return 0;
6959   }
6960   return -1;
6961 }
6962 
6963 // Read from file f.
6964 int
6965 fileread(struct file *f, char *addr, int n)
6966 {
6967   int r;
6968 
6969   if(f->readable == 0)
6970     return -1;
6971   if(f->type == FD_PIPE)
6972     return piperead(f->pipe, addr, n);
6973   if(f->type == FD_INODE){
6974     ilock(f->ip);
6975     if((r = readi(f->ip, addr, f->off, n)) > 0)
6976       f->off += r;
6977     iunlock(f->ip);
6978     return r;
6979   }
6980   panic("fileread");
6981 }
6982 
6983 
6984 
6985 
6986 
6987 
6988 
6989 
6990 
6991 
6992 
6993 
6994 
6995 
6996 
6997 
6998 
6999 
7000 // Write to file f.
7001 int
7002 filewrite(struct file *f, char *addr, int n)
7003 {
7004   int r;
7005 
7006   if(f->writable == 0)
7007     return -1;
7008   if(f->type == FD_PIPE)
7009     return pipewrite(f->pipe, addr, n);
7010   if(f->type == FD_INODE){
7011     // write a few blocks at a time to avoid exceeding
7012     // the maximum log transaction size, including
7013     // i-node, indirect block, allocation blocks,
7014     // and 2 blocks of slop for non-aligned writes.
7015     // this really belongs lower down, since writei()
7016     // might be writing a device like the console.
7017     int max = ((LOGSIZE-1-1-2) / 2) * 512;
7018     int i = 0;
7019     while(i < n){
7020       int n1 = n - i;
7021       if(n1 > max)
7022         n1 = max;
7023 
7024       begin_op();
7025       ilock(f->ip);
7026       if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
7027         f->off += r;
7028       iunlock(f->ip);
7029       end_op();
7030 
7031       if(r < 0)
7032         break;
7033       if(r != n1)
7034         panic("short filewrite");
7035       i += r;
7036     }
7037     return i == n ? n : -1;
7038   }
7039   panic("filewrite");
7040 }
7041 
7042 
7043 
7044 
7045 
7046 
7047 
7048 
7049 
