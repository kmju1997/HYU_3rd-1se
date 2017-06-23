#include <stdio.h>
#include <stdlib.h>

void SWAP(char *a, char *b) {
    int temp = *a;
    *a=*b;
    *b=temp;
}
void perm(char *list,   int i,  int n) { 
  int j; 
  if (i==n) { 
    for(j=0;  j<=n;  j++)  
  printf("%c", list[j]); 
    printf("\n");  
           }   
  else { 
    for(j=i;  j<=n;  j++) { 
      SWAP(&list[i], &list[j]); 
      perm(list,  i+1,  n); 
      SWAP(&list[i], &list[j]); 
    } 
  } 
}
int main() {
    char *list;
    int len, i=0;
    list = (char*)malloc(sizeof(char)*10);
    fgets(list,sizeof(list),stdin);
    printf("\n");
    while(list[i] != '\0') {
        i++;
    }
    len = i;
    list[--len]='\0';
//    printf("hello : %s",list);
    perm(list,0,len-1);

    return 0;
}
