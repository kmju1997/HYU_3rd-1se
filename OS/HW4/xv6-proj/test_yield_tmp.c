#include "types.h"
#include "stat.h"
#include "user.h"

    int
main(int argc, char *argv[])
{
    int pid;
    int i;
    pid = fork();
    if (pid < 0){
        printf(1, "Fork Error");
        exit();
    }else if (pid == 0){
        if(set_cpu_share(1) == -1){
            printf(1, "\n\nC fail--\n ");

        }else{
            for(i = 0 ; i < 10000; i++){
                printf(1, "C ");
                //sleep(5);
                //yield();
            }

            printf(1, "\n\nC Done---\n ");
        }

        exit();

    }else {
        //set_cpu_share(10);
        printf(1, "\n\nP Done---\n ");
           for(i = 0 ; i < 1000; i++){
           printf(1, "P ");
        //sleep(5);
        //yield();
        }
        wait();

    }
    exit();
}
