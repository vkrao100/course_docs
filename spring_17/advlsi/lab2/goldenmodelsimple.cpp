/////////////////////////////////////////////////////////////
// Golden reference model for pipelined multiplier
//
// Authors         : Ken Stevens <kstevens@ece.utah.edu>
// Mod Date        : January 2010
// Revision        : 0.2
// Status          : 
// Bug Reports     : Ken Stevens <kstevens@ece.utah.edu>
//
// This program validates the design for a function unit that has been
// designed in a four-deep pipeline.  It is a simple debug pattern
// that runs a loop multiplying the inputs by 1 to 10 in all permuations.
// 
// Bugs:
//
// Improvements:
//
// Comments:
//
// Commands:
//   Compile with: "g++ -Wall -O -o goldenmodelsimple goldenmodelsimple.cpp"
//
///////////////////////////////////////////////////////////////

#include <stdio.h>

int main()
{
    unsigned char inA, inB;
    unsigned int result, stage0, stage1, stage2, stage3;

    // reset all pipeline stage latches.
    result = stage0 = stage1 = stage2 = stage3 = 0;

    // Loop 100 times doing all permutations of a*b for values 1,10
    for(inA = 0; inA < 11; inA++) {
	for(inB = 1; inB < 11; inB++) {

	    // shift data through pipeline
	    stage3 = stage2;
	    stage2 = stage1;
	    stage1 = stage0;
	    stage0 = result;
	    result = inA * inA + 97 * inB;

	    // print out result of pipelined multipler
	    // can only observe last stage
	    printf("a = %3d, b = %3d, result = %5d\n", inA, inB, stage3);
	}
    }

    return 0;
}
