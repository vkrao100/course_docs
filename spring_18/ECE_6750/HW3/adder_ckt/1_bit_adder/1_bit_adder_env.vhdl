--VHDL env for 1 bit adder 
-- Author - Vikas Rao
-- UnID - 1072596

--standard library declarations
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.nondeterminism.all;
use work.handshake.all;

--entity declaration
--initializing outputs to 0
entity OneBitAdder_dualrail_env is
	port (X_0:inout std_logic:=0;
	      X_1:inout std_logic:=0;
	      Y_0:inout std_logic:=0;
	      Y_1:inout std_logic:=0;
	      Cin_0:inout std_logic:=0;
	      Cin_1:inout std_logic:=0;
	      Sum_0:in std_logic;
	      Sum_1:in std_logic;
	      Cout_0:in std_logic;
	      Cout_1:in std_logic;
	      X_ack:in std_logic;
	      Y_ack:in std_logic;
	      Cin_ack:in std_logic;
	      Sum_ack:inout std_logic:=0;
	      Cout_ack:inout std_logic:=0);
end entity OneBitAdder_dualrail_env;

--behavioral description of adder
architecture structure of OneBitAdder_dualrail_env is
	signal a:std_logic;
	signal b:std_logic;
	signal c:std_logic;
	signal s:std_logic;
	signal d:std_logic;
	begin
	adder_env:process
		begin
		a<= selection(2,1);
		b<= selection(2,1);
		c<= selection(2,1);
		wait for delay(5,10);
		--check for inputs lines to be 0
		guard_and(X_0,0,Y_0,0,Cin_0,0);
		guard_and(X_1,0,Y_1,0,Cin_1,0);
		
		if (a=1) then 
			assign(X_1,1,1,5);
		elsif (a=0) then 
			assign(X_0,1,1,5);
		end if;
		if (b=1) then 
			assign(Y_1,1,1,5);
		elsif (b=0) then 
			assign(Y_0,1,1,5);
		end if;
		if (c=1) then 
			assign(Cin_1,1,1,5);
		elsif (c=0) then 
			assign(Cin_0,1,1,5);
		end if;

		--check for acknowledgments
		guard_and(X_ack,1,1,5,Y_ack,1,1,5,Cin_ack,1,1,5);
		
		st <= a xor b xor c;
		dt <= (a and b) or (a and c) or (b and c);
		wait for delay(5,10);
		assert((st=s) and (dt=d))
			report "wrong output from adder" severity error;
		end process adder_env;
	end structure;