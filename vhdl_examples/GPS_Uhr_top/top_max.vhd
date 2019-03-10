-- Description:
-- Top Level for Mapping into MaxII CPLD
-- for different entities under test
-- History:
-- 15.Jan.2009 : 1st version M.Q.Tavares _ ZHAW

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.gps_uhr_pkg.all;


ENTITY top_max IS
	PORT ( 	clk50    : in  std_logic; 
			reset_n  : in  std_logic;
			lcd_data  : out std_logic_vector(7 downto 0);
			lcd_rs	 : out std_logic;
			lcd_rw	 : out std_logic;
			lcd_e	 : out std_logic;
			lcd_rst 	: out std_logic;
			tx_data	 	: in std_logic;
			test_n		: in std_logic;
			pbres		:	out std_logic;
			led1_out : out std_logic;
            led2_out : out std_logic;
            led3_out : out std_logic;
            led4_out : out std_logic;
            led5_out : out std_logic;
            led6_out : out std_logic;
            led7_out : out std_logic;
            led8_out : out std_logic);
END top_max;

ARCHITECTURE struct OF top_max IS
--------------------------
-- COMPONENT DECLARATIONS
--------------------------
COMPONENT baudperiod

GENERIC ( baud_factor		: positive);
  PORT(
    clk     	  : IN    std_logic;
    reset   	  : IN    std_logic;
    sync_baud     : IN    std_logic;
    baud_pulse    : OUT   std_logic
    );
END COMPONENT;

COMPONENT uart
  PORT(
  		clk	    			: IN		std_logic;  	
  		reset				: IN		std_logic;
  		d					: IN		uart_in_type;
  		q					: OUT    	uart_out_type
    	);
END COMPONENT;

COMPONENT detector
    PORT(
  		clk	    			: IN		std_logic;
  		reset   			: IN		std_logic;  	
  		d					: IN		uart_out_type;
  		q					: OUT    	detector_out_type
        );
END COMPONENT;

COMPONENT LCDDriver
	GENERIC( tickNum		: positive);
	PORT (	 clk			: in		std_logic;
			 reset			: in		std_logic;
			 dIn			: in		std_logic_vector(7 downto 0);
			 charNum		: in		std_logic_vector(6 downto 0);
			 wEn			: in		std_logic;
			 lcdData		: out		std_logic_vector(7 downto 0);
			 lcdRS			: out		std_logic;
			 lcdRW			: out		std_logic;
			 lcdE			: out		std_logic);
END COMPONENT;

COMPONENT display_controll
  PORT(
  		clk	    			: IN		std_logic;  	
  		reset				: IN		std_logic;
  		baud_pulse			: IN		std_logic;
  		gps_time			: IN    	detector_out_type;
  		test_n				: IN		std_logic;
    	wen					: OUT   	std_logic;
		d_in				: OUT		std_logic_vector(7 downto 0);
		charNum				: OUT		std_logic_vector(6 downto 0)
    	);
END COMPONENT;


--------------------------
-- SIGNAL & CONSTANT DECLARATIONS
--------------------------		
	CONSTANT Low : std_logic := '0';
    CONSTANT High : std_logic := '1';  
    CONSTANT m_tickNum : positive := 500;
    constant c_baud_factor : positive := 5209;

	SIGNAL reset   : std_logic;
	SIGNAL uart_out: uart_out_type;
	SIGNAL uart_in: uart_in_type;
	
	-- For debug
	SIGNAL m_lcdData : std_logic_vector(7 downto 0);
	SIGNAL m_lcdRS   : std_logic;
	SIGNAL m_lcdRW   : std_logic;
	SIGNAL m_lcdE    : std_logic;
	
	SIGNAL wen			: std_logic;
	SIGNAL d_in			: std_logic_vector(7 downto 0);
	SIGNAL charnum		: std_logic_vector(6 downto 0);
	SIGNAL sync_baud    : std_logic;
    SIGNAL baud_pulse   : std_logic;
    SIGNAl gps_time		: detector_out_type;

	
BEGIN
--------------------------
-- COMPONENT INSTANTIATION
--------------------------	

u_baudperiod : baudperiod

 GENERIC MAP(
 	baud_factor		=> c_baud_factor)
 	
PORT MAP(
 	clk     	  	=> clk50,
    reset   	  	=> reset,
    sync_baud     	=> sync_baud,
    baud_pulse    	=> baud_pulse);
    
u_uart : uart
  PORT MAP(
  		clk => clk50,
  		reset => reset,
  		d.tx_data => tx_data,
  		d.baud_pulse => baud_pulse,
  		q => uart_out
    	);

u_detector : detector

    PORT MAP(
  		clk => clk50,
  		reset => reset,
  		q => gps_time,
  		d => uart_out
        );

u_lcddriver: lcddriver
	GENERIC MAP(
		tickNum   => m_tickNum)
	PORT MAP(
	   clk        => clk50,
	   reset      => reset,
	   dIn		  => d_in,	
	   charNum	  => charnum,		
	   wEn		  => wen,	
	   lcdData	  => m_lcdData,
	   lcdRS	  => m_lcdRS,
	   lcdRW	  => m_lcdRW,
	   lcdE		  => m_lcdE);
	   
u_display_controll: display_controll
  PORT MAP(
  		clk	    		=>  clk50,
  		reset			=>	reset,
  		gps_time		=>  gps_time,
    	wen				=> wen,
    	test_n			=> test_n,
		d_in			=> d_in,
		charNum			=> charnum,
		baud_pulse		=> baud_pulse
    	);
	   

--------------------------
-- OUTPUT COMB LOGIC
--------------------------	
-- not used


--------------------------
-- Concurrent assignements
--------------------------		
-- Outputs:
lcd_data   <= m_lcdData;     
lcd_rs     <= m_lcdRS;     
lcd_rw    <= m_lcdRW;      
lcd_e      <= m_lcdE;
lcd_rst    <= reset_n;

-- Inputs:
reset    <= NOT(reset_n);

-- DEBUG
led1_out   <= reset_n;
led2_out   <= m_lcdRW;
led3_out   <= m_lcdRS;
led4_out   <= m_lcdE;
led5_out   <= wen;
led6_out   <= m_lcdData(6);
led7_out   <= m_lcdData(5);
led8_out   <= m_lcdData(4);
sync_baud  <= uart_out.frame_start;
pbres		<= '1'; -- Reset is low active : GPS-RX-Modul Reset

END struct; 
