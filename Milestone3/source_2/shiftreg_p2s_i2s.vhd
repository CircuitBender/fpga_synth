
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity shiftreg_p2s_i2s is

  port(

    clk      : in  std_logic;
    set_n    : in  std_logic;
    load_i   : in  std_logic;
    par_i    : in  std_logic_vector(15 downto 0);
    enable_i : in  std_logic;           --BCLK
    shift_i  : in  std_logic;           --Shift l/r
    ser_o    : out std_logic
    );

end shiftreg_p2s_i2s;

architecture rtl of shiftreg_p2s_i2s is

  signal shiftreg      : std_logic_vector(15 downto 0);
  signal next_shiftreg : std_logic_vector(15 downto 0);
  signal enable        : std_logic;

begin

  enablelogic : process (all)
  begin
   enable <= '0';
    if enable_i = '1' and shift_i = '1' then
      enable <= '1';
    end if;
  end process enablelogic;


  logik : process(load_i, enable, shiftreg, par_i)

  begin
    next_shiftreg <= shiftreg;

    if load_i = '1' then
      next_shiftreg <= par_i;

    elsif enable = '1' then
      next_shiftreg <= shiftreg(14 downto 0) & '1';  -- LSB =1, umgekehrt MSB=1


    end if;

  end process logik;




  flip_flops : process(all)

  begin

    if set_n = '0' then
      shiftreg <= (others => '0');

    elsif rising_edge (clk) then
      shiftreg <= next_shiftreg;

    end if;
  end process flip_flops;

  ser_o <= shiftreg(15);

end architecture rtl;