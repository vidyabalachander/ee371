module read_rom(clk, address, x0, y0, x1, y1);
	input  logic        clk;
   input  logic [7:0]  address;
   output logic [10:0] x0, y0, x1, y1;

   logic [37:0] q;

   rom_lineart memory (.clock(clk), .*);

   assign x0 = {1'b0,  q[37:28]};
   assign y0 = {2'b00, q[27:19]};
   assign x1 = {1'b0,  q[18:9]};
   assign y1 = {2'b00, q[8:0]};

endmodule  // read_rom