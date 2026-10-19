`timescale 1 ps / 1 ps
/*
	This module tests task2, which is a 32x3 RAM built using a 2-dimensional array.
	It simulates reading, writing, and overwriting the RAM.
*/
module task2_tb();

	logic [4:0] addr;
   logic clk;
   logic [2:0] dataIn;
   logic wren;
   logic [2:0] q;

   task2 dut (.*);

   parameter period = 100;

   initial begin
       clk = 0;
       forever #(period/2) clk = ~clk;
   end

	initial begin
       wren = 0;
       addr = 0;
       dataIn = 0;
       @(negedge clk);

       // Write values to four addresses.
       wren = 1;

       addr = 5'b00000; dataIn = 3'b101;
       @(negedge clk);

       addr = 5'b00101; dataIn = 3'b011;
       @(negedge clk);

       addr = 5'b01101; dataIn = 3'b110;
       @(negedge clk);

       addr = 5'b11111; dataIn = 3'b111;
       @(negedge clk);

       // Read the stored values.
       wren = 0;

       addr = 5'b00000;
       @(negedge clk);
       $display("Expected: 101; q: %b", q);

       addr = 5'b00101;
       @(negedge clk);
       $display("Expected: 011; q: %b", q);

       addr = 5'b01101;
       @(negedge clk);
       $display("Expected: 110; q: %b", q);

       addr = 5'b11111;
       @(negedge clk);
       $display("Expected: 111; q: %b", q);

		 // Overwrite the same addresses.
       wren = 1;

       addr = 5'b00000; dataIn = 3'b011;
       @(negedge clk);

       addr = 5'b00101; dataIn = 3'b101;
       @(negedge clk);

       addr = 5'b01101; dataIn = 3'b111;
       @(negedge clk);

       addr = 5'b11111; dataIn = 3'b110;
       @(negedge clk);

       // Read the updated values.
       wren = 0;

       addr = 5'b00000;
       @(negedge clk);
       $display("Expected: 011; q: %b", q);

       addr = 5'b00101;
       @(negedge clk);
       $display("Expected: 101; q: %b", q);

       addr = 5'b01101;
       @(negedge clk);
       $display("Expected: 111; q: %b", q);

       addr = 5'b11111;
       @(negedge clk);
       $display("Expected: 110; q: %b", q);

       $stop;
   end
endmodule //task2_tb