// PL homework: hw1
// fsa.cc

#include <iostream>
#include <stdio.h>
#include <sstream>
#include <string>
#include <vector>
#include <set>
#include "fsa.h"
#include <string.h>

#define DISABLE_LOG true
#define LOG \
    if (DISABLE_LOG) {} else std::cerr

using namespace std;

int FollowEpsilon(const std::vector<FSATableElement>& elements, int follow_epsilon, int n){

    int follow_epsilon_cache = follow_epsilon; 
    int hasEpsilon;
    int cnt = 0;
    vector<FSATableElement>::const_iterator it;
    vector<FSATableElement>::const_iterator it2; //For broad searching
    while(1){
        hasEpsilon = 0;
        for(it = elements.begin(); it != elements.end(); it++){
            if(strcmp((*it).str.data(), "") == 0 &&\
                    (*it).state == follow_epsilon &&\
                    (*it).next_state != follow_epsilon_cache){
                hasEpsilon = 1;
                follow_epsilon_cache = follow_epsilon;
                follow_epsilon = (*it).next_state;
            }
        }
        if(hasEpsilon == 0) break;
    }
    return follow_epsilon;
}

bool PrintFSATableElem(struct FSATableElement FSAElement){

    //for test (printing)

    cout << FSAElement.state;
    cout << "\t\t";
    //for test (printing)
    cout << FSAElement.next_state;

    cout << "\t\t";
    cout << FSAElement.str;
    cout << endl;

}
bool PrintFSAElem(struct FSAElement FSAElement){

    //for test (printing)
    set<int>::iterator setit;
    for(setit = FSAElement.state.begin();\
            setit != FSAElement.state.end();\
            ++setit)
    {
        cout << *setit;
    }
    cout << "\t\t";
    //for test (printing)
    for(setit = FSAElement.next_state.begin();\
            setit != FSAElement.next_state.end();\
            ++setit)
    {
        cout << *setit;

    }

    cout << "\t\t";
    cout << FSAElement.str;
    cout << "\t\t";
    cout << FSAElement.isAccepted;
    cout << endl;

}
bool PrintFSAElems(vector<FSAElement> FSAElements){

    //for test (printing)
    vector<FSAElement>::iterator it;
    for(it = FSAElements.begin();\
            it != FSAElements.end();\
            ++it)
    {
        PrintFSAElem(*it);
    }

}
//1. check FSAElements's states,
//2. If some of them are in accept_states, set isAccepted to 1
bool CheckIsAccepted(const std::vector<int>& accept_states, FiniteStateAutomaton* fsa){
    vector<FSAElement>::iterator fsait0;
    vector<int>::const_iterator acceptIt;
    for(fsait0 = fsa->FSAElements.begin(); fsait0 != fsa->FSAElements.end(); fsait0++){
        (*fsait0).isAccepted = 0;
        for(acceptIt = accept_states.begin(); acceptIt != accept_states.end();acceptIt++){
            if((*fsait0).state.find(*acceptIt) != (*fsait0).state.end()){
                (*fsait0).isAccepted = 1;

            }

        }
    }
    return true;
}
std::set<int> StepDFA(const FiniteStateAutomaton* fsa,\
        std::set<int> in_state,\
        std::string input){

    vector<FSAElement>::const_iterator fsait0;
    std::set<int> false_ret;

    false_ret.insert(-100);

    for(fsait0 = fsa->FSAElements.begin(); fsait0 != fsa->FSAElements.end(); fsait0++){
        if((*fsait0).state == in_state &&\
                (*fsait0).str.find(input) != std::string::npos)
            return (*fsait0).next_state;
    }
    return false_ret;
}

bool RunFSA(const FiniteStateAutomaton& fsa, const string& str) {
    // Implement this function.
    int len =  str.length();
    int i=0;
    std::set<int> in_state;
    vector<FSAElement>::const_iterator fsait0;

    in_state = fsa.FSAElements.front().state;

    for(i=0; i<len; i++){

        in_state = StepDFA(&fsa,in_state,str.substr(i,1));

    }

    //Check last state is accepted
    for(fsait0 = fsa.FSAElements.begin(); fsait0 != fsa.FSAElements.end(); fsait0++){
        if((*fsait0).state == in_state ){

            if((*fsait0).isAccepted == 1) return true;
            else return false;

        }
    }
    return false;
}

bool BuildFSA(const std::vector<FSATableElement>& elements,
        const std::vector<int>& accept_states,
        FiniteStateAutomaton* fsa) {
    // Implement this function.
    // Initialization
    vector<FSATableElement>::const_iterator it;
    vector<FSATableElement>::const_iterator it2; //For broad searching
    std::set<char> kindsOfStr;
    int hasEpsilon = 0;
    int follow_epsilon = 0;
    int follow_epsilon_cache = 0;

    fsa->FSAElements.clear();
    FSAElement firelemFSA;
    firelemFSA.state.clear();
    firelemFSA.next_state.clear();

    //set kindsOfStr
    for(it = elements.begin(); it != elements.end(); it++){
        if(strcmp((*it).str.data(), "") != 0){
            string::const_iterator strit;
            for(strit = (*it).str.begin(); strit != (*it).str.end(); strit++){
                kindsOfStr.insert((*strit));
            }
        }

    }
    // Follow epsilon and set new_state of FSAElement(start state)
    // 1. check FSATable and find the entry that has epsilon in str
    // 2. add the entry's state * next_state to firelemFSA
    firelemFSA.state.insert(elements.front().state);
    follow_epsilon = elements.front().state;
    follow_epsilon_cache = follow_epsilon; 
    while(1){
        hasEpsilon = 0;
        for(it = elements.begin(); it != elements.end(); it++){
            if(strcmp((*it).str.data(), "") == 0 &&\
                    (*it).state == follow_epsilon &&\
                    (*it).next_state != follow_epsilon_cache){
                hasEpsilon = 1;
                firelemFSA.state.insert((*it).next_state);
                follow_epsilon_cache = follow_epsilon;
                follow_epsilon = (*it).next_state;
                //Below for loop is for broad searching
                for(it2 = elements.begin(); it2 != elements.end(); it2++){
                    if((*it2).state == follow_epsilon &&
                            strcmp((*it2).str.data(), "") == 0 )
                    {
                        firelemFSA.state.insert((*it2).next_state);
                    }
                }

            }
        }
        if(hasEpsilon == 0) break;

    }


    while(1)
    {

        // Follow firelemFSA, set next_state of FSAElement and push them to FSAElements
        // 0. check kindsOfStr and iterates it 
        // 0-1. make new elemFSA
        // 1-0. check FSATable and find the entry that has the str that is equal to setit 
        // 1. check the entry has the state that firelemFSA state has
        // 2. add the entry's next_state to new elemFSA  
        set<int>::iterator setit0;
        set<char>::iterator setit;
        int target;
        for(setit = kindsOfStr.begin();\
                setit != kindsOfStr.end();\
                ++setit){
            FSAElement elemFSA;
            elemFSA.state.clear();
            elemFSA.next_state.clear();
            elemFSA.state = firelemFSA.state;
            elemFSA.str = *setit;

            for(setit0 = elemFSA.state.begin();setit0 != elemFSA.state.end(); setit0++){
                follow_epsilon = (*setit0);
                follow_epsilon_cache = follow_epsilon; 
                for(it = elements.begin(); it != elements.end(); it++){
                    if((*it).state == follow_epsilon &&\
                            *(*it).str.data() == (*setit)){
                        elemFSA.next_state.insert((*it).next_state);

                    }
                    if(strcmp((*it).str.data(), "") == 0 &&\
                            (*it).state == follow_epsilon ){
                        target = FollowEpsilon(elements,(*it).next_state,1);

                        for(it2 = elements.begin(); it2 != elements.end(); it2++){
                            if((*it2).state == target &&
                                    *(*it2).str.data() == (*setit))
                            {
                                elemFSA.next_state.insert((*it2).next_state);
                            }
                        }
                    }
                }
            }

            /*
               for(it = elements.begin(); it != elements.end(); it++){
               if(*(*it).str.data() == (*setit)){
               if(elemFSA.state.find((*it).state) != elemFSA.state.end()){
               elemFSA.next_state.insert((*it).next_state);

               }
               }

               }
               */
            //if the set next_state is empty, it means it can't be accepted
            if(elemFSA.next_state.empty()) elemFSA.next_state.insert(-1);
            //push it
            fsa->FSAElements.push_back(elemFSA);
        }

        //check new_FSA_state list and check the case 
        //that next_states has a epsilon
        //and add it
        vector<FSAElement>::iterator fsait0;
        set<int>::iterator set_i_it;
        for(fsait0 = fsa->FSAElements.begin(); fsait0 != fsa->FSAElements.end(); fsait0++){
            for(set_i_it = (*fsait0).next_state.begin();
                    set_i_it != (*fsait0).next_state.end();
                    set_i_it++){
                //Below while loop is for depth searching
                follow_epsilon = (*set_i_it);
                follow_epsilon_cache = follow_epsilon; 
                while(1){
                    hasEpsilon = 0;

                    for(it = elements.begin(); it != elements.end(); it++){
                        if((*it).state == follow_epsilon &&
                                strcmp((*it).str.data(), "") == 0 &&\
                                (*it).next_state != follow_epsilon_cache)
                        {
                            hasEpsilon = 1;
                            (*fsait0).next_state.insert((*it).next_state);
                            follow_epsilon_cache = follow_epsilon; 
                            follow_epsilon = (*it).next_state;

                            //Below for loop is for broad searching
                            for(it2 = elements.begin(); it2 != elements.end(); it2++){
                                if((*it2).state == follow_epsilon &&
                                        strcmp((*it2).str.data(), "") == 0 )
                                {
                                    (*fsait0).next_state.insert((*it2).next_state);
                                }
                            }

                        }
                    }
                    if(hasEpsilon == 0) break;
                }


            }
        }

        // check new_FSA_State list and set next new_FSA_State 
        // fsait for checking fields(!!static)
        // fsait2 for checking new_FSA_state list
        static vector<FSAElement>::iterator fsait;
        int foundStateFlag = 0;
        for(fsait = fsa->FSAElements.begin(); fsait != fsa->FSAElements.end(); fsait++){
            foundStateFlag = 0;

            vector<FSAElement>::iterator fsait2;
            for(fsait2 = fsa->FSAElements.begin(); fsait2 != fsa->FSAElements.end(); fsait2++){
                if((*fsait).next_state == (*fsait2).state){
                    firelemFSA.state.clear();
                    //if foundStateFlag==1, no need to add it to fsa list
                    foundStateFlag = 1;
                    break;
                }
            }
            if(foundStateFlag == 0){
                firelemFSA.state = (*fsait).next_state;
                break;
            }
        }
        if(firelemFSA.state.empty() == true) break;
    }

    CheckIsAccepted(accept_states,fsa);


    //PrintFSAElems(fsa->FSAElements);

    LOG << "num_elements: " << elements.size()
        << ", accept_states: " << accept_states.size() << endl;
    return true;
}

