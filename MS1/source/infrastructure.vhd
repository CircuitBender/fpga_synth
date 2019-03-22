-------------------------------------------------------------------------------
-- Title      : infrastructure
-- Project    : synthi_project
-------------------------------------------------------------------------------
-- File       : infrastructure.vhd
-- Author     :   <Nicola@NICOLA>
-- Company    : 
-- Created    : 2019-03-08
-- Last update: 2019-03-15
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-03-08  1.0      Nicola	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity infrastructure is

  port (
    clock_50 		: in std_logic;
    key      		: in std_logic_vector(1 downto 0);
    sw       		: in std_logic_vector(17 downto 0);
    gpio_26  		: in std_logic;
    clk_12m  		: out std_logic;
    key_1_sync 	: out std_logic;
    reset_n  		: out std_logic;
    sw_sync  		: out std_logic_vector(17 downto 0);
    gpio_26_sync 	: out std_logic
    );

end entity infrastructure;

-------------------------------------------------------------------------------

architecture str of infrastructure is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  signal clk_12m_int : std_logic;   -- internal 12.5MHz clock-signal
  signal key_sync_int : std_logic_vector(1 downto 0);  --synchronized key-signals
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

  component modulo_divider is
    generic (
      width : positive);
    port (
      clk          : in  std_logic;
      reset_n      : out std_logic;
      clk_12m      : out std_logic);
  end component modulo_divider;

begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------
  sync_inst_1: synchronize
    generic map (
      width => 2)
    port map (
      signal_i => key,
      clk_12m  => clk_12m_int,
      signal_o => key_sync_int);
  
  sync_inst_2: synchronize
    generic map (
      width => 18)
    port map (
      signal_i => sw,
      clk_12m  => clk_12m_int,
      signal_o => sw_sync);
  
  sync_inst_3: synchronize
    generic map (
      width => 1)
    port map (
      signal_i(0) => gpio_26,
      clk_12m  => clk_12m_int,
      signal_o(0) => gpio_26_sync);

    takt_inst: modulo_divider
    generic map (
      width => 2)
    port map (
      clk     => clock_50,
      clk_12m => clk_12m_int);

  
  clk_12m <= clk_12m_int;               --12.5MHz clock output
  key_1_sync <= key_sync_int(1);        --synchronized keys get split in 2 outputs
  reset_n <= key_sync_int(0);
  
end architecture str;

-------------------------------------------------------------------------------
