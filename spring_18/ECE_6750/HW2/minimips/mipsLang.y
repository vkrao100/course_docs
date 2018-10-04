%{

/**
 * rsgLex.l -- In theory this should generate tokens
 *             from a scanned Reduced State Graph file.
 *             Code Name RSG.
 *   
 * @author     Eric G. Mercer (eemercer@eng.uath.edu)
 *
 * @version    1.0, 30 May 1997
 *
 */

#include <iostream>
#include <stdio.h>
#include <vector>
#include <string>

#include "instruction.h"

extern int mipslex(void*);
extern istream* mips_istream;
extern char* mipstext;
extern vector<CMipsInst*>* mips_list;
void warn( const string& s, const int& i );
int mipserror(char* s);
extern int lineNumber;

%}

%pure_parser

%union yyDataType {
  int value;
  string* label;
  CMipsInst* inst;
};

%token ADD SUB AND OR SLT SLL SRL SRA
%token ADDI ANDI ORI SLTI
%token BEQ BNE J JR JAL
%token LW SW
%token NOP
%token DUMP
%token REG_MARK
%token LAB_MARK
%token COMMA
%token T_REG V_REG A_REG S_REG GP_REG SP_REG FP_REG RA_REG K_REG AT_REG ZERO_REG
%token INT
%token ID

%type  <value> INT reg_type 
%type  <inst>  ADD SUB AND OR SLT SLL SRL SRA ADDI ANDI ORI SLTI BEQ BNE J JR JAL LW SW i_type r_type j_type misc_type
%type  <label> ID

%start program

%%

 program:            instructions
                     ;  

 instructions:       instructions instruction 
                   | instruction
                     ;

 instruction:        r_type 
                     { mips_list->push_back( $1 );
		     }
                   | j_type
                     { mips_list->push_back( $1 );
		     }
                   | i_type
                     { mips_list->push_back( $1 );
		     }
                   | misc_type
                     { mips_list->push_back( $1 );
		     }
                   | ID LAB_MARK r_type
                     { $3->label( *($1) );
		       mips_list->push_back( $3 );
		       delete $1 
                     }
                   | ID LAB_MARK j_type
                     { $3->label( *($1) );
		       mips_list->push_back( $3 );
		       delete $1
                     }
                   | ID LAB_MARK i_type
                     { $3->label( *($1) );
		       mips_list->push_back( $3 );
		       delete $1
                     }
                   | ID LAB_MARK misc_type
                     { $3->label( *($1) );
		       mips_list->push_back( $3 );
		       delete $1
                     }
                     ;

 r_type:             ADD reg_type reg_type reg_type
                     { $$ = new CRtype( $3, $4, $2, 0, CRtype::_ADD_ ); 
		     }
                   | SUB reg_type reg_type reg_type
                     { $$ = new CRtype( $3, $4, $2, 0, CRtype::_SUB_ );
                     } 
                   | AND reg_type reg_type reg_type
                     { $$ = new CRtype( $3, $4, $2, 0, CRtype::_AND_ );
                     } 
                   | OR  reg_type reg_type reg_type
                     { $$ = new CRtype( $3, $4, $2, 0, CRtype::_OR_ );
                     } 
                   | SLT reg_type reg_type reg_type
                     { $$ = new CRtype( $3, $4, $2, 0, CRtype::_SLT_ );
                     } 
                   | SLL reg_type reg_type INT
                     { $$ = new CRtype( 0, $3, $2, $4, CRtype::_SLL_ );
                     } 
                   | SRL reg_type reg_type INT
                     { $$ = new CRtype( 0, $3, $2, $4, CRtype::_SRL_ );
                     } 
                   | SRA reg_type reg_type INT
                     { $$ = new CRtype( 0, $3, $2, $4, CRtype::_SRA_ );
                     } 
                   | JR  reg_type
                     { $$ = new CRtype( $2, 0, 0, 0, CRtype::_JR_ );
                     } 
                   ;
 j_type:             JAL INT
                     { $$ = new CJtype( CJtype::_JAL_, $2/4 );
		     }
                   | J   INT
                     { $$ = new CJtype( CJtype::_J_, $2/4 );
		     }
                   | JAL ID
                     { $$ = new CJtype( CJtype::_JAL_, *($2) );
		       delete $2;
		     }
                   | J   ID
                     { $$ = new CJtype( CJtype::_J_, *($2) );
		       delete $2;
		     }
                     ;

 i_type:             LW reg_type INT reg_type 
                     { $$ = new CItype( CItype::_LW_, $4, $2, $3 );
                     }
                   | SW reg_type INT reg_type
                     { $$ = new CItype( CItype::_SW_, $4, $2, $3 );
                     }
                   | ANDI reg_type reg_type INT
                     { $$ = new CItype( CItype::_ANDI_, $3, $2, $4 );
                     }
                   | ADDI reg_type reg_type INT
                     { $$ = new CItype( CItype::_ADDI_, $3, $2, $4 );
                     }
                   | ORI  reg_type reg_type INT
                     { $$ = new CItype( CItype::_ORI_, $3, $2, $4 );
                     }
                   | SLTI  reg_type reg_type INT
                     { $$ = new CItype( CItype::_SLTI_, $3, $2, $4 );
                     }
                   | BEQ  reg_type reg_type INT
                     { $$ = new CItype( CItype::_BEQ_, $2, $3, $4/4 );
                     }
                   | BNE  reg_type reg_type INT
                     { $$ = new CItype( CItype::_BNE_, $2, $3, $4/4 );
                     }
                   | BEQ  reg_type reg_type ID
                     { $$ = new CItype( CItype::_BEQ_, $2, $3, *($4) );
		       delete $4;
                     }
                   | BNE  reg_type reg_type ID
                     { $$ = new CItype( CItype::_BNE_, $2, $3, *($4) );
                       delete $4;
                     }
                     ; 
 
 misc_type:          DUMP 
                     { $$ = new CMisctype( CMisctype::_DUMP_ );
		     }
                   | NOP
                     { $$ = new CMisctype( CMisctype::_NOP_ );
		     }
                   ;
reg_type:            T_REG INT
                     {
                       assert( $2 >= 0 );
		       if ( $2 >= 0 && $2 <= 7 ) $$ = $2 + 8;
                       else if ( $2 >= 8 && $2 <= 9 ) $$ = $2 + 16;
                       else {
			 $$ = $2;
			 warn( "$t", $2 );
		       }
		     }
                   | V_REG INT
                     {
                       if ( $2 >= 0 && $2 <= 1 ) $$ = $2 + 2;
                       else {
			 $$ = $2;
			 warn( "$v", $2 );
		       }
		     }
                   | A_REG INT
                      {
                       if ( $2 >= 0 && $2 <= 3 ) $$ = $2 + 4;
                       else { 
			 $$ = $2;
			 warn( "$a", $2 );
		       }
		     }
                   | S_REG INT
                     {
                       if ( $2 >= 0 && $2 <= 7 ) $$ = $2 + 16;
                       else { 
			 $$ = $2;
			 warn( "$s", $2 );
		       }
		     }
                   | GP_REG
                     {
                       $$ = 28;
		     }
                   | SP_REG
                     { 
                       $$ = 29;
		     }
                   | FP_REG 
                     {
                       $$ = 30;
		     }
                   | RA_REG 
                     {
                       $$ = 31;
		     }
                   | K_REG INT
                     {
                       if ( $2 >=0 && $2 <= 1 ) $$ = $2 + 26;
		       else { 
			 $$ = $2;
			 warn( "$k", $2 );
		       }
		     }
                   | AT_REG
                     {
                       $$ = 1;
                     }
                   | ZERO_REG 
                     {
                       $$ = 0;
		     }
                   | REG_MARK INT
                     {
                       $$ = $2;
		     }                       
                     ;

%%

void warn( const string& s, const int& i ) {
  cout << endl << "Note: The label " << s << " one line " << lineNumber;
  cout << " did not fit mapping, using the specified register value " << i << ".";
}

int mipserror(char* s)
{
    cout << endl << "Confused: " << s << " on line " << lineNumber << " before " << mipstext << ".";
    return(1);
}
