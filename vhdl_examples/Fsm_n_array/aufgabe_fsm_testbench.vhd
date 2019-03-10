-------------------------------------------
-- Block code:  aufgabe_fsm_testbench.vhd
-- History: 	26.Jan.2014 - 1st version (dqtm)
--				24.Apr.2016 - adapted for exam in FS16
--                 <date> - <changes>  (<author>)
-- Function: Testbench for exercise with driver for external memory
--           
-------------------------------------------

-- Library & Use Statements
LIBRARY ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration 
ENTITY aufgabe_fsm_testbench IS
  
END aufgabe_fsm_testbench ;


-- Architecture Declaration 
ARCHITECTURE struct OF aufgabe_fsm_testbench IS
	
	COMPONENT aufgabe_fsm 
	PORT( clk,reset_n	: IN    std_logic;
		do_write		: IN	std_logic;
		write_pointer	: IN	std_logic_vector(3 downto 0);
		write_done		: OUT	std_logic;
		-- outputs to drive external memory
  		address			: OUT   std_logic_vector(7 downto 0);
		we_n			: OUT 	std_logic;
  		data2mem		: OUT   std_logic_vector(15 downto 0)
    	);
	END COMPONENT aufgabe_fsm;
			
		-- Signals & Constants Declaration 
	SIGNAL tb_clock 		: std_logic;
	SIGNAL tb_rst_n 		: std_logic;
	SIGNAL tb_do_write 		: std_logic;
	SIGNAL tb_write_pointer : std_logic_vector(3 downto 0);
	SIGNAL tb_write_done	: std_logic;
	SIGNAL tb_address 		: std_logic_vector(7 downto 0);	
	SIGNAL tb_we_n 			: std_logic;
	SIGNAL tb_data2mem 		: std_logic_vector(15 downto 0);
	
	CONSTANT CLK_HALFP 		: time := 500 ns;
	CONSTANT Tsetup			: time := 300 ns;
	CONSTANT Thold			: time := 200 ns;
	
	CONSTANT INVALID_ADDR	: std_logic_vector(7 downto 0) := (OTHERS => 'Z');
	CONSTANT INVALID_DATA	: std_logic_vector(15 downto 0) := (OTHERS => 'Z');
	
	-- Added to be able to track internal signal from FSM (using external name feature)
	TYPE memwrite_state IS (idle,setAdr,setEn,setDat,holdDat); -- enumerated type

	
BEGIN
  
  DUT: aufgabe_fsm
  PORT MAP (
		clk 			=> 	tb_clock,
		reset_n			=> 	tb_rst_n,
		do_write		=>	tb_do_write,
		write_pointer	=>	tb_write_pointer,
		write_done		=>	tb_write_done,
		address			=>	tb_address,
		we_n			=>	tb_we_n,
		data2mem		=>	tb_data2mem
		);
		
generate_clock: PROCESS
BEGIN
	tb_clock <= '1';
	wait for CLK_HALFP;	
	tb_clock <= '0';
	wait for CLK_HALFP;
END PROCESS generate_clock;
	
stimuli: PROCESS
BEGIN
	-- initialise all inputs & pulse reset
	tb_do_write			<= '0';
	tb_write_pointer	<= (OTHERS => 'Z');
	tb_rst_n			<= '0';
	wait for 4*CLK_HALFP;
	wait until falling_edge(tb_clock);	
	tb_rst_n			<= '1';
	wait for 4*CLK_HALFP;
	
	-- pulse do_write : 1st time
	wait until rising_edge(tb_clock);
	tb_do_write			<= '1';
	tb_write_pointer	<= "0111";
	wait for 2*CLK_HALFP;	
	tb_do_write			<= '0';
	tb_write_pointer	<= (OTHERS => 'Z');
	-- HERE 1st WRITE ACCESS  SHOULD START!!
	
	-- pulse do_write : 2nd time
	wait until rising_edge(tb_write_done);
	wait until rising_edge(tb_clock); 	
	tb_do_write			<= '1';
	tb_write_pointer	<= "0101";
	wait for 2*CLK_HALFP;	
	tb_do_write			<= '0';
	tb_write_pointer	<= (OTHERS => 'Z');
	-- HERE 2nd WRITE ACCESS  SHOULD START!!
	
	wait;
END PROCESS stimuli;
	
	
check: PROCESS
	variable we_n_fall_time  : time;
	variable we_interval_time  : time;
BEGIN
	-- wait for start of write access to external memory
	wait until (<<signal DUT.state:memwrite_state>> = setAdr);
	--wait for 2 ns;  -- delay for toggling output signal
	
	-- ===================================
	-- Check-1 Verify tsetup
	wait until falling_edge(tb_we_n) for 3*CLK_HALFP;
	we_n_fall_time := now;  -- for check tcycle below
	
	wait on tb_data2mem;
	ASSERT (tb_data2mem /= INVALID_DATA) 
		report "Check-1A: Expected valid data ! " 
		severity error;
	wait for Tsetup;
	ASSERT (tb_we_n='0') report "Check-1B: Expected we_n='0' . Tsetup violated"  severity error;
	
	-- ===================================	
	-- Check-2 Verify thold
	wait until rising_edge(tb_we_n);
	wait for Thold;
	ASSERT (tb_data2mem /= INVALID_DATA) 
		report "Check-2: Expected valid data. Thold violated ! " 
		severity error;
	
	-- ===================================	
	-- Check-2 Verify tcycle
	wait until falling_edge(tb_we_n);
	we_interval_time := now - we_n_fall_time;
	assert (we_interval_time >= 5 us) report "Check-2D: Cycle time less than 5us . Tcycle violated"  severity error;
	
	
	-- ===================================	
	wait for 22 * CLK_HALFP; 
	assert false report "All tests passed!" severity failure;
	END PROCESS check;
	
	
  
END struct;

