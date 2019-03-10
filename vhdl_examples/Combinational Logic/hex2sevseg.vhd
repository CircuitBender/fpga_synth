-------------------------------------------
-- Block code:  hex2sevseg.vhd
-- History:     24.Sep.2013 - 1st version (dqtm)
--                 <date> - <changes>  (<author>)
-- Function: Hexa to seven-seg converter
--            plain functionality 
--            implemented with comb logic outside process
-------------------------------------------

-- Library & Use Statements
library ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration 
entity hex2sevseg is
  port(
    hexa_i : in  std_logic_vector(3 downto 0);
    seg_o  : out std_logic_vector(6 downto 0));  -- Sequence is "gfedcba" (MSB is seg_g)
end hex2sevseg;

-- Architecture Declaration 
architecture rtl of hex2sevseg is

  -- Signals & Constants Declaration 
  constant display_0     : std_logic_vector(6 downto 0) := "0111111";
  constant display_1     : std_logic_vector(6 downto 0) := "0000110";
  constant display_2     : std_logic_vector(6 downto 0) := "1011011";
  constant display_3     : std_logic_vector(6 downto 0) := "1001111";
  constant display_4     : std_logic_vector(6 downto 0) := "1100110";
  constant display_5     : std_logic_vector(6 downto 0) := "1101101";
  constant display_6     : std_logic_vector(6 downto 0) := "1111101";
  constant display_7     : std_logic_vector(6 downto 0) := "0000111";
  constant display_8     : std_logic_vector(6 downto 0) := "1111111";
  constant display_9     : std_logic_vector(6 downto 0) := "1101111";
  constant display_A     : std_logic_vector(6 downto 0) := "1110111";
  constant display_B     : std_logic_vector(6 downto 0) := "1111100";
  constant display_C     : std_logic_vector(6 downto 0) := "0111001";
  constant display_D     : std_logic_vector(6 downto 0) := "1011110";
  constant display_E     : std_logic_vector(6 downto 0) := "1111001";
  constant display_F     : std_logic_vector(6 downto 0) := "1110001";
  constant display_blank : std_logic_vector(6 downto 0) := (others => '0');

-- Begin Architecture
begin

  -------------------------------------------
  -- Concurrent Assignments  
  -------------------------------------------
  -- Implementation option: concurrent comb logic with with/select/when
  with hexa_i select
    seg_o <= not(display_0) when x"0",  -- added not() for low active display
    not(display_1)          when x"1",
    not(display_2)          when x"2",
    not(display_3)          when x"3",
    not(display_4)          when x"4",
    not(display_5)          when x"5",
    not(display_6)          when x"6",
    not(display_7)          when x"7",
    not(display_8)          when x"8",
    not(display_9)          when x"9",
    not(display_A)          when x"A",
    not(display_B)          when x"B",
    not(display_C)          when x"C",
    not(display_D)          when x"D",
    not(display_E)          when x"E",
    not(display_F)          when x"F",
    not(display_blank)      when others;

end rtl;

