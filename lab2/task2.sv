module task2 (clk, wren, addr,dataIn, q);
	
	input logic 	[4:0] addr;
	input logic 	[2:0] dataIn;
	output logic 	[2:0] q;
	
	input logic 	clock, wren;
	
	logic [4:0] memory_array [31:0];
	
	always_ff @(posedge clock) begin
		if (wren) begin
			memory_array[addr] <= dataIn;
		end
		q <= memory_array[addr];
	end
	
endmodule //task2