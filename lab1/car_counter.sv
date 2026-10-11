/*
	The car_counter module keeps track of the occupancy of the parking 
	lot using the incr and decr signals. These signals represent when 
	a car has entered or exited the parking lot. The counter can hold 0
	to 5 cars, outputted as a 3 bit variable count.
*/
module car_counter (input logic clk, reset, incr, decr,
				output logic [2:0] count);
	
	// always_ff is a synchronized car counter
	always_ff @(posedge clk) begin
		if (reset) count = 0;
		else begin
			case ({incr, decr})
				2'b10: if (count < 3'd5) count <= count + 1'b1;
				2'b01: if (count > 3'd0) count <= count - 1'b1;
				default: count <= count;
			endcase // case statement
		end // else statement
	end // always_ff
	
endmodule // car_counter
