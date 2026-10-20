/*
	This module tests task1, which is the prebuilt 32x3 RAM from Quartus.
	It simulates reading, writing, and overwriting the RAM in both the library-based and array-based RAM implementations.
*/
`timescale 1 ps / 1 ps
module task1_tb;

	logic [4:0] Address;
	logic clk;
	logic [2:0] DataIn;
	logic Write;
	logic [2:0] DataOut;
	
	task1 dut(.*);
	
	logic [2:0] q;
	task2 dut2(.clk, .addr(Address), .wren(Write), .dataIn(DataIn), .q);
	
	parameter period = 100;
	initial begin
		clk <= 0;
		forever
			#(period/2)
			clk <= ~clk;
	end
	
	initial begin
		// Read only
		Write <= 0; @(posedge clk);
		
		// Write mode
		Write <= 1; 
						// Set some Address' values to DataIn
						Address <= 5'b00000; DataIn <= 3'b101; @(posedge clk);
						Address <= 5'b00101; DataIn <= 3'b011; @(posedge clk);
						Address <= 5'b01101; DataIn <= 3'b110; @(posedge clk);
						Address <= 5'b11111; DataIn <= 3'b111; @(posedge clk);
		
		// Read mode
		Write <= 0;
						
						Address <= 5'b00000; @(posedge clk);
						Address <= 5'b00101; @(posedge clk);
						$display("Expected: 3'b101; task1: 3'b%b, task2: 3'b%b", DataOut, q);
						Address <= 5'b01101; @(posedge clk);
						$display("Expected: 3'b011; task1: 3'b%b, task2: 3'b%b", DataOut, q);
						Address <= 5'b11111; @(posedge clk);
						$display("Expected: 3'b110; task1: 3'b%b, task2: 3'b%b", DataOut, q);
													@(posedge clk);
						$display("Expected: 3'b111; task1: 3'b%b, task2: 3'b%b", DataOut, q);
		
		// Write mode (overwriting what was there before)
		Write <= 1;
						Address <= 5'b00000; DataIn <= 3'b011; @(posedge clk);
						Address <= 5'b00101; DataIn <= 3'b101; @(posedge clk);
						Address <= 5'b01101; DataIn <= 3'b111; @(posedge clk);
						Address <= 5'b11111; DataIn <= 3'b110; @(posedge clk);
		
		// Read mode
		Write <= 0;
						Address <= 5'b00000; @(posedge clk);
						Address <= 5'b00101; @(posedge clk);
						$display("Expected: 3'b011; task1: 3'b%b, task2: 3'b%b", DataOut, q);
						Address <= 5'b01101; @(posedge clk);
						$display("Expected: 3'b101; task1: 3'b%b, task2: 3'b%b", DataOut, q);
						Address <= 5'b11111; @(posedge clk);
						$display("Expected: 3'b111; task1: 3'b%b, task2: 3'b%b", DataOut, q);
													@(posedge clk);
						$display("Expected: 3'b110; task1: 3'b%b, task2: 3'b%b", DataOut, q);
		$stop;		
	end // ending simulation

endmodule //task1_tb