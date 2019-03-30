# create work library
vlib work

# compile project files
vcom -2008 -explicit -work work ../../support/simulation_pkg.vhd
vcom -2008 -explicit -work work ../../support/standard_driver_pkg.vhd
vcom -2008 -explicit -work work ../../support/user_driver_pkg.vhd

vcom -2008 -explicit -work work ../../../source/codec_controller.vhd
vcom -2008 -explicit -work work ../../../source/i2c_master.vhd
vcom -2008 -explicit -work work ../../../source/i2c_slave_bfm.vhd
vcom -2008 -explicit -work work ../../../source/infrastructure.vhd
vcom -2008 -explicit -work work ../../../source/modulo_divider.vhd
vcom -2008 -explicit -work work ../../../source/reg_table_pkg.vhd
vcom -2008 -explicit -work work ../../../source/synchronize.vhd
vcom -2008 -explicit -work work ../../../source/synchronize_single.vhd
#vcom -2008 -explicit -work work ../../../tone_gen_pkg.vhd
#vcom -2008 -explicit -work work ../../../MS2_SigProc_FIR/audio_filter_pkg.vhd
#vcom -2008 -explicit -work work ../../../MS2_SigProc_FIR/fir_core.vhd
#vcom -2008 -explicit -work work ../../../MS2_SigProc_FIR/single_port_ram.vhd

#vcom -2008 -explicit -work work ../../../MS2_SigProc_FIR/testbench_fir_design.vhd






vcom -2008 -explicit -work work ../../../source/synthi_top.vhd
vcom -2008 -explicit -work work ../../../source/synthi_top_i2s_tb.vhd


# run the simulation
vsim -novopt -t 1ns -lib work work.synthi_top_tb
do ./wave.do
run 200 ms
