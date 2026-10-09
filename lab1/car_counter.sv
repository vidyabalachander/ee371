module car_counter (input logic clk, reset, incr, decr,
				output logic [2:0] count);
	
	
	always_ff @(posedge clk) begin
		if (reset) count = 0;
		else begin
			case ({incr, decr})
				2'b10: if (count < 3'd5) count <= count + 1'b1;
				2'b01: if (count > 3'd0) count <= count - 1'b1;
				default: count <= count;
			endcase
		end
	end
	
endmodule
