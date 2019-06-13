-------------------------------------------
-- Block code:  baud_tick.vhd
-- History:     15.Nov.2017 - 1st version (dqtm)
--                 <date> - <changes>  (<author>)
-- Function: edge detector with rise & fall outputs. 
--           Declaring FFs as a shift-register.
-------------------------------------------

-- Library & Use Statements
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity Declaration 
entity baud_tick is
  port(Clk       : in  std_logic;
       start_bit : in  std_logic;
       reset_n   : in  std_logic;
       baud_tick : out std_logic
       );
end baud_tick;


-- Architecture Declaration 
architecture rtl of baud_tick is

  constant clock                     : natural                            := 50_000_000;  --Hz
  constant baud_rate                 : natural                            := 115_200;  --Hz
  constant count_width               : natural                            := 10;  --freqclock/freqbaudrate==50000000/115200=434 ==>434 bruucht 10bit
  constant one_period                : unsigned(count_width - 1 downto 0) := to_unsigned(400, count_width);
  constant half_period               : unsigned(count_width - 1 downto 0) := to_unsigned(200, count_width);
  signal baud_count, next_baud_count : unsigned(count_width - 1 downto 0);



-- Begin Architecture
begin


  reg_proc : process(all)
  begin
    baud_tick <= '0';
    if start_bit = '1' then
      next_baud_count <= half_period;

    elsif baud_count = 0 then
      next_baud_count <= one_period;
      baud_tick       <= '1';
    else next_baud_count <= baud_count-1;

    end if;



  end process reg_proc;

  clok : process(all)
  begin
    if reset_n = '0' then

      baud_count <= (others => '0');
    elsif rising_edge(Clk) then
      baud_count <= next_baud_count;
    end if;
  end process clok;



end rtl;



