### compilers
CC =            g++
LEX=    	flex
YACC=   	bison -v

### Location of the STL library with Matrix components
STL = 		$(HOME)/sgi-stl/src
MATRIX = 	$(HOME)/tnt-lib

### Include directories to search for #include<>'s
INCLUDES =      -I$(STL) 

## Document Directory
DOCLATEX = ../doc/tex
DOCHTML = ../doc/html

### Compiler flags
DEBUGFLAGS = 	-g -D _DEBUG_ 
RELEASEFLAGS = 	-g 
EXECFLAGS =     -g -D _DEBUG_ -D _MAIN_ 
GCCBUG    =     -D _CTEL_ADAPT_
NET       =     -D _NO_NETWORK_

#===================================================================

PGMS = 		assembler 
DEBUG =		debug 
REL =       	release
OBJS =          mipsLang.tab.o lex.mips.o instruction.o

# Note that the first CTel is the default CTel
all:		$(PGMS)

# ------------------------------------------------------------------

assembler:	assembler.h assembler.cpp $(OBJS) 
		$(CC) $(INCLUDES) $(EXECFLAGS) $(GCCBUG) $(NET) -c assembler.cpp
		$(CC) $(INCLUDES) $(EXECFLAGS) $(GCCBUG) $(NET) -o assembler assembler.o $(OBJS)

mipsLang.tab.o:	mipsLang.y
		$(YACC) -p mips -d mipsLang.y 
		$(CC) $(INCLUDES) $(RELEASEFLAGS) $(NET) -c mipsLang.tab.c

lex.mips.o: 	mipsLang.l
		$(LEX) -Pmips mipsLang.l
		$(CC) $(INCLUDES) $(RELEASEFLAGS) $(NET) -c lex.mips.c

instruction.o:  instruction.h instruction.cpp 
		$(CC) $(INCLUDES) $(EXECFLAGS) $(GCCBUG) $(NET) -c instruction.cpp

# ------------------------------------------------------------------

clean:
		rm -f *.o $(PGMS) core *.dxx mipsLang.tab.h lex.mips.c mipsLang.tab.c

waste:
		rm -f *.o $(PGMS) 
