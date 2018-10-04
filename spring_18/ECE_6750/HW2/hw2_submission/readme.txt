## vikas kumar rao - u1072596 ##

the file names within directories are self explanatory.
*_core - file with computation part describing the arithmetic operations
*_env - environment/testbench to load the values
*_top - wrapper top binding all the ports for core and env

I was able to compile and simulate all the VHDL files successfully on modelsim version 10.5c.

directory structure -
hw2.1 - adder_ckt
	hw2.1.1 - 4_bit_adder
	hw2.1.2 - 1_bit_adder
	hw2.1.3 - 4_1_bit_adder
	hw2.1.4 - 1_bit_adder_optimized

hw2.5 - minimips
	only modified files are fetch.vhd and decode.vhd