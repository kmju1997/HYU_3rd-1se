#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include "common.h"

enum MODE {INTERACTIVE=0, BATCH}; //enum MODE determine Interactive mode or batch mode

int main(int argc, char* const argv[]){
    //All Lines,
    //Instructions(seperated by ';' from a line), 
    //and words(seperated by 'space'  from a Instruction) are
    //structured by Linkedlist.
    //
    //If "ls -al; pwd;" is entered
    //"ls -al; pwd;" is treated as a line
    //"ls -al;", "pwd" is treated as a instruction
    //"ls", "-al", "pwd" is treated as a word
    //
    //so "PNode header" gets head of the instruction list
    //"PNode instruction" is used to iterate the list
    //"PNode instI" is searched from the instruction list and execute the Instruction
    //
    //"int mode" gets enum MODE.
    //"int numOfInst" gets number of Instructions by iterate the list.
    //(At the same time, "PNode instruction" iterates the list)
    //
    //"int pid[MAXPID]" is pid that gets pid from "func fork" and MAXPID is defined at common.h
    // and "int i" is used for a index
    //
    //(----In INTERACTIVE mode---
    //When the parent process completes making all child by fork. 
    //then, it waits all child. by "int j" that used to iterate the pid[].
    //--------------)
    //
    //(----In BATCH mode---
    //When the parent process completes making a child by fork. 
    //then, it waits a child. and waits a child, then forks another child 
    //--------------)
    //
    //"int status" gets exit status of a child
    PNode instruction, instI, header;
    int mode, numOfInst=0; 
    int pid[MAXPID];
    int i,j;
    int status;

    //Determine INTERACTIVE mode or BATCH mode by if conditional
    if(argc == 1){
        mode = INTERACTIVE;
    }else if(argc <= 2){
        mode = BATCH;
    }

    if(mode == INTERACTIVE){

        while(1){
            //Print a prompt
            //gets the list of instructions seperated by ';' by "getInput()"
            //header points header of the list
            prompt(); 
            instruction = getInput(); 
            header = instruction; 

            // iterates the list and increases numOfInst
            while(instruction->next != NULL){
                instruction=instruction->next;
                numOfInst++;
            }


            //Depending on numOfInst, forks a child or children 
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
                                exit(0);
                            }
                        }
                        numOfInst=0;
                    }
                }
            }
        }
    }else if(mode == BATCH){
        // In BATCH bode, "PNode instruction is treated as a line"
        // so getInputByLine return the list of lines,
        // "PNode header" gets head of the list of lines,
        // "PNode instI" gets a line of a input file
        // "int numOfInst" gets the number of a input file
        instruction = getInputByLine(argv[1]);
        header = instruction;
        while(instruction->next != NULL){
            instruction=instruction->next;
            numOfInst++;
        }

        //Depending on numOfInst(the number of lines), forks a child or children 
        for(i=0;i<numOfInst;i++){
            pid[i]=fork();

            if (pid[i] == -1)
            {
                perror("fork error ");
                exit(0);
            }
            //Child process
            //Search a line that consistent with pid[i];
            //From top to bottom in "a input file", pid[i] executes "a line" of a input file
            //
            //"executeLine()" separates a line by ";" by "getInputBySemi()"
            //then, execute a instruction that comes from "getInputBySemi()"
            else if (pid[i] == 0)
            {
                instI = SearchInst(header,i);
                executeLine(instI->p_Inst);
            }
            //Parent process 
            //When the parent process completes making a child by fork. 
            //then, it waits a child. and waits a child, then forks another child 
            //
            //and If word "quit" is found at "execute()" 
            //"execute()" makes a child exit by "exit(QUIT)"
            //and a parent gets the exit() status of a child by "WEXITSTATUS()"
            //then If exit status of a child is equal to QUIT
            //then a parent exits process
            else
            {
                wait(&status);
                if(WEXITSTATUS(status) == QUIT){
                    exit(0);
                }
            }

        }

    }

    return 0;
}


