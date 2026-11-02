/* Testbench for the rom_to_codec module. Checks counter advancement, wraparound to the first address, 
	and pausing and resuming writes */
`timescale 1 ps / 1 ps

module rom_to_codec_tb ();
	logic clk, write;
	logic [23:0] rom_data_left, rom_data_right;
	
	//Wrapping at 4 addresses just for the testbench
	rom_to_codec #(.counter_max(4)) dut (.*);
	
	parameter period = 100;
	initial begin
		clk <= 0;
		forever
			#(period/2)
			clk <= ~clk;
	end
	
	initial begin
		// Keeping write off - ccounter should stay 0
		write <= 0; 	@(posedge clk);
		write <= 0;		@(posedge clk);
		write <= 0;		@(posedge clk);

		// Start writing - counter should advance and eventually wrap to 0
		write <= 1; 	@(posedge clk);
		write <= 1;		@(posedge clk);
		write <= 1;		@(posedge clk);
		write <= 1;		@(posedge clk);
		write <= 1;		@(posedge clk);
		write <= 1;		@(posedge clk);

		// Pause writing - counter pauses
		write <= 0; 	@(posedge clk);
		write <= 0;		@(posedge clk);
		write <= 0;		@(posedge clk);

		// Resume writing should resume from the address paused at
		write <= 1; 	@(posedge clk);
		write <= 1;    @(posedge clk);
		write <= 1;		@(posedge clk);
		write <= 1;		@(posedge clk);
		write <= 1;		@(posedge clk);

		// Checking that values hold when write is paused.
		write <= 0; 	@(posedge clk);
		write <= 0;		@(posedge clk);

		$stop;
	end
	
endmodule 