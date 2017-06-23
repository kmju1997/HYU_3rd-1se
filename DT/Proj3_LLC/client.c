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
#include <zlib.h>
#include "llc.h"
#include "mac.h"

#define chop(str) str[strlen(str)-1] = 0x00;
#define  BUFF_SIZE 600 
#define TIMEOUT_MAX_CNT 5

pthread_mutex_t  mutex = PTHREAD_MUTEX_INITIALIZER;
char   g_buff_rcv[BUFF_SIZE];

//for dest MAC
char g_dest_mac[6] = {0,0,0,0,0,0};
//for timeout
short g_ua_rcv_flag = 0;
short g_rr_rcv_flag = 0;
short g_waiting_rcv_flag = 0;
short g_timeout_cnt = 0;
short g_timeoutflag = 0;

//for sabme, disc
short g_connectedflag = 0;
short g_u_sabme_snt = 0;
short g_u_disc_snt = 0;


unsigned char g_NS;
unsigned char g_NR;


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

    //SetHexToString(llc->crc, do_crc(LLCBuffWithoutCRC(buff_snd), 514),4);
    memmove(&len,llc->length,2);
    SetLLC_CRC(llc,do_crc(buff_snd, len-4));
    //send data
    if(0 >= sendto( sockfd, buff_snd, BUFF_SIZE, 0,
                ( struct sockaddr*)&client_addr, sizeof( client_addr)))
    {
        printf("Data send error\n");
    }
}
//Snd LLC Data 
void SndLLCData(int sockfd, char buff_snd[], struct sockaddr_in client_addr, char data[]){
    LLC* llc;
    char dest[6];
    char src[6];
    char length[2];
    char dsap[1];
    char ssap[1];
    char control[2];
    char crc[4];
    int len;

    memmove(dest,g_dest_mac,6);
    findMyMac(src);
    SetHexToString(length,FRAME_LEN,2);
    SetHexToString(&control[0],0x00,1);
    SetHexToString(&control[1],0x00,1);
    memset(crc,0,4);

    MakeLLCFromBuff(buff_snd, dest, src,length,control,data,crc);
    llc = (LLC*)buff_snd;
    SetNS(llc,g_NR);
    SetNR(llc,g_NR);

    //SetHexToString(llc->crc, do_crc(LLCBuffWithoutCRC(buff_snd), 514),4);
    memmove(&len,llc->length,2);
    SetLLC_CRC(llc,do_crc(buff_snd, len-4));
    //send data
    fflush(stdout); 
    printf("\t\t\t\tNS:%d, NR:%d\n",GetNS(llc),GetNR(llc));
    fflush(stdout); 
    if(0 >= sendto( sockfd, buff_snd, BUFF_SIZE, 0,
                ( struct sockaddr*)&client_addr, sizeof( client_addr)))
    {
        printf("Data send error\n");
    }

}
void* SndThread(void* threadArgP){

    int sockfd;
    int client_addr_size;
    struct sockaddr_in client_addr;
    LLC llc;


    char   buff_rcv[BUFF_SIZE];
    char   buff_snd[BUFF_SIZE];


    //copy thread arguments to each thread stack
    pthread_mutex_lock(&mutex);  
    struct threadArg arg = *((struct threadArg*)threadArgP);  
    sockfd = arg.sockfd;
    client_addr = arg.client_addr;
    pthread_mutex_unlock(&mutex);




    //- -   -   -   -   -   -   -   -   -   -   I-Frame
    //For Sending Data from keyboard
    while(!feof(stdin)){
        if(NULL != fgets(buff_snd,BUFF_SIZE,stdin)){
            chop(buff_snd);
        }

        //- -   -   -if("start" typed) -- U_SABME
        if(strcmp(buff_snd,"start") == 0){
            SndLLCFrame(sockfd,buff_snd,client_addr,U_SABME);
            g_u_sabme_snt = 1;
            g_waiting_rcv_flag = 1;
            goto UA;
            //- -   -   if("quit" typed) -- U_DISC
        }else if(strcmp(buff_snd,"quit") == 0){
            SndLLCFrame(sockfd,buff_snd,client_addr,U_DISC);
            g_u_disc_snt = 1;
            g_waiting_rcv_flag = 1;
            goto UA;
        }else if(g_connectedflag == 1)
        {
            SndLLCData(sockfd,buff_snd,client_addr,buff_snd);
            g_waiting_rcv_flag = 1;

            //RR didn't arrive
            while(!g_rr_rcv_flag){
                if(g_timeoutflag) {
                    g_timeoutflag=0;
                    //send data again
                    if(0 >= sendto( sockfd, buff_snd, BUFF_SIZE, 0,
                                ( struct sockaddr*)&client_addr, sizeof( client_addr)))
                    {
                        printf("Data send error\n");
                    }

                    fflush(stdout);
                    continue;
                }
            }
            //RR arrived
            if(g_rr_rcv_flag){
                g_rr_rcv_flag = 0;
                g_waiting_rcv_flag = 0;
                g_timeoutflag = 0;
                memset( &buff_rcv, 0, sizeof( buff_rcv));
                memset( &buff_snd, 0, sizeof( buff_snd));
            }
            continue;
        }
        memset( &buff_rcv, 0, sizeof( buff_rcv));
        memset( &buff_snd, 0, sizeof( buff_snd));
            continue;


UA:
        //UA didn't arrive
        while(!g_ua_rcv_flag){
            if(g_timeoutflag) {
                g_timeoutflag=0;
                //send data again
                if(0 >= sendto( sockfd, buff_snd, BUFF_SIZE, 0,
                            ( struct sockaddr*)&client_addr, sizeof( client_addr)))
                {
                    printf("Data send error\n");
                }

                fflush(stdout);
                continue;
            }
        }
        //UA arrived
        if(g_ua_rcv_flag){
            g_ua_rcv_flag = 0;
            g_waiting_rcv_flag = 0;
            g_timeoutflag = 0;
            memset( &buff_rcv, 0, sizeof( buff_rcv));
            memset( &buff_snd, 0, sizeof( buff_snd));
        }
        continue;


    }
    pthread_exit(0);
}

void* RcvThread(void* threadArgP){

    int sockfd;
    int client_addr_size;
    int receiveByte;
    struct sockaddr_in client_addr;
    char   buff_rcv[BUFF_SIZE];
    char   buff_snd[BUFF_SIZE];
    LLC* llc;

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
                    g_timeout_cnt++;
                    if(g_timeout_cnt == TIMEOUT_MAX_CNT){
                        printf("\tMax Timeout count, send another packet\n");
                        fflush(stdout);
                        g_ua_rcv_flag = 1;
                        g_rr_rcv_flag = 1;
                        g_timeoutflag = 0;
                        g_timeout_cnt = 0;
                        g_waiting_rcv_flag = 0;
                        goto SEND;
                    }
                }
                continue;
                // 입력이 들어왔을경우 처리한다. 
            default:
                fflush(stdout);

        }
        recvfrom( sockfd, buff_rcv, BUFF_SIZE, 0 , ( struct sockaddr*)&client_addr, &client_addr_size);

        pthread_mutex_lock(&mutex); //protect thread race
        llc = (LLC*)buff_rcv;
        printLLC(llc);
    printf("-   -   -   -   -   CRC Check ret %d(Suc:1,Fail:0)\n",LLC_CRC_Check(buff_rcv));
        g_timeout_cnt = 0;
        // UA  
        if(FigLLCFormat(buff_rcv) == U_UA ){
            fflush(stdout);
            printf( "   [Receive]: %s   \n", CvtFmtToStr(FigLLCFormat(buff_rcv)));
            g_ua_rcv_flag = 1;
            memmove(g_dest_mac,llc->src,6);
            if(g_u_sabme_snt == 1){
                printf("        //SAB mode connected\n");
                g_connectedflag = 1;
                g_u_sabme_snt = 0;
                g_NR = 0;
            }
            if(g_u_disc_snt == 1){
                printf("        //SAB mode disconnected\n");
                g_connectedflag = 0;
                g_u_disc_snt = 0;
            }
        }
        //RR
        if(FigLLCFormat(buff_rcv) == S_RR){
            fflush(stdout);
            printf( "   [Receive]: %s\t\t      NR:%d  \n", CvtFmtToStr(FigLLCFormat(buff_rcv)), GetNR(llc));
            g_rr_rcv_flag = 1;
            g_NR = GetNR(llc);
        }


SEND:

        if(g_connectedflag ==0) printf("(Cli)[Send] (You should type \"start\" to connect)  : ");
        else printf("(Cli)[Send] (Typing \"quit\" will disconnect)  : ");
        fflush(stdout);
        pthread_mutex_unlock(&mutex); //protect thread race

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
    //IP CONFIG

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

    printf("[Cli]Send (You should type \"start\"to connect):");
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
