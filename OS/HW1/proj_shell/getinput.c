#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "common.h"

#define chop(str) str[strlen(str)-1] = 0x00;

PNode InitInst(){
    Node *header;
    header = (PNode)malloc(sizeof(Node));
    return header;
}

PNode SearchInst(PNode header, int index){
    PNode temp;
    temp=header->next;
    int i;
    for(i=0;i<index;i++){
        if(temp->next != NULL){
            temp = temp->next;
        }
    }
    return temp;
}


PNode FindInstLast(PNode header){
    Node  *temp;
    temp = header;
    while(temp->next != NULL){
        temp=temp->next;
    }
    return temp;
}
void AppendInst(int len, char* p_Inst, PNode header){
    Node *temp, *LastInst;
    temp = (PNode)malloc(sizeof(Node));

    temp->p_Inst = (char*)malloc(sizeof(char)*(len+1));
    strcpy(temp->p_Inst, p_Inst);
    temp->len = len;
    LastInst = FindInstLast(header);
    LastInst->next = temp;

}

void FreeInst(PNode header){
    Node *node, *temp;
    node = header;
    while(node != NULL){
        temp=node->next;
        free(node);
        temp=node;
    }
    free(temp);
}

//"getInput()" gets a line by "fgets()" from stdin.
//and seperates a line by ';'
//then makes a list of instructions
//then return head of the list
PNode getInput(){
    char* tok;
    char buf[BUFSIZE];
    Node *header;
    header = NULL;

    memset(buf,0x00,BUFSIZE);

    if(fgets(buf,BUFSIZE,stdin) != NULL){
        chop(buf);

        tok = strtok(buf,";");
        header = InitInst(); 
        while(tok != NULL){
            AppendInst(strlen(tok), tok, header);
            tok = strtok(NULL,";");
        }


    } else{
        //If fgets encouter Ctrl+D, It terminates executing itself
        printf("\nCtrl+D was typed. Program is exiting....\n");
        exit(0);
    }
    return header;
}

//"getInputBySemi()" gets a line by "char *input" 
//and seperates a line by ';'
//then makes a list of instructions
//then return head of the list
PNode getInputBySemi(char *input){
    char* tok;
    char buf[BUFSIZE];
    Node *header;
    header = NULL;
    memset(buf,0x00,BUFSIZE);

    header = InitInst(); 
    tok = strtok(input,";");
    while(tok != NULL){
        AppendInst(strlen(tok), tok, header);
        tok = strtok(NULL,";");
    }
    return header;
}

//"getInputByLine()" gets a file path by "char *arg[]" 
//and seperates a line by "while(fgets() != NULL)"
//then makes a list of Lines 
//then return head of the list
PNode getInputByLine(char* arg){
    char buf[BUFSIZE];
    FILE *fp;
    Node *header;
    header = NULL;
    memset(buf,0x00,BUFSIZE);

    if((fp = fopen(arg,"r")) == NULL){
        printf("File open error\n");
        exit(0);
    }
    header = InitInst(); 

    while(fgets(buf,BUFSIZE,fp) != NULL){
        chop(buf);
        AppendInst(strlen(buf), buf, header);
    }

    return header;
}


