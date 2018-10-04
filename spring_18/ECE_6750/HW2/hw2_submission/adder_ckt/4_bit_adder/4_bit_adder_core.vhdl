--VHDL code for 4 bit adder 
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
entity FourBitAdder_core is
	port (X:inout channel:=init_channel;
	      Y:inout channel:=init_channel;
	      Cin:inout channel:=init_channel;
	      Sum:inout channel:=init_channel;
	      Cout:inout channel:=init_channel);
end entity FourBitAdder_core;

--behavioral description of adder
architecture structure of FourBitAdder_core is
	signal a:std_logic_vector(3 downto 0);
	signal b:std_logic_vector(3 downto 0);
	signal c:std_logic;
	signal s:std_logic_vector(3 downto 0);
	signal d:std_logic;
	signal temp:std_logic_vector(4 downto 0);

	begin
		adder:process
		begin
		receive(X,a,Y,b,Cin,c);
		temp <= ("0"& a) + ("0"& b) + ("0000"& c); 
		wait for delay(5,10);
		send(Sum,temp(3 downto 0),Cout,temp(4 downto 4));
		end process adder;
	end structure;