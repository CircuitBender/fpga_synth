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

-------------------------------------------------------------------------------


-- Library & Use Statements
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;


-- Entity Declaration 
-------------------------------------------
ENTITY bclk_gen IS
  PORT( clk_12m, reset_n	: IN    std_logic;
    	  bclk     				: OUT   std_logic
    	);
END bclk_gen;

-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF bclk_gen IS

-- Signals & Constants Declaration
-------------------------------------------
signal bclk_temp : std_logic := '0';
signal counter : integer := 0;
begin
	P1: Process(clk_12m, reset_n)
	begin
		if rising_edge(clk_12m) then
			if reset_n = '0' then
				bclk_temp <= '0';
				counter <= 0;
			else
				counter <= counter + 1;
				if counter = 1 then
					bclk_temp <= '1';
					counter <= 0;
				else 
					bclk_temp <= '0';
				end if;
			end if;
		end if;
	end Process;

  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
	bclk <= bclk_temp; --type conversion for output
  
  
 -- End Architecture 
------------------------------------------- 
END rtl;





