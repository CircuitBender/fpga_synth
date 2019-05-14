-------------------------------------------------------------------------------
-- Title      : MIDI_UART
-- Project    : 
-------------------------------------------------------------------------------
-- File       : MIDI_UART.vhd
-- Author     :  rutiscla
-- Company    : 
-- Created    : 2019-05-03
-- Last update: 2019-05-03
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version   Author          Description
-- 2019-05-03  1.0       rutiscla        Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

-------------------------------------------------------------------------------

entity MIDI_UART is

  generic (
    );

  port (clk_12_m        :       in      std_logic;
        reset_n         :       in      std_logic;
        serial_in       :       in      std_logic;
        rx_data_valid   :       out     std_logic;
        rx_data         :       out     std_logic_vector (7 downto 0)
    );

end entity MIDI_UART;

-------------------------------------------------------------------------------

architecture str of MIDI_UART is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  signal baud_tick_sig : std_logic;
  signal fall_edge_sig : std_logic;
  signal shift_enable_sig : std_logic;
  signal start_bit_sig : std_logic;
  signal rx_data_sig : std_logic_vector (7 downto 0);
  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------

  component baud_tick is
    port (
      start_bit : IN  std_logic;
      clock     : IN  std_logic;
      reset_n   : IN  std_logic;
      baud_tick : OUT std_logic);
  end component baud_tick;

  component uart_controller is
    port (
      uart_controller_i : in  std_logic;
      fall_edge         : in  std_logic;
      clock             : in  std_logic;
      reset_n           : in  std_logic;
      parallel_in       : in  std_logic_vector(9 downto 0);
      start_bit_o       : out std_logic;
      data_valid_o      : out std_logic;
      shift_enable      : out std_logic);
  end component uart_controller;

  component flanken_detect is
    port (
      data_in : IN  std_logic;
      clock   : IN  std_logic;
      reset_n : IN  std_logic;
      steig   : OUT std_logic;
      fall    : OUT std_logic);
  end component flanken_detect;

  component shiftreg_s2p is
    generic (
      width : positive);
    port (
      clk, reset_n, enable_i, ser_i : IN  std_logic;
      par_o                         : OUT std_logic_vector (9 downto 0));
  end component shiftreg_s2p;

begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- instance "baud_tick_1"
  baud_tick_1: baud_tick
    port map (
      start_bit => start_bit_sig,
      clock     => clk_12_m,
      reset_n   => reset_n,
      baud_tick => baud_tick_sig);

  -- instance "uart_controller_1"
  uart_controller_1: uart_controller
    port map (
      uart_controller_i => baud_tick_sig,
      fall_edge         => fall_edge_sig,
      clock             => clk_12_m,
      reset_n           => reset_n,
      parallel_in       => rx_data_sig,
      start_bit_o       => start_bit_sig,
      data_valid_o      => rx_data_valid,
      shift_enable      => shift_enable_sig);

  -- instance "flanken_detect_1"
  flanken_detect_1: flanken_detect
    port map (
      data_in => serial_in,
      clock   => clk_12_m,
      reset_n => reset_n,
      steig   => steig,
      fall    => fall_edge_sig);

  -- instance "shiftreg_s2p_1"
  shiftreg_s2p_1: shiftreg_s2p
    generic map (
      width => width)
    port map (
      clk      => clk_12_m,
      reset_n  => reset_n,
      enable_i => shift_enable_sig,
      ser_i    => serial_in,
      par_o    => rx_data_sig);


  --outputs:
  rx_data <= rx_data_sync;

end architecture str;

-------------------------------------------------------------------------------
