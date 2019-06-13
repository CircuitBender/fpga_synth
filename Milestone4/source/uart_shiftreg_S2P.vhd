-------------------------------------------
-- Block code:  uart_shiftreg_s2p.vhd
-- History:     14.Nov.2012 - 1st version (dqtm)
--                 <date> - <changes>  (<author>)
-- Function: modulo divider with generic width. Output MSB with 50% duty cycle.
--              Can be used for clock-divider when no exact ratio required.
-------------------------------------------

-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Entity Declaration 
-------------------------------------------
entity uart_shiftreg_s2p is

  port(Clk          : in  std_logic;
       reset_n      : in  std_logic;
       shift_enable : in  std_logic;
       serdata_sync : in  std_logic;
       parallel_out : out std_logic_vector(9 downto 0)
      
       );
end uart_shiftreg_s2p;



architecture rtl of uart_shiftreg_s2p is


  signal shiftreg      : std_logic_vector(9 downto 0);
  signal next_shiftreg : std_logic_vector(9 downto 0);



begin

  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  comb_logic : process(all)
  begin


    if shift_enable = '1' then
      next_shiftreg <=serdata_sync & shiftreg(9 downto 1);
    else
      next_shiftreg <= shiftreg;        --sonst bleibt es gleiche zahl

    end if;

  end process comb_logic;

  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : process(all)
  begin
    if reset_n = '0' then
      shiftreg <= (others => '0');
    elsif rising_edge(Clk) then
      shiftreg <= next_shiftreg;
    end if;
  end process flip_flops;

  parallel_out <= shiftreg;  --when (shift_enable = '0') else "0000000000";

end rtl;

