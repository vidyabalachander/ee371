/*
	This is the top-level module for this lab project. It initializes and selects between single-port 32x3 RAM 
	and RAM with separate read and write ports. Hex displays are used to display the value being written, the address
	the value is written at, or the address a value is read from.
*/
`timescale 1 ps / 1 ps
module DE1_SoC_tb();

	logic CLOCK_50;
   logic [9:0] SW;
   logic [3:0] KEY;
   logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

   DE1_SoC dut (.*);

   // CLOCK_50 will have a period of 20 ns
   initial begin
       CLOCK_50 = 0;
       forever 
			#10 
			CLOCK_50 = ~CLOCK_50;
   end

	initial begin
      SW = 10'b0;
      KEY = 4'b1111;

      // Resetting
      KEY[3] <= 0;			@(posedge CLOCK_50);
      repeat (5)				@(posedge CLOCK_50);
		KEY[3] <= 1;			@(posedge CLOCK_50);
      repeat (5)				@(posedge CLOCK_50);
		
		//Testing write for Task 3
		SW[0] <= 0;				@(posedge CLOCK_50);
		repeat (5)				@(posedge CLOCK_50);
		
		SW[9] <= 1;				@(posedge CLOCK_50);
		SW[8:4] <= 5'd0;		@(posedge CLOCK_50);
		SW[3:1] <= 3'd5;		@(posedge CLOCK_50);
		repeat (5)				@(posedge CLOCK_50);
		
		SW[0] <= 1;				@(posedge CLOCK_50);
		repeat (5)				@(posedge CLOCK_50);
		
		SW[0] <= 0;				@(posedge CLOCK_50);
		repeat (5)				@(posedge CLOCK_50);		

      $display("Expected task3 value: 101");
		
		//Testing write for Task 2
		SW[0] <= 0;				@(posedge CLOCK_50);
		repeat (5);				@(posedge CLOCK_50);
		
		SW[9] <= 0;				@(posedge CLOCK_50);
		SW[8:4] <= 5'd0;		@(posedge CLOCK_50);
		SW[3:1] <= 3'd6;		@(posedge CLOCK_50);
		repeat (5);				@(posedge CLOCK_50);
		
		SW[0] <= 1;				@(posedge CLOCK_50);
		repeat (5);				@(posedge CLOCK_50);
		
		SW[0] <= 0;				@(posedge CLOCK_50);
		repeat (5);				@(posedge CLOCK_50);			
		
      $display("Expected task2 value: 110");

		// Reset after writing
		KEY[3] <= 0;			@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);
		KEY[3] <= 1;			@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);
		$display("Expected task2 value: 110");

		// Both should retain their values
		SW[9] <= 1;				@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);
		$display("Expected task3 value: 101");

		// Overwrite address 0: Task 3 with 6.
		SW[3:1] <= 3'd6;		@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);

		SW[0] <= 1;				@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);
		SW[0] <= 0;				@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);
		$display("Expected task3 value: 110");

		// Overwrite address 0: Task 2 with 2.
		SW[9] <= 0;				@(posedge CLOCK_50);
		SW[3:1] <= 3'd2;		@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);

		SW[0] <= 1;				@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);
		SW[0] <= 0;				@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);
		$display("Expected task2 value: 010");

		// Writing disabled: Task 2 should retain 2.
		SW[3:1] <= 3'd4;		@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);
		$display("Expected task2 value: 010");

		// Writing disabled: Task 3 should retain 6.
		SW[9] <= 1;				@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);
		$display("Expected task3 value: 110");

		// Write 7 to address 31: Task 3.
		// Write address displays 1F; input displays 7.
		SW[8:4] <= 5'd31;		@(posedge CLOCK_50);
		SW[3:1] <= 3'd7;		@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);
	
		SW[0] <= 1;				@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);
		SW[0] <= 0;				@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);


		// Write 7 to address 31: Task 2.
		SW[9] <= 0;				@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);

		SW[0] <= 1;				@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);
		SW[0] <= 0;				@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);


		// Attempt writing during reset: Task 2.
		KEY[3] <= 0;			@(posedge CLOCK_50);
		SW[8:4] <= 5'd0;		@(posedge CLOCK_50);
		SW[3:1] <= 3'd1;		@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);

		SW[0] <= 1;				@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);


		// Attempt writing during reset: Task 3.
		KEY[3] <= 0;			@(posedge CLOCK_50);
		SW[9] <= 1;				@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);

		SW[0] <= 1;				@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);

		SW[0] <= 0;				@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);
		KEY[3] <= 1;			@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);

		// Task 3: read address 0 while writing address 10.
		SW[8:4] <= 5'd10;		@(posedge CLOCK_50);
		SW[3:1] <= 3'd4;		@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);

		SW[0] <= 1;				@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);

		SW[0] <= 0;				@(posedge CLOCK_50);
		repeat (5) 				@(posedge CLOCK_50);
		$stop;
		
    end
endmodule //DE1_SOC_tb