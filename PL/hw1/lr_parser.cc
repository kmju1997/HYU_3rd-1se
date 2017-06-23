// PL homework: hw2
// lr_parser.cc

#include <assert.h>

#include <iostream>
#include <vector>

#include "lr_parser.h"

#define DISABLE_LOG false
#define LOG \
    if (DISABLE_LOG) {} else std::cerr

using namespace std;

int g_str_index;
int g_top_of_stack;
int g_front_of_str;

int GotoAction(const LRParser* lr_parser, int symbol, int frt_of_rdc);

bool PrintStack(std::vector<int>* stack){
    vector<int>::iterator s_it;

    for(s_it = stack->begin(); s_it != stack->end(); s_it++){
        cout << (*s_it) << " ";
    }
    cout << endl;

    return true;
}
bool ShiftAction( std::vector<int>* stack , int next_state){
    stack->push_back(g_front_of_str);
    g_str_index++;
    stack->push_back(next_state);
    return true;

}

bool ReduceAction(const LRParser* lr_parser, std::vector<int>* stack, int next_state){
    vector<LRRule>::const_iterator ruleit;
    const std::vector<LRRule>* rules;
    LRRule rule;
    int amt_to_pop=0;
    int i=0;
    int push_state; //Last added state


    rules = lr_parser->rules;

    for(ruleit = rules->begin(); ruleit != rules->end(); ruleit++){
        if((*ruleit).id == next_state){
            rule = *ruleit;
            if(g_top_of_stack == (int)(')')){
                amt_to_pop = (*ruleit).num_rhs*2-1;
            }else amt_to_pop = (*ruleit).num_rhs*2;
        }
    }

    for(i=0;i<amt_to_pop;i++){
        stack->pop_back();
    }
    g_top_of_stack = stack->at(stack->size()-1);

    stack->push_back(rule.lhs_symbol);

    push_state = GotoAction(lr_parser,rule.lhs_symbol, g_top_of_stack);

    stack->push_back(push_state);

    return true;
}

int GotoAction(const LRParser* lr_parser, int symbol, int frt_of_rdc){

    vector<LRTableElement>::const_iterator elemit;
    const std::vector<LRTableElement>* elements;

    elements = lr_parser->elements;

    for(elemit = elements->begin(); elemit != elements->end(); elemit++){
        if((*elemit).action == GOTO){
            if((*elemit).state == frt_of_rdc &&\
                    (*elemit).symbol == symbol)
                return (*elemit).next_state;

        }
    }

    return 0;
}

bool BuildLRParser(const std::vector<LRTableElement>& elements,
        const std::vector<LRRule>& rules,
        LRParser* lr_parser) {

    lr_parser->elements = &elements;
    lr_parser->rules = &rules;

    return true;
}

bool RunLRParser(const LRParser& lr_parser, const std::string& str) {

    int next_state;
    bool isAccepted = false;
    vector<int> stack;
    vector<int> tmp_stack; //For debugging
    int loop_cnt = 0;

    const std::vector<LRTableElement>* elements;
    const std::vector<LRRule>* rules;

    vector<LRTableElement>::const_iterator elemit;

    elements = lr_parser.elements;
    rules = lr_parser.rules;


    stack.clear();
    g_str_index=0;
    g_top_of_stack;
    g_front_of_str;
    stack.push_back(0);

    g_top_of_stack = stack.at(stack.size()-1);

    while(!isAccepted){
        for(elemit = elements->begin(); elemit != elements->end(); elemit++){
            g_top_of_stack = stack.at(stack.size()-1);
            g_front_of_str = str.at(g_str_index);

            if((*elemit).state == g_top_of_stack &&
                    (*elemit).symbol == g_front_of_str){
                next_state = (*elemit).next_state;

                switch((*elemit).action){

                    case SHIFT:
                        ShiftAction(&stack, next_state);
                        break;
                    case REDUCE:
                        ReduceAction(&lr_parser,&stack, next_state);
                        break;
                    case ACCEPT:
                        isAccepted = true;
                        break;
                    case GOTO:
                        break;
                }
            }
            if(isAccepted) break;

        }
        loop_cnt++;
        if(loop_cnt == 3){
            if(tmp_stack == stack) return false;
            else loop_cnt =0;
        }
        tmp_stack = stack;

        //PrintStack(&stack);
    }
    if(isAccepted) return true;


    return false;
}

