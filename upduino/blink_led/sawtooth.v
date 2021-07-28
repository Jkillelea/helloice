`default_nettype none
`timescale 1ns / 10ps

module SAWTOOTH #(parameter WIDTH = 8)
(
    input  clk,
    output [WIDTH:0] sawtooth
);
    localparam DIR_UP = 1'b0;
    localparam DIR_DN = 1'b1;

    reg [WIDTH:0] sawtooth = 0;

    reg direction = DIR_UP;

    always @(posedge clk) begin
        case (direction)
            DIR_UP: begin
                sawtooth <= sawtooth + 1;

                if (sawtooth == ((2 << WIDTH) - 2)) begin
                    direction <= DIR_DN;
                end
            end

            DIR_DN: begin
                sawtooth <= sawtooth - 1;

                if (sawtooth == 2) begin
                    direction <= DIR_UP;
                end
            end

            default: begin
                direction <= DIR_UP;
            end
        endcase
    end
endmodule


