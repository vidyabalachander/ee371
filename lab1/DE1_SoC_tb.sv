/* testbench for the DE1_SoC */
module DE1_SoC_tb();

	// define signals
	logic	CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	wire [35:0] V_GPIO;
	
	// define parameters
	parameter T = 20;
	
	// Connect testbench signals to GPIO inputs.
	logic reset, outer, inner;
   assign V_GPIO[24] = reset;
   assign V_GPIO[28] = outer;
   assign V_GPIO[30] = inner;
	
	// instantiate module
	DE1_SoC dut (.*);
	
	// define simulated clock
	initial begin
		CLOCK_50 <= 0;
		forever	#(T/2)	CLOCK_50 <= ~CLOCK_50;
	end  // initial clock
	
	initial begin
		// Reset to clear
      reset <= 1; outer <= 0; inner <= 0;		@(posedge CLOCK_50);
      reset <= 1; outer <= 0; inner <= 0;		@(posedge CLOCK_50);
      reset <= 0;										@(posedge CLOCK_50);
		reset <= 0;										@(posedge CLOCK_50);

      // Testing entry sequence
      outer <= 1; inner <= 0;						@(posedge CLOCK_50);
      outer <= 1; inner <= 1;						@(posedge CLOCK_50);
      outer <= 0; inner <= 1;						@(posedge CLOCK_50);
      outer <= 0; inner <= 0;						@(posedge CLOCK_50);
      // Display should show 01 and the LEDs Off-board should both be off.
		
		// Testing no inputs
      outer <= 0; inner <= 0;						@(posedge CLOCK_50);
      outer <= 0; inner <= 0;						@(posedge CLOCK_50);
      outer <= 0; inner <= 0;						@(posedge CLOCK_50);

      // Testing exit sequence
      outer <= 0; inner <= 1;						@(posedge CLOCK_50);
      outer <= 1; inner <= 1;						@(posedge CLOCK_50);
      outer <= 1; inner <= 0;						@(posedge CLOCK_50);
      outer <= 0; inner <= 0;						@(posedge CLOCK_50);	
		
		//Holding for a few clock cycles to see the changes
		outer <= 0; inner <= 0;						@(posedge CLOCK_50);	
		outer <= 0; inner <= 0;						@(posedge CLOCK_50);	
		outer <= 0; inner <= 0;						@(posedge CLOCK_50);	
		
		$stop;
	end
	
endmodule  // DE1_SoC_tb
