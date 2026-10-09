/* Top-level module for LandsLand hardware connections to implement the parking lot system.*/

module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, V_GPIO);

	input  logic		 CLOCK_50;	// 50MHz clock
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;	// active low
	output logic [9:0] LEDR;
	inout  logic [35:0] V_GPIO;	// expansion header 0 (LabsLand board)
	
    // Turn off all 7-seg displays (active low: 1 = off, 0 = on)
	assign HEX0 = 7'b1111111;
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	
	// clock setup
	logic [31:0] clk;
	logic SYSTEM_CLOCK;

	clock_divider divider (.clock(CLOCK_50), .divided_clocks(clk));

	assign SYSTEM_CLOCK = clk[14]; // 1526 Hz clock signal	
	
	logic reset, outer, inner;
	
	logic outer, inner, enter, exit;
	
	parking_lot_fsm		fsm 	(.clk(SYSTEM_CLOCK), .reset, .outer, .inner,
										.enter, .exit);
										
	

	
	

endmodule  // DE1_SoC
