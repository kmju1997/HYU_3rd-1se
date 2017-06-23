//for visual studio 2013(fscanf_s problem)
#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <stdlib.h>

typedef struct Node* PtrToNode;
typedef PtrToNode List;
typedef PtrToNode Position;
typedef struct ElementType{
    int key;
    float value;
}ElementType;
struct Node{
    ElementType element;
    Position next;
};

List MakeEmpty(List L);
int IsEmpty(List L);
int isLast(Position P, List L);
void Delete(ElementType X, List L);
Position FindPrevious(ElementType X, List L);
Position Find(ElementType X, List L);
void Insert(ElementType X, List L, Position P);
void DeleteList(List L);
void PrintList(List L);

int main(int argc, char *argv[]) {
    char command;
    int key1, key2;
    FILE *input;
    ElementType in,in2; //key2의 값을 받을 ElementType in2를 정의한다.
    Position header = NULL;
    Position tmp = NULL;
    Position tmp2 = NULL;
    if(argc == 1)
        input = fopen("input.txt", "r");
    else
        input = fopen(argv[1], "r");
    header = MakeEmpty(header);
    while(1) {
        command = fgetc(input);
        if(feof(input)) break;
        switch(command) {
            case 'i':
                fscanf(input, "%d %d", &key1, &key2);
                in.key = key1;
                //duplication check
                tmp = Find(in, header);
                if(tmp != NULL) {
                    printf("There already is an element with key %d. Insertion failed\n", key1);
                    break;
                }
                    //key2가 -1이 아닐경우, in2가 key2를 가지고 in2를 리스트에서
                    //찾는다. 그리고 Insert한다. key2가 NULL인 경우는 Insert함수안에서 처리한다다.
                if(key2 != -1){ 
                    in2.key = key2;
                    tmp2 = Find(in2,header);
                    Insert(in,header,tmp2); 
                } else {
                    Insert(in, header, header);
                }
                break;
            case 'd':
                fscanf(input, "%d", &key1);
                in.key = key1;
                Delete(in, header);
                break;
            case 'f':
                fscanf(input, "%d", &key1);
                in.key = key1;
                tmp = FindPrevious(in, header);
                if(isLast(tmp, header))
                    printf("Could not find %d in the list\n", key1);
                else {
                    if(tmp->element.key>0)
                        printf("Key of the previous node of %d is %d.\n", key1, tmp->element.key);
                    else
                        printf("Key of the previous node of %d is header.\n", key1);
                }
                break;
            case 'p':
                PrintList(header);
                break;
            default:
                ;
        }
    }
    system("PAUSE");
    DeleteList(header);
    fclose(input);
    return 0;
}

//create header node
List MakeEmpty(List L) {
    L = (List)malloc(sizeof(struct Node));
    L->element.key = -30;
    L->element.value = -30.0;
    L->next = NULL;
    return L;
}
//check the list is empty when L == header(except error case)
int isEmpty(List L) {
    return L->next == NULL;
}

//check the position P is at the last of the list L
int isLast(Position P, List L) {
    Position cur = L;
    while(cur->next != NULL) {
        cur = cur->next;
    }
    return P == cur;
}

//return last position when X is not in L. else, return previous position of element X exist
Position FindPrevious(ElementType X, List L) {
    Position P = NULL;
    P = L;
    while(P->next != NULL && P->next->element.key !=X.key) {
        P = P->next;
    }
    return P;
}

//delete whole list
void DeleteList(List L) {
    Position P = NULL, Tmp = NULL;
    P = L->next; /* Header assumed */
    L->next = NULL;
    while (P != NULL)
    {
        Tmp = P->next;
        free(P);
        P = Tmp;
    }
}
//negative will be header
Position Find(ElementType X, List L) {
    Position P = NULL;
    if(X.key<0) return L;
    P = FindPrevious(X, L);
    return P->next;
}

//////////////HW2/////////////////
void Insert(ElementType X, List L, Position P) {
    Position Tmp = NULL;
    //input should be positive integer
    if(X.key<0) {
        printf("Please use positive input. %d cannot be inserted\n", X.key);
        return;
    }
    /*
       set Element value 3.14
       */
    X.value = 3.14;  // 새로 넣을 Element X의 value를 3.14로 넣어준다.
    Tmp = (Position)malloc(sizeof(struct Node));
    Tmp->element = X;
    if(P==NULL) {
        printf("Insertion(%d) Failed : cannot find the location to be inserted\n", X.key);
        free(Tmp);
        return;
    }
    Tmp->next = P->next;
    P->next = Tmp;
}


void PrintList(List L) {
    PtrToNode tmp = NULL;
    tmp = L->next;
    if(tmp==NULL) {
        printf("list is empty!\n");
        return;
    }
    //tmp의 element의 key와 value를 마지막 리스트까지 출력한다/
    while(tmp!=NULL) {
        printf("key:%d value:%.3f \t",tmp->element.key,tmp->element.value);
        tmp = tmp->next;

    }

    printf("\n");
}

void Delete(ElementType X, List L) {
    Position P = NULL, Tmp = NULL;

    P = FindPrevious(X, L);
    //삭제할 Tmp를 P->next로 지정하고, Tmp->next값을 얻어온 후 Tmp를 삭제한다.
    if (!isLast(P, L)) {
        Tmp = P->next;
        P->next = Tmp->next;
        free(Tmp);
    } else {
        printf("Deletion failed : element %d is not in the list\n", X.key);
    }
}

////////////// HW2 //////////////

