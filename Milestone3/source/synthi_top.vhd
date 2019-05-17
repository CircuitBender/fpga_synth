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
use work.tone_gen_pkg.all;              -- package tone_gen_pkg.vhd
use work.audio_filter_pkg.all;

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
  signal key_sync_sig     : std_logic_vector (3 downto 0) := (others => '0');
  signal sw_sync_sig      : std_logic_vector (17 downto 0):= (others => '0');
  signal gpio_26_sync_sig : std_logic;

  -- signals between codec_controller and i2c_master
  signal write_sync_sig      : std_logic;
  signal write_data_sync_sig : std_logic_vector (15 downto 0):= (others => '0');
  signal ack_error_sync_sig  : std_logic;
  signal write_done_sync_sig : std_logic;
  -- signal between codec_controller amd i2s
  signal mute_o_sig : std_logic;
  signal load_sig     : std_logic;
  signal adcdat_pl_sig : std_logic_vector(15 downto 0):= (others => '0');
  signal adcdat_pr_sig : std_logic_vector(15 downto 0):= (others => '0');
  signal dacdat_pl_sig : std_logic_vector(15 downto 0):= (others => '0');
  signal dacdat_pr_sig : std_logic_vector(15 downto 0):= (others => '0');
  signal dacdat_s_sig  : std_logic;
  signal bclk_sig      : std_logic;
  signal ws_sig        : std_logic;
  signal adcdat_s_sig  : std_logic;
  signal dds_r_sig :  std_logic_vector(15 downto 0):= (others => '0');
    signal dds_l_sig :  std_logic_vector(15 downto 0):= (others => '0');
signal dds_sig :  std_logic_vector(15 downto 0):= (others => '0');
  signal tone_on_sig  : std_logic;
signal     attenu_sig   : std_logic_vector (3 downto 0);
signal note_vector_sig : std_logic_vector (6 downto 0);
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

  component i2s_master is
    port (
      clk_12m_i     : in  std_logic;
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
  
   component path_control is
	port (clk_12m_i : in std_logic;
       reset_n_i : in std_logic;
       strobe_i : in std_logic;
	  sw_sync_i      : in  std_logic_vector(17 downto 3); -- path selection
            -- Audio data generated inside FPGA
		dds_l_i 		: in  std_logic_vector(15 downto 0);  --Input from synthesizer
      dds_r_i 		: in  std_logic_vector(15 downto 0);
       -- Audio data coming from codec
       adcdat_pl_i 	: in  std_logic_vector(15 downto 0);  --Input  i2s_master
       adcdat_pr_i 	: in  std_logic_vector(15 downto 0);
       -- Audio data towards codec
       dacdat_pl_o 	: out std_logic_vector(15 downto 0);  --Output zum i2s_master
       dacdat_pr_o 	: out std_logic_vector(15 downto 0)
	   );
  end component path_control;
  
    component tone_generator is
    port (
	  clk_12m_i      : in  std_logic;
	  reset_n_i     : in  std_logic;
      note_vector_i : in  std_logic_vector (6 downto 0);
      attenu_i    : in  std_logic_vector (3 downto 0);
	tone_on_i : in std_logic;
      load_i      : in  std_logic;
      dds_o       : out std_logic_vector(N_AUDIO -1 downto 0));
  end component tone_generator;
  
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
	  
	    -- instance "i2s_master_1"
  i2s_master_1: i2s_master
    port map (
      clk_12m_i     => clk_12m_sync_sig,
      reset_n_i     => reset_n_sig,
      load_o      => load_sig,
      adcdat_pl_o => adcdat_pl_sig,
      adcdat_pr_o => adcdat_pr_sig,
      dacdat_pl_i => dacdat_pl_sig,
      dacdat_pr_i => dacdat_pr_sig,
      dacdat_s_o  => AUD_DACDAT,
      bclk_o      => AUD_BCLK,
      ws_o        => ws_sig,
      adcdat_s_i  => AUD_ADCDAT);
	  
	   path_control_1 : path_control
	port map (
	clk_12m_i => clk_12m_sync_sig,
       reset_n_i => reset_n_sig,
       strobe_i => bclk_sig,
  sw_sync_i	=> sw_sync_sig(17 downto 3),
	dds_r_i 		=> dds_r_sig,
   dds_l_i 		=> dds_l_sig,

       adcdat_pl_i 	=> adcdat_pl_sig,
       adcdat_pr_i 	=> adcdat_pr_sig,
       dacdat_pl_o 	=> dacdat_pl_sig,
       dacdat_pr_o	=> dacdat_pr_sig
	   );
tone_generator_1 : tone_generator
    port map (
      note_vector_i => note_vector_sig,
      attenu_i    => attenu_sig,
      load_i      => load_sig,
      clk_12m_i     => clk_12m_sync_sig,
      reset_n_i     => reset_n_sig,
      dds_o       => dds_sig,
	tone_on_i   => tone_on_sig);
  -----------------------------------------------------------------------------
  -- concurrent assignments / output
  -----------------------------------------------------------------------------
AUD_XCK <=  clk_12m_sync_sig;
AUD_DACLRCK <= ws_sig;
	AUD_ADCLRCK <= ws_sig;
	tone_on_sig <= '1';
	attenu_sig <= "0110";
	note_vector_sig <= "0111011";
	
end architecture rtl;

-------------------------------------------------------------------------------
