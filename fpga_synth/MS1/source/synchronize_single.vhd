-------------------------------------------------------------------------------
-- Title      : synchronize
-- Project    : 
-------------------------------------------------------------------------------
-- File       : synchronize.vhd<MS_stud>
-- Author     :   <Hans-Joachim@GELKE-LENOVO>
-- Company    : 
-- Created    : 2018-03-08
-- Last update: 2018-03-09
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Scalable synchronization FFs
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2018-03-08  1.0      Hans-Joachim    Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity synchronize_single is
generic (
  width : positive := 10
  );
  
  port (
    signal_i : in  std_logic;
    clk_12m  : in  std_logic;
    signal_o : out std_logic
    );

end entity synchronize_single;

-------------------------------------------------------------------------------

architecture rtl of synchronize_single is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  signal tmp_signal : std_logic;

begin  -- architecture rtl

  flipflops : process(clk_12m)
  begin
    if(rising_edge(clk_12m)) then
      tmp_signal <= signal_i;
      signal_o   <= tmp_signal;
    end if;
  end process flipflops;

end architecture rtl;

-------------------------------------------------------------------------------
