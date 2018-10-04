#ifndef CTELPARSER_H
#define CTELPARSER_H

#include <fstream>
#include <vector>
#include "instruction.h"

extern istream* mips_istream;
extern vector<CMipsInst*>* mips_ostream;

extern void mipsLexInit( istream& s, vector<CMipsInst*>& list );

extern void mipsLexCleanUp();

extern int mipsparse();

#endif
