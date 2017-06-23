#define BUFSIZE 256
#define MAXINST 100
#define MAXWORD 10
#define MAXPID 10

typedef struct Inst Node;
typedef struct Inst* PNode;

typedef struct SWord Word;
typedef struct SWord* PWord;

struct Inst{
    int len;
    char *p_Inst;
    struct Inst *next;
};
struct SWord{
    int len;
    char *p_Word;
    struct SWord *next;
};

enum EXECRETURN { DEFAULT, QUIT };

PNode InitInst();
PNode SearchInst(PNode header, int index);
PNode FindInstLast(PNode header);
void AppendInst(int len, char* p_Inst, PNode header);
void FreeInst(PNode header);
PNode getInput();
PNode getInputBySemi(char *input);
PNode getInputByLine(char* arg);
PWord InitWord();
PWord FindWordLast(PWord header);
void AppendWord(int len, char* p_Word, PWord header);
void FreeWord(PWord header);
PWord parseSpace(char* p_Inst);
void execute(char* p_Inst);
void executeLine(char* p_Inst);
void prompt();

