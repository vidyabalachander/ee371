module datapath #(parameter log2n) (clk, reset, A, data_out, initialize,
    update_low, update_high, save, address, address_out, Found,
    equal, less, at_low, at_high);

    parameter LOG2N = 5;

    input logic clk, reset;
    input logic [7:0] A, data_out;
    input logic initialize, update_low, update_high, save;
    output logic [LOG2N-1:0] address, address_out;
    output logic Found, equal, less, at_low, at_high;

    logic [LOG2N-1:0] low, high, mid;
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
            high <= (2**LOG2N) - 1;
            target <= 8'd0;
            address_out <= 0;
            Found <= 1'b0;
				
        end else if (initialize) begin
            low <= 0;
            high <= (2**LOG2N) - 1;
            target <= A;
            address_out <= 0;
            Found <= 1'b0;
				
        end else begin
            if (update_high)
                high <= mid - 1;
					 
            else if (update_low)
                low <= mid + 1;

            if (save) begin
                address_out <= mid;
                Found <= 1'b1;
            end
        end
    end
endmodule
