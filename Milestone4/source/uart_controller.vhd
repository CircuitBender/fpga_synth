library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity uart_controller is
  port(uart_controller_i : in  std_logic;
       fall_edge         : in  std_logic;
       clock             : in  std_logic;
       reset_n           : in  std_logic;
       parallel_in       : in  std_logic_vector(7 downto 0);
       start_bit_o       : out std_logic;
       data_valid_o      : out std_logic;
       shift_enable      : out std_logic
       );
end uart_controller;

architecture rtl of uart_controller is

  signal bit_count, next_bit_count   : unsigned (3 downto 0);
  type uart_state_type is (idle, prepare_rx, Wait_rx_byte, Check_rx);
  signal uart_state, next_uart_state : uart_state_type;

begin
  comb_proc : process (uart_state, next_uart_state, fall_edge, bit_count)
  begin
    next_uart_state <= uart_state;
    case uart_state is
      when idle =>
        if fall_edge = '1' then next_uart_state <= prepare_rx;
        end if;
      when prepare_rx => next_uart_state <= wait_rx_byte;
      when Wait_rx_byte =>
        if bit_count = "0" then next_uart_state <= check_rx;
        end if;
      when CHeck_rx => next_uart_state <= idle;
    end case;
  end process comb_proc;


  Bit_count_p : process (all)
  begin
    if uart_state = prepare_rx then
      next_bit_count <= to_unsigned (8, 4);
    elsif bit_count > 0 and uart_controller_i = '1' then
      next_bit_count <= bit_count -1;
    else next_bit_count <= bit_count;
    end if;
  end process BIT_count_p;


  uart_fsm : process (all)
  begin
    start_bit_o  <= '0';
    shift_enable <= '0';
    data_valid_o <= '0';
    case uart_state is
      when prepare_rx => start_bit_o <= '1';
      when wait_rx_byte =>
        if uart_controller_i = '1' then shift_enable <= '1';
        end if;
      when check_rx =>
        if parallel_in(0) <= '0' and parallel_in (7) <= '1'
        then data_valid_o <= '1';
        end if;
      when others => null;
    end case;
  end process uart_fsm;

  reg_proc : process (all)
  begin
    if reset_n = '0' then
      uart_state <= idle;
      bit_count  <= (others => '0');
    elsif (rising_edge(clock)) then
      uart_state <= next_uart_state;
      bit_count  <= next_bit_count;
    end if;
  end process reg_proc;


end rtl;
