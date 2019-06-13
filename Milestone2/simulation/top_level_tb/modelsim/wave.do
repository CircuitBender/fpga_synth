onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/DUT/ack_error_sync
add wave -noupdate /synthi_top_tb/DUT/adcdat_pl_o
add wave -noupdate /synthi_top_tb/DUT/adcdat_pr_o
add wave -noupdate /synthi_top_tb/DUT/AUD_ADCDAT
add wave -noupdate /synthi_top_tb/DUT/AUD_ADCLRCK
add wave -noupdate /synthi_top_tb/DUT/AUD_BCLK
add wave -noupdate /synthi_top_tb/DUT/AUD_DACDAT
add wave -noupdate /synthi_top_tb/DUT/AUD_DACLRCK
add wave -noupdate /synthi_top_tb/DUT/AUD_XCK
add wave -noupdate /synthi_top_tb/DUT/clk_12m_sync
add wave -noupdate /synthi_top_tb/DUT/CLOCK_50
add wave -noupdate /synthi_top_tb/DUT/dacdat_pl_i
add wave -noupdate /synthi_top_tb/DUT/dacdat_pr_i
add wave -noupdate /synthi_top_tb/DUT/GPIO_26
add wave -noupdate /synthi_top_tb/DUT/gpio_26_sync_2
add wave -noupdate /synthi_top_tb/DUT/I2C_SCLK
add wave -noupdate /synthi_top_tb/DUT/I2C_SDAT
add wave -noupdate /synthi_top_tb/DUT/KEY
add wave -noupdate /synthi_top_tb/DUT/key_sync_2
add wave -noupdate /synthi_top_tb/DUT/mute_o
add wave -noupdate /synthi_top_tb/DUT/reset_n
add wave -noupdate /synthi_top_tb/DUT/SW
add wave -noupdate /synthi_top_tb/DUT/sw_sync_2
add wave -noupdate /synthi_top_tb/DUT/write_data_sync
add wave -noupdate /synthi_top_tb/DUT/write_done_sync
add wave -noupdate /synthi_top_tb/DUT/write_sync
add wave -noupdate /synthi_top_tb/DUT/ws_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8618 ns} 0}
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
WaveRestoreZoom {0 ns} {602406912 ns}
