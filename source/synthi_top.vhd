-------------------------------------------------------------------------------
-- Title      : synthi_top
-- Project    : 
-------------------------------------------------------------------------------
-- File       : synthi_top.vhd
-- Author     :   <Hans-Joachim@GELKE-LENOVO>
-- Company    : 
-- Created    : 2018-03-08
-- Last update: 2019-03-13
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Top Level for Synthesizer
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2018-03-08  1.0      Hans-Joachim    Created
-- 2019-03-04  1.1      Hans-Joachim    Changed KEY from vectored to single
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library work;
use ieee.numeric_std.all;
use work.reg_table_pkg.all;

-------------------------------------------------------------------------------

entity synthi_top is

  port (
    CLOCK_50 : in std_logic;            -- DE2 clock from xtal 50MHz
    KEY_0    : in std_logic;            -- DE2 low_active input buttons
    KEY_1    : in std_logic;            -- DE2 low_active input buttons
    KEY_2    : in std_logic;            -- DE2 low_active input buttons
    KEY_3    : in std_logic;            -- DE2 low_active input buttons
    SW       : in std_logic_vector(17 downto 0);  -- DE2 input switches

    GPIO_26 : in std_logic;             -- midi_uart serial_input

    AUD_XCK     : out std_logic;        -- master clock for Audio Codec
    AUD_DACDAT  : out std_logic;        -- audio serial data to Codec-DAC
    AUD_BCLK    : out std_logic;        -- bit clock for audio serial data
    AUD_DACLRCK : out std_logic;        -- left/right word select for Codec-DAC
    AUD_ADCLRCK : out std_logic;        -- left/right word select for Codec-ADC
    AUD_ADCDAT  : in  std_logic;        -- audio serial data from Codec-ADC

    I2C_SCLK : out   std_logic;         -- clock from I2C master block
    I2C_SDAT : inout std_logic          -- data  from I2C master block
    );

end entity synthi_top;


-------------------------------------------------------------------------------

architecture struct of synthi_top is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  signal reset_n: std_logic;
  signal sw_syncro: std_logic_vector (17 downto 0);
  signal key_1_sync:std_logic;
  signal write_done:std_logic;
  signal  write_data:std_logic_vector (15 downto 0);
signal    write_c:std_logic;
signal    ack_error:std_logic;
signal mute:std_logic;
signal gpio_26_sync:std_logic; 
signal clk_12m_int:std_logic;
  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------

  component infrastructure is
    port (
      CLOCK_50     : in  std_logic;
      KEY_0        : in  std_logic;
      KEY_1        : in  std_logic;
      SW           : in  std_logic_vector(17 downto 0);
      GPIO_26      : in  std_logic;
      clk_12m	  : out std_logic;
      reset_n      : out std_logic;
      key_1_sync   : out std_logic;
      sw_sync      : out std_logic_vector (17 downto 0);
      gpio_26_sync : out std_logic);
  end component infrastructure;

  component codec_controller is
    port (
      sw_sync_i    : in  std_logic_vector(2 downto 0);
      initialize_i : in  std_logic;
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
  
begin

  -- instance "infrastructure_1"
  infrastructure_1: infrastructure
    port map (
      CLOCK_50     => CLOCK_50,
      KEY_0        => KEY_0,
      KEY_1        => KEY_1,
      SW           => SW,
      GPIO_26      => GPIO_26,
      clk_12m	  => AUD_XCK,
      reset_n      => reset_n,
      key_1_sync   => key_1_sync,
      sw_sync      => sw_syncro,
      gpio_26_sync => gpio_26_sync);

  -- instance "codec_controller_1"
  codec_controller_1: codec_controller
    port map (
      sw_sync_i    => sw_syncro(2 downto 0),
      initialize_i => key_1_sync,
      write_done_i => write_done,
      ack_error_i  => ack_error,
      write_data_o => write_data,
      write_o      => write_c,
		mute_o       => mute);

  -- instance "i2c_master_1"
  i2c_master_1: i2c_master
    port map (
      clk          => clk_12m_int,
      reset_n      => reset_n,   
      write_i      => write_c,
      write_data_i => write_data,
      sda_io       => I2C_SDAT,
      scl_o        => I2C_SCLK,
      write_done_o => write_done,
      ack_error_o  => ack_error);

end architecture struct;

-------------------------------------------------------------------------------
