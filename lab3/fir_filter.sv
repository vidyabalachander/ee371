/* This file creates a FIR Filter for the specified DATA_WIDTH and LOG_2_N bit widths.
 * It takes in a clock, reset, enable signal, and data_in of size DATA_WIDTH. It outputs
 * data_out also of size DATA_WIDTH, a moving average of the last N samples. This is 
 * achieved using a FIFO buffer and accumulator. When played sequentially, data_out
 * sounds like a filtered version of data_in, omitting background noise and static.
*/
module fir_filter #(parameter DATA_WIDTH = 24, parameter LOG_2_N = 9)
						(clk, reset, enable, data_in, data_out);

	input logic clk, reset, enable;
	input logic [DATA_WIDTH-1:0] data_in;
	output logic [DATA_WIDTH-1:0] data_out;
	
	logic empty, full;
	logic wr;
	assign wr = enable;
	logic rd;
	assign rd = enable & full;
	
	// dividing data by N
	logic [DATA_WIDTH-1:0] div_data;
	assign div_data = {{LOG_2_N{data_in[DATA_WIDTH-1]}}, data_in[DATA_WIDTH-1:LOG_2_N]};
	
	// creating FIFO buffer
	logic [DATA_WIDTH-1:0] buffer_out;
	fifo #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(LOG_2_N)) 
			buffer (.clk, .reset, .rd, .wr, .empty, .full, .w_data(div_data), .r_data(buffer_out));
			
	// If full, start getting data out of the buffer, and subtract it
	logic signed [DATA_WIDTH-1:0] sum_div_data_buffer_out;
	assign sum_div_data_buffer_out = div_data + (full ? (-buffer_out) : 24'b0);
	
	// Accumulator
	logic signed [DATA_WIDTH-1:0] accumulator;
	
	// Accumulator sequential logic
	always_ff @(posedge clk)
		if (reset)
			accumulator <= 24'b0;
		else if (enable)
			accumulator <= accumulator + sum_div_data_buffer_out;
	
	assign data_out = accumulator;
			
endmodule // fir_filter