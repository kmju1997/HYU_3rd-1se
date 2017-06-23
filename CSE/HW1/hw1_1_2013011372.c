#include <stdio.h>
#include <stdlib.h>
#define MAXNAMESIZE 100   //Max size of name


typedef struct studentT{
    char *name;
    int literature;
    int math;
    int science;
} studentT;

int main(int argc,char *argv[]) {
    int num,i;
    FILE *fp,*fp2;  //File descripter
    studentT *p_student;
    if((fp = fopen(argv[1],"r")) == NULL){  //Open input file to read
        puts("error"); //File open exception handler
        return 0;
    }
    fscanf(fp, "%d",&num); //Scan number of students
    p_student = (studentT*)malloc(sizeof(studentT)*(num+1)); //Make memory for struct of students 
    if(p_student == NULL){  //Out of memory exception handler
        puts("error");
        return 0;
    }


    for(i=0;i<num;i++){
        p_student[i].name = (char*)malloc(sizeof(char)*(MAXNAMESIZE+1)); //Make memory for name of a student
        fscanf(fp,"%s %d %d %d",p_student[i].name,  //Scan students name, score
                &p_student[i].literature,
                &p_student[i].math,
                &p_student[i].science);
    }
    fclose(fp);


    if((fp2 = fopen(argv[2],"w")) == NULL){ //Open output file to write
        puts("error"); //File open exception handler
        return 0;
    }
    fprintf(fp2,"Name\t\tLiterature\tMath\t\tScience\t\tAve.\n");
    for(i=0;i<num;i++){
        fprintf(fp2,"%-12.12s%-12d%-12d%-12d%-12.2f\n",p_student[i].name, //Print students score to output.txt
                p_student[i].literature,
                p_student[i].math,
                p_student[i].science,
                ((double)p_student[i].literature+(double)p_student[i].math+(double)p_student[i].science)/3);
    }
    fclose(fp2);
    free(p_student);
    return 0;
}
