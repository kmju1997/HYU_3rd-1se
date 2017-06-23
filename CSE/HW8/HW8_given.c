#include <stdio.h>
#include <stdlib.h>
//#include<conio.h>
#include<ctype.h>
#define MAX_STACK_SIZE 50
#define MAX_STACK_NUM 50
typedef int element;
typedef struct {
    element stack[MAX_STACK_SIZE];
    int top;
}StackType;
char tmp[MAX_STACK_SIZE] = "";

// 스택 초기화 함수
void init(StackType *s) {
    s->top = -1;
}
// 공백 상태 검출 함수
int is_empty(StackType *s) {
    //printf("---%d\n",(s->top == -1));
    return (s->top == -1);
}
// 포화 상태 검출 함수
int is_full(StackType *s) {
    return (s->top == (MAX_STACK_SIZE-1));
}
// 삽입함수
void push(StackType *s, element item) {
    //printf("push %d\n",item);
    if ( is_full(s) ) {
        fprintf(stderr," \n");
        return;
    }else s->stack[++(s->top)] = item;

}
// 삭제함수
element pop(StackType *s) {
    //printf("pop %d\n",s->stack[(s->top)]);

    if ( is_empty(s) ) {
        fprintf(stderr, "스택 공백 에러\n");
        exit(1);
    } else return s->stack[(s->top)--];
}
// 피크함수
element peek(StackType *s) {
    if ( is_empty(s) ) {
        fprintf(stderr, "스택 공백 에러\n");
        exit(1);
    } else return s->stack[s->top];
}

//Moves Stack from to
void moveStack(StackType* from, StackType* to){

    StackType tmp;
    init(&tmp);
    while(!is_empty(from))
        push(&tmp,pop(from));
    while(!is_empty(&tmp))
        push(to,pop(&tmp));

}
//Moves Stack from to with Bracket
void moveStackWithBraket(StackType* from, StackType* to){

    StackType tmp;
    init(&tmp);
    push(&tmp,'('-'0');
    while(!is_empty(from))
        push(&tmp,pop(from));
    push(&tmp,')'-'0');
    while(!is_empty(&tmp))
        push(to,pop(&tmp));

}

// 연산자의 우선순위를 반환한다.
int prec(char op) {
    switch(op){
        case '(': case ')': return 0;
        case '+': case '-': return 1;
        case '*': case '/': return 2;
    }
    return -1;
}

//infix to postfix
void infix_to_postfix(char infix[],char postfix[])
{
    StackType s;
    char x,token;
    int i,j;    //i-index of infix, j-index of postfix
    init(&s);
    j=0;

    for(i=0;infix[i]!='\0';i++)
    {
        token=infix[i];
        if(isalnum(token))
            postfix[j++]=token;
        else
            if(token=='(')
                push(&s,'(');
            else
                if(token==')')
                    while((x=pop(&s))!='(')
                        postfix[j++]=x;
                else
                {
                    while(!is_empty(&s) && (prec(token) <= prec(peek(&s))))
                    {
                        x=pop(&s);
                        postfix[j++]=x;
                    }
                    push(&s,token);
                }
    }

    while(!is_empty(&s))
    {
        x=pop(&s);
        postfix[j++]=x;
    }

    postfix[j]='\0';
    printf("\ninfix_to_postfix expression: %s", postfix);
}

char* postfix_to_infix(char expression[])
{
    /* fill in the blank */
    StackType s[MAX_STACK_NUM];
    char token;
    char* ret;
    int i,j;
    StackType* oa1;
    StackType* oa2;
    StackType tmp;
    j=0;

    ret = malloc(sizeof(char)*100);

    for(i=0;i<MAX_STACK_NUM;i++)
        init(&s[i]);
    init(&tmp);
    for(i=0; expression[i] != '\0'; i++)
    {
        token = expression[i];
        if(isalnum(token))
        {
            push(&s[j],token-'0');
            j++;
        }else
        {
            oa1 = &s[j-1];
            oa2 = &s[j-2]; 

            //Push result depends on operation
            switch (token){
                case '+':
                    moveStack(oa2,&tmp);
                    moveStack(oa1,oa2);
                    push(oa2,'+'-'0');
                    moveStack(&tmp,oa2);
                    break;
                case '*':
                    moveStack(oa2,&tmp);
                    moveStackWithBraket(oa1,oa2);
                    push(oa2,'*'-'0');
                    moveStackWithBraket(&tmp,oa2);
                    break;
                case '-':
                    moveStack(oa2,&tmp);
                    moveStack(oa1,oa2);
                    push(oa2,'-'-'0');
                    moveStack(&tmp,oa2);
                    break;
                case '/':
                    moveStack(oa2,&tmp);
                    moveStackWithBraket(oa1,oa2);
                    push(oa2,'/'-'0');
                    moveStackWithBraket(&tmp,oa2);
                    break;
            }
                j = j-1;

        }
    }
    if(j != 1){
        printf("\n postfix_to_infix error input file is incorrect\n"); return ret;
    }
    for(i=0; !is_empty(&s[j-1]);i++)
    {
        token = pop(&s[j-1]) + '0';
        ret[i] = (char)token;
    }
    ret[i] = '\0';
    printf("\npostfix_to_ infix expression:");
    printf(" %s\n",ret);
    return ret;
}

int postfixEval(char exp[])
{   

    /* fill in the blank */
    StackType s;
    char token;
    int i;
    int oa1, oa2;
    init(&s);

    for(i=0; exp[i] != '\0';i++)
    {
        token = exp[i];
        if(isalnum(token))
            push(&s,token -'0');
        else{
            oa1 = pop(&s);
            oa2 = pop(&s);
            //push result of operation depends on case
            switch (token){
                case '+':
                    push(&s,oa2+oa1);
                    break;
                case '*':
                    push(&s,oa2*oa1);
                    break;
                case '-':
                    push(&s,oa2-oa1);
                    break;
                case '/':
                    push(&s,oa2/oa1);
                    break;
            }
        }
    }
    return pop(&s);
}

int main() { 

    FILE *f;
    char postfix[30];
    char* tmp = (char*)malloc(sizeof(char)*20);

    f=fopen("input1.txt","r");
    fscanf(f,"%s", tmp);
    infix_to_postfix(tmp,postfix);
    printf("\neval: %d \n", postfixEval(postfix)); 

    f=fopen("./input3.txt","r");
    fscanf(f,"%s", tmp);
    postfix_to_infix(tmp);                   
    printf("eval: %d \n", postfixEval(tmp)); 


    return 0;
}
