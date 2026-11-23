/* Top level module of the FPGA that takes the onboard resources 
 * as input and outputs the lines drawn from the VGA port.
 *
 * Inputs:
 *   KEY 			- On board keys of the FPGA
 *   SW 			- On board switches of the FPGA
 *   CLOCK_50 		- On board 50 MHz clock of the FPGA
 *
 * Outputs:
 *   HEX 			- On board 7 segment displays of the FPGA
 *   LEDR 			- On board LEDs of the FPGA
 *   VGA_R 			- Red data of the VGA connection
 *   VGA_G 			- Green data of the VGA connection
 *   VGA_B 			- Blue data of the VGA connection
 *   VGA_BLANK_N 	- Blanking interval of the VGA connection
 *   VGA_CLK 		- VGA's clock signal
 *   VGA_HS 		- Horizontal Sync of the VGA connection
 *   VGA_SYNC_N 	- Enable signal for the sync of the VGA connection
 *   VGA_VS 		- Vertical Sync of the VGA connection
 */
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign LEDR[8:0] = SW[8:0];
	
	logic [10:0] x0, y0, x1, y1, x, y, x_draw, y_draw, x_clear, y_clear;
	logic [7:0] rom_address;
	logic reset, reset_line, line_drawn;
	assign reset = SW[0];
	
	// fsm
	enum logic [2:0] {S_DRAW, S_CLEAR, S_DONE, S_HOLD, S_LOAD} ps, ns;
	
	parameter max_line = 8'd137;
	parameter max_x_pixel = 10'd639;
	parameter max_y_pixel = 10'd479;
	
	always_ff @(posedge CLOCK_50) begin
		if (reset) begin
			ps <= S_CLEAR;
			rom_address <= 8'b0;
			
			if (x_clear == max_x_pixel) begin
				if (y_clear == max_y_pixel)
					y_clear <= 10'b0;
				else 
					y_clear <= y_clear + 10'b1;
				x_clear <= 10'b0;
			end else
				x_clear <= x_clear + 10'b1;
			
		end else begin
			ps <= ns;
			
			if (ps == S_DRAW && line_drawn && rom_address < max_line)
				rom_address <= rom_address + 8'b1;

		end
	end //always_ff
	
	assign LEDR[9] = ps == S_DONE;
	assign reset_line = ps == S_LOAD;
	
	always_comb begin
		ns = ps;
		case (ps)
			S_CLEAR: if (~reset) ns = S_HOLD;
			S_HOLD: ns = S_LOAD;
			S_LOAD: ns = S_DRAW;
			S_DRAW: if (line_drawn) ns = (rom_address == max_line) ? S_DONE : S_HOLD;
			S_DONE: ns = S_DONE;
		endcase // ps
	end // always_comb
	
	VGA_framebuffer fb (
		.clk50			(CLOCK_50), 
		.reset			(1'b0),
		// if in clear, clear all pixels, otherwise choose output from line_drawer
		.x					((ps == S_CLEAR) ? x_clear : x_draw), 
		.y					((ps == S_CLEAR) ? y_clear : y_draw),
		.pixel_color	((ps == S_CLEAR) ? 1'b0 : 1'b1), 
		.pixel_write	(ps != S_DONE),
		.VGA_R, 
		.VGA_G, 
		.VGA_B, 
		.VGA_CLK, 
		.VGA_HS, 
		.VGA_VS,
		.VGA_BLANK_n	(VGA_BLANK_N), 
		.VGA_SYNC_n		(VGA_SYNC_N));
				

	read_rom load_lines (.clk(CLOCK_50), .address(rom_address), .x0, .y0, .x1, .y1);
	
	line_drawer draw_lines (.clk(CLOCK_50), .reset(reset_line), .x0, .y0, .x1, .y1, .x(x_draw), 
									.y(y_draw), .done(line_drawn));

endmodule  // DE1_SoC
