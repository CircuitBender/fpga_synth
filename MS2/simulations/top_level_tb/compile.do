# create work library
vlib work

# compile project files
vcom -2008 -explicit -work work ../../support/simulation_pkg.vhd
vcom -2008 -explicit -work work ../../support/standard_driver_pkg.vhd
vcom -2008 -explicit -work work ../../support/user_driver_pkg.vhd
vcom -2008 -explicit -work work ../../../source/reg_table_pkg.vhd

vcom -2008 -explicit -work work ../../../source/i2c_master.vhd
vcom -2008 -explicit -work work ../../../source/i2c_slave_bfm.vhd
vcom -2008 -explicit -work work ../../../source/modulo_divider.vhd
vcom -2008 -explicit -work work ../../../source/sync.vhd
vcom -2008 -explicit -work work ../../../source/infrastructure.vhd
vcom -2008 -explicit -work work ../../../source/codec_controller.vhd


#vcom -2008 -explicit -work work ../../../source/midi_uart.vhd
#vcom -2008 -explicit -work work ../../../source/midi_controller.vhd
#vcom -2008 -explicit -work work ../../../source/tone_generator.vhd
#vcom -2008 -explicit -work work ../../../source/digital_loop_switch.vhd
#vcom -2008 -explicit -work work ../../../source/i2s_master.vhd











vcom -2008 -explicit -work work ../../../source/synthi_top.vhd
vcom -2008 -explicit -work work ../../../source/synthi_top_tb.vhd


# run the simulation
vsim -novopt -t 1ns -lib work work.synthi_top_tb
do ./wave.do
run 10000 ms