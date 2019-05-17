-------------------------------------------------------------------------------
-- Title      : synthi_top
-- Project    : 
-------------------------------------------------------------------------------
-- File       : top.vhd
-- Author     : Schawan / Heinzen
-- Company    : 
-- Created    : 2019-03-08
-- Last update: 2019-05-03
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
-- 2019-03-08  1.1      Heinzen   Milestone 3 added
-------------------------------------------------------------------------------
-- Libraries
-------------------------------------------------------------------------------
library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.reg_table_pkg.all;
use work.tone_gen_pkg.all;              -- package tone_gen_pkg.vhd

-------------------------------------------------------------------------------
-- entity declarations
-------------------------------------------------------------------------------
entity synthi_top is
  port (
    -- Infrastructure --
    CLOCK_50 : in  std_logic;
    GPIO_26  : in  std_logic;
    KEY      : in  std_logic_vector (3 downto 0);
    SW       : in  std_logic_vector (17 downto 0);
    AUD_XCK  : out std_logic;

    AUD_ADCDAT  : in    std_logic;
    I2C_SCLK    : out   std_logic;
    I2C_SDAT    : inout std_logic;
    AUD_DACDAT  : out   std_logic;
    AUD_BCLK    : out   std_logic;
    AUD_DACLRCK : out   std_logic;
    AUD_ADCLRCK : out   std_logic
    );
end entity synthi_top;

-------------------------------------------------------------------------------
-- architecture declaration
-------------------------------------------------------------------------------
architecture rtl of synthi_top is

-----------------------------------------------------------------------------
  -- Internal signal declarations
-----------------------------------------------------------------------------

  -- output infrastructure --
  signal clk_12m_sync     : std_logic;
  signal key_sync_sig     : std_logic_vector (3 downto 0);
  signal sw_sync_sig      : std_logic_vector (17 downto 0);
  signal gpio_26_sync_sig : std_logic;
  
-- reset signal
  signal reset_n         : std_logic;

  -- signals between codec_controller and i2c_master
  signal write_sync      : std_logic;
  signal write_data_sync : std_logic_vector (15 downto 0);
  signal ack_error_sync  : std_logic;
  signal write_done_sync : std_logic;
  -- signal between codec_controlle amd i2s
  signal mute_sig        : std_logic; 
  signal load_sig        : std_logic;
  signal adcdat_pl_o     : std_logic_vector(15 downto 0);
  signal adcdat_pr_o     : std_logic_vector(15 downto 0);
  signal dacdat_pl_i     : std_logic_vector(15 downto 0);
  signal dacdat_pr_i     : std_logic_vector(15 downto 0);
  signal dacdat_s_o      : std_logic;
  signal bclk_o          : std_logic;
  signal ws_sig          : std_logic;
  signal adcdat_s_i      : std_logic;
  

-- dds
  signal dds_sig        : std_logic_vector(15 downto 0);

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
      event_ctrl_i : in  std_logic_vector(2 downto 0);
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

  component i2s_master is
    port (
      clk_12m     : in  std_logic;
      reset_n     : in  std_logic;
      load_o      : out std_logic;
      adcdat_pl_o : out std_logic_vector(15 downto 0);
      adcdat_pr_o : out std_logic_vector(15 downto 0);
      dacdat_pl_i : in  std_logic_vector(15 downto 0);
      dacdat_pr_i : in  std_logic_vector(15 downto 0);
      dacdat_s_o  : out std_logic;
      bclk_o      : out std_logic;
      ws_o        : out std_logic;
      adcdat_s_i  : in  std_logic);
  end component i2s_master;

  component path_control is
    port (
      sw_sync_3   : in  std_logic;      -- path selection
      -- Audio data generated inside FPGA
      dds_l_i     : in  std_logic_vector(15 downto 0);  --Input from synthesizer
      dds_r_i     : in  std_logic_vector(15 downto 0);
      -- Audio data coming from codec
      adcdat_pl_i : in  std_logic_vector(15 downto 0);  --Input  i2s_master
      adcdat_pr_i : in  std_logic_vector(15 downto 0);
      -- Audio data towards codec
      dacdat_pl_o : out std_logic_vector(15 downto 0);  --Output zum i2s_master
      dacdat_pr_o : out std_logic_vector(15 downto 0));
  end component path_control;

  

  component tone_generator is
    port (
	  clk_12m      : in  std_logic;
	  reset_n      : in  std_logic;
      note_vector : in  std_logic_vector (6 downto 0);
      --attenu_i    : in  std_logic_vector (3 downto 0);
      load_i      : in  std_logic;
      dds_o       : out std_logic_vector(N_AUDIO -1 downto 0));
  end component tone_generator;

begin  -- architecture rtl
-----------------------------------------------------------------------------
  -- Component instantiations
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
  -- Milestone 1
-----------------------------------------------------------------------------

  -- instance "infrastructure_1"
  infrastructure_1 : infrastructure
    port map (
      CLOCK_50     => CLOCK_50,
      GPIO_26      => GPIO_26,
      KEY          => KEY,
      SW           => SW,
      key_sync     => key_sync_sig,
      sw_sync      => sw_sync_sig,
      gpio_26_sync => gpio_26_sync_sig,
      clk_12m      => clk_12m_sync,
      reset_n      => reset_n);

  -- instance "codec_controller_1"
  codec_controller_1 : codec_controller
    port map (
      clk          => clk_12m_sync,
      reset_n      => reset_n,
      event_ctrl_i => sw_sync_sig(2 downto 0),
      initialize_i => key_sync_sig(1),
      write_done_i => write_done_sync,
      ack_error_i  => ack_error_sync,
      write_data_o => write_data_sync,
      write_o      => write_sync,
      mute_o       => mute_sig);

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
  -- Milestone 2
-----------------------------------------------------------------------------
  -- instance "i2s_master_1"
  i2s_master_1 : i2s_master
    port map (
      clk_12m     => clk_12m_sync,
      reset_n     => reset_n,
      load_o      => load_sig,
      adcdat_pl_o => adcdat_pl_o,
      adcdat_pr_o => adcdat_pr_o,
      dacdat_pl_i => dacdat_pl_i,
      dacdat_pr_i => dacdat_pr_i,
      dacdat_s_o  => AUD_DACDAT,
      bclk_o      => AUD_BCLK,
      ws_o        => ws_sig,
      adcdat_s_i  => AUD_ADCDAT);

  -- instance "path_control_1"
  path_control_1 : path_control
    port map (
      sw_sync_3   => sw_sync_sig(3),
      dds_l_i     => dds_sig,
      dds_r_i     => dds_sig,
      adcdat_pl_i => adcdat_pl_o,
      adcdat_pr_i => adcdat_pr_o,
      dacdat_pl_o => dacdat_pl_i,
      dacdat_pr_o => dacdat_pr_i
      );
	

  tone_generator_1 : tone_generator
    port map (
      note_vector => "0001011",
      --attenu_i    => attenu_i,
      load_i      => load_sig,
      clk_12m     => clk_12m_sync,
      reset_n     => reset_n,
      dds_o       => dds_sig);

------------------------------------
-- concurrent assignments
------------------------------------       
 
  	AUD_XCK <=  clk_12m_sync;
	AUD_DACLRCK <= ws_sig;
	AUD_ADCLRCK <= ws_sig;

end architecture rtl;

-------------------------------------------------------------------------------