%{

#define YY_DECL int yylex (void *lvalp)
#define yylval (*((YYSTYPE*)lvalp))

#include <iostream>
#include <vector>
#include "instruction.h"

/**
 * This include should always be last.  This
 * is the details from the parser.
 */
#include "mipsLang.tab.h"

istream* mips_istream;
vector<CMipsInst*>* mips_list;

int lineNumber = 1;

void CTelLexInit( istream& s, vector<CMipsInst*>& list );

/**
 * Deletes any memory allocated by the lexer
 * and parser for the CTel structures.
 * NOTE: Should be called after parsing has
 * finished.
 */
void mipsLexCleanUp();

int mips_yyinput(char *buf, int max_size);

/**
 * Rewrite the standard YY_INPUT
 */
#undef YY_INPUT
#define YY_INPUT(b,r,ms) (r = mips_yyinput(b,ms))

%}

%start          norm comment

WHITE           [ \t]
LETTER          [A-Za-z_]
DIGIT           [0-9]
DECINT	        ({DIGIT}+|[-]{DIGIT}+)
COMMENT         ("#")
LAB_MARK        (":")
ADD             ([Aa][Dd][Dd])
SUB             ([Ss][Uu][Bb])
AND             ([Aa][Nn][Dd])
OR              ([Oo][Rr])
SLT             ([Ss][Ll][Tt])
SLL             ([Ss][Ll][Ll])
SRL             ([Ss][Rr][Ll])
SRA             ([Ss][Rr][Aa])
ADDI            ([Aa][Dd][Dd][Ii])
ANDI            ([Aa][Nn][Dd][Ii])
ORI             ([Oo][Rr][Ii])
SLTI            ([Ss][Ll][Tt][Ii])
BEQ             ([Bb][Ee][Qq])
BNE             ([Bb][Nn][Ee])
J               ([Jj])
JR              ([Jj][Rr])
JAL             ([Jj][Aa][Ll])
LW              ([Ll][Ww])
SW              ([Ss][Ww])
NOP             ([Nn][Oo][Pp])
DUMP            ([Dd][Uu][Mm][Pp])
T_REG           ([$][Tt])
V_REG           ([$][Vv])
A_REG           ([$][Aa])
GP_REG          ([$][Gg][Pp])
SP_REG          ([$][Ss][Pp])
S_REG           ([$][Ss])
FP_REG          ([$][Ff][Pp])
RA_REG          ([$][Rr][Aa])
AT_REG          ([$][Aa][Tt])
K_REG           ([$][Kk])
ZERO_REG        ([$][Zz][Ee][Rr][Oo])
ID              ({LETTER}({LETTER}|{DIGIT})*)
USELESS         ([,()])
REG_MARK        ([$])
NEWLINE         [\n]

%%

%{
BEGIN norm;
%}

{COMMENT}                    { BEGIN comment; }

<norm>{WHITE}                {}
<norm>{NEWLINE}              { ++lineNumber; }
<norm>{USELESS}              {}
<norm>{LAB_MARK}             { return( LAB_MARK ); }
<norm>{DECINT}               { yylval.value = (int)atoi(yytext);
			       return( INT ); }
<norm>{ADD}                  { return(ADD); }
<norm>{SUB}                  { return(SUB); }
<norm>{AND}                  { return(AND); }
<norm>{OR}                   { return(OR); }
<norm>{SLT}                  { return(SLT); }
<norm>{SLL}                  { return(SLL); }
<norm>{SRL}                  { return(SRL); }
<norm>{SRA}                  { return(SRA); }
<norm>{ADDI}                 { return(ADDI); }        
<norm>{ANDI}                 { return(ANDI); }
<norm>{ORI}                  { return(ORI); }
<norm>{SLTI}                 { return(SLTI); }
<norm>{BEQ}                  { return(BEQ); }
<norm>{BNE}                  { return(BNE); }
<norm>{J}                    { return(J); }
<norm>{JR}                   { return(JR); }
<norm>{JAL}                  { return(JAL); }
<norm>{LW}                   { return(LW); }
<norm>{SW}                   { return(SW); }
<norm>{NOP}                  { return(NOP); }
<norm>{DUMP}                 { return(DUMP); }
<norm>{T_REG}                { return(T_REG); }
<norm>{ZERO_REG}             { return(ZERO_REG);}
<norm>{V_REG}                { return(V_REG); }
<norm>{A_REG}                { return(A_REG); }
<norm>{SP_REG}               { return(SP_REG); }
<norm>{S_REG}                { return(S_REG); }
<norm>{GP_REG}               { return(GP_REG); }
<norm>{FP_REG}               { return(FP_REG); }
<norm>{RA_REG}               { return(RA_REG); }
<norm>{AT_REG}               { return(AT_REG); }
<norm>{K_REG}                { return(K_REG); }
<norm>{REG_MARK}             { return( REG_MARK ); }
<norm>{ID}                   { yylval.label = new string( yytext );
                               return( ID );
                             }
<norm>.                      {cout << endl << "Unidentified token: " << yytext;
                              cout << " found on line " << lineNumber << endl;}

<comment>{NEWLINE}           { BEGIN norm; lineNumber++; }
<comment>(.)                 {}
 
%%

/**
 * mips_yyinput is a wrapper function that described
 * how to read text from a istream buffer.
 */
int mips_yyinput( char *buf, int max_size ) {
   if ( mips_istream->get(buf[0]) == 0 ) return( 0 );
   return(1);
}

/**
 * mipsLexInit will set all of the memory locations
 * and values of global variables including:
 *     1) sets lineNumber to 1.
 *     2) sets mips_istream to the input stream
 *     3) sets the mips_ostream to the output stream
 */
void mipsLexInit( istream& s, vector<CMipsInst*>& list ) {
   lineNumber = 1;
   mips_istream = &s;
   mips_list = &list;
}

/**
 * Deletes any memory allocated by the lexer
 * and parser for the mips structures.
 * NOTE: Should be called after parsing has
 * finished.
 */
void mipsLexCleanUp() {
  // Nothing to delete.
}

/**
 * mipswrap is called when the pstream stream reaches the end
 * of a file.  Currently, it just returns at EOF, but it
 * can be written to redirect input to a different stream on
 * an EOF.
 */
int mipswrap() { return(1); }