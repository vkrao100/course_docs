########################################
# Only necessary for running MODELSIM:
# 
# In your shell (I use tcsh): you may need to define the license file
# before running make:
#
# setenv LM_LICENSE_FILE /uusoc/facility/cad_tools/Mentor/common_license
#
MODELTECH_BIN=/uusoc/facility/cad_tools/Mentor/MSIM-S17/linux_x86_64
CADTOOLS=/uusoc/facility/cad_common/local/bin/S17:/uusoc/facility/cad_common/local/bin/F16:/uusoc/facility/cad_common/local/bin/S16:/uusoc/facility/cad_common/local/bin/F15:/uusoc/facility/cad_common/local/bin/S15:/uusoc/facility/cad_common/local/bin/F14:/uusoc/facility/cad_common/local/bin/S14:/uusoc/facility/cad_common/local/bin/F13:/uusoc/facility/cad_common/local/bin/S13:
# Add tools paths to PATH
PATH=/usr/local/bin:/usr/openwin/bin:/usr/bin:/usr/ccs/bin:/usr/ucb:/usr/afsws/bin:/usr/afsws/etc:/bin:/usr/sbin:/usr/dt/bin:/uusoc/facility/cad_common/local/bin/:${CADTOOLS}:${MODELTECH_BIN}
#
########################################


all: clean c_compile syn sim validate

clean:
	echo ${path}
	-\rm test/GoldenResult
	-\rm test/VerilogResult
	-\rm goldenmodel/goldenmodel
	-\rm mult.dcopt.log

c_compile:
	g++ -Wall -ggdb -O -o goldenmodel/goldenmodel goldenmodel/goldenmodel.cpp
	#g++ -Wall -ggdb -O -o goldenmodel/goldenmodel goldenmodel/goldenmodelsimple.cpp
	goldenmodel/goldenmodel > test/GoldenResult

syn:
	# your code in here...

sim:
	#vlog mult.dcopt.v /uusoc/facility/cad_common/IBM/Artisan/8RF-1.2v/aci/sc-x/verilog/ibm13svt.v
	vsim -c -novopt -sdftyp /mult=mult.dcopt.sdf -t ps -do mult.do work.mult

validate:
	diff -c test/GoldenResult test/VerilogResult
