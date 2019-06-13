-------------------------------------------------------------------------------
-- File       : midi_cntroller.vhd
-- Authors    : rutiscla
-- Created    : 21.05.19
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- History    :
-- Date       Author    Description
-- 21.05.19   rutiscla  
------------------------------------------------------------------------------

-- Library & Use Statements
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tone_gen_pkg.all;

-------------------------------------------------------------------------------

entity midi_controller is
  port (
    clk_12m        : in  std_logic;
    reset_n        : in  std_logic;
    rx_data        : in  std_logic_vector(7 downto 0);
    rx_data_valid  : in  std_logic;
    reg_note_on_o  : out std_logic_vector(9 downto 0);	
    reg_note_o     : out t_tone_array;
    reg_velocity_o : out t_tone_array);


end entity midi_controller;

-------------------------------------------------------------------------------

architecture rtl of midi_controller is

  ----------------------------------------
  --State Machine codec automat type definition
  ----------------------------------------
  type midi_states_fsm is (wait_status, wait_data1, wait_data2);
  signal midi_state      : midi_states_fsm;
  signal midi_next_state : midi_states_fsm;

  signal new_data_flag, next_new_data_flag : std_logic;
  signal data1_reg, next_data1_reg         : std_logic_vector(6 downto 0);
  signal data2_reg, next_data2_reg         : std_logic_vector(6 downto 0);
  signal status_reg, next_status_reg       : std_logic_vector(3 downto 0);

  constant SET_NOTE : std_logic_vector(3 downto 0) := "1001";
  constant DEL_NOTE : std_logic_vector(3 downto 0) := "1000";

  signal reg_note, next_reg_note         : t_tone_array;
  signal reg_velocity, next_reg_velocity : t_tone_array;
  signal reg_note_on, next_reg_note_on   : std_logic_vector(9 downto 0);

 -- type t_tone_array is array (0 to 9) of std_logic_vector(6 downto 0);

-- Begin Architecture
begin

  ------------------------------------------- 
  -- Process for State Machine codec automat
  -------------------------------------------
  state_controller : process(all)
  begin
    midi_next_state    <= midi_state;
    next_data1_reg     <= data1_reg;
    next_data2_reg     <= data2_reg;
    next_status_reg    <= status_reg;
    next_new_data_flag <= '0';

    case midi_state is
      when wait_status =>
        if rx_data(7) = '1' and rx_data_valid = '1' then   
          next_status_reg <= rx_data(7 downto 4);
          midi_next_state <= wait_data1;
        elsif rx_data(7) = '0'and rx_data_valid = '1' then 
          next_data1_reg  <= rx_data(6 downto 0);
          midi_next_state <= wait_data2;
        end if;

      when wait_data1 =>
         if rx_data(7) = '0' and rx_data_valid = '1' then 
          next_data1_reg  <= rx_data(6 downto 0);
          midi_next_state <= wait_data2;
        end if;

      when wait_data2 =>
        if rx_data(7) = '0' and rx_data_valid = '1' then 
          next_data2_reg     <= rx_data(6 downto 0);
          next_new_data_flag <= '1';
          midi_next_state    <= wait_status;
        end if;

      when others =>
        midi_next_state <= wait_status;
    end case;

  end process state_controller;

  -------------------------------------------
  -- Ausgangslogik für die verschiedenen DDS 
  -------------------------------------------
  array_logic : process(all)
    variable note_available : std_logic := '0';
	variable note_written : std_logic:= '0';

  begin
    next_reg_note     <= reg_note;
    next_reg_velocity <= reg_velocity;
    next_reg_note_on  <= reg_note_on;

    if new_data_flag = '1' then
      note_available := '0';
	  note_written:='0';

      -- Check if note is already exists in registers
      for i in 0 to 9 loop
        if reg_note(i) = data1_reg and reg_note_on(i) = '1' then
          note_available := '1';          -- Found a matching note
          if status_reg = DEL_NOTE or (status_reg = SET_NOTE and data2_reg = "0000000") then
            next_reg_note_on(i)  <= '0';  -- Turn note off
            next_reg_velocity(i) <= data2_reg;
          end if;
        end if;
      end loop;

      -- Note does not exist -> find empty register
      if note_available = '0' then
        for i in 0 to 9 loop
          if status_reg = SET_NOTE and (reg_note_on(i) = '0' or i = 9) then
            next_reg_note(i)     <= data1_reg;
            next_reg_velocity(i) <= data2_reg;
            next_reg_note_on(i)  <= '1';
            note_written         := '1';
            exit;                       -- Exit loop
          end if;
        end loop;
       end if;
     
    end if;
  end process array_logic;
  
    ------------------------------------------- 
  -- Process for registers (flip-flops)
  -------------------------------------------
  clk_proc : process(all)
  begin
    if reset_n = '0' then
      midi_state  <= wait_status;
      reg_note_on <= (others => '0');
      for i in 0 to 9 loop
        reg_note(i)     <= (others => '0');
        reg_velocity(i) <= (others => '0');
      end loop;
    elsif rising_edge(clk_12m) then
      midi_state    <= midi_next_state;
      data1_reg     <= next_data1_reg;
      data2_reg     <= next_data2_reg;
      status_reg    <= next_status_reg;
      new_data_flag <= next_new_data_flag;
      reg_note      <= next_reg_note;
      reg_velocity  <= next_reg_velocity;
      reg_note_on   <= next_reg_note_on;
    end if;
  end process clk_proc;


  -------------------------------------------
  -- Concurrent Assignements
  -------------------------------------------
  reg_note_o     <= reg_note;
  reg_note_on_o  <= reg_note_on;
  reg_velocity_o <= reg_velocity;

end architecture rtl;

-------------------------------------------------------------------------------
