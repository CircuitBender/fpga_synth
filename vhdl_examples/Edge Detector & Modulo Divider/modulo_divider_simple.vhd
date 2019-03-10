-------------------------------------------
-- Block code:  modulo_divider_simple.vhd
-- History:     14.Nov.2012 - 1st version (dqtm)
--                              01.Mar.2018 - simplified version without generic
--                 <date> - <changes>  (<author>)
-- Function: modulo divider with 5 bits. Output MSB with 50% duty cycle.
--              Can be used for clock-divider when no exact ratio required.
-------------------------------------------

-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Entity Declaration 
-------------------------------------------
entity modulo_divider_simple is
  port(clk, reset_n : in  std_logic;
       clk_div      : out std_logic
       );
end modulo_divider_simple;


-- Architecture Declaration
-------------------------------------------
architecture rtl of modulo_divider_simple is
-- Signals & Constants Declaration
-------------------------------------------
  signal count, next_count : unsigned(4 downto 0);

-- Begin Architecture
-------------------------------------------
begin

  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  comb_logic : process(count)
  begin
    -- increment        
    next_count <= count + 1;
  end process comb_logic;

  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : process(clk, reset_n)
  begin
    if reset_n = '0' then
      count <= to_unsigned(0, 5);
    elsif rising_edge(clk) then
      count <= next_count;
    end if;
  end process flip_flops;

  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  -- take MSB and convert for output data-type
  clk_div <= std_logic(count(4));

-- End Architecture 
------------------------------------------- 
end rtl;
