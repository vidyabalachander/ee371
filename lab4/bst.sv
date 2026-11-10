module bst (clk, reset, s, A, Loc, Done, Found);

    input logic clk, reset, s;
    input logic [7:0] A;

    output logic [4:0] Loc;
    output logic Done, Found;

    // Control signals.
    logic initialize, update_low, update_high, save;

    // Status signals.
    logic equal, less, at_low, at_high;

    // Memory connections.
    logic [4:0] address;
    logic [7:0] data_out;

    bst_control control (.*);
    bst_datapath datapath (.*);

    ram32x8 memory (.address, .clock(clk), .data(8'd0), .wren(1'b0), .q(data_out));
						
endmodule //task2