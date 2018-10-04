/*
code to implement state graph for a circuit given in
*.prs file and do a conformal equivalence 
by determining all the fail states of the machine.

author  - Vikas K Rao
project - conformal equivalence
subject - ECE 6750
Instructor - Prof. Chris Myers  */

#include <iostream>
#include <fstream>
#include <string>
#include <vector>

//helper files
#include "struct.h"


using namespace std;

#define SIGNAL 's'
#define NOT '~'   
#define LSQ '['   
#define RSQ ']'   
#define LPA '('   
#define RPA ')'   
#define AND '&'   
#define CLN ':'   
#define RISE '+'  
#define FALL '-'  
#define EOL 'n'   

int numLines = 0;

int main(int argc,  char **argv)
{   
    int stateString;
    // Check the number of parameters
    if (argc < 2) 
    {
        // make sure a prs file is read from command line
        cerr << "Usage: " << argv[0] << " sample.prs" << endl;
        return 1;
    }
    ifstream infile(argv[1]);
    string line;
    if (infile.is_open())
    {
       while(getline(infile,line))
       {
         ++numLines;
         
       }

       infile.close();
       cout << "number of lines in the file is " << numLines << endl;
       stateString = numLines/2;
    }
    else cout << "Unable to open file"; 
    return 0;
}

int fgettokprs(FILE *fp,char *tokvalue, int maxtok) 
{
  int c;           /* c is the character to be read in */
  int toklen;      /* toklen is the length of the toklen */
  bool readsignal;   /* True if token is a signal */

  readsignal = FALSE;
  toklen = 0;
  *tokvalue = '\0';
  while ((c=getc(fp)) != EOF) {
    switch (c) {
    case NOT:
    case LBRK:
    case RBRK:
    case LPAR:
    case RPAR:
    case AND:
    case COLON:
    case RISE:
    case FALL:
      if (!readsignal) return(c);
      else {
        ungetc(c,fp);
        return (SIGNAL);
      }
      break;
    case '\n':
      if (!readsignal) return(EOL);
      else {
        ungetc('\n',fp);
        return (SIGNAL);
      }
      break;
    case '#':
      if (!readsignal) while (((c=getc(fp)) != EOF) && (c != '\n'));
      else {
  ungetc('#',fp);
  return (SIGNAL);
      }
      break;
    case ' ':
      if (readsignal) return (SIGNAL);      
      break;
    default:
      if (toklen < maxtok) {
  readsignal=TRUE;
  *tokvalue++=c;
  *tokvalue='\0';
  toklen++;
      }
      break;
    }
  }
  if (!readsignal) 
    return(EOF);
  else
    return(SIGNAL);
}