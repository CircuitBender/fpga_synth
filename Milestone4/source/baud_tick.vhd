LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

ENTITY baud_tick IS
  PORT( start_bit 		: IN    std_logic;
			clock				: IN    std_logic;
			reset_n			: IN    std_logic;
			baud_tick   	: OUT   std_logic
			);
END baud_tick;

ARCHITECTURE rtl OF baud_tick IS

SIGNAL baud_count, next_baud_count: unsigned (9 downto 0);
CONSTANT clock_freq		: natural :=	12_500_000;
CONSTANT baud_rate		: natural := 	31_250;
CONSTANT count_width		: natural := 	10;
SIGNAL one_period		: unsigned (count_width - 1 downto 0):= to_unsigned(clock_freq/baud_rate , count_width);
SIGNAL half_period		: unsigned (count_width - 1 downto 0):= to_unsigned(clock_freq/baud_rate / 2 , count_width);

BEGIN
	comb_proc : PROCESS (Start_bit,half_period,next_baud_count,one_period,baud_count)
	BEGIN 
	IF Start_bit ='1' THEN
		next_baud_count <= half_period;
	ELSIF baud_count ="0" THEN
		next_baud_count <= one_period;
	ELSE next_baud_count <= baud_count-1;
	END IF;
	END PROCESS comb_proc;
	
	reg_proc : PROCESS(clock, reset_n,baud_count, next_baud_count)
	BEGIN	
		IF reset_n = '0' THEN
			baud_count <= (OTHERS => '0');
		ELSIF (rising_edge(clock)) THEN
			baud_count <= next_baud_count;
		END IF;
	END PROCESS reg_proc;
	
	
	abc : PROCESS (baud_tick,baud_count)
	BEGIN
		IF baud_count = ("0") THEN 
			baud_tick <= '1';
		ELSE baud_tick <= '0';
		END IF;
	END PROCESS abc;


END rtl;			
		
