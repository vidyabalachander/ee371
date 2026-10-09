/* Top-level module for LandsLand hardware connections to implement the parking lot system.*/

module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, V_GPIO);

	input  logic		 CLOCK_50;	// 50MHz clock
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;	// active low
	output logic [9:0] LEDR;
	inout  logic [35:0] V_GPIO;	// expansion header 0 (LabsLand board)
	
    // Turn off all 7-seg displays (active low: 1 = off, 0 = on)
	/*
	assign HEX0 = 7'b1111111;
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	*/
	// clock setup
	logic [31:0] clk;
	logic SYSTEM_CLOCK;

	clock_divider divider (.clock(CLOCK_50), .divided_clocks(clk));

	assign SYSTEM_CLOCK = clk[14]; // 1526 Hz clock signal	
	
	logic reset, outer, inner;
	assign reset = V_GPIO[24]; 
	assign outer = V_GPIO[28];
	assign inner = V_GPIO[30];
	assign V_GPIO[32] = outer;
	assign V_GPIO[34] = inner;
	
	logic [2:0] count;
	
	logic enter, exit;
	
	parking_lot_fsm		fsm 	(.clk(SYSTEM_CLOCK), .reset, .outer, .inner,
										.enter, .exit);
										
	car_counter 			counter 	(.clk(SYSTEM_CLOCK), .reset, .incr(enter), .decr(exit),
										.count);
	
	display					seg7 (.count, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5);
	
			
	

endmodule  // DE1_SoC

