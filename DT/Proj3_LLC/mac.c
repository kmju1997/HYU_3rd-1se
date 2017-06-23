#include <sys/ioctl.h>
#include <net/if.h>
#include <unistd.h>
#include <netinet/in.h>
#include <string.h>
void reverse6Byte(char t[]){
    int i, j;
    char tmp[6];
    memcpy(tmp,t,6);
    for(i=0; i<6;i++){
        j = 5-i;
        t[i] = tmp[j]; 
    }
}
int findMyMac(char target[])
{
    struct ifreq ifr;
    struct ifconf ifc;
    char buf[1024];
    int success = 0;
    int i;

    int sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_IP);
    if (sock == -1) {  return -1; }

    ifc.ifc_len = sizeof(buf);
    ifc.ifc_buf = buf;
    if (ioctl(sock, SIOCGIFCONF, &ifc) == -1) {  return -1;  }

    struct ifreq* it = ifc.ifc_req;
    const struct ifreq* const end = it + (ifc.ifc_len / sizeof(struct ifreq));

    for (; it != end; ++it) {
        strcpy(ifr.ifr_name, it->ifr_name);
        if (ioctl(sock, SIOCGIFFLAGS, &ifr) == 0) {
            if (! (ifr.ifr_flags & IFF_LOOPBACK)) { // don't count loopback
                if (ioctl(sock, SIOCGIFHWADDR, &ifr) == 0) {
                    success = 1;
                    break;
                }
            }
        }
        else {  return -1; }
    }

    unsigned char mac_address[6];

    if (success){
        memcpy(mac_address, ifr.ifr_hwaddr.sa_data, 6);
    }
    reverse6Byte(mac_address);
    memmove(target,mac_address,6);
    /*
    for(i=0; i<6; i++)
    printf("%x",mac_address[i]);
    printf("\n");
    */
    return 0;
    
}

