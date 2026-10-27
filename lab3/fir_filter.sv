module fir_filter #(parameter DATA_WIDTH = 24, parameter LOG_2_N = 3)
						(clk, reset, enable, data_in, data_out);

	input logic clk, reset, enable;
	input logic [DATA_WIDTH-1:0] data_in;
	output logic [DATA_WIDTH-1:0] data_out;
	
	logic empty, full;
	logic wr;
	assign wr = enable;
	// only allowed to read from the buffer when the buffer is full
	logic rd;
	assign rd = enable & full;
	
	// dividing data by N
	logic [DATA_WIDTH-1:0] div_data;
	assign div_data = data_in >> LOG_2_N;
	
	// buffer
	logic [DATA_WIDTH-1:0] buffer_out;
	fifo #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(LOG_2_N)) 
			buffer (.clk, .reset, .rd, .wr, .empty, .full, .w_data(div_data), .r_data(buffer_out));
			
	// if full, start getting data out of the buffer
	logic signed [DATA_WIDTH-1:0] sum_div_data_buffer_out;
	assign sum_div_data_buffer_out = full ? (buffer_out * -1) + div_data : 24'b0;
	
	// accumulator
	logic signed [DATA_WIDTH-1:0] accumulator;
	
	always_ff @(posedge clk)
		if (reset)
			accumulator <= 24'b0;
		else if (enable)
			accumulator <= accumulator + sum_div_data_buffer_out;
	
	assign data_out = accumulator;
			
	
endmodule
