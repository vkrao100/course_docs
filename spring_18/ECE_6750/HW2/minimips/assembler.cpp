#include "assembler.h"

unsigned int index( const vector<CMipsInst*>& iList, const string& s ) {
  for ( vector<CMipsInst*>::const_iterator i = iList.begin() ; i != iList.end() ; i++ ) 
    if ( (*i)->label() == s )
      return( i - iList.begin() );
  cout << endl << "Failure, no instruction labels match " << s << ". ";
  assert(false);
}

unsigned short branchOffset( const vector<CMipsInst*>& iList, const string& s, const unsigned short& index ) {
  for ( vector<CMipsInst*>::const_iterator i = iList.begin() ; i != iList.end() ; i++ ) 
    if ( (*i)->label() == s ) {
      int tmp = ((i - iList.begin())-index);
      if ( tmp ) 
	return( tmp );
      else {
	return( (unsigned short)(int((double)pow( 2.0, 16.0 ) + tmp)) );
      }
    }
  cout << endl << "Failure, no instruction labels match " << s << ". ";
  assert(false);
}

bool resolveAddresses( vector<CMipsInst*>& iList ) {
  for ( vector<CMipsInst*>::const_iterator i = iList.begin() ; i != iList.end() ; i++ ) {
    if ( (*i)->type() == _JTYPE_  )
      if ( ((CJtype*)(*i))->address().length() )
	((CJtype*)(*i))->address( index( iList, ((CJtype*)(*i))->address() ) );
    if ( (*i)->type() == _ITYPE_ )
      if ( ((CItype*)(*i))->address().length() )
	((CItype*)(*i))->address( branchOffset( iList, ((CItype*)(*i))->address(), (i-iList.begin())+1 ) );
  }
  return( true );
}

int main( int argc, char* argv[] ) {
  cout << "MIPs Assembler compiled " << __DATE__ << " " << __TIME__;
  cout << endl << "Department of Electrical Engineering"; 
  cout << endl << "(c)opyright 1998";
  fstream parse_stream;
  fstream out_stream;
  string file;
  if ( argc > 1 )
    file = string( argv[1] );
  else {
    cout << endl << "Enter file name to compile -> ";
    cin >> file;
  }
  parse_stream.open( file.c_str(), ios::in );
  if ( parse_stream == NULL ) {
    cout << "Cannot open " << file << ", check file and try again." << endl;
    exit( 0 );
  }

  timeval t0,t1;
  double time;
  gettimeofday( &t0, NULL );
  vector<CMipsInst*> instList;
  mipsLexInit( parse_stream, instList );
  mipsparse();
  mipsLexCleanUp();
  gettimeofday( &t1, NULL );
  time = (t1.tv_sec+(t1.tv_usec*.000001)) - (t0.tv_sec+(t0.tv_usec*.000001));

  if ( argc > 2 )
    file = string( argv[2] );
  else {
    cout << "Enter output file name -> ";
    cin >> file;
  }
  out_stream.open( file.c_str(), ios::out );
  if ( out_stream == NULL ) {
    cout << "Cannot open " << file << ", check permissions and try again." << endl;
    exit( 0 );
  }

  assert( resolveAddresses( instList ) );

  for ( vector<CMipsInst*>::const_iterator i = instList.begin() ; i != instList.end() ; i++ ) {
    out_stream << **i << endl;
    delete *i;
  }
  //out_stream << endl;
  cout << endl << "Completed in " << time << " seconds.";
  cout << endl;

}