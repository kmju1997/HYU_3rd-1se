7750 #include "types.h"
7751 #include "defs.h"
7752 #include "param.h"
7753 #include "mmu.h"
7754 #include "proc.h"
7755 #include "fs.h"
7756 #include "spinlock.h"
7757 #include "sleeplock.h"
7758 #include "file.h"
7759 
7760 #define PIPESIZE 512
7761 
7762 struct pipe {
7763   struct spinlock lock;
7764   char data[PIPESIZE];
7765   uint nread;     // number of bytes read
7766   uint nwrite;    // number of bytes written
7767   int readopen;   // read fd is still open
7768   int writeopen;  // write fd is still open
7769 };
7770 
7771 int
7772 pipealloc(struct file **f0, struct file **f1)
7773 {
7774   struct pipe *p;
7775 
7776   p = 0;
7777   *f0 = *f1 = 0;
7778   if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
7779     goto bad;
7780   if((p = (struct pipe*)kalloc()) == 0)
7781     goto bad;
7782   p->readopen = 1;
7783   p->writeopen = 1;
7784   p->nwrite = 0;
7785   p->nread = 0;
7786   initlock(&p->lock, "pipe");
7787   (*f0)->type = FD_PIPE;
7788   (*f0)->readable = 1;
7789   (*f0)->writable = 0;
7790   (*f0)->pipe = p;
7791   (*f1)->type = FD_PIPE;
7792   (*f1)->readable = 0;
7793   (*f1)->writable = 1;
7794   (*f1)->pipe = p;
7795   return 0;
7796 
7797 
7798 
7799 
7800  bad:
7801   if(p)
7802     kfree((char*)p);
7803   if(*f0)
7804     fileclose(*f0);
7805   if(*f1)
7806     fileclose(*f1);
7807   return -1;
7808 }
7809 
7810 void
7811 pipeclose(struct pipe *p, int writable)
7812 {
7813   acquire(&p->lock);
7814   if(writable){
7815     p->writeopen = 0;
7816     wakeup(&p->nread);
7817   } else {
7818     p->readopen = 0;
7819     wakeup(&p->nwrite);
7820   }
7821   if(p->readopen == 0 && p->writeopen == 0){
7822     release(&p->lock);
7823     kfree((char*)p);
7824   } else
7825     release(&p->lock);
7826 }
7827 
7828 
7829 int
7830 pipewrite(struct pipe *p, char *addr, int n)
7831 {
7832   int i;
7833 
7834   acquire(&p->lock);
7835   for(i = 0; i < n; i++){
7836     while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
7837       if(p->readopen == 0 || proc->killed){
7838         release(&p->lock);
7839         return -1;
7840       }
7841       wakeup(&p->nread);
7842       sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
7843     }
7844     p->data[p->nwrite++ % PIPESIZE] = addr[i];
7845   }
7846   wakeup(&p->nread);  //DOC: pipewrite-wakeup1
7847   release(&p->lock);
7848   return n;
7849 }
7850 int
7851 piperead(struct pipe *p, char *addr, int n)
7852 {
7853   int i;
7854 
7855   acquire(&p->lock);
7856   while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
7857     if(proc->killed){
7858       release(&p->lock);
7859       return -1;
7860     }
7861     sleep(&p->nread, &p->lock); //DOC: piperead-sleep
7862   }
7863   for(i = 0; i < n; i++){  //DOC: piperead-copy
7864     if(p->nread == p->nwrite)
7865       break;
7866     addr[i] = p->data[p->nread++ % PIPESIZE];
7867   }
7868   wakeup(&p->nwrite);  //DOC: piperead-wakeup
7869   release(&p->lock);
7870   return i;
7871 }
7872 
7873 
7874 
7875 
7876 
7877 
7878 
7879 
7880 
7881 
7882 
7883 
7884 
7885 
7886 
7887 
7888 
7889 
7890 
7891 
7892 
7893 
7894 
7895 
7896 
7897 
7898 
7899 
