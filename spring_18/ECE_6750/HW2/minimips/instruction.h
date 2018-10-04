#ifndef INSTRUCTION_H
#define INSTRUCTION_H

#include <iostream>
#include <string>
#include <assert.h>
#include <math.h>

using namespace std;

int registerMap( string s, const int& r = 0, const int& line = 0 );

enum insruction_type { _BASE_ = 0, _RTYPE_, _ITYPE_, _JTYPE_,_MISCTYPE_ };

////////////////////////////////////////////////////////////////////////////////
//

class CMipsInst {
protected:

  typedef unsigned short value_type;

  value_type m_nOpcode;

  string m_Label;

  static const unsigned short _MAX_CONST_VALUE_;

protected:

  string to_binary( value_type val, const value_type& width ) const;

  string to_hex( unsigned long val, const value_type& width ) const;

  bool regCheck( const value_type& val ) const;
  
  bool valueCheck( const value_type& val ) const;

public:

  CMipsInst();

  CMipsInst( const value_type& op );

  CMipsInst( const value_type& op, const string& s );

  virtual ~CMipsInst();

  string label() const;
  
  void label( const string& s );

  virtual int type() const { return( _BASE_ ); };

  virtual void binaryOut( ostream& s ) const;

  friend ostream& operator<<( ostream& s, const CMipsInst& i );

};

//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
class CRtype : public CMipsInst {
protected:
  
  value_type m_nRs;

  value_type m_nRt;
 
  value_type m_nRd;

  value_type m_nShamt;
  
  value_type m_nFunc;

public:

  enum inst_type { _SLL_ = 0,
		   _SRL_ = 2,
		   _SRA_ = 3,
		   _JR_  = 8,
                   _ADD_ = 32, 
		   _SUB_ = 34,
		   _AND_ = 36,
		   _OR_  = 37,
		   _SLT_ = 42 };
public:

  CRtype();

  CRtype( const value_type& rs, 
	  const value_type& rt, 
	  const value_type& rd,
	  const value_type& shamt,
	  const value_type& func );

  CRtype( const value_type& rs, 
	  const value_type& rt, 
	  const value_type& rd,
	  const value_type& shamt,
	  const value_type& func,
	  const string& s );

  ~CRtype();

  int type() const { return( _RTYPE_ ); };

  void binaryOut( ostream& s ) const;

};
//
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
//
class CItype : public CMipsInst {
protected:
  
  value_type m_nRs;

  value_type m_nRt;
 
  value_type m_nAddress;

  string m_sAddress;

public:

  enum inst_type { _BEQ_ = 4,
		   _BNE_  = 5,
		   _ADDI_ = 8,
		   _ANDI_  = 12,
		   _ORI_ = 13, 
		   _SLTI_ = 10, 
		   _LW_ = 35,
		   _SW_ = 43 };
public:

  CItype();

  CItype( const value_type& op,
	  const value_type& rs, 
	  const value_type& rt, 
	  const value_type& address );

  CItype( const value_type& op,
	  const value_type& rs, 
	  const value_type& rt, 
	  const string& s );

  ~CItype();

  void address( const value_type& val );

  string address() const;

  int type() const { return( _ITYPE_ ); };

  void binaryOut( ostream& s ) const;

};
//
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
//
class CJtype : public CMipsInst {
protected:
  
  unsigned int m_nAddress;

  string m_sAddress;

public:

  enum inst_type { _J_ = 2, _JAL_  = 3 };

public:

  CJtype();

  CJtype( const value_type& op, const value_type& address );

  CJtype( const value_type& op, const string& s );

  ~CJtype();

  void address( const unsigned int& val );

  string address() const;

  int type() const { return( _JTYPE_ ); };

  void binaryOut( ostream& s ) const;

};
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
class CMisctype : public CMipsInst {

  value_type m_nFunc;

public:

  enum inst_type { _DUMP_ = 13, _NOP_ = 32 };

public:

  CMisctype();

  CMisctype( const value_type& func );

  ~CMisctype();

  int type() const { return( _MISCTYPE_ ); };

  void binaryOut( ostream& s ) const;

};
//
////////////////////////////////////////////////////////////////////////////////

#endif
