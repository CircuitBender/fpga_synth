-------------------------------------------
-- Block code:  gray_decoder.vhd
-- History:     30.Sep.2013 - 1st version (gelk)
--                              05.Okt.2015 - added template comments (dqtm)
--              01.Mar.2018 - changed for comb inside process (dqtm)
-- Function: Decodes 3-bit vector from binary or bcd to gray code.
--           Only comb logic. Implementation with process.
-------------------------------------------

-- Library & Use Statements
library ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration 
entity gray_decoder is
  port(
    bcd_in   : in  std_logic_vector(2 downto 0);
    gray_out : out std_logic_vector(2 downto 0)
    );
end gray_decoder;

-- Architecture Declaration 
architecture rtl of gray_decoder is
-- Signals & Constants Declaration 
  constant gray_0 : std_logic_vector(2 downto 0) := "000";
  constant gray_1 : std_logic_vector(2 downto 0) := "001";
  constant gray_2 : std_logic_vector(2 downto 0) := "011";
  constant gray_3 : std_logic_vector(2 downto 0) := "010";
  constant gray_4 : std_logic_vector(2 downto 0) := "110";
  constant gray_5 : std_logic_vector(2 downto 0) := "111";
  constant gray_6 : std_logic_vector(2 downto 0) := "101";
  constant gray_7 : std_logic_vector(2 downto 0) := "100";

-- Begin Architecture
begin

  -------------------------------------------
  -- Process for combinational logic  
  -------------------------------------------
  comb_proc : process (bcd_in)
  begin
    case bcd_in is
      when "000"  => gray_out <= gray_0;
      when "001"  => gray_out <= gray_1;
      when "010"  => gray_out <= gray_2;
      when "011"  => gray_out <= gray_3;
      when "100"  => gray_out <= gray_4;
      when "101"  => gray_out <= gray_5;
      when "110"  => gray_out <= gray_6;
      when others => gray_out <= gray_7;
    end case;
  end process comb_proc;

end rtl;

