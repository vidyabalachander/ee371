/* This helper module goes through the ROM of values that represent one line on the VGA
 * Each word has 38 bits, with the first 10 bits representing x0, the next 9 representing y0,
 * the next 10 representing x1, and the last 9 representing y1.
 */
module read_rom(clk, address, x0, y0, x1, y1);
	
	input  logic        clk;
   input  logic [7:0]  address;
   output logic [10:0] x0, y0, x1, y1;

   logic [37:0] q;
	
	// Instantiating the ROM
   rom_lineart memory (.clock(clk), .*);

	// Assigning the respective range of digits of the word to the correct value
   assign x0 = {1'b0,  q[37:28]};
   assign y0 = {2'b00, q[27:19]};
   assign x1 = {1'b0,  q[18:9]};
   assign y1 = {2'b00, q[8:0]};

endmodule  // read_rom