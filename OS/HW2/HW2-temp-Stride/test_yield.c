#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    int pid, i;
    pid = fork();
    if (pid < 0){
        printf(1, "Fork Error");
        exit();
    }else if (pid == 0){
        for(i = 0 ; i < 1000; i++){
            printf(1, "C ");
            //sleep(5);
            //yield();
        }
            printf(1, "\n\nC Done---\n ");
        exit();

    }else {
        for(i = 0 ; i < 1000; i++){
            printf(1, "P ");
            //sleep(5);
            //yield();
        }
            printf(1, "\n\nP Done---\n ");
        wait();

    }
    exit();
}
