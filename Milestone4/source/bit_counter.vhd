-------------------------------------------------------------------------------
-- Title      : bit_counter
-- Project    : fpga_synth
-------------------------------------------------------------------------------
-- File       : bit_counter.vhd
-- Author     : Heinzen
-- Company    : 
-- Created    : 2019-03-28
-- Last update: 2019-05-18
-- Platform   : Windows 10
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: bit counter to drive I2S decoder
-------------------------------------------------------------------------------
-- Copyright (c) 2019
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2019-03-28  1.0      Heinzen         created
-- 2019-03-29  1.0      Heinzen         added comments
-- 18.05.2019  1.1      Rutishauser     Debugging
-------------------------------------------------------------------------------

-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Entity Declaration 
-------------------------------------------
entity bit_counter is
  port(clk_12m, bclk, reset_n, init_n : in  std_logic;
       bit_count                      : out integer range 0 to 127
       );
end bit_counter;

-- Architecture Declaration?
-------------------------------------------
architecture rtl of bit_counter is
-- Signals & Constants Declaration?
-------------------------------------------
  signal count, next_count : integer range 0 to 127;  -- 7 bit to count from 0 to 127 

-- Begin Architecture
-------------------------------------------
begin


  comb_logic : process(all)
  begin

    --default statement
    next_count <= count;

    if init_n = '0' then
      next_count <= 0;       -- reset counter to 0
    elsif bclk = '1' then
		if count < 127 then
			next_count <= count + 1;          -- increment 1 if baud clock is high
		else 
			next_count <= 0;
		end if; 
    end if;

  end process comb_logic;

  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : process(all)
  begin
    if reset_n = '0' then
      count <= 0;       -- start counting from 0 
    elsif rising_edge(clk_12m) then
      count <= next_count;
    end if;
  end process flip_flops;

  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  bit_count <= count;  --type conversion for output


-- End Architecture 
------------------------------------------- 
end rtl;

