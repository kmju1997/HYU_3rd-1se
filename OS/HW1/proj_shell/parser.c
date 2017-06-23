#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "common.h"


PWord InitWord(){
    Word *header;
    header = (PWord)malloc(sizeof(Word));
    return header;
}

PWord FindWordLast(PWord header){
    Word  *temp;
    temp = header;
    while(temp->next != NULL){
        temp=temp->next;
    }
    return temp;
}
void AppendWord(int len, char* p_Word, PWord header){
    Word *temp, *LastWord;
    temp = (PWord)malloc(sizeof(Word));

    temp->p_Word = (char*)malloc(sizeof(char)*(len+1));
    strcpy(temp->p_Word, p_Word);
    temp->len = len;
    LastWord = FindWordLast(header);
    LastWord->next = temp;

}

void FreeWord(PWord header){
    Word *Word, *temp;
    Word = header;
    while(Word != NULL){
        temp=Word->next;
        free(Word);
        temp=Word;
    }
    free(temp);
}

//"parseSpace()" gets a instruction by "char* p_Inst"
//and seperates a instruction by 'space'
//then makes a list of words 
//then return head of the list
PWord parseSpace(char* p_Inst){
    char* tok;
    Word *header;
    tok = strtok(p_Inst," ");
    header = InitWord(); 
    while(tok != NULL){
        AppendWord(strlen(tok), tok, header);
        tok = strtok(NULL," ");
    }
    return header;
}
