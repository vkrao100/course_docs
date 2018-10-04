--\begin{algorithm}
--\small
--------------------
-- fetch.vhd
--------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; 
use work.nondeterminism.all;
use work.channel.all;

entity fetch is
  port(imem_address:inout channel:=init_channel; 
       imem_data:inout channel:=init_channel;
       decode_instr:inout channel:=init_channel;
       branch_decision:inout channel:=init_channel;
       Prog_Coun_out:inout channel:=init_channel);
end fetch;

architecture behavior of fetch is 
  signal PC:std_logic_vector(31 downto 0):=(others=>'0');
  signal instr:std_logic_vector(31 downto 0);
  signal bd:std_logic;
  alias opcode:std_logic_vector(5 downto 0) is
    instr(31 downto 26);
  alias offset:std_logic_vector(15 downto 0) is
    instr(15 downto 0);
  alias address:std_logic_vector(25 downto 0) is
    instr(25 downto 0); 
begin
process
  variable branch_offset:std_logic_vector(31 downto 0);
begin
  send(imem_address,PC);
  receive(imem_data,instr);
  PC <= PC + 1;
  wait for delay(5,10);
  case opcode is
  when "000100" => -- beq
    send(decode_instr,instr);
    receive(branch_decision,bd);
    if (bd = '1') then
      branch_offset(31 downto 16):=(others=>instr(15));
      branch_offset(15 downto 0):=offset;
      PC <= PC + branch_offset;
      wait for delay(5,10);
    end if;
  when "000110" => -- j
    PC <= (PC(31 downto 26) & address);
    wait for delay(5,10);
  when "000011" => --jal
    send(decode_instr,instr); --decode instruction
    send(Prog_Coun_out,PC); --send old PC counter 
    PC <= (PC(31 downto 26) & address);--PC address updated
    wait for delay(5,10);
  when others => 
    send(decode_instr,instr);
  end case;
end process;
end behavior;
--\end{algorithm}

