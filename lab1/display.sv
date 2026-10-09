module display (input logic [2:0] count,
					output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
					
	always_comb begin
		HEX5 = 7'b1111111;
		HEX4 = 7'b1111111;
		HEX3 = 7'b1111111;
		HEX2 = 7'b1111111;
		HEX1 = 7'b1111111;
		HEX0 = 7'b1111111;
		
		case (count)
			3'b000: begin
				HEX5 = 7'b0110001; // C
				HEX4 = 7'b1110001; // L
				HEX3 = 7'b0110000; // E
				HEX2 = 7'b0001000; // A
				HEX1 = 7'b1111010; // r
				HEX0 = 7'b0000001; // 0
			end
			3'b001: begin
				HEX1 = 7'b0000001; // 0
				HEX0 = 7'b1001111; // 1
			end
			3'b010: begin
				HEX1 = 7'b0000001; // 0
				HEX0 = 7'b0010010; // 2
			end
			3'b011: begin
				HEX1 = 7'b0000001; // 0
				HEX0 = 7'b0000110; // 3
			end
			3'b100: begin
				HEX1 = 7'b0000001; // 0
				HEX0 = 7'b1001100; // 4
			end
			3'b101: begin
				HEX5 = 7'b0111000; // F
				HEX4 = 7'b1000001; // U
				HEX3 = 7'b1110001; // L
				HEX2 = 7'b1110001; // L
				HEX1 = 7'b0000001; // 0
				HEX0 = 7'b0100100; // 5
			end
			default: begin
			end
		endcase
	end
	
endmodule
