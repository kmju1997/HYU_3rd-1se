#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <zlib.h>
#include "llc.h"

#define BUFF_SIZE 518

void SetLLC(LLC* llc, char dest[], char src[], char length[],\
        char control[], char data[], char crc[]){
    short len = strlen(data)+ 22;
    //short len = 518;
    memmove(llc->dest, dest,6);
    memmove(llc->src, src,6);
    memmove(llc->length, &len,2);
    llc->dsap[0] = 0x00;
    llc->ssap[0] = 0x00;
    memmove(llc->control, control,2);
    memmove(llc->data, data,496);
    memmove(llc->crc, crc,4);
}

void MakeLLCFromBuff(char* buff,  char dest[], char src[], char length[],\
        char control[], char data[], char crc[]){
    int i;
    LLC llc;
    SetLLC(&llc, dest, src, length, control, data, crc);
    //SetHexToString(llc.crc, (int)crc32(0,LLCBuffWithoutCRC(buff),BUFF_SIZE-4),4);
        memmove(buff,&llc, 518);
    buff[518] = '\0';
}
void SetHexToString(char* target, int value, int n){
    int i;
    /*
    for(i = n-1; i >= 0; i--){
        //target[i] = value & 0xff;
        memset(&target[i],value & 0xff,1);
        value = value >> 8;
    }
    memset(&target[n],'9',1);
    */
    memmove(target,&value,n);
   
}
//Same : 1, Different : 0
int CmpHexToString(char* target, int value, int n){
    int i;
    for(i = n-1; i >= 0; i--){
        if(target[i] != (value & 0xff)){
            return 0;
        }
        value = value >> 8;
    }
    return 1;
}

void CopyLLCFromBuff(LLC* llc, char* buff){
    memmove(llc,buff,518);
}

void SetNS(LLC* llc, char value){
    llc->control[0] = llc->control[0] | (value << 1);
}
char GetNS(LLC* llc){
    return (llc->control[0] >> 1) & 0x7f;
}
void SetNR(LLC* llc, char value){
    llc->control[1] = llc->control[1] | (value << 1);
}
char GetNR(LLC* llc){
    return (llc->control[1] >> 1) & 0x7f;
}
//Figure LLC Frame
int FigLLCFrame(char buff_rcv[]){
    LLC* llc;
    char control0;
    
    llc = (LLC*)buff_rcv;
    control0 = I_FRAME_MASK(llc->control[0]);
    if(CmpHexToString(&control0,I_FRAME,1)){
        return I_FRAME;
    }
    control0 = C_FRAME_MASK(llc->control[0]);
    if(CmpHexToString(&control0,S_FRAME,1)){
        return S_FRAME;
    }
    if(CmpHexToString(&control0,U_FRAME,1)){
        return U_FRAME;
    }
    return 0;
}
int FigLLCFormat(char buff_rcv[]){
    LLC* llc;
    char control0;
    
    llc = (LLC*)buff_rcv;
    control0 = llc->control[0];
    if(CmpHexToString(&control0,U_SABME,1)){
        return U_SABME;
    }
    if(CmpHexToString(&control0,U_DISC,1)){
        return U_DISC;
    }
    if(CmpHexToString(&control0,U_UA,1)){
        return U_UA;
    }
    if(CmpHexToString(&control0,S_RR,1)){
        return S_RR;
    }
    if(CmpHexToString(&control0,S_RNR,1)){
        return S_RNR;
    }
    return 0;
}
char* FigLLCData(char buff_rcv[]){
    LLC* llc;
    char* ret;
    ret = malloc(sizeof(char)*500);
    
    llc = (LLC*)buff_rcv;
    ret = llc->data;
    return ret;
}

char* CvtFmtToStr(int format){
    char* ret;
    ret = malloc(sizeof(char)*100);

    if(format == U_SABME){
        ret = "U_SABME";
    }
    if(format == U_DISC){
        ret = "U_DISC";
    }
    if(format == U_UA){
        ret = "U_UA";
    }
    if(format == S_RR){
        ret = "S_RR";
    }
    if(format == S_RNR){
        ret = "S_RNR";
    }
    return ret;
}
//For Debugging
void printLLC(LLC* llc){
    int i;
    short len;
    char crc[4];
    printf("-   -   -   -   -   LLC Received-   -   -   -   -   -   -   -   -   -\n");
    printf("\t\t");
    printf("Dest:");
    for(i=5;i>=0;i--) printf("%.2x ",llc->dest[i]);
    printf("\n");


    printf("\t\t");
    printf("Src:");
    for(i=5;i>=0;i--)printf("%.2x ",llc->src[i]);
    printf("\n");

    printf("\t\t");
    printf("Length:");
    memmove(&len,llc->length,2);
    printf("%d",len);
    //for(i=1;i>=0;i--) printf("%.2x ",llc->length[i]);
    printf("\n");

    printf("\t\t");
    printf("Dsap:");
    for(i=0;i>=0;i--) printf("%.2x ",llc->dsap[i]);
    printf("\n");

    printf("\t\t");
    printf("Ssap:");
    for(i=0;i>=0;i--) printf("%.2x ",llc->ssap[i]);
    printf("\n");

    printf("\t\t");
    printf("Control:");
    for(i=1;i>=0;i--) printf("%.2x ",llc->control[i]);
    printf("\n");

    printf("\t\t");
    printf("Data:");
    for(i=20;i>=0;i--) printf("%.2x ",llc->data[i]);
    printf("\n");

    /*
    printf("\t\t");
    printf("crc:");
    for(i=3;i>=0;i--) printf("%.2x ",llc->crc[i]);
    printf("\n");
    */
    printf("\t\t");
    printf("crc:");
    GetLLC_CRC(llc,crc);
    for(i=3;i>=0;i--) printf("%.2x ",crc[i]);
    printf("\n");
}
char* LLCBuffWithoutCRC(char buff[]){
    char* data;
    data = malloc(sizeof(char)*514);

    memmove(data,buff,514);
    return data;


}
int do_crc(char *bytes, int n)
{
    int i;
    int crc = crc32(0L, Z_NULL, 0);

    for (i = 0; i < n; ++i)
    {
        crc = crc32(crc, bytes + i, 1);
    }

    return crc;
}
//ERROR : 0, SUCCESS : 1
int LLC_CRC_Check(char buff[]){
    LLC* llc;
    char tmp_crc[4];
    char llc_crc[4];
    int i;
    int len;

    llc = (LLC*)buff;
    memmove(&len,llc->length,2);

    //SetHexToString(tmp_crc, (int)crc32(0,LLCBuffWithoutCRC(buff),BUFF_SIZE-4),4);
    SetHexToString(tmp_crc, do_crc(buff, len-4),4);
    GetLLC_CRC(llc,llc_crc);

    printf("\t\t");
    printf("checked_crc:");
    for(i=3;i>=0;i--) printf("%.2x ",tmp_crc[i]);
    printf("\n");

    //if(memcmp(tmp_crc,llc->crc,4) == 0)return 0;
    /*
    */
    for(i=0;i<4;i++){
        if(tmp_crc[i] != llc_crc[i]){
            printf("fail in %d\n",i);
            return 0;
        }
    }

    return 1;
}
void SetLLC_CRC(LLC* llc, int value){
    short len;
    char* iter;
    iter = (char*)llc;
    memmove(&len,llc->length,2);
    memmove(&iter[len-4],&value,4);
}
void GetLLC_CRC(LLC* llc, char tgt[]){
    short len;
    char* iter;
    iter = (char*)llc;
    memmove(&len,llc->length,2);
    memmove(tgt,&iter[len-4],4);

}
