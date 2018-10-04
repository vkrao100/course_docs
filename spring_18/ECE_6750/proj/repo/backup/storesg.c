#include "storesg.h"
#include "findreg.h"

/*****************************************************************************/
/* Store reduced state graph.                                                */
/*****************************************************************************/

void store_state_graph(char * filename,signalADT *signals,eventADT *events,
		       stateADT *state_table,int ninpsig,int nsignals)
{
  char outname[FILENAMESIZE];
  FILE *fp;
  int i;
  stateADT curstate;
  statelistADT predstate;

  strcpy(outname,filename);
  strcat(outname,".rsg");
  printf("Storing reduced state graph to:  %s\n",outname);
  fprintf(lg,"Storing reduced state graph to:  %s\n",outname);
  fp=Fopen(outname,"w"); 
  fprintf(fp,"SG:\n");
  print_state_vector(fp,signals,nsignals,ninpsig);
  fprintf(fp,"STATES:\n");
  for (i=0;i<PRIME;i++)
    for (curstate=state_table[i];
	 curstate != NULL && curstate->state != NULL;
	 curstate=curstate->link) {
      fprintf(fp,"%d:%s\n",curstate->number,curstate->state);
    }
  fprintf(fp,"EDGES:\n");
  for (i=0;i<PRIME;i++)
    for (curstate=state_table[i];
	 curstate != NULL && curstate->state != NULL;
	 curstate=curstate->link)
      for (predstate=curstate->pred;predstate;
	   predstate=predstate->next) {
	fprintf(fp,"%d:%s - %s -> %d:%s\n",predstate->stateptr->number,
		predstate->stateptr->state,
		events[predstate->enabled]->event,
		curstate->number,curstate->state);
    }
  fclose(fp);
}