-------------------------------------------------------------------------------
-- Title      : I2S_Decoder
-- Project    : fpga_synth
-------------------------------------------------------------------------------
-- File       : i2s_decoder.vhd
-- Author     : Heinzen
-- Company    : 
-- Created    : 2019-03-23
-- Last update: 2019-05-18
-- Platform   : Windows 10
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Controls load and shift event of following P2S and S2P blocks
-------------------------------------------------------------------------------
-- Copyright (c) 2019
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2019-03-23  1.0      Heinzen         created
-- 2019-03-26  1.1      Heinzen         changed shift direction 
-- 2019-04-28  1.1      Heinzen         added comments
-- 18.05.2019  1.2      Rutishauser     Debugging
-- 2019-05-28  1.1      Heinzen         nomenclatura

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

  port(bit_count_i               : in  integer range 0 to 127;
       load_o, shift_l_o, shift_r_o, ws_o : out std_logic
       );
end entity i2s_decoder;


-------------------------------------------
-- Architecture Declaration 
-------------------------------------------
architecture rtl of i2s_decoder is

begin
--------------------------------------------------
-- COMBINATORIAL LOGIC FOR OUTPUT
--------------------------------------------------

  comb_out : process(all)
  begin
    -- default statements
    load_o    <= '0';
    shift_l_o <= '0';
    shift_r_o <= '0';

    -- load condition when bit_count is zero
    if (bit_count_i = 0) then
      load_o <= '1';
    elsif (bit_count_i < 17) then  -- when bit counter in range 0..16: shift left should be active
      shift_l_o <= '1';
    elsif (bit_count_i > 64) and (bit_count_i < 81) then  --when bit counter in range 65..80: shift right should be active
      shift_r_o <= '1';
    end if;

    -- generating ws signal 
	 if bit_count_i < 64 then ws_o <= '0';
	 else ws_o <= '1';
	 end if;
  end process comb_out;

end architecture;
-- end
----------------------------------------
