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
        for(i = 0 ; i < 100; i++){
            printf(1, "Child\n");
            sleep(5);
            yield();
        }
        exit();

    }else {
        for(i = 0 ; i < 100; i++){
            printf(1, "Parent\n");
            sleep(5);
            yield();
        }
        wait();

    }
    exit();
}
