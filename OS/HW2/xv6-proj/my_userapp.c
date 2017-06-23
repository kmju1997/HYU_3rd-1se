#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    char *buf = "Hello xv6!";
    int ret_val;
    ret_val = my_syscall(buf);
    printf(1, "Return value : 0x%x\n", ret_val);
    printf(1, "My pid : %x\n", getpid());
    printf(1, "My ppid : %x\n", getppid());

    printf(1, " int $128 test\n");
    __asm__("int $128");
    exit();
}
