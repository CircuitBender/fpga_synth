onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/DUT/path_control_1/sw_sync_i
add wave -noupdate /synthi_top_tb/DUT/path_control_1/dds_l_i
add wave -noupdate /synthi_top_tb/DUT/path_control_1/dds_r_i
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/path_control_1/adcdat_pl_i
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/path_control_1/adcdat_pr_i
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/path_control_1/dacdat_pl_o
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/path_control_1/dacdat_pr_o
add wave -noupdate /synthi_top_tb/DUT/path_control_1/sw_sync_i
add wave -noupdate /synthi_top_tb/DUT/path_control_1/sw_sync_i(3)
add wave -noupdate -radix hexadecimal /synthi_top_tb/dacdat_check
add wave -noupdate -divider ja
add wave -noupdate -expand /synthi_top_tb/tv_s
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {95230 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 411
configure wave -valuecolwidth 100
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
configure wave -timelineunits ps
update
WaveRestoreZoom {238354 ns} {532498 ns}
