/*
	This is the top-level module for this lab project. It initializes and selects between single-port 32x3 RAM 
	and RAM with separate read and write ports. Hex displays are used to display the value being written, the address
	the value is written at, or the address a value is read from.
*/
module DE1_SoC (CLOCK_50, SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
   input logic CLOCK_50;
   input logic [9:0] SW;
   input logic [3:0] KEY;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

   // Accounting for metastability by running the signal through two flip-flops
   logic [9:0] meta_SW, syncSW;
   logic meta_reset, reset;

    always_ff @(posedge CLOCK_50) begin
        meta_SW <= SW;
        syncSW <= meta_SW;

        meta_reset <= ~KEY[3];
        reset <= meta_reset;
    end

    // We iterate through a count of 50000000 since we're using CLOCK_50
    logic [4:0] read_addr;
	 
	 counter address_counter(.clk(CLOCK_50), .reset, .curr_addr(read_addr));

    // Enable writes only to the selected memory.
    logic wren2, wren3;

    assign wren2 = syncSW[0] & ~syncSW[9] & ~reset;
    assign wren3 = syncSW[0] &  syncSW[9] & ~reset;
    logic [4:0] addr2;

    always_comb begin
        if (wren2)
            addr2 = syncSW[8:4];
        else
            addr2 = read_addr;
    end

    logic [2:0] q2, q3, dataOut;

    task2 memory2 (
        .clk    (CLOCK_50),
        .wren   (wren2),
        .addr   (addr2),
        .dataIn (syncSW[3:1]),
        .q      (q2)
    );

    ram32x3port2 memory3 (
        .clock     (CLOCK_50),
        .data      (syncSW[3:1]),
        .rdaddress (read_addr),
        .wraddress (syncSW[8:4]),
        .wren      (wren3),
        .q         (q3)
    );

    // Display the selected memory's output.
    always_comb begin
        if (syncSW[9])
            dataOut = q3;
        else
            dataOut = q2;
    end

    // Using HEX4 and HEX5 to display the write address
    seg7 write_addr_high (
        .hex  ({3'b000, syncSW[8]}),
        .leds (HEX5)
    );

    seg7 write_addr_low (
        .hex  (syncSW[7:4]),
        .leds (HEX4)
    );

    // HEX2 and HEX3 are used to display the read address
    seg7 read_addr_high (
        .hex  ({3'b000, read_addr[4]}),
        .leds (HEX3)
    );

    seg7 read_addr_low (
        .hex  (read_addr[3:0]),
        .leds (HEX2)
    );

    seg7 input_display (
        .hex  ({1'b0, syncSW[3:1]}),
        .leds (HEX1)
    );

    seg7 output_display (
        .hex  ({1'b0, dataOut}),
        .leds (HEX0)
    );

endmodule //DE1_SoC