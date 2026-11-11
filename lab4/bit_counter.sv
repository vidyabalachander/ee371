// This module is a bit counter. It counts the number of bits that are 1 in the
// 8 bit number A and outputs the value in the 4 bit result. It takes in a clock, 
// a reset signal, and a start signal s. It also outputs a Done signal to signal
// to the higher level module when the result is ready to be displayed on the
// seven segment display.
module bit_counter (
							input logic clk, reset, s,
							input logic [7:0] A,
							output logic Done,
							output logic [3:0] num_ones
							);
	
	logic [3:0] result;
	
	// define status and control signals
	logic clr_result, load_A, right_shift_A, incr_result;
	logic A_eq_0, lsb_A;
	
	bit_counter_control c_unit (.*);
	bit_counter_datapath d_unit (.*);
	
	always_ff @(posedge clk) begin
		if (reset) num_ones <= 4'b0;
		else begin
			if (!Done) num_ones <= num_ones;
			else if (Done) num_ones <= result;
		end
	end
	
endmodule // bit_counter