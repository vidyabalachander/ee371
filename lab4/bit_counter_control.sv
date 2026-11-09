// This module defines the controller for the bit counter. It takes in the system clock,
// a reset signal, and a start signal, as well as c few status signals from the datapath.
// It outputs a Done signal to the higher level bit_counter module as well as numerous
// control signals going to the datapath.
module bit_counter_control (
							input logic clk, reset, s,
							input logic A_eq_0, lsb_A,
							output logic Done,
							output logic clr_result, load_A, right_shift_A, incr_result
							);
	
	// define state names and variables
	enum {S1, S2, S3} ps, ns;
	
	// controller logic with synchronous reset
	always_ff @(posedge clk)
		if (reset)
			ps <= S1;
		else
			ps <= ns;
	
	// next state logic
	always_comb
		case (ps)
			S1: ns = s ? S2 : S1;
			S2: ns = A_eq_0 ? S3 : S2;
			S3: ns = s ? S3 : S1;
		endcase
		
	// moore outputs
	assign clr_result = (ps == S1);
	assign right_shift_A = (ps == S2);
	assign Done = (ps == S3);
	
	// mealy outputs
	assign load_A = (ps == S1) & ~s;
	assign incr_result = (ps == S2) & ~A_eq_0 & lsb_A;

endmodule // bit_counter_control