onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/CLOCK_50
add wave -noupdate /synthi_top_tb/DUT/KEY_0
add wave -noupdate /synthi_top_tb/DUT/SW
add wave -noupdate /synthi_top_tb/DUT/KEY_1
add wave -noupdate /synthi_top_tb/DUT/write_done_top
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/write_data_top
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/fsm_state
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/initialize_i
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/count
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/reset_n
add wave -noupdate /synthi_top_tb/DUT/infrastructure_1/key
add wave -noupdate /synthi_top_tb/DUT/infrastructure_1/key_1_sync
add wave -noupdate /synthi_top_tb/DUT/infrastructure_1/clk_12m
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/count
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/sw_sync_i
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/write_data_o
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/write_done_i
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/write_o
add wave -noupdate /synthi_top_tb/DUT/i2c_master_1/ack_error
add wave -noupdate /synthi_top_tb/DUT/i2c_master_1/ack_error_o
add wave -noupdate /synthi_top_tb/DUT/i2c_master_1/write_done_o
add wave -noupdate /synthi_top_tb/DUT/i2c_master_1/write_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {590 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 316
configure wave -valuecolwidth 234
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {20352 ns}
