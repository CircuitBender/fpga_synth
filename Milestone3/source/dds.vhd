-------------------------------------------------------------------------------
-- Project     : fpga_synth
-- Title        : DDS 
-- Description : Constants and LUT for tone generation with DDS
--
--
-------------------------------------------------------------------------------
-- File       : dds.vhd
-- Author     : rutishauser 
-- Company    : 
-- Created    : 2019-04-22
-- Last update: 2019-05-09
-- Platform   : Windows 10
-- Standard   : VHDL'08

-- Change History
-- Date     |Name      |Modification
------------|----------|-------------------------------------------------------
-- 22.04.19 | rutiscla    | dds-Baustein programmieren
-- 09.05.19 | heinzen    | debugging

-------------------------------------------------------------------------------
-- Package  Declaration
-------------------------------------------------------------------------------
-- Include in Design of Block dds.vhd and tone_decoder.vhd :
--   use work.tone_gen_pkg.all;
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tone_gen_pkg.all;


entity DDS is

  port(
    clk_12m    : in  std_logic;
    load_i     : in  std_logic;
    reset_n    : in  std_logic;
    phi_incr_i : in  std_logic_vector (N_CUM-1 downto 0);
    dds_o      : out std_logic_vector (N_AUDIO -1 downto 0)
    );
end DDS;

architecture rtl of DDS is
  signal count, next_count : unsigned (N_CUM-1 downto 0);
  signal lut_addr          : unsigned(N_LUT-1 downto 0);
  signal lut_val           : signed(N_AUDIO-1 downto 0);


begin
  comblogic : process (all)
  begin
    if (load_i = '1') then
      next_count <= (count + unsigned(phi_incr_i));
    else
      next_count <= count;
    end if;
  end process comblogic;

  flipflop : process (all)
  begin
    if reset_n = '0' then
      count <= to_unsigned(0, N_CUM);
    elsif rising_edge(clk_12m) then -- rising oder falling edge ?? von fall zu rise korrigiert
      count <= next_count;
    end if;
  end process flipflop;

-- concurrent assignments:
  lut_addr        <= count(N_CUM-1 downto (N_CUM-N_LUT));
  lut_val         <= to_signed(LUT_SIN(to_integer(lut_addr)), N_AUDIO);
  dds_o           <= std_logic_vector(lut_val); 
end architecture rtl;
