// This module instantiates the binary search algorithm, by instantiating the control, datapath, and the RAM.
// This algorithm seraches through a sorted array to determine whether an input target value is present in the 
// array. If it is present, the algorithm outputs the address at which the value is present in the RAM. It also
// outputs signals Done and Found, which are asserted respectively when the search is completed, and if the input
// value is present in the RAM.
module bst (clk, reset, s, A, Loc, Done, Found);

   input logic clk, reset, s;
   input logic [7:0] A;

   output logic [4:0] Loc;
   output logic Done, Found;

   // Control signals.
   logic initialize, update_low, update_high, save;

   // Status signals.
   logic equal, less, at_low, at_high;

   // Memory connections.
   logic [4:0] address;
   logic [7:0] data_out;

	// instantiating the control and datapath units
   bst_control control (.*);
   bst_datapath datapath (.*);

	// instantiating the RAM based on the my_array.mif file
   ram32x8 memory (.address, .clock(clk), .data(8'd0), .wren(1'b0), .q(data_out));
						
endmodule //task2 - binary search algorithm