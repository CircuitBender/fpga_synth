LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY tb_top_max IS

END tb_top_max;

ARCHITECTURE struct OF tb_top_max IS
--------------------------
-- COMPONENT DECLARATIONS
--------------------------
COMPONENT top_max 
	PORT ( 	clk50    		: in  std_logic; 
			reset_n  		: in  std_logic;
			lcd_data  		: out std_logic_vector(7 downto 0);
			lcd_rs	 		: out std_logic;
			lcd_rw	 		: out std_logic;
			lcd_e	 		: out std_logic;
			lcd_rst	 		: out std_logic;
			tx_data	 		: in std_logic;
			test_n			: in std_logic
			);
END COMPONENT;
	
--------------------------
-- SIGNAL & CONSTANT DECLARATIONS
--------------------------		
	CONSTANT clk_halfp : time := 10 ns;
	CONSTANT baud_rate : time := 0.2083 ms; --4800 Baud
	
	SIGNAL t_clock   		: std_logic := '0';
	SIGNAL t_reset_n 		: std_logic;
	SIGNAL t_lcdData 		: std_logic_vector(7 downto 0);
	SIGNAL t_lcdRS	 		: std_logic;
	SIGNAL t_lcdRW	 		: std_logic;
	SIGNAL t_lcdE	 		: std_logic;
	SIGNAL t_lcd_reset	 	: std_logic;
	SIGNAL parallel_word	: std_logic_vector(7 downto 0);
	SIGNAL tx_data		 	: std_logic;
	SIGNAL test_n		 	: std_logic;
	
	type SERIAL_TYPE is array (0 to 15) of std_logic_vector(7 downto 0);
constant serial_data			: SERIAL_TYPE := (	x"24",	-- 0x24
													x"47",	-- 0x47
													x"50",	-- 0x50
													x"47",	-- 0x47
													x"47",	-- 0x47
													x"41",	-- 0x41
													x"2c", -- 0x2c
													x"12", -- h
													x"34", -- h
													x"56", -- min
													x"78", -- min
													x"9a", -- sec
													x"bc", -- sec
													x"de", -- dummy
													x"f0", -- dummy
													x"12"); -- dummy
													
--signal serial_pointer	: integer range 0 to SERIAL_TYPE'high;									
	
	
BEGIN
--------------------------
-- DUT INSTANTIATION
--------------------------	
	dut_top_max: top_max
		PORT MAP(
		   clk50      	=> t_clock,
		   reset_n    	=> t_reset_n,
		   lcd_data 	=> t_lcdData,
		   lcd_rs      	=> t_lcdRS,
		   lcd_rw      	=> t_lcdRW,
		   lcd_e       	=> t_lcdE,
		   lcd_rst		=> t_lcd_reset,
		   test_n		=> test_n,
		   tx_data		=> tx_data);
		   
--------------------------
-- CLK GENERATION PROCESS
--------------------------	
	clkgen 	: PROCESS
	BEGIN
      WAIT FOR 1*clk_halfp;
      t_clock <= not(t_clock);
    END PROCESS clkgen;

--------------------------
-- STIMULI & CHECK PROCESS
--------------------------	
stimuli: process
	begin
	wait for 2*clk_halfp ;
	t_reset_n <= '0'; 		-- RESET ON
	wait for 10*clk_halfp;
	t_reset_n <= '1';			-- RESET OFF
	wait for 1000000*clk_halfp;
	assert (false) report " --- TESTBENCH NOT AUTOMATIC, NEED VISUAL CHECK!! ---" severity warning;
	wait;
  END process;	
  
	test_n <= '1'; 
  
dummy_data: process
VARIABLE v_parallel_word	: std_logic_vector(7 downto 0);

	begin
	tx_data <= '1';
	for serial_pointer in 0 to 15 loop
		wait for 10*baud_rate;
		v_parallel_word := serial_data(serial_pointer);
		    wait for baud_rate;
			tx_data <= '0'; -- Start Bit
			wait for baud_rate;
			for bit_pointer in 0 to 7 loop
				tx_data <= v_parallel_word(bit_pointer);
				wait for baud_rate;
    		end loop;
    		tx_data <= '1'; -- Stop Bit
    end loop;
    end process;

END struct; 




