// The testbench for the top level module, DE1_SoC
`timescale 1 ps / 1 ps

module DE1_SoC_tb ();
	
	logic clk;
	logic [9:0] SW;
	logic [3:0] KEY;
	logic [9:0] LEDR;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	DE1_SoC dut (.CLOCK_50(clk), .*);
	
	// create simulated clock
	parameter period = 100;
	initial begin
		clk <= 0;
		forever
			#(period/2)
			clk <= ~clk;
	end
	
	initial begin
		// test reset
		KEY[0] <= 0; @(posedge clk);
		KEY[0] <= 1; @(posedge clk);
		
		
		// set some A
		// press start
		// wait a while
		// until posedge LEDR[9]
		// verify hex 0 shows the right value
		// unpress start
		SW[6] <= 1; SW[4] <= 1; SW[1] <= 1; @(posedge clk);
		KEY[3] <= 0; @(posedge clk);
						@(posedge clk)
		KEY[3] <= 1; @(posedge clk);
		repeat(20)	@(posedge clk);
		
		
		// toggle sw 9 = 1
		// set some A that we know is in the ram
		// press start
		// wait until the done light LEDR[9] is found
		// verify that found light LEDR[0] is on
		// hex 1 and 0 should show the right address
		// unpress start
		SW[9] <= 1; @(posedge clk);
		SW[3] <= 1; SW[6] <= 0; SW[4] <= 0; SW[1] <= 0; @(posedge clk);
		KEY[3] <= 0; @(posedge clk);
		while (!LEDR[9]) @(posedge clk);
		KEY[3] <= 1; @(posedge clk);
		
		// keep sw 9 = 1
		// set some A that we know is not in the ram
		// press start
		// wait until the done light LEDR[9] is found
		// verify that found light LEDR[0] is off
		// hex 1 and 0 should be of (all 1's)
		// unpress start
		SW[0] <= 1; @(posedge clk);
		KEY[3] <= 0; @(posedge clk);
		while (!LEDR[9]) @(posedge clk);
		KEY[3] <= 1; @(posedge clk);
		
		// turn off sw 9 
		// set a new A
		// wait a while
		// until posedge LEDR[9]
		// verify hex 0 shows the right value
		// unpress start
		SW[9] <= 0; @(posedge clk);
		SW[7] <= 1; SW[6] <= 1; SW[5] <= 1; SW[4] <= 1; 
		SW[3] <= 1; SW[2] <= 1; SW[1] <= 1; SW[0] <= 1; @(posedge clk);
		KEY[3] <= 0; @(posedge clk);
		while (!LEDR[9]) @(posedge clk);
		KEY[3] <= 1; @(posedge clk);
		
		$stop;
	end

endmodule // DE1_SoC_tb