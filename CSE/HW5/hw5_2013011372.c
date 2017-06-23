#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <string.h>
#include <stdio.h>

typedef struct TreeNode {
    int key;
    struct TreeNode *left, *right;
} TreeNode;

void display(TreeNode *p)
{
    if (p != NULL) {
        printf("(");
        display(p->left);
        printf("%d", p->key);
        display(p->right);
        printf(")");
    }
}
//루트부터 내려가 재귀적으로key를 가진 트리 노드를 찾아 반환한다.
TreeNode *search(TreeNode *node, int key)
{
    while(node != NULL){
        if( key == node->key ) return node;
        else if( key < node->key )
            return search(node->left, key);
        else
            return search(node->right, key);
    }   
    return NULL; // 탐색에 실패했을 경우 NULL 반환
}

//루트부터 내려가 재귀적으로key를 가진 트리 노드의 부모를  찾아 반환한다.
//key값이 루트에 있거나, 값이 없으면 NULL을 반환한다.
TreeNode *searchParent(TreeNode *node, int key)
{
    while(node != NULL){
        if(node->left != NULL){
            if(key == node->left->key) return node;
        }
        if(node->right != NULL){
            if(key == node->right->key) return node;
        }
        if( key < node->key )
            return searchParent(node->left, key);
        else
            return searchParent(node->right, key);
    }   
    return NULL; // 탐색에 실패했을 경우 NULL 반환
}

void insert_node(TreeNode **root, int key)
{
    TreeNode *p, *q; 
    TreeNode *n; 
    p = *root;
    q = NULL;
    // 인자로 받은 key 탐색 수행
    if( search(p,key) != NULL){
        printf("Alredy exist\n");
        return;
    }   
    //p가 가 들어갈 자리를 반복해서 찾고 내려가기 전에 q에 p를 넣어 부모를 저장한다
    while(p != NULL ){
        if( key < p->key){
            q = p;
            p = p->left;
        }else if(key > p->key){
            q = p;
            p = p->right;
        }
    }
    if(p == NULL)
        n = (TreeNode*)malloc(sizeof(TreeNode));
    n->key = key;
    n->left = NULL;
    n->right = NULL;
    //처음 root가 들어왔을경우 p가 NULL이었다가 메모리를 받으므로, q는 NULL이다
    //이때 바로 루트에 n을 넣어준다.
    if(q == NULL){
        *root = n;
        return;
    }

    if(n->key < q->key){
        q->left = n;
    }else {
        q->right = n;
    }
}

//루트로 부터 key를 가진 tmp를 찾고,
//tmp의 부모를 pTmp에 넣는다.
//1. tmp가 left,right 둘다 없을 경우 바로 free하고, 부모에서 tmp쪽 방향에 NULL을 넣는다.
//2. tmp에 right 가 있을경우(right만 있거나 left, right둘다 있을경우)
//  right에서 제일 왼쪽에 있는 노드를 찾아 tmp의 key값과 교환하고, 
//  free하고, 부모에서 left쪽 방향에 NULL을 넣는다.
//3. tmp에 right가 없고, left만 있을경우 tmp의 key값과 교환하고,
//  left에서 제일 오른쪽에 있는 노드를 찾아 free하고, 부모에서 right쪽 방향에 NULL을 넣는다.
//  root는 free를 해도 NULL이 되지 않으므로, 삭제할 수 없다.
void delete_node(TreeNode *node, int key)
{
    TreeNode *tmp, *pTmp;
    TreeNode *iter, *pIter = NULL;
    int isleft;

    tmp = search(node,key);
    if(tmp == NULL){
        printf("The node that has key : %d isn't in the tree\n",key);
        return ;
    }
    pTmp = searchParent(node,key);
    if(pTmp == NULL){
        printf("Root can't be eliminated\n");
        return;
    }

    if(pTmp->left == tmp) isleft=1;
    if(pTmp->right == tmp) isleft=0;

    if(tmp->left == NULL && tmp->right == NULL){
        free(tmp);
        tmp = NULL;
        if(isleft) pTmp->left = NULL;
        if(!isleft) pTmp->right = NULL;
        return;

    }else{
        if(tmp->right != NULL){
            iter = tmp->right;
            while(iter->left != NULL){
                iter = iter->left;
            }
            tmp->key = iter->key;
            pIter = searchParent(node,iter->key);
            free(iter);
            if(pIter != NULL) pIter->left=NULL;
            return;
        }else {
            iter = tmp->left;
            while(iter->right != NULL){
                iter = iter->right;
            }
            tmp->key = iter->key;
            pIter = searchParent(node,iter->key);
            free(iter);
            if(pIter != NULL) pIter->right=NULL;
            return;
        }
    }
}


void main(int argc, char *argv[])
{
    char command;
    int key;
    FILE *input;
    TreeNode *root = NULL;

    if (argc == 1) input = fopen("input.txt", "r");
    else input = fopen(argv[1], "r");
    while (1) {
        command = fgetc(input);
        if (feof(input)) break;
        switch (command) {
            case 'i':
                fscanf(input, "%d", &key);
                insert_node(&root, key);
                break;
            case 'd':
                fscanf(input, "%d", &key);
                delete_node(root, key);
                break;
            case 's':
                fscanf(input, "%d", &key);
                if (search(root, key) != NULL)printf("key is in the tree: %d\n", key);
                else printf("key is not in the tree: %d\n", key);
                break;
            case 'p':
                display(root);
                printf("\n");
                break;
            default:
                break;
        }
    }
    fclose(input);
}
