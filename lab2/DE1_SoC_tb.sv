/*
	This is the top-level module for this lab project. It initializes and selects between single-port 32x3 RAM 
	and RAM with separate read and write ports. Hex displays are used to display the value being written, the address
	the value is written at, or the address a value is read from.
*/
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

      // Resetting the counter
      KEY[3] = 0;
      repeat (5) @(negedge CLOCK_50);

		KEY[3] = 1;
      repeat (5) @(negedge CLOCK_50);

      SW[9] = 1;
      repeat (5) @(negedge CLOCK_50);
      $display("Task 3 initial value: expected 3");

      // Testing Task 2 write
      SW[9] = 0;
      SW[8:4] = 5'd0;
      SW[3:1] = 3'd5;
      repeat (5) @(negedge CLOCK_50);

      SW[0] = 1;
      repeat (5) @(negedge CLOCK_50);

      // Return to reading address 0.
      SW[0] = 0;
      repeat (5) @(negedge CLOCK_50);
      $display("Task 2 after write: expected 5");

      // Task 3 should still contain 3.
      SW[9] = 1;
      repeat (5) @(negedge CLOCK_50);
      $display("Task 3 unchanged: expected 3");


      // Prepare to write 6 to Task 3, address 0.
      SW[3:1] = 3'd6;
      repeat (5) @(negedge CLOCK_50);

      SW[0] = 1;
      repeat (5) @(negedge CLOCK_50);
		 
      // Stop writing before checking the output.
      // Reading and writing the same address simultaneously
      SW[0] = 0;
      repeat (5) @(negedge CLOCK_50);
      $display("Task 3 after write: expected 6");

		// Task 2 should still contain 5.
      SW[9] = 0;
      repeat (5) @(negedge CLOCK_50);
      $display("Task 2 unchanged: expected 5");
      $stop;
		
    end
endmodule //DE1_SOC_tb