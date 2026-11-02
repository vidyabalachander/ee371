module fir_filter_tb();
	
	logic clk, reset, enable;
	logic [23:0] data_in, data_out;
	
	//For convenience, we're testing a buffer that averages 8 samples
	//In our actual module, we used a buffer that averaged 512 samples
	fir_filter #(.DATA_WIDTH(24), .LOG_2_N(3)) dut(.*);
	
	parameter period = 100;
	initial begin
		clk <= 0;
		forever
			#(period/2)
			clk <= ~clk;
	end
	
	initial begin
		
		//Resetting the accumulator and FIFO buffer
		reset <= 1'b1;			@(posedge clk);
		enable <= 1'b0;		@(posedge clk);
		reset <= 1'b0;			@(posedge clk);
		
		//Filling the buffer with 8 identical samples
		data_in <= 24'd16;	@(posedge clk);
		enable <= 1'b1;		@(posedge clk);
		enable <= 1'b1;		@(posedge clk);
		enable <= 1'b1;		@(posedge clk);
		enable <= 1'b1;		@(posedge clk);
		enable <= 1'b1;		@(posedge clk);
		enable <= 1'b1;		@(posedge clk);
		enable <= 1'b1;		@(posedge clk);
		enable <= 1'b1;		@(posedge clk);
		
		//Replacing old samples with new identical samples should keep the output the same
		enable <= 1'b1;		@(posedge clk);
		enable <= 1'b1;		@(posedge clk);
		
		//Trying to change input with enable off. 
		//Also checks whether value holds when enable is off
		enable <= 1'b0;		@(posedge clk);
		data_in <= 24'd0;		@(posedge clk);
		data_in <= 24'd0;		@(posedge clk);
		
		//Enabling and setting samples to 0
		data_in <= 24'd0;		@(posedge clk);
		enable <= 1'b1;		@(posedge clk);
		enable <= 1'b1;		@(posedge clk);
		enable <= 1'b1;		@(posedge clk);
		enable <= 1'b1;		@(posedge clk);
		enable <= 1'b1;		@(posedge clk);
		enable <= 1'b1;		@(posedge clk);
		enable <= 1'b1;		@(posedge clk);
		enable <= 1'b1;		@(posedge clk);
		
		//Using different inputs and checking the total
		data_in <= 24'd16;	@(posedge clk);
		enable <= 1'b1;		@(posedge clk);
		data_in <= 24'd24;	@(posedge clk);
		data_in <= 24'd8;		@(posedge clk);
		data_in <= 24'd24;	@(posedge clk);
		data_in <= 24'd8;		@(posedge clk);
		data_in <= 24'd24;	@(posedge clk);
		data_in <= 24'd8;		@(posedge clk);
		data_in <= 24'd16;	@(posedge clk);
		
		//Resetting should set the samples to 0
		reset <= 1'b1;			@(posedge clk);
		enable <= 1'b0;		@(posedge clk);
		reset <= 1'b0;			@(posedge clk);
		
		$stop;
		
	end 
	
endmodule 