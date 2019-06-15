onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/DUT/tone_generator_1/clk_12m
add wave -noupdate /synthi_top_tb/DUT/tone_generator_1/reset_n
add wave -noupdate /synthi_top_tb/DUT/tone_generator_1/load_i
add wave -noupdate /synthi_top_tb/DUT/tone_generator_1/note_vector
add wave -noupdate /synthi_top_tb/DUT/tone_generator_1/dds_o
add wave -noupdate /synthi_top_tb/DUT/tone_generator_1/DDS_1/clk_12m
add wave -noupdate /synthi_top_tb/DUT/tone_generator_1/DDS_1/load_i
add wave -noupdate /synthi_top_tb/DUT/tone_generator_1/DDS_1/reset_n
add wave -noupdate /synthi_top_tb/DUT/tone_generator_1/DDS_1/phi_incr_i
add wave -noupdate /synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o
add wave -noupdate /synthi_top_tb/DUT/tone_generator_1/DDS_1/count
add wave -noupdate -expand /synthi_top_tb/DUT/tone_generator_1/DDS_1/next_count
add wave -noupdate -expand /synthi_top_tb/DUT/tone_generator_1/DDS_1/lut_addr
add wave -noupdate /synthi_top_tb/DUT/tone_generator_1/DDS_1/lut_val
add wave -noupdate -radix binary -childformat {{/synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(15) -radix symbolic} {/synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(14) -radix symbolic} {/synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(13) -radix symbolic} {/synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(12) -radix symbolic} {/synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(11) -radix symbolic} {/synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(10) -radix symbolic} {/synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(9) -radix symbolic} {/synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(8) -radix symbolic} {/synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(7) -radix symbolic} {/synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(6) -radix symbolic} {/synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(5) -radix symbolic} {/synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(4) -radix symbolic} {/synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(3) -radix symbolic} {/synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(2) -radix symbolic} {/synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(1) -radix symbolic} {/synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(0) -radix symbolic}} -radixshowbase 1 -expand -subitemconfig {/synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(15) {-radix symbolic} /synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(14) {-radix symbolic} /synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(13) {-radix symbolic} /synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(12) {-radix symbolic} /synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(11) {-radix symbolic} /synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(10) {-radix symbolic} /synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(9) {-radix symbolic} /synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(8) {-radix symbolic} /synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(7) {-radix symbolic} /synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(6) {-radix symbolic} /synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(5) {-radix symbolic} /synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(4) {-radix symbolic} /synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(3) {-radix symbolic} /synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(2) {-radix symbolic} /synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(1) {-radix symbolic} /synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o(0) {-radix symbolic}} /synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o
add wave -noupdate /synthi_top_tb/DUT/tone_generator_1/DDS_1/load_i
add wave -noupdate /synthi_top_tb/DUT/tone_generator_1/DDS_1/clk_12m
add wave -noupdate /synthi_top_tb/DUT/tone_generator_1/DDS_1/count
add wave -noupdate /synthi_top_tb/DUT/tone_generator_1/DDS_1/dds_o
add wave -noupdate /synthi_top_tb/DUT/tone_generator_1/DDS_1/load_i
add wave -noupdate /synthi_top_tb/DUT/tone_generator_1/DDS_1/lut_addr
add wave -noupdate /synthi_top_tb/DUT/tone_generator_1/DDS_1/lut_val
add wave -noupdate /synthi_top_tb/DUT/tone_generator_1/DDS_1/next_count
add wave -noupdate /synthi_top_tb/DUT/tone_generator_1/DDS_1/phi_incr_i
add wave -noupdate /synthi_top_tb/DUT/tone_generator_1/DDS_1/reset_n
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {28315777 ns} 0}
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
WaveRestoreZoom {21410154 ns} {62031466 ns}
