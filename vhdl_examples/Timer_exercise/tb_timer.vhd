-------------------------------------
-- Testbench zur Timer Aufgabe
-- Block-DUT timer
-- for Mitte-Semester exam FS13 _ dqtm 18.April.2013
-------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY tb_timer IS 	
		-- Keine Ports
END tb_timer;

ARCHITECTURE behaviour of tb_timer is 

	COMPONENT timer 
	PORT( 	clk,rst_n	: IN   	std_logic;
			start_pulse	: IN	std_logic;
			enable		: IN	std_logic;
			ready		: OUT  	std_logic);
	END COMPONENT;
	
	SIGNAL t_clk, t_rst_n:	std_logic; -- testbench Interne Signale
	SIGNAL t_start_pulse:	std_logic;
	SIGNAL t_enable:		std_logic;
	SIGNAL t_ready:			std_logic;

	CONSTANT	clk_halbper: 		time := 100 ns;

begin
	dut : timer
		PORT MAP(
		clk			=> 	t_clk,
		rst_n		=> 	t_rst_n,
		start_pulse	=> 	t_start_pulse,
		enable 		=> 	t_enable,
		ready 		=> 	t_ready );

	clock_gen: PROCESS 		-- Periodisches Taktsignal
	BEGIN
		t_clk <= '0'; 
		wait for clk_halbper;
		t_clk <= '1'; 
		wait for clk_halbper;
	END PROCESS clock_gen;
	
	
	STIMULI: process		-- Abfolge für Eingänge und Checks 
	begin
		-- reset active, other inputs initialised
		t_rst_n  		<= '0';	
		t_start_pulse 	<= '0'; 	
		t_enable 		<= '1';		wait for 4*clk_halbper;
		-- check reset value
		assert (t_ready = '1') report "expected ready='1' as reset value"  severity error;
		
		-- Test-1: reset disactive, wait clock rise and generate start pulse
		t_rst_n 		<= '1';		wait until t_clk = '1'; 
		t_start_pulse 	<= '1';		wait for 2*clk_halbper;
		t_start_pulse 	<= '0';		wait for 1*clk_halbper;
		-- check load value
		assert (t_ready = '0') report "expected ready='0' after load"  severity error;
			
		-- Test-2: check freeze when enable goes down
									wait for 10*clk_halbper;
		t_enable 		<= '0';		wait for 6*clk_halbper;							
		t_enable 		<= '1';		wait for 20*clk_halbper;	
		assert (t_ready = '1') report "expected ready='1' when countdown done"  severity error;
		
									wait for 2*clk_halbper;
		-- can continue to test further scenarios
		-- when finished...
		assert false report " --- ALL TESTS PASS ---" severity failure;

	end process STIMULI;

end BEHAVIOUR;

