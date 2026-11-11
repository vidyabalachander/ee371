// This module is the datapath unit for the binary search module. This module takes in
// a clock, a reset signal, the next output from the RAM 32x8 array, and the value 
// to be searching for in the array. The status signals being output are an equal signal,
// a less signal which is true when the current calue is less than the value being checked
// in the RAM, and two values that are true when the current address is a boundary address:
// at_low and at_high. Finally, this module also outputs Found, which is true when the value is found,
// address, the next addresss to check in the RAM, and Loc, the location at which the address is found. 

module bst_datapath (clk, reset, A, data_out, initialize,
    update_low, update_high, save, address, Loc, Found,
    equal, less, at_low, at_high);

	 // input and output signals
    input logic clk, reset;
    input logic [7:0] A, data_out;
    input logic initialize, update_low, update_high, save;
    output logic [4:0] address, Loc;
    output logic Found, equal, less, at_low, at_high;

	 // these variables store different addresses which are used to maintain the binary search boundaries
    logic [4:0] low, high;
	 logic [5:0] mid;
    logic [7:0] target;

	 // logic used to assign new boundaries and output status signals to the control unit.
    assign mid = (low + high) / 2;
    assign address = mid;
    assign equal = (target == data_out);
    assign less = (target < data_out);
    assign at_low = (mid == low);
    assign at_high = (mid == high);

	 // changing boundaries and initializing values based on control signals
    always_ff @(posedge clk) begin
	 
        if (reset) begin
				low <= 0;
            high <= 5'd31;
            target <= 8'd0;
            Loc <= 0;
            Found <= 1'b0;
				
        end else if (initialize) begin
            low <= 0;
            high <= 5'd31;
            target <= A;
            Loc <= 0;
            Found <= 1'b0;
				
        end else begin
            if (update_high) begin
                high <= mid - 1'b1;
					 
            end else if (update_low) begin
                low <= mid + 1;
					 
				end else begin			
					if (save) begin
						 Loc <= mid;
						 Found <= 1'b1;
					end
				end
			end
    end
endmodule
