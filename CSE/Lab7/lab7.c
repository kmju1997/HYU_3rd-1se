#include <stdio.h>
#define MAX_ELEMENT 10

typedef struct {
    int key;
} element;


typedef struct {
    element heap[MAX_ELEMENT];
    int heap_size;
} HeapType;

init(HeapType *h)
{
    h->heap_size =0;
};

print_heap(HeapType *h)
{
    int i;
    int level=1;
    printf("\n===================");
    for(i=1;i<=h->heap_size;i++){
        if( i == level ) {
            printf("\n");
            level *= 2;
        }
        printf("\t%d", h->heap[i].key);
    }
    printf("\n===================");
}


void insert_max_heap(HeapType *h, element item)
{
    int i;
    element tmp;

    // 히프의 크기를 하나 증가 시킨다.
    h->heap_size++;
    // // 트리를 거슬러 올라가면서 부모 노드와 비교
    for(i=h->heap_size;i>=1;i/=2){
        if(h->heap[i/2].key < h->heap[i].key) break;
        h->heap[i].key = h->heap[i/2].key;
    }
    h->heap[i] = item;

} 
element delete_max_heap(HeapType *h)
{
    int parent, child, tmp;
    element item;
    item = h->heap[1];
    parent = 1;
    child = 2;

    item = h->heap[1];

    h->heap[1].key = h->heap[h->heap_size].key;
    h->heap_size--;
    while(child <= h->heap_size && h->heap[parent].key < h->heap[child].key){
        if(h->heap[child].key < h->heap[child+1].key){
            child = child+1;
        }

        tmp = h->heap[parent].key;
        h->heap[parent].key = h->heap[child].key;
        h->heap[child].key = tmp;
        parent = child;
        child = parent*2;
    }
    return item;
}


void main()
{
    element e1 = { 10 }, e2 = { 5 }, e3 = { 30 };
    element d1;
    HeapType heap;// 히프 생성

    init(&heap);// 초기화

    insert_max_heap(&heap, e1);
    insert_max_heap(&heap, e2);
    insert_max_heap(&heap, e3);
    print_heap(&heap);

    d1 = delete_max_heap(&heap);
    printf("\n <del. %d > \n", d1.key);
    print_heap(&heap);
}
