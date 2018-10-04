--\begin{algorithm}
--\small
--------------------
-- imem.vhd
--------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; 
use work.nondeterminism.all;
use work.channel.all;

entity imem is
  port(address:inout channel:=init_channel;
       data:inout channel:=init_channel);
end imem;

architecture behavior of imem is
  type memory is array (0 to 7) of 
    std_logic_vector(31 downto 0);
  signal addr:std_logic_vector(31 downto 0);
  signal instr:std_logic_vector(31 downto 0);
begin
process
  variable imem:memory:=(
    X"8c220000", -- L: lw r2,0(r1)
    X"8c640000", --    lw r4,0(r3)
    X"00a42020", --    add r4,r5,r4
    X"00642824", --    and r5,r3,r4
    X"ac640000", --    sw r4,0(r3)
    X"00822022", -- M: sub r4,r4,r2
    X"1080fff9", --    beq r4,r0,L
    X"18000005");--    j M
begin
  receive(address,addr);
  instr <= imem(conv_integer(addr(2 downto 0)));
  wait for delay(5,10);
  send(data,instr);
end process;
end behavior;
--\end{algorithm}

