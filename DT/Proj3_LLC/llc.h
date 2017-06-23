#ifndef __LLC_H
#define __LLC_H


#define C_FRAME_MASK(control0) (control0  & 0x03)
#define I_FRAME_MASK(control0) (control0 & 0x01)

#define FRAME_LEN 0x0206

#define U_FRAME 0x03
#define S_FRAME 0x02
#define I_FRAME 0x00

#define U_SABME 0x6f
#define U_DISC 0x43
#define U_UA 0x63

#define S_RR 0x01
#define S_RNR 0x05


typedef struct LLC{
    char dest[6];
    char src[6];
    char length[2];
    char dsap[1];
    char ssap[1];
    unsigned char control[2];
    unsigned char data[496];
    char crc[4];

}LLC;

void SetLLC(LLC* llc, char dest[], char src[], char length[],\
        char control[], char data[], char crc[]);
void MakeLLCFromBuff(char* buff,  char dest[], char src[], char length[],\
        char control[], char data[], char crc[]);
void CopyLLCFromBuff(LLC* llc, char* buff);
void SetHexToString(char* target, int value, int n);
int CmpHexToString(char* target, int value, int n);
void SetNS(LLC* llc, char value);
char GetNS(LLC* llc);
void SetNR(LLC* llc, char value);
char GetNR(LLC* llc);
int FigLLCFrame(char buff_rcv[]);
int FigLLCFormat(char buff_rcv[]);
char* CvtFmtToStr(int format);
char* FigLLCData(char buff_rcv[]);
void printLLC(LLC* llc);
char* LLCBuffWithoutCRC(char buf[]);
int do_crc(char *bytes, int n);
int LLC_CRC_Check(char buff[]);
void SetLLC_CRC(LLC* llc, int value);
void GetLLC_CRC(LLC* llc, char tgt[]);
#endif //__LLC_H
