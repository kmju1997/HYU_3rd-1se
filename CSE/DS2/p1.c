#include<stdio.h>
#include<stdlib.h>

void swap(int **a, int**b){
    int *temp = *a;
    *a = *b;
    *b = temp;
}
int main(){
    int **a,**b;
    int *pa;
    pa=(int*)malloc(sizeof(int)*5);
    int *pb;
    pb=(int*)malloc(sizeof(int)*5);
    a=&pa;
    b=&pb;
    printf("variable A, B ");
    scanf("%d %d",*a,*b);
    swap(a,b);

    printf("After Swap A : %d, B : %d\n",**a,**b);

    return 0;
}
