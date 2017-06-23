#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include "common.h"

//"execute()" gets a Instruction by "char* p_Inst"
//"parseSpace()" return a list of words
//and "PWord inWord" gets the list
//then copy it to word[i]
//
//lastly, executes "execvp()" passing word[]
//
//If word "quit" is found at "execute()"
//"execute()" makes a child exit by "exit(QUIT)"
//
//If a instruction isn't executed by "execvp()"
//then prints a error message

void execute(char* p_Inst){
    PWord inWord;
    char *word[MAXWORD];
    char *temp;
    int i=0;
    temp = strdup(p_Inst);
    inWord = parseSpace(temp);
    while(inWord->next != NULL){
        inWord=inWord->next;
        word[i] = strdup(inWord->p_Word);
        i++;
    }
    word[i]=NULL;

    if (execvp(word[0],word) == -1){
        if(!strcmp(word[0],"quit")){
            printf("Warning!! :\"quit\" was typed. Program will be shutdown soon...\n");
            exit(QUIT);
        }
        printf("!!!!! Instruction : \"%s\" occured error\n", *word);
        exit(0);
    }

}


//"executeLine()" separates a line by ";" by "getInputBySemi()"
//then, execute a instruction that comes from "getInputBySemi()"
//by execute()
//
//If word "quit" is found at "execute()"
//"execute()" makes a child exit by "exit(QUIT)"
//and a parent gets the exit() status of a child by "WEXITSTATUS()"
//then If exit status of a child is equal to QUIT
//then a parent exits process

void executeLine(char* p_Inst){
    PNode header, instruction, instI;
    int status, numOfInst=0; 
    int pid[10];
    int i=0, j=0;

    printf("%s\n",p_Inst);
    instruction = getInputBySemi(p_Inst);
    header = instruction;
    while(instruction->next != NULL){
        instruction=instruction->next;
        numOfInst++;
    }

    for(i=0;i<numOfInst;i++){
        pid[i]=fork();

        if (pid[i] == -1)
        {
            perror("fork error ");
            exit(0);
        }
        //Child process
        //Search "a instruction" that is consistent with pid[i];
        //From left to right in "a line", pid[i] executes "a instruction"
        else if (pid[i] == 0)
        {
            instI = SearchInst(header,i);
            execute(instI->p_Inst);
        }

        //Parent process
        //When the parent process completes making all child by fork.
        //then, it waits all child. by "int j" that used to iterate the pid[].
        //then, it gets the exit() status of a child
        //
        //and If word "quit" is found at "execute()"
        //"execute()" makes a child exit by "exit(QUIT)"
        //and a parent gets the exit() status of a child by "WEXITSTATUS()"
        //then If exit status of a child is equal to QUIT
        //then a parent exits process
        else
        {
            if(i == numOfInst-1) {
                for(j=0;j<numOfInst;j++){
                    waitpid(pid[j],&status,0);
                    if(WEXITSTATUS(status) == QUIT){
                        exit(QUIT);
                    }
                }
                numOfInst=0;
                exit(0);
            }
        }
    }
}

