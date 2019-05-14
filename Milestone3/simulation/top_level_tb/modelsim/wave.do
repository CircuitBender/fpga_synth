onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/DUT/path_control_1/sw_sync_3
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/path_control_1/adcdat_pl_i
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/path_control_1/adcdat_pr_i
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/path_control_1/dacdat_pl_o
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/path_control_1/dacdat_pr_o
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/i2s_master_1/shiftreg_p2s_i2s_right/shiftreg
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/shiftreg_p2s_i2s_right/enable
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/shiftreg_p2s_i2s_right/load_i
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/shiftreg_p2s_i2s_right/enable_i
add wave -noupdate -radix hexadecimal /synthi_top_tb/dacdat_check
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/ser_i_sig
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/bit_count_sig
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/ser_i_sig
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/bclk
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/shift_l_sig
add wave -noupdate -radix decimal /synthi_top_tb/DUT/i2s_master_1/shift_r_sig
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/ws_o
add wave -noupdate /synthi_top_tb/DUT/clk_12m_sync
add wave -noupdate /synthi_top_tb/DUT/clk_12m
add wave -noupdate /synthi_top_tb/AUD_ADCDAT
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/i2s_master_1/adcdat_pl_o
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/i2s_master_1/adcdat_pr_o
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/shiftreg_s2p_i2s_right/clk
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/shiftreg_s2p_i2s_right/enable
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/shiftreg_s2p_i2s_right/enable_i
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/shiftreg_s2p_i2s_right/next_shiftreg
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/shiftreg_s2p_i2s_right/par_o
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/shiftreg_s2p_i2s_right/reset_n
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/shiftreg_s2p_i2s_right/ser_i
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/shiftreg_s2p_i2s_right/shift_i
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/i2s_master_1/shiftreg_s2p_i2s_right/shiftreg
add wave -noupdate -radix decimal /synthi_top_tb/DUT/i2s_master_1/bit_count
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/i2s_master_1/bclk
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/clk_12m
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/shift_l_sig
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/shift_r_sig
add wave -noupdate /synthi_top_tb/AUD_BCLK
add wave -noupdate /synthi_top_tb/AUD_ADCLRCK
add wave -noupdate /synthi_top_tb/AUD_DACLRCK
add wave -noupdate /synthi_top_tb/AUD_XCK
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
WaveRestoreZoom {734 ns} {20606 ns}
