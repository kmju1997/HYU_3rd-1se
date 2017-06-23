// PL homework: hw2
// regexp_matcher.cc

#include <stdio.h>
#include <iostream>
#include <string>
#include <vector>
#include <set>
#include <string.h>
#include "regexp_matcher.h"
#include "fsa.h"

#define DISABLE_LOG true
#define LOG \
    if (DISABLE_LOG) {} else std::cerr

using namespace std;

bool RunRegExpMatcher(RegExpMatcher& regexp_matcher, const char* str) {
    string in_str(str);
    
        return  RunFSA(*(regexp_matcher.fsa), in_str);
}

                
int StepRegExp(RegExp* regExp,
                    vector<FSATableElement>* fsaElements,
                    set<char> *alphabetsSet,
                    int startState, int finalState) {
    vector<char> alphabets = vector<char>(alphabetsSet->begin(),
                                          alphabetsSet->end());

    int curId = finalState;
    if (regExp->tokenType == RE_REGEXP || regExp->tokenType == RE_GROUP) {
        for (int i=0; i<=regExp->or_ops_count; i++) {
            curId++;
            FSATableElement* startElem =
                new FSATableElement(startState, kEps, curId);
            fsaElements->push_back(*startElem);
            for (int j=0; j<regExp->elements[i].size(); j++) {
                if (regExp->elements[i][j]->tokenType == RE_CHAR) {
                    FSATableElement* elem = new FSATableElement(
                        curId,
                        regExp->elements[i][j]->primitiveValue,
                        curId + 1
                    );
                    fsaElements->push_back(*elem);
                    curId++;
                }
                else if (regExp->elements[i][j]->tokenType == RE_ANYCHAR) {
                    int charCount = alphabets.size();
                    for(int k=0; k<charCount; k++) {
                        FSATableElement* elem = new FSATableElement(
                            curId, alphabets[k], curId + 1
                        );
                        fsaElements->push_back(*elem);
                        elem = new FSATableElement(
                            curId + 1,
                            kEps,
                            curId + 2
                        );
                        fsaElements->push_back(*elem);
                    }
                    curId += 2;
                }
                else if (regExp->elements[i][j]->tokenType == RE_SETCHAR) {
                    int charCount = regExp->elements[i][j]->elements[0].size();
                    for(int k=0; k<charCount; k++) {
                        FSATableElement* elem = new FSATableElement(
                            curId,
                            regExp->elements[i][j]
                                  ->elements[0][k]
                                  ->primitiveValue,
                            curId + 1
                        );
                        fsaElements->push_back(*elem);
                        elem = new FSATableElement(
                            curId + 1,
                            kEps,
                            curId + 2
                        );
                        fsaElements->push_back(*elem);
                    }
                    curId += 2;
                }
                else if (regExp->elements[i][j]->tokenType == RE_GROUP) {
                    int tmpCurId = curId;
                    FSATableElement* groupStartElem =
                        new FSATableElement(tmpCurId, kEps, tmpCurId + 1);
                    fsaElements->push_back(*groupStartElem);
                    curId = StepRegExp(
                        regExp->elements[i][j],
                        fsaElements,
                        alphabetsSet,
                        tmpCurId + 1,
                        tmpCurId + 2
                    );
                    FSATableElement* groupEndElem =
                        new FSATableElement(tmpCurId + 2, kEps, curId + 1);
                    fsaElements->push_back(*groupEndElem);
                    curId++;
                }
                else if (regExp->elements[i][j]->tokenType == RE_STAR) {
                    int tmpCurId = curId;
                    FSATableElement* starStartElem =
                        new FSATableElement(tmpCurId, kEps, tmpCurId + 1);
                    fsaElements->push_back(*starStartElem);
                    curId = StepRegExp(
                        regExp->elements[i][j]->elements[0][0],
                        fsaElements,
                        alphabetsSet,
                        tmpCurId + 1,
                        tmpCurId + 2
                    );
                    FSATableElement* starZeroRepeatElem =
                        new FSATableElement(tmpCurId + 1, kEps, tmpCurId + 2);
                    fsaElements->push_back(*starZeroRepeatElem);
                    FSATableElement* starRepeatElem =
                        new FSATableElement(tmpCurId + 2, kEps, tmpCurId + 1);
                    fsaElements->push_back(*starRepeatElem);
                    FSATableElement* starEndElem =
                        new FSATableElement(tmpCurId + 2, kEps, curId + 1);
                    fsaElements->push_back(*starEndElem);
                    curId++;
                }
            }
            FSATableElement* endElem = new FSATableElement(curId, kEps, finalState);
            fsaElements->push_back(*endElem);
        }
    }
    else if (regExp->tokenType == RE_CHAR) {
        FSATableElement* charElem = new FSATableElement(
            startState, regExp->primitiveValue, finalState
        );
        fsaElements->push_back(*charElem);
        //cout << "pushed\n";
        curId = finalState;
    }
    else if (regExp->tokenType == RE_ANYCHAR) {
        int charCount = alphabets.size();
        for(int k=0; k<charCount; k++) {
            FSATableElement* elem = new FSATableElement(
                startState, alphabets[k], finalState
            );
            fsaElements->push_back(*elem);
        }
        curId = finalState;
    }
    else if (regExp->tokenType == RE_SETCHAR) {
        int charCount = regExp->elements[0].size();
        for(int k=0; k<charCount; k++) {
            FSATableElement* elem = new FSATableElement(
                startState, regExp->elements[0][k]->primitiveValue, finalState
            );
            fsaElements->push_back(*elem);
        }
        curId = finalState;
    }
    return curId;
}
bool BuildRegExpMatcher(const char* regexp, RegExpMatcher* regexp_matcher) {
  // Returns false when parse error

  RegExp *rootRegExp = new RegExp(RE_REGEXP);
  set<char> alphabets;
  char handle;
  int cursor = 0;

  while((handle = regexp[cursor++]) != '\0') {
      if (handle != ANYCHAR && handle != STAR && handle != OR &&
          handle != OPEN_GROUP && handle != CLOSE_GROUP &&
          handle != OPEN_SET && handle != CLOSE_SET)
        alphabets.insert(handle);
  }
  for (char s='a'; s<='z'; s++) alphabets.insert(s);
  for (char s='A'; s<='Z'; s++) alphabets.insert(s);
  for (char s='0'; s<='9'; s++) alphabets.insert(s);

  cursor = 0;
  RegExp* currentRegExp = rootRegExp;
  while((handle = regexp[cursor++]) != '\0') {
      if (handle == ANYCHAR) {
          // 1. construct new regexp accepts any single character
          RegExp* anyCharRegExp = new RegExp(RE_ANYCHAR);
          // 2. and push it into current stack
          currentRegExp->elements[currentRegExp->or_ops_count]
            .push_back(anyCharRegExp);
      }
      else if (handle == STAR) {
          // If no previous element to *-repeat, error
          if (currentRegExp->elements[0].size() == 0) return false;
          // 1. construct new *-repeat regexp on previous element
          RegExp* starRegExp = new RegExp(RE_STAR);
          starRegExp->elements[0].push_back(
            currentRegExp->elements[currentRegExp->or_ops_count].back());
          currentRegExp->elements[currentRegExp->or_ops_count].pop_back();
          // 2. and push it into current stack
          currentRegExp->elements[currentRegExp->or_ops_count]
            .push_back(starRegExp);
      }
      else if (handle == OPEN_GROUP) {
          // 1. construct new group
          RegExp* groupRegExp = new RegExp(RE_GROUP);
          groupRegExp->container = currentRegExp;
          // 2. and push it into current stack
          currentRegExp->elements[currentRegExp->or_ops_count]
            .push_back(groupRegExp);
          // 3. and change current stack to new group
          currentRegExp = groupRegExp;
      }
      else if (handle == CLOSE_GROUP) {
          // Closing unopened group, error
          if (currentRegExp->tokenType != RE_GROUP) return false;
          currentRegExp = currentRegExp->container;
      }
      else if (handle == OPEN_SET) {
          // 1. construct new set
          RegExp* setRegExp = new RegExp(RE_SETCHAR);
          setRegExp->container = currentRegExp;
          // 2. and push it into current stack
          currentRegExp->elements[currentRegExp->or_ops_count]
            .push_back(setRegExp);
          // 3. and change current stack to new set
          currentRegExp = setRegExp;
      }
      else if (handle == CLOSE_SET) {
          // Closing unopened set, error
          if (currentRegExp->tokenType != RE_SETCHAR) return false;
          currentRegExp = currentRegExp->container;
      }
      else if (handle == OR) {
          // Break regexp if OR(|) appears
          currentRegExp->or_ops_count++;
          currentRegExp->elements.push_back(vector<RegExp*>(0));
      }
      else /* alphabets */ {
          // 1. construct new regexp accepts any single character
          RegExp* singleCharRegExp = new RegExp(RE_CHAR);
          singleCharRegExp->primitiveValue = handle;
          // 2. and push it into current stack
          currentRegExp->elements[currentRegExp->or_ops_count]
            .push_back(singleCharRegExp);
      }
  }

  vector<FSATableElement> fsa_elements;
  fsa_elements.clear();

  StepRegExp(rootRegExp, &fsa_elements, &alphabets, 0, 1);
  
  /*
  //For debuging
  vector<FSATableElement>::iterator fsait;

  for(fsait = fsa_elements.begin(); fsait != fsa_elements.end(); fsait++){
      PrintFSATableElem(*fsait);

  }
  */

  set<int> accept_states_set;
  accept_states_set.insert(1);
  int statesCount;
  do {
    statesCount = accept_states_set.size();
    for(int i=0; i<fsa_elements.size(); i++) {
        if (fsa_elements[i].str[0] != kEps) continue;
        vector<int> accept_states_vec =
            vector<int>(accept_states_set.begin(), accept_states_set.end());
        for(int j=0; j<accept_states_vec.size(); j++) {
            if (fsa_elements[i].next_state == accept_states_vec[j])
                accept_states_set.insert(fsa_elements[i].state);
        }
    }
  } while(statesCount != accept_states_set.size());
  vector<int> accept_states =
      vector<int>(accept_states_set.begin(), accept_states_set.end());

  regexp_matcher->fsa = new FiniteStateAutomaton();


  return BuildFSA(fsa_elements, accept_states,regexp_matcher->fsa);
}


