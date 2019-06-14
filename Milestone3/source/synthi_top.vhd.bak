-------------------------------------------------------------------------------
-- Title      : synthi_top
-- Project    : 
-------------------------------------------------------------------------------
-- File       : top.vhd
-- Author     : Schawan / Heinzen
-- Company    : 
-- Created    : 2019-03-08
-- Last update: 2018-03-16
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-03-08  1.0      Schawan   Created
-- 2019-03-08  1.1      Heinzen   Debugged
-------------------------------------------------------------------------------
-- Libraries
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.reg_table_pkg.all;

-------------------------------------------------------------------------------
-- entity declarations
-------------------------------------------------------------------------------
entity synthi_top is
  port (

    -- Infrastructure --
    CLOCK_50    : in  std_logic;
    GPIO_26     : in  std_logic;
    KEY         : in  std_logic_vector (3 downto 0);
    SW          : in  std_logic_vector (17 downto 0);
    AUD_XCK     : out std_logic;
	
    AUD_ADCDAT  : in  std_logic;
    I2C_SCLK    : out std_logic;
    I2C_SDAT    : inout std_logic;
    AUD_DACDAT  : out std_logic;
    AUD_BCLK    : out std_logic;
    AUD_DACLRCK : out std_logic;
    AUD_ADCLRCK : out std_logic
    );

end entity synthi_top;

-------------------------------------------------------------------------------
-- architecture declaration
-------------------------------------------------------------------------------
architecture rtl of synthi_top is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal clk_12m : std_logic;
  signal reset_n : std_logic;

  -- output infrastructure --
  signal clk_12m_sync   : std_logic;
  signal key_sync_2     : std_logic_vector (3 downto 0);
  signal sw_sync_2      : std_logic_vector (17 downto 0);
  signal gpio_26_sync_2 : std_logic;

  -- signals between codec_controller and i2c_master
  signal write_sync      : std_logic;
  signal write_data_sync : std_logic_vector (15 downto 0);
  signal ack_error_sync  : std_logic;
  signal write_done_sync : std_logic;
  -- signal between codec_controlle amd i2s
  signal mute_o : std_logic;
  
  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------

  component infrastructure is
    port (
      CLOCK_50     : in  std_logic;
      GPIO_26      : in  std_logic;
      KEY          : in  std_logic_vector (3 downto 0);
      SW           : in  std_logic_vector (17 downto 0);
      key_sync     : out std_logic_vector (3 downto 0);
      sw_sync      : out std_logic_vector (17 downto 0);
      gpio_26_sync : out std_logic;
      clk_12m      : out std_logic;
      reset_n      : out std_logic);
  end component infrastructure;

  component codec_controller is
    port (
      clk, reset_n : in  std_logic;
      event_ctrl_i   : in  std_logic_vector(2 downto 0);
      initialize_i   : in  std_logic;
      write_done_i : in  std_logic;
      ack_error_i  : in  std_logic;
      write_data_o : out std_logic_vector(15 downto 0);
      write_o      : out std_logic;
      mute_o       : out std_logic);
  end component codec_controller;

  component i2c_master is
    port (
      clk          : in    std_logic;
      reset_n      : in    std_logic;
      write_i      : in    std_logic;
      write_data_i : in    std_logic_vector(15 downto 0);
      sda_io       : inout std_logic;
      scl_o        : out   std_logic;
      write_done_o : out   std_logic;
      ack_error_o  : out   std_logic);
  end component i2c_master;

begin  -- architecture rtl

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- instance "infrastructure_1"
  infrastructure_1 : infrastructure
    port map (
      CLOCK_50     => CLOCK_50,
      GPIO_26      => GPIO_26,
      KEY          => KEY,
      SW           => SW,
      key_sync     => key_sync_2(3 downto 0),
      sw_sync      => sw_sync_2,
      gpio_26_sync => gpio_26_sync_2,
      clk_12m      => clk_12m_sync,
      reset_n      => reset_n);

  -- instance "codec_controller_1"
  codec_controller_1 : codec_controller
    port map (
      clk          => clk_12m_sync,
      reset_n      => reset_n,
      event_ctrl_i   => sw_sync_2(2 downto 0),
      initialize_i   => key_sync_2(1),
      write_done_i => write_done_sync,
      ack_error_i  => ack_error_sync,
      write_data_o => write_data_sync,
      write_o      => write_sync,
      mute_o       => mute_o);

  -- instance "i2c_master_1"
  i2c_master_1 : i2c_master
    port map (
      clk          => clk_12m_sync,
      reset_n      => reset_n,
      write_i      => write_sync,
      write_data_i => write_data_sync,
      sda_io       => I2C_SDAT,
      scl_o        => I2C_SCLK,
      write_done_o => write_done_sync,
      ack_error_o  => ack_error_sync);

  -----------------------------------------------------------------------------
  -- concurrent assignments / output
  -----------------------------------------------------------------------------
AUD_XCK <=  clk_12m_sync;

end architecture rtl;

-------------------------------------------------------------------------------
