
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity infrastructure is

  port (
    CLOCK_50     : in  std_logic;
    GPIO_26      : in  std_logic;
    KEY          : in  std_logic_vector (3 downto 0);
    SW           : in  std_logic_vector (17 downto 0);
    key_sync_o     : out std_logic_vector (3 downto 0);
    sw_sync_o     : out std_logic_vector (17 downto 0);
    gpio_26_sync_o : out std_logic;
    clk_12m_o      : out std_logic;
    reset_n_o     : out std_logic
    );

end entity infrastructure;

-------------------------------------------------------------------------------

architecture str of infrastructure is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  
  signal reset_n_temp : std_logic;
  signal  clk_12m_sig : std_logic;
  
  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------

  component synchronize is
    generic (
      width : positive);
    port (
      signal_i : in  std_logic_vector(width-1 downto 0);
      clk_i  : in  std_logic;
      signal_o : out std_logic_vector(width-1 downto 0));
  end component synchronize;

  component modulo_divider is
    generic (width : positive);
    port (
      clk_i, reset_n_i : in  std_logic;
      clk_12m_o      : out std_logic);
  end component modulo_divider;


begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- instance "synchronize_1"
  synchronize_1 : synchronize
    generic map (
      width => 4)
    port map (
      signal_i => KEY,
      clk_i  =>  clk_12m_sig,
      signal_o => key_sync_o);

  -- instance "synchronize_2"
  synchronize_2 : synchronize
    generic map (
      width => 18)
    port map (
      signal_i => SW,
      clk_i  =>  clk_12m_sig,
      signal_o => sw_sync_o);

  -- instance "synchronize_3"
  synchronize_3 : synchronize
    generic map (
      width => 1)
    port map (
      signal_i(0) => GPIO_26,
      clk_i  =>  clk_12m_sig,
      signal_o(0) => gpio_26_sync_o);

    -- instance "modulo_divider_1"
    modulo_divider_1 : modulo_divider
    generic map (
      width => 2)
    port map (
      clk_i     => CLOCK_50,
      reset_n_i => '1',
      clk_12m_o =>  clk_12m_sig);

  reset_n_temp <= key_sync_o(0);
  reset_n_o <= reset_n_temp;
  clk_12m_o <= clk_12m_sig;

end architecture str;

-------------------------------------------------------------------------------