// Instantiates and handles all logic for the bit counter.
module task1(clk, reset, s, A, HEX0, LED);
	input logic clk, reset, s;
	input logic [7:0] A;
	output logic [6:0] HEX0;
	output logic LED;
	
	logic Done;
	logic [3:0] result;
	logic [3:0] num_ones;
	
	bit_counter count_ones (.*);
								
	always_ff @(posedge clk) begin
		if (reset) num_ones <= 4'b0;
		if (!Done) begin
			num_ones <= num_ones;
		end
		else if (Done) begin 
			num_ones <= result;
		end
	end
	
	seg7 task1_display (
							  .hex  (num_ones),
							  .leds (HEX0));
						
endmodule // task1