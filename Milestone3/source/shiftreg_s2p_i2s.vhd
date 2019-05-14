-------------------------------------------------------------------------------
-- Title      : Shiftregister serial to parallel
-- Project    : syntProject_group10
-------------------------------------------------------------------------------
-- File       : shiftreg_s2p_i2s.vhd
-- Author     : Rutishauser, Heinzen
-- Company    : 
-- Created    : 2019-03-28
-- Last update: 2019-05-09
-- Platform   : Windows 10
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Shiftregister to shift audio data 
-------------------------------------------------------------------------------
-- Copyright (c) 2019
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  	Description
-- 2019-03-01  1.0      Rutishauser		Created
-- 2018-05-09  1.1		Heinzen		debugging, commentary, added else statement as default statement

-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity shiftreg_s2p_i2s is
  port (
    clk      : in  std_logic;
    reset_n  : in  std_logic;
    enable_i : in  std_logic;           --BCLK
    ser_i    : in  std_logic;
--	load_i    : in std_logic;
    shift_i  : in  std_logic;           --Shift l/r
    par_o    : out std_logic_vector(15 downto 0)
	);
end shiftreg_s2p_i2s;

-- Architecture Declaration 
architecture rtl of shiftreg_s2p_i2s is

  -- Signals & Constants Declaration 
  signal shiftreg, next_shiftreg : std_logic_vector (15 downto 0);
  signal enable        : std_logic;

-- Begin Architecture
begin

  enable_logic : process(all)
  begin
		enable <= '0'; -- default statement instead of else
    if enable_i = '0' and shift_i = '1' then
      enable <= '1';
    end if;

  end process enable_logic;
  --------------------------------------------------
  -- PROCESS FOR COMB-INPUT LOGIC
  --------------------------------------------------
  comblogic : process(all)
    begin
    if enable = '1' then
      next_shiftreg (15 downto 0) <= shiftreg(14 downto 0) & ser_i;
	else
      next_shiftreg <= shiftreg;
    end if;
  end process comblogic;

  --------------------------------------------------
  -- PROCESS FOR FLIP FLOPS
  --------------------------------------------------
 flipflops : process(all) -- process hatte keinen Namen
  begin
    if reset_n = '0' then
      shiftreg <= (others => '0');
    elsif rising_edge(clk) then
      shiftreg <= next_shiftreg;
    end if;
  end process flipflops; -- process hatte keinen Namen

--concurrent Statement
  par_o <= shiftreg;

end rtl;
