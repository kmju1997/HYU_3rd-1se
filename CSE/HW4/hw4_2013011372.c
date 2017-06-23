//for visual studio 2013(fscanf_s problem)
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <string.h>

typedef int element;
typedef struct _TreeNode
{
    element data;
    struct _TreeNode * left;
    struct _TreeNode * right;
} TreeNode;
//새로운 트리노드를 만든다.
TreeNode * createTreeNode(void)
{
    TreeNode* node;
    node = (TreeNode*)malloc(sizeof(TreeNode));
    node->left = NULL;
    node->right = NULL;
    return node;

}
//인자로 넘어온 노드에 데이터를 넣어준다.
void setData(TreeNode * node, element data)
{
    node->data = data;

}
//인자로 넘어온 노드의 값을 얻는다.
element getData(TreeNode * node)
{
    return node->data;

}
//main 인자로 넘어온 노드의 왼쪽서브트리로 sub를 넣는다.
void makeLeftSubTree(TreeNode * main, TreeNode * sub)
{
    main->left = sub;
}

//main 인자로 넘어온 노드의 오른쪽서브트리로 sub를 넣는다.
void makeRightSubTree(TreeNode * main, TreeNode * sub)
{
    main->right = sub;

}

//인자로 넘어온 노드의 왼쪽서브트리를 얻는다.
TreeNode * getLeftSubTree(TreeNode * node)
{
    return node->left;

}

//인자로 넘어온 노드의 오른서브트리를 얻는다.
TreeNode * getRightSubTree(TreeNode * node)
{
    return node->right;

}
//중위순회하며 트리를 출력한다.
void printInorder(TreeNode *root){
    if(root == NULL) return;
    printInorder(getLeftSubTree(root));
    printf("%d ", root->data);
    printInorder(getRightSubTree(root));
}
//전위순회하며 트리를 출력한다.
void printPreorder(TreeNode *root){
    if(root == NULL) return;
    printf("%d ", root->data);
    printPreorder(getLeftSubTree(root));
    printPreorder(getRightSubTree(root));
}
//후위순회하며 트리를 출력한다.
void printPostorder(TreeNode *root){
    if(root == NULL) return;
    printPostorder(getLeftSubTree(root));
    printPostorder(getRightSubTree(root));
    printf("%d ", root->data);

}
int main(int argc, char *argv[]){
    FILE *input;
    char command;
    TreeNode *root;
    root = createTreeNode();
//트리노드를 만든다.
    TreeNode * t1 = createTreeNode();
    TreeNode * t2 = createTreeNode();
    TreeNode * t3 = createTreeNode();
    TreeNode * t4 = createTreeNode();
    TreeNode * t5 = createTreeNode();
    TreeNode * t6 = createTreeNode();
    TreeNode * t7 = createTreeNode();
    TreeNode * t8 = createTreeNode();
    TreeNode * t9 = createTreeNode();

    //트리노드들에 값을 넣어준다.
    setData(root, 54);
    setData(t1, 27);
    setData(t2, 13);
    setData(t3, 1);
    setData(t4, 44);
    setData(t5, 37);
    setData(t6, 89);
    setData(t7, 71);
    setData(t8, 64);
    setData(t9, 92);

    //트리노드의 구조들을 연결해준다.
    makeLeftSubTree(root, t1);
    makeRightSubTree(root, t6);

    makeLeftSubTree(t1, t2);
    makeRightSubTree(t1, t4);

    makeLeftSubTree(t2, t3);

    makeLeftSubTree(t4, t5);

    makeLeftSubTree(t6, t7);
    makeRightSubTree(t6, t9);

    makeLeftSubTree(t7, t8);

     //입력 파일을 지정하지 않았을 경우
    if(argc == 1)
        input = fopen("input.txt", "r");
    //입력 파일을 지정했을 경우
    else if(argc == 2)
        input = fopen(argv[1], "r");
    //아규먼트가 많을 경우
    else error("Usage : $HW4 (arg)\n");
    //파일을 찾을 수 없을경우
    if(input == NULL){
        printf("Can't find the file\n");
        exit(0);
    }


    while(1){
        command = fgetc(input);
        if(feof(input)) break;//파일을 끝까지 읽었을경우
        switch(command) {
            case 'r':
                printf("Preorder:\t");
                printPreorder(root);
                printf("\n");
                break;
            case 'i':
                printf("Inorder:\t");
                printInorder(root);
                printf("\n");
                break;
            case 'o':
                printf("Postorder:\t");
                printPostorder(root);
                printf("\n");
                break;
            default:
                break;
        }
    }
    fclose(input);
    return 0;
}
