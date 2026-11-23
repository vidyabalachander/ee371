`timescale 1 ps / 1 ps
// This module is the testbench for the read_rom module. It checks some known values in the ROM
// And ensures that those are the ones being read by this module.
module read_rom_tb ();
	
	// define module port connections
   logic clk;
   logic [7:0] address;
	logic [10:0] x0, y0, x1, y1;

	// instantiating device under test module
   read_rom dut (.*);
	
	// create simulated clock
	parameter period = 100;
	initial begin
		clk <= 0;
		forever
			#(period/2)
			clk <= ~clk;
	end
	
	initial begin
		//Testing address 0
      address <= 0; 															@(posedge clk);
		repeat(10)																@(posedge clk);
      if (dut.q == 38'b01000011000110100110100001111011000001)
         $display("Address 0: SUCCESS");
      else
         $display("Address 0: FAIL");

		//Testing address 19
		address <= 19; 														@(posedge clk);
		repeat(10)																@(posedge clk);

      if (dut.q == 38'b01001010010101101010100110010010110101)
         $display("Address 19: SUCCESS");
      else
         $display("Address 19: FAIL");
		
		//Testing address 55
      address <= 55; 														@(posedge clk);
		repeat(10)																@(posedge clk);
      if (dut.q == 38'b01011011000101111010101101110010111011)
         $display("Address 55: SUCCESS");
      else
         $display("Address 55: FAIL");

		//Testing address 114
      address <= 114; 														@(posedge clk);
		repeat(10)																@(posedge clk);
      if (dut.q == 38'b00110111001011001000110100100101100100)
         $display("Address 114: SUCCESS");
      else
         $display("Address 114: FAIL");

     
		//Testing address 137
		address <= 137; 														@(posedge clk);
		repeat(10)																@(posedge clk);
      if (dut.q == 38'b01000101111010110000100010100101010101)
         $display("Address 137: SUCCESS");
      else
         $display("Address 137: FAIL");

      $stop;
   end
endmodule // read_rom_tb