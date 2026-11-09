// This module defines the datapath for the bit counter. It takes in the system clock
// and 8 bit input A, as well as numerous control signals from the controller. It outputs
// a 4 bit result, counting the number of 1's in A, as well as a few status signals going
// to the controller.
module bit_counter_datapath (
							input logic clk,
							input logic [7:0] A,
							output logic [3:0] result,
							output logic A_eq_0, lsb_A,
							input logic clr_result, load_A, right_shift_A, incr_result
							);
	
	// copy of A
	logic [7:0] data;
	
	// datapath logic
	always_ff @(posedge clk) begin
		if (load_A) 
			data <= A;
		else if (right_shift_A)
			data <= data >> 1;
			
		if (clr_result)		
			result <= 4'b0;
		else if (incr_result) 		
			result <= result + 1'b1;
	end
	
	// output assignments
	assign A_eq_0 = (data == 8'b0);
	assign lsb_A = data[0];
	
endmodule // bit_counter_datapath