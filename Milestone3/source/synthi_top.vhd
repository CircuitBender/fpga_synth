-------------------------------------------------------------------------------
-- Title      : synthi_top
-- Project    : 
-------------------------------------------------------------------------------
-- File       : top.vhd
-- Author     : Schawan / Heinzen
-- Company    : 
-- Created    : 2019-03-08
-- Last update: 2019-05-19
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
-- 2019-05-22	1.2-1.5	Heinzen		Ms1-Ms3 integrated, debugged, nomenclatura
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
    CLOCK_50    : in  std_logic;
    GPIO_26     : in  std_logic;
    KEY         : in  std_logic_vector (1 downto 0);
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
  
  signal reset_n_sig : std_logic;

  -- output infrastructure --
  signal clk_12m_sync_sig   : std_logic;
  signal key_sync_sig     : std_logic;
  signal sw_sync_sig      : std_logic_vector (17 downto 0);
  signal gpio_26_sync_sig : std_logic;

  -- signals between codec_controller and i2c_master
  signal write_sync_sig      : std_logic;
  signal write_data_sync_sic : std_logic_vector (15 downto 0);
  signal ack_error_sync_sig  : std_logic;
  signal write_done_sync_sig : std_logic;
  -- signal between codec_control amd i2s
  signal mute_sig : std_logic;
  signal ws_sig : std_logic;
  -- signal between path control i2s_master
  signal adcdat_pl_o_sig : std_logic_vector (15 downto 0);
  signal adcdat_pr_o_sig : std_logic_vector (15 downto 0);
  signal dacdat_pl_i_sig : std_logic_vector (15 downto 0);
  signal dacdat_pr_i_sig : std_logic_vector (15 downto 0);
  
  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------

  component infrastructure is
    port (
      CLOCK_50     : in  std_logic;
      GPIO_26      : in  std_logic;
      KEY          : in  std_logic_vector (1 downto 0);
      SW           : in  std_logic_vector (17 downto 0);
      key_sync_o     : out std_logic;
      sw_sync_o      : out std_logic_vector (17 downto 0);
      gpio_26_sync_o : out std_logic;
      clk_12m_o      : out std_logic;
      reset_n_o      : out std_logic);
  end component infrastructure;

  component codec_controller is
    port (
      clk_i    : in std_logic;
	  reset_n_i : in  std_logic;
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

  component path_control is
    port (
      sw_i     : in  std_logic;
      --dds_l_i     : in  std_logic_vector(15 downto 0);
      --dds_r_i     : in  std_logic_vector(15 downto 0);
      adcdat_pl_i : in  std_logic_vector(15 downto 0);
      adcdat_pr_i : in  std_logic_vector(15 downto 0);
      dacdat_pl_o : out std_logic_vector(15 downto 0);
      dacdat_pr_o : out std_logic_vector(15 downto 0));
  end component path_control;

  component i2s_master is
    port (
      clk_i     : in  std_logic;
      reset_n_i     : in  std_logic;
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
      clk_12m_o      => clk_12m_sync_sig,
      reset_n_o      => reset_n_sig);

  -- instance "codec_controller_1"
  codec_controller_1 : codec_controller
    port map (
      clk_i          => clk_12m_sync_sig,
      reset_n_i     => reset_n_sig,
      sw_sync_i   => sw_sync_sig(2 downto 0),
      initialize_i   => key_sync_sig,
      write_done_i => write_done_sync_sig,
      ack_error_i  => ack_error_sync_sig,
      write_data_o => write_data_sync_sic,
      write_o      => write_sync_sig,
      mute_o       => mute_sig);

  -- instance "i2c_master_1"
  i2c_master_1 : i2c_master
    port map (
      clk_i          => clk_12m_sync_sig,
      reset_n_i      => reset_n_sig,
      write_i      => write_sync_sig,
      write_data_i => write_data_sync_sic,
      sda_io       => I2C_SDAT,
      scl_o        => I2C_SCLK,
      write_done_o => write_done_sync_sig,
      ack_error_o  => ack_error_sync_sig);

  -- instance "path_control_1"
  path_control_1: path_control
    port map (
      sw_i     => sw_sync_sig(3),
      --dds_l_i     => open,
      --dds_r_i     => open,
      adcdat_pl_i => adcdat_pl_o_sig,
      adcdat_pr_i => adcdat_pr_o_sig,
      dacdat_pl_o => dacdat_pl_i_sig,
      dacdat_pr_o => dacdat_pr_i_sig);

  -- instance "i2s_master_1"
  i2s_master_1: i2s_master
    port map (
      clk_i     => clk_12m_sync_sig,
      reset_n_i     => reset_n_sig,
      load_o      => open,
      adcdat_pl_o => adcdat_pl_o_sig,
      adcdat_pr_o => adcdat_pr_o_sig,
      dacdat_pl_i => dacdat_pl_i_sig,
      dacdat_pr_i => dacdat_pr_i_sig,
      dacdat_s_o  => AUD_DACDAT,
      bclk_o      => AUD_BCLK,
      ws_o        => ws_sig,
      adcdat_s_i  => AUD_ADCDAT);

    -----------------------------------------------------------------------------
  -- concurrent assignments / output
  -----------------------------------------------------------------------------
  AUD_XCK <=  clk_12m_sync_sig;
  AUD_DACLRCK <= ws_sig;
  AUD_ADCLRCK <= ws_sig;
               

end architecture rtl;

-------------------------------------------------------------------------------
