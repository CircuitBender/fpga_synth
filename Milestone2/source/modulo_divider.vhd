-------------------------------------------
-- Block code:  modulo_divider.vhd
-- History:     14.Nov.2012 - 1st version (dqtm)
--                 <date> - <changes>  (<author>)
-- Function: modulo divider with generic width. Output MSB with 50% duty cycle.
--              Can be used for clock-divider when no exact ratio required.
-------------------------------------------

-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity Declaration 
-------------------------------------------
entity modulo_divider is
  generic (width : positive := 5);
  port(clk_i, reset_n_i : in  std_logic;
       clk_12m_o      : out std_logic
       );
end modulo_divider;

-- Architecture Declaration 
-------------------------------------------
architecture rtl of modulo_divider is
-- Signals & Constants Declaration 
-------------------------------------------
  signal count, next_count : unsigned(width-1 downto 0) := (others => '0');  -- exception! Forcing to enable start without reset in simu

-- Begin Architecture
-------------------------------------------
begin

  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  comb_logic : process(all)
  begin
    -- increment        
    next_count <= count + 1;
  end process comb_logic;

  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : process(all)
  begin
    if reset_n_i = '0' then
      count <= to_unsigned(0, width);
    elsif rising_edge(clk_i) then
      count <= next_count;
    end if;
  end process flip_flops;

  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  -- take MSB and convert for output data-type
  clk_12m_o <= std_logic(count(width-1));

-- End Architecture 
------------------------------------------- 
end rtl;

