--\begin{algorithm}
--\small
-------------------
-- dmem.vhd
-------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; 
use work.nondeterminism.all;
use work.channel.all;

entity dmem is
  port(address:inout channel:=init_channel;
       data_in:inout channel:=init_channel;
       data_out:inout channel:=init_channel;
       read_write:inout channel:=init_channel);
end dmem;

architecture behavior of dmem is
  type memory is array (0 to 7) of 
    std_logic_vector(31 downto 0);
  signal addr:std_logic_vector(31 downto 0);
  signal d:std_logic_vector(31 downto 0);
  signal rw:std_logic;
  signal dmem:memory:=(X"00000000",
                       X"11111111",
                       X"22222222",
                       X"33333333",
                       X"44444444",
                       X"55555555",
                       X"66666666",
                       X"77777777");
begin
process
begin
  receive(address,addr);
  receive(read_write,rw);
  case rw is
  when '1' => 
    d <= dmem(conv_integer(addr(2 downto 0)));
    wait for delay(5,10);
    send(data_out,d);
  when '0' =>
    receive(data_in,d);
    dmem(conv_integer(addr(2 downto 0))) <= d;
    wait for delay(5,10);
  when others =>
    wait for delay(5,10);
  end case;
end process;
end behavior;
--\end{algorithm}
