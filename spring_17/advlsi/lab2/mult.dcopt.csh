#!/bin/csh -fb

############################################################
# This runs design compiler and creates the constraint files


### Script variable settings
## design compiler command - may need to run "setup-synopsys" first:
set dccmd  = "syn-dc"
## design definitions
# note that csh variables do not get imported into dc_shell :-(
set design = "mult"	# this should be the top level name of your design
set tool   = "dcopt"

### Execute script

# clean up result log
rm -f $design.$tool.out

# run rtlopt to make sure I get the correct constraints
./$design.rtlopt.csh

# Tool command
$dccmd -no_home_init  -f $design.$tool.tcl >& $design.$tool.out

#
############################################################
