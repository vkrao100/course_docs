#include "instruction.h"

////////////////////////////////////////////////////////////////////////////////
//
int registerMap( string s, const int& r, const int& line ) {
  for (int i=0;i<s.length();i++) 
    s[i]=toupper(s[i]);
  if ( s == "ZERO" ) return( 0 );
  else if ( s == "V" && r >= 0 && r <= 1 ) return( r + 2 );
  else if ( s == "A" && r >= 0 && r <= 3 ) return( r + 4 );
  else if ( s == "T" && r >= 0 && r <= 7 ) return( r + 8 );
  else if ( s == "S" && r >= 0 && r <= 7 ) return( r + 16 );
  else if ( s == "T" && r >= 8 && r <= 9 ) return( r + 16 );
  else if ( s == "GP" ) return( 28 );
  else if ( s == "SP" ) return( 29 );
  else if ( s == "FP" ) return( 30 );
  else if ( s == "RA" ) return( 31 );
  else if ( s == "AT" ) return( 1 );
  else if ( s == "K" && r >=0 && r <= 1 ) return( r + 26 );
  cout << endl << "Note: The label" << s << " one line " << line;
  cout << " did not match any mapping, using the specified register value " << r << ".";
  return( r );
}
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//

const unsigned short CMipsInst::_MAX_CONST_VALUE_ = 65535;

string CMipsInst::to_binary( value_type val, const value_type& width ) const {
  string tmp;
  for( int i = 0 ; i < width ; i++ ) {
    if ( (val % 2) == 1 )
      tmp = '1' + tmp;
    else
      tmp = '0' + tmp;
    val /= 2;
  }
  return( tmp );
}

string CMipsInst::to_hex( unsigned long val, const value_type& width ) const {
  string tmp;
  for( int i = 0 ; i < width ; i+=4 ) {
    switch (val % 16) {
    case 0:
      tmp = '0' + tmp;
      break;
    case 1:
      tmp = '1' + tmp;
      break;
    case 2:
      tmp = '2' + tmp;
      break;
    case 3:
      tmp = '3' + tmp;
      break;
    case 4:
      tmp = '4' + tmp;
      break;
    case 5:
      tmp = '5' + tmp;
      break;
    case 6:
      tmp = '6' + tmp;
      break;
    case 7:
      tmp = '7' + tmp;
      break;
    case 8:
      tmp = '8' + tmp;
      break;
    case 9:
      tmp = '9' + tmp;
      break;
    case 10:
      tmp = 'a' + tmp;
      break;
    case 11:
      tmp = 'b' + tmp;
      break;
    case 12:
      tmp = 'c' + tmp;
      break;
    case 13:
      tmp = 'd' + tmp;
      break;
    case 14:
      tmp = 'e' + tmp;
      break;
    case 15:
      tmp = 'f' + tmp;
      break;
    default:
      break;
    }
    val /= 16;
  }
  return( tmp );
}

bool CMipsInst::regCheck( const value_type& val ) const {
  return( val <= 31 );
}
  
bool CMipsInst::valueCheck( const value_type& val ) const {
  return( val <= _MAX_CONST_VALUE_ );
}

CMipsInst::CMipsInst() : m_nOpcode(0), m_Label() {}

CMipsInst::CMipsInst( const value_type& op ) : m_nOpcode(op), m_Label() {}

CMipsInst::CMipsInst( const value_type& op, const string& s ) : m_nOpcode(op), m_Label(s) {} 

CMipsInst::~CMipsInst() {
  // Do Nothing
}

string CMipsInst::label() const {
  return( m_Label );
}
  
void CMipsInst::label( const string& s ) {
  m_Label = s;
}

void CMipsInst::binaryOut( ostream& s ) const {
  s << to_binary( m_nOpcode, 6 );
}

ostream& operator<<( ostream& s, const CMipsInst& i ) {
  i.binaryOut( s );
  return( s );
}
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
CRtype::CRtype() : CMipsInst(), m_nRs(0), m_nRt(0), m_nRd(0) {}

CRtype::CRtype( const value_type& rs, 
		const value_type& rt, 
		const value_type& rd,
		const value_type& shamt,
		const value_type& func ) : CMipsInst(0), 
                                           m_nRs(rs), 
                                           m_nRt(rt), 
                                           m_nRd(rd),
                                           m_nShamt(shamt),
                                           m_nFunc(func) {
   assert( regCheck( rs ) );
   assert( regCheck( rt ) );
   assert( regCheck( rd ) );
   assert( regCheck( shamt ) );
} 

CRtype::CRtype( const value_type& rs, 
		const value_type& rt, 
		const value_type& rd, 
		const value_type& shamt,
		const value_type& func,
		const string& s ) : CMipsInst(0,s), 
                                    m_nRs(rs), 
                                    m_nRt(rt), 
                                    m_nRd(rd),  
                                    m_nShamt(shamt),
                                    m_nFunc(func) {
   assert( regCheck( rs ) );
   assert( regCheck( rt ) );
   assert( regCheck( rd ) );
   assert( regCheck( shamt ) );

}

CRtype::~CRtype() {
  //DO NOTHING
}

void CRtype::binaryOut( ostream& s ) const {
  /*
  CMipsInst::binaryOut( s );
  s << to_binary( m_nRs, 5 ) << to_binary( m_nRt, 5 ) << to_binary( m_nRd, 5 );
  s << to_binary( m_nShamt, 5 ) << to_binary( m_nFunc, 6 );
  */
  unsigned long instr;
  instr=m_nOpcode;
  instr=(instr << 6) + m_nRs;
  instr=(instr << 5) + m_nRt;
  instr=(instr << 5) + m_nRd;
  instr=(instr << 5) + m_nShamt;
  instr=(instr << 6) + m_nFunc;
  s << to_hex(instr,32);
}
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
CItype::CItype() : CMipsInst(), m_nRs(0), m_nRt(0), m_nAddress(0), m_sAddress() {}

CItype::CItype( const value_type& op,
	        const value_type& rs, 
		const value_type& rt, 
		const value_type& address ) : CMipsInst(op), 
                                              m_nRs(rs), 
                                              m_nRt(rt), 
                                              m_nAddress(0),
                                              m_sAddress() {
   if ( address ) m_nAddress = address;
   else m_nAddress = (unsigned short)(int((double)pow( 2.0, 16.0 )) + address);
   assert( regCheck( rs ) );
   assert( regCheck( rt ) );
   assert( valueCheck( m_nAddress ) );
}

CItype::CItype( const value_type& op,
		const value_type& rs, 
		const value_type& rt, 
		const string& s ) : CMipsInst(op), 
                                    m_nRs(rs), 
                                    m_nRt(rt),
                                    m_nAddress(0),
                                    m_sAddress(s) {
   assert( regCheck( rs ) );
   assert( regCheck( rt ) );
}

CItype::~CItype() {
  //DO NOTHING
}

void CItype::address( const value_type& val ) {
  assert( valueCheck( val ) );
  m_nAddress = val;
}

string CItype::address() const { return( m_sAddress );}

void CItype::binaryOut( ostream& s ) const {
  /*
  CMipsInst::binaryOut( s );
  s << to_binary( m_nRs, 5 ) << to_binary( m_nRt, 5 );
  s << to_binary( m_nAddress, 16 );
  */
  unsigned long instr;
  instr=m_nOpcode;
  instr=(instr << 5) + m_nRs;
  instr=(instr << 5) + m_nRt;
  instr=(instr << 16) + m_nAddress;
  s << to_hex(instr,32);
}

//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
CJtype::CJtype() : CMipsInst(), m_nAddress(0), m_sAddress() {}

CJtype::CJtype( const value_type& op, 
		const value_type& address ) : CMipsInst(op), m_nAddress(address), m_sAddress() {
   assert( address <= 67108863 );
}

CJtype::CJtype( const value_type& op, 
		const string& s ) : CMipsInst(op), m_nAddress(0), m_sAddress(s) {}

CJtype::~CJtype() {
  // DO NOTHING
}

void CJtype::address( const unsigned int& val ) {
  assert( val <= 67108863  );
  m_nAddress = val;
}

string CJtype::address() const { return( m_sAddress ); }

void CJtype::binaryOut( ostream& s ) const {
  /*
  CMipsInst::binaryOut( s );
  s << to_binary( m_nAddress, 26 );
  */
  unsigned long instr;
  instr=m_nOpcode;
  instr=(instr << 26) + m_nAddress;
  s << to_hex(instr,32);
}
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
CMisctype::CMisctype() : CMipsInst(0), m_nFunc(0) {
}

CMisctype::CMisctype( const value_type& func ) : CMipsInst(0), m_nFunc( func ) {
} 

CMisctype::~CMisctype() {
  //DO NOTHING
}

void CMisctype::binaryOut( ostream& s ) const {
  CMipsInst::binaryOut( s );
  s << to_binary( m_nFunc, 26 );
}
//
////////////////////////////////////////////////////////////////////////////////
