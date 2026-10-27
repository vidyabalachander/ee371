module rom_to_codec #(parameter counter_max = 18'd48000)(clk, write, rom_data_left, rom_data_right);
	input logic clk, write;
	output logic [23:0] rom_data_left, rom_data_right;
	
	logic [15:0] counter = 0;
	logic [23:0] data;
	
	rom48000 rom (.address(counter), .clock(clk), .q(data));
	
	always_ff @(posedge clk)
		if (write) begin
			
			if (counter < counter_max - 1)
				counter <= counter + 1'd1;
			else 
				counter <= 0;
				
			rom_data_left <= data;
			rom_data_right <= data;
		end
		else
			counter <= counter;

endmodule // rom_to_codec