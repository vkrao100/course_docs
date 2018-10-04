--VHDL top for 1 bit adder 
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
entity OneBitAdder_top is
end entity OneBitAdder_top;

--behavioral description of adder
architecture structure of OneBitAdder_top is
	component OneBitAdder_core
		port (X:inout channel:=init_channel;
		      Y:inout channel:=init_channel;
		      Cin:inout channel:=init_channel;
		      Sum:inout channel:=init_channel;
		      Cout:inout channel:=init_channel);
	end component OneBitAdder_core;	
	component OneBitAdder_env is
		port (X:inout channel:=init_channel;
		      Y:inout channel:=init_channel;
		      Cin:inout channel:=init_channel;
		      Sum:inout channel:=init_channel;
		      Cout:inout channel:=init_channel);
	end component OneBitAdder_env;
	
	signal X:channel:=init_channel;
	signal Y:channel:=init_channel;
	signal Cin: channel:=init_channel;
	signal Sum: channel:=init_channel;
	signal Cout: channel:=init_channel;
	
	begin
		adder:OneBitAdder_core
			port map(X=>X,Y=>Y,Cin=>Cin,Sum=>Sum,Cout=>Cout);
		adder_env:OneBitAdder_env
			port map(X=>X,Y=>Y,Cin=>Cin,Sum=>Sum,Cout=>Cout);
	end structure;