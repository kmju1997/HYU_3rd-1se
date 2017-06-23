7050 //
7051 // File-system system calls.
7052 // Mostly argument checking, since we don't trust
7053 // user code, and calls into file.c and fs.c.
7054 //
7055 
7056 #include "types.h"
7057 #include "defs.h"
7058 #include "param.h"
7059 #include "stat.h"
7060 #include "mmu.h"
7061 #include "proc.h"
7062 #include "fs.h"
7063 #include "spinlock.h"
7064 #include "sleeplock.h"
7065 #include "file.h"
7066 #include "fcntl.h"
7067 
7068 // Fetch the nth word-sized system call argument as a file descriptor
7069 // and return both the descriptor and the corresponding struct file.
7070 static int
7071 argfd(int n, int *pfd, struct file **pf)
7072 {
7073   int fd;
7074   struct file *f;
7075 
7076   if(argint(n, &fd) < 0)
7077     return -1;
7078   if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
7079     return -1;
7080   if(pfd)
7081     *pfd = fd;
7082   if(pf)
7083     *pf = f;
7084   return 0;
7085 }
7086 
7087 
7088 
7089 
7090 
7091 
7092 
7093 
7094 
7095 
7096 
7097 
7098 
7099 
7100 // Allocate a file descriptor for the given file.
7101 // Takes over file reference from caller on success.
7102 static int
7103 fdalloc(struct file *f)
7104 {
7105   int fd;
7106 
7107   for(fd = 0; fd < NOFILE; fd++){
7108     if(proc->ofile[fd] == 0){
7109       proc->ofile[fd] = f;
7110       return fd;
7111     }
7112   }
7113   return -1;
7114 }
7115 
7116 int
7117 sys_dup(void)
7118 {
7119   struct file *f;
7120   int fd;
7121 
7122   if(argfd(0, 0, &f) < 0)
7123     return -1;
7124   if((fd=fdalloc(f)) < 0)
7125     return -1;
7126   filedup(f);
7127   return fd;
7128 }
7129 
7130 int
7131 sys_read(void)
7132 {
7133   struct file *f;
7134   int n;
7135   char *p;
7136 
7137   if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
7138     return -1;
7139   return fileread(f, p, n);
7140 }
7141 
7142 
7143 
7144 
7145 
7146 
7147 
7148 
7149 
7150 int
7151 sys_write(void)
7152 {
7153   struct file *f;
7154   int n;
7155   char *p;
7156 
7157   if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
7158     return -1;
7159   return filewrite(f, p, n);
7160 }
7161 
7162 int
7163 sys_close(void)
7164 {
7165   int fd;
7166   struct file *f;
7167 
7168   if(argfd(0, &fd, &f) < 0)
7169     return -1;
7170   proc->ofile[fd] = 0;
7171   fileclose(f);
7172   return 0;
7173 }
7174 
7175 int
7176 sys_fstat(void)
7177 {
7178   struct file *f;
7179   struct stat *st;
7180 
7181   if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
7182     return -1;
7183   return filestat(f, st);
7184 }
7185 
7186 
7187 
7188 
7189 
7190 
7191 
7192 
7193 
7194 
7195 
7196 
7197 
7198 
7199 
7200 // Create the path new as a link to the same inode as old.
7201 int
7202 sys_link(void)
7203 {
7204   char name[DIRSIZ], *new, *old;
7205   struct inode *dp, *ip;
7206 
7207   if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
7208     return -1;
7209 
7210   begin_op();
7211   if((ip = namei(old)) == 0){
7212     end_op();
7213     return -1;
7214   }
7215 
7216   ilock(ip);
7217   if(ip->type == T_DIR){
7218     iunlockput(ip);
7219     end_op();
7220     return -1;
7221   }
7222 
7223   ip->nlink++;
7224   iupdate(ip);
7225   iunlock(ip);
7226 
7227   if((dp = nameiparent(new, name)) == 0)
7228     goto bad;
7229   ilock(dp);
7230   if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
7231     iunlockput(dp);
7232     goto bad;
7233   }
7234   iunlockput(dp);
7235   iput(ip);
7236 
7237   end_op();
7238 
7239   return 0;
7240 
7241 bad:
7242   ilock(ip);
7243   ip->nlink--;
7244   iupdate(ip);
7245   iunlockput(ip);
7246   end_op();
7247   return -1;
7248 }
7249 
7250 // Is the directory dp empty except for "." and ".." ?
7251 static int
7252 isdirempty(struct inode *dp)
7253 {
7254   int off;
7255   struct dirent de;
7256 
7257   for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
7258     if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
7259       panic("isdirempty: readi");
7260     if(de.inum != 0)
7261       return 0;
7262   }
7263   return 1;
7264 }
7265 
7266 
7267 
7268 
7269 
7270 
7271 
7272 
7273 
7274 
7275 
7276 
7277 
7278 
7279 
7280 
7281 
7282 
7283 
7284 
7285 
7286 
7287 
7288 
7289 
7290 
7291 
7292 
7293 
7294 
7295 
7296 
7297 
7298 
7299 
7300 int
7301 sys_unlink(void)
7302 {
7303   struct inode *ip, *dp;
7304   struct dirent de;
7305   char name[DIRSIZ], *path;
7306   uint off;
7307 
7308   if(argstr(0, &path) < 0)
7309     return -1;
7310 
7311   begin_op();
7312   if((dp = nameiparent(path, name)) == 0){
7313     end_op();
7314     return -1;
7315   }
7316 
7317   ilock(dp);
7318 
7319   // Cannot unlink "." or "..".
7320   if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
7321     goto bad;
7322 
7323   if((ip = dirlookup(dp, name, &off)) == 0)
7324     goto bad;
7325   ilock(ip);
7326 
7327   if(ip->nlink < 1)
7328     panic("unlink: nlink < 1");
7329   if(ip->type == T_DIR && !isdirempty(ip)){
7330     iunlockput(ip);
7331     goto bad;
7332   }
7333 
7334   memset(&de, 0, sizeof(de));
7335   if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
7336     panic("unlink: writei");
7337   if(ip->type == T_DIR){
7338     dp->nlink--;
7339     iupdate(dp);
7340   }
7341   iunlockput(dp);
7342 
7343   ip->nlink--;
7344   iupdate(ip);
7345   iunlockput(ip);
7346 
7347   end_op();
7348 
7349   return 0;
7350 bad:
7351   iunlockput(dp);
7352   end_op();
7353   return -1;
7354 }
7355 
7356 static struct inode*
7357 create(char *path, short type, short major, short minor)
7358 {
7359   uint off;
7360   struct inode *ip, *dp;
7361   char name[DIRSIZ];
7362 
7363   if((dp = nameiparent(path, name)) == 0)
7364     return 0;
7365   ilock(dp);
7366 
7367   if((ip = dirlookup(dp, name, &off)) != 0){
7368     iunlockput(dp);
7369     ilock(ip);
7370     if(type == T_FILE && ip->type == T_FILE)
7371       return ip;
7372     iunlockput(ip);
7373     return 0;
7374   }
7375 
7376   if((ip = ialloc(dp->dev, type)) == 0)
7377     panic("create: ialloc");
7378 
7379   ilock(ip);
7380   ip->major = major;
7381   ip->minor = minor;
7382   ip->nlink = 1;
7383   iupdate(ip);
7384 
7385   if(type == T_DIR){  // Create . and .. entries.
7386     dp->nlink++;  // for ".."
7387     iupdate(dp);
7388     // No ip->nlink++ for ".": avoid cyclic ref count.
7389     if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
7390       panic("create dots");
7391   }
7392 
7393   if(dirlink(dp, name, ip->inum) < 0)
7394     panic("create: dirlink");
7395 
7396   iunlockput(dp);
7397 
7398   return ip;
7399 }
7400 int
7401 sys_open(void)
7402 {
7403   char *path;
7404   int fd, omode;
7405   struct file *f;
7406   struct inode *ip;
7407 
7408   if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
7409     return -1;
7410 
7411   begin_op();
7412 
7413   if(omode & O_CREATE){
7414     ip = create(path, T_FILE, 0, 0);
7415     if(ip == 0){
7416       end_op();
7417       return -1;
7418     }
7419   } else {
7420     if((ip = namei(path)) == 0){
7421       end_op();
7422       return -1;
7423     }
7424     ilock(ip);
7425     if(ip->type == T_DIR && omode != O_RDONLY){
7426       iunlockput(ip);
7427       end_op();
7428       return -1;
7429     }
7430   }
7431 
7432   if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
7433     if(f)
7434       fileclose(f);
7435     iunlockput(ip);
7436     end_op();
7437     return -1;
7438   }
7439   iunlock(ip);
7440   end_op();
7441 
7442   f->type = FD_INODE;
7443   f->ip = ip;
7444   f->off = 0;
7445   f->readable = !(omode & O_WRONLY);
7446   f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
7447   return fd;
7448 }
7449 
7450 int
7451 sys_mkdir(void)
7452 {
7453   char *path;
7454   struct inode *ip;
7455 
7456   begin_op();
7457   if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
7458     end_op();
7459     return -1;
7460   }
7461   iunlockput(ip);
7462   end_op();
7463   return 0;
7464 }
7465 
7466 int
7467 sys_mknod(void)
7468 {
7469   struct inode *ip;
7470   char *path;
7471   int major, minor;
7472 
7473   begin_op();
7474   if((argstr(0, &path)) < 0 ||
7475      argint(1, &major) < 0 ||
7476      argint(2, &minor) < 0 ||
7477      (ip = create(path, T_DEV, major, minor)) == 0){
7478     end_op();
7479     return -1;
7480   }
7481   iunlockput(ip);
7482   end_op();
7483   return 0;
7484 }
7485 
7486 
7487 
7488 
7489 
7490 
7491 
7492 
7493 
7494 
7495 
7496 
7497 
7498 
7499 
7500 int
7501 sys_chdir(void)
7502 {
7503   char *path;
7504   struct inode *ip;
7505 
7506   begin_op();
7507   if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
7508     end_op();
7509     return -1;
7510   }
7511   ilock(ip);
7512   if(ip->type != T_DIR){
7513     iunlockput(ip);
7514     end_op();
7515     return -1;
7516   }
7517   iunlock(ip);
7518   iput(proc->cwd);
7519   end_op();
7520   proc->cwd = ip;
7521   return 0;
7522 }
7523 
7524 int
7525 sys_exec(void)
7526 {
7527   char *path, *argv[MAXARG];
7528   int i;
7529   uint uargv, uarg;
7530 
7531   if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
7532     return -1;
7533   }
7534   memset(argv, 0, sizeof(argv));
7535   for(i=0;; i++){
7536     if(i >= NELEM(argv))
7537       return -1;
7538     if(fetchint(uargv+4*i, (int*)&uarg) < 0)
7539       return -1;
7540     if(uarg == 0){
7541       argv[i] = 0;
7542       break;
7543     }
7544     if(fetchstr(uarg, &argv[i]) < 0)
7545       return -1;
7546   }
7547   return exec(path, argv);
7548 }
7549 
7550 int
7551 sys_pipe(void)
7552 {
7553   int *fd;
7554   struct file *rf, *wf;
7555   int fd0, fd1;
7556 
7557   if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
7558     return -1;
7559   if(pipealloc(&rf, &wf) < 0)
7560     return -1;
7561   fd0 = -1;
7562   //cprintf(" pipe cur pid %d/ tid %d\n",proc->pid,proc->tid);
7563   if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
7564     if(fd0 >= 0)
7565       proc->ofile[fd0] = 0;
7566     fileclose(rf);
7567     fileclose(wf);
7568     return -1;
7569   }
7570   fd[0] = fd0;
7571   fd[1] = fd1;
7572   return 0;
7573 }
7574 
7575 
7576 
7577 
7578 
7579 
7580 
7581 
7582 
7583 
7584 
7585 
7586 
7587 
7588 
7589 
7590 
7591 
7592 
7593 
7594 
7595 
7596 
7597 
7598 
7599 
