module DE1_SoC (CLOCK_50, SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	
	input logic CLOCK_50;
	input logic [9:0] SW;
	input logic [3:0] KEY;
	output logic [9:0] LEDR;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	// reset signal
	logic reset;
	assign reset = ~KEY[0];
	
	// start signal
	logic s;
	logic meta_s;
	always_ff @(posedge CLOCK_50) begin
		meta_s <= ~KEY[3];
		s <= meta_s;
	end
	
	task1 count_ones (.clk(CLOCK_50), .reset, .s, .A(SW[7:0]), .HEX0, .LED(LEDR[9]));
	
	assign HEX5 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX1 = 7'b1111111;
	
endmodule // DE1_SoC