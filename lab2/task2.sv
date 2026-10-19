/*
	This module uses a 5-bit by 32-bit array to simulated ROM by taking address, data, and wren input. If wren is TRUE, 
	the address input is accessed and the value at that address in the 2D-array is overwritten with the data input. 
	If wren is FALSE, the address is located and the current value is output.
*/
module task2 (clk, wren, addr,dataIn, q);
	
	input logic 	[4:0] addr;
	input logic 	[2:0] dataIn;
	output logic 	[2:0] q;
	
	input logic 	clk, wren;
	
	logic [2:0] memory_array [31:0];
	
	always_ff @(posedge clk) begin
		if (wren) begin
			memory_array[addr] <= dataIn;
			q <= dataIn;
		end
		else begin	
			q <= memory_array[addr];
		end
	end
	
endmodule //task2