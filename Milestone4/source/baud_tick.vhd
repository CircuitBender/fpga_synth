-------------------------------------------------------------------------------
-- Title      : Testbench for design "synthi_top"
-- Project    : fpga:synth
-------------------------------------------------------------------------------
-- File       : baud_tick.vhd
-- Author     : dqtm 
-- Company    : ZHAW
-- Created    : 2018-03-09
-- Last update: 2019-05-23
-- Platform   : Windows
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: edge detector with rise & fall outputs. 
--              Declaring FFs as a shift-register.
-------------------------------------------------------------------------------
-- Copyright (c) 2019
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2017-11-15  1.0      dqtm        Created$
-- 2019-05-23   1.1             Heinzen         commentaries, debugging, adaption
-------------------------------------------------------------------------------
-- Library & Use Statements
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------
-- Entity Declaration 
-------------------------------------------------------------------------------
entity baud_tick is
  port(clk_i       : in  std_logic;
       start_bit_i : in  std_logic;
       reset_n_i   : in  std_logic;
       baud_tick_o : out std_logic
       );
end baud_tick;

-------------------------------------------------------------------------------
-- Architecture Declaration 
-------------------------------------------------------------------------------
architecture rtl of baud_tick is

  constant clock                     : natural                            := 50_000_000;  --Hz
  constant baud_rate                 : natural                            := 115_200;  --Hz
  constant count_width               : natural                            := 10;  --freqclock/freqbaudrate==50000000/115200=434 ==>434 braucht 10bit
  constant one_period                : unsigned(count_width - 1 downto 0) := to_unsigned(400, count_width);
  constant half_period               : unsigned(count_width - 1 downto 0) := to_unsigned(200, count_width);
  signal baud_count, next_baud_count : unsigned(count_width - 1 downto 0);


-------------------------------------------------------------------------------
-- Begin Architecture
-------------------------------------------------------------------------------
begin

  reg_proc : process(all)
  begin
    baud_tick_o <= '0';
    if start_bit_i = '1' then
      next_baud_count <= half_period;
    elsif baud_count = 0 then
      next_baud_count <= one_period;
      baud_tick_o       <= '1';
    else next_baud_count <= baud_count-1;
    end if;
  end process reg_proc;

  clock_process : process(all)
  begin
    if reset_n_i = '0' then

      baud_count <= (others => '0');
    elsif rising_edge(clk_i) then
      baud_count <= next_baud_count;
    end if;
  end process clock_process;

end rtl;
-------------------------------------------------------------------------------
-- end
-------------------------------------------------------------------------------
