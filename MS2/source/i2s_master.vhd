-------------------------------------------------------------------------------
-- Title      : synthi_top
-- Project    : fpga_synth
-------------------------------------------------------------------------------
-- File       : i2s_master.vhd
-- Author     : Heinzen
-- Company    : 
-- Created    : 2014-03-24
-- Last update: 2019-03-28
-- Platform   : Windows 10
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: I2S Master
-------------------------------------------------------------------------------
-- Copyright (c) 2019
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 08.03.2019  1.0      loosean         Created
-- 15.03.2019  1.0      loosean         revised comments
-- 22.03.2019  1.1      dqtm            adapt to reuse on extended DTP2 project
-- 29.03.2017  1.1      dqtm            Changes: reuse mod_div, combine bit_cnt & i2s_decoder into frame_decoder)
-- 28.03.2019  1.2      Heinzen		intern project version 1.0 / beta
-------------------------------------------------------------------------------


-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;


-- Entity Declaration 
-------------------------------------------
entity i2s_master is
  port(clk_12m   : in std_logic;            -- 12.5M Clock
       reset_n : in std_logic;  -- Reset or init used for re-initialisation

       load_o : out std_logic;          -- Pulse once per audio frame 1/48kHz

       --Verbindungen zum audio_controller
       adcdat_pl_o : out std_logic_vector(15 downto 0);  --Ausgang zum audio_controller
       adcdat_pr_o : out std_logic_vector(15 downto 0);

       dacdat_pl_i : in std_logic_vector(15 downto 0);  --Eingang vom audio_controller
       dacdat_pr_i : in std_logic_vector(15 downto 0);

       --Verbindungen zum Audio-Codec
       dacdat_s_o : out std_logic;      --Serielle Daten Ausgang
       bclk_o     : out std_logic;      --Bus-Clock
       ws_o         : out std_logic;      --WordSelect (Links/Rechts)
       adcdat_s_i : in  std_logic       --Serielle Daten Eingang
       );
end i2s_master;

-------------------------------------------
-- Architecture 
-------------------------------------------
architecture rtl of i2s_master is
-------------------------------------------
-- Signals & Constants Declaration
-------------------------------------------

   
-------------------------------------------
-- Component declarations
-------------------------------------------
  component bit_counter is
    port (
      clk_12m, bclk, reset_n, init_i : IN  std_logic;
      bit_count                      : OUT std_logic_vector(6 downto 0));
  end component bit_counter;

  component i2s_decoder is
    port (
      bit_count                  : in  std_logic_vector(6 downto 0);
      load, shift_l, shift_r, ws : out std_logic);
  end component i2s_decoder;

  component i2s_decoder is
    port (
      bit_count                  : in  std_logic_vector(6 downto 0);
      load, shift_l, shift_r, ws : out std_logic);
  end component i2s_decoder;

  component shiftreg_p2s_i2s is
    port (
      clk      : in  std_logic;
      set_n    : in  std_logic;
      load_i   : in  std_logic;
      par_i    : in  std_logic_vector(15 downto 0);
      enable_i : in  std_logic;
      shift_i  : in  std_logic;
      ser_o    : out std_logic);
  end component shiftreg_p2s_i2s;

-------------------------------------------
-- Begin Architecture
-------------------------------------------
begin
  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------

 --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  
  
end rtl;

