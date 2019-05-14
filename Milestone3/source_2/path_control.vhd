-------------------------------------------------------------------------------
-- Title      : path_control
-- Project    : fpga_synth
-------------------------------------------------------------------------------
-- File       : path_control.vhd
-- Author     : Gelke, Heinzen
-- Company    : 
-- Created    : 2019-03-28
-- Last update: 2019-03-29
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: MUX to choose from 2 parallel signals
-------------------------------------------------------------------------------
-- Copyright (c) 2019
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  	Description
-- 2018-03-01  1.0      Gelke		Created
-- 2019-03-28  1.1		Heinzen		added MUX

-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity Declaration 
-------------------------------------------
entity path_control is
  port(sw_sync_3      : in  std_logic;  -- path selection
            -- Audio data generated inside FPGA
		dds_l_i : in  std_logic_vector(15 downto 0);  --Input from synthesizer
		dds_r_i : in  std_logic_vector(15 downto 0);
       -- Audio data coming from codec
       adcdat_pl_i : in  std_logic_vector(15 downto 0);  --Input  i2s_master
       adcdat_pr_i : in  std_logic_vector(15 downto 0);
       -- Audio data towards codec
       dacdat_pl_o : out std_logic_vector(15 downto 0);  --Output zum i2s_master
       dacdat_pr_o : out std_logic_vector(15 downto 0)
       );
end path_control;


architecture rtl of path_control is



begin

mux : PROCESS (all)
	BEGIN
	-- mux switch between dds input LOW and feedback loop HIGH
	IF sw_sync_3 = '0' THEN 
		dacdat_pl_o <= dds_l_i;
		dacdat_pr_o <= dds_r_i;
	ELSE
		dacdat_pl_o <= adcdat_pl_i;
		dacdat_pr_o <= adcdat_pr_i;
	END IF;
	
	END PROCESS mux;


end rtl;

