-------------------------------------------------------------------------------
-- Title      : codec_controller
-- Project    : 
-------------------------------------------------------------------------------
-- File       : codec_controller.vhdl
-- Author     : Jonathan Vogt
-- Company    : ZHAW
-- Created    : 2019-03-08
-- Last update: 2019-03-15
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Codec Controller fuer DTP2 Project. Steuert den vorhandenen
-- Codec Chip.
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-03-08  1.0      Johnny  Created
-------------------------------------------------------------------------------
-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.reg_table_pkg.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------
-- Entity Declaration 
-------------------------------------------
entity codec_controller is
  port (
    sw_sync_i    : in  std_logic_vector(2 downto 0);
    initialize_i : in  std_logic;
    write_done_i : in  std_logic;
    ack_error_i  : in  std_logic;
    clk          : in  std_logic;
    reset_n      : in  std_logic;
    write_o      : out std_logic;
    write_data_o : out std_logic_vector(15 downto 0)
   --mute                        :       out std_logic   Function?
    );

end entity codec_controller;
-------------------------------------------------------------------------------
-- Architecture Declaration?
-------------------------------------------
architecture str of codec_controller is
  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  signal count, next_count         : integer range 0 to 9;
  type uart_type is (idle, start_write, wait_on);
  signal fsm_state, next_fsm_state : uart_type;
-----------------------------------------------------------------------------
-- Component declarations
-----------------------------------------------------------------------------
begin  -- architecture str
  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------
  cc_fsm : process(all)                 --Codec Controller State_Machine
  begin
    write_o        <= '0';
    next_fsm_state <= fsm_state;  --Default, bei aktuellem 'state' bleiben
    case fsm_state is
      when idle =>
        if(initialize_i = '1')then      --Bei initialese HIGH
          next_fsm_state <= start_write;  --wird der nexte 'state' start_write
        end if;  --erreicht.
      when start_write =>               --Nur ein Taktzyklus in
        next_fsm_state <= wait_on;      --start_write 'state'
        write_o        <= '1';
      when wait_on =>
        if(ack_error_i = '1')then
          next_fsm_state <= idle;
        elsif(write_done_i = '1')then   --bei write done High
          if(count < 9) then  --und count unter 9 zu start write state                 
            next_fsm_state <= start_write;
          else                          --oder zu idle wenn count ueber 9
            next_fsm_state <= idle;
          end if;
        end if;
      when others => null;
    end case;
  end process cc_fsm;
-------------------------------------------------------------------------------
  cc_fsm_out : process(all)             --Codec Statemaschine Output
  begin
    --an write_data_o angelegt ansonsten
    case sw_sync_i is                   --wird durch case ausgew�hlt
      when "001" =>
        write_data_o <= "000" & std_logic_vector(to_unsigned(count, 4)) & C_W8731_ANALOG_BYPASS(count);
      when "101" =>
        write_data_o <= "000" & std_logic_vector(to_unsigned(count, 4)) & C_W8731_ANALOG_MUTE_LEFT(count);
      when "011" =>
        write_data_o <= "000" & std_logic_vector(to_unsigned(count, 4)) & C_W8731_ANALOG_MUTE_RIGHT(count);
      when "111" =>
        write_data_o <= "000" & std_logic_vector(to_unsigned(count, 4)) & C_W8731_ANALOG_MUTE_BOTH(count);
      when others =>
         write_data_o <= "000" & std_logic_vector(to_unsigned(count, 4)) & C_W8731_ADC_DAC_0DB_48K(count);
    end case;

  end process cc_fsm_out;
------------------------------------------------------------------------------
-------------------------------------------------------------------------------
  comb_logic : process(all)
  begin
    next_count <= count;
    if fsm_state = idle then
      next_count <= 0;  --im idle state counter auf null setzen--default next_count unveraendert
    elsif write_done_i = '1' and count < 9 then  --next_count wird erh�ht im start_write                      
      next_count <= count + 1;          --state und wenn count unter 10
    else
      next_count <= count;
    end if;
  end process comb_logic;


  --
  clocked : process(all)
  begin
    if reset_n = '0' then
      count     <= 0;
      fsm_state <= idle;
    elsif rising_edge(clk) then
      count     <= next_count;
      fsm_state <= next_fsm_state;
    end if;
  end process clocked;



end architecture str;

-------------------------------------------------------------------------------
