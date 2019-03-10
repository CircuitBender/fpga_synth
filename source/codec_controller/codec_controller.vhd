-------------------------------------------------------------------------------
-- Title      : codec_controller
-- Project    : DTP2 Synthesizer Projekt
-------------------------------------------------------------------------------
-- File       : codec_controller.vhd
-- Author     : <Heinzen> Marco Heinzen (heinzma2@students.zhaw.ch)
-- Company    :ZHAW
-- Created    : 2019-03-08
-- Platform   : Windows 10
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: controller block for the audio codec
-------------------------------------------------------------------------------
-- Copyright (c) 2019
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  	Description
-- 2018-03-08  1.0     	Heinzen 	Created
-- 2018-03-09  1.1      Heinzen 	comments added
-------------------------------------------------------------------------------

-- Library & Use Statements
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all; -- standard lib
USE ieee.numeric_std.all; -- standard lib
use work.reg_table_pkg.all; -- predifined registry with bits set for different audio applications

-- Entity Declaration
-------------------------------------------
-- codec controller prestatement: codec controller receives 3 switches via sw_sync_i (3bit bus) 
-- depending on the switch combination, different codec presets are loaded via i2c
-- the fsm state machine controls the i2c bus and loads the preset and decides if the acknowledge bit is correctly set
-- / if the communication was succesfull


entity codec_controller is

	PORT (
		sw_sync_i	:	in std_logic_vector(2 downto 0); -- input for the switches
		initialize_i	:	in std_logic; -- input for initialisation
		write_done_i	: 	in std_logic; -- input if writing is done
		ack_error_i		:	in std_logic; -- acknowledge bit error input
		clk				:	in std_logic; -- system clock input (50 MHz)
		reset_n			: 	in std_logic; -- reset input for reseting the fsm to idle and outputs to '0'
		write_o			:	out std_logic; --serial write output
		mute_o			:	out std_logic; -- mute output
		write_data_o	: 	out std_logic_vector(15 downto 0)); -- 16bit write output vector with address and data bits

END codec_controller;


-- Architecture
-------------------------------------------
ARCHITECTURE rtl OF codec_controller IS
-- Types
TYPE	codec_status	is	(idle, prepare, startWrite, waitAck);

-- Signals
SIGNAL currentStat		 :	codec_status; -- signal: state of fsm machine
SIGNAL nextStat			 :	codec_status; -- signal: next state of the fsm machine
SIGNAL count		   	 : 	unsigned(6 downto 0); -- signal: 7bit count register
SIGNAL nextcount	 	 : 	unsigned(6 downto 0); -- signal: next 7bit count register
SIGNAL event_control       :	std_logic_vector(2 downto 0); -- signal: event_control register consist of the 3bit switches input
SIGNAL next_event_control  :	std_logic_vector(2 downto 0); -- signal: next_event_control next rei^gister 3bit switches
SIGNAL write_data_buffer : std_logic_vector(15 downto 0); -- signal: write output buffer register
SIGNAL next_write_data_buffer : std_logic_vector(15 downto 0); -- signal: next write output buffer register

BEGIN


	-- Process for FSM and count
	clocked : PROCESS(clk, reset_n, nextStat)
	BEGIN
		-- Reset for Counter, Output and FSM , override with '0'
		IF reset_n = '0' THEN
			currentStat <= idle;
			event_control <= (OTHERS => '0');
			count <= (OTHERS => '0');
			write_data_buffer <= (OTHERS => '0');
		
		-- on rising edge states are shifted and count is increased
		ELSIF rising_edge(clk) THEN
			currentStat <= nextStat;
			count <= nextcount;
			event_control <= next_event_control;
			write_data_buffer <= next_write_data_buffer;
		END IF;

	END PROCESS clocked;

	
	-- Process for sending data to i2c master
	sendparallel : PROCESS (ALL)
	BEGIN
	-- Default Statements
	nextStat <= currentStat;
	nextcount <= count;
	next_event_control <= event_control;
	next_write_data_buffer <= write_data_buffer;
	write_o <= '0';

	CASE currentStat IS
	WHEN idle => -- default state
		next_event_control <= sw_sync_i;
		IF initialize_i = '0' THEN -- change state to prepare if initialize_i signal is '1'
			nextStat <= prepare;
			CASE event_control IS -- set array entry to 9
				WHEN "000" => nextcount <= to_unsigned(9,7);
				WHEN "001" => nextcount <= to_unsigned(9,7);
				WHEN "010" => nextcount <= to_unsigned(9,7);
				WHEN "011" => nextcount <= to_unsigned(9,7);
				WHEN "100" => nextcount <= to_unsigned(9,7);
				WHEN OTHERS => nextStat <= idle;
			END CASE;
		END IF;

	WHEN prepare =>
		nextStat <= startWrite;
		-- writing data in output register
		CASE event_control IS	-- switch between different stored commands
			WHEN "000" => next_write_data_buffer <= std_logic_vector(count) & C_W8731_ANALOG_BYPASS(to_integer(count));
			WHEN "001" => next_write_data_buffer <= std_logic_vector(count) & C_W8731_ANALOG_MUTE_RIGHT(to_integer(count));
			WHEN "010" => next_write_data_buffer <= std_logic_vector(count) & C_W8731_ANALOG_MUTE_LEFT(to_integer(count));
			WHEN "011" => next_write_data_buffer <= std_logic_vector(count) & C_W8731_ANALOG_MUTE_BOTH(to_integer(count));
			WHEN "100" => next_write_data_buffer <= std_logic_vector(count) & C_W8731_ADC_DAC_0DB_48K(to_integer(count));

			WHEN OTHERS =>
				nextStat <= idle;
				nextcount <= (OTHERS => '0');
		END CASE;

	-- start sending data
	WHEN startWrite =>
		write_o <= '1';
		nextStat <= waitAck;

	-- wait till data are received
	WHEN waitAck =>
		IF (write_done_i = '1') THEN -- sending next data package
			IF (count = 0) THEN -- go to idle if all data is sent
				nextStat <= idle;
				next_write_data_buffer <= (OTHERS => '0');
			ELSE
				nextStat <= prepare;
				nextcount <= count -1; -- reduce count by 1
			END IF;
		ELSIF (ack_error_i = '1') THEN -- resending data if error is received
			nextStat <= prepare;
		END IF;

	WHEN OTHERS =>
		nextStat <= idle;

	END CASE;
	END PROCESS;

	-- outputs
	write_data_o <= write_data_buffer;


END ARCHITECTURE;
