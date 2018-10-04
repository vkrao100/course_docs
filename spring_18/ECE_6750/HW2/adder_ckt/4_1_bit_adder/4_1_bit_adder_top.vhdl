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
entity FourOneBitAdder_top is
end entity FourOneBitAdder_top;

--behavioral description of adder
architecture structure of FourOneBitAdder_top is
	component OneBitAdder_core
		port (X:inout channel:=init_channel;
		      Y:inout channel:=init_channel;
		      Cin:inout channel:=init_channel;
		      Sum:inout channel:=init_channel;
		      Cout:inout channel:=init_channel);
	end component OneBitAdder_core;	
	component FourOneBitAdder_env is
		port (X0:inout channel:=init_channel;
			  X1:inout channel:=init_channel;
			  X2:inout channel:=init_channel;
			  X3:inout channel:=init_channel;
			  Y0:inout channel:=init_channel;
			  Y1:inout channel:=init_channel;
			  Y2:inout channel:=init_channel;
			  Y3:inout channel:=init_channel;
			  Cin:inout channel:=init_channel;
			  Sum0:inout channel:=init_channel;
			  Sum1:inout channel:=init_channel;
			  Sum2:inout channel:=init_channel;
			  Sum3:inout channel:=init_channel;
			  Cout:inout channel:=init_channel);
	end component FourOneBitAdder_env;
	
	signal X0:channel:=init_channel;
	signal X1:channel:=init_channel;
	signal X2:channel:=init_channel;
	signal X3:channel:=init_channel;
	signal Y0:channel:=init_channel;
	signal Y1:channel:=init_channel;
	signal Y2:channel:=init_channel;
	signal Y3:channel:=init_channel;
	signal Cin:channel:=init_channel;
	signal Sum0:channel:=init_channel;
	signal Sum1:channel:=init_channel;
	signal Sum2:channel:=init_channel;
	signal Sum3:channel:=init_channel;
	signal C0:channel:=init_channel;
	signal C1:channel:=init_channel;
	signal C2:channel:=init_channel;
	signal Cout:channel:=init_channel;	
	begin
		adder0:OneBitAdder_core
			port map(X=>X0,Y=>Y0,Cin=>Cin,Sum=>Sum0,Cout=>C0);
		adder1:OneBitAdder_core
			port map(X=>X1,Y=>Y1,Cin=>C0,Sum=>Sum1,Cout=>C1);		
		adder2:OneBitAdder_core
			port map(X=>X2,Y=>Y2,Cin=>C1,Sum=>Sum2,Cout=>C2);
		adder3:OneBitAdder_core
			port map(X=>X3,Y=>Y3,Cin=>C2,Sum=>Sum3,Cout=>Cout);
		adder_env:FourOneBitAdder_env
			port map(X0=>X0,Y0=>Y0,X1=>X1,Y1=>Y1,X2=>X2,Y2=>Y2,X3=>X3,Y3=>Y3,Cin=>Cin,Sum0=>Sum0,Sum1=>Sum1,Sum2=>Sum2,Sum3=>Sum3,Cout=>Cout);
	end structure;