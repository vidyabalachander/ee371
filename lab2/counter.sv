module counter(clk, reset, curr_addr);
	
	input logic clk, reset;
	output logic [4:0] curr_addr;
	
   logic [25:0] count;
	
   always_ff @(posedge clk) begin
       if (reset) begin
           count <= 0;
           curr_addr <= 0;
       end
       else if (count == 26'd49_999_999) begin
           count <= 0;
           curr_addr <= curr_addr + 5'd1;
       end
       else begin
           count <= count + 26'd1;
       end
   end
	
endmodule 