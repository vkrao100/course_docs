--VHDL top for 1 bit adder using dualrail handshaking protocol
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
entity Four_OneBitAdder_dualrail_top is
end entity Four_OneBitAdder_dualrail_top;

--behavioral description of adder
architecture structure of Four_OneBitAdder_dualrail_top is
	component Four_OneBitAdder_dualrail_core is
	port (X_0:in std_logic;
	      X_1:in std_logic;
	      Y_0:in std_logic;
	      Y_1:in std_logic;
	      Cin_0:in std_logic;
	      Cin_1:in std_logic;
	      Sum_0:inout std_logic;
	      Sum_1:inout std_logic;
	      Cout_0:inout std_logic;
	      Cout_1:inout std_logic;
	      X_ack:inout std_logic;
	      Y_ack:inout std_logic;
	      Cin_ack:inout std_logic;
	      Sum_ack:in std_logic;
	      Cout_ack:in std_logic);
	end component Four_OneBitAdder_dualrail_core;
	component Four_OneBitAdder_dualrail_env
	port (X0_0:inout std_logic;
	      X0_1:inout std_logic;
	      X1_0:inout std_logic;
	      X1_1:inout std_logic;
	      X2_0:inout std_logic;
	      X2_1:inout std_logic;
	      X3_0:inout std_logic;
	      X3_1:inout std_logic;
	      Y0_0:inout std_logic;
	      Y0_1:inout std_logic;
	      Y1_0:inout std_logic;
	      Y1_1:inout std_logic;
	      Y2_0:inout std_logic;
	      Y2_1:inout std_logic;
	      Y3_0:inout std_logic;
	      Y3_1:inout std_logic;
	      Cin_0:inout std_logic;
	      Cin_1:inout std_logic;
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
	      Sum0_ack:inout std_logic;
	      Sum1_ack:inout std_logic;
	      Sum2_ack:inout std_logic;
	      Sum3_ack:inout std_logic;
	      Cout_ack:inout std_logic);
	end component Four_OneBitAdder_dualrail_env;	
	
	signal X0_0:std_logic;
	signal X1_0:std_logic;
	signal X2_0:std_logic;
	signal X3_0:std_logic;
	signal X0_1:std_logic;
	signal X1_1:std_logic;
	signal X2_1:std_logic;
	signal X3_1:std_logic;
	signal Y0_0:std_logic;
	signal Y1_0:std_logic;
	signal Y2_0:std_logic;
	signal Y3_0:std_logic;
	signal Y0_1:std_logic;
	signal Y1_1:std_logic;
	signal Y2_1:std_logic;
	signal Y3_1:std_logic;
	signal Cin_0: std_logic;
	signal Cin_1: std_logic;
	signal Sum0_0: std_logic;
	signal Sum1_0: std_logic;
	signal Sum2_0: std_logic;
	signal Sum3_0: std_logic;
	signal Sum0_1: std_logic;
	signal Sum1_1: std_logic;
	signal Sum2_1: std_logic;
	signal Sum3_1: std_logic;
	signal Cout0_0:std_logic;
	signal Cout0_1:std_logic;
	signal Cout1_0:std_logic;
	signal Cout1_1:std_logic;
	signal Cout2_0:std_logic;
	signal Cout2_1:std_logic;
	signal Cout_0:std_logic;
	signal Cout_1:std_logic;
	signal X0_ack: std_logic;
	signal X1_ack: std_logic;
	signal X2_ack: std_logic;
	signal X3_ack: std_logic;
	signal Y0_ack: std_logic;
	signal Y1_ack: std_logic;
	signal Y2_ack: std_logic;
	signal Y3_ack: std_logic;
	signal Cin0_ack: std_logic;
	signal Sum0_ack: std_logic;
	signal Sum1_ack: std_logic;
	signal Sum2_ack: std_logic;
	signal Sum3_ack: std_logic;
	signal Cout0_ack:std_logic:='0';
	signal Cout1_ack:std_logic:='0';
	signal Cout2_ack:std_logic:='0';
	signal Cout3_ack:std_logic:='0';
	
	begin
		adder_env:Four_OneBitAdder_dualrail_env
			port map(X0_0=>X0_0,Y0_0=>Y0_0,Sum0_0=>Sum0_0,Cin_0=>Cin_0,
				     X0_1=>X0_1,Y0_1=>Y0_1,Sum0_1=>Sum0_1,Cin_1=>Cin_1, Cin_ack=>Cin0_ack,
				     X1_0=>X1_0,Y1_0=>Y1_0,Sum1_0=>Sum1_0,
				     X1_1=>X1_1,Y1_1=>Y1_1,Sum1_1=>Sum1_1,
				     X2_0=>X2_0,Y2_0=>Y2_0,Sum2_0=>Sum2_0,
				     X2_1=>X2_1,Y2_1=>Y2_1,Sum2_1=>Sum2_1,
				     X3_0=>X3_0,Y3_0=>Y3_0,Sum3_0=>Sum3_0,
				     X3_1=>X3_1,Y3_1=>Y3_1,Sum3_1=>Sum3_1,
				     X0_ack => X0_ack, Y0_ack => Y0_ack, Sum0_ack=> Sum0_ack, 
				     X1_ack => X1_ack, Y1_ack => Y1_ack, Sum1_ack=> Sum1_ack,
				     X2_ack => X2_ack, Y2_ack => Y2_ack, Sum2_ack=> Sum2_ack,
				     X3_ack => X3_ack, Y3_ack => Y3_ack, Sum3_ack=> Sum3_ack,
				     Cout_0=>Cout_0, Cout_1=>Cout_1, Cout_ack=>Cout3_ack);
		adder1:Four_OneBitAdder_dualrail_core
			port map(X_0=>X0_0,Y_0=>Y0_0,Cin_0=>Cin_0,Sum_0=>Sum0_0,Cout_0=>Cout0_0,
				     X_1=>X0_1,Y_1=>Y0_1,Cin_1=>Cin_1,Sum_1=>Sum0_1,Cout_1=>Cout0_1,
				     X_ack => X0_ack, Y_ack => Y0_ack, Cin_ack => Cin0_ack, Sum_ack=> Sum0_ack, Cout_ack=> Cout0_ack);
		adder2:Four_OneBitAdder_dualrail_core
			port map(X_0=>X1_0,Y_0=>Y1_0,Cin_0=>Cout0_0,Sum_0=>Sum1_0,Cout_0=>Cout1_0,
				     X_1=>X1_1,Y_1=>Y1_1,Cin_1=>Cout0_1,Sum_1=>Sum1_1,Cout_1=>Cout1_1,
				     X_ack => X1_ack, Y_ack => Y1_ack, Cin_ack => Cout0_ack, Sum_ack=> Sum1_ack, Cout_ack=> Cout1_ack);
		adder3:Four_OneBitAdder_dualrail_core
			port map(X_0=>X2_0,Y_0=>Y2_0,Cin_0=>Cout1_0,Sum_0=>Sum2_0,Cout_0=>Cout2_0,
				     X_1=>X2_1,Y_1=>Y2_1,Cin_1=>Cout1_1,Sum_1=>Sum2_1,Cout_1=>Cout2_1,
				     X_ack => X2_ack, Y_ack => Y2_ack, Cin_ack => Cout1_ack, Sum_ack=> Sum2_ack, Cout_ack=> Cout2_ack);
		adder4:Four_OneBitAdder_dualrail_core
			port map(X_0=>X3_0,Y_0=>Y3_0,Cin_0=>Cout2_0,Sum_0=>Sum3_0,Cout_0=>Cout_0,
				     X_1=>X3_1,Y_1=>Y3_1,Cin_1=>Cout2_1,Sum_1=>Sum3_1,Cout_1=>Cout_1,
				     X_ack => X3_ack, Y_ack => Y3_ack, Cin_ack => Cout2_ack, Sum_ack=> Sum3_ack, Cout_ack=> Cout3_ack);
	end structure;