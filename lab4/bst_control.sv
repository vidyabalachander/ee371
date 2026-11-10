module bst_control (clk, reset, s, equal, less, at_low,
   at_high, initialize, update_low, update_high, save, Done);

   input logic clk, reset, s;
   input logic equal, less, at_low, at_high;
   output logic initialize, update_low, update_high, save, Done;

	// define state names and variables
   enum {s_idle, s_hold, s_compare, s_done} ps, ns;
	
	// controller logic with synchronous reset
	always_ff @(posedge clk) begin
        if (reset)
            ps <= s_idle;
        else
            ps <= ns;
   end

	//next state logic
   always_comb begin
       ns = ps;
       initialize = 1'b0;
       update_low = 1'b0;
       update_high = 1'b0;
       save = 1'b0;
       Done = 1'b0;

       case (ps)
           s_idle: begin
					if (s) begin
						initialize = 1'b1;
						ns = s_hold;
					end
           end
			  
			  s_hold: begin
					ns = s_compare;
			  end
			
           s_compare: begin
					if (equal) begin
						 save = 1'b1;
						 ns = s_done;
					end else if (less) begin
						 if (at_low)
							  ns = s_done;
						 else begin
							  update_high = 1'b1;
							  ns = s_hold;
						 end
					end else begin
						 if (at_high)
							  ns = s_done;
						 else begin
							  update_low = 1'b1;
							  ns = s_hold;
						 end
					end
			end
         s_done: begin
             Done = 1'b1;
             if (~s)
                 ns = s_idle;
         end
			default: ns = s_idle;
		endcase
	end
endmodule
