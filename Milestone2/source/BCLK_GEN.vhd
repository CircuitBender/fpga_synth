-------------------------------------------------------------------------------
-- Title      : BCLK_GEN
-- Project    : fpga_synth
-------------------------------------------------------------------------------
-- File       : BCLK_GEN.vhd
-- Author     : Heinzen
-- Company    : 
-- Created    : 2019-03-29
-- Last update: 2019-03-29
-- Platform   : Windows 10
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: BCLK_GEN baud clock generator
-------------------------------------------------------------------------------
-- Copyright (c) 2019
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 30.03.2019  1.0      Heinzen         Created
-- 05.04.2019  1.1      Heinzen         version 2

-------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bclk_gen is
port(
  clk_12m         : in  std_logic;
  reset_n         : in  std_logic;
  bclk_o    : out std_logic;
 
end bclk_gen;
architecture rtl of bclk_gen is
signal clk_divider        : unsigned(3 downto 0);
begin
bclk_gen_process: process(reset_n,clk_12m)
begin
  if(reset_n='0') then
    clk_divider   <= (others=>'0');
  elsif(rising_edge(clk_12m)) then
    clk_divider   <= clk_divider + 1;
  end if;
end process bclk_gen_process;
bclk_0    <= not clk_divider(0);

end rtl;




