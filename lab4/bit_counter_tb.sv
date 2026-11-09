// The testbench for the bit_counter module. Tests all 8 bit numbers.
module bit_counter_tb ();

	// define module port connections
	logic [7:0] A;
	logic clk, s, reset, Done;
	logic [3:0] result;
	
	// instantiate module
   bit_counter dut (.*);
	
	// create simulated clock
	parameter period = 100;
	initial begin
		clk <= 0;
		forever
			#(period/2)
			clk <= ~clk;
	end
	
   integer i;
	initial begin
		reset <= 1; s <= 0;  @(posedge clk);
		A <= 8'b0;				@(posedge clk);
		reset <= 0;          @(posedge clk);
		
		for (i = 0; i < 2**8; i++) begin
			A <= i; @(posedge clk);
			s <= 1; @(posedge clk);
			
			while (!Done) @(posedge clk);
			
			$display("T = %4t, bit_counter(%8b) = %1d",
			         $time, A, result); 
						
			s <= 0; @(posedge clk);
		end
		@(posedge clk);
		$stop();
	end  // initial
	
endmodule  // bit_counter_tb