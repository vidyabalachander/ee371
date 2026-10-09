module parking_lot_fsm (input logic clk, reset, outer, inner,
				  output logic enter, exit);
				  
	enum logic [2:0] {S0, S1, S2, S3, S4, S5, S6} ps, ns;
	
	
	always_ff @(posedge clk)
		if (reset)
			ps <= S0;
		else 
			ps <= ns;
				
	always_comb begin
		
		case (ps)
			S0: 	if (outer & ~inner) 			ns = S1; // move to S1 if entering (only outer)
					else if (~outer & inner)	ns = S4;	//	move to S4 if exiting (only inner)
					else 								ns = S0; // stay in S0
			S1: 	if (outer & ~inner)			ns = S1; // stay in S1
					else if (outer & inner) 	ns = S2;	// move to S2 if both
					else 								ns = S0;	// invalid
			S2: 	if (outer & inner) 			ns = S2;	// stay in S2
					else if (~outer & inner)	ns = S3; // move to S3 if only inner
					else 								ns = S0; // invalid
			S3: 	if (~outer & inner) 			ns = S3;	// stay in S3
					else if (~outer & ~inner)	ns = S0; // move to S0 if neither (car has entered lot)
					else 								ns = S0; // invalid	
			S4: 	if (~outer & inner) 			ns = S4;	// stay in S4
					else if (outer & inner)		ns = S5; // move to S5 if both
					else 								ns = S0; // invalid		
			S5: 	if (outer & inner) 			ns = S5;	// stay in S5
					else if (outer & ~inner)	ns = S5; // move to S6 if only outer 
					else 								ns = S0; // invalid
			S6: 	if (outer & inner) 			ns = S6;	// stay in S6
					else if (~outer & ~inner)	ns = S0; // move to S0 if neither (car has exited lot)
					else 								ns = S0; // invalid
			default: ns = S0;
		endcase
		
		
	end
	
	assign enter = ~outer & ~inner & (ps == S3);
	assign exit = ~outer & ~inner & (ps == S6);
	
endmodule
