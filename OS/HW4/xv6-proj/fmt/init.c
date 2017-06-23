9850 // init: The initial user-level program
9851 
9852 #include "types.h"
9853 #include "stat.h"
9854 #include "user.h"
9855 #include "fcntl.h"
9856 
9857 char *argv[] = { "sh", 0 };
9858 
9859 int
9860 main(void)
9861 {
9862   int pid, wpid;
9863 
9864   if(open("console", O_RDWR) < 0){
9865     mknod("console", 1, 1);
9866     open("console", O_RDWR);
9867   }
9868   dup(0);  // stdout
9869   dup(0);  // stderr
9870 
9871   for(;;){
9872     printf(1, "init: starting sh\n");
9873     pid = fork();
9874     if(pid < 0){
9875       printf(1, "init: fork failed\n");
9876       exit();
9877     }
9878     if(pid == 0){
9879       exec("sh", argv);
9880       printf(1, "init: exec sh failed\n");
9881       exit();
9882     }
9883     while((wpid=wait()) >= 0 && wpid != pid)
9884       printf(1, "zombie!\n");
9885   }
9886 }
9887 
9888 
9889 
9890 
9891 
9892 
9893 
9894 
9895 
9896 
9897 
9898 
9899 
