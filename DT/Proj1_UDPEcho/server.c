#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <pthread.h>

#define  BUFF_SIZE  4096 
#define MAX_THREAD 100

pthread_mutex_t  mutex = PTHREAD_MUTEX_INITIALIZER;
char   g_buff_rcv[BUFF_SIZE+5];

struct threadArg{
    int sockfd;
    struct sockaddr_in client_addr;
    char* buff_rcv;
};

//	–	UDP 패킷이 오면 오는 즉시 패킷을 받고 화면에 표시해주는 기능
void* RcvThread(void* threadArgP){

    int sockfd;
    int client_addr_size;
    struct sockaddr_in client_addr;
    char   buff_rcv[BUFF_SIZE+5];
    char   buff_snd[BUFF_SIZE+5];

    pthread_mutex_lock(&mutex); //protect thread race

    //copy thread arguments to each thread stack
    struct threadArg arg = *((struct threadArg*)threadArgP);  //protect thread race
    free(threadArgP);
    sockfd = arg.sockfd;
    client_addr = arg.client_addr;
    strcpy(buff_rcv, arg.buff_rcv);

    memset(&g_buff_rcv, 0 ,sizeof(g_buff_rcv)); //prevent using the past data

    pthread_mutex_unlock(&mutex);

    printf( "receive: %s  \t\t port %d\n", buff_rcv, client_addr.sin_port);
    printf("                                tid %u\n",(unsigned int)pthread_self());
    sprintf( buff_snd, "%s", buff_rcv);

    sendto( sockfd, buff_snd, strlen( buff_snd)+1, 0,  
            ( struct sockaddr*)&client_addr, sizeof( client_addr)); 

    //flush buff receive & buff send
    memset( &buff_rcv, 0, sizeof( buff_rcv));
    memset( &buff_snd, 0, sizeof( buff_snd));

    pthread_exit(0);
    return 0;

}

int   main( void)
{
    int   sock;
    int   client_addr_size;

    struct sockaddr_in   server_addr;
    struct sockaddr_in   client_addr;


    pthread_t tid[MAX_THREAD];
    int th_id;
    int receiveByte;
    static int threadcnt=0;

    struct threadArg *threadArgP;



    sock  = socket( PF_INET, SOCK_DGRAM, 0);

    if( -1 == sock)
    {
        printf( "socket() error\n");
        exit( 1);
    }

    memset( &server_addr, 0, sizeof( server_addr));
    server_addr.sin_family     = AF_INET;
    server_addr.sin_port       = htons(7788);
    server_addr.sin_addr.s_addr= htonl( INADDR_ANY);

    if( -1 == bind( sock, (struct sockaddr*)&server_addr, sizeof( server_addr) ) )
    {
        printf( "bind() error\n");
        exit( 1);
    }

    while( 1)
    {
        client_addr_size  = sizeof( client_addr);


        receiveByte = recvfrom( sock, g_buff_rcv, BUFF_SIZE, 0 , 
                ( struct sockaddr*)&client_addr, &client_addr_size);
        if(receiveByte > 0){


            pthread_mutex_lock(&mutex); //protect thread race

            //If "quit" was received then shutdown server program
            if(strcmp(g_buff_rcv,"quit") == 0){
                printf(" Server is downed\n");
                break;
            }

            //prepare for new thread argumnets
            threadArgP =  malloc(sizeof(struct threadArg));
            threadArgP->sockfd = sock;
            threadArgP->client_addr = client_addr;
            threadArgP->buff_rcv = g_buff_rcv;

            pthread_mutex_unlock(&mutex);

            th_id = pthread_create(&(tid[threadcnt]), NULL, RcvThread,(void *)threadArgP);
            if(th_id != 0)
            {
                perror("Thread Create Error");
                return 1;
            }
            threadcnt++;

        }
    }
    close(sock);
}

