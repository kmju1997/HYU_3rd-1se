// PL homework: hw2
// regexp_matcher.h

#ifndef _PL_HOMEWORK_REGEXP_MATCHER_H_
#define _PL_HOMEWORK_REGEXP_MATCHER_H_
#include <string>
#include <vector>
#include <set>
#include "fsa.h"

using namespace std;
// Valid characters are alphanumeric and underscore (A-Z,a-z,0-9,_).
// Epsilon moves in NFA are represented by empty strings.
enum RegExpTokenType {
    RE_REGEXP,  
    RE_CHAR,  
    RE_ANYCHAR, 
    RE_SETCHAR,  
    RE_GROUP,  
    RE_STAR,  
};

struct RegExp {
  RegExpTokenType tokenType;
  char primitiveValue;  
  vector< vector<RegExp*> > elements;  
  RegExp* container; 
  int or_ops_count;

  RegExp(RegExpTokenType tkType) {
    tokenType = tkType;
    primitiveValue = '\0';
    elements = vector< vector<RegExp*> >(1);
    elements[0].resize(0);
    container = NULL;
    or_ops_count = 0;
  }
};


const char ANYCHAR = '.';
const char OPEN_GROUP = '(';
const char CLOSE_GROUP = ')';
const char OPEN_SET = '[';
const char CLOSE_SET = ']';
const char STAR = '*';
const char OR = '|';

const char kEps = '\0';

struct RegExpMatcher {
  // Design your RegExpMatcher structure.
  RegExp* regExp;
  FiniteStateAutomaton* fsa;
};

int StepRegExp(RegExp* regExp,
                    vector<FSATableElement>* fsaElements,
                    set<char> *alphabetsSet,
                    int startState, int finalState) ;
// Homework 1.3
bool RunRegExpMatcher(RegExpMatcher& regexp_matcher, const char* str) ;
// Homework 1.3
bool BuildRegExpMatcher(const char* regexp, RegExpMatcher* regexp_matcher);

#endif  //_PL_HOMEWORK_REGEXP_MATCHER_H_

