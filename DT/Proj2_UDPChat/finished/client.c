#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/socket.h>
#include <pthread.h>
#include <errno.h>

#define chop(str) str[strlen(str)-1] = 0x00;
#define  BUFF_SIZE   1024

pthread_mutex_t  mutex = PTHREAD_MUTEX_INITIALIZER;
char   g_buff_rcv[BUFF_SIZE+5];
int	g_ack_rcv_flag = 0;
int g_waiting_rcv_flag = 0;
int g_timeoutflag = 0;


struct threadArg{
    int sockfd;
    struct sockaddr_in client_addr;
    char* buff_rcv;
};


void* SndThread(void* threadArgP){

    int sockfd;
    int client_addr_size;
    struct sockaddr_in client_addr;

    char   buff_rcv[BUFF_SIZE+5];
    char   buff_snd[BUFF_SIZE+5];

    //for signal

    pthread_mutex_lock(&mutex); //protect thread race

    //copy thread arguments to each thread stack
    struct threadArg arg = *((struct threadArg*)threadArgP);  //protect thread race
    //free(threadArgP);
    sockfd = arg.sockfd;
    client_addr = arg.client_addr;

    pthread_mutex_unlock(&mutex);

    //For Sending Data from keyboard
    while(!feof(stdin)){
        if(NULL != fgets(buff_snd,BUFF_SIZE,stdin)){
            chop(buff_snd);
        }

        //send data
        if(0 >= sendto( sockfd, buff_snd, strlen( buff_snd)+1, 0,
                    ( struct sockaddr*)&client_addr, sizeof( client_addr)))
        {
            printf("Data send error\n");
        }

        g_waiting_rcv_flag = 1;
        while(!g_ack_rcv_flag){
            if(g_timeoutflag) {
                g_timeoutflag=0;
                //send data again
                if(0 >= sendto( sockfd, buff_snd, strlen( buff_snd)+1, 0,
                            ( struct sockaddr*)&client_addr, sizeof( client_addr)))
                {
                    printf("Data send error\n");
                }

                fflush(stdout);
                continue;
            }
        }
        if(g_ack_rcv_flag){
            g_ack_rcv_flag = 0;
            g_waiting_rcv_flag = 0;
            g_timeoutflag = 0;
            //flush buff receive & buff send
    memset( &buff_rcv, 0, sizeof( buff_rcv));
    memset( &buff_snd, 0, sizeof( buff_snd));
        }
        
    }
    pthread_exit(0);
}

void* RcvThread(void* threadArgP){

    int sockfd;
    int client_addr_size;
    int receiveByte;
    struct sockaddr_in client_addr;
    char   buff_rcv[BUFF_SIZE+5];
    char   buff_snd[BUFF_SIZE+5];

    // select time out 설저을 위한 timeval 구조체	
    int state;
    struct timeval tv;
    fd_set readfds;


    pthread_mutex_lock(&mutex); //protect thread race


    //copy thread arguments to each thread stack
    struct threadArg arg = *((struct threadArg*)threadArgP);  //protect thread race
    free(threadArgP);
    sockfd = arg.sockfd;
    client_addr = arg.client_addr;
    strcpy(buff_rcv, arg.buff_rcv);

    pthread_mutex_unlock(&mutex);




    while(1)
    {
        // client_sockfd 의 입력검사를 위해서 
        // fd_set 에 등록한다. 
        FD_ZERO(&readfds);
        FD_SET(sockfd, &readfds);
        // 약 5초간 기다린다. 
        tv.tv_sec = 2;
        tv.tv_usec = 10;
        //~ // 입력이 있는지 기다린다. 
        state = select(sockfd+1, &readfds,
                (fd_set *)0, (fd_set *)0, &tv);
        switch(state)
        {
            case -1:
                perror("select error :");
                exit(0);
                
                // 만약 일정시간안에 아무런 입력이 없었다면 
                // Time out 발생상황이다. 
            case 0:
                if(g_waiting_rcv_flag){
                    printf("Time out error\n");
                    g_timeoutflag=1;
                }
                continue;
                
                // 입력이 들어왔을경우 처리한다. 
            default:
				fflush(stdout);

        }

        recvfrom( sockfd, buff_rcv, BUFF_SIZE, 0 , ( struct sockaddr*)&client_addr, &client_addr_size);


        pthread_mutex_lock(&mutex); //protect thread race
        printf( "   [CLI]Receive: %s   \n", buff_rcv);
        printf("[Cli]Send : ");
        fflush(stdout);
        pthread_mutex_unlock(&mutex); //protect thread race

        //ACK isn't retransmitted'
        if(strcmp(buff_rcv,"ACK") == 0){
            g_ack_rcv_flag = 1;
            //flush buff receive & buff send
            memset( &buff_rcv, 0, sizeof( buff_rcv));
            memset( &buff_snd, 0, sizeof( buff_snd));
            continue;
        }


        sprintf( buff_snd, "ACK");

        sendto( sockfd, buff_snd, strlen( buff_snd)+1, 0,  
                ( struct sockaddr*)&client_addr, sizeof( client_addr)); 

        //flush buff receive & buff send
        memset( &buff_rcv, 0, sizeof( buff_rcv));
        memset( &buff_snd, 0, sizeof( buff_snd));
    }

    pthread_exit(0);
    return 0;

}
int  main( int argc, char **argv)
{
    int   sock;
    void* status1;
    void* status2;


    struct sockaddr_in   server_addr;


    pthread_t th_rcv_id, th_snd_id;

    struct threadArg *threadArgRcvP;
    struct threadArg *threadArgSndP;


    //mutex 설정
    pthread_mutex_init(&mutex,NULL);



    sock  = socket( AF_INET, SOCK_DGRAM, 0);

    if( -1 == sock)
    {
        printf( "socket() error\n");
        exit( 1);
    }


    memset( &server_addr, 0, sizeof( server_addr));
    server_addr.sin_family     = AF_INET;
    server_addr.sin_port       = htons(7788);
    server_addr.sin_addr.s_addr= inet_addr( "127.0.0.1");

    threadArgRcvP =  malloc(sizeof(struct threadArg));
    threadArgRcvP->sockfd = sock;
    threadArgRcvP->client_addr = server_addr;
    threadArgRcvP->buff_rcv = g_buff_rcv;


    th_rcv_id = pthread_create((&th_rcv_id), NULL, RcvThread,(void *)threadArgRcvP);
    if(th_rcv_id != 0)
    {
        perror("Thread Create Error");
        return 1;
    }


    threadArgSndP =  malloc(sizeof(struct threadArg));
    threadArgSndP->sockfd = sock;
    threadArgSndP->client_addr = server_addr;

    printf("[Cli]Send :");
    th_snd_id = pthread_create(&th_snd_id, NULL, SndThread,(void *)threadArgSndP);
    if(th_snd_id != 0)
    {
        perror("Thread Create Error");
        return 1;
    }
    while(1){
        pthread_join(th_rcv_id,(void**)&status1);
        pthread_join(th_snd_id,(void**)&status2);
        if(status1 == 0 && status2 == 0) break;
    }
    close( sock);
    return 0;
}
