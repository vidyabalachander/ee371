/* Given two points on the screen this module draws a line between
 * those two points by coloring necessary pixels
 *
 * Inputs:
 *   clk    - should be connected to a 50 MHz clock
 *   reset  - resets the module and starts over the drawing process
 *	 x0 	- x coordinate of the first end point
 *   y0 	- y coordinate of the first end point
 *   x1 	- x coordinate of the second end point
 *   y1 	- y coordinate of the second end point
 *
 * Outputs:
 *   x 		- x coordinate of the pixel to color
 *   y 		- y coordinate of the pixel to color
 *   done	- flag that line has finished drawing
 *
 */
module line_drawer(clk, reset, x0, y0, x1, y1, x, y, done);
	input logic clk, reset;
	input logic [10:0]	x0, y0, x1, y1;
	output logic done;
	output logic [10:0]	x, y;
	

	logic signed [11:0] error;
	logic [10:0] x0_s, x1_s, y0_s, y1_s;
	logic [10:0] x_curr, y_curr;
	
	always_comb begin
		// this if/else block handles the case when x0 is greater than x1. we switch x and y 
		// start and ends so that we always draw moving left to right
		if (x0 > x1) begin
			x0_s = x1;
			x1_s = x0;
			y0_s = y1;
			y1_s = y0;
		end else begin
			x0_s = x0;
			x1_s = x1;
			y0_s = y0;
			y1_s = y1;
		end
		
	end // always_comb
	
	always_ff @(posedge clk) begin
		if (reset) begin
			x_curr <= x0_s;
			y_curr <= y0_s;
			done <= 0;
		end else begin
			if (x_curr < x1_s) begin
				x_curr <= x_curr + 1'b1;
			end else begin
				done <= 1;
			end
		end
	end  // always_ff
	
	assign x = x_curr;
	assign y = y_curr;
	
endmodule  // line_drawer