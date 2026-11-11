// This is the top-level module for the aglorithms in hardware laboratory assignment. This project allows
// a user to input an unsigned 8-digit binary number to the algorithm, and provides an output via the 
// HEX displays. Through SW9, the user can choose to receive an output of the number of 1s in their
// 8-bit input, through a bit_counter module. The user can alternatively choose to traverse an inbuilt 32x8 RAM
// array via binary search and find the address at which the input value is stored. If the input value is not found,
// no output address is displayed on the HEX displays. The user provides this 8-bit input with the on-board switches.
// The on-board keys are also used for input, with KEY0 being the reset button, and KEY3 being the Start button
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
	end //always_ff
	
	// bit count outputs
	logic bit_count_done;
	logic [3:0] num_ones;
	
	//binary search outputs
	logic [4:0] Loc;
	logic bst_done, bst_found;	
	
	//instantiating both algorithms
	bit_counter count_ones (.clk(CLOCK_50), .reset, .s, .A(SW[7:0]), .Done(bit_count_done), .result(num_ones));
	bst search (.clk(CLOCK_50), .reset, .s, .A(SW[7:0]), .Loc, .Done(bst_done), .Found(bst_found));
	
	logic [3:0] hex0_in, hex1_in;
	logic [6:0] hex0_out, hex1_out;
	
	// logic for displaying output dependant on which algorithm is selected
	always_comb begin
		LEDR[9] = 1'b0;
		if (SW[9]) begin 
			hex0_in = Loc[3:0];
			hex1_in = {3'b000, Loc[4]};
			LEDR[9] = bst_done;
		end 
		else begin
			hex0_in = num_ones;
			hex1_in = 4'b0; //doesn't matter
			LEDR[9] = bit_count_done;
		end
	end
	
	// saving the hex output to a variable
	seg7 display_0 (.hex(hex0_in), .leds(hex0_out));
	seg7 display_1 (.hex(hex1_in), .leds(hex1_out));
	

	// For the binary search algorithm, the displays must not show any address when the value is not
	// found in the array. This block helps with that logic.
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
	
	// Keeping unused outputs unasserted.
	assign LEDR[8:1] = 8'd0;
	assign HEX5 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	
endmodule // DE1_SoC