#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef int element;
typedef struct ListNode{
    element data;
    struct ListNode *link;
} ListNode;

void error(char *message){
    fprintf(stderr,"%s\n", message);
    exit(1);
}

ListNode *create_node(element data, ListNode *link){
    ListNode *new_node;
    new_node = (ListNode*)malloc(sizeof(ListNode));
    if(new_node == NULL) error("malloc err");
    new_node->data = data;
    new_node->link =link;
    return(new_node);
}

void insert_node(ListNode **phead, ListNode *p, ListNode *new_node){
    ListNode *temp;
    if(*phead == NULL){
        *phead = new_node;
    }else if(p == NULL){
        temp = *phead;
        while(temp->link != NULL){
            temp = temp->link;
        }
        temp->link = new_node;

    }else {
        new_node->link = p->link;
        p->link = new_node;
    }
}
void display(ListNode *head){
    ListNode *p = head;
    while(p != NULL){
        printf("%d->",p->data);
        p = p->link;
    }
    printf("\n");
}
ListNode *search(ListNode *head, int x){
    ListNode *p;
    p = head;
    while(p != NULL){
        if(p->data == x) return p;
        p = p->link;
    }
    return p;
}
ListNode *searchPrevious(ListNode *head, int x){
    ListNode *p;
    p = head;
    while(p->link != NULL){
        if(p->link->data == x) return p;
        p = p->link;
    }
    return p;
}
void remove_node(ListNode **phead, ListNode *p, ListNode *removed){
    ListNode *temp, *p_temp, *removeData;
    if(p == NULL){
        p_temp = *phead;
        if(p_temp->link != NULL){
            while(p_temp->link->link != NULL){
                p_temp = p_temp->link;
            }
            temp = p_temp->link;
            p_temp->link = NULL;
        }else temp = *phead;
        removeData = temp;
    }else{
        if(p == *phead){
            removeData = p;
        } else{


            temp = searchPrevious(*phead, p->data);
            removeData=temp->link;
            temp->link = temp->link->link;
        }
    }
    if(removeData== *phead){
        *phead = NULL;
    }
    free(removeData );
}

void main(){
    ListNode *list1= NULL;

    insert_node(&list1,NULL,create_node(10,NULL));
    insert_node(&list1,NULL,create_node(20,NULL));
    insert_node(&list1,NULL,create_node(30,NULL));
    insert_node(&list1,search(list1,10),create_node(15,NULL));
    display(list1);

    remove_node(&list1, NULL, list1);
    display(list1);
    remove_node(&list1, search(list1,15), list1);
    display(list1);
    remove_node(&list1, search(list1,20), list1);
    remove_node(&list1, search(list1,10), list1);
    display(list1);
}
