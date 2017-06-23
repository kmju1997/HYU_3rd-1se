#include <stdio.h>
#include <stdlib.h>
#define SWAP(x, y, t) {t=x; x=y; y=t;}
#define MAX_SIZE 10
#define NAME_SIZE 32

//adjust 함수의 구현은 수업시간에 다루었고 동일한 알로기즘으로 구현되어 있음
void adjust(int heap[], int root, int n)
{  

    int j, k;

    k=heap[root];
    j=2*root;
    while ((j<=n))     /* Iterate until child exist */
    {
        if (j<n)                 /* Is right child exist? */
            if (heap[j]<heap[j+1])       /* Take bigger child */
                j=j+1;
        if (k>=heap[j])
        break;
        else{
            heap[j/2]=heap[j];          /* Swap with child */
            j=2*j;   }
    }
    heap[j/2]=k;
}

void heap_sort(int list[], int n)
{  

    int i, j;
    int temp;
    //Except leaves, take adjust function
    for(i=n/2; i>=0; i--)
        adjust(list,i,n);
    //Swap, root and rear of list
    //then re adjust root
    for(i=n-1; i>=0;i--)
    {
        SWAP(list[0], list[i+1],temp);
        adjust(list, 0, i); 
    }

}


void main()
{  
    FILE *f;
    int i;
    int list1[MAX_SIZE]; 
    f= fopen("input2.txt","r");
    fscanf(f,"%d %d %d %d %d %d %d %d %d %d",
            &list1[0],&list1[1],&list1[2],&list1[3],&list1[4],
            &list1[5],&list1[6],&list1[7],&list1[8],&list1[9]);
    //힙정렬
    heap_sort(list1, MAX_SIZE); /* 선택정렬 호출 */
    printf("heap_sort: \n");
    for(i=1; i<=MAX_SIZE; i++) printf("%d \t",list1[i] );

}
