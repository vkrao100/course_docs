------------------------------------------------------------------------------
--  Copyright (c) 2004 Aoki laboratory. All rights reserved.
--
--  Top module: Multiplier_3_0_3_000
--
--  Operand-1 length: 4
--  Operand-2 length: 4
--  Two-operand addition algorithm: Ripple carry adder
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity TCDECON_3_0 is
  port ( TOP : out std_logic;
         R : out std_logic_vector ( 2 downto 0 );
         I : in  std_logic_vector ( 3 downto 0 ) );
end TCDECON_3_0;

architecture TCDECON_3_0 of TCDECON_3_0 is
begin
   TOP <= I(3);
   R(0) <= I(0);
   R(1) <= I(1);
   R(2) <= I(2);
end TCDECON_3_0;

library IEEE;
use IEEE.std_logic_1164.all;

entity UB1BPPG_0_0 is
  port ( O : out std_logic;
         IN1 : in  std_logic;
         IN2 : in  std_logic );
end UB1BPPG_0_0;

architecture UB1BPPG_0_0 of UB1BPPG_0_0 is
begin
   O <= IN1 and IN2;
end UB1BPPG_0_0;

library IEEE;
use IEEE.std_logic_1164.all;

entity UB1BPPG_1_0 is
  port ( O : out std_logic;
         IN1 : in  std_logic;
         IN2 : in  std_logic );
end UB1BPPG_1_0;

architecture UB1BPPG_1_0 of UB1BPPG_1_0 is
begin
   O <= IN1 and IN2;
end UB1BPPG_1_0;

library IEEE;
use IEEE.std_logic_1164.all;

entity UB1BPPG_2_0 is
  port ( O : out std_logic;
         IN1 : in  std_logic;
         IN2 : in  std_logic );
end UB1BPPG_2_0;

architecture UB1BPPG_2_0 of UB1BPPG_2_0 is
begin
   O <= IN1 and IN2;
end UB1BPPG_2_0;

library IEEE;
use IEEE.std_logic_1164.all;

entity NU1BPPG_3_0 is
  port ( O : out std_logic;
         IN1 : in  std_logic;
         IN2 : in  std_logic );
end NU1BPPG_3_0;

architecture NU1BPPG_3_0 of NU1BPPG_3_0 is
begin
   O <= IN1 and IN2;
end NU1BPPG_3_0;

library IEEE;
use IEEE.std_logic_1164.all;

entity NUBUB1CON_3 is
  port ( O : out std_logic;
         I : in  std_logic );
end NUBUB1CON_3;

architecture NUBUB1CON_3 of NUBUB1CON_3 is
begin
   O <= not I;
end NUBUB1CON_3;

library IEEE;
use IEEE.std_logic_1164.all;

entity UB1BPPG_0_1 is
  port ( O : out std_logic;
         IN1 : in  std_logic;
         IN2 : in  std_logic );
end UB1BPPG_0_1;

architecture UB1BPPG_0_1 of UB1BPPG_0_1 is
begin
   O <= IN1 and IN2;
end UB1BPPG_0_1;

library IEEE;
use IEEE.std_logic_1164.all;

entity UB1BPPG_1_1 is
  port ( O : out std_logic;
         IN1 : in  std_logic;
         IN2 : in  std_logic );
end UB1BPPG_1_1;

architecture UB1BPPG_1_1 of UB1BPPG_1_1 is
begin
   O <= IN1 and IN2;
end UB1BPPG_1_1;

library IEEE;
use IEEE.std_logic_1164.all;

entity UB1BPPG_2_1 is
  port ( O : out std_logic;
         IN1 : in  std_logic;
         IN2 : in  std_logic );
end UB1BPPG_2_1;

architecture UB1BPPG_2_1 of UB1BPPG_2_1 is
begin
   O <= IN1 and IN2;
end UB1BPPG_2_1;

library IEEE;
use IEEE.std_logic_1164.all;

entity NU1BPPG_3_1 is
  port ( O : out std_logic;
         IN1 : in  std_logic;
         IN2 : in  std_logic );
end NU1BPPG_3_1;

architecture NU1BPPG_3_1 of NU1BPPG_3_1 is
begin
   O <= IN1 and IN2;
end NU1BPPG_3_1;

library IEEE;
use IEEE.std_logic_1164.all;

entity NUBUB1CON_4 is
  port ( O : out std_logic;
         I : in  std_logic );
end NUBUB1CON_4;

architecture NUBUB1CON_4 of NUBUB1CON_4 is
begin
   O <= not I;
end NUBUB1CON_4;

library IEEE;
use IEEE.std_logic_1164.all;

entity UB1BPPG_0_2 is
  port ( O : out std_logic;
         IN1 : in  std_logic;
         IN2 : in  std_logic );
end UB1BPPG_0_2;

architecture UB1BPPG_0_2 of UB1BPPG_0_2 is
begin
   O <= IN1 and IN2;
end UB1BPPG_0_2;

library IEEE;
use IEEE.std_logic_1164.all;

entity UB1BPPG_1_2 is
  port ( O : out std_logic;
         IN1 : in  std_logic;
         IN2 : in  std_logic );
end UB1BPPG_1_2;

architecture UB1BPPG_1_2 of UB1BPPG_1_2 is
begin
   O <= IN1 and IN2;
end UB1BPPG_1_2;

library IEEE;
use IEEE.std_logic_1164.all;

entity UB1BPPG_2_2 is
  port ( O : out std_logic;
         IN1 : in  std_logic;
         IN2 : in  std_logic );
end UB1BPPG_2_2;

architecture UB1BPPG_2_2 of UB1BPPG_2_2 is
begin
   O <= IN1 and IN2;
end UB1BPPG_2_2;

library IEEE;
use IEEE.std_logic_1164.all;

entity NU1BPPG_3_2 is
  port ( O : out std_logic;
         IN1 : in  std_logic;
         IN2 : in  std_logic );
end NU1BPPG_3_2;

architecture NU1BPPG_3_2 of NU1BPPG_3_2 is
begin
   O <= IN1 and IN2;
end NU1BPPG_3_2;

library IEEE;
use IEEE.std_logic_1164.all;

entity NUBUB1CON_5 is
  port ( O : out std_logic;
         I : in  std_logic );
end NUBUB1CON_5;

architecture NUBUB1CON_5 of NUBUB1CON_5 is
begin
   O <= not I;
end NUBUB1CON_5;

library IEEE;
use IEEE.std_logic_1164.all;

entity UN1BPPG_0_3 is
  port ( O : out std_logic;
         IN1 : in  std_logic;
         IN2 : in  std_logic );
end UN1BPPG_0_3;

architecture UN1BPPG_0_3 of UN1BPPG_0_3 is
begin
   O <= IN1 and IN2;
end UN1BPPG_0_3;

library IEEE;
use IEEE.std_logic_1164.all;

entity UN1BPPG_1_3 is
  port ( O : out std_logic;
         IN1 : in  std_logic;
         IN2 : in  std_logic );
end UN1BPPG_1_3;

architecture UN1BPPG_1_3 of UN1BPPG_1_3 is
begin
   O <= IN1 and IN2;
end UN1BPPG_1_3;

library IEEE;
use IEEE.std_logic_1164.all;

entity UN1BPPG_2_3 is
  port ( O : out std_logic;
         IN1 : in  std_logic;
         IN2 : in  std_logic );
end UN1BPPG_2_3;

architecture UN1BPPG_2_3 of UN1BPPG_2_3 is
begin
   O <= IN1 and IN2;
end UN1BPPG_2_3;

library IEEE;
use IEEE.std_logic_1164.all;

entity NUB1BPPG_3_3 is
  port ( O : out std_logic;
         IN1 : in  std_logic;
         IN2 : in  std_logic );
end NUB1BPPG_3_3;

architecture NUB1BPPG_3_3 of NUB1BPPG_3_3 is
begin
   O <= IN1 and IN2;
end NUB1BPPG_3_3;

library IEEE;
use IEEE.std_logic_1164.all;

entity UBOne_4 is
  port ( O : out std_logic );
end UBOne_4;

architecture UBOne_4 of UBOne_4 is
begin
   O <= '1';
end UBOne_4;

library IEEE;
use IEEE.std_logic_1164.all;

entity UB1DCON_4 is
  port ( O : out std_logic;
         I : in  std_logic );
end UB1DCON_4;

architecture UB1DCON_4 of UB1DCON_4 is
begin
   O <= I;
end UB1DCON_4;

library IEEE;
use IEEE.std_logic_1164.all;

entity UB1DCON_0 is
  port ( O : out std_logic;
         I : in  std_logic );
end UB1DCON_0;

architecture UB1DCON_0 of UB1DCON_0 is
begin
   O <= I;
end UB1DCON_0;

library IEEE;
use IEEE.std_logic_1164.all;

entity UB1DCON_1 is
  port ( O : out std_logic;
         I : in  std_logic );
end UB1DCON_1;

architecture UB1DCON_1 of UB1DCON_1 is
begin
   O <= I;
end UB1DCON_1;

library IEEE;
use IEEE.std_logic_1164.all;

entity UB1DCON_2 is
  port ( O : out std_logic;
         I : in  std_logic );
end UB1DCON_2;

architecture UB1DCON_2 of UB1DCON_2 is
begin
   O <= I;
end UB1DCON_2;

library IEEE;
use IEEE.std_logic_1164.all;

entity UB1DCON_3 is
  port ( O : out std_logic;
         I : in  std_logic );
end UB1DCON_3;

architecture UB1DCON_3 of UB1DCON_3 is
begin
   O <= I;
end UB1DCON_3;

library IEEE;
use IEEE.std_logic_1164.all;

entity UBHA_1 is
  port ( C : out std_logic;
         S : out std_logic;
         X : in  std_logic;
         Y : in  std_logic );
end UBHA_1;

architecture UBHA_1 of UBHA_1 is
begin
   C <= X and Y;
   S <= X xor Y;
end UBHA_1;

library IEEE;
use IEEE.std_logic_1164.all;

entity UBFA_2 is
  port ( C : out std_logic;
         S : out std_logic;
         X : in  std_logic;
         Y : in  std_logic;
         Z : in  std_logic );
end UBFA_2;

architecture UBFA_2 of UBFA_2 is
begin
   C <= ( X and Y ) or ( Y and Z ) or ( Z and X );
   S <= X xor Y xor Z;
end UBFA_2;

library IEEE;
use IEEE.std_logic_1164.all;

entity UBFA_3 is
  port ( C : out std_logic;
         S : out std_logic;
         X : in  std_logic;
         Y : in  std_logic;
         Z : in  std_logic );
end UBFA_3;

architecture UBFA_3 of UBFA_3 is
begin
   C <= ( X and Y ) or ( Y and Z ) or ( Z and X );
   S <= X xor Y xor Z;
end UBFA_3;

library IEEE;
use IEEE.std_logic_1164.all;

entity UBFA_4 is
  port ( C : out std_logic;
         S : out std_logic;
         X : in  std_logic;
         Y : in  std_logic;
         Z : in  std_logic );
end UBFA_4;

architecture UBFA_4 of UBFA_4 is
begin
   C <= ( X and Y ) or ( Y and Z ) or ( Z and X );
   S <= X xor Y xor Z;
end UBFA_4;

library IEEE;
use IEEE.std_logic_1164.all;

entity UB1DCON_5 is
  port ( O : out std_logic;
         I : in  std_logic );
end UB1DCON_5;

architecture UB1DCON_5 of UB1DCON_5 is
begin
   O <= I;
end UB1DCON_5;

library IEEE;
use IEEE.std_logic_1164.all;

entity UBHA_2 is
  port ( C : out std_logic;
         S : out std_logic;
         X : in  std_logic;
         Y : in  std_logic );
end UBHA_2;

architecture UBHA_2 of UBHA_2 is
begin
   C <= X and Y;
   S <= X xor Y;
end UBHA_2;

library IEEE;
use IEEE.std_logic_1164.all;

entity UBFA_5 is
  port ( C : out std_logic;
         S : out std_logic;
         X : in  std_logic;
         Y : in  std_logic;
         Z : in  std_logic );
end UBFA_5;

architecture UBFA_5 of UBFA_5 is
begin
   C <= ( X and Y ) or ( Y and Z ) or ( Z and X );
   S <= X xor Y xor Z;
end UBFA_5;

library IEEE;
use IEEE.std_logic_1164.all;

entity UB1DCON_6 is
  port ( O : out std_logic;
         I : in  std_logic );
end UB1DCON_6;

architecture UB1DCON_6 of UB1DCON_6 is
begin
   O <= I;
end UB1DCON_6;

library IEEE;
use IEEE.std_logic_1164.all;

entity UBFA_6 is
  port ( C : out std_logic;
         S : out std_logic;
         X : in  std_logic;
         Y : in  std_logic;
         Z : in  std_logic );
end UBFA_6;

architecture UBFA_6 of UBFA_6 is
begin
   C <= ( X and Y ) or ( Y and Z ) or ( Z and X );
   S <= X xor Y xor Z;
end UBFA_6;

library IEEE;
use IEEE.std_logic_1164.all;

entity UBZero_3_3 is
  port ( O : out std_logic );
end UBZero_3_3;

architecture UBZero_3_3 of UBZero_3_3 is
begin
   O <= '0';
end UBZero_3_3;

library IEEE;
use IEEE.std_logic_1164.all;

entity UBTC1CON7_0 is
  port ( O : out std_logic;
         I : in  std_logic );
end UBTC1CON7_0;

architecture UBTC1CON7_0 of UBTC1CON7_0 is
begin
   O <= I;
end UBTC1CON7_0;

library IEEE;
use IEEE.std_logic_1164.all;

entity UBTC1CON7_1 is
  port ( O : out std_logic;
         I : in  std_logic );
end UBTC1CON7_1;

architecture UBTC1CON7_1 of UBTC1CON7_1 is
begin
   O <= I;
end UBTC1CON7_1;

library IEEE;
use IEEE.std_logic_1164.all;

entity UBTC1CON7_2 is
  port ( O : out std_logic;
         I : in  std_logic );
end UBTC1CON7_2;

architecture UBTC1CON7_2 of UBTC1CON7_2 is
begin
   O <= I;
end UBTC1CON7_2;

library IEEE;
use IEEE.std_logic_1164.all;

entity UBTC1CON7_3 is
  port ( O : out std_logic;
         I : in  std_logic );
end UBTC1CON7_3;

architecture UBTC1CON7_3 of UBTC1CON7_3 is
begin
   O <= I;
end UBTC1CON7_3;

library IEEE;
use IEEE.std_logic_1164.all;

entity UBTC1CON7_4 is
  port ( O : out std_logic;
         I : in  std_logic );
end UBTC1CON7_4;

architecture UBTC1CON7_4 of UBTC1CON7_4 is
begin
   O <= I;
end UBTC1CON7_4;

library IEEE;
use IEEE.std_logic_1164.all;

entity UBTC1CON7_5 is
  port ( O : out std_logic;
         I : in  std_logic );
end UBTC1CON7_5;

architecture UBTC1CON7_5 of UBTC1CON7_5 is
begin
   O <= I;
end UBTC1CON7_5;

library IEEE;
use IEEE.std_logic_1164.all;

entity UBTC1CON7_6 is
  port ( O : out std_logic;
         I : in  std_logic );
end UBTC1CON7_6;

architecture UBTC1CON7_6 of UBTC1CON7_6 is
begin
   O <= I;
end UBTC1CON7_6;

library IEEE;
use IEEE.std_logic_1164.all;

entity UBTCTCONV_7_7 is
  port ( O : out std_logic;
         I : in  std_logic );
end UBTCTCONV_7_7;

architecture UBTCTCONV_7_7 of UBTCTCONV_7_7 is
begin
   O <= not I;
end UBTCTCONV_7_7;

library IEEE;
use IEEE.std_logic_1164.all;

entity Multiplier_3_0_3_000 is
  port ( P : out std_logic_vector ( 7 downto 0 );
         IN1 : in  std_logic_vector ( 3 downto 0 );
         IN2 : in  std_logic_vector ( 3 downto 0 ) );
end Multiplier_3_0_3_000;

architecture Multiplier_3_0_3_000 of Multiplier_3_0_3_000 is
  component MultTC_STD_ARY_RC000
    port ( P : out std_logic_vector ( 7 downto 0 );
           IN1 : in  std_logic_vector ( 3 downto 0 );
           IN2 : in  std_logic_vector ( 3 downto 0 ) );
  end component;
  signal W :  std_logic_vector ( 7 downto 0 );
begin
   P(0) <= W(0);
   P(1) <= W(1);
   P(2) <= W(2);
   P(3) <= W(3);
   P(4) <= W(4);
   P(5) <= W(5);
   P(6) <= W(6);
   P(7) <= W(7);
  U0:MultTC_STD_ARY_RC000 port map (W, IN1, IN2);
end Multiplier_3_0_3_000;

library IEEE;
use IEEE.std_logic_1164.all;
entity CSA_4_0_4_1_5_2 is
  port(
      C : out std_logic_vector(5 downto 2);
      S : out std_logic_vector(5 downto 0);
      X : in std_logic_vector(4 downto 0);
      Y : in std_logic_vector(4 downto 1);
      Z : in std_logic_vector(5 downto 2));
end CSA_4_0_4_1_5_2;

architecture CSA_4_0_4_1_5_2 of CSA_4_0_4_1_5_2 is
  component UB1DCON_0 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
  component UBHA_1 
    port(
      C : out std_logic;
      S : out std_logic;
      X : in std_logic;
      Y : in std_logic);
  end component;
  component PureCSA_4_2 
    port(
      C : out std_logic_vector(5 downto 3);
      S : out std_logic_vector(4 downto 2);
      X : in std_logic_vector(4 downto 2);
      Y : in std_logic_vector(4 downto 2);
      Z : in std_logic_vector(4 downto 2));
  end component;
  component UB1DCON_5 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
begin
  U0: UB1DCON_0 port map (S(0), X(0));
  U1: UBHA_1 port map (C(2), S(1), Y(1), X(1));
  U2: PureCSA_4_2 port map (C(5 downto 3), S(4 downto 2), Z(4 downto 2), Y(4 downto 2), X(4 downto 2));
  U3: UB1DCON_5 port map (S(5), Z(5));
end CSA_4_0_4_1_5_2;

library IEEE;
use IEEE.std_logic_1164.all;
entity CSA_5_0_5_2_6_3 is
  port(
      C : out std_logic_vector(6 downto 3);
      S : out std_logic_vector(6 downto 0);
      X : in std_logic_vector(5 downto 0);
      Y : in std_logic_vector(5 downto 2);
      Z : in std_logic_vector(6 downto 3));
end CSA_5_0_5_2_6_3;

architecture CSA_5_0_5_2_6_3 of CSA_5_0_5_2_6_3 is
  component UBCON_1_0 
    port(
      O : out std_logic_vector(1 downto 0);
      I : in std_logic_vector(1 downto 0));
  end component;
  component UBHA_2 
    port(
      C : out std_logic;
      S : out std_logic;
      X : in std_logic;
      Y : in std_logic);
  end component;
  component PureCSA_5_3 
    port(
      C : out std_logic_vector(6 downto 4);
      S : out std_logic_vector(5 downto 3);
      X : in std_logic_vector(5 downto 3);
      Y : in std_logic_vector(5 downto 3);
      Z : in std_logic_vector(5 downto 3));
  end component;
  component UB1DCON_6 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
begin
  U0: UBCON_1_0 port map (S(1 downto 0), X(1 downto 0));
  U1: UBHA_2 port map (C(3), S(2), Y(2), X(2));
  U2: PureCSA_5_3 port map (C(6 downto 4), S(5 downto 3), Z(5 downto 3), Y(5 downto 3), X(5 downto 3));
  U3: UB1DCON_6 port map (S(6), Z(6));
end CSA_5_0_5_2_6_3;

library IEEE;
use IEEE.std_logic_1164.all;
entity MultTC_STD_ARY_RC000 is
  port(
      P : out std_logic_vector(7 downto 0);
      IN1 : in std_logic_vector(3 downto 0);
      IN2 : in std_logic_vector(3 downto 0));
end MultTC_STD_ARY_RC000;

architecture MultTC_STD_ARY_RC000 of MultTC_STD_ARY_RC000 is
  component TCPPG_3_0_3_0 
    port(
      PP0 : out std_logic_vector(4 downto 0);
      PP1 : out std_logic_vector(4 downto 1);
      PP2 : out std_logic_vector(5 downto 2);
      PP3 : out std_logic_vector(6 downto 3);
      IN1 : in std_logic_vector(3 downto 0);
      IN2 : in std_logic_vector(3 downto 0));
  end component;
  component UBARYACC_4_0_4_1_000 
    port(
      S1 : out std_logic_vector(6 downto 3);
      S2 : out std_logic_vector(6 downto 0);
      PP0 : in std_logic_vector(4 downto 0);
      PP1 : in std_logic_vector(4 downto 1);
      PP2 : in std_logic_vector(5 downto 2);
      PP3 : in std_logic_vector(6 downto 3));
  end component;
  component UBRCA_6_3_6_0 
    port(
      S : out std_logic_vector(7 downto 0);
      X : in std_logic_vector(6 downto 3);
      Y : in std_logic_vector(6 downto 0));
  end component;
  component UBTCCONV7_7_0 
    port(
      O : out std_logic_vector(7 downto 0);
      I : in std_logic_vector(7 downto 0));
  end component;
  signal PP0 : std_logic_vector(4 downto 0);
  signal PP1 : std_logic_vector(4 downto 1);
  signal PP2 : std_logic_vector(5 downto 2);
  signal PP3 : std_logic_vector(6 downto 3);
  signal P_UB : std_logic_vector(7 downto 0);
  signal S1 : std_logic_vector(6 downto 3);
  signal S2 : std_logic_vector(6 downto 0);
begin
  U0: TCPPG_3_0_3_0 port map (PP0, PP1, PP2, PP3, IN1, IN2);
  U1: UBARYACC_4_0_4_1_000 port map (S1, S2, PP0, PP1, PP2, PP3);
  U2: UBRCA_6_3_6_0 port map (P_UB, S1, S2);
  U3: UBTCCONV7_7_0 port map (P, P_UB);
end MultTC_STD_ARY_RC000;

library IEEE;
use IEEE.std_logic_1164.all;
entity NUBUBCON_5_3 is
  port(
      O : out std_logic_vector(5 downto 3);
      I : in std_logic_vector(5 downto 3));
end NUBUBCON_5_3;

architecture NUBUBCON_5_3 of NUBUBCON_5_3 is
  component NUBUB1CON_3 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
  component NUBUB1CON_4 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
  component NUBUB1CON_5 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
begin
  U0: NUBUB1CON_3 port map (O(3), I(3));
  U1: NUBUB1CON_4 port map (O(4), I(4));
  U2: NUBUB1CON_5 port map (O(5), I(5));
end NUBUBCON_5_3;

library IEEE;
use IEEE.std_logic_1164.all;
entity PureCSA_4_2 is
  port(
      C : out std_logic_vector(5 downto 3);
      S : out std_logic_vector(4 downto 2);
      X : in std_logic_vector(4 downto 2);
      Y : in std_logic_vector(4 downto 2);
      Z : in std_logic_vector(4 downto 2));
end PureCSA_4_2;

architecture PureCSA_4_2 of PureCSA_4_2 is
  component UBFA_2 
    port(
      C : out std_logic;
      S : out std_logic;
      X : in std_logic;
      Y : in std_logic;
      Z : in std_logic);
  end component;
  component UBFA_3 
    port(
      C : out std_logic;
      S : out std_logic;
      X : in std_logic;
      Y : in std_logic;
      Z : in std_logic);
  end component;
  component UBFA_4 
    port(
      C : out std_logic;
      S : out std_logic;
      X : in std_logic;
      Y : in std_logic;
      Z : in std_logic);
  end component;
begin
  U0: UBFA_2 port map (C(3), S(2), X(2), Y(2), Z(2));
  U1: UBFA_3 port map (C(4), S(3), X(3), Y(3), Z(3));
  U2: UBFA_4 port map (C(5), S(4), X(4), Y(4), Z(4));
end PureCSA_4_2;

library IEEE;
use IEEE.std_logic_1164.all;
entity PureCSA_5_3 is
  port(
      C : out std_logic_vector(6 downto 4);
      S : out std_logic_vector(5 downto 3);
      X : in std_logic_vector(5 downto 3);
      Y : in std_logic_vector(5 downto 3);
      Z : in std_logic_vector(5 downto 3));
end PureCSA_5_3;

architecture PureCSA_5_3 of PureCSA_5_3 is
  component UBFA_3 
    port(
      C : out std_logic;
      S : out std_logic;
      X : in std_logic;
      Y : in std_logic;
      Z : in std_logic);
  end component;
  component UBFA_4 
    port(
      C : out std_logic;
      S : out std_logic;
      X : in std_logic;
      Y : in std_logic;
      Z : in std_logic);
  end component;
  component UBFA_5 
    port(
      C : out std_logic;
      S : out std_logic;
      X : in std_logic;
      Y : in std_logic;
      Z : in std_logic);
  end component;
begin
  U0: UBFA_3 port map (C(4), S(3), X(3), Y(3), Z(3));
  U1: UBFA_4 port map (C(5), S(4), X(4), Y(4), Z(4));
  U2: UBFA_5 port map (C(6), S(5), X(5), Y(5), Z(5));
end PureCSA_5_3;

library IEEE;
use IEEE.std_logic_1164.all;
entity TCNVPPG_3_0_3 is
  port(
      O : out std_logic_vector(6 downto 3);
      IN1 : in std_logic_vector(3 downto 0);
      IN2 : in std_logic);
end TCNVPPG_3_0_3;

architecture TCNVPPG_3_0_3 of TCNVPPG_3_0_3 is
  component TCDECON_3_0 
    port(
      TOP : out std_logic;
      R : out std_logic_vector(2 downto 0);
      I : in std_logic_vector(3 downto 0));
  end component;
  component UN1BPPG_0_3 
    port(
      O : out std_logic;
      IN1 : in std_logic;
      IN2 : in std_logic);
  end component;
  component UN1BPPG_1_3 
    port(
      O : out std_logic;
      IN1 : in std_logic;
      IN2 : in std_logic);
  end component;
  component UN1BPPG_2_3 
    port(
      O : out std_logic;
      IN1 : in std_logic;
      IN2 : in std_logic);
  end component;
  component NUB1BPPG_3_3 
    port(
      O : out std_logic;
      IN1 : in std_logic;
      IN2 : in std_logic);
  end component;
  component NUBUBCON_5_3 
    port(
      O : out std_logic_vector(5 downto 3);
      I : in std_logic_vector(5 downto 3));
  end component;
  signal IN1N : std_logic;
  signal IN1P : std_logic_vector(2 downto 0);
  signal NEG : std_logic_vector(5 downto 3);
begin
  U0: TCDECON_3_0 port map (IN1N, IN1P, IN1);
  U1: UN1BPPG_0_3 port map (NEG(3), IN1P(0), IN2);
  U2: UN1BPPG_1_3 port map (NEG(4), IN1P(1), IN2);
  U3: UN1BPPG_2_3 port map (NEG(5), IN1P(2), IN2);
  U4: NUB1BPPG_3_3 port map (O(6), IN1N, IN2);
  U5: NUBUBCON_5_3 port map (O(5 downto 3), NEG);
end TCNVPPG_3_0_3;

library IEEE;
use IEEE.std_logic_1164.all;
entity TCPPG_3_0_3_0 is
  port(
      PP0 : out std_logic_vector(4 downto 0);
      PP1 : out std_logic_vector(4 downto 1);
      PP2 : out std_logic_vector(5 downto 2);
      PP3 : out std_logic_vector(6 downto 3);
      IN1 : in std_logic_vector(3 downto 0);
      IN2 : in std_logic_vector(3 downto 0));
end TCPPG_3_0_3_0;

architecture TCPPG_3_0_3_0 of TCPPG_3_0_3_0 is
  component TCDECON_3_0 
    port(
      TOP : out std_logic;
      R : out std_logic_vector(2 downto 0);
      I : in std_logic_vector(3 downto 0));
  end component;
  component TCUVPPG_3_0_0 
    port(
      O : out std_logic_vector(3 downto 0);
      IN1 : in std_logic_vector(3 downto 0);
      IN2 : in std_logic);
  end component;
  component TCUVPPG_3_0_1 
    port(
      O : out std_logic_vector(4 downto 1);
      IN1 : in std_logic_vector(3 downto 0);
      IN2 : in std_logic);
  end component;
  component TCUVPPG_3_0_2 
    port(
      O : out std_logic_vector(5 downto 2);
      IN1 : in std_logic_vector(3 downto 0);
      IN2 : in std_logic);
  end component;
  component TCNVPPG_3_0_3 
    port(
      O : out std_logic_vector(6 downto 3);
      IN1 : in std_logic_vector(3 downto 0);
      IN2 : in std_logic);
  end component;
  component UBOne_4 
    port(
      O : out std_logic);
  end component;
  component UBCMBIN_4_4_3_0 
    port(
      O : out std_logic_vector(4 downto 0);
      IN0 : in std_logic;
      IN1 : in std_logic_vector(3 downto 0));
  end component;
  signal BIAS : std_logic;
  signal IN2R : std_logic_vector(2 downto 0);
  signal IN2T : std_logic;
  signal W : std_logic_vector(3 downto 0);
begin
  U0: TCDECON_3_0 port map (IN2T, IN2R, IN2);
  U1: TCUVPPG_3_0_0 port map (W, IN1, IN2R(0));
  U2: TCUVPPG_3_0_1 port map (PP1, IN1, IN2R(1));
  U3: TCUVPPG_3_0_2 port map (PP2, IN1, IN2R(2));
  U4: TCNVPPG_3_0_3 port map (PP3, IN1, IN2T);
  U5: UBOne_4 port map (BIAS);
  U6: UBCMBIN_4_4_3_0 port map (PP0, BIAS, W);
end TCPPG_3_0_3_0;

library IEEE;
use IEEE.std_logic_1164.all;
entity TCUVPPG_3_0_0 is
  port(
      O : out std_logic_vector(3 downto 0);
      IN1 : in std_logic_vector(3 downto 0);
      IN2 : in std_logic);
end TCUVPPG_3_0_0;

architecture TCUVPPG_3_0_0 of TCUVPPG_3_0_0 is
  component TCDECON_3_0 
    port(
      TOP : out std_logic;
      R : out std_logic_vector(2 downto 0);
      I : in std_logic_vector(3 downto 0));
  end component;
  component UB1BPPG_0_0 
    port(
      O : out std_logic;
      IN1 : in std_logic;
      IN2 : in std_logic);
  end component;
  component UB1BPPG_1_0 
    port(
      O : out std_logic;
      IN1 : in std_logic;
      IN2 : in std_logic);
  end component;
  component UB1BPPG_2_0 
    port(
      O : out std_logic;
      IN1 : in std_logic;
      IN2 : in std_logic);
  end component;
  component NU1BPPG_3_0 
    port(
      O : out std_logic;
      IN1 : in std_logic;
      IN2 : in std_logic);
  end component;
  component NUBUB1CON_3 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
  signal IN1N : std_logic;
  signal IN1P : std_logic_vector(2 downto 0);
  signal NEG : std_logic;
begin
  U0: TCDECON_3_0 port map (IN1N, IN1P, IN1);
  U1: UB1BPPG_0_0 port map (O(0), IN1P(0), IN2);
  U2: UB1BPPG_1_0 port map (O(1), IN1P(1), IN2);
  U3: UB1BPPG_2_0 port map (O(2), IN1P(2), IN2);
  U4: NU1BPPG_3_0 port map (NEG, IN1N, IN2);
  U5: NUBUB1CON_3 port map (O(3), NEG);
end TCUVPPG_3_0_0;

library IEEE;
use IEEE.std_logic_1164.all;
entity TCUVPPG_3_0_1 is
  port(
      O : out std_logic_vector(4 downto 1);
      IN1 : in std_logic_vector(3 downto 0);
      IN2 : in std_logic);
end TCUVPPG_3_0_1;

architecture TCUVPPG_3_0_1 of TCUVPPG_3_0_1 is
  component TCDECON_3_0 
    port(
      TOP : out std_logic;
      R : out std_logic_vector(2 downto 0);
      I : in std_logic_vector(3 downto 0));
  end component;
  component UB1BPPG_0_1 
    port(
      O : out std_logic;
      IN1 : in std_logic;
      IN2 : in std_logic);
  end component;
  component UB1BPPG_1_1 
    port(
      O : out std_logic;
      IN1 : in std_logic;
      IN2 : in std_logic);
  end component;
  component UB1BPPG_2_1 
    port(
      O : out std_logic;
      IN1 : in std_logic;
      IN2 : in std_logic);
  end component;
  component NU1BPPG_3_1 
    port(
      O : out std_logic;
      IN1 : in std_logic;
      IN2 : in std_logic);
  end component;
  component NUBUB1CON_4 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
  signal IN1N : std_logic;
  signal IN1P : std_logic_vector(2 downto 0);
  signal NEG : std_logic;
begin
  U0: TCDECON_3_0 port map (IN1N, IN1P, IN1);
  U1: UB1BPPG_0_1 port map (O(1), IN1P(0), IN2);
  U2: UB1BPPG_1_1 port map (O(2), IN1P(1), IN2);
  U3: UB1BPPG_2_1 port map (O(3), IN1P(2), IN2);
  U4: NU1BPPG_3_1 port map (NEG, IN1N, IN2);
  U5: NUBUB1CON_4 port map (O(4), NEG);
end TCUVPPG_3_0_1;

library IEEE;
use IEEE.std_logic_1164.all;
entity TCUVPPG_3_0_2 is
  port(
      O : out std_logic_vector(5 downto 2);
      IN1 : in std_logic_vector(3 downto 0);
      IN2 : in std_logic);
end TCUVPPG_3_0_2;

architecture TCUVPPG_3_0_2 of TCUVPPG_3_0_2 is
  component TCDECON_3_0 
    port(
      TOP : out std_logic;
      R : out std_logic_vector(2 downto 0);
      I : in std_logic_vector(3 downto 0));
  end component;
  component UB1BPPG_0_2 
    port(
      O : out std_logic;
      IN1 : in std_logic;
      IN2 : in std_logic);
  end component;
  component UB1BPPG_1_2 
    port(
      O : out std_logic;
      IN1 : in std_logic;
      IN2 : in std_logic);
  end component;
  component UB1BPPG_2_2 
    port(
      O : out std_logic;
      IN1 : in std_logic;
      IN2 : in std_logic);
  end component;
  component NU1BPPG_3_2 
    port(
      O : out std_logic;
      IN1 : in std_logic;
      IN2 : in std_logic);
  end component;
  component NUBUB1CON_5 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
  signal IN1N : std_logic;
  signal IN1P : std_logic_vector(2 downto 0);
  signal NEG : std_logic;
begin
  U0: TCDECON_3_0 port map (IN1N, IN1P, IN1);
  U1: UB1BPPG_0_2 port map (O(2), IN1P(0), IN2);
  U2: UB1BPPG_1_2 port map (O(3), IN1P(1), IN2);
  U3: UB1BPPG_2_2 port map (O(4), IN1P(2), IN2);
  U4: NU1BPPG_3_2 port map (NEG, IN1N, IN2);
  U5: NUBUB1CON_5 port map (O(5), NEG);
end TCUVPPG_3_0_2;

library IEEE;
use IEEE.std_logic_1164.all;
entity UBARYACC_4_0_4_1_000 is
  port(
      S1 : out std_logic_vector(6 downto 3);
      S2 : out std_logic_vector(6 downto 0);
      PP0 : in std_logic_vector(4 downto 0);
      PP1 : in std_logic_vector(4 downto 1);
      PP2 : in std_logic_vector(5 downto 2);
      PP3 : in std_logic_vector(6 downto 3));
end UBARYACC_4_0_4_1_000;

architecture UBARYACC_4_0_4_1_000 of UBARYACC_4_0_4_1_000 is
  component CSA_4_0_4_1_5_2 
    port(
      C : out std_logic_vector(5 downto 2);
      S : out std_logic_vector(5 downto 0);
      X : in std_logic_vector(4 downto 0);
      Y : in std_logic_vector(4 downto 1);
      Z : in std_logic_vector(5 downto 2));
  end component;
  component CSA_5_0_5_2_6_3 
    port(
      C : out std_logic_vector(6 downto 3);
      S : out std_logic_vector(6 downto 0);
      X : in std_logic_vector(5 downto 0);
      Y : in std_logic_vector(5 downto 2);
      Z : in std_logic_vector(6 downto 3));
  end component;
  signal IC0 : std_logic_vector(5 downto 2);
  signal IS0 : std_logic_vector(5 downto 0);
begin
  U0: CSA_4_0_4_1_5_2 port map (IC0, IS0, PP0, PP1, PP2);
  U1: CSA_5_0_5_2_6_3 port map (S1, S2, IS0, IC0, PP3);
end UBARYACC_4_0_4_1_000;

library IEEE;
use IEEE.std_logic_1164.all;
entity UBCMBIN_4_4_3_0 is
  port(
      O : out std_logic_vector(4 downto 0);
      IN0 : in std_logic;
      IN1 : in std_logic_vector(3 downto 0));
end UBCMBIN_4_4_3_0;

architecture UBCMBIN_4_4_3_0 of UBCMBIN_4_4_3_0 is
  component UB1DCON_4 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
  component UBCON_3_0 
    port(
      O : out std_logic_vector(3 downto 0);
      I : in std_logic_vector(3 downto 0));
  end component;
begin
  U0: UB1DCON_4 port map (O(4), IN0);
  U1: UBCON_3_0 port map (O(3 downto 0), IN1);
end UBCMBIN_4_4_3_0;

library IEEE;
use IEEE.std_logic_1164.all;
entity UBCON_1_0 is
  port(
      O : out std_logic_vector(1 downto 0);
      I : in std_logic_vector(1 downto 0));
end UBCON_1_0;

architecture UBCON_1_0 of UBCON_1_0 is
  component UB1DCON_0 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
  component UB1DCON_1 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
begin
  U0: UB1DCON_0 port map (O(0), I(0));
  U1: UB1DCON_1 port map (O(1), I(1));
end UBCON_1_0;

library IEEE;
use IEEE.std_logic_1164.all;
entity UBCON_2_0 is
  port(
      O : out std_logic_vector(2 downto 0);
      I : in std_logic_vector(2 downto 0));
end UBCON_2_0;

architecture UBCON_2_0 of UBCON_2_0 is
  component UB1DCON_0 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
  component UB1DCON_1 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
  component UB1DCON_2 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
begin
  U0: UB1DCON_0 port map (O(0), I(0));
  U1: UB1DCON_1 port map (O(1), I(1));
  U2: UB1DCON_2 port map (O(2), I(2));
end UBCON_2_0;

library IEEE;
use IEEE.std_logic_1164.all;
entity UBCON_3_0 is
  port(
      O : out std_logic_vector(3 downto 0);
      I : in std_logic_vector(3 downto 0));
end UBCON_3_0;

architecture UBCON_3_0 of UBCON_3_0 is
  component UB1DCON_0 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
  component UB1DCON_1 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
  component UB1DCON_2 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
  component UB1DCON_3 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
begin
  U0: UB1DCON_0 port map (O(0), I(0));
  U1: UB1DCON_1 port map (O(1), I(1));
  U2: UB1DCON_2 port map (O(2), I(2));
  U3: UB1DCON_3 port map (O(3), I(3));
end UBCON_3_0;

library IEEE;
use IEEE.std_logic_1164.all;
entity UBPriRCA_6_3 is
  port(
      S : out std_logic_vector(7 downto 3);
      X : in std_logic_vector(6 downto 3);
      Y : in std_logic_vector(6 downto 3);
      Cin : in std_logic);
end UBPriRCA_6_3;

architecture UBPriRCA_6_3 of UBPriRCA_6_3 is
  component UBFA_3 
    port(
      C : out std_logic;
      S : out std_logic;
      X : in std_logic;
      Y : in std_logic;
      Z : in std_logic);
  end component;
  component UBFA_4 
    port(
      C : out std_logic;
      S : out std_logic;
      X : in std_logic;
      Y : in std_logic;
      Z : in std_logic);
  end component;
  component UBFA_5 
    port(
      C : out std_logic;
      S : out std_logic;
      X : in std_logic;
      Y : in std_logic;
      Z : in std_logic);
  end component;
  component UBFA_6 
    port(
      C : out std_logic;
      S : out std_logic;
      X : in std_logic;
      Y : in std_logic;
      Z : in std_logic);
  end component;
  signal C4 : std_logic;
  signal C5 : std_logic;
  signal C6 : std_logic;
begin
  U0: UBFA_3 port map (C4, S(3), X(3), Y(3), Cin);
  U1: UBFA_4 port map (C5, S(4), X(4), Y(4), C4);
  U2: UBFA_5 port map (C6, S(5), X(5), Y(5), C5);
  U3: UBFA_6 port map (S(7), S(6), X(6), Y(6), C6);
end UBPriRCA_6_3;

library IEEE;
use IEEE.std_logic_1164.all;
entity UBPureRCA_6_3 is
  port(
      S : out std_logic_vector(7 downto 3);
      X : in std_logic_vector(6 downto 3);
      Y : in std_logic_vector(6 downto 3));
end UBPureRCA_6_3;

architecture UBPureRCA_6_3 of UBPureRCA_6_3 is
  component UBPriRCA_6_3 
    port(
      S : out std_logic_vector(7 downto 3);
      X : in std_logic_vector(6 downto 3);
      Y : in std_logic_vector(6 downto 3);
      Cin : in std_logic);
  end component;
  component UBZero_3_3 
    port(
      O : out std_logic);
  end component;
  signal C : std_logic;
begin
  U0: UBPriRCA_6_3 port map (S, X, Y, C);
  U1: UBZero_3_3 port map (C);
end UBPureRCA_6_3;

library IEEE;
use IEEE.std_logic_1164.all;
entity UBRCA_6_3_6_0 is
  port(
      S : out std_logic_vector(7 downto 0);
      X : in std_logic_vector(6 downto 3);
      Y : in std_logic_vector(6 downto 0));
end UBRCA_6_3_6_0;

architecture UBRCA_6_3_6_0 of UBRCA_6_3_6_0 is
  component UBPureRCA_6_3 
    port(
      S : out std_logic_vector(7 downto 3);
      X : in std_logic_vector(6 downto 3);
      Y : in std_logic_vector(6 downto 3));
  end component;
  component UBCON_2_0 
    port(
      O : out std_logic_vector(2 downto 0);
      I : in std_logic_vector(2 downto 0));
  end component;
begin
  U0: UBPureRCA_6_3 port map (S(7 downto 3), X(6 downto 3), Y(6 downto 3));
  U1: UBCON_2_0 port map (S(2 downto 0), Y(2 downto 0));
end UBRCA_6_3_6_0;

library IEEE;
use IEEE.std_logic_1164.all;
entity UBTCCONV7_7_0 is
  port(
      O : out std_logic_vector(7 downto 0);
      I : in std_logic_vector(7 downto 0));
end UBTCCONV7_7_0;

architecture UBTCCONV7_7_0 of UBTCCONV7_7_0 is
  component UBTC1CON7_0 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
  component UBTC1CON7_1 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
  component UBTC1CON7_2 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
  component UBTC1CON7_3 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
  component UBTC1CON7_4 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
  component UBTC1CON7_5 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
  component UBTC1CON7_6 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
  component UBTCTCONV_7_7 
    port(
      O : out std_logic;
      I : in std_logic);
  end component;
begin
  U0: UBTC1CON7_0 port map (O(0), I(0));
  U1: UBTC1CON7_1 port map (O(1), I(1));
  U2: UBTC1CON7_2 port map (O(2), I(2));
  U3: UBTC1CON7_3 port map (O(3), I(3));
  U4: UBTC1CON7_4 port map (O(4), I(4));
  U5: UBTC1CON7_5 port map (O(5), I(5));
  U6: UBTC1CON7_6 port map (O(6), I(6));
  U7: UBTCTCONV_7_7 port map (O(7), I(7));
end UBTCCONV7_7_0;

