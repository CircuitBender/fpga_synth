
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity infrastructure is

  port (
    CLOCK_50       : in  std_logic;
    GPIO_26        : in  std_logic;
    KEY            : in  std_logic_vector (1 downto 0);
    SW             : in  std_logic_vector (17 downto 0);
    key_sync_o     : out std_logic;--initialise
    sw_sync_o      : out std_logic_vector (17 downto 0);
    gpio_26_sync_o : out std_logic;
    clk_12m_o      : out std_logic;
    reset_n_o      : out std_logic
    );

end entity infrastructure;

-------------------------------------------------------------------------------

architecture str of infrastructure is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal reset_n_temp : std_logic;
  signal clk_12m_sig  : std_logic;
  signal key_sync_sig :std_logic_vector (1 downto 0);
  signal g26_i :std_logic;
  signal g26_o :std_logic;

  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------

  component synchronize is
    generic (
      width : positive);
    port (
      signal_i : in  std_logic_vector(width-1 downto 0);
      clk_12m    : in  std_logic;
      signal_o : out std_logic_vector(width-1 downto 0));
  end component synchronize;

  component modulo_divider is
    generic (width : positive);
    port (
      clk, reset_n : in  std_logic;
      clk_12m        : out std_logic);
  end component modulo_divider;


begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- instance "synchronize_1"
  synchronize_1 : synchronize
    generic map (
      width => 2)
    port map (
      signal_i => KEY,
      clk_12m    => clk_12m_sig,
      signal_o => key_sync_sig);

  -- instance "synchronize_2"
  synchronize_2 : synchronize
    generic map (
      width => 18)
    port map (
      signal_i => SW,
      clk_12m   => clk_12m_sig,
      signal_o => sw_sync_o);

  -- instance "synchronize_3"
  synchronize_3 : synchronize
    generic map (
      width => 1)
    port map (
      signal_i(0) => GPIO_26,
      clk_12m       => clk_12m_sig,
      signal_o(0) => gpio_26_sync_o);

  -- instance "modulo_divider_1"
  modulo_divider_1 : modulo_divider
    generic map (
      width => 2)
    port map (
      clk     => CLOCK_50,
      reset_n => '1',
      clk_12m => clk_12m_sig);

		--zuweisung
  reset_n_o <= key_sync_sig(0);
  key_sync_o <= key_sync_sig(1);
  clk_12m_o <= clk_12m_sig;
  
  
  
end architecture str;

-------------------------------------------------------------------------------
