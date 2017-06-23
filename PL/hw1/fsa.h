// PL homework: hw1
// fsa.h

#ifndef _PL_HOMEWORK_FSA_H_
#define _PL_HOMEWORK_FSA_H_

#include <vector>
#include <string>
#include <set>

// Valid characters are alphanumeric and underscore (A-Z,a-z,0-9,_).
// Epsilon moves in NFA are represented by empty strings.

//NFA Element
struct FSATableElement {
  int state;
  int next_state;
  std::string str;

  FSATableElement(){
      state = state;
      next_state = next_state;
  }
  FSATableElement(int in_state, char in_ch, int in_next_state){
      state = in_state;
      str.push_back(in_ch);
      next_state = in_next_state;
  }
};
//FOR ADDED
//DFA Element
struct FSAElement {
    std::set<int> state;
    std::set<int> next_state;
    std::string str;
    int isAccepted;
    
};
struct FiniteStateAutomaton {
  // Make your own FSA struct here.
    std::vector<FSAElement> FSAElements;
};

// Run FSA and return true if str is matched by fsa, and false otherwise.
bool PrintFSATableElem(struct FSATableElement FSAElement);
bool PrintFSAElem(struct FSAElement FSAElement);
bool PrintFSAElems(const std::vector<FSAElement> FSAElements);

bool RunFSA(const FiniteStateAutomaton& fsa, const std::string& str);

bool BuildFSA(const std::vector<FSATableElement>& elements,
              const std::vector<int>& accept_states,
              FiniteStateAutomaton* fsa);

#endif //_PL_HOMEWORK_FSA_H_

