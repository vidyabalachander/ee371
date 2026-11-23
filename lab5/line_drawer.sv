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
	
	/* You'll need to create some registers to keep track of things
	 * such as error and direction.
	 */
	logic signed [11:0] 	error, error_after_add;  // example - feel free to change/delete
	logic [10:0] 			dx, dy;
	logic 					is_steep;
	logic [10:0] 			axis1_0, axis2_0, axis1_1, axis2_1;
   logic [10:0] 			axis1_start, axis2_start, axis1_end, axis2_end;
   logic [10:0] 			axis1_distance, axis2_distance;
   logic [10:0] 			axis1_pos, axis2_pos;
	
	always_comb begin
		dx	= (x1 >= x0) ? (x1 - x0) : (x0 - x1);
		dy	= (y1 >= y0) ? (y1 - y0) : (y0 - y1);
		is_steep = (dy > dx);
		
		axis1_0 = is_steep ? y0 : x0;
      axis2_0 = is_steep ? x0 : y0;
      axis1_1 = is_steep ? y1 : x1;
      axis2_1 = is_steep ? x1 : y1;

      axis1_distance = is_steep ? dy : dx;
      axis2_distance = is_steep ? dx : dy;
		
		if (axis1_0 > axis1_1) begin
			axis1_start = axis1_1;
         axis2_start = axis2_1;
         axis1_end   = axis1_0;
         axis2_end   = axis2_0;
      end else begin
         axis1_start = axis1_0;
         axis2_start = axis2_0;
         axis1_end   = axis1_1;
         axis2_end   = axis2_1;
      end

      error_after_add = error + $signed({1'b0, axis2_distance});
	end
	
	always_ff @(posedge clk) begin
		if (reset) begin
			axis1_pos <= axis1_start;
         axis2_pos <= axis2_start;
         error     <= -($signed({1'b0, axis1_distance}) / 2);
			done <= 1'b0;
      end else if (axis1_pos < axis1_end) begin
			axis1_pos <= axis1_pos + 11'd1;

         if ((axis2_distance != 0) && (error_after_add >= 0)) begin
				if (axis2_start < axis2_end)
                axis2_pos <= axis2_pos + 11'd1;
            else
                axis2_pos <= axis2_pos - 11'd1;

            error <= error_after_add - $signed({1'b0, axis1_distance});
         end else begin
            error <= error_after_add;
         end
      end else 
			done <= 1'b1;
	end  // always_ff
	
	assign x = is_steep ? axis2_pos : axis1_pos;
   assign y = is_steep ? axis1_pos : axis2_pos;
	
endmodule  // line_drawer