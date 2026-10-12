/* Top-level module for LandsLand hardware connections to implement the parking lot system.
	It connects all of the submodules to implement the logic of the system. Outputs are two
	signals controlling external LEDs and a seven segment display of the car count. */

module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, V_GPIO);

	input  logic		 CLOCK_50;	// 50MHz clock
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;	// active low
	output logic [9:0] LEDR;
	inout  logic [35:0] V_GPIO;	// expansion header 0 (LabsLand board)

	// clock setup
	logic [31:0] clk;
	logic SYSTEM_CLOCK;
	clock_divider divider (.clock(CLOCK_50), .divided_clocks(clk));
	// Change this back before the demo!
	assign SYSTEM_CLOCK = CLOCK_50; // 1526 Hz clock signal	
	
	// pin setup for I/O
	logic reset, outer, inner;
	assign reset = V_GPIO[24]; 
	assign outer = V_GPIO[28];
	assign inner = V_GPIO[30];
	assign V_GPIO[32] = outer;
	assign V_GPIO[34] = inner;
	
	// variable to represent number of cards in the lot
	logic [2:0] count;
	
	// signals outputted by parking lot fsm
	logic enter, exit;
	
	// Instantiates the FSM logic. Inputs are the clock, reset signal, outer sensor signal,
	// inner sensor signal. Outputs are one clock pulse indications of when a car has entered
	// or exited the lot.
	parking_lot_fsm		fsm 	(.clk(SYSTEM_CLOCK), .reset, .outer, .inner,
										.enter, .exit);
	
	// Instantiates the car counting logic. Inputs are the clock, reset signal, enter signal 
	// (telling the system to increment the counter) and exit signal (telling the system to
	// decrement the counter). The output is the three bit variable count, describing how many
	// cars are currently in the lot.
	car_counter 			counter 	(.clk(SYSTEM_CLOCK), .reset, .incr(enter), .decr(exit),
										.count);
	
	// Instantiates the display modeule which takes in the three bit count variable from
	// car_counter and outputs a visual representation of the number of cars in the lot
	// on the seven segment display.
	display					seg7 (.count, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5);

endmodule  // DE1_SoC

