--VHDL code for 1 bit adder 
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
entity OneBitAdder_core is
	port (X:inout channel:=init_channel;
	      Y:inout channel:=init_channel;
	      Cin:inout channel:=init_channel;
	      Sum:inout channel:=init_channel;
	      Cout:inout channel:=init_channel);
end entity OneBitAdder_core;

--behavioral description of adder
architecture structure of OneBitAdder_core is
	signal a:std_logic;
	signal b:std_logic;
	signal c:std_logic;
	signal s:std_logic;
	signal d:std_logic;

	begin
		adder:process
		begin
		receive(X,a,Y,b,Cin,c);
		s <= a xor b xor c; 
		d <= (a and b) or (a and c) or (b and c); 
		wait for delay(5,10);
		send(Sum,s,Cout,d);
		end process adder;
	end structure;