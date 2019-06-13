-------------------------------------------------------------------------------
-- Title      : path_control
-- Project    : syntProject_group10
-------------------------------------------------------------------------------
-- File       : path_control.vhd
-- Author     : Heinzen
-- Company    : 
-- Created    : 2019-03-28
-- Last update: 2019-05-18
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
-- 2018-03-28  1.1      Heinzen         added MUX
-- 2018-05-18  1.1      Rutishauser     debugged

-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;


entity path_control is
  port(sw_sync     : in  std_logic;     -- path selection
       -- Audio data generated inside FPGA
       dds_l_i     : in  std_logic_vector(15 downto 0);  --Input from synthesizer
       dds_r_i     : in  std_logic_vector(15 downto 0);
       -- Audio data coming from codec
       adcdat_pl_i : in  std_logic_vector(15 downto 0);  --Input  i2s_master
       adcdat_pr_i : in  std_logic_vector(15 downto 0);
       -- Audio data towards codec
       dacdat_pl_o : out std_logic_vector(15 downto 0);  --Output zum i2s_master
       dacdat_pr_o : out std_logic_vector(15 downto 0)
       );
end path_control;


architecture comb of path_control is



begin

  mux : process (all)
  begin
    -- mux switch between dds input LOW and feedback loop HIGH

    if sw_sync = '0' then
      dacdat_pl_o <= dds_l_i;
      dacdat_pr_o <= dds_r_i;
    else
      dacdat_pl_o <= adcdat_pl_i;
      dacdat_pr_o <= adcdat_pr_i;
    end if;

  end process mux;


end comb;

