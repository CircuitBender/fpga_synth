-------------------------------------------------------------------------------
-- File       : shiftreg_p2s.vhd
-- Authors    : Rutishasuer
-- Created    : 12.11.12
-------------------------------------------------------------------------------
-- Description: transforms parallel_input to serial_output
-------------------------------------------------------------------------------
-- History    :
-- Date       Author    Description
-- 14.03.19   Rutishasuer      1st version
-- 07.04.19   Rutishasuer  Added generic
-- 22.05.19	  Heinzen		debugging, nomenclatura
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
entity shiftreg_p2s is
  generic(width: positive := 16);

  port(clk_i : in  std_logic;         --12.5 MHz Clock
       reset_n_i: in  std_logic;         --Reset
       load_i    : in  std_logic;         --load enable
       shift_i   : in  std_logic;         --shift-signal from i2s decoder
       enable_i  : in  std_logic;         --shift_enable
       par_in  : in  std_logic_vector(width-1 downto 0);  --parallel input dacdat
       ser_out : out std_logic          --serial output
       );
end shiftreg_p2s;

-------------------------------------------
-- Architecture Declaration
-------------------------------------------
architecture rtl of shiftreg_p2s is

-------------------------------------------
-- Signals & Constants Declaration?
-------------------------------------------
  signal shiftreg      : std_logic_vector(width-1 downto 0);
  signal next_shiftreg : std_logic_vector(width-1 downto 0);
  signal zeroes        : std_logic;

-------------------------------------------
-- Begin Architecture
-------------------------------------------  
begin
	-------------------------------------------
	-- default statements
	-------------------------------------------
  zeroes <= '0';
  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  logic : process (all)
  begin
    if load_i = '1' then                  --load input to shiftreg
      next_shiftreg <= par_in;
    elsif shift_i = '1' and enable_i = '1' then  --shift if bit_clk and shift_l/r '1'
      next_shiftreg <= shiftreg(14 downto 0) & zeroes;  --shift to MSB (put in '0' to LSB)
    else next_shiftreg <= shiftreg;
    end if;
  end process logic;

  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : process (all)
  begin
    if reset_n_i = '0' then
      shiftreg <= (others => '0');
    elsif rising_edge (clk_i) then
      shiftreg <= next_shiftreg;
    end if;
  end process flip_flops;

  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  -- take MSB and convert for output data-type
  ser_out <= shiftreg(width-1);


-- End Architecture 
-------------------------------------------

 
end architecture rtl;
