#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#define min(a, b) (((a) < (b)) ? (a) : (b))
#define max(a, b) (((a) > (b)) ? (a) : (b))

struct avl_node   {
    struct avl_node *left_child, *right_child;  /* Subtrees. */
    int data;                   /* Pointer to data. */
};

struct avl_node *root;
struct avl_node *header; //��Ʈ�� ����Ű�� ������ (��Ʈ ������ ���δ�)

// ������ ȸ�� �Լ�
struct avl_node* rotate_right(struct avl_node *parent)
{
    struct avl_node *child = parent->left_child;
    parent->left_child= child->right_child;
    child->right_child= parent;
    return child;
}

// ���� ȸ�� �Լ�
struct avl_node* rotate_left(struct avl_node *parent)
{
    struct avl_node *child = parent->right_child;
    parent->right_child = child->left_child;
    child->left_child = parent;
    return child;
}

// ������-���� ȸ�� �Լ�
struct avl_node* rotate_right_left(struct avl_node *parent) 
{
    parent->right_child = rotate_right(parent->right_child);
    return rotate_left(parent);
}

// ����-������ ȸ�� �Լ�
struct avl_node* rotate_left_right(struct avl_node *parent)
{
    parent->left_child= rotate_left(parent->left_child);
    return rotate_right(parent);
}

// Ʈ���� ���̸� ��ȯ
int get_height(struct avl_node *node)
{
    int height=0;
    if( node != NULL )
        height = 1 + max(get_height(node->left_child), get_height(node->right_child));
    return height;
}

// ����� �����μ��� ��ȯ
int get_height_diff(struct avl_node *node) 
{
    if( node == NULL ) return 0;
    return get_height(node->left_child) - get_height(node->right_child);
} 

// Ʈ���� ����Ʈ���� �����
struct avl_node* rebalance(struct avl_node **node)
{
    //FOR ADDED
    header->right_child = root;
    header->left_child = root;
    int height_diff = get_height_diff(*node);
    if( height_diff > 1 ){
        if( get_height_diff((*node)->left_child) >= 0 )
            *node = rotate_right(*node);
        else
            *node = rotate_left_right(*node);
    }
    else if ( height_diff < -1 ){
        if( get_height_diff((*node)->right_child) <= 0 )
            *node = rotate_left(*node);
        else
            *node = rotate_right_left(*node);
    }
    return *node;
}

// AVL Ʈ���� ���� ����
struct avl_node * avl_add(struct avl_node **root, int new_key)
{
    if( *root == NULL ){
        *root = (struct avl_node *)malloc(sizeof(struct avl_node));
        if( *root == NULL ){
            exit(1);
        }
        (*root)->data = new_key;
        (*root)->left_child = (*root)->right_child = NULL;
    }
    else if( new_key < (*root)->data ){
        (*root)->left_child = avl_add(&((*root)->left_child), new_key);
        *root = rebalance(root);
    }
    else if( new_key > (*root)->data ){
        (*root)->right_child=avl_add(&((*root)->right_child), new_key);
        *root = rebalance(root);
    }
    else{
        printf("�ߺ��� Ű\n");
        exit(1);
    }
    return *root;
}
//����Լ� �����Ǿ�����
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
// AVL Ʈ���� Ž���Լ�
struct avl_node *avl_search(struct avl_node *node, int key) 
{ 
    if( node == NULL ) return NULL; 
    if( key == node->data ){
        return node; 
    }
    else if( key < node->data ) 
        return avl_search(node->left_child, key); 
    else 
        return avl_search(node->right_child, key); 
} 
// AVL Ʈ���� �θ�Ž���Լ�
struct avl_node *avl_parent_search(struct avl_node *node, int key) 
{ 
    if( node == NULL ){
        printf("there is no %d\n",key);
        return NULL; 
    }

    if(node == header) return avl_parent_search(root,key);

    if(key == root->data){
        header->left_child = root;
        header->right_child = root;
        return header;
    }

    if( node->left_child != NULL ){
        if(key == node->left_child->data) {
            return node; 
        }
    }
    if( node->right_child != NULL ){
        if(key == node->right_child->data){ 
            return node; 
        }
    }

    if( key < node->data ) {
        return avl_parent_search(node->left_child, key); 
    }
    else {
        return avl_parent_search(node->right_child, key); 
    }
} 

//��Ʈ�� ���� key�� ���� tmp�� ã��,
//tmp�� �θ� pTmp�� �ִ´�.
//1. tmp�� left,right �Ѵ� ���� ��� �ٷ� free�ϰ�, �θ𿡼� tmp�� ���⿡ NULL�� �ִ´�.
//2. tmp�� right �� �������(right�� �ְų� left, right�Ѵ� �������)
//  right���� ���� ���ʿ� �ִ� ��带 ã�� tmp�� key���� ��ȯ�ϰ�,
//  free�ϰ�, �θ𿡼� left�� ���⿡ NULL�� �ִ´�.
//3. tmp�� right�� ����, left�� ������� tmp�� key���� ��ȯ�ϰ�,
//  left���� ���� �����ʿ� �ִ� ��带 ã�� free�ϰ�, �θ𿡼� right�� ���⿡ NULL�� �ִ´�.
//  root�� free�� �ص� NULL�� ���� �����Ƿ�, ������ �� ����.
struct avl_node * avl_delete(struct avl_node **root, int new_key)
{
    struct avl_node *temp;
    struct avl_node *pTemp,*ppTemp;
    struct avl_node *iter, *pIter;
    int isleft, data;

    pTemp = avl_parent_search(*root,new_key);
    //ppTemp is used for connecting rebalanced node;
    if(pTemp !=header)
        ppTemp = avl_parent_search(*root, pTemp->data);
    else
        ppTemp = pTemp;
    if(pTemp == NULL){
        printf("There is no %d\n",new_key);
        return NULL;
    }

    //Determine whether temp is positioned to left or right of it's parent
    if(pTemp->left_child != NULL && pTemp->left_child->data == new_key){
        isleft = 1;
        temp = pTemp->left_child;
    }
    if(pTemp->right_child != NULL && pTemp->right_child->data == new_key){
        isleft = 0;
        temp = pTemp->right_child;
    }

    //���尡 �ƹ��� ���� ���
    if(temp->left_child == NULL && temp->right_child == NULL){
        free(temp);
        if(isleft) pTemp->left_child = NULL;
        if(!isleft) pTemp->right_child = NULL;

        //rebalance based on pTemp, and connect it to parent of pTemp
        if(pTemp == ppTemp->right_child){
            ppTemp->right_child = rebalance(&pTemp);
        }else if(pTemp == ppTemp->left_child){
            ppTemp->left_child = rebalance(&pTemp);
        }
        return;

    }else{
        //������ ��尡 ������ ���尡 ���� ���
        if(temp->right_child != NULL){
            iter = temp->right_child;
            while(iter->left_child != NULL){
                iter = iter->left_child;
            }
            pIter = avl_parent_search(*root,iter->data);

            data = iter->data;
            avl_delete(root,iter->data);
            temp->data = data;

            if(iter == temp->right_child) {
                temp->right_child = iter->right_child;

        //rebalance based on pTemp, and connect it to parent of pTemp
                if(pTemp == ppTemp->right_child){
                    ppTemp->right_child = rebalance(&pTemp);
                }else if(pTemp == ppTemp->left_child){
                    ppTemp->left_child = rebalance(&pTemp);
                }
            }
            *root = rebalance(root);
            return;

            //���� �� ��尡 ���� ���尡 ���� ���
        }else {
            iter = temp->left_child;
            while(iter->right_child != NULL){
                iter = iter->right_child;
            }
            pIter = avl_parent_search(*root,iter->data);

            data = iter->data;
            avl_delete(root,iter->data);
            temp->data = data;

        //rebalance based on pTemp, and connect it to parent of pTemp
            if(iter == temp->left_child) {
                temp->left_child = iter->left_child;


                if(pTemp == ppTemp->right_child){
                    ppTemp->right_child = rebalance(&pTemp);

                }else if(pTemp == ppTemp->right_child){
                    ppTemp->left_child= rebalance(&pTemp);
                }
            }
        }
        *root = rebalance(root);
        return;
    }
}

void main()
{
    char command;
    int key;
    FILE *input;
    root = NULL;
    input = fopen("input.txt", "r");

    header = (struct avl_node *)malloc(sizeof(struct avl_node));
    header->left_child = root;
    header->right_child = root;
    header->data = -1;

    while (1) {
        command = fgetc(input);
        if (feof(input)) break;
        switch (command) {
            case 'i':
                fscanf(input, "%d", &key);
                avl_add(&root, key);
                break;
            case 'd':
                fscanf(input, "%d", &key);
                avl_delete(&root, key);
                break;
            default:
                break;
        }
    }

    display(header->left_child);
    printf("root %d\n",root->data);
    printf("\n");

}
