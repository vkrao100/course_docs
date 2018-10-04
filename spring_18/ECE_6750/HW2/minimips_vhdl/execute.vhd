--\begin{algorithm}
--\small
----------------------
-- execute.vhd
----------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; 
use work.nondeterminism.all;
use work.channel.all;

entity execute is
  port(execute_op:inout channel:=init_channel;
       execute_rs:inout channel:=init_channel;
       execute_rt:inout channel:=init_channel;
       execute_rd:inout channel:=init_channel;
       execute_func:inout channel:=init_channel;
       execute_offset:inout channel:=init_channel;
       dmem_addr:inout channel:=init_channel;
       dmem_rw:inout channel:=init_channel;
       branch_decision:inout channel:=init_channel);
end execute;

architecture behavior of execute is 
  signal rs:std_logic_vector(31 downto 0);
  signal rt:std_logic_vector(31 downto 0);
  signal rd:std_logic_vector(31 downto 0);
  signal op:std_logic_vector(5 downto 0);
  signal func:std_logic_vector(5 downto 0);
  signal offset:std_logic_vector(15 downto 0);
  signal rw:std_logic;
  signal bd:std_logic;
begin
process
  variable addr_offset:std_logic_vector(31 downto 0);
begin
  receive(execute_op,op);
  case op is
  when "000000" => -- ALU op
    receive(execute_func,func,execute_rs,rs,
            execute_rt,rt);
    case func is
    when "100000" => -- add
      rd <= rs + rt;
    when "100010" => -- sub
      rd <= rs - rt;
    when "100100" => -- and
      rd <= rs and rt;
    when "100101" => -- or
      rd <= rs or rt;
    when others =>
      rd <= (others => 'X'); -- undefined
    end case;
    wait for delay(5,10);
    send(execute_rd,rd);
  when "000100" => -- beq
    receive(execute_rs,rs,execute_rt,rt);
    if (rs = rt) then bd <= '1';
    else bd <= '0';
    end if;
    wait for delay(5,10);
    send(branch_decision,bd);
  when "100011" => -- lw
    receive(execute_rs,rs,execute_offset,offset);
    addr_offset(31 downto 16):=(others => offset(15));
    addr_offset(15 downto 0):=offset;
    rd <= rs + addr_offset;
    rw <= '1';
    wait for delay(5,10);
    send(dmem_addr,rd);
    send(dmem_rw,rw);
  when "101011" => -- sw
    receive(execute_rs,rs,execute_offset,offset);
    addr_offset(31 downto 16):=(others => offset(15));
    addr_offset(15 downto 0):=offset;
    rd <= rs + addr_offset;
    rw <= '0';
    wait for delay(5,10);
    send(dmem_addr,rd);
    send(dmem_rw,rw);
  when others => -- undefined
    assert false
      report "Illegal instruction"
      severity error;
  end case;
  end process;
end behavior;
--\end{algorithm}
