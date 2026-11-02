/* This module was created to transfer data from our ROM (which stores the data of an audio file)
 * sequentially to be used by the audio CODEC. It takes in an 16 bit parameter, counter_max which
 * represents the number of individual datapoints in the audio file. As of now, the counter is only
 * large enough to cycle through one second of audio (chosen due to board memory constraints). Other
 * inputs include a clock and a write signal, which indicates when the CODEC is ready for the next
 * datapoint. Outputs are two 24 bit variables, rom_data_left and rom_data_right. The counter is
 * designed to wrap for seamless playback from the stored audio file.
*/
module rom_to_codec #(parameter counter_max = 16'd48000)(clk, write, rom_data_left, rom_data_right);
	input logic clk, write;
	output logic [23:0] rom_data_left, rom_data_right;

	logic [23:0] data;
	logic [15:0] counter = 16'b0;
	
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