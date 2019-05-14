-------------------------------------------
-- Block code:  modulo_divider.vhd
-- History: 	14.Nov.2012 - 1st version (dqtm)
--                 <date> - <changes>  (<author>)
-- Function: modulo divider with generic width. Output MSB with 50% duty cycle.
--		Can be used for clock-divider when no exact ratio required.
-------------------------------------------

-- Library & Use Statements
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


-- Entity Declaration 
-------------------------------------------
ENTITY shiftreg_s2p IS
GENERIC (width		: positive  := 8 );
  PORT( clk,reset_n,enable_i,ser_i	: 	IN    std_logic;
			par_o 				:	OUT		std_logic_vector (7 downto 0)
			);
END shiftreg_s2p;


-- Architecture Declaration?
-------------------------------------------
ARCHITECTURE rtl OF shiftreg_s2p IS
-- Signals & Constants Declaration?
-------------------------------------------
signal shift_reg, next_shift_reg: std_logic_vector(7 downto 0);	 


-- Begin Architecture
-------------------------------------------
BEGIN
  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  comb_logic: PROCESS(shift_reg)
  BEGIN	
	-- increment	
	IF enable_i = '1' THEN 
	next_shift_reg <= ser_i & shift_reg (7	downto 1) ;
	ELSE 
	next_shift_reg <= shift_reg;
	END IF ;
  END PROCESS comb_logic;   
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : PROCESS(clk, reset_n)
  BEGIN	
  	IF reset_n = '0' THEN
		shift_reg <=(OTHERS=>'0');
    ELSIF rising_edge(clk) THEN
		shift_reg <= next_shift_reg ;
    END IF;
  END PROCESS flip_flops;		
  
  
  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  -- take MSB and convert for output data-type
  output: PROCESS (ALL)
  BEGIN
	IF enable_i= '0' THEN
	par_o <= shift_reg;
	ELSE
	par_o <= "00000000";
	END IF;
	End Process Output;
  
  
 -- End Architecture 
------------------------------------------- 
END rtl;

