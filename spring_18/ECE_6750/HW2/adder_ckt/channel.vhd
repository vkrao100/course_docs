--\begin{packit}
library IEEE; 
use IEEE.std_logic_1164.all; 

package channel is

  constant MAX_BIT_WIDTH:natural:=32;
  subtype datatype is std_logic_vector((MAX_BIT_WIDTH-1) downto 0 );
  constant dataZ:datatype:=datatype'(others => 'Z');
  constant data0:datatype:=datatype'(others => '0');
  constant dataACK:dataType:=dataType'(others => '1');

  type channel is record
    dataright,dataleft:datatype;
    pending_send,pending_recv,sync:std_logic;
  end record;

  type bools is array (natural range <>) of boolean;

  -- Used to send data on a channel
  procedure send(signal c1:inout channel);

  procedure send(signal c1:inout channel;signal d1:inout std_logic);

  procedure send(signal c1:inout channel;signal d1:inout std_logic;
                 signal c2:inout channel;signal d2:inout std_logic);

  procedure send(signal c1:inout channel;signal d1:inout std_logic;
                 signal c2:inout channel;signal d2:inout std_logic;
                 signal c3:inout channel;signal d3:inout std_logic);

  procedure send(signal c1:inout channel;signal d1:inout std_logic_vector);

  procedure send(signal c1:inout channel;signal d1:inout std_logic_vector;
                 signal c2:inout channel;signal d2:inout std_logic_vector);

  procedure send(signal c1:inout channel;signal d1:inout std_logic_vector;
                 signal c2:inout channel;signal d2:inout std_logic_vector;
                 signal c3:inout channel;signal d3:inout std_logic_vector);

  -- Used to receive data on a channel
  procedure receive(signal c1:inout channel);

  procedure receive(signal c1:inout channel;signal d1:inout std_logic);

  procedure receive(signal c1:inout channel;signal d1:inout std_logic;
                    signal c2:inout channel;signal d2:inout std_logic);

  procedure receive(signal c1:inout channel;signal d1:inout std_logic;
                    signal c2:inout channel;signal d2:inout std_logic;
                    signal c3:inout channel;signal d3:inout std_logic);

  procedure receive(signal c1:inout channel;signal d1:inout std_logic_vector);

  procedure receive(signal c1:inout channel;signal d1:inout std_logic_vector;
                    signal c2:inout channel;signal d2:inout std_logic_vector);

  procedure receive(signal c1:inout channel;signal d1:inout std_logic_vector;
                    signal c2:inout channel;signal d2:inout std_logic_vector;
                    signal c3:inout channel;signal d3:inout std_logic_vector);

  -- Initialization function called in a port declaration 
  -- as a default value to initialize a channel.
  function init_channel return channel;

  function active return channel;

  function passive return channel;

  -- Test for pending communication on a channel
  function probe(signal chan:in channel) return boolean;

end channel;

package body channel is

  procedure validate(signal data:in std_logic_vector) is
  begin
    assert( data'LENGTH <= MAX_BIT_WIDTH ) 
      report "Bit width is too wide" severity failure;
  end validate;

  function init_channel return channel is
  begin
    return(dataright=>dataZ,dataleft=>dataZ,
           pending_send=>'Z',pending_recv=>'Z',sync=>'Z');
  end init_channel;

  function active return channel is
  begin
    return(dataright=>dataZ,dataleft=>dataZ,
           pending_send=>'Z',pending_recv=>'Z',sync=>'Z');
  end active;

  function passive return channel is
  begin
    return(dataright=>dataZ,dataleft=>dataZ,
           pending_send=>'Z',pending_recv=>'Z',sync=>'Z');
  end passive;

  procedure send_handshake(variable done:inout boolean;
                           variable reset:inout boolean;
                           signal chan:inout channel) is
  begin
    if (done=false) then
      if (reset=false) then
        if (chan.pending_send='Z') then
          chan.pending_send<='1';
        end if;
        if (chan.sync='1') then
          chan.pending_send<='Z';
          reset:=true;
        end if;
      elsif (chan.sync='Z') then
        done:=true;
      end if;
    end if;
  end send_handshake;

  function zero_extend(signal data:in std_logic) return datatype is
    variable extdata:datatype;
  begin
    extdata := data0;
    extdata(0) := data;
    return extdata;
  end zero_extend;  

  function zero_extend(signal data:in std_logic_vector) 
    return datatype is
    variable extdata:datatype;
  begin
    validate(data);
    extdata := data0;
    extdata( data'length - 1 downto 0 ) := data;
    return extdata;
  end zero_extend;

  procedure send(signal c1:inout channel) is
    variable done:bools(1 to 1) := (others => false);
    variable reset:bools(1 to 1) := (others => false);
  begin
    loop
      send_handshake(done(1),reset(1),c1);
      exit when (done(1)=true);
      wait on c1.sync;
    end loop;
  end send;
 
  procedure send(signal c1:inout channel;signal d1:inout std_logic) is
    variable done:bools(1 to 1) := (others => false);
    variable reset:bools(1 to 1) := (others => false);
  begin
    c1.dataright <= zero_extend(d1);
    loop
      send_handshake(done(1),reset(1),c1);
      exit when (done(1)=true);
      wait on c1.sync,c1.pending_send,c1.pending_recv;
    end loop;
  end send;

  procedure send(signal c1:inout channel;signal d1:inout std_logic;
                 signal c2:inout channel;signal d2:inout std_logic) is
    variable done:bools(1 to 2) := (others => false);
    variable reset:bools(1 to 2) := (others => false);
  begin
    c1.dataright <= zero_extend(d1);
    c2.dataright <= zero_extend(d2);
    loop
      send_handshake(done(1),reset(1),c1);
      send_handshake(done(2),reset(2),c2);
      exit when ((done(1)=true) and (done(2)=true));
      wait on c1.sync,c2.sync;
    end loop;
  end send;

  procedure send(signal c1:inout channel;signal d1:inout std_logic;
                 signal c2:inout channel;signal d2:inout std_logic;
                 signal c3:inout channel;signal d3:inout std_logic) is
    variable done:bools(1 to 3) := (others => false);
    variable reset:bools(1 to 3) := (others => false);
  begin
    c1.dataright <= zero_extend(d1);
    c2.dataright <= zero_extend(d2);
    c3.dataright <= zero_extend(d3);
    loop
      send_handshake(done(1),reset(1),c1);
      send_handshake(done(2),reset(2),c2);
      send_handshake(done(3),reset(3),c3);
      exit when ((done(1)=true) and (done(2)=true) and (done(3)=true));
      wait on c1.sync,c2.sync,c3.sync;
    end loop;
  end send; 

  procedure send(signal c1:inout channel;
                 signal d1:inout std_logic_vector) is
    variable done:bools(1 to 1) := (others => false);
    variable reset:bools(1 to 1) := (others => false);
  begin
    c1.dataright <= zero_extend(d1);
    loop
      send_handshake(done(1),reset(1),c1);
      exit when (done(1)=true);
      wait on c1.sync,c1.pending_send,c1.pending_recv;
    end loop;
  end send;

  procedure send(signal c1:inout channel;signal d1:inout std_logic_vector;
                 signal c2:inout channel;signal d2:inout std_logic_vector) is
    variable done:bools(1 to 2) := (others => false);
    variable reset:bools(1 to 2) := (others => false);
  begin
    c1.dataright <= zero_extend(d1);
    c2.dataright <= zero_extend(d2);
    loop
      send_handshake(done(1),reset(1),c1);
      send_handshake(done(2),reset(2),c2);
      exit when ((done(1)=true) and (done(2)=true));
      wait on c1.sync,c2.sync;
    end loop;
  end send;

  procedure send(signal c1:inout channel;signal d1:inout std_logic_vector;
                 signal c2:inout channel;signal d2:inout std_logic_vector;
                 signal c3:inout channel;signal d3:inout std_logic_vector) is
    variable done:bools(1 to 3) := (others => false);
    variable reset:bools(1 to 3) := (others => false);
  begin
    c1.dataright <= zero_extend(d1);
    c2.dataright <= zero_extend(d2);
    c3.dataright <= zero_extend(d3);
    loop
      send_handshake(done(1),reset(1),c1);
      send_handshake(done(2),reset(2),c2);
      send_handshake(done(3),reset(3),c3);
      exit when ((done(1)=true) and (done(2)=true) and (done(3)=true));
      wait on c1.sync,c2.sync,c3.sync;
    end loop;
  end send;

  procedure recv_hse(variable done:inout boolean;
                     variable reset:inout boolean;
                     signal chan:inout channel) is
  begin
    if (done = false) then
      if (reset = false) then
        if ((chan.pending_recv='Z') and
            (chan.sync='Z')) then
          chan.pending_recv<='1';
        end if;
        if (chan.sync='1') then
          chan.pending_recv<='Z';
        end if;
        if ((chan.pending_send='1') and
            (chan.pending_recv='1') and
            (chan.sync='Z')) then
          chan.sync<='1';
        end if;
        if ((chan.pending_send='Z') and
            (chan.pending_recv='Z') and
            (chan.sync='1')) then 
          chan.sync <= 'Z';
          reset:=true;
        end if;
      elsif (chan.sync='Z') then
        done:=true;
      end if;
    end if;
  end recv_hse;

  procedure recv_hse(variable done:inout boolean;
                     variable reset:inout boolean;
                     signal chan:inout channel;signal data:out std_logic) is
  begin
    if (done=false) then
      if (reset=false) then
        if ((chan.pending_recv='Z') and
            (chan.sync= 'Z')) then
          chan.pending_recv<='1';
        end if;
        if (chan.sync='1') then
          chan.pending_recv<='Z';
        end if;
        if ((chan.pending_send='1') and
            (chan.pending_recv='1') and
            (chan.sync='Z')) then
          chan.sync<='1';
          data<=chan.dataright(0);
        end if;
        if ((chan.pending_send='Z') and
            (chan.pending_recv='Z') and
            (chan.sync='1')) then 
          chan.sync<='Z';
          reset:=true;
        end if;
      elsif (chan.sync='Z') then
        done:=true;
      end if;
    end if;
  end recv_hse;

  procedure recv_hse(variable done:inout boolean;
                     variable reset:inout boolean;
                     signal chan:inout channel;
                     signal data:out std_logic_vector) is
  begin
    if (done=false) then
      if (reset=false) then
        if ((chan.pending_recv='Z') and
            (chan.sync='Z')) then
          chan.pending_recv<='1';
        end if;
        if (chan.sync='1') then
          chan.pending_recv<='Z';
        end if;
        if ((chan.pending_send='1') and
            (chan.pending_recv='1') and
            (chan.sync='Z')) then
          chan.sync<='1';
          data<=chan.dataright(data'length - 1 downto 0);
        end if;
        if ((chan.pending_send='Z') and
            (chan.pending_recv='Z') and
            (chan.sync='1')) then 
          chan.sync<='Z';
          reset:=true;
        end if;
      elsif (chan.sync='Z') then
        done:=true;
      end if;
    end if;
  end recv_hse;

  procedure receive (signal c1:inout channel) is
    variable done:bools(1 to 1) := (others => false);
    variable reset:bools(1 to 1) := (others => false);
  begin
    loop
      recv_hse(done(1),reset(1),c1);
      exit when (done(1)=true);
      wait on c1.pending_send,c1.sync,c1.pending_recv;
    end loop;
  end receive;

  procedure receive(signal c1:inout channel;signal d1:inout std_logic) is
    variable done:bools(1 to 1) := (others => false);
    variable reset:bools(1 to 1) := (others => false);
  begin
    loop
      recv_hse(done(1),reset(1),c1,d1);
      exit when (done(1)=true);
      wait on c1.pending_send,c1.sync,c1.pending_recv;
    end loop;
  end receive;

  procedure receive(signal c1:inout channel;signal d1:inout std_logic;
                    signal c2:inout channel;signal d2:inout std_logic) is
    variable done:bools(1 to 2) := (others => false);
    variable reset:bools(1 to 2) := (others => false);
  begin
    loop
      recv_hse(done(1),reset(1),c1,d1);
      recv_hse(done(2),reset(2),c2,d2);
      exit when ((done(1)=true) and (done(2)=true));
      wait on c1.pending_send,c1.sync,c1.pending_recv,
        c2.pending_send,c2.sync,c2.pending_recv;
    end loop;
  end receive;

  procedure receive(signal c1:inout channel;signal d1:inout std_logic;
                    signal c2:inout channel;signal d2:inout std_logic;
                    signal c3:inout channel;signal d3:inout std_logic) is
    variable done:bools(1 to 3) := (others => false);
    variable reset:bools(1 to 3) := (others => false);
  begin
    loop
      recv_hse(done(1),reset(1),c1,d1);
      recv_hse(done(2),reset(2),c2,d2);
      recv_hse(done(3),reset(3),c3,d3);
      exit when ((done(1)=true) and (done(2)=true) and (done(3)=true));
      wait on c1.pending_send,c1.sync,c1.pending_recv,c2.pending_send,
        c2.sync,c2.pending_recv,c3.pending_send,c3.sync,c3.pending_recv;
    end loop;
  end receive;

  procedure receive(signal c1:inout channel;signal d1:inout std_logic_vector
                   ) is
    variable done:bools(1 to 1) := (others => false);
    variable reset:bools(1 to 1) := (others => false);
  begin
    validate( d1 );
    loop
      recv_hse(done(1),reset(1),c1,d1);
      exit when (done(1)=true);
      wait on c1.pending_send,c1.sync,c1.pending_recv;
    end loop;
  end receive;

  procedure receive(signal c1:inout channel;signal d1:inout std_logic_vector;
                    signal c2:inout channel;signal d2:inout std_logic_vector
                    ) is
    variable done:bools(1 to 2) := (others => false);
    variable reset:bools(1 to 2) := (others => false);
  begin
    validate( d1 );
    validate( d2 );
    loop
      recv_hse(done(1),reset(1),c1,d1);
      recv_hse(done(2),reset(2),c2,d2);
      exit when ((done(1)=true) and (done(2)=true));
      wait on c1.pending_send,c1.sync,c1.pending_recv,
        c2.pending_send,c2.sync,c2.pending_recv;
    end loop;
  end receive;

  procedure receive(signal c1:inout channel;signal d1:inout std_logic_vector;
                    signal c2:inout channel;signal d2:inout std_logic_vector;
                    signal c3:inout channel;signal d3:inout std_logic_vector
                    ) is
    variable done:bools(1 to 3) := (others => false);
    variable reset:bools(1 to 3) := (others => false);
  begin
    validate( d1 );
    validate( d2 );
    validate( d3 );
    loop
      recv_hse(done(1),reset(1),c1,d1);
      recv_hse(done(2),reset(2),c2,d2);
      recv_hse(done(3),reset(3),c3,d3);
      exit when ((done(1)=true) and (done(2)=true) and (done(3)=true));
      wait on c1.pending_send,c1.sync,c1.pending_recv,c2.pending_send,
        c2.sync,c2.pending_recv,c3.pending_send,c3.sync,c3.pending_recv;
    end loop;
  end receive;

  function probe( signal chan:in channel ) return boolean is
  begin
    return ((chan.pending_send='1') or (chan.pending_recv='1'));
  end probe;

end channel;
--\end{packit}

