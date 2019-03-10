-------------------------------------------
-- Block code:  simple_dff_circ.vhd
-- History:     04.Feb.2014 - 1st version (dqtm)
-- Function:    simple 1-DFF circuit for VHDL introduction
-------------------------------------------

-- Library & Use Statements
library ieee;
use ieee.std_logic_1164.all;


-- Entity Declaration 
entity simple_dff_circ is
  port (
    clock   : in  std_logic;
    reset_n : in  std_logic;
    data_i  : in  std_logic;
    hold_i  : in  std_logic;
    buff_o  : out std_logic
    );
end simple_dff_circ;


-- Architecture Declaration 
architecture rtl of simple_dff_circ is

  -- Signals & Constants Declaration
  signal buff, next_buff : std_logic;

-- Begin Architecture
begin
  -------------------------------------------
  -- Process for combinatorial logic
  -------------------------------------------
  comb_logic : process(all)
  begin
    -- hold or update
    if hold_i = '1' THEN
                        next_buff <= buff;
  else
    next_buff <= data_i;
  end if;
end process comb_logic;


------------------------------------------- 
-- Process for registers (flip-flops)
-------------------------------------------
flip_flops : process(clock, reset_n)
begin
  if reset_n = '0' then
    buff <= '0';
  elsif RISING_EDGE(clock) then
    buff <= next_buff;
  end if;
end process flip_flops;

-------------------------------------------
-- Concurrent Assignements  
-- e.g. Assign outputs from intermediate signals
-------------------------------------------
buff_o <= buff;

                                        -- End Architecture    
end rtl;
