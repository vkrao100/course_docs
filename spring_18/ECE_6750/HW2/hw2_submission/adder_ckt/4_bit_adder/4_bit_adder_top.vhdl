--VHDL top for 4 bit adder 
-- Author - Vikas Rao
-- UnID - 1072596

--standard library declarations
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.nondeterminism.all;
use work.channel.all;

--entity declaration
entity FourBitAdder_top is
end entity FourBitAdder_top;

--behavioral description of adder
architecture structure of FourBitAdder_top is
	component FourBitAdder_core
		port (X:inout channel:=init_channel;
		      Y:inout channel:=init_channel;
		      Cin:inout channel:=init_channel;
		      Sum:inout channel:=init_channel;
		      Cout:inout channel:=init_channel);
	end component FourBitAdder_core;	
	component FourBitAdder_env is
		port (X:inout channel:=init_channel;
		      Y:inout channel:=init_channel;
		      Cin:inout channel:=init_channel;
		      Sum:inout channel:=init_channel;
		      Cout:inout channel:=init_channel);
	end component FourBitAdder_env;
	
	signal X:channel:=init_channel;
	signal Y:channel:=init_channel;
	signal Cin: channel:=init_channel;
	signal Sum: channel:=init_channel;
	signal Cout: channel:=init_channel;
	
	begin
		adder:FourBitAdder_core
			port map(X=>X,Y=>Y,Cin=>Cin,Sum=>Sum,Cout=>Cout);
		adder_env:FourBitAdder_env
			port map(X=>X,Y=>Y,Cin=>Cin,Sum=>Sum,Cout=>Cout);
	end structure;