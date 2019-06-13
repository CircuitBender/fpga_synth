-------------------------------------------------------------------------------
-- Title      : BCLK_GEN
-- Project    : fpga_synth
-------------------------------------------------------------------------------
-- File       : BCLK_GEN.vhd
-- Author     : Heinzen
-- Company    : 
-- Created    : 2019-03-29
-- Last update: 2019-05-18
-- Platform   : Windows 10
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: BCLK_GEN baud clock generator
-------------------------------------------------------------------------------
-- Copyright (c) 2019
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 08.03.2019  1.0      Heinzen         Created
-- 18.05.2019  1.1      Rutishauser             Debugging
-------------------------------------------------------------------------------


-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------------------------------------------------

entity BCLK_GEN is

  port (
    reset_n : in  std_logic;
    clk_12m : in  std_logic;
    bclk    : out std_logic
    );

end entity BCLK_GEN;

-------------------------------------------------------------------------------

architecture rtl of BCLK_GEN is

  

begin  -- architecture rtl
  CLOCK_DIVIDER : process(all)
  begin
    if reset_n = '0' then
      bclk <= '0';
    elsif rising_edge(clk_12m)then
      bclk <= bclk xor '1';

    end if;



  end process CLOCK_DIVIDER;
  
end architecture rtl;



















