#include <stdio.h>
void print_binary(int num){
    int t;

    if(num <= 1){
        printf("%d",num);
        return;
    }
    t = num%2;
    print_binary(num/2);
    printf("%d",t);
}
void main(){
    int a = 4;
    int tr;
    print_binary(a);
    printf("\n");
    //printf("adf : %d\n",tr);

}
