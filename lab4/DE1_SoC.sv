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
	
	//logic LED_task1;
	
	//task1 count_ones (.clk(CLOCK_50), .reset, .s, .A(SW[7:0]), .HEX0, .LED(LED_task1));
	
	//binary search wires
	logic [4:0] Loc;
	logic [7:0] data_out;
	logic Done, Found;	
	
	bst search (.clk(CLOCK_50), .reset, .s, .A(SW[7:0]), .Loc, .Done, .Found);
	
	seg7 bst_display_0 (.hex(Loc[3:0]), .leds(HEX0));
	seg7 bst_display_1 (.hex({3'b000, Loc[4]}), .leds(HEX1));
	
	assign LEDR[9]   = SW[9]? Done : 1'b0;
   assign LEDR[0]   = SW[9]? Found : 1'b0;
	
	assign LEDR[8:1] = 8'd0;
	assign HEX5 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	
endmodule // DE1_SoC