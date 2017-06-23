#include <sys/ioctl.h> 

#include <sys/types.h> 

#include <sys/stat.h> 

#include <sys/socket.h> 

#include <unistd.h> 

#include <netinet/in.h> 

#include <arpa/inet.h> 

#include <stdio.h> 

#include <stdlib.h> 

#include <string.h> 

#include <net/if.h> 

#include <arpa/inet.h> 



int main() 

{ 

    // 이더넷 데이터 구조체 

    struct ifreq *ifr; 

    struct sockaddr_in *sin; 

    struct sockaddr *sa; 



    // 이더넷 설정 구조체 

    struct ifconf ifcfg; 

    int fd; 

    int n; 

    int numreqs = 30; 

    fd = socket(AF_INET, SOCK_DGRAM, 0); 



    // 이더넷 설정정보를 가지고오기 위해서 

    // 설정 구조체를 초기화하고  

    // ifreq데이터는 ifc_buf에 저장되며, 

    // 네트워크 장치가 여러개 있을 수 있으므로 크기를 충분히 잡아주어야 한다.  

    // 보통은 루프백주소와 하나의 이더넷카드, 2개의 장치를 가진다. 

    memset(&ifcfg, 0, sizeof(ifcfg)); 

    ifcfg.ifc_buf = NULL; 

    ifcfg.ifc_len = sizeof(struct ifreq) * numreqs; 

    ifcfg.ifc_buf = malloc(ifcfg.ifc_len); 



    for(;;) 

    { 

        ifcfg.ifc_len = sizeof(struct ifreq) * numreqs; 

        ifcfg.ifc_buf = realloc(ifcfg.ifc_buf, ifcfg.ifc_len); 

        if (ioctl(fd, SIOCGIFCONF, (char *)&ifcfg) < 0) 

        { 

            perror("SIOCGIFCONF "); 

            exit; 

        } 

        // 디버깅 메시지 ifcfg.ifc_len/sizeof(struct ifreq)로 네트워크 

        // 장치의 수를 계산할 수 있다.  

        // 물론 ioctl을 통해서도 구할 수 있는데 그건 각자 해보기 바란다. 

        printf("%d : %d \n", ifcfg.ifc_len, sizeof(struct ifreq)); 

        break; 

    } 



    // 주소를 비교해 보자.. ifcfg.if_req는 ifcfg.ifc_buf를 가리키고 있음을 

    // 알 수 있다. 

    printf("address %d\n", &ifcfg.ifc_req); 

    printf("address %d\n", &ifcfg.ifc_buf); 



    // 네트워크 장치의 정보를 얻어온다.  

    // 보통 루프백과 하나의 이더넷 카드를 가지고 있을 것이므로 

    // 2개의 정보를 출력할 것이다. 

    ifr = ifcfg.ifc_req; 

    for (n = 0; n < ifcfg.ifc_len; n+= sizeof(struct ifreq)) 

    { 

        // 주소값을 출력하고 루프백 주소인지 확인한다. 

        printf("[%s]\n", ifr->ifr_name); 

        sin = (struct sockaddr_in *)&ifr->ifr_addr; 

        printf("IP    %s %d\n", inet_ntoa(sin->sin_addr), sin->sin_addr.s_addr); 

        if ( ntohl(sin->sin_addr.s_addr) == INADDR_LOOPBACK) 

        { 

            printf("Loop Back\n"); 

        } 

        else 

        { 

            // 루프백장치가 아니라면 MAC을 출력한다. 

            ioctl(fd, SIOCGIFHWADDR, (char *)ifr); 

            sa = &ifr->ifr_hwaddr; 

            //printf("%s\n", ether_ntoa((struct ether_addr *)sa->sa_data)); 
            printf("%s\n", ((struct ether_addr *)sa->sa_data)); 

        } 

        // 브로드 캐스팅 주소 

        ioctl(fd,  SIOCGIFBRDADDR, (char *)ifr); 

        sin = (struct sockaddr_in *)&ifr->ifr_broadaddr; 

        printf("BROD  %s\n", inet_ntoa(sin->sin_addr)); 

        // 네트워크 마스팅 주소 

        ioctl(fd, SIOCGIFNETMASK, (char *)ifr); 

        sin = (struct sockaddr_in *)&ifr->ifr_addr; 

        printf("MASK  %s\n", inet_ntoa(sin->sin_addr)); 

        // MTU값 

        ioctl(fd, SIOCGIFMTU, (char *)ifr); 

        printf("MTU   %d\n", ifr->ifr_mtu); 

        printf("\n"); 

        ifr++; 

    } 

} 

          


