#include "types.h"
#include "stat.h"
#include "user.h"
#define CNT_CHILD 5

    int
main(int argc, char *argv[])
{
    int pid;
    int i;


    for (i = 0; i < CNT_CHILD; i++) {
        pid = fork();
        if (pid > 0) {
            // parent
            continue;
        } else if (pid == 0) {
            // child]
            char *args[3] = {"echo", "echo is executed!", 0};
            sleep(1);
            exec("echo", args);
            printf(1, "exec failed!!\n");
            exit();
        } else {
            printf(1, "fork failed!!\n");
            exit();
        }
    }

    for (i = 0; i < CNT_CHILD; i++) {
        wait();
    }

    exit();
}
