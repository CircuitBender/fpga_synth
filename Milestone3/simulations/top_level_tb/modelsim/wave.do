onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/AUD_ADCDAT
add wave -noupdate /synthi_top_tb/AUD_ADCLRCK
add wave -noupdate /synthi_top_tb/AUD_BCLK
add wave -noupdate /synthi_top_tb/AUD_DACDAT
add wave -noupdate /synthi_top_tb/AUD_DACLRCK
add wave -noupdate /synthi_top_tb/AUD_XCK
add wave -noupdate /synthi_top_tb/CLOCK_50
add wave -noupdate /synthi_top_tb/GPIO_26
add wave -noupdate /synthi_top_tb/I2C_SCLK
add wave -noupdate /synthi_top_tb/I2C_SDAT
add wave -noupdate /synthi_top_tb/KEY
add wave -noupdate /synthi_top_tb/SW
add wave -noupdate /synthi_top_tb/clock_freq
add wave -noupdate /synthi_top_tb/clock_period
add wave -noupdate /synthi_top_tb/dacdat_check
add wave -noupdate /synthi_top_tb/reg_data0
add wave -noupdate /synthi_top_tb/reg_data1
add wave -noupdate /synthi_top_tb/reg_data2
add wave -noupdate /synthi_top_tb/reg_data3
add wave -noupdate /synthi_top_tb/reg_data4
add wave -noupdate /synthi_top_tb/reg_data5
add wave -noupdate /synthi_top_tb/reg_data6
add wave -noupdate /synthi_top_tb/reg_data7
add wave -noupdate /synthi_top_tb/reg_data8
add wave -noupdate /synthi_top_tb/reg_data9
add wave -noupdate /synthi_top_tb/switch
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6205950 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 388
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
configure wave -timelineunits ns
update
WaveRestoreZoom {11409754 ns} {52031066 ns}
