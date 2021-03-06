-------------------------------------------------------------------------------
-- Title      : tone_generator
-- Project    : fpga_synth
-------------------------------------------------------------------------------
-- File       : tone_generator.vhd
-- Author     : Heinzen / Rutishauser
-- Company    : ZHAW
-- Created    : 2019-05-02
-- Last update: 2019-05-22
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
-- Include in to the top design tone_generator.vhd and tone_decoder.vhd
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
  port(clk_12m     : in  std_logic;      -- 12.5M Clock
       reset_n     : in  std_logic;      -- Reset or init used for re-initialisation
      -- tone_on_i   : in  std_logic;
       load_i      : in  std_logic;      -- Pulse once per audio frame 1/48kHz
       note_on     : in  std_logic_vector(9 downto 0);
	    strobe      : in std_logic;
		 note_array  : in  t_tone_array;
       --attenu_i  : in  std_logic_vector (3 downto 0);
       dds_o       : out std_logic_vector(N_AUDIO -1 downto 0));
end tone_generator;


-------------------------------------------------------------------------------

architecture struct of tone_generator is


  signal dds_o_array : t_dds_o_array;
  signal sum_reg : integer;
  signal next_sum_reg : integer;

  component DDS is
    port (
      clk_12m    : in  std_logic;
      load_i     : in  std_logic;
      reset_n    : in  std_logic;
      phi_incr_i : in  std_logic_vector (N_CUM-1 downto 0);
      tone_on_i  : in  std_logic;
      attenu_i   : in  std_logic_vector (3 downto 0);
      dds_o      : out std_logic_vector (N_AUDIO -1 downto 0));

  end component DDS;


begin

  DDS_inst_gen : for i in 0 to 9 generate
    DDS_1 : DDS
      port map (
        clk_12m    => clk_12m,
        load_i     => load_i,
        reset_n    => reset_n,
        phi_incr_i => LUT_midi2dds(to_integer(unsigned(note_array(i)))),  --lut_midi2dds in tone_generator,
        tone_on_i  => note_on(i),
        attenu_i   => "0001",
        dds_o      => dds_o_array(i));

  end generate DDS_inst_gen;


  comb_sum_output : process(all)
    variable var_sum : integer range -(2**(20)) to (2**(20))-1;
  begin
    var_sum := 0;
    if strobe = '1' then

      dds_sum_loop : for i in 0 to 9 loop
        var_sum := var_sum + (to_integer(unsigned(dds_o_array(i))));
      end loop dds_sum_loop;

      next_sum_reg <= var_sum;
    else
      next_sum_reg <= sum_reg;
    end if;

  end process comb_sum_output;


  reg_sum_output : process(all)
  begin
    if reset_n = '0' then
      sum_reg <= 0;
    elsif rising_edge(clk_12m) then
      sum_reg <= next_sum_reg;
    end if;
  end process reg_sum_output;

--output:
dds_o<= std_logic_vector(to_unsigned(sum_reg,16));

end architecture struct;
