`default_nettype none
`timescale 1 ns / 1 ps

module top(
    input  ICE_CLK,
    output SHIFT_LATCH,
    output SHIFT_CLOCK,
    output SHIFT_DATA,
    output GLED5,
    output RLED1,
    output RLED2,
    output RLED3,
    output RLED4
);
    `include "vfd_bits.v"

    parameter DISPLAY_BITS = 32;

    reg [DISPLAY_BITS-1:0] vfd_data   = 0;
    reg                    data_valid = 1;
    wire                   shift_busy;

    always @(posedge ICE_CLK) begin
        if (!shift_busy && !data_valid) begin
            vfd_data   <= vfd_data + 1;
            data_valid <= 1;
        end
        else begin
            data_valid <= 0;
        end
    end

    shiftout #(
        .FREQUENCY(1_000_000), .DATA_WIDTH(DISPLAY_BITS)
    ) shitfout_inst (
        ICE_CLK, ~vfd_data, data_valid, SHIFT_LATCH, SHIFT_CLOCK, SHIFT_DATA, shift_busy
    );

    assign GLED5 = !shift_busy;
    assign RLED1 = SHIFT_CLOCK;
    assign RLED2 = SHIFT_LATCH;
    assign RLED3 = data_valid;
    assign RLED4 = SHIFT_DATA;

endmodule
