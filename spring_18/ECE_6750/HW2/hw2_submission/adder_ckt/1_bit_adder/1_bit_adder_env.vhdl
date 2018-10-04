--VHDL env for 1 bit adder 
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
entity OneBitAdder_env is
	port (X:inout channel:=init_channel;
	      Y:inout channel:=init_channel;
	      Cin:inout channel:=init_channel;
	      Sum:inout channel:=init_channel;
	      Cout:inout channel:=init_channel);
end entity OneBitAdder_env;

--behavioral description of adder
architecture structure of OneBitAdder_env is
	signal a:std_logic;
	signal b:std_logic;
	signal c:std_logic;
	signal s:std_logic;
	signal d:std_logic;
	signal st:std_logic;
	signal dt:std_logic;
	begin
	adder_env:process
		begin
		a<= selection(2,1);
		b<= selection(2,1);
		c<= selection(2,1);
		wait for delay(5,10);
		send(X,a,Y,b,Cin,c);
		receive(Sum,s,Cout,d);
		st <= a xor b xor c;
		dt <= (a and b) or (a and c) or (b and c);
		wait for delay(5,10);
		assert((st=s) and (dt=d))
			report "wrong output from adder" severity error;
		end process adder_env;
	end structure;