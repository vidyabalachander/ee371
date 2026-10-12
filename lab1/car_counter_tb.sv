/* Testbench for the car_counter module */
module car_counter_tb();
	
	logic clk, reset, incr, decr;
	logic [2:0] count;
	
	car_counter dut(.*);
	
	parameter period = 100;
	initial begin
		clk <= 0;
		forever
			#(period/2)
			clk <= ~clk;
	end
	
	initial begin
		// resetting to S0
		reset <= 1;	decr <= 0; incr <= 0;  	@(posedge clk);
		reset <= 0;						  			@(posedge clk);
		
		// Testing going from 0 to 5
		incr <= 1; 	decr <= 0;					@(posedge clk);
		incr <= 1; 	decr <= 0;					@(posedge clk);
		incr <= 1; 	decr <= 0;					@(posedge clk);
		incr <= 1; 	decr <= 0;					@(posedge clk);
		incr <= 1; 	decr <= 0;					@(posedge clk);
		
		//Testing further increments above 5
		incr <= 1; 	decr <= 0;					@(posedge clk);
		incr <= 1; 	decr <= 0;					@(posedge clk);

		//Testing going from 5 back down to 0
		incr <= 0; 	decr <= 1;					@(posedge clk);
		incr <= 0; 	decr <= 1;					@(posedge clk);
		incr <= 0; 	decr <= 1;					@(posedge clk);
		incr <= 0; 	decr <= 1;					@(posedge clk);
		incr <= 0; 	decr <= 1;					@(posedge clk);
		
		//Testing going below 0
		incr <= 0; 	decr <= 1;					@(posedge clk);
		incr <= 0; 	decr <= 1;					@(posedge clk);
		
		//Testing changing direction between 0 and 5
		incr <= 1; 	decr <= 0;					@(posedge clk);
		incr <= 1; 	decr <= 0;					@(posedge clk);
		incr <= 1; 	decr <= 0;					@(posedge clk);
		incr <= 0; 	decr <= 1;					@(posedge clk);
		
		//Testing holding at a value
		incr <= 0; 	decr <= 0;					@(posedge clk);
		incr <= 0; 	decr <= 0;					@(posedge clk);	
	
		//Testing simultaneous increment and decrement
		incr <= 1; 	decr <= 1;					@(posedge clk);
		incr <= 1; 	decr <= 1;					@(posedge clk);
		
		$stop;
	end

endmodule //car_counter_tb