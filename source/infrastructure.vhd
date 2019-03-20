-------------------------------------------------------------------------------
-- Title      : 
-- Project    : 
-------------------------------------------------------------------------------
-- File       : infrastructure.vhd
-- Author     :   <Schawan@LAPTOP-PV1H37B3>
-- Company    : 
-- Created    : 2019-03-13
-- Last update: 2019-03-13
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-03-13  1.0      Schawan	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity infrastructure is
  port(
  CLOCK_50:in std_logic;
  KEY_0:in std_logic;
  KEY_1: in std_logic;
  SW:in std_logic_vector(17 downto 0);
  GPIO_26:in std_logic;
  clk_12m: out std_logic;
  reset_n:out std_logic;
  key_1_sync: out std_logic;
  sw_sync: out std_logic_vector (17 downto 0);
  gpio_26_sync: out std_logic
    );

end entity infrastructure;

-------------------------------------------------------------------------------

architecture str of infrastructure is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
signal clk_12m_int:std_logic;

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
  
    component synchronize_single is
    port (
      signal_i : in  std_logic;
      clk_12m  : in  std_logic;
      signal_o : out std_logic);
  end component synchronize_single;

  component modulo_divider is
    generic (
      width : positive);
    port (
      clk, reset_n : in  std_logic;
      clk_12m      : out std_logic);
  end component modulo_divider;

begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- instance "synchronize_1"
  synchronize_1: synchronize_single

    port map (
      signal_i => KEY_1,
      clk_12m  => clk_12m_int,
      signal_o => key_1_sync);

  -- instance "synchronize_2"
  synchronize_2: synchronize
    generic map (
      width => 18)
    port map (
      signal_i => SW,
      clk_12m  => clk_12m_int,
      signal_o => sw_sync);

  -- instance "synchronize_3"
  synchronize_3: synchronize_single
    port map (
      signal_i => GPIO_26,
      clk_12m  => clk_12m_int,
      signal_o => gpio_26_sync);

  -- instance "modulo_divider_1"
  modulo_divider_1: modulo_divider
    generic map (
      width => 2)
    port map (
      clk     => CLOCK_50,
     reset_n => '1',
      clk_12m => clk_12m_int);

  -- instance "synchronize_4"
  synchronize_4: synchronize_single
    port map (
      signal_i => KEY_0,
      clk_12m  => clk_12m_int,
      signal_o => reset_n);
  

end architecture str;

-------------------------------------------------------------------------------
