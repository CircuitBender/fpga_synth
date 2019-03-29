-------------------------------------------------------------------------------
-- Title      : Block Audio Codec Controller
-- Project    : 
-------------------------------------------------------------------------------
-- File       : codec_controller.vhd
-- Author     : <Heinzen>  
-- Company    : 
-- Created    : 2019-03-08
-- Last update: 2019-03-28
-- Platform   : Windows 10
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Codec Controller 
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  : 
-- Date        Version  Author  Description
-- 2019-03-08  1.0      Heinzen   Created
-- 2019-03-15  1.1      Heinzen   debugging
-- 2019-03-22  1.2      Heinzen   minor changes
-- 2019-03-08  1.0      Heinzen   comments added

-------------------------------------------------------------------------------

--Library & Use Statements
library ieee;
use ieee.std_logic_1164.all; -- Standard Library
use ieee.numeric_std.all; -- Standard Library
use work.reg_table_pkg.all; -- Import registry tables for different Audio Setups
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Entity Declaraion
entity codec_controller is

  port(
    initialise_i  : in  std_logic; 
    write_done_i  : in  std_logic; -- write done signal input
    ack_error_i   : in  std_logic; -- acknoledgment bit error  signal input
    clock         : in  std_logic; -- clock signal input 
    reset_n       : in  std_logic; -- reset signal input
    write_o       : out std_logic; -- write out signal 
    write_data_o  : out std_logic_vector(15 downto 0); -- write parallel data output
    state_control : in  std_logic_vector(2 downto 0) -- 3bit vector for 3 input switches to control the fsm
    );
end codec_controller;
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Architecture Declaration
architecture rtl of codec_controller is
--Types
  type codec_state is (idle, start_write, wait_state); -- type declaration for different fsm states
--Signals
  signal current_state : codec_state; -- signal for states
  signal next_state    : codec_state; -- next signal for states
  signal count         : integer range 0 to 9; -- signal vector for counter
  signal next_count    : integer range 0 to 9; -- next signal vector for counter


begin
-- Process for sending data to I2C

  send : process(all)
  begin
    
     case state_control is  --control for switching between different commands(from reg.table_pkg)
      when "001"  => write_data_o <= "000" & std_logic_vector(to_unsigned (count, 4)) & C_W8731_ANALOG_BYPASS(count); -- setup for analog bypass
      when "011"  => write_data_o <= "000" & std_logic_vector(to_unsigned (count, 4)) & C_W8731_ANALOG_MUTE_RIGHT(count); -- setup for right mute
      when "101"  => write_data_o <= "000" & std_logic_vector(to_unsigned (count, 4)) & C_W8731_ANALOG_MUTE_LEFT(count); -- setup for left mute
      when "111"  => write_data_o <= "000" & std_logic_vector(to_unsigned (count, 4)) & C_W8731_ANALOG_MUTE_BOTH(count); -- setup for mute (both)
      when others => write_data_o <= "000" & std_logic_vector(to_unsigned (count, 4)) & C_W8731_ADC_DAC_0DB_48K(count); -- default setup

    end case;

    

  end process;
-------------------------------------------------------------------------------
  --sending data
  codec_controller_fsm : process(all)                 --Codec Controller State_Machine
  begin
    write_o    <= '0';					-- default for write out bit '0'
    next_state <= current_state;       -- default, idle state / stay at actual state
    next_count <= count;				-- count goes to nextcount

    -- prestatement:
	-- idle and start_write state
	-- default (initialise HIGH) keeps the fsm in idle state	
	-- initialise low initialises the writing state and sets the counter to 0
	-- only one cycle in start_write state which sets write out bit HIGH and switches fsm state to wait_state for the next cycle
          
    case current_state is  				-- case for current state
      when idle => 						-- idle statement
        if(initialise_i = '0')then      
           next_count <= 0;				-- initialising counter to 0
        else
          next_state <= idle;          -- idle loop
        end if;  --erreicht.
      when start_write =>               -- one cycle start_write switching to wait_state
        next_state <= wait_state;       --start_write 'state'
        write_o    <= '1';				-- sending out write bit

        -- prestatement:
	-- wait_state waits until the write_done_i input signal acknowledges the output of data and switches 
	-- AND if the counter exceeds 10 counts (10 bits of data) the transmission is done and the fsm switches to idle
	-- if the fsm receives an acknowldgement error  the fsm switches back to idle for next try to transmit
        
      when wait_state =>
        if ((write_done_i = '1') and (count >= 9))or (ack_error_i = '1') then -- conditions to switch to idle
          next_state <= idle;
          
        elsif(write_done_i = '1')and (count<9)  then   -- writing is in process but not all data sent
            next_count <= count + 1;              -- counter increment
            next_state <= start_write;  -- switch to start_write for one cycle 
          else                          --oder zu idle wenn count ueber 9
            next_state <= wait_state; -- waiting while data is transmitted
             next_count <= count;  -- counter is idle
          end if;
        
      when others => null; -- default statement for case 
    end case;
  end process codec_controller_fsm;

  -- flip flop shoft registers  
  -- prestatement reset_n LOW resets the fsm to idle and counter to 0
  
  ff : process(all)
  begin
    if reset_n = '0' then
      count         <= 0;
      current_state <= idle;

    elsif rising_edge(clock) then -- shifting states on rising edge
      current_state <= next_state;
      count         <= next_count;
    end if;
  end process; 
end architecture;
