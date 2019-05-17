onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/DUT/AUD_ADCDAT
add wave -noupdate /synthi_top_tb/DUT/AUD_ADCLRCK
add wave -noupdate /synthi_top_tb/DUT/AUD_BCLK
add wave -noupdate /synthi_top_tb/DUT/AUD_DACDAT
add wave -noupdate /synthi_top_tb/DUT/AUD_DACLRCK
add wave -noupdate /synthi_top_tb/DUT/AUD_XCK
add wave -noupdate /synthi_top_tb/DUT/CLOCK_50
add wave -noupdate /synthi_top_tb/DUT/GPIO_26
add wave -noupdate /synthi_top_tb/DUT/I2C_SCLK
add wave -noupdate /synthi_top_tb/DUT/I2C_SDAT
add wave -noupdate /synthi_top_tb/DUT/KEY
add wave -noupdate /synthi_top_tb/DUT/SW
add wave -noupdate /synthi_top_tb/DUT/ack_error_sync_sig
add wave -noupdate /synthi_top_tb/DUT/adcdat_pl_sig
add wave -noupdate /synthi_top_tb/DUT/adcdat_pr_sig
add wave -noupdate /synthi_top_tb/DUT/adcdat_s_sig
add wave -noupdate /synthi_top_tb/DUT/attenu_sig
add wave -noupdate /synthi_top_tb/DUT/bclk_sig
add wave -noupdate /synthi_top_tb/DUT/clk_12m_sig
add wave -noupdate /synthi_top_tb/DUT/clk_12m_sync_sig
add wave -noupdate /synthi_top_tb/DUT/dacdat_pl_sig
add wave -noupdate /synthi_top_tb/DUT/dacdat_pr_sig
add wave -noupdate /synthi_top_tb/DUT/dacdat_s_sig
add wave -noupdate /synthi_top_tb/DUT/dds_l_sig
add wave -noupdate /synthi_top_tb/DUT/dds_r_sig
add wave -noupdate /synthi_top_tb/DUT/dds_sig
add wave -noupdate /synthi_top_tb/DUT/gpio_26_sync_sig
add wave -noupdate /synthi_top_tb/DUT/key_sync_sig
add wave -noupdate /synthi_top_tb/DUT/load_sig
add wave -noupdate /synthi_top_tb/DUT/mute_o_sig
add wave -noupdate /synthi_top_tb/DUT/note_vector_sig
add wave -noupdate /synthi_top_tb/DUT/reset_n_sig
add wave -noupdate /synthi_top_tb/DUT/sw_sync_sig
add wave -noupdate /synthi_top_tb/DUT/tone_on_sig
add wave -noupdate /synthi_top_tb/DUT/write_data_sync_sig
add wave -noupdate /synthi_top_tb/DUT/write_done_sync_sig
add wave -noupdate /synthi_top_tb/DUT/write_sync_sig
add wave -noupdate /synthi_top_tb/DUT/ws_sig
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10670 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 332
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
WaveRestoreZoom {498912 ns} {518784 ns}
