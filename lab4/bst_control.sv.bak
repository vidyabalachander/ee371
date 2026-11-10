module binary_search_control (clk, reset, Start, equal, less, at_low,
    at_high, initialize, update_low, update_high, save, Done);

    input logic clk, reset, Start;
    input logic equal, less, at_low, at_high;
    output logic initialize, update_low, update_high, save, Done;

    typedef enum logic [2:0] {s_idle, s_init, s_read, s_compare, s_finish} state_t;
    state_t ps, ns;

    always_ff @(posedge clk) begin
        if (reset)
            ps <= s_idle;
        else
            ps <= ns;
    end

    always_comb begin
        ns = ps;
        initialize = 1'b0;
        update_low = 1'b0;
        update_high = 1'b0;
        save = 1'b0;
        Done = 1'b0;

        case (ps)
            s_idle: begin
                if (Start)
                    ns = s_init;
            end
            s_init: begin
                initialize = 1'b1;
                ns = s_read;
            end
            s_read: begin
                ns = s_compare;
            end
            s_compare: begin
                if (equal) begin
                    save = 1'b1;
                    ns = s_finish;
                end else if (less) begin
                    if (at_low)
                        ns = s_finish;
                    else begin
                        update_high = 1'b1;
                        ns = s_read;
                    end
                end else begin
                    if (at_high)
                        ns = s_finish;
                    else begin
                        update_low = 1'b1;
                        ns = s_read;
                    end
                end
            end
            s_finish: begin
                Done = 1'b1;
                if (~Start)
                    ns = s_idle;
            end
            default: ns = s_idle;
        endcase
    end
endmodule
