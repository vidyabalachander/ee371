// Testbench for the binary search algorithm. Tests various numbers within the RAM array
// as well as numbers outside the array. Also tests basic functionality.
`timescale 1 ps / 1 ps
module bst_tb();

	// define module port connections
	logic clk, reset, s, Done, Found;
	logic [4:0] Loc;
	logic [7:0] A;
	
	// instantiating device under test module
	bst dut(.*);
	
	// create simulated clock
	parameter period = 100;
	initial begin
		clk <= 0;
		forever
			#(period/2)
			clk <= ~clk;
	end
	
	initial begin
		// Resetting before the simulation
		reset <= 1; s <= 0;		@(posedge clk);
		A <= 8'd0;					@(posedge clk);
		reset <= 0;					@(posedge clk);
		
		
		// Setting target to lower bound value
		A <= 8'd0;					@(posedge clk);
		s <= 1'b1;					@(posedge clk);
		repeat(20)					@(posedge clk);
		s <= 1'b0;					@(posedge clk);
		
		// Checking the very first element we start with
		A <= 8'd123;				@(posedge clk);
		s <= 1;						@(posedge clk);
		repeat (20) 				@(posedge clk);
		s <= 0;						@(posedge clk);
										@(posedge clk);

		// Setting target to upper bound value
		A <= 8'd255;				@(posedge clk);
		s <= 1;						@(posedge clk);
		repeat (20) 				@(posedge clk);
		s <= 0;						@(posedge clk);

		// Checking a random element in the array
		s <= 0;						@(posedge clk);
		A <= 8'd197;				@(posedge clk);
		s <= 1;						@(posedge clk);
		repeat (20) 				@(posedge clk);
		s <= 0;						@(posedge clk);

		// Value not in the array but far from the middle
		s <= 0;						@(posedge clk);
		A <= 8'd1;					@(posedge clk);
		s <= 1;						@(posedge clk);
		repeat (20) 				@(posedge clk);
		s <= 0;						@(posedge clk);

		// Value not in the array but close to the middle
		s <= 0;						@(posedge clk);
		s <= 0;						@(posedge clk);
		A <= 8'd124;				@(posedge clk);
		s <= 1;						@(posedge clk);
		repeat (20) 				@(posedge clk);
		s <= 0;						@(posedge clk);


		// Resetting after a completed search
		s <= 0;						@(posedge clk);
		reset <= 1;					@(posedge clk);
		reset <= 0;					@(posedge clk);

		// Resetting during the binary search
		A <= 8'd255;				@(posedge clk);
		s <= 1;						@(posedge clk);
		s <= 1;						@(posedge clk);
		s <= 1;						@(posedge clk);
		reset <= 1;					@(posedge clk);
		s <= 0;						@(posedge clk);
		reset <= 0;					@(posedge clk);
		reset <= 0;					@(posedge clk);

		$stop;
	end

endmodule //testbench for the bst module