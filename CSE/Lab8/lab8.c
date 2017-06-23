#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
struct avl_node {
    struct avl_node *left_child, *right_child; /* Subtrees. */
    int data; /* Pointer to data. */
};

struct avl_node *root; //글로벌로 선언함

void display(struct avl_node *node)
{
    if (node != NULL) {
        printf("(");
        display(node->left_child);
        printf("%d", node->data);
        display(node->right_child);
        printf(")");
    }
}

struct avl_node* avl_add(struct avl_node **root, int new_key)
{
    if( *root == NULL ){
        *root = (struct avl_node *)malloc(sizeof(struct avl_node));
        if( *root == NULL ){
            exit(1);
        }
        (*root)->data = new_key;
        (*root)->left_child = (*root)->right_child = NULL;
    }
    else if( new_key > (*root)->data ){
        (*root)->right_child=avl_add(&((*root)->right_child), new_key);
        *root = rebalance(root); //STEP1에서는 균형인수만 출력한다
    }
    else{
        printf("중복된 키\n");
        exit(1);
    }
    return *root;
}

struct avl_node* rebalance(struct avl_node **node)
{
    int height_diff = get_height_diff(*node); //균형인수를 가져오는 함수
    printf("균형인수: %d node: %d\n", height_diff, (*node)->data);
    return *node;
}

// 트리의 높이를 반환
int get_height(struct avl_node *node)
{
    int height=0;
    /* fill in the blank */
    return height;
}

// 노드의 균형인수를 반환
int get_height_diff(struct avl_node *node)
{
    int height_diff =0;
    if( node == NULL ) return 0;
    /* fill in the blank */
    return height_diff ;
}

void main()
{
    //7,8,9,10,11
    avl_add(&root, 7);
    avl_add(&root, 8);
    avl_add(&root, 9);
    avl_add(&root, 10);
    avl_add(&root, 11);
    display(root);
}
