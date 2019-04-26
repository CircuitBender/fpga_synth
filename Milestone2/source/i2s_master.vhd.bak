-------------------------------------------------------------------------------
-- Title      : synthi_top
-- Project    : fpga_synth
-------------------------------------------------------------------------------
-- File       : i2s_master.vhd
-- Author     : Heinzen
-- Company    : 
-- Created    : 2014-03-24
-- Last update: 2019-03-30
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
-- 29.03.2017  1.1      dqtm            Changes: reuse mod_div, combine bit_cnt , i2s_decoder into frame_decoder)
-- 28.03.2019  1.2      Heinzen         intern project version 1.0 / beta
-- 31.03.2019  1.3      Heinzen         completing beta 

-------------------------------------------------------------------------------


-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;


-- Entity Declaration 
-------------------------------------------
entity i2s_master is
  port(clk_12m : in  std_logic;         -- 12.5M Clock
       reset_n : in  std_logic;  -- Reset or init used for re-initialisation
       load_o  : out std_logic;         -- Pulse once per audio frame 1/48kHz

       --Verbindungen zum audio_controller
       adcdat_pl_o : out std_logic_vector(15 downto 0);  --Ausgang zum audio_controller
       adcdat_pr_o : out std_logic_vector(15 downto 0);

       dacdat_pl_i : in std_logic_vector(15 downto 0);  --Eingang vom audio_controller
       dacdat_pr_i : in std_logic_vector(15 downto 0);

       --Verbindungen zum Audio-Codec
       dacdat_s_o : out std_logic;      --Serielle Daten Ausgang
       bclk_o     : out std_logic;      --Bus-Clock
       ws_o       : out std_logic;      --WordSelect (Links/Rechts)
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
  component bclk_gen is
    port (
      clk_12m, reset_n : in  std_logic;
      bclk             : out std_logic);
  end component bclk_gen;

  component bit_counter is
    port (
      clk_12m, bclk, reset_n, init_i : in  std_logic;
      bit_count                      : out std_logic_vector(6 downto 0));
  end component bit_counter;

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

  component shiftreg_s2p_i2s is
    port (
      clk      : in  std_logic;
      reset_n  : in  std_logic;
      enable_i : in  std_logic;
      ser_i    : in  std_logic;
      shift_i  : in  std_logic;
      par_o    : out std_logic_vector(15 downto 0));
  end component shiftreg_s2p_i2s;



  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  signal  bclk_sig   : std_logic;
  signal init_i_sig : std_logic := 0;   -- optional initialisation signal , still to be implemented
  signal bitcount_signal : std_logic_vector(6 downto 0);  -- bitcount signal
  signal ac_atttime : std_logic_vector(4 downto 1);
  signal ac_dectime : std_logic_vector(4 downto 1);
  signal load_sig : std_logic := 0;     -- load signal
  signal shift_l_sig : std_logic := 0;  -- shift left signal
  signal shift_r_sig : std_logic := 0;  -- shift right signal
  

  -----------------------------------------------------------------------------
  -- instance declaration
  -----------------------------------------------------------------------------
  bclk_gen_1 : bclk_gen
    port map (
      clk_12m => clk_12m,
      reset_n => reset_n,
      bclk    => bclk_sig);

  bit_counter_1 : bit_counter
    port map (
      clk_12m   => clk_12m,
      bclk      => bclk_sig,
      reset_n   => reset_n,
      init_i    => init_i_sig,
      bit_count => bit_count_sig);

  i2s_decoder_1 : i2s_decoder
    port map (
      bit_count => bit_count_sig,
      load      => load_sig,
      shift_l   => shift_l_sig,
      shift_r   => shift_r_sig,
      ws        => ws_o);

  shiftreg_p2s_i2s_right : shiftreg_p2s_i2s
    port map (
      clk      => clk_12m,
      set_n    => set_n_sig,
      load_i   => load_sig,
      par_i    => dacdat_pr_i,
      enable_i => bclk_sig,
      shift_i  => shift_r_sig,
      ser_o    => ser_o_sig);
  
   shiftreg_p2s_i2s_left : shiftreg_p2s_i2s
    port map (
      clk      => clk_12m,
      set_n    => set_n_sig,
      load_i   => load_sig,
      par_i    => dacdat_pl_i,
      enable_i => bclk_sig,
      shift_i  => shift_l_sig,
      ser_o    => ser_o_sig);

  shiftreg_s2p_i2s_right : shiftreg_s2p_i2s
    port map (
      clk      => clk_12m,
      reset_n  => reset_n,
      enable_i => bclk_sig,
      ser_i    => adcdat_s_i,
      shift_i  => shift_r_sig,
      par_o    => par_o_sig);

    shiftreg_s2p_i2s_left : shiftreg_s2p_i2s
    port map (
      clk      => clk_12m,
      reset_n  => reset_n,
      enable_i => bclk_sig,
      ser_i    => ser_i_sig,
      shift_i  => adcdat_s_i,
      par_o    => par_o_sig);

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
----------------------------------------------------
-- concurrent assignments
----------------------------------------------------
  bclk_o <= bclk_sig;
  load_o <= load_sig;
  ws_o <= ws_sig;
  
end rtl;

