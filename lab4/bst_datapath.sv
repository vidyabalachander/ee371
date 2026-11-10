module bst_datapath (clk, reset, A, data_out, initialize,
    update_low, update_high, save, address, Loc, Found,
    equal, less, at_low, at_high);

    input logic clk, reset;
    input logic [7:0] A, data_out;
    input logic initialize, update_low, update_high, save;
    output logic [4:0] address, Loc;
    output logic Found, equal, less, at_low, at_high;

    logic [4:0] low, high;
	 logic [5:0] mid;
    logic [7:0] target;

    assign mid = (low + high) / 2;
    assign address = mid;
    assign equal = (target == data_out);
    assign less = (target < data_out);
    assign at_low = (mid == low);
    assign at_high = (mid == high);

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
