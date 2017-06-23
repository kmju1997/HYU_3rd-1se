#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <zlib.h>
#include "llc.h"
void main(){
    char t;
    char ts[2];
    char tss[5];
    char ze;
    char* s;

    s = "hello who";
    t = 0x03;
    SetHexToString(ts,0x0203,2);
    SetHexToString(tss,0x020304,3);
    ze = 0xff;

    if(t == 0x03)
        printf("hello??\n");
    /*
    printf("%x",ts[0]);
    printf("-%x-\n",ts[1]);
    */
    if(CmpHexToString(ts,0x0203,2))
        printf("hello!!!??\n");
    /*
    printf("%x",tss[0]);
    printf("-%x",tss[1]);
    printf("-%x-\n",tss[2]);
    */
    if(CmpHexToString(tss,0x020304,3))
        printf("WOW!!!??\n");

        printf("ze : %d\n",ze);

    uLong crc = crc32(0L, Z_NULL, 0);

       //crc = crc32(crc, buffer, length);

    printf(" crc: %lx\n",crc32(0, (const void*)s, strlen(s)));
    printf(" crc2: %lx\n",crc32(crc, (const void*)s, strlen(s)));


}
