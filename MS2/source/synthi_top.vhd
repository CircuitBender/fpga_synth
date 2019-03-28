-------------------------------------------------------------------------------
-- Title      : synthi_top
-- Project    : synthi_top
-------------------------------------------------------------------------------
-- File       : synthi_top.vhd
-- Author     : Schawan Schirwan
-- Company    : 
-- Created    : 2019-03-08
-- Last update: 2019-03-28
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Top Level for Synthesizer
-------------------------------------------------------------------------------
-- Copyright (c) 2019
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 08.03.2019  1.0      Schawan         Created
-- 15.03.2019  1.1      Schawan         Debugged
-- 22.03.2019  1.1      Heinzen         Debugging and Comments
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library work;
use ieee.numeric_std.all;
use work.reg_table_pkg.all;
-- use work.tone_gen_pkg.all;

-------------------------------------------------------------------------------

entity synthi_top is

  port (
    CLOCK_50 : in std_logic;  -- DE2 clock from xtal 50MHz
    KEY_0    : in std_logic;  -- DE2 low_active input buttons
    KEY_1    : in std_logic;  -- DE2 low_active input buttons
    --KEY_2    : in std_logic;            -- DE2 low_active input buttons
    KEY_3    : in std_logic;  -- DE2 low_active input buttons
    SW       : in std_logic_vector(17 downto 0);  -- DE2 input switches

    GPIO_26 : in std_logic;  -- midi_uart serial_input

    -- clk_12m    : out std_logic;         -- Clock @ 12.5 MHz
    -- reset_n    : out std_logic;         -- Reset for Codec & I2C
    -- key_1_sync : out std_logic;         --     key_1_sync to Codec Controller
    --sw_sync    : out std_logic_vector(17 downto 0);  -- synchronized input buttons to Codec Controller
    gpio_26_sync : out std_logic;  -- 

    AUD_XCK : out std_logic;  -- master clock for Audio Codec
    -- AUD_DACDAT  : out std_logic;        -- audio serial data to Codec-DAC
    -- AUD_BCLK    : out std_logic;        -- bit clock for audio serial data
    -- AUD_DACLRCK : out std_logic;        -- left/right word select for Codec-DAC
    -- AUD_ADCLRCK : out std_logic;        -- left/right word select for Codec-ADC
    -- AUD_ADCDAT  : in  std_logic;        -- audio serial data from Codec-ADC

    I2C_SCLK : out   std_logic;  -- clock from I2C master block
    I2C_SDAT : inout std_logic  -- data  from I2C master block
    );

end entity synthi_top;


-------------------------------------------------------------------------------

architecture struct of synthi_top is

  component i2c_master is
    port (
      clk          : in    std_logic;  -- clk in 
      reset_n      : in    std_logic;  -- reset in
      write_i      : in    std_logic;  -- write data bit in 
      write_data_i : in    std_logic_vector(15 downto 0);  -- write parallel data in
      sda_io       : inout std_logic;  -- transmit data 
      scl_o        : out   std_logic;  -- source clock out
      write_done_o : out   std_logic;  -- write done out
      ack_error_o  : out   std_logic);  -- acknowledgement error out 
  end component i2c_master;

  component codec_controller is
    port (
      initialise_i  : in  std_logic;  -- initialise bit in 
      write_done_i  : in  std_logic;  -- write done bit in
      ack_error_i   : in  std_logic;  -- acknowledgement error bit in
      clock         : in  std_logic;  -- clk in
      reset_n       : in  std_logic;  -- reset in
      write_o       : out std_logic;  -- write bit out
      write_data_o  : out std_logic_vector(15 downto 0);  -- write parallel data out (to audio codec)
      state_control : in  std_logic_vector(2 downto 0));  -- state control vector, 3 bits for switching audio codec setups
  end component codec_controller;

  component infrastructure is
    port (
      CLOCK_50 : in std_logic;  -- clock 50 MHz in 
      KEY : in std_logic_vector(1 downto 0);  -- Key input
      GPIO_26 : in std_logic;  -- GPIO_26 input 
      SW : in std_logic_vector(17 downto 0);
      clk_12m : out std_logic;  -- converted 12 MHz clock out 
      reset_n : out std_logic;  -- reset switch out
      key_1_sync : out std_logic;  -- synced KEY_0
      gpio_26_sync : out std_logic;  -- synced GPIO_26
      c_1 : std_logic_vector(17 downto 0);  -- synced switches
                                            -- 
      signal write_1 : std_logic;  -- write signal 
      signal write_data : std_logic_vector(15 downto 0);  -- write parallel data signal
      signal write_done : std_logic;  -- write done signal 
      signal ack_error : std_logic;  -- acknowldegment error signaö
      signal dacdat_pl : std_logic_vector(15 downto 0);  -- digital-analog signal left
      signal dacdat_pr : std_logic_vector(15 downto 0);  -- digital-analog signal right
      signal adcdat_pl : std_logic_vector(15 downto 0);  -- analog-digital signal left
      signal adcdat_pr : std_logic_vector(15 downto 0);  -- analog-digital signal right

      begin

        -- instance "i2c_master_1"
        i2c_master_1 : i2c_master
          port map (
            clk => Clock_intern,
            reset_n => reset_n_intern,
            write_i => write_1,
            write_data_i => write_data,
            sda_io => I2C_SDAT,
            scl_o => I2C_SCLK,
            write_done_o => write_done,
            ack_error_o => ack_error);

        -- instance "codec_controller_1"
        codec_controller_1 : codec_controller
          port map (
            initialise_i => key_ini_1,
            write_done_i => write_done,
            ack_error_i => ack_error,
            clock => Clock_intern,
            reset_n => reset_n_intern,
            write_o => write_1,
            write_data_o => write_data,
            state_control => sw_sync_1(2 downto 0)
            );

        -- instance "infrastructure_1"
        infrastructure_1 : infrastructure
          port map (
            CLOCK_50 => CLOCK_50,
            KEY => (KEY_1 & KEY_0),
            GPIO_26 => GPIO_26,  ---
            SW => SW,
            clk_12m => Clock_intern,
            reset_n => reset_n_intern,
            key_1_sync => key_ini_1,
            gpio_26_sync => gpio_26_sync,  ---
            sw_sync => sw_sync_1);

        -- instance path control "path_control_1"
        path_control_1 : path_control
          port map (
            sw_sync_3 => sw_sync_1(3),
            dds_l_i => dds_l_i,
            dds_r_i => dds_r_i,
            adcdat_pl_i => dacdat_pl,
            adcdat_pr_i => adcdat_pr,
            dacdat_pl_o => dacdat_pl,
            dacdat_pr_o => dacdat_pr);

        -- concurrent assignments
        AUD_XCK <= Clock_intern;



      end architecture struct;

-------------------------------------------------------------------------------
