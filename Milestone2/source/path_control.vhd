-------------------------------------------------------------------------------
-- Title      : path_control
-- Project    : syntProject_group10
-------------------------------------------------------------------------------
-- File       : path_control.vhd
-- Author     : Heinzen
-- Company    : 
-- Created    : 2019-03-28
-- Last update: 2019-03-29
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: MUX to choose from 2 parallel signals
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  	Description
-- 2018-03-01  1.0      Gelke		Created
-- 2018-03-28  1.1		Heinzen		added MUX

-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;


entity path_control is
  generic (
        g_init_val : std_logic := '0'
    );
  port(sw_sync_i      : in  std_logic_vector(17 downto 0) := (others => g_init_val);  -- path selection
            -- Audio data generated inside FPGA
		dds_l_i : in  std_logic_vector(15 downto 0) := (others => g_init_val);  --Input from synthesizer
		dds_r_i : in  std_logic_vector(15 downto 0) := (others => g_init_val);
       -- Audio data coming from codec
       adcdat_pl_i : in  std_logic_vector(15 downto 0) := (others => g_init_val);  --Input  i2s_master
       adcdat_pr_i : in  std_logic_vector(15 downto 0) := (others => g_init_val);
       -- Audio data towards codec
       dacdat_pl_o : out std_logic_vector(15 downto 0) := (others => g_init_val);  --Output zum i2s_master
       dacdat_pr_o : out std_logic_vector(15 downto 0) := (others => g_init_val)
       );
end path_control;


architecture comb of path_control is



begin

mux : PROCESS (all)
	BEGIN
	-- mux switch between dds input LOW and feedback loop HIGH
	IF (sw_sync_i(3) = '0') THEN 
		dacdat_pl_o <= dds_l_i;
		dacdat_pr_o <= dds_r_i;

	ELSE
		dacdat_pl_o <= adcdat_pl_i;
		dacdat_pr_o <= adcdat_pr_i;
	END IF;
	
	END PROCESS mux;


end comb;

