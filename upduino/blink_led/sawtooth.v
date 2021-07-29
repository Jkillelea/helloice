`default_nettype none
`timescale 1ns / 10ps

module SAWTOOTH #(
    parameter WIDTH = 8,
    parameter PRESCALER = 0
)
(
    input                  clk,
    output reg [WIDTH-1:0] sawtooth,
    output reg             direction
);
    localparam DIR_DN    = 1'b0;
    localparam DIR_UP    = 1'b1;
    localparam COUNT_MAX = (2 << (WIDTH - 1)) - 1;

    reg [WIDTH-1:0] counter   = 0;
    reg [WIDTH-1:0] clks      = 0;

    initial begin
        sawtooth  <= 0;
        direction <= DIR_UP;
    end

    always @(posedge clk) begin
        clks <= clks + 1;
    end

    always @(posedge clks[PRESCALER]) begin
        counter <= counter + 1;

        if (counter == COUNT_MAX) begin
            direction <= !direction;
        end

        if (direction == DIR_UP) // up
            sawtooth <= counter;
        else                     // down
            sawtooth <= COUNT_MAX - counter;

    end
endmodule


