#ifndef _loadprs_h
#define _loadprs_h

#include "struct.h"

/*****************************************************************************/
/* Defining token types needed for ER system files.                          */
/*****************************************************************************/

#define SIGNAL 's'      /* strings, characters */
#define NOT '~'         /* the symbol "~" */
#define LBRK '['        /* the symbol "[" */
#define RBRK ']'        /* the symbol "]" */
#define LPAR '('        /* the symbol "(" */
#define RPAR ')'        /* the symbol ")" */
#define AND '&'         /* the symbol "&" */
#define COLON ':'       /* the symbol ":" */
#define RISE '+'        /* the symbol "+" */
#define FALL '-'        /* the symbol "-" */
#define EOL 'n'        /* return character "\n" */

/*****************************************************************************/
/* Load production rules.                                                    */
/*****************************************************************************/

bool load_production_rules(char command,designADT design);

#endif /* loadprs.h */