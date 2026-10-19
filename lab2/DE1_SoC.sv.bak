module DE1_SoC ();
	
	input logic [9:0] SW;
	input logic [3:0] KEY;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	logic [2:0] q;
	
	task2 memory 	(.clk (~KEY[0]), .wren (SW[0]), .addr (sw[8:4]), 
						 .dataIn (sw[3:1]), .q (q));
						 
	seg7 output_display 	(.hex ({1'b0, q}), .leds(HEX0))
	seg7 input_display 	(.hex ({1'b0, SW[3:1]}), .leds(HEX1))
	seg7 addr_l				(.hex (SW[7:4]), .leds(HEX4))
	seg7 addr_h				(.hex ({3'b000, SW[8]}), .leds(HEX5))
	
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	
endmodule 