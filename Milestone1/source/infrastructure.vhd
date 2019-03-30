-------------------------------------------------------------------------------
-- Title      : infrastructure
-- Project    : 
-------------------------------------------------------------------------------
-- File       : infrastructure.vhd
-- Author     : Schawan Schirwan / Heinzen
-- Company    : 
-- Created    : 2018-03-09
-- Last update: 2018-03-13
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: syncronises input signals
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-03-09  1.0      Schawan        Created
-- 2019-03-15	1.1		Heinzen			Debugging
-- 2019-03-22	1.1		Heinzen			added Comments
-------------------------------------------------------------------------------
-- Libraries
-------------------------------------------------------------------------------
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------
-- entity declaration
-------------------------------------------------------------------------------
entity infrastructure is

  port (
    CLOCK_50     : in  std_logic;
    GPIO_26      : in  std_logic;
    KEY          : in  std_logic_vector (3 downto 0);
    SW           : in  std_logic_vector (17 downto 0);
    key_sync     : out std_logic_vector (3 downto 0);
    sw_sync      : out std_logic_vector (17 downto 0);
    gpio_26_sync : out std_logic;
    clk_12m      : out std_logic;
    reset_n      : out std_logic
    );

end entity infrastructure;

-------------------------------------------------------------------------------

architecture str of infrastructure is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  
  signal reset_n_temp : std_logic;
  signal  clk_12m_int : std_logic;
  
  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------

  component synchronize is
    generic (
      width : positive);
    port (
      signal_i : in  std_logic_vector(width-1 downto 0);
      clk_12m  : in  std_logic;
      signal_o : out std_logic_vector(width-1 downto 0));
  end component synchronize;

  component modulo_divider is
    generic (width : positive);
    port (
      clk, reset_n : in  std_logic;
      clk_12m      : out std_logic);
  end component modulo_divider;


begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- instance "synchronize_1"
  synchronize_1 : synchronize
    generic map (
      width => 4)
    port map (
      signal_i => KEY,
      clk_12m  =>  clk_12m_int,
      signal_o => key_sync);

  -- instance "synchronize_2"
  synchronize_2 : synchronize
    generic map (
      width => 18)
    port map (
      signal_i => SW,
      clk_12m  =>  clk_12m_int,
      signal_o => sw_sync);

  -- instance "synchronize_3"
  synchronize_3 : synchronize
    generic map (
      width => 1)
    port map (
      signal_i(0) => GPIO_26,
      clk_12m  =>  clk_12m_int,
      signal_o(0) => gpio_26_sync);

    -- instance "modulo_divider_1"
    modulo_divider_1 : modulo_divider
    generic map (
      width => 2)
    port map (
      clk     => CLOCK_50,
      reset_n => '1',
      clk_12m =>  clk_12m_int);
	  
----------------------------------------------------------------------
-- concurrent assignments
----------------------------------------------------------------------
-- output

  reset_n_temp <= key_sync(0);
  reset_n <= reset_n_temp;
  clk_12m <= clk_12m_int;

end architecture str;

-------------------------------------------------------------------------------
