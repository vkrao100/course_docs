-- VHDL code for 1 bit adder with handshaking expansion
-- using dual rail approach. We need two lines for every wire such 
-- that it encodes the data validity in itself.
-- Author - Vikas Rao
-- UnID - 1072596

--standard library declarations
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.nondeterminism.all;
use work.handshake.all;

--entity declaration - two wires for encoding every signal and one wire acknowledgment
--also initializing all outputs to '0'
entity Four_OneBitAdder_dualrail_core is
	port (X_0:in std_logic;
	      X_1:in std_logic;
	      Y_0:in std_logic;
	      Y_1:in std_logic;
	      Cin_0:in std_logic;
	      Cin_1:in std_logic;
	      Sum_0:inout std_logic:='0';
	      Sum_1:inout std_logic:='0';
	      Cout_0:inout std_logic:='0';
	      Cout_1:inout std_logic:='0';
	      X_ack:inout std_logic:='0';
	      Y_ack:inout std_logic:='0';
	      Cin_ack:inout std_logic:='0';
	      Sum_ack:in std_logic;
	      Cout_ack:in std_logic);
end entity Four_OneBitAdder_dualrail_core;

--behavioral description of adder
architecture structure of Four_OneBitAdder_dualrail_core is
	begin
		adder:process
		begin
		--check for individual acknowledgments to be low
		--guard(X_ack,'0');
		--guard(Y_ack,'0');
		--guard(Cin_ack,'0');
		guard(Sum_ack,'0');
		guard(Cout_ack,'0');
		--check if atleast one of the dual rail lines in every input bit is changed
		-- x_0-x_1 -> 0-0(no data) ->1-0(x is 0) -> 0-1(x is 1)->1-1(invalid) 
		guard_or(X_0,'1',X_1,'1');
		guard_or(Y_0,'1',Y_1,'1');
		guard_or(Cin_0,'1',Cin_1,'1');
		--implementing the bitwise addition based on truth table
		-- since Sum_0=1 indicates a '0' on the Sum output, only two inputs must be 1, or all must be '0' out of 3 input bits
		Sum_0 <= (X_0 and Y_0 and Cin_0) or (X_0 and Y_1 and Cin_1) or (X_1 and Y_0 and Cin_1) or (X_1 and Y_1 and Cin_0);
		--similarly for the output to be '1', only 1 input must be 1 or all three inputs must be '1'
		Sum_1 <= (X_0 and Y_0 and Cin_1) or (X_0 and Y_1 and Cin_0) or (X_1 and Y_0 and Cin_0) or (X_1 and Y_1 and Cin_1);
		--on similar lines for carry -from the truth table
		Cout_0 <= (X_0 and Y_0 and Cin_0) or (X_0 and Y_0 and Cin_1) or (X_0 and Y_1 and Cin_0) or (X_1 and Y_0 and Cin_0);
		Cout_1 <= (X_0 and Y_1 and Cin_1) or (X_1 and Y_0 and Cin_1) or (X_1 and Y_1 and Cin_0) or (X_1 and Y_1 and Cin_1);
		wait for delay(5,10);
		--wait until atleast one of the lines in output is set
		--guard_or(Sum_0,'1',Sum_1,'1');
		--guard_or(Cout_0,'1',Cout_1,'1');
		--send acknowledgments
		assign(X_ack,'1',1,5,Y_ack,'1',1,5);
		assign(Cin_ack,'1',1,5);
		--once we have the output acks, make sure the inputs are reset again before the next set of input arrives
		guard_and(Sum_ack,'1',Cout_ack,'1');
		vassign(Sum_0,'0',1,5,Sum_1,'0',1,5);
		vassign(Cout_0,'0',1,5,Cout_1,'0',1,5);
		guard_and(X_0,'0',Y_0,'0',Cin_0,'0');
		guard_and(X_1,'0',Y_1,'0',Cin_1,'0');
		assign(X_ack,'0',1,5,Y_ack,'0',1,5,Cin_ack,'0',1,5);
		end process adder;
	end structure;