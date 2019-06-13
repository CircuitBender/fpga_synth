-------------------------------------------------------------------------------
-- File       : shiftreg_s2p.vhd
-- Authors    : dqtm
-- Created    : 12.11.12
-------------------------------------------------------------------------------
-- Description: transforms serial_input to parallel_output
-------------------------------------------------------------------------------
-- History    :
-- Date         Author     Description
-- 03.03.2019   rutiscla	created
-------------------------------------------------------------------------------


-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Entity Declaration 
-------------------------------------------
entity shiftreg_s2p is
  generic(width: positive := 16);
  port(
    clk_12m : in  std_logic;                          -- Clock 12.5 MHz
    reset_n : in  std_logic;                          -- Reset
    enable  : in  std_logic;                          -- shift_enable from bitclock
    shift   : in  std_logic;                          -- shift_enable from i2s_decoder
    ser_in  : in  std_logic;                          -- serial input
    dir     : in  std_logic;                          -- shift direction (1 = to MSB, 0 = to LSB)
    par_out : out std_logic_vector(width-1 downto 0)  -- parallel output
  );
end shiftreg_s2p;


-- Architecture Declaration?
-------------------------------------------
architecture rtl of shiftreg_s2p is
-- Signals & Constants Declaration
-------------------------------------------
  signal shiftreg      : std_logic_vector(width-1 downto 0);
  signal next_shiftreg : std_logic_vector(width-1 downto 0);

-- Begin Architecture
-------------------------------------------
begin
  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  logic : process (all)
  begin
    if (enable = '0') and (shift = '1') then  -- shift if bit_clk is '0' (delay of codec) and shift_l/r = '1'
      if dir = '1' then
        next_shiftreg <= shiftreg(width-2 downto 0) & ser_in; -- shift to MSB
      else
        next_shiftreg <= ser_in & shiftreg(width-1 downto 1); -- shift to LSB
      end if ;
    else
      next_shiftreg <= shiftreg;
    end if;
  end process logic;

  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : process (all)
  begin
    if reset_n = '0' then
      shiftreg <= (others => '0');
    elsif rising_edge (clk_12m) then
      shiftreg <= next_shiftreg;
    end if;
  end process flip_flops;

  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  out_logic : process(all)
  begin
    if shift = '0' then
      par_out <= shiftreg;  --give out parallel_out if shift is complete (shift_l/r = '0')
    else
      par_out <= (others => '0');    --if shift is '1' parallel_out is 0
    end if;

  end process;
-- End Architecture 
------------------------------------------- 
end rtl;
