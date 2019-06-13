-------------------------------------------
-- Block code:  flanken_detect.vhd
-- History:     15.Nov.2017 - 1st version (dqtm)
--                 <date> - <changes>  (<author>)
-- Function: edge detector with rise & fall outputs. 
--           Declaring FFs as a shift-register.
-------------------------------------------

-- Library & Use Statements
library ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration 
entity flanken_detect is
  port(serdata_sync : in  std_logic;
       Clk          : in  std_logic;
       reset_n      : in  std_logic;
       fall_edge    : out std_logic
   --data_in    : IN    std_logic;
       --steig      : OUT   std_logic;
       );
end flanken_detect;


-- Architecture Declaration 
architecture rtl of flanken_detect is

  -- Signals & Constants Declaration 
  signal shiftreg, next_shiftreg : std_logic_vector(1 downto 0);


-- Begin Architecture
begin
  -------------------------------------------
  -- Process for combinatorial logic
  -- OBs.: small logic, could be outside process, 
  --       but doing inside for didactical purposes!
  -------------------------------------------
  comb_proc : process(all)
  begin
    next_shiftreg <= serdata_sync & shiftreg(1);  -- shift direction towards LSB                
  end process comb_proc;

  -------------------------------------------
  -- Process for registers (flip-flops)
  -------------------------------------------
  reg_proc : process(all)
  begin
    if reset_n = '0' then
      shiftreg <= (others => '0');
    elsif (rising_edge(Clk)) then
      shiftreg <= next_shiftreg;
    end if;
  end process reg_proc;

  -------------------------------------------
  -- Concurrent Assignments  
  -------------------------------------------
  --steig <=     shiftreg(1)  AND NOT(shiftreg(0));
  fall_edge <= not(shiftreg(1)) and shiftreg(0);


end rtl;
