#!/usr/bin/python
# Author - Vikas Rao 
# goal: parse *.prs  and convert each gate into a state graph
# and derive a single state graph with pruned state space
import os
import sys
import argparse
import fileinput
import re
import string
import datetime

from collections import namedtuple

class StateGraph(object):

    def __init__(self, graph_dict=None):
        if graph_dict == None:
            graph_dict = {}
        self.__graph_dict = graph_dict

    def vertices(self):
        #returns the vertices of a graph
        return list(self.__graph_dict.keys())

    def edges(self):
        #returns the edges of a graph
        return self.__generate_edges()

    def add_vertex(self, vertex):
        # If the vertex "vertex" is not in 
        #     self.__graph_dict, a key "vertex" with an empty
        #     list as a value is added to the dictionary. 
        #     Otherwise nothing has to be done. 
        if vertex not in self.__graph_dict:
            self.__graph_dict[vertex] = []

    def add_edge(self, edge):
         # assumes that edge is of type set, tuple or list; 
         #    between two vertices can be multiple edges! 
        
        edge = set(edge)
        (vertex1, vertex2) = tuple(edge)
        if vertex1 in self.__graph_dict:
            self.__graph_dict[vertex1].append(vertex2)
        else:
            self.__graph_dict[vertex1] = [vertex2]

    def __generate_edges(self):
         # A static method generating the edges of the 
         #    graph "graph". Edges are represented as sets 
         #    with one (a loop back to the vertex) or two 
         #    vertices 
        
        edges = []
        for vertex in self.__graph_dict:
            for neighbour in self.__graph_dict[vertex]:
                if {neighbour, vertex} not in edges:
                    edges.append({vertex, neighbour})
        return edges

    def __str__(self):
        res = "vertices: "
        for k in self.__graph_dict:
            res += str(k) + " "
        res += "\nedges: "
        for edge in self.__generate_edges():
            res += str(edge) + " "
        return res

def main():

    #imports from given helper libraries
    from datetime import datetime

    #maintain a wire dictionary
    from collections import defaultdict
    prsDict = defaultdict(list)
    lpnDict = defaultdict(list)
    stateDict = defaultdict()
    
    #file input details
    fileInput1     = sys.argv [-2]
    fileInput2     = sys.argv [-1]

    try:
        f1 = open(fileInput1,"r")
        f2 = open(fileInput2,"r")
    except IOError:
        print ("File open failed! Need an input *.prs file at commandline")

    f1.close()
    f2.close()

    baseFile, ext  = os.path.splitext(fileInput1)
    outputSuffixP  = "prs.out"

    #output file string
    newFilePrs = os.path.join(baseFile + "." + outputSuffixP)

    #interested keywords from input file
    interestedKeyWords1 = ['[','(',']',')',':','+','-']
    interestedKeyWords2 = ['outputs','init_state','markings','inputs', 'internal','#@','<','{','+','-']
    interestedSymbols  = ['~', '&']
    excludeSymbols = interestedKeyWords1 + interestedSymbols

    index      = 0
    outputVars = ''
    inputVars  = ''
    combList   = []
    charList   = []
    outputList = []
    inputList  = []

    with open(fileInput1, 'r') as fin:
        for line in fin:
            if any(keyWord in line for keyWord in interestedKeyWords1):
                searchObjRise = re.search( r'\[\+(.*):\s+\((.*)\)\]', line, re.M|re.I)
                if searchObjRise:
                    if searchObjRise.group(1) not in outputList:
                        outputList.append(searchObjRise.group(1))
                    charList.extend(re.split(' & ',searchObjRise.group(2)))
                searchObjFall = re.search(r'\[\-(.*):\s+\((.*)\)\]', line, re.M|re.I)
                if searchObjFall:
                    if searchObjFall.group(1) not in outputList:
                        outputList.append(searchObjFall.group(1))
                    charList.extend(re.split(' & ',searchObjFall.group(2)))
                searchObjComb = re.search(r'\[\s(.*):\s+\((.*)\)\]', line, re.M|re.I)
                if searchObjComb:
                    if searchObjComb.group(1) not in outputList:
                        outputList.append(searchObjComb.group(1))
                    charList.extend(re.split(' & ',searchObjComb.group(2)))
    inputList = [re.compile(r'~').sub('', m) for m in charList]
    inputList = list(set(inputList))
    globalList = outputList + [x for x in inputList if x not in outputList]
    allVars = ''.join(globalList)

    with open(fileInput1, 'r') as fin:
        for line in fin:
            cubeVars = allVars
            if any(keyWord in line for keyWord in interestedKeyWords1):
                searchObjRise = re.search( r'\[\+(.*):\s+\((.*)\)\]', line, re.M|re.I)
                if searchObjRise:
                    if searchObjRise.group(1) not in outputVars:
                        outputVars += searchObjRise.group(1)
                    charList = re.split(' & ',searchObjRise.group(2))
                    for val in charList:
                        literal = val.strip('~')
                        index = cubeVars.find(literal)
                        if '~' in val:
                            cubeVars = cubeVars.replace(literal,str(0))
                        else:
                            cubeVars = cubeVars.replace(literal,str(1))
                    for lVar in globalList:
                        if lVar in cubeVars:
                            cubeVars = cubeVars.replace(lVar,'-')
                    prsDict["+"+searchObjRise.group(1)] = cubeVars
                searchObjFall = re.search(r'\[\-(.*):\s+\((.*)\)\]', line, re.M|re.I)
                if searchObjFall:
                    if searchObjFall.group(1) not in outputVars:
                        outputVars += searchObjFall.group(1)
                    charList = re.split(' & ',searchObjFall.group(2))
                    for val in charList:
                        literal = val.strip('~')
                        index = cubeVars.find(literal)
                        if '~' in val:
                            cubeVars = cubeVars.replace(literal,str(0))
                        else:
                            cubeVars = cubeVars.replace(literal,str(1))
                    for lVar in globalList:
                        if lVar in cubeVars:
                            cubeVars = cubeVars.replace(lVar,'-')
                    prsDict["-"+searchObjFall.group(1)] = cubeVars
                searchObjComb = re.search(r'\[\s(.*):\s+\((.*)\)\]', line, re.M|re.I)
                if searchObjComb:
                    if searchObjComb.group(1) not in outputVars:
                        outputVars += searchObjComb.group(1)
                    charList = re.split(' & ',searchObjComb.group(2))
                    for val in charList:
                        literal = val.strip('~')
                        index = cubeVars.find(literal)
                        if '~' in val:
                            cubeVars = cubeVars.replace(literal,str(0))
                        else:
                            cubeVars = cubeVars.replace(literal,str(1))
                    for lVar in globalList:
                        if lVar in cubeVars:
                            cubeVars = cubeVars.replace(lVar,'-')
                    if prsDict[searchObjComb.group(1)]:
                        combList.append(prsDict[searchObjComb.group(1)])
                        combList.append(cubeVars)
                        prsDict[searchObjComb.group(1)] = combList
                    else:
                        prsDict[searchObjComb.group(1)] = cubeVars
        print(prsDict)    

    lpnOutputList = []
    lpnInputList  = []
    lpnIntList    = []
    lpnMarkngList = []
    lpnTrnList = []
    initState = ''

    with open(fileInput2, 'r') as fin1:
        for line in fin1:
            if any(keyWord in line for keyWord in interestedKeyWords2):
                searchObjOut = re.search( r'\.outputs(.*)', line, re.M|re.I)
                if searchObjOut:
                    lpnOutputList = (searchObjOut.group(1)).split()
                searchObjInp = re.search(r'\.inputs(.*)', line, re.M|re.I)
                if searchObjInp:
                    lpnInputList = (searchObjInp.group(1)).split()
                searchObjInt = re.search(r'\.internal(.*)', line, re.M|re.I)
                if searchObjInt:
                    lpnIntList = (searchObjInt.group(1)).split()
                searchObjInitSt = re.search(r'#@\.init_state\s\[(.*)\]', line, re.M|re.I)
                if searchObjInitSt:
                    initState = searchObjInitSt.group(1)
                searchObjMarkng = re.search(r'\.marking\s\{(.*)\}', line, re.M|re.I)
                if searchObjMarkng:
                    lpnMarkngList = (searchObjMarkng.group(1)).split()
                searchObjTrn = re.search(r'^[^.#]', line, re.M|re.I)
                if searchObjTrn:
                    lpnTrnList = line.split()
                    lpnDict[lpnTrnList[0]] = line.split()

#create state graph
    # graph = StateGraph(lpnDict)
    # print(graph.vertices())
    # print(graph.edges()
    varsLength = len(allVars)
    key, value = lpnDict.popitem()
    listLen = len(value)
    incomingTrigger = value[0]
    nextTransition = value[1:]
    # print(value)
    # print(incomingTrigger)
    # print(nextTransition)
    
    stateVal = "RR1"
    Transition = "x+"
    InverseTransition = "x-"
    nextState = "1R1"
    storeState(stateDict,stateVal,Transition,nextState)

def storeState(stateDict,stateVal,Transition,nextState):
    
    if "+" in Transition:
        InverseTransition = Transition.replace("+","-")
    else:
        InverseTransition = Transition.replace("-","+")
    
    if stateVal not in stateDict:
        stateDict[stateVal] = (dict(), dict())
    stateDict[stateVal][0][Transition] = nextState
    if nextState not in stateDict:
        stateDict[nextState] = (dict(), dict())
    stateDict[nextState][1][Transition] = stateVal
    stateDict[nextState][0][InverseTransition] = "FAIL"
    if "FAIL" not in stateDict:
        stateDict["FAIL"] = (dict(), dict())
    stateDict["FAIL"][1][InverseTransition] = nextState

    # print(stateDict["FAIL"][1])
    print(stateDict)
    return stateDict

# stateStruct = namedtuple('stateStruct',["state,marking,enablings,colorvec,evalvec,number,highlight,color,visited,"])

# /*****************************************************************************/
# /* States                                                                    */
# /*     For each signal bits[] is: 0 if signal is low, R if signal is low     */
# /*       but enabled to rise, 1 if signal is high, F if signal is high but   */
# /*       enabled to fall.                                                    */
# /*****************************************************************************/

# typedef struct state_tag {
#   char * state;
#   char * marking;
#   char * enablings;
#   char * colorvec;    // vector of colors, one for each node
#   char * evalvec;     // vector of boolean evaluations, one for each node
#   int number;
#   int highlight;
#   int color;
#   bool visited;
#   double probability;
#   int num_clocks;
#   struct state_tag *link;
#   struct state_list_tag *pred;
#   struct state_list_tag *succ;
#   clocklistADT clocklist;
# } *stateADT;

# typedef struct state_list_tag {
#   stateADT stateptr;
#   int enabling;
#   int enabled;
#   int iteration;
#   char * colorvec;     // vector of colors, one for each node
#   int color;
#   struct state_list_tag *next;
#   double probability;
# } *statelistADT;


# typedef struct ver_state{
#   char * state;
#   char * marking;
#   char * enablings;
#   char * imp_state;
#   char * imp_marking;
#   char * imp_enablings;
#   struct ver_state *next;
#   int number;
#   ver_clocklistADT clocklist;
# } *ver_stateADT;

# def build_state_graph():
#     # Build a state graph from the extended burst-mode specification.

#     local($i,$curr_state,$end_vector,$in_vector,@prev_rf_state_vector,@state_vector,@next_states,@in_bursts,@out_bursts);
#     $curr_state = @_[0];
#     $prev_vector = @_[1];
#     $prev_burst = @_[2];

#     @prev_rf_state_vector = split(//,$prev_vector);
#     $tmp_vector = $prev_vector;
#     $tmp_vector =~ s/R/1/g;
#     $tmp_vector =~ s/F/0/g;
#     @state_vector = split(//,$tmp_vector);
#     if($debug){print $id."DFS trace - state $curr_state, state vector = ",@state_vector,"\n";}
#     $next_states = $graph{$curr_state}{next_state};
#     $next_states =~ s/,$//;
#     @next_states = split(/,/,$next_states);
#     $in_bursts = $graph{$curr_state}{in_burst};
#     $in_bursts =~ s/,$//;
#     @in_bursts = split(/,/,$in_bursts);
#     $out_bursts = $graph{$curr_state}{out_burst};
#     $out_bursts =~ s/,$//;
#     @out_bursts = split(/,/,$out_bursts);
#     @rf_state_vector = @state_vector;
#     # Mark enabled inputs with R,F,-.
#     foreach $name (keys %level_signals) {
#     @rf_state_vector[$signal_position{$name}] = "-"; }
#     foreach $burst (@in_bursts) {
#     @signals = split(/\s+/,$burst);
#     foreach $signal (@signals) {
#         $name = $signal;
#         $name =~ s/\+|-|\*|\[|\]//g;
#         $position = $signal_position{$name};
#         if ($signal =~ /-(?!\])/) {
#         # Falling edge
#         @rf_state_vector[$position] = "F"; }
#         elsif ($signal =~ /\+(?!\])/) {
#         # Rising edge
#         @rf_state_vector[$position] = "R"; }
#         elsif ($signal =~ /\*(?!\])/) {
#         # Directed don't care
#         if (@prev_rf_state_vector[$position] eq "0") {    # First ddc occurrence in the ddc transition.
#             @rf_state_vector[$position] = "R"; } 
#         elsif (@prev_rf_state_vector[$position] eq "1") {
#             @rf_state_vector[$position] = "F"; }
#         elsif (@prev_rf_state_vector[$position] eq "R") { # Second or later ddc occurrence in ddc transition.
#             @rf_state_vector[$position] = "R"; }
#         elsif (@prev_rf_state_vector[$position] eq "F") {
#             @rf_state_vector[$position] = "F"; }
#         else { die $id."ERROR: Cannot determine value of directed don't care.\n"; }}
#         elsif ($signal =~ /(?:\+|-)\]/) { }
#         # Specified and unspecified level signals alike are X throughout input transition.
#         else {
#         die $id."ERROR: Signal $signal not of recognizable type (terminating edge, directed don't care, level).\n"; }
#     }
#     }
#     if($debug){print join("",@rf_state_vector)."  ".join(", ",@in_bursts)." |\n";}
#     $in_vector = join("",@rf_state_vector);
#     $state_visited{$curr_state} = 1;
#     $state_graph{$curr_state}{state_vector} = $in_vector;
#     if ($prev_burst !~ /\w/) {
#     $dfs_start_rf_state_vector = $end_vector; }
#     $states++;
#     $i = 0;
#     foreach $next_state (@next_states) {
#     if($debug){print "$curr_state  $next_state   ".@in_bursts[$i]."  |  ".@out_bursts[$i]."\n";}
#     @rf_state_vector = @state_vector;
#     $tc = join("",@state_vector);
#     $tc =~ s/0|1|R|F/-/g;
#     @tc = split(//,$tc);
#     $burst = @in_bursts[$i];
#     $in_burst = $burst;
#     $in_burst =~ s/\s+/,/g;
#     @signals = split(/\s+/,$burst);
#     # Fire all inputs in current burst to form state vector after input changes have ended.
#     foreach $signal (@signals) {
#         $name = $signal;
#         $name =~ s/\+|-|\*|\[|\]//g;
#         $position = $signal_position{$name};
#         if ($signal =~ /-/) { 
#         # Falling edge or 0 level signal
#         if ($signal !~ /\[/) { @tc[$position] = "0"; }
#         @rf_state_vector[$position] = "0"; }
#         elsif ($signal =~ /\+/) { 
#         # Rising edge or 1 level signal
#         if ($signal !~ /\[/) { @tc[$position] = "1"; }
#         @rf_state_vector[$position] = "1"; }
#         elsif($signal =~ /\*/) {
#         # Directed don't care.
#         if (@prev_rf_state_vector[$position] eq "0") {    # First ddc occurrence in the ddc transition.
#             @rf_state_vector[$position] = "R"; } 
#         elsif (@prev_rf_state_vector[$position] eq "1") {
#             @rf_state_vector[$position] = "F"; }
#         elsif (@prev_rf_state_vector[$position] eq "R") { # Second or later ddc occurrence in ddc transition.
#             @rf_state_vector[$position] = "R"; }
#         elsif (@prev_rf_state_vector[$position] eq "F") {
#             @rf_state_vector[$position] = "F"; }}}
#     # Mark eventual enabled outputs with R,F.
#     $burst = @out_bursts[$i];
#     $end_vector = join("",@rf_state_vector);
#     $end_burst = $in_burst;
#     @signals = split(/\s+/,$burst);
#     if ($#signals >= 0) { 
#         $out_burst = $burst;
#         $out_burst =~ s/\s+/$burst_num,/g;
#         $out_burst .= $burst_num;
#         $end_burst = $out_burst;
#         @tmp_state_vector = @rf_state_vector;
#         $cs = "";
#         while (($name,$position) = each(%signal_position)) {
#         if ((@tc[$position] eq "-") && ((@rf_state_vector[$position] eq "0") || (@rf_state_vector[$position] eq "1"))) {
#             if (@rf_state_vector[$position] eq "0") { $cs .= $name.","; }
#             else { $cs .= "~".$name.","; }}}
#         foreach $signal (@signals) {
#         $ec{$signal} .= join("",@tmp_state_vector).",";
#         $tc{$signal.$burst_num}{state_vector} = join("",@tc);
#         $tc{$signal.$burst_num}{trigger_signals} = $in_burst;
#         $cs{$signal.$burst_num} = $cs;
#         $name = $signal;
#         $name =~ s/\+|-//;
#         if ($signal =~ /-/) { 
#             # Falling edge 
#             @rf_state_vector[$signal_position{$name}] = "F"; }
#         elsif ($signal =~ /\+/) { 
#             # Rising edge
#             @rf_state_vector[$signal_position{$name}] = "R"; }}
#         if($debug){print join("",@rf_state_vector)."  | ".@out_bursts[$i]."\n";}
#         $out_vector = join("",@rf_state_vector);
#         $state_graph{$curr_state}{next_state} .= $curr_state."_".$next_state.",";
#         $state_graph{$curr_state}{burst} .= $in_burst.";";
#         $state_graph{$curr_state."_".$next_state}{state_vector} = $out_vector;
#         $state_graph{$curr_state."_".$next_state}{next_state} = $next_state;
#         $state_graph{$curr_state."_".$next_state}{burst} = $out_burst;
#         $end_vector = join("",@rf_state_vector);
#         $states++;
#         $burst_num++; }
#     else {
#         $state_graph{$curr_state}{next_state} .= $next_state.",";
#         $state_graph{$curr_state}{burst} .= $in_burst.";"; }
#     # Handle dfs iteration.
#     if (! $state_visited{$next_state}) { 
#         &build_state_graph($next_state,$end_vector,$end_burst); }
#     $i++;
#     }

# // *********************************************************************
# // Build a cube that represents the evaluations of the predecessors
# // to the node of interest in curstate.
# // Cube is a character vector (0,1,X) of length (# of preds).
# // *********************************************************************
# char* build_forcing_cube(stateADT curstate, nodelistADT curnode,
#              int num_preds) {

#   int index=0;
#   char* cube;

#   cube=(char*)GetBlock(sizeof(char)*(num_preds+1));
  
#   // foreach v in preds of u
#   for (nodelistADT prednode=curnode->this_node->preds;prednode;
#        prednode=prednode->link) {
    
#     // If v is in (I union O)
#     if ((prednode->this_node->type == IO) ||
#     (prednode->this_node->type == INNEE) ||
#     (prednode->this_node->type == OUTTEE)) {
      
#       // cube[index] = curstate->evalvec[index];
#       if ((curstate->state[prednode->this_node->name] == '0') ||
#       (curstate->state[prednode->this_node->name] == 'R'))
#     cube[index] = '0';
#       else
#     cube[index] = '1';
#     }
#     else if (curstate->colorvec[prednode->this_node->counter] == '1')
#       cube[index] = '1';
#     else if (curstate->colorvec[prednode->this_node->counter] == '0')
#       cube[index] = '0';
#     else
#       cube[index] = 'X';
#     index++;
#   }
#   cube[index] = '\0';
#   return cube;
# }

# // ********************************************************************
# // Checks state graph for coloring inconsistancies. Any R->F, R->D,
# // U->F, U->D, F->R, F->U, D->R, or D->U transition between two
# // states is flagged and returns true, if the edge between them is not
# // stable, indicating a coloring error.
# // ********************************************************************
# int sg_check(designADT design, node* curnode) {

#   int index = curnode->counter;
#   bool error = false;
#   int error1 = 0;

#   for (int i=0;i<PRIME;i++) {
#     for (stateADT curstate=design->state_table[i];
#      curstate != NULL && curstate->state != NULL;
#      curstate=curstate->link) {
      
#       // Look at all next states from curstate
#       for (statelistADT edge=curstate->succ;
#        (edge != NULL && edge->stateptr->state != NULL);
#        (edge=edge->next)) {
#     if (((curstate->colorvec[index] == 'R') ||
#          (curstate->colorvec[index] == 'U')) && 
#         ((edge->stateptr->colorvec[index] == 'F') ||
#          (edge->stateptr->colorvec[index] == 'D'))) {
#       if ((edge->colorvec[index] != '1'))
#         error = true;
#     }
#     else if (((curstate->colorvec[index] == 'F') ||
#           (curstate->colorvec[index] == 'D')) && 
#          ((edge->stateptr->colorvec[index] == 'R') ||
#           (edge->stateptr->colorvec[index] == 'U'))) {
#       if ((edge->colorvec[index] != '0'))
#         error = true;
#     }
#     if (error) {
# #ifdef __VERBOSE_HAZINFO__
#       cout << "  " << curstate->colorvec[index] << "->"
#            << edge->colorvec[index] << "->"
#            << edge->stateptr->colorvec[index];
#       print_coloring_error(design, curstate, edge, index);
# #endif
#       error = false;
#       error1++;
#     }
#       }
#     }
#   }
#   return error1;
# }
#main function call
main()

