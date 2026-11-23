onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /DE1_SoC_tb/period
add wave -noupdate /DE1_SoC_tb/clk
add wave -noupdate {/DE1_SoC_tb/SW[9]}
add wave -noupdate {/DE1_SoC_tb/LEDR[9]}
add wave -noupdate /DE1_SoC_tb/SW
add wave -noupdate /DE1_SoC_tb/LEDR
add wave -noupdate /DE1_SoC_tb/KEY
add wave -noupdate /DE1_SoC_tb/dut/reset_line
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {55464 ps} {56803 ps}
