--VHDL code for 1 bit optimizied adder core based on logic from 1-bit truth table
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
entity OneBitAdder_opt_core is
	port (X:inout channel:=init_channel;
	      Y:inout channel:=init_channel;
	      Cin:inout channel:=init_channel;
	      Sum:inout channel:=init_channel;
	      Cout:inout channel:=init_channel);
end entity OneBitAdder_opt_core;

--behavioral description of optimized adder
architecture structure of OneBitAdder_opt_core is
	signal a:std_logic;
	signal b:std_logic;
	signal c:std_logic;
	signal s:std_logic;
	signal d:std_logic;
	signal t:std_logic;
	begin
		adder:process
		begin
		--receive(X,a,Y,b,Cin,c);
		----if inputs are equal carry is always one of the inputs
		---- and sum is carry in itself
		--if (a=b) then
		--	s <= c;
		--	d <= a or b;--can be d<=a,d<=b to reduce more logic
		----if inputs are different carry is carry in value itself
		---- and sum is complement of carry in
		--else
		--	s <= not c;
		--	d <= c;
		--end if ;
		--wait for delay(5,10);
		--send(Sum,s,Cout,d);
		receive(X,a,Y,b);
		--if inputs are equal carry is always one of the inputs
		-- and sum is carry in itself
		if (a=b) then
			d <= a;
			wait for delay(5,10);
			send(Cout,d);
			receive(Cin,c);
			s <= c;
			wait for delay(5,10);
			send(Sum,s);
		else
			receive(Cin,c);
			s <= not c;
			d <= c;
			wait for delay(5,10);
			send(Sum,s,Cout,d);
		end if;
		end process adder;
	end structure;