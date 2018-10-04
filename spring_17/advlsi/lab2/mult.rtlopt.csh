#!/bin/csh -fb

############################################################
# This runs design compiler and creates the constraint files
# This is the first of two scripts to be run
# This one basically ensures the verilog is correct

### Script variable settings
## design compiler command - may need to run "setup-synopsys" first:
set dccmd  = "syn-dc"
## design definitions
# note that csh variables do not get imported into dc_shell :-(
set design = "mult"	# this should be the top level name of your design
set tool   = "rtlopt"


### Execute script

# clean up result log
rm -f $design.$tool.out

# Tool command
$dccmd -no_home_init  -f $design.$tool.tcl >& $design.$tool.out


#
############################################################
