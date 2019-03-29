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
-- 08.03.2019  1.0      Heinzen         Created

-------------------------------------------------------------------------------


-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;



-- Entity Declaration 
-------------------------------------------
entity BCLK_GEN is
  port(clk_12m   : in std_logic;            -- 12.5M Clock
       bclk_o     : out std_logic;      --Bus-Clock out
       );
end BCLK_GEN;

-------------------------------------------
-- Architecture 
-------------------------------------------
architecture rtl of BCLK_GEN is
-------------------------------------------
-- Signals & Constants Declaration
-------------------------------------------

-------------------------------------------
-- Begin Architecture
-------------------------------------------
begin
  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
if rising_edge(clk_12m) and  then 

 --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  
  
end rtl;

