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
-- 18.05.2019  1.1      Rutishauser     Debugging
-- 23.05.2019  1.1.1	Heinzen			Nomenclatura
-------------------------------------------------------------------------------

-------------------------------------------
-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------
-- Entity Declaration
-------------------------------------------
entity BCLK_GEN is
  port (
    reset_n_i : in  std_logic;
    clk_i : in  std_logic;
    bclk_o    : out std_logic
    );
end entity BCLK_GEN;

-------------------------------------------
-- Architecture
-------------------------------------------
architecture rtl of BCLK_GEN is
  
begin 
-------------------------------------------
-- Clock Divider Process
-------------------------------------------
  CLOCK_DIVIDER : process(all)
  begin
    if reset_n_i = '0' then
      bclk_o <= '0';
    elsif rising_edge(clk_i)then
      bclk_o <= bclk_o xor '1';
    end if;
  end process CLOCK_DIVIDER;
  
------------------------------------------- 
-- end architecture
-------------------------------------------
end architecture rtl;