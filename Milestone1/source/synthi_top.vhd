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
    CLOCK_50 : in std_logic;            -- DE2 clock from xtal 50MHz
 --   KEY_0    : in std_logic;            -- DE2 low_active input buttons
--    KEY_1    : in std_logic;            -- DE2 low_active input buttons
--    KEY_2    : in std_logic;            -- DE2 low_active input buttons
--    KEY_3    : in std_logic;            -- DE2 low_active input buttons
KEY          : in  std_logic_vector (3 downto 0);  -- DE2 low_active input buttons
      
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
-- architecture declaration
-------------------------------------------------------------------------------
architecture rtl of synthi_top is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal clk_12m_sig : std_logic;
  signal reset_n_sig : std_logic;

  -- output infrastructure --
  signal clk_12m_sync_sig   : std_logic;
  signal key_sync_sig     : std_logic_vector (3 downto 0);
  signal sw_sync_sig      : std_logic_vector (17 downto 0);
  signal gpio_26_sync_sig : std_logic;

  -- signals between codec_controller and i2c_master
  signal write_sync_sig      : std_logic;
  signal write_data_sync_sig : std_logic_vector (15 downto 0);
  signal ack_error_sync_sig  : std_logic;
  signal write_done_sync_sig : std_logic;
  -- signal between codec_controller amd i2s
  signal mute_o_sig : std_logic;
  
  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------

  component infrastructure is
    port (
      CLOCK_50     : in  std_logic;
      GPIO_26      : in  std_logic;
      KEY          : in  std_logic_vector (3 downto 0);
      SW           : in  std_logic_vector (17 downto 0);
      key_sync_o     : out std_logic_vector (3 downto 0);
      sw_sync_o      : out std_logic_vector (17 downto 0);
      gpio_26_sync_o : out std_logic;
      clk_12m_o      : out std_logic;
      reset_n_o      : out std_logic);
  end component infrastructure;

  component codec_controller is
    port (
      clk_12m_i, reset_n_i : in  std_logic;
      sw_sync_i   : in  std_logic_vector(2 downto 0);
      initialize_i   : in  std_logic;
      write_done_i : in  std_logic;
      ack_error_i  : in  std_logic;
      write_data_o : out std_logic_vector(15 downto 0);
      write_o      : out std_logic;
      mute_o       : out std_logic);
  end component codec_controller;

  component i2c_master is
    port (
      clk_i          : in    std_logic;
      reset_n_i      : in    std_logic;
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
      key_sync_o     => key_sync_sig,
      sw_sync_o      => sw_sync_sig,
      gpio_26_sync_o => gpio_26_sync_sig,
      clk_12m_o     => clk_12m_sync_sig,
      reset_n_o     => reset_n_sig);

  -- instance "codec_controller_1"
  codec_controller_1 : codec_controller
    port map (
      clk_12m_i          => clk_12m_sync_sig,
      reset_n_i      => reset_n_sig,
      sw_sync_i   => sw_sync_sig(2 downto 0),
      initialize_i   => key_sync_sig(1),
      write_done_i => write_done_sync_sig,
      ack_error_i  => ack_error_sync_sig,
      write_data_o => write_data_sync_sig,
      write_o      => write_sync_sig,
      mute_o       => mute_o_sig);

  -- instance "i2c_master_1"
  i2c_master_1 : i2c_master
    port map (
      clk_i          => clk_12m_sync_sig, -- im i2c_master code steht zwar input 50mhz ?? es entsteht ja ein clk div sig im block bzw 12.5mhz/5 != 50mhz/5
      reset_n_i      => reset_n_sig,
      write_i      => write_sync_sig,
      write_data_i => write_data_sync_sig,
      sda_io       => I2C_SDAT,
      scl_o        => I2C_SCLK,
      write_done_o => write_done_sync_sig,
      ack_error_o  => ack_error_sync_sig);

  -----------------------------------------------------------------------------
  -- concurrent assignments / output
  -----------------------------------------------------------------------------
AUD_XCK <=  clk_12m_sync_sig;


end architecture rtl;

-------------------------------------------------------------------------------
