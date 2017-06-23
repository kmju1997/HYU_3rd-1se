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

struct threadArg{
    int sockfd;
    struct sockaddr_in client_addr;
    char* buff_rcv;
};

void* RcvThread(void* threadArg){

    int sockfd;
    int client_addr_size;
    struct sockaddr_in client_addr;
    char   buff_rcv[BUFF_SIZE+5];
    char   buff_snd[BUFF_SIZE+5];

    pthread_mutex_lock(&mutex);

    struct threadArg *arg = (struct threadArg*)threadArg;
    sockfd = arg->sockfd;
    client_addr = arg->client_addr;
    strcpy(buff_rcv, arg->buff_rcv);

    //printf( "receive: %s\n", buff_rcv);
    printf( "receive: %s port %d\n", buff_rcv, client_addr.sin_port);
    sprintf( buff_snd, "%s", buff_rcv);
    sendto( sockfd, buff_snd, strlen( buff_snd)+1, 0,  
            ( struct sockaddr*)&client_addr, sizeof( client_addr)); 
    memset( &buff_rcv, 0, sizeof( buff_rcv));
    memset( &buff_snd, 0, sizeof( buff_snd));


    /*
       while(1){
       client_addr_size = sizeof(client_addr);

       recvfrom( sockfd, buff_rcv, BUFF_SIZE, 0 , 
       ( struct sockaddr*)&client_addr, &client_addr_size);

       if(strcmp(buff_rcv,"quit") == 0){
       printf(" Server is downed\n");
       break;
       }

       pthread_mutex_lock(&mutex);

    //printf( "receive: %s\n", buff_rcv);
    printf( "receive: %s port %d\n", buff_rcv, client_addr.sin_port);
    sprintf( buff_snd, "%s", buff_rcv);

    sendto( sockfd, buff_snd, strlen( buff_snd)+1, 0,  
    ( struct sockaddr*)&client_addr, sizeof( client_addr)); 
    memset( &buff_rcv, 0, sizeof( buff_rcv));
    memset( &buff_snd, 0, sizeof( buff_snd));

    pthread_mutex_unlock(&mutex);
    }
    */
    pthread_mutex_unlock(&mutex);
    pthread_exit(0);
    return 0;

}

int   main( void)
{
    int   sock;
    int   client_addr_size;

    struct sockaddr_in   server_addr;
    struct sockaddr_in   client_addr;

    char   buff_rcv[BUFF_SIZE+5];

    pthread_t tid[MAX_THREAD];
    int th_id;
    int receiveByte;
    static int threadcnt=0;

    struct threadArg *threadArgP;
    struct threadArg threadArg;



    sock  = socket( PF_INET, SOCK_DGRAM, 0);

    if( -1 == sock)
    {
        printf( "socket 생성 실패n");
        exit( 1);
    }

    memset( &server_addr, 0, sizeof( server_addr));
    server_addr.sin_family     = AF_INET;
    server_addr.sin_port       = htons(7788);
    server_addr.sin_addr.s_addr= htonl( INADDR_ANY);

    if( -1 == bind( sock, (struct sockaddr*)&server_addr, sizeof( server_addr) ) )
    {
        printf( "bind() 실행 에러n");
        exit( 1);
    }

    while( 1)
    {
        client_addr_size  = sizeof( client_addr);

        receiveByte = recvfrom( sock, buff_rcv, BUFF_SIZE, 0 , 
                ( struct sockaddr*)&client_addr, &client_addr_size);
        if(receiveByte > 0){

            if(strcmp(buff_rcv,"quit") == 0){
                printf(" Server is downed\n");
                break;
            }

            //if(threadArg.client_addr.sin_port !=  client_addr.sin_port){
            threadArg.sockfd = sock;
            threadArg.client_addr = client_addr;
            threadArg.buff_rcv = buff_rcv;

            threadArgP = &threadArg;
            th_id = pthread_create(&tid[threadcnt], NULL, RcvThread,(void *)threadArgP);
            if(th_id != 0)
            {
                perror("Thread Create Error");
                return 1;
            }
            pthread_detach(tid[threadcnt]);
            printf("        threadcnt : %d\n",threadcnt);
            threadcnt++;

            //pthread_join(tid,(void**)&status);
            //
        }
    }
        close(sock);
}

