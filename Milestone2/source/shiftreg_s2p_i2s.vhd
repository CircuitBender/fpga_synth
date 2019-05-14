

library ieee;
use ieee.std_logic_1164.all;

entity shiftreg_s2p_i2s is
  port (
    clk      : in  std_logic;
    reset_n  : in  std_logic;
    enable_i : in  std_logic;           --BCLK
    ser_i    : in  std_logic;
    shift_i  : in  std_logic;           --Shift l/r
    par_o    : out std_logic_vector(15 downto 0)
    );
end shiftreg_s2p_i2s;


architecture rtl of shiftreg_s2p_i2s is

  signal shiftreg      : std_logic_vector (15 downto 0);
  signal next_shiftreg : std_logic_vector (15 downto 0);
  signal enable        : std_logic;

begin

  --concurrent Statement
  par_o <= shiftreg;

  enable_logic : process(all)

  begin
		enable <= '0';
    if enable_i = '0' and shift_i = '1' then
      enable <= '1';

    end if;

  end process enable_logic;
  --------------------------------------------------
  -- PROCESS FOR COMB-INPUT LOGIC
  --------------------------------------------------
  comblogic : process(all)
    begin
    next_shiftreg <= shiftreg;

    if enable = '1' then
      next_shiftreg (15 downto 0) <= shiftreg(14 downto 0) & ser_i;

    end if;


  end process comblogic;



 flipflops : process(all) -- process hatte keinen Namen
  begin
    if reset_n = '0' then
      shiftreg <= (others => '0');

    elsif rising_edge(clk) then
      shiftreg <= next_shiftreg;
    end if;
  end process flipflops; -- process hatte keinen Namen



end rtl;
