--\begin{algorithm}
--\small
---------------------
-- decode.vhd
---------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; 
use work.nondeterminism.all;
use work.channel.all;

entity decode is
  port(decode_instr:inout channel:=init_channel;
       execute_op:inout channel:=init_channel;
       execute_rs:inout channel:=init_channel;
       execute_rt:inout channel:=init_channel;
       execute_rd:inout channel:=init_channel;
       execute_func:inout channel:=init_channel;
       execute_offset:inout channel:=init_channel;
       dmem_datain:inout channel:=init_channel;
       dmem_dataout:inout channel:=init_channel;
       prog_coun_in:inout channel:=init_channel);
end decode;

architecture behavior of decode is 
  type registers is array (0 to 7) of 
       std_logic_vector(31 downto 0);
  type booleans is array (natural range <>) of boolean;
  signal instr : std_logic_vector( 31 downto 0);
  alias op:std_logic_vector(5 downto 0) is
    instr(31 downto 26);
  alias rs:std_logic_vector(2 downto 0) is
    instr(23 downto 21);
  alias rt:std_logic_vector(2 downto 0) is
    instr(18 downto 16);
  alias rd:std_logic_vector(2 downto 0) is
    instr(13 downto 11);
  alias func:std_logic_vector(5 downto 0) is
    instr(5 downto 0);
  alias offset:std_logic_vector(15 downto 0) is
    instr(15 downto 0);
  signal reg:registers:=(X"00000000",
                         X"11111111",
                         X"22222222",
                         X"33333333",
                         X"44444444",
                         X"55555555",
                         X"66666666",
                         X"77777777");
  signal reg_rs:std_logic_vector(31 downto 0);
  signal reg_rt:std_logic_vector(31 downto 0);
  signal reg_rd:std_logic_vector(31 downto 0);
  signal reg_locks:booleans(0 to 7):=(others => false);
  signal decode_to_wb:channel:=init_channel;
  signal wb_instr:std_logic_vector(31 downto 0);
  alias wb_op:std_logic_vector(5 downto 0) is
    wb_instr(31 downto 26);
  alias wb_rt:std_logic_vector(2 downto 0) is
    wb_instr(18 downto 16);
  alias wb_rd:std_logic_vector(2 downto 0) is
    wb_instr(13 downto 11);
  signal lock:channel:=init_channel;
begin
decode:process
begin
  receive(decode_instr,instr);
  if ((reg_locks(conv_integer(rs))) or 
      (reg_locks(conv_integer(rt)))) then
    wait until ((not reg_locks(conv_integer(rs))) and 
                (not reg_locks(conv_integer(rt))));
  end if;
  reg_rs <= reg(conv_integer(rs));
  reg_rt <= reg(conv_integer(rt));
  send(execute_op,op);
  wait for delay(5,10);
  case op is
  when "000000" => -- ALU op
    send(execute_func,func,execute_rs,reg_rs,
         execute_rt,reg_rt);
    send(decode_to_wb,instr);
    receive(lock);
  when "000100" => -- beq
    send(execute_rs,reg_rs,execute_rt,reg_rt);
  when "100011" => -- lw
    send(execute_rs,reg_rs,execute_offset,offset);
    send(decode_to_wb,instr);
    receive(lock);
  when "101011" => -- sw
    send(execute_rs,reg_rs,execute_offset,offset,
         dmem_datain,reg_rt);
  when "000011" => -- jal- no wb as this is not a ALU operation
    receive(prog_coun_in,reg_rd);
    reg(7) <= reg_rd; --old PC loaded to reg 7
    wait for delay(5,10);
  when others => -- undefined
    assert false
      report "Illegal instruction"
      severity error;
  end case;
end process;

writeback:process
begin
  receive(decode_to_wb,wb_instr);
  case wb_op is 
  when "000000" => -- ALU op
    reg_locks(conv_integer(wb_rd)) <= true;
    wait for 1 ns;
    send(lock);
    receive(execute_rd,reg_rd);
    reg(conv_integer(wb_rd)) <= reg_rd;
    wait for delay(5,10);
    reg_locks(conv_integer(wb_rd)) <= false;
    wait for delay(5,10);
  when "100011" => -- lw
    reg_locks(conv_integer(wb_rt)) <= true;
    wait for 1 ns;
    send(lock);
    receive(dmem_dataout,reg_rd);
    reg(conv_integer(wb_rt)) <= reg_rd;
    wait for delay(5,10);
    reg_locks(conv_integer(wb_rt)) <= false;
    wait for delay(5,10);
  when others => -- undefined
    wait for delay(5,10);
  end case;
end process; 
end behavior;
--\end{algorithm}

