// This module is the control unit for the binary search algorithm. This module contains the
// state logic and decides when the datapath should be completing some action or executing some logic.
// The module takes a clock, reset, and start inputs from the top-level module. The module also takes
// status signals from the datapath as inputs. The control units being output are:
// - initialize, which tells the datapath to reset the boundaries, output address, and target value.
// - update_low, which tells the datapath to update to lower boundary
// - update_high, which tells the datapath to update the upper boundary
// - save, which tells the datapath to save the current address to Loc
module bst_control (clk, reset, s, equal, less, at_low,
	at_high, initialize, update_low, update_high, save, Done);

   input logic clk, reset, s;
   input logic equal, less, at_low, at_high;
   output logic initialize, update_low, update_high, save, Done;

	// defining state names and variables
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
		endcase // case (ps)
	end // always_comb
endmodule //bst_control
