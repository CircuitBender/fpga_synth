-- Title      : synchronize
-- Project    : Synthesizer
-------------------------------------------------------------------------------
-- File       : synchronize.vhd
-- Author     : Heinzen
-- Company    : 
-- Created    : 2018-03-09
-- Last update: 2019-03-22
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: synchronizes for input signals with internal clock
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2018-03-09  1.0      Heinzen        Created
-- 2018-06-13  1.0			abeggmir			  add comments
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity sync is

  generic (width : positive );
  port (
    signal_i : in  std_logic_vector(width-1 downto 0);
    clock_i  : in  std_logic;
    signal_o : out std_logic_vector(width-1 downto 0) );
  
end entity sync;

-------------------------------------------------------------------------------

architecture rtl of sync is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  --signal tmp_signal : std_logic_vector(width-1 downto 0); -- temporary storage of input signal signal_i

begin  -- architecture rtl

  flipflops : process(all)
  begin
    if(rising_edge(clock_i)) then
      signal_o <= signal_i;			-- implement 2 flip flops with tmp signal
     
    end if;
  end process flipflops;

end architecture rtl;

-------------------------------------------------------------------------------
