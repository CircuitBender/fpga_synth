onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/reset_n
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/initalise_i
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/write_o
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/codec_controller_1/write_data_o
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/next_count
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/write_done_i
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/count
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/write_o
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/ack_error_i
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/s_state
add wave -noupdate /synthi_top_tb/DUT/infrastructure_1/clk_12m
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2666 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 340
configure wave -valuecolwidth 40
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
WaveRestoreZoom {0 ns} {19664 ns}
