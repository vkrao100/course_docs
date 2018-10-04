--\begin{algorithm}
--\small
--------------------
-- minimips.vhd
--------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.channel.all;

entity minimips is
end minimips;

architecture structure of minimips is
  component imem
    port(data:inout channel;
         address:inout channel);
  end component;
  component fetch
    port(branch_decision:inout channel;
         decode_instr:inout channel;
         imem_data:inout channel;
         imem_address:inout channel);
  end component;
  component decode
    port(dmem_dataout:inout channel;
         dmem_datain:inout channel;
         execute_offset:inout channel;
         execute_func:inout channel;
         execute_rd:inout channel;
         execute_rt:inout channel;
         execute_rs:inout channel;
         execute_op:inout channel;
         decode_instr:inout channel);
  end component;
  component execute
    port(branch_decision:inout channel;
         dmem_rw:inout channel;
         dmem_addr:inout channel;
         execute_offset:inout channel;
         execute_func:inout channel;
         execute_rd:inout channel;
         execute_rt:inout channel;
         execute_rs:inout channel;
         execute_op:inout channel);
  end component;
  component dmem
    port(read_write:inout channel;
         data_out:inout channel;
         data_in:inout channel;
         address:inout channel);
  end component;
  signal addr:channel;
  signal bd:channel;
  signal datain:channel;
  signal dataout:channel;
  signal func:channel;
  signal instr:channel;
  signal new_instr:channel;
  signal offset:channel;
  signal op:channel;
  signal PC:channel;
  signal rd:channel;
  signal read_write:channel;
  signal rs:channel;
  signal rt:channel;
begin
  imem1:imem
    port map(data => new_instr,
             address => PC);
  fetch1:fetch
    port map(branch_decision => bd,
             decode_instr => instr,
             imem_data => new_instr,
             imem_address => PC);
  decode1:decode
    port map(dmem_dataout => dataout,
             dmem_datain => datain,
             execute_offset => offset,
             execute_func => func,
             execute_rd => rd,
             execute_rt => rt,
             execute_rs => rs,
             execute_op => op,
             decode_instr => instr);
  execute1:execute
    port map(branch_decision => bd,
             dmem_rw => read_write,
             dmem_addr => addr,
             execute_offset => offset,
             execute_func => func,
             execute_rd => rd,
             execute_rt => rt,
             execute_rs => rs,
             execute_op => op);
  dmem1:dmem
    port map(read_write => read_write,
             data_out => dataout,
             data_in => datain,
             address => addr);
end structure;
--\end{algorithm}
