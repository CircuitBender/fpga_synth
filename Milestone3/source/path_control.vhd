-------------------------------------------------------------------------------
-- Title      : path_control
-- Project    : syntProject_group10
-------------------------------------------------------------------------------
-- File       : path_control.vhd
-- Author     : Heinzen
-- Company    : 
-- Created    : 2019-03-28
-- Last update: 2019-05-17
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: MUX to choose from 2 parallel signals
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2018-03-01  1.0      Gelke           Created
-- 2018-03-28  1.1              Heinzen         added MUX

-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use work.audio_filter_pkg.all;


entity path_control is
  generic (
    g_init_val : std_logic := '0');  
 
  port(clk_12m_i : in std_logic;
       reset_n_i : in std_logic;
       strobe_i : in std_logic;
    sw_sync_i   : in  std_logic_vector(17 downto 3) := (others => g_init_val);  -- path selection
    -- Audio data generated inside FPGA
    dds_l_i     : in  std_logic_vector(15 downto 0) := (others => g_init_val);  --Input from synthesizer
    dds_r_i     : in  std_logic_vector(15 downto 0) := (others => g_init_val);
    -- Audio data coming from codec
    adcdat_pl_i : in  std_logic_vector(15 downto 0) := (others => g_init_val);  --Input  i2s_master
    adcdat_pr_i : in  std_logic_vector(15 downto 0) := (others => g_init_val);
    -- Audio data towards codec
    dacdat_pl_o : out std_logic_vector(15 downto 0) := (others => g_init_val);  --Output zum i2s_master
    dacdat_pr_o : out std_logic_vector(15 downto 0) := (others => g_init_val)
    );
end path_control;


architecture comb of path_control is

  signal audio_l_i_sig : std_logic_vector(15 downto 0);  -- <[comment]>
  signal audio_r_i_sig : std_logic_vector(15 downto 0);  -- <[comment]>
  signal audio_l_o_sig : std_logic_vector(15 downto 0);  -- <[comment]>
  signal audio_r_o_sig : std_logic_vector(15 downto 0);  -- <[comment]>
    signal adata_l_i_sig : std_logic_vector(15 downto 0);  -- <[comment]>
    signal adata_r_i_sig : std_logic_vector(15 downto 0);  -- <[comment]>
  signal fdata_l_o_sig : std_logic_vector(15 downto 0);  -- <[comment]>
  signal fdata_r_o_sig : std_logic_vector(15 downto 0);  -- <[comment]>

  component fir_core is
   
    port (
      clk_i     : in  std_logic;
      reset_n_i : in  std_logic;
      strobe_i  : in  std_logic;
      adata_i   : in  std_logic_vector(15 downto 0);
      fdata_o   : out std_logic_vector(15 downto 0));
  end component fir_core;

begin  -- architecture rtl


  fir_core_1 : fir_core
    
    port map (
      clk_i     => clk_12m_i,
      reset_n_i => reset_n_i,
      strobe_i  => strobe_i,
      adata_i   => adata_l_i_sig,
      fdata_o   => fdata_l_o_sig);
		
    fir_core_2 : fir_core
  
    port map (
      clk_i     => clk_12m_i,
      reset_n_i => reset_n_i,
      strobe_i  => strobe_i,
      adata_i   => adata_r_i_sig,
      fdata_o   => fdata_r_o_sig);


  mux : process (all)
  begin
   
    -- mux switch between dds input LOW and feedback loop HIGH
    if (sw_sync_i(3) = '1') then
    audio_l_i_sig   <= dds_l_i;
   audio_r_i_sig    <= dds_r_i;
dacdat_pl_o <= audio_l_o_sig;
dacdat_pr_o <= audio_r_o_sig;

    else
      audio_l_i_sig <= adcdat_pl_i;
      audio_r_i_sig <= adcdat_pr_i;
	  dacdat_pl_o <= audio_l_o_sig;
	  dacdat_pr_o <= audio_r_o_sig;
    end if;
	  
    if (sw_sync_i(4) = '1') then
      adata_l_i_sig <=  audio_l_i_sig;
      adata_r_i_sig <= audio_r_i_sig;
		audio_l_i_sig <= fdata_l_o_sig;
		audio_r_i_sig <= fdata_r_o_sig;

    else
      audio_l_o_sig <= audio_l_i_sig;
      audio_r_o_sig <= audio_r_i_sig;
    end if;
     
  end process mux;


end comb;

