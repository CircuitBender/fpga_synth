-------------------------------------------
-- Block code:  edge_detector.vhd
-- History:     14.Oct.2013 - 1st version (dqtm)
--              01.Mar.2018 - rename in English (dqtm)
-- Function: synchronous edge detector for a serial data input.
--           Outputs are rise and fall pulses lasting 1 clock period. 
--
-------------------------------------------

-- Library & Use Statements
library ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration 
entity edge_detector is
  port(data_in : in  std_logic;
       clock   : in  std_logic;
       reset_n : in  std_logic;
       rise    : out std_logic;
       fall    : out std_logic
       );
end edge_detector;


-- Architecture Declaration 
architecture rtl of edge_detector is

  -- Signals & Constants Declaration 
  signal Q_after1FF : std_logic;
  signal Q_after2FF : std_logic;

-- Begin Architecture
begin
  -------------------------------------------
  -- Process for combinational logic
  ------------------------------------------- 
  -- not needed in this file, using concurrent logic

  -------------------------------------------
  -- Process for registers (flip-flops)
  -------------------------------------------
  flip_flops : process(clock, reset_n)
  begin
    if reset_n = '0' then
      Q_after1FF <= '0';
      Q_after2FF <= '0';
    elsif rising_edge(clock) then
      Q_after1FF <= data_in;
      Q_after2FF <= Q_after1FF;
    end if;
  end process flip_flops;


  -------------------------------------------
  -- Concurrent Assignments  
  -------------------------------------------
  rise <= Q_after1FF and not(Q_after2FF);
  fall <= Q_after2FF and not(Q_after1FF);


end rtl;
