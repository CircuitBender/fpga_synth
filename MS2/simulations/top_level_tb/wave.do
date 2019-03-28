onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/DUT/CLOCK_50
add wave -noupdate /synthi_top_tb/DUT/KEY_0
add wave -noupdate /synthi_top_tb/DUT/KEY_1
add wave -noupdate /synthi_top_tb/DUT/SW
add wave -noupdate /synthi_top_tb/DUT/I2C_SCLK
add wave -noupdate /synthi_top_tb/DUT/I2C_SDAT
add wave -noupdate /synthi_top_tb/DUT/write_data
add wave -noupdate /synthi_top_tb/DUT/write_1
add wave -noupdate /synthi_top_tb/DUT/write_done
add wave -noupdate /synthi_top_tb/DUT/ack_error
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
WaveRestoreZoom {2862440 ns} {2882104 ns}
