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
	
	//binary search wires
	logic initialize, update_low, update_high, save;
	logic equal, less, at_low, at_high;

	logic [LOG2N-1:0] address, address_out;
	logic [7:0] data_out;
	logic Done, Found;	
	
	bst_control control (.*);

	bst_datapath #(.LOG2N(5)) datapath (
		 .clk,
		 .reset,
		 .A(SW[7:0]),
		 .data_out,
		 .initialize,
		 .update_low,
		 .update_high,
		 .save,
		 .address,
		 .address_out,
		 .Found,
		 .equal,
		 .less,
		 .at_low,
		 .at_high
	);
	
	assign HEX5 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX1 = 7'b1111111;
	
endmodule // DE1_SoC