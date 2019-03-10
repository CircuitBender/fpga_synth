-------------------------------------------
-- Block code:  aufgabe_fsm.vhd
-- History: 	25.Nov.2012 - 1st version (dqtm)
--				24.Apr.2016 - adapted for aufgabe fsm in FS16
--                 <date> - <changes>  (<author>)
-- Function: FSM driving write access to external memory
--
-------------------------------------------

-- Library & Use Statements
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


-- Entity Declaration 
-------------------------------------------
ENTITY aufgabe_fsm IS
  PORT( clk,reset_n		: IN    std_logic;
		do_write		: IN	std_logic;
		write_pointer	: IN	std_logic_vector(3 downto 0);
		write_done		: OUT	std_logic;
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

SIGNAL next_rom_idx, rom_idx : integer range 0 to 15; -- convert from write_pointer input

type ROM_DATA_TYPE is array (0 to 15) of std_logic_vector(15 downto 0);
constant initROM_data: ROM_DATA_TYPE := (	x"FFFF", x"EEEE", x"DDDD", x"CCCC",
											x"BBBB", x"AAAA", x"9999", x"8888",
											x"7777", x"6666", x"5555", x"4444",
											x"3333", x"2222", x"1111", x"0000");

type ROM_ADDR_TYPE is array (0 to 15) of std_logic_vector(7 downto 0);
constant initROM_addr: ROM_ADDR_TYPE := (	x"F0", x"F1", x"F2", x"F3",
											x"F4", x"F5", x"F6", x"F7",
											x"F8", x"F9", x"FA", x"FB",
											x"FC", x"FD", x"FE", x"FF");


											
											
-- Begin Architecture
-------------------------------------------
BEGIN
  
  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------  

  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  regs : PROCESS(clk, reset_n)
  BEGIN	
  	IF reset_n = '0' THEN
		state 		<= idle;
		rom_idx   	<= 0;
    ELSIF rising_edge(clk) THEN
		state 		<= next_state ;
		rom_idx   	<= next_rom_idx;
	END IF;
  END PROCESS regs;	
  
  
  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  comb: PROCESS(all)
  BEGIN	
	-- default statement for FF inputs
	next_state 	  	<= state;
	next_rom_idx 	<= rom_idx;

	-- default statements for driver outputs
	write_done		<= '0';
	address   		<= (others => 'Z');
	we_n    		<= 'H';
	data2mem  		<= (others => 'Z');
	
	CASE state IS
		WHEN idle =>
			IF (do_write='1') THEN
				next_state 	  	<= setAdr;
				next_rom_idx 	<= to_integer(unsigned(write_pointer));
			END IF;
			
		WHEN setAdr =>			
			next_state	<= setEn;
			address   	<= initROM_addr(rom_idx); -- valid address
			
		WHEN setEn =>			
			next_state  <= setDat;
			address   	<= initROM_addr(rom_idx);
			we_n <= '0';

		WHEN setDat =>			
			next_state  <= holdDat;
			address   	<= initROM_addr(rom_idx);
			we_n 		<= '0';
			data2mem 	<= initROM_data(rom_idx);  -- valid data
			
		WHEN holdDat =>			
			next_state  <= idle;
			write_done	<= '1';
			-- HERE WILL DO THE MISTAKE, IF MISSING THE NEXT LINE!!
			data2mem    <= initROM_data(rom_idx);  -- valid data
					
		WHEN others =>
			next_state 	<= idle;
		END CASE;
		
  END PROCESS comb;   	
  
 -- End Architecture 
------------------------------------------- 
END rtl;

