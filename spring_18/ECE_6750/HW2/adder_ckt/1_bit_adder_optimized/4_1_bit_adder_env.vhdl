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
entity FourOneBitAdder_env is
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
end entity FourOneBitAdder_env;

--behavioral description of adder
architecture structure of FourOneBitAdder_env is
	signal a:std_logic_vector(3 downto 0);
	signal b:std_logic_vector(3 downto 0);
	signal c:std_logic;
	signal s:std_logic_vector(3 downto 0);
	signal d:std_logic;
	signal temp:std_logic_vector(4 downto 0);
	begin
	adder_env_send:process
		begin
		a<= selection(16,4);
		b<= selection(16,4);
		c<= selection(2,1);
		wait for delay(5,10);
		send(X0,a(0),Y0,b(0));
		send(X1,a(1),Y1,b(1));
		send(X2,a(2),Y2,b(2));
		send(X3,a(3),Y3,b(3));
		send(Cin,c);
		temp <= ("0"&a)+("0"&b)+("0000"&c);
		wait for delay(5,10);
		send();
		end process adder_env_send;
	adder_env_receive:process
		begin
		receive(Sum0,s(0));
		receive(Sum1,s(1));
		receive(Sum2,s(2));
		receive(Sum3,s(3));
		receive(Cout,d);
		assert((temp(3 downto 0)=s) and (temp(4 downto 4)=d))
			report "wrong output from adder" severity error;
		receive();
		end process adder_env_receive;
	end structure;