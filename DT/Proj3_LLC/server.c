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
#include <zlib.h>
#include "llc.h"
#include "mac.h"


#define  BUFF_SIZE 600
#define MAX_THREAD 100
#define chop(str) str[strlen(str)-1] = 0x00;

pthread_mutex_t  mutex = PTHREAD_MUTEX_INITIALIZER;
char   g_buff_rcv[BUFF_SIZE];
//For indicate that new client connected.
int g_new_client_cnt = 0;

//For timeout
int	g_ack_rcv_flag = 0;
int g_waiting_rcv_flag = 0;
int g_timeoutflag = 0;

//For LLC 
int g_disc_flag = 0;
unsigned char g_NS;
unsigned char g_NR=0;

//For dest Mac
char g_dest_mac[6] = {0,0,0,0,0,0};

struct threadArg{
    int sockfd;
    struct sockaddr_in client_addr;
    char* buff_rcv;
};
//Snd LLC Frame
void SndLLCFrame(int sockfd, char buff_snd[], struct sockaddr_in client_addr, int frame ){
    LLC* llc;
    char dest[6];
    char src[6];
    char length[2];
    char dsap[1];
    char ssap[1];
    char control[2];
    char data[496];
    char crc[4];
    int len;

        llc = (LLC*)buff_snd;
   memmove(dest,g_dest_mac,6); 
    findMyMac(src);
    memset(data,0,496);
    memset(crc,0,4);
    SetHexToString(length,FRAME_LEN,2);
    SetHexToString(&control[0],frame,1);
    SetHexToString(&control[1],0x00,1);
    MakeLLCFromBuff(buff_snd, dest, src,length,control,data,crc);
    if(frame == S_RR){
        SetNR(llc,g_NR+1);
    }

    //SetHexToString(llc->crc, do_crc(LLCBuffWithoutCRC(buff_snd), 514),4);
    //SetLLC_CRC(llc,do_crc(LLCBuffWithoutCRC(buff_snd), 514));
    memmove(&len,llc->length,2);
    SetLLC_CRC(llc,do_crc(buff_snd, len-4));
    //send data
    if(0 >= sendto( sockfd, buff_snd, BUFF_SIZE, 0,
                ( struct sockaddr*)&client_addr, sizeof( client_addr)))
    {
        printf("Data send error\n");
    }
    if(FigLLCFormat(buff_snd) == S_RR){
        printf( "(Server)[Send]: %s,\t\t\t      NR:%d\n", CvtFmtToStr(FigLLCFormat(buff_snd)), GetNR(llc));
    }else printf( "(Server)[Send]: %s   \n", CvtFmtToStr(FigLLCFormat(buff_snd)));
}

//	–	UDP 패킷이 오면 오는 즉시 패킷을 받고 화면에 표시해주는 기능
void* RcvThread(void* threadArgP){

    int sockfd;
    struct sockaddr_in client_addr;
    char   buff_rcv[BUFF_SIZE];
    char   buff_snd[BUFF_SIZE];
    LLC* llc;

    //copy thread arguments to each thread stack
    pthread_mutex_lock(&mutex); 
    struct threadArg arg = *((struct threadArg*)threadArgP);  
    sockfd = arg.sockfd;
    client_addr = arg.client_addr;
    memmove(buff_rcv, arg.buff_rcv,BUFF_SIZE);
    memset(&g_buff_rcv, 0 ,sizeof(g_buff_rcv)); //prevent using the past data
    pthread_mutex_unlock(&mutex);

    pthread_mutex_lock(&mutex); //protect thread race
    llc = (LLC*)buff_rcv;
    memmove(g_dest_mac,llc->src,6);
    printLLC(llc);
    printf("-   -   -   -   -   CRC Check ret %d(Suc:1,Fail:0)\n",LLC_CRC_Check(buff_rcv));
    if(FigLLCFrame(buff_rcv) == U_FRAME){
        if(FigLLCFormat(buff_rcv) == U_SABME){
            printf( "   [Receive]: %s\n", CvtFmtToStr(FigLLCFormat(buff_rcv)));
            printf("        //SAB mode connected\n");
            fflush(stdout);
            SndLLCFrame(sockfd,buff_snd,client_addr,U_UA);
        }
        //- -   -   U_DISC
        if(FigLLCFormat(buff_rcv) == U_DISC){
            printf( "   [Receive]: %s\n", CvtFmtToStr(FigLLCFormat(buff_rcv)));
            printf("        //SAB mode disconnected\n");
            fflush(stdout);
            SndLLCFrame(sockfd,buff_snd,client_addr,U_UA);
            g_disc_flag = 1;
            exit(0);
        }

    }

    if(FigLLCFrame(buff_rcv) == I_FRAME){
        printf( "   [Receive]: %s, \t\t\tNS:%d, NR:%d\n", FigLLCData(buff_rcv),GetNS(llc),GetNR(llc));
        fflush(stdout);
        g_NR = GetNR(llc);
        SndLLCFrame(sockfd,buff_snd,client_addr,S_RR);
    }
    
    pthread_mutex_unlock(&mutex);

    //flush buff receive & buff send
    memset( &buff_rcv, 0, sizeof( buff_rcv));
    memset( &buff_snd, 0, sizeof( buff_snd));

    pthread_exit(0);
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

    threadArgRcvP =  malloc(sizeof(struct threadArg));

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
    //IP CONFIG

    if( -1 == bind(sock, (struct sockaddr*)&server_addr, sizeof( server_addr) ) )
    {
        printf( "bind() error\n");
        exit( 1);
    }

    while(1)
    {

        //For Receiving Data
        client_addr_size  = sizeof( client_addr);

        /*
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
        */
        receiveByte = recvfrom( sock, g_buff_rcv, BUFF_SIZE, 0 , 
                ( struct sockaddr*)&client_addr, &client_addr_size);
        if(receiveByte > 0){



            pthread_mutex_lock(&mutex); //protect thread race



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

        }
            pthread_join(th_rcv_id,(void**)&status1);
            if(g_disc_flag == 1) exit(0);
    }

    close(sock);
    return 1;
}

