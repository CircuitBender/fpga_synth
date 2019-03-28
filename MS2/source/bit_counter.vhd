-------------------------------------------------------------------------------
-- Title      : bit_counter
-- Project    : fpga_synth
-------------------------------------------------------------------------------
-- File       : bit_counter.vhd
-- Author     : Heinzen
-- Company    : 
-- Created    : 2019-03-28
-- Last update: 2019-03-29
-- Platform   : Windows 10
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: bit counter to drive I2S decoder
-------------------------------------------------------------------------------
-- Copyright (c) 2019
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  	Description
-- 2019-03-28  1.0      Heinzen 	created
-- 2019-03-29  1.0		Heinzen	added comments
									
-------------------------------------------------------------------------------

-- Library & Use Statements
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


-- Entity Declaration 
-------------------------------------------
ENTITY bit_counter IS
  PORT( clk_12m, bclk, reset_n, init_i	: IN    std_logic;
    	  bit_count     				: OUT   std_logic_vector(6 downto 0)
    	);
END bit_counter;

-- Architecture Declaration?
-------------------------------------------
ARCHITECTURE rtl OF bit_counter IS
-- Signals & Constants Declaration?
-------------------------------------------
signal count, next_count: unsigned(6 downto 0);	  -- 7 bit to count from 0 to 127 

-- Begin Architecture
-------------------------------------------
BEGIN

  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  comb_logic: PROCESS(bclk, count)
  BEGIN	
	IF init_i = '1' THEN
		count <= to_unsigned(0,7); -- reset counter to 0
	ELSIF bclk = '1' THEN
		next_count <= count + 1; 	-- increment 1 if baud clock is high
	ELSE
		next_count <= count; 			-- idle / freeze (default) 
	END IF;	

  END PROCESS comb_logic;   
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : PROCESS(clk_12m, reset_n)
  BEGIN	
  	IF reset_n = '0' THEN
		count <= to_unsigned(0,7);			-- start counting from 0 
    ELSIF rising_edge(clk_12m) THEN
		count <= next_count;
    END IF;
  END PROCESS flip_flops;		
	
  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
	bit_count <= std_logic_vector(count); --type conversion for output
  
  
 -- End Architecture 
------------------------------------------- 
END rtl;

