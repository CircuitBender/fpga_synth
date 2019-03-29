-------------------------------------------------------------------------------
-- Title      : I2S_Decoder
-- Project    : fpga_synth
-------------------------------------------------------------------------------
-- File       : i2s_decoder.vhd
-- Author     : Heinzen
-- Company    : 
-- Created    : 2019-03-23
-- Last update: 2019-03-28
-- Platform   : Windows 10
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Controls load and shift event of following P2S and S2P blocks
-------------------------------------------------------------------------------
-- Copyright (c) 2019
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-03-23  1.0      Heinzen created
-- 2019-03-26   1.1             Heinzen changed shift direction 
-- 2019-06-28   1.1             Heinzen added comments
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
entity i2s_decoder is
  port(bit_count                  : in  std_logic_vector(6 downto 0);
       load, shift_l, shift_r, ws : out std_logic
       );
end i2s_decoder;


-------------------------------------------
-- Architecture Declaration 
-------------------------------------------
architecture rtl of i2s_decoder is

-------------------------------------------
-- Signals & Constants Declaration 
-------------------------------------------

begin
--------------------------------------------------
-- COMBINATORIAL LOGIC FOR OUTPUT
--------------------------------------------------

  comb_out : process(bit_count)
  begin
    -- default statements
    load    <= '0';
    shift_l <= '0';
    shift_r <= '0';

    -- load condition when bit_count is zero
    if (bit_count = "0000000") then
      load <= '1';
    elsif (unsigned(bit_count) < 17) then  -- when bit counter in range 0..16: shift left should be active
      shift_l <= '1';
    elsif (unsigned(bit_count) > 64) and (unsigned(bit_count) < 81) then  --when bit counter in range 65..80: shift right should be active
      shift_r <= '1';
    end if;

    ws <= bit_count(6);                 -- take MSB of bit_counter as ws
  end process comb_out;



end architecture;

