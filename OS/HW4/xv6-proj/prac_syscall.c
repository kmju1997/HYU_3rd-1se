#include "types.h"
#include "defs.h"
#include "syscall.h"

//Simple system call
int 
my_syscall(char *str){
    cprintf("%s\n", str);
    return 0xABCD;
}

// Wrapper for my_syscall
int
sys_my_syscall(void){
    char *str;
    cprintf("Wrapper\n");
    //Decode argument using argstr
    if(argstr(0, &str) <0)
        return -1;
    return my_syscall(str);
}
