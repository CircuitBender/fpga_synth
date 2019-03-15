-------------------------------------------------------------------------------
-- Title      : synthi_top
-- Project    : 
-------------------------------------------------------------------------------
-- File       : synthi_top.vhd
-- Author     :   <Hans-Joachim@GELKE-LENOVO>
-- Company    : 
-- Created    : 2018-03-08
-- Last update: 2019-03-04
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

  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------


end architecture struct;

-------------------------------------------------------------------------------
