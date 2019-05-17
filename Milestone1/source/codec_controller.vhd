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
-- 2019-03-28  1.2      Heinzen   comments added
-- 2019-03-28  1.2      Heinzen   comments changed
-- 2019-03-22  1.3      Heinzen   ack_error_i feature added 
-------------------------------------------------------------------------------


--Library & Use Statements
library ieee;
use ieee.std_logic_1164.all; -- Standard Library
use ieee.numeric_std.all; -- Standard Library
use work.reg_table_pkg.all; -- Import registry tables for different Audio Setups
-------------------------------------------------------------------------------

-- Entity Declaration 
-------------------------------------------
entity codec_controller is
  port(clk_12m_i, reset_n_i : in std_logic; -- clock signal input , reset signal input
       sw_sync_i : in std_logic_vector(2 downto 0);   -- 3bit vector for 3 input switches to control the fsm
       initialize_i : in std_logic; 
       write_done_i : in std_logic; -- write done signal input
       ack_error_i  : in std_logic; -- acknoledgment bit error  signal input

       --outputs: 
       write_data_o : out std_logic_vector(15 downto 0); -- write parallel data output
       write_o      : out std_logic; -- write out signal 
       mute_o       : out std_logic --- mute out signal 
       );
end codec_controller;


-- Architecture Declaration?
-------------------------------------------
architecture rtl of codec_controller is

-- Signals & Constants Declaration
-------------------------------------------

  signal count, next_count : integer range 0 to 9; -- internal signal count , next count
  signal write_done_sig     : std_logic; -- output signal write done output
  signal ack_error_sig      : std_logic; --- output signal acknowledgement error output
  type fsm_states is (state_idle, state_start_write, state_wait);  -- type declaration for different fsm states
  signal fsm_state           : fsm_states; -- signal for state
  signal next_fsm_state      : fsm_states; -- signal for next state


-- Begin Architecture
-------------------------------------------
begin

  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  --Codec Controller State_Machine
  codec_controller_fsm : process(all)
  begin
-- Process for sending data to I2C
    -- prestatement:
	-- idle and start_write state
	-- default (initialise HIGH) keeps the fsm in idle state	
	-- initialise low initialises the writing state and sets the counter to 0
	-- only one cycle in start_write state which sets write out bit HIGH and switches fsm state to wait_state for the next cycle
 
 write_o <= '0'; -- default for write out bit '0'

    case fsm_state is --- case statement for fsm 
      when state_idle => -- idle state definition
        if initialize_i = '0' then -- one cycle start_write state
          next_fsm_state <= state_start_write; 
        else
          next_fsm_state <= fsm_state; -- default, idle state / stay at actual state
        end if;

      when state_start_write => 
        write_o <= '1'; -- write output signal HIGH
        if write_done_i = '0' then -- wait while transmitting data
          next_fsm_state <= state_wait;
        else
          next_fsm_state <= fsm_state; -- default, idle state / stay at actual state

        end if;
		
   -- prestatement:
	-- wait_state waits until the write_done_i input signal acknowledges the output of data and switches 
	-- AND if the counter exceeds 8 counts the transmission is done and the fsm switches to idle
	-- if the fsm receives an acknowldgement error  the fsm switches back to idle for next try to transmit
    
      when state_wait => 
        if write_done_i = '1' then
          if count < 9 then
            next_fsm_state <= state_start_write;
          else
            next_fsm_state <= state_idle;
          end if;
        else
          next_fsm_state <= fsm_state; -- default, idle state / stay at actual state
        end if;

      when others =>
        next_fsm_state <= state_idle;  -- default, idle state / stay at actual state
    end case;
  end process codec_controller_fsm;



--------------------------------------------------
-- PROCESS FOR REGISTERS
--------------------------------------------------
  -- flip flop shoft registers  
  -- prestatement reset_n LOW resets the fsm to idle and counter to 0
-- if the fsm receives an acknowldgement error  the fsm switches back to idle for next try to transmit

  flip_flops : process(all)
  begin
    if reset_n_i = '0' or ack_error_i = '1' then
      count   <= 0;  
      fsm_state <= state_idle;
    elsif rising_edge(clk_12m_i) then  -- shifting states on rising edge
      count   <= next_count; -- shift count register
      fsm_state <= next_fsm_state; -- shift fsm  register
    end if;
  end process flip_flops;

 -- prestatement counter register:
 -- transmission has to be acknowledged by write_done_i
 -- while in white state counter counts up from 0 to 8 (for the different adresses in the array) after 8 counter is reset to 0
   counter : process(all)
  begin
    if write_done_i = '1' and fsm_state = state_wait then
		if count < 9 then
        next_count <= count + 1; -- counter increment
		else
        next_count <= 0;
		end if;
    else
    next_count <= count;
    end if;
  end process counter;

  
  -- Process for sending data to I2C

  muxer : process(all)
  begin
    --default statement
    write_data_o <= (others => '0');
    mute_o       <= '1';
	 --case for switching between different commands(from reg.table_pkg)
	 -- convert count from unsigned to std_logic for array 

    case sw_sync_i is
    when "001"  => write_data_o <= "000" & std_logic_vector(to_unsigned(count, 4)) & C_W8731_ANALOG_BYPASS(count); -- setup for analog bypass
      when "011"  => write_data_o <= "000" & std_logic_vector(to_unsigned(count, 4)) & C_W8731_ANALOG_MUTE_RIGHT(count); -- setup for right mute
      when "101"  => write_data_o <= "000" & std_logic_vector(to_unsigned(count, 4)) & C_W8731_ANALOG_MUTE_LEFT(count); -- setup for left mute
      when "111"  => write_data_o <= "000" & std_logic_vector(to_unsigned(count, 4)) & C_W8731_ANALOG_MUTE_BOTH(count); -- setup for mute (both)
      when others => write_data_o <= "000" & std_logic_vector(to_unsigned(count, 4)) & C_W8731_ADC_DAC_0DB_48K(count); -- default setup

    end case;
  end process muxer;

--------------------------------------------------
-- CONCURRENT ASSIGNMENTS
-------------------------------------------------
-- none 

-- End Architecture 
------------------------------------------- 

end rtl;

