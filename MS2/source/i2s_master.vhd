--------------------------------------------------------------------
-- Project     : DTP_Soundmachine
--
-- File Name   : i2s_master.vhd
-- Description : Konvertiert die seriellen i2s Daten in ein paralleles signal
--                              und umgekehrt, Hierachie f�r clock-Teiler, state-machine, schieberegister
--
--------------------------------------------------------------------
-- Change History
-- Date     |Name      |Modification
------------|----------|--------------------------------------------
-- 24.03.14 | loosean  | file created
-- 21.04.14 | loosean  | revised comments
-- 29.03.17 | dqtm     | adapt to reuse on extended DTP2 project 
--                     | Changes: reuse mod_div, combine bit_cnt & i2s_decoder into frame_decoder)
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


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


architecture rtl of i2s_master is

begin
  
end rtl;
