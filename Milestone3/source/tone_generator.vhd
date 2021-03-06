-------------------------------------------------------------------------------
-- Title      : tone_generator
-- Project    : fpga_synth
-------------------------------------------------------------------------------
-- File       : tone_generator.vhd
-- Author     : Heinzen / Rutishauser
-- Company    : ZHAW
-- Created    : 2019-05-02
-- Last update: 2019-05-09
-- Platform   : Windows 10
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2019
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-05-02  1.0      Rutishauser   Created
-- 2019-05-09  1.2      Heinzen   Debugging, commentaries
---------------------------------------------------------------
-------------------------------------------------------------------------------
-- Package  Declaration
-------------------------------------------------------------------------------
-- Include in to the top design tone_generator.vhd
--   use work.tone_gen_pkg.all;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Libraries
--------------------------------------------------------------------------------
library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.tone_gen_pkg.all;              -- package tone_gen_pkg.vhd

--------------------------------------------------------------------------------
-- Entity Declaration 
--------------------------------------------------------------------------------
entity tone_generator is
  port(clk_12m    : in  std_logic;      -- 12.5M Clock
    reset_n    : in  std_logic;  -- Reset or init used for re-initialisation
    load_i     : in  std_logic;      -- Pulse once per audio frame 1/48kHz
	note_vector : in  std_logic_vector (6 downto 0);
    dds_o       : out std_logic_vector(N_AUDIO -1 downto 0));
end tone_generator;


-------------------------------------------------------------------------------

architecture struct of tone_generator is

  component DDS is
    port (
      clk_12m    : in  std_logic;
      load_i     : in  std_logic;
      reset_n    : in  std_logic;
      phi_incr_i : in  std_logic_vector (N_CUM-1 downto 0);
      dds_o      : out std_logic_vector (N_AUDIO -1 downto 0));
  end component DDS;

begin

  -- instance "DDS_1"
  DDS_1 : DDS
    port map (
      clk_12m    => clk_12m,
      load_i     => load_i,
      reset_n    => reset_n,
      phi_incr_i => LUT_midi2dds(to_integer(unsigned(note_vector))),  --lut_midi2dds in tone_generator,
      dds_o      => dds_o);

end architecture struct;
