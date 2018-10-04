#ifndef _storeprs_h
#define _storeprs_h

#include "struct.h"
#include "bcp.h"

tableSolADT find_minimal_prs(regionADT region,int nsignals,bool exact);

bool check_combo(stateADT *state_table,regionADT *regions,int nsignals,
		bool combo,bool exact,tableSolADT NewSol,int k,int l);

/*****************************************************************************/
/* Remove unnecessary C-elements.                                            */
/*****************************************************************************/

bool *check_combinational(stateADT *state_table,regionADT *regions,
                           int ninputs,int nsignals,bool combo);

/*****************************************************************************/
/* Check if current guard is symmetric to an upcoming guard.                 */
/*****************************************************************************/

bool symmetric_guard(regionADT start,regionADT region,int nsignals);

/*****************************************************************************/
/* Check if guards are disjoint.                                             */
/*****************************************************************************/

bool disjoint_check(char * filename,signalADT *signals,stateADT *state_table,
		    regionADT *regions,bool *comb,int ninpsig,int nsignals);

/*****************************************************************************/
/* Store production rules.                                                   */
/*****************************************************************************/
bool store_production_rules(char command,designADT design);

/*****************************************************************************/
/* Prints covers for a signal transition selected by NewSol.  Prints all    */
/*   NewSol is NULL.     .                                                   */
/*****************************************************************************/

bool print_covers(FILE *fp,char * filename,signalADT *signals,
		  regionADT *regions,bool exact,int *fanout,bool comb1,
		  bool comb2,int i,int nsignals,int maxsize,bool *first,
		  bool *okay,int *area,int *total_lits,FILE **errfp,
		  tableSolADT NewSol);

#endif  /* storeprs.h */