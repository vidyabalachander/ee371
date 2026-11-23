onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /read_rom_tb/period
add wave -noupdate /read_rom_tb/clk
add wave -noupdate /read_rom_tb/address
add wave -noupdate /read_rom_tb/x0
add wave -noupdate /read_rom_tb/y0
add wave -noupdate /read_rom_tb/x1
add wave -noupdate /read_rom_tb/y1
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
WaveRestoreZoom {0 ps} {1248 ps}
