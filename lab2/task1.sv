/* 
	This module instantiates the prebuilt 32x3 RAM from Quartus.
	It takes in a 5 bit memory Address, a 1 bit CLK clock for 
	synchronization, 3 bits of DataIn, and a 1 bit Write enable signal.
	The outputs is 3 bits of DataOut. When Write = 1'b0, the system is
	in "read mode" and DataOut is whatever is stored in the given Address.
	When Write = 1'b1, the the system is in "write mode." The the system
	overwrites whatever is currently at Address with DataIn. In "write mode,"
	Data 
*/
module task1 (Address, CLK, DataIn, Write, DataOut);
	
	input	logic [4:0] Address;
	input	logic CLK;
	input	logic [2:0] DataIn;
	input	logic Write;
	output logic [2:0] DataOut;
	
	ram32x3 ram (.address(Address), .clock(CLK), 
					 .data(DataIn), .wren(Write), .q(DataOut));
	
endmodule // task1
