----------------------------------------------------
-- Timer for DTP2 FS13 Mitte-Sem Exam
-- dqtm 18.Apr.2013
----------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY timer IS
PORT( 	clk,rst_n	: IN   	std_logic;
		start_pulse	: IN	std_logic;
		enable		: IN	std_logic;
		ready		: OUT  	std_logic
);
END timer;

ARCHITECTURE rtl of timer is 
	signal count, next_count: 		unsigned(3 downto 0);	 
	
BEGIN
  	
	comb_timer : PROCESS (count, start_pulse, enable)
  	BEGIN
		IF enable = '0' THEN
			next_count <= count;
		ELSIF start_pulse = '1' THEN
			next_count <= to_unsigned(15,4); 
		ELSIF count > 0 THEN 
			next_count <= count-1;
		ELSE
			next_count <= to_unsigned(0,4);
		END IF;
		
		IF count = 0 THEN
			ready <= '1';
		ELSE
			ready <= '0';
		END IF;
	END PROCESS comb_timer;   
 
  	reg_timer : PROCESS (clk, rst_n)
  	BEGIN	
    	IF rst_n = '0' THEN
      		count <= (OTHERS => '0');
    	ELSIF rising_edge(clk) THEN
      		count <= next_count;
    	END IF;
  	END PROCESS reg_timer;

	
END architecture rtl;



