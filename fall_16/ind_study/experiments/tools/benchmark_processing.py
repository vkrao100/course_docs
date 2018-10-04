#!/usr/bin/python
# Created by Vikas Rao @ 11/14/2016
# goal: wrapper script to process all the operations of converting a -
#  - .verilog multiplier benchmark to an alg output.
# steps:
#       1. take generated multiplier
#		2. open yosys
#		3. 

import os
import sys
import re
import fileinput
import string
import subprocess


def main():
	 
    # add tool and module directies as part of search paths in sys
    sys.path.insert(1,'/home/vkrao/Documents/ind_study/experiments/To_Vikas/tools')
    sys.path.insert(2,'/home/vkrao/Documents/ind_study/experiments/To_Vikas/Benchmarks/4x4_SG_SP_AR_RC')
    
    # collect the verilog benchmark to work on
    fileInput = sys.argv [-1]

    # setup the output verilog benchmark file name
    baseFile, ext = os.path.splitext(fileInput)
    yosysExt      = "_fh.v"
    blifExt       = "_fh.blif"
    blifSisExt    = "_fh_axi_map.blif"
    eqnExt        = "_fh.eqn"
    yosysVerOut   = os.path.join(baseFile + yosysExt)
    blifOut       = os.path.join(baseFile + blifExt)
    blifSisOut    = os.path.join(baseFile + blifSisExt)
    eqnOut        = os.path.join(baseFile + eqnExt)
    
    # return the top module name from benchmark file
    moduleName = return_module_name(fileInput)
    
    # execute yosys operations
    process_yosys(fileInput, yosysVerOut, moduleName)
    
    # call the verilog to blif/eqn converter script
    blif_eqn_creator(yosysVerOut)

    # call sis operations
    process_sis(eqnOut, blifSisOut)


def return_module_name(fileInput):

	with open(fileInput, 'r') as fin:
		for line in fin:
			if "Top module" in line:
				searchObjModule = re.search(r'\s*Top module:\s*(.*)', line, re.M|re.I)
				if searchObjModule:
					return searchObjModule.group(1)
				else: 
					print ("can't find top module name")
					exit()


def process_yosys(fileInput, yosysVerOut, moduleName):

	#prepare yosys command script for inline processing
    yos = open('yosys.cmd','w')
    yos.write('read_verilog %s\n' %fileInput)
    yos.write('flatten\n')
    yos.write('hierarchy -check -top %s\n' %moduleName)
    yos.write('write_verilog '+ yosysVerOut + '\n')
    yos.write('quit\n')
    yos.close()

    #call yosys and execute the commands
    wor_dir = os.getcwd()
    yosProc = subprocess.Popen(['yosys'], stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.PIPE, cwd=wor_dir)
    command = 'script yosys.cmd'
    yosProc.communicate(input=command.encode())
    print("\nprocess yosys completed\n")

def blif_eqn_creator(yosysVerOut):

	os.system("python3 verilog_to_blif_converter.py "+yosysVerOut)
	print("created blif and eqn files\n")

def process_sis(eqnOut, blifSisOut):
    
    sis = open('sisPrompt.cmd','w')
    sis.write('read_library lib2_and_xor_inv.lib\n')
    sis.write('read_eqn %s\n'%eqnOut)
    sis.write('sweep\n')
    sis.write('resub -a\n')
    sis.write('write_blif -n %s\n'%blifSisOut)
    sis.write('quit\n')
    sis.close()
    
    #call yosys and execute the commands
    wor_dir = os.getcwd()
    sisProc = subprocess.Popen(['sis'], stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.PIPE, cwd=wor_dir)
    command = 'source sisPrompt.cmd'
    sisProc.communicate(input=command.encode())
    print("process sis completed\n")
    
if __name__ == "__main__":
    main()
