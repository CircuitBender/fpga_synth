

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY shiftreg_s2p_i2s IS
	PORT (
		clk		 		: 	IN std_logic;
		reset_n 		: 	IN std_logic;
		enable_i		:	IN std_logic; 			--BCLK
		ser_i			:	IN std_logic;
		shift_i			:	IN std_logic;			--Shift l/r
		par_o 			: 	OUT std_logic_vector(15 downto 0)
	);
END shiftreg_s2p_i2s;


ARCHITECTURE rtl OF shiftreg_s2p_i2s IS
	
	SIGNAL shiftreg 		:std_logic_vector (15 downto 0);
	SIGNAL next_shiftreg	:std_logic_vector (15 downto 0);
	SIGNAL enable 			:std_logic;

BEGIN

 --concurrent Statement
  par_o <= shiftreg; 
 
 enable_logic: PROCESS (enable_i, shift_i)
 
 begin
 
	if enable_i = '0' and shift_i = '1' THEN
	enable <= '1';
	
	end if;
 
 end process enable_logic;
  --------------------------------------------------
  -- PROCESS FOR COMB-INPUT LOGIC
  --------------------------------------------------
  comblogic : PROCESS (all)
  BEGIN
  	-- Default Statement
  	next_shiftreg <= shiftreg;
	
	if enable = '1' THEN
	  next_shiftreg (15 downto 0)<= shiftreg(14 downto 0) & ser_i;
	  
	end if;
	 
  	
  END PROCESS comblogic;
 
 
 
  PROCESS (all)
  BEGIN
	if reset_n = '0' then
	shiftreg <= (others => '0');
  		
  	elsif rising_edge(clk) THEN
  		shiftreg <= next_shiftreg;
  	END IF;
  END PROCESS;
  
 
  
  END rtl;
