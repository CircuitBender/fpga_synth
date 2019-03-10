-------------------------------------------
-- Block code:  example_fsm.vhd
-- History: 	25.Nov.2012 - 1st version (dqtm)
--                 <date> - <changes>  (<author>)
-- Function: State machine to control the serial reception of 4 symbols.
--           Once a start_bit is identified (fall edge detected during idle),
--           the reception of 4 symbols is started.
--           The block also contains the buffers for the RX-symbols.
-------------------------------------------

-- Library & Use Statements
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;


-- Entity Declaration 
-------------------------------------------
ENTITY aufgabe_fsm IS
  PORT( clk,reset_n		: IN    std_logic;
		do_write		: IN	std_logic;
		data_pointer	: IN	std_logic_vector(3 downto 0);
		-- outputs to drive external memory
  		address			: OUT   std_logic_vector(7 downto 0);
		we_n			: OUT 	std_logic;
  		data2mem		: OUT   std_logic_vector(15 downto 0)
    	);
END aufgabe_fsm;


-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF aufgabe_fsm IS
-- Signals & Constants Declaration
-------------------------------------------
TYPE memwrite_state IS (idle,setAdr,setEn,setDat,holdDat); -- enumerated type
SIGNAL state, next_state: memwrite_state; -- signals with data-type memwrite_state

SIGNAL rom_idx : integer range 0 to 15; -- convert from data_pointer input

type ROM_TYPE is array (0 to 15) of std_logic_vector(15 downto 0);
constant initROM	: ROM_TYPE := (	x"FFFF", x"EEEE", x"DDDD", x"CCCC",
									x"BBBB", x"AAAA", x"9999", x"8888",
									x"7777", x"6666", x"5555", x"4444",
									x"3333", x"2222", x"1111", x"0000");

-- Begin Architecture
-------------------------------------------
BEGIN
  
  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------  
  rom_idx 	<= to_integer(unsigned(data_pointer));
  address   <= reg_addr;
  we_n    	<= reg_we_n;
  data2mem  <= reg_data2mem;

  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  regs : PROCESS(clk, reset_n)
  BEGIN	
  	IF reset_n = '0' THEN
		state 		<= idle;
		reg_addr   	<= x"00";
		reg_we_n    <= '1';
		reg_data2mem<= (others => '0');
    ELSIF rising_edge(clk) THEN
		state 		<= next_state ;
		reg_addr   	<= next_reg_addr;
		reg_we_n    <= next_reg_we_n;
		reg_data2mem<= next_reg_data2mem;
	END IF;
  END PROCESS regs;	
  
  
  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  comb: PROCESS(all)
  BEGIN	
	-- default statement
	next_reg_addr		<= reg_addr;			
	next_reg_we_n		<= '1';
	next_reg_data2mem	<= (others => 'Z');
	next_state 	  		<= state;
	
	CASE state IS
		WHEN idle =>
			IF (do_write='1') THEN
				next_state 	  <= setAdr;
				next_reg_addr <= "1010" & data_pointer; -- valid address 
			END IF;
			
		WHEN setAdr =>			
			next_state    <= setEn;
			next_reg_we_n <= '0';
			
		WHEN setEn =>			
			next_state    <= setDat;
			next_reg_we_n <= '0';
			next_reg_data2mem <= initROM(rom_idx);  -- valid data

		WHEN setDat =>			
			next_state    <= holdDat;
			-- HERE WILL DO THE MISTAKE, IF MISSING THE NEXT LINE!!
			-- next_reg_data2mem <= initROM(rom_idx);  -- valid data
			next_reg_addr <= x"00";
			
		WHEN others =>
			next_state 	<= idle;
		END CASE;
		
  END PROCESS comb;   	
  
 -- End Architecture 
------------------------------------------- 
END rtl;

