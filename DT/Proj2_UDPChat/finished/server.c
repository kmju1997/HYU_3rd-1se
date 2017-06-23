#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/socket.h>
#include <pthread.h>
#include <signal.h>
#include <errno.h>


#define  BUFF_SIZE 1024 
#define MAX_THREAD 100
#define chop(str) str[strlen(str)-1] = 0x00;

pthread_mutex_t  mutex = PTHREAD_MUTEX_INITIALIZER;
char   g_buff_rcv[BUFF_SIZE+5];
//indicator count how many client connected.
int g_new_client_cnt = 0;
int	g_ack_rcv_flag = 0;
int g_waiting_rcv_flag = 0;
int g_timeoutflag = 0;


struct threadArg{
    int sockfd;
    struct sockaddr_in client_addr;
    char* buff_rcv;
};


//Send Data & wait until "ACK" arrive
void* SndThread(void* threadArgP){

    int sockfd;
    int client_addr_size;
    struct sockaddr_in client_addr;

    char   buff_snd[BUFF_SIZE+5];
    char   buff_rcv[BUFF_SIZE+5];
    //for select
    int timeoutflag=0;
    
       // select time out 설저을 위한 timeval 구조체	
    int state;
    struct timeval tv;
    fd_set readfds;


    pthread_mutex_lock(&mutex); //protect thread race

    //copy thread arguments to each thread stack
    struct threadArg arg = *((struct threadArg*)threadArgP);  //protect thread race
    sockfd = arg.sockfd;
    client_addr = arg.client_addr;

    pthread_mutex_unlock(&mutex);
    

    //For Sending Data from keyboard
    while(!feof(stdin)){
		// client_sockfd 의 입력검사를 위해서 
        // fd_set 에 등록한다. 
        FD_ZERO(&readfds);
        FD_SET(fileno(stdin), &readfds);
        // 약 일정시간 기다린다. 
        tv.tv_sec = 2;
        tv.tv_usec = 10;
        //~ // 입력이 있는지 기다린다. 
        state = select(fileno(stdin)+1, &readfds,
                (fd_set *)0, (fd_set *)0, &tv);
         
		switch(state)
        {
            case -1:
                perror("select error :");
                exit(0);
                
                // 만약 2초안에 아무런 입력이 없었다면 
                // Time out 발생상황이다. 
            case 0:
				if(g_new_client_cnt == 2){
					g_new_client_cnt--;
					pthread_exit(threadArgP);
			}
                continue;
                
                // 5초안에 입력이 들어왔을경우 처리한다. 
            default:
				fflush(stdout);

        }

        //if new client is connected break loop and delete this thread then make new one
        //if timeout was over, then do not get input again
            if(NULL != fgets(buff_snd,BUFF_SIZE,stdin)){
                chop(buff_snd);
			}

        //send data
        if(-1 == sendto( sockfd, buff_snd, strlen( buff_snd)+1, 0,
                    ( struct sockaddr*)&client_addr, sizeof( client_addr)))
        {
            printf("Data send error\n");
        }


        g_waiting_rcv_flag = 1;
        while(!g_ack_rcv_flag){
            if(g_timeoutflag) {
                g_timeoutflag=0;
                //send data again
                printf(" Send data %s again tid : %d\n",buff_snd,(int)pthread_self());
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
    pthread_exit(threadArgP);
}

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
    sockfd = arg.sockfd;
    client_addr = arg.client_addr;
    strcpy(buff_rcv, arg.buff_rcv);

    memset(&g_buff_rcv, 0 ,sizeof(g_buff_rcv)); //prevent using the past data


    pthread_mutex_unlock(&mutex);

    pthread_mutex_lock(&mutex); //protect thread race
    printf( "   Receive: %s   \n", buff_rcv);
    printf("Send : ");
    fflush(stdout);
    pthread_mutex_unlock(&mutex);

    //ACK isn't retransmitted'
    if(strncmp(buff_rcv,"ACK",3) == 0){
		g_ack_rcv_flag = 1;
        fflush(stdout);
        pthread_exit(0);
    }

    sprintf( buff_snd, "ACK");

    sendto( sockfd, buff_snd, strlen( buff_snd)+1, 0,  
            ( struct sockaddr*)&client_addr, sizeof( client_addr)); 

    //flush buff receive & buff send
    memset( &buff_rcv, 0, sizeof( buff_rcv));
    memset( &buff_snd, 0, sizeof( buff_snd));

    pthread_exit(threadArgP);
    return 0;

}

int  main( void)
{
    int   sock;
    int   client_addr_size;
    void* status1;
    void* status2;

    struct sockaddr_in   server_addr;
    struct sockaddr_in   client_addr;


    pthread_t tid[MAX_THREAD];
    int th_rcv_id, th_snd_id;
    int receiveByte;
    static int threadcnt=0;

    struct threadArg *threadArgRcvP;
    struct threadArg *threadArgSndP;

    threadArgRcvP =  malloc(sizeof(struct threadArg));
    threadArgSndP =  malloc(sizeof(struct threadArg));
    
    // select time out 설저을 위한 timeval 구조체	
    int state;
    struct timeval tv;
    fd_set readfds;

    //mutex 설정
    pthread_mutex_init(&mutex,NULL);
    

    sock  = socket( PF_INET, SOCK_DGRAM, 0);

    if(-1 == sock)
    {
        printf( "socket() error\n");
        exit( 1);
    }

    memset( &server_addr, 0, sizeof( server_addr));
    server_addr.sin_family     = AF_INET;
    server_addr.sin_port       = htons(7788);
    server_addr.sin_addr.s_addr= htonl( INADDR_ANY);

    if( -1 == bind(sock, (struct sockaddr*)&server_addr, sizeof( server_addr) ) )
    {
        printf( "bind() error\n");
        exit( 1);
    }

    while(1)
    {
		
                
        //For Receiving Data
        client_addr_size  = sizeof( client_addr);


			
		// client_sockfd 의 입력검사를 위해서 
        // fd_set 에 등록한다. 
        FD_ZERO(&readfds);
        FD_SET(sock, &readfds);
        // 약 일정시간 기다린다. 
        tv.tv_sec = 2;
        tv.tv_usec = 10;
        //~ // 입력이 있는지 기다린다. 
        state = select(sock+1, &readfds,
                (fd_set *)0, (fd_set *)0, &tv);
                
                switch(state)
        {
            case -1:
                perror("select error :");
                exit(0);
                
                // 만약 2초안에 아무런 입력이 없었다면 
                // Time out 발생상황이다. 
            case 0:
                if(g_waiting_rcv_flag){
                    printf("Time out error\n");
                    g_timeoutflag=1;
                }
                continue;
                
                // 5초안에 입력이 들어왔을경우 처리한다. 
            default:
				fflush(stdout);

        }
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
            threadArgRcvP->sockfd = sock;
            threadArgRcvP->client_addr = client_addr;
            threadArgRcvP->buff_rcv = g_buff_rcv;

            pthread_mutex_unlock(&mutex);

            th_rcv_id = pthread_create(&(tid[threadcnt]), NULL, RcvThread,(void *)threadArgRcvP);
            if(th_rcv_id != 0)
            {
                perror("Thread Create Error");
                return 1;
            }

            threadcnt++;
            
            //For sending data

            if(threadArgSndP->client_addr .sin_port != client_addr.sin_port ||\
                    threadArgSndP->client_addr.sin_addr.s_addr != client_addr.sin_addr.s_addr){
				g_new_client_cnt++;
                g_timeoutflag=0;
                g_waiting_rcv_flag=0;
                printf("\n\n[New client Reached.] From now on server will communicate with this  client \n");
                printf(" -[IP : %d	Port %d]-\n",client_addr.sin_addr.s_addr,client_addr.sin_port);
                printf(" wait some seconds...\n");
                sleep(1);
                fflush(stdout);

                threadArgSndP->sockfd = sock;
                threadArgSndP->client_addr = client_addr;

                th_snd_id = pthread_create(&(tid[threadcnt]), NULL, SndThread,(void *)threadArgSndP);
                if(th_snd_id != 0)
                {
                    perror("Thread Create Error");
                    return 1;
                }
            }

        }


    }
     while(1){
        //~ pthread_join(th_rcv_id,(void**)&status1);
        pthread_join(th_snd_id,(void**)&status2);
        if(status1 == 0 && status2 == 0) break;
    }
    
    close(sock);
    return 1;
}

