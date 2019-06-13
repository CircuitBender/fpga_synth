-------------------------------------------------------------------------------
-- Title      : synchronize
-- Project    : fpga_synth
-------------------------------------------------------------------------------
-- File       : synchronize.vhd
-- Author     : Gelke
-- Company    : ZHAW
-- Created    : 2018-03-08
-- Last update: 2019-05-22
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Scalable synchronization FFs
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2018-03-08  1.0      Hans-Joachim    Created
-- 2019-05-22  1.1      Heinzen    		debugging, nomenclatura

-------------------------------------------------------------------------------

--------------------------------
-- Libraries
--------------------------------
library ieee;
use ieee.std_logic_1164.all;

--------------------------------
-- entity declaration
--------------------------------
entity synchronize is
generic (
  width : positive := 10
  );
  
  port (
    signal_i : in  std_logic_vector(width-1 downto 0);
    clk_i  : in  std_logic;
    signal_o : out std_logic_vector(width-1 downto 0)
    );
end entity synchronize;

--------------------------------
-- architecture declaration
--------------------------------
architecture rtl of synchronize is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  signal tmp_signal : std_logic_vector(width-1 downto 0);

begin  -- architecture rtl

-------------------------------
-- flip flops
--------------------------------
  flipflops : process(clk_i)
  begin
    if(rising_edge(clk_i)) then
      tmp_signal <= signal_i;
      signal_o   <= tmp_signal;
    end if;
  end process flipflops;

end architecture rtl;
-- end
--------------------------------