--VHDL env for 4 1 bit adder 
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
entity Four_OneBitAdder_dualrail_env is
	port (X0_0:inout std_logic:='0';
	      X0_1:inout std_logic:='0';
	      X1_0:inout std_logic:='0';
	      X1_1:inout std_logic:='0';
	      X2_0:inout std_logic:='0';
	      X2_1:inout std_logic:='0';
	      X3_0:inout std_logic:='0';
	      X3_1:inout std_logic:='0';
	      Y0_0:inout std_logic:='0';
	      Y0_1:inout std_logic:='0';
	      Y1_0:inout std_logic:='0';
	      Y1_1:inout std_logic:='0';
	      Y2_0:inout std_logic:='0';
	      Y2_1:inout std_logic:='0';
	      Y3_0:inout std_logic:='0';
	      Y3_1:inout std_logic:='0';
	      Cin_0:inout std_logic:='0';
	      Cin_1:inout std_logic:='0';
	      Sum0_0:in std_logic;
	      Sum0_1:in std_logic;
	      Sum1_0:in std_logic;
	      Sum1_1:in std_logic;
	      Sum2_0:in std_logic;
	      Sum2_1:in std_logic;
	      Sum3_0:in std_logic;
	      Sum3_1:in std_logic;
	      Cout_0:in std_logic;
	      Cout_1:in std_logic;
	      X0_ack:in std_logic;
	      X1_ack:in std_logic;
	      X2_ack:in std_logic;
	      X3_ack:in std_logic;
	      Y0_ack:in std_logic;
	      Y1_ack:in std_logic;
	      Y2_ack:in std_logic;
	      Y3_ack:in std_logic;
	      Cin_ack:in std_logic;
	      Sum0_ack:inout std_logic:='0';
	      Sum1_ack:inout std_logic:='0';
	      Sum2_ack:inout std_logic:='0';
	      Sum3_ack:inout std_logic:='0';
	      Cout_ack:inout std_logic:='0');
end entity Four_OneBitAdder_dualrail_env;

--behavioral description of adder
architecture structure of Four_OneBitAdder_dualrail_env is
	signal a:std_logic_vector(3 downto 0);
	signal b:std_logic_vector(3 downto 0);
	signal c:std_logic_vector(0 downto 0);
	signal temp:std_logic_vector(4 downto 0);

	begin
	adder_env_send:process
		begin
		a<= selection(16,4);
		b<= selection(16,4);
		c<= selection(2,1);
		wait for delay(1,5);
		--temp <= ("0"&a)+("0"&b)+("0000"&c);
		--check for inputs lines to be 0
		--guard_and(X_0,'0',Y_0,'0',Cin_0,'0');
		--guard_and(X_1,'0',Y_1,'0',Cin_1,'0');
		assign(X0_1,a(0),1,5,X0_0,not a(0),1,5);
		assign(Y0_1,b(0),1,5,Y0_0,not b(0),1,5);
		assign(X1_1,a(1),1,5,X1_0,not a(1),1,5);
		assign(Y1_1,b(1),1,5,Y1_0,not b(1),1,5);
		assign(X2_1,a(2),1,5,X2_0,not a(2),1,5);
		assign(Y2_1,b(2),1,5,Y2_0,not b(2),1,5);
		assign(X3_1,a(3),1,5,X3_0,not a(3),1,5);
		assign(Y3_1,b(3),1,5,Y3_0,not b(3),1,5);
		assign(Cin_1,c(0),1,5,Cin_0,not c(0),1,5);
		--X0_0 <= not a(0);
		--X0_1 <= a(0);
		--wait for delay(1,5);
		--Y0_0 <= not b(0);
		--Y0_1 <= b(0);
		--wait for delay(1,5);
		--X1_0 <= not a(1);
		--X1_1 <= a(1);
		--wait for delay(1,5);
		--Y1_0 <= not b(1);
		--Y1_1 <= b(1);
		--wait for delay(1,5);
		--X2_0 <= not a(2);
		--X2_1 <= a(2);
		--wait for delay(1,5);
		--Y2_0 <= not b(2);
		--Y2_1 <= b(2);
		--wait for delay(1,5);
		--X3_0 <= not a(3);
		--X3_1 <= a(3);
		--wait for delay(1,5);
		--Y3_0 <= not b(3);
		--Y3_1 <= b(3);
		--wait for delay(1,5);
		--Cin_0 <= not c(0);
		--Cin_1 <= c(0);
		--wait for delay(1,5);

		--check for acknowledgments
		guard_and(X0_ack,'1',Y0_ack,'1');
		guard_and(X1_ack,'1',Y1_ack,'1');
		guard_and(X2_ack,'1',Y2_ack,'1');
		guard_and(X3_ack,'1',Y3_ack,'1');
		guard(Cin_ack,'1');
		vassign(X0_0,'0',1,5,X0_1,'0',1,5);
		vassign(Y0_0,'0',1,5,Y0_1,'0',1,5);
		vassign(X1_0,'0',1,5,X1_1,'0',1,5);
		vassign(Y1_0,'0',1,5,Y1_1,'0',1,5);
		vassign(X2_0,'0',1,5,X2_1,'0',1,5);
		vassign(Y2_0,'0',1,5,Y2_1,'0',1,5);
		vassign(X3_0,'0',1,5,X3_1,'0',1,5);
		vassign(Y3_0,'0',1,5,Y3_1,'0',1,5);
		vassign(Cin_0,'0',1,5);
		vassign(Cin_1,'0',1,5);
		guard_and(X0_ack,'0',Y0_ack,'0');
		guard_and(X1_ack,'0',Y1_ack,'0');
		guard_and(X2_ack,'0',Y2_ack,'0');
		guard_and(X3_ack,'0',Y3_ack,'0');
		guard(Cin_ack,'0');
		end process adder_env_send;
	adder_env_receive:process
		begin
		guard_or(Sum0_0,'1',Sum0_1,'1');
		assign(Sum0_ack,'1',1,5);
		guard_or(Sum1_0,'1',Sum1_1,'1');
		assign(Sum1_ack,'1',1,5);
		guard_or(Sum2_0,'1',Sum2_1,'1');
		assign(Sum2_ack,'1',1,5);
		guard_or(Sum3_0,'1',Sum3_1,'1');
		assign(Sum3_ack,'1',1,5);
		guard_or(Cout_0,'1',Cout_1,'1');
		assign(Cout_ack,'1',1,5);
		--wait for delay(1,5);
		--assert((temp(0)="0") and (sum0_0='1'))
--			report "wrong output from adder" severity error;
		--assert((temp(0)="1") and (sum0_1='1'))
--			report "wrong output from adder" severity error;
		--assert((temp(1)="0") and (sum1_0='1'))
--			report "wrong output from adder" severity error;
		--assert((temp(1)="1") and (sum1_1='1'))
--			report "wrong output from adder" severity error;
		--assert((temp(2)="0") and (sum2_0='1'))
--			report "wrong output from adder" severity error;
		--assert((temp(2)="1") and (sum2_1='1'))
--			report "wrong output from adder" severity error;
		--assert((temp(3)="0") and (sum3_0='1'))
--			report "wrong output from adder" severity error;
		--assert((temp(3)="1") and (sum3_1='1'))
--			report "wrong output from adder" severity error;
--		assert((temp(4)="0") and (Cout_0='1'))
--			report "wrong output from adder" severity error;
--		assert((temp(4)="1") and (Cout_1='1'))
--			report "wrong output from adder" severity error;
		guard_and(Sum0_0,'0',Sum0_1,'0');
		assign(Sum0_ack,'0',1,5);
		guard_and(Sum1_0,'0',Sum1_1,'0');
		assign(Sum1_ack,'0',1,5);
		guard_and(Sum2_0,'0',Sum2_1,'0');
		assign(Sum2_ack,'0',1,5);
		guard_and(Sum3_0,'0',Sum3_1,'0');
		assign(Sum3_ack,'0',1,5);
		guard_and(Cout_0,'0',Cout_1,'0');
		assign(Cout_ack,'0',1,5);
		end process adder_env_receive;
	end structure;