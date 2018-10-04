--VHDL env for 4 bit adder 
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
entity FourBitAdder_env is
	port (X:inout channel:=init_channel;
	      Y:inout channel:=init_channel;
	      Cin:inout channel:=init_channel;
	      Sum:inout channel:=init_channel;
	      Cout:inout channel:=init_channel);
end entity FourBitAdder_env;

--behavioral description of adder
architecture structure of FourBitAdder_env is
	signal a:std_logic_vector(3 downto 0);
	signal b:std_logic_vector(3 downto 0);
	signal c:std_logic;
	signal s:std_logic_vector(3 downto 0);
	signal d:std_logic;
	signal temp:std_logic_vector(4 downto 0);
	begin
	adder_env:process
		begin
		a<= selection(16,4);
		b<= selection(16,4);
		c<= selection(2,1);
		wait for delay(5,10);
		send(X,a,Y,b,Cin,c);
		receive(Sum,s,Cout,d);
		temp <= ("0"&a)+("0"&b)+("0000"&c);
		wait for delay(5,10);
		assert((temp(3 downto 0)=s) and (temp(4 downto 4)=d))
			report "wrong output from adder" severity error;
		end process adder_env;
	end structure;