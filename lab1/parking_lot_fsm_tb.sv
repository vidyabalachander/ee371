/* Testbench for parking_lot_fsm */
module parking_lot_fsm_tb();
	
	logic clk, reset, outer, inner, enter, exit;
	
	parking_lot_fsm dut (.*);
	
	parameter period = 100;
	initial begin
		clk <= 0;
		forever
			#(period/2)
			clk <= ~clk;
	end

	// The testbench tests all possible transitions.
	initial begin
		// resetting to S0
		reset <= 1;	outer <= 0;	inner <= 0; @(posedge clk);
		reset <= 0;						  			@(posedge clk);
		
					// entry path test
						// stay in S0
						outer <= 0;	inner <= 0; @(posedge clk);
						// move to S1
						outer <= 1;	inner <= 0; @(posedge clk);
						// stay in S1
						outer <= 1;	inner <= 0; @(posedge clk);
						// move to S2
						outer <= 1;	inner <= 1; @(posedge clk);
						// stay in S2
						outer <= 1;	inner <= 1; @(posedge clk);
						// move to S3
						outer <= 0;	inner <= 1; @(posedge clk);
						// stay in S3
						outer <= 0;	inner <= 1; @(posedge clk);
						// move to S0
						outer <= 0;	inner <= 0; @(posedge clk);
					
					// exit path testbench
						// move to S4
						outer <= 0;	inner <= 1; @(posedge clk);
						// stay in S4
						outer <= 0;	inner <= 1; @(posedge clk);
						// move to S5
						outer <= 1;	inner <= 1; @(posedge clk);
						// stay in S5
						outer <= 1;	inner <= 1; @(posedge clk);
						// move to S6
						outer <= 1;	inner <= 0; @(posedge clk);
						// stay in S6
						outer <= 1;	inner <= 0; @(posedge clk);
						// move to S0
						outer <= 0;	inner <= 0; @(posedge clk);
					
					// testing select invalid sequences
						// move to S1
						outer <= 1;	inner <= 0; @(posedge clk);
						// invalid, return to S0
						outer <= 0;	inner <= 1; @(posedge clk);
						
						// move to S1
						outer <= 1;	inner <= 0; @(posedge clk);
						// move to S2
						outer <= 1;	inner <= 1; @(posedge clk);
						// invalid, return to S0
						outer <= 1;	inner <= 0; @(posedge clk);
						
						// move to S1
						outer <= 1;	inner <= 0; @(posedge clk);
						// move to S2
						outer <= 1;	inner <= 1; @(posedge clk);
						// move to S3
						outer <= 0;	inner <= 1; @(posedge clk);
						// invalid, return to S0
						outer <= 1; inner <= 1; @(posedge clk);
						
						// move to S4
						outer <= 0;	inner <= 1; @(posedge clk);
						// invalid, return to S0
						outer <= 1;	inner <= 0; @(posedge clk);
						
						// move to S4
						outer <= 0;	inner <= 1; @(posedge clk);
						// move to S5
						outer <= 1;	inner <= 1; @(posedge clk);
						// invalid, return to S0
						outer <= 0;	inner <= 1; @(posedge clk);
						
						// move to S4
						outer <= 0;	inner <= 1; @(posedge clk);
						// move to S5
						outer <= 1;	inner <= 1; @(posedge clk);
						// move to S6
						outer <= 1;	inner <= 0; @(posedge clk);
						// invalid, return to S0
						outer <= 0;	inner <= 1; @(posedge clk);
						
												@(posedge clk);
		$stop;
		
	end
	
endmodule  // parking_lot_fsm_tb
