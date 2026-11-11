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
	
	// bit count outputs
	logic bit_count_done;
	logic [3:0] num_ones;
	
	//binary search outputs
	logic [4:0] Loc;
	logic bst_done, bst_found;	
	
	bit_counter count_ones (.clk(CLOCK_50), .reset, .s, .A(SW[7:0]), .Done(bit_count_done), .num_ones);
	
	bst search (.clk(CLOCK_50), .reset, .s, .A(SW[7:0]), .Loc, .Done(bst_done), .Found(bst_found));
	
	logic [3:0] hex0_in, hex1_in;
	logic [6:0] hex0_out, hex1_out;
	
	always_comb begin
		if (SW[9]) begin 
			hex0_in = Loc[3:0];
			hex1_in = {3'b000, Loc[4]};
		end 
		else begin
			hex0_in = num_ones;
			hex1_in = 4'b0; //doesn't matter
		end
	end
	
	seg7 display_0 (.hex(hex0_in), .leds(hex0_out));
	seg7 display_1 (.hex(hex1_in), .leds(hex1_out));
	
	assign LEDR[9]   = SW[9]? bst_done : bit_count_done;
	
	always_comb begin
		if (SW[9]) begin			
			LEDR[0] = bst_found;
			if (bst_found) begin
				HEX0 = hex0_out;
				HEX1 = hex1_out;
			end 
			else begin
				HEX0 = 7'b1111111;
				HEX1 = 7'b1111111;
			end
		end 
		else begin
			LEDR[0] = 1'b0;
			HEX0 = hex0_out;
			HEX1 = 7'b1111111;
		end
	end
	
	assign LEDR[8:1] = 8'd0;
	assign HEX5 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	
endmodule // DE1_SoC