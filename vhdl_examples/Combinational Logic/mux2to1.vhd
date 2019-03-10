-------------------------------------------
-- Block code:  <filename>.vhd
-- History:     24.Sep.2013 - 1st version (gelk)
--                 <date> - <changes>  (<author>)
-- Function: 2-1Mux, plain functionality, example for IF-THEN/ELSE
--            implemented with comb logic inside process
-------------------------------------------

-- Library & Use Statements
library ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration 
entity mux2to1 is
  port(
    a, b : in  std_logic_vector(7 downto 0);
    sel  : in  std_logic;
    x    : out std_logic_vector(7 downto 0)
    );
end mux2to1;


-- Architecture Declaration 
architecture rtl of mux2to1 is

-- Begin Architecture
begin

  -------------------------------------------
  -- Process for combinational logic 
  -------------------------------------------
  muxer : process(all)
  begin
    if (sel = '1') then
      x <= a;
    else
      x <= b;
    end if;
  end process;


end rtl;

