#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <signal.h>
#include <errno.h>

static void sig_handler(int signo)
{
    return;
}
#define chop(str) str[strlen(str)-1] = 0x00;
#define  BUFF_SIZE   1024

int  main( int argc, char **argv)
{
    int   sock;
    int   server_addr_size;
    int timeoutflag=0;

    struct sockaddr_in   server_addr;

    char   buff_rcv[BUFF_SIZE+5];
    char   buff_snd[BUFF_SIZE+5];

    // signal 설정
    struct sigaction sigact, oldact;
    sigact.sa_handler = sig_handler;
    sigemptyset(&sigact.sa_mask);
    sigact.sa_flags = 0;
    sigact.sa_flags |= SA_INTERRUPT;

    if (sigaction(SIGALRM, &sigact, &oldact) < 0)
    {
        perror("sigaction error : ");
        exit(0);
    }

    sock  = socket( AF_INET, SOCK_DGRAM, 0);

    if( -1 == sock)
    {
        printf( "socket() error\n");
        exit( 1);
    }

    memset( &server_addr, 0, sizeof( server_addr));
    server_addr.sin_family     = AF_INET;
    server_addr.sin_port       = htons(7788);
    server_addr.sin_addr.s_addr= inet_addr( "127.10.234.1");

    while(!feof(stdin)){
        //if timeout was over, then do not get input again
        if(timeoutflag == 0){
            printf("send(type 'quit' to shut off server) : ");
            if(NULL != fgets(buff_snd,BUFF_SIZE,stdin)){
                chop(buff_snd);
            }
        }

        //send data
        if(-1 == sendto( sock, buff_snd, strlen( buff_snd)+1, 0,    
                    ( struct sockaddr*)&server_addr, sizeof( server_addr)))
        {          
            printf("Data send error\n");
        }

        //if "quit" was typed shutdown client and server 
        if(strcmp(buff_snd,"quit") == 0 ) break;


        server_addr_size  = sizeof( server_addr);

        //if data was send then, set alarm(Timeout) that limits the data receiving time
        if(strlen(buff_snd) != 0) alarm(2);
        
        if (recvfrom( sock, buff_rcv, BUFF_SIZE, 0 , 
                    ( struct sockaddr*)&server_addr, &server_addr_size) <= 0){

            //if interrupt is occured in this block, it means timeout is over
            if (errno == EINTR)
            {
                printf ("Timeout is over\n");
                printf("Retrying! \"%s\" is transmitted...\n",buff_snd);
                timeoutflag = 1;
                continue;
            }
        }

        timeoutflag = 0;
        printf( "receive: %s\n", buff_rcv);
        memset( &buff_rcv, 0, sizeof( buff_rcv));
        memset( &buff_snd, '\0', sizeof( buff_snd));
        alarm(0);
    }
    close( sock);
    return 0;
}
