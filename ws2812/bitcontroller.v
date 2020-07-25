`default_nettype none
`timescale 1ns / 1ps

// WS2812 timing controller. Feed it a bit array and it will pulse DONE when it
// needs a new bit
module BitController (
    input                     Clk,
    input      [BITWIDTH-1:0] Indata,
    input                     Reset,
    output reg                Done
);

    parameter F_CLK = 12_000_000;
    parameter BITWIDTH = 24;

    /*  A high bit:             A low bit:
     * -----------              --------
     *           |                     |
     *   T1H     |  T1L         T0H    |  T0L
     *  (0.7us)  | (0.6us)     (0.35us)| (0.8us)
     * ^         ---------^     ^      -----------^
     *
     * Reset with a low voltage for longer than 50us
     **/

    // CLK cycles for one pulse, +/- one CLK (which is 83ns at 12MHz).
    parameter T0H = 350 * F_CLK / 10**9; // 4.2 -> 4 clks
    parameter T0L = 800 * F_CLK / 10**9; // 9.6 -> 9 clks
    parameter T1H = 700 * F_CLK / 10**9; // 8.4 -> 8 clks
    parameter T1L = 600 * F_CLK / 10**9; // 7.2 -> 7 clks

    initial begin
        $display("T0H %d", T0H);
        $display("T0L %d", T0L);
        $display("T1H %d", T1H);
        $display("T1L %d", T1L);
    end

    always @(posedge Clk) begin
        if (Reset) begin
        end else begin
        end
    end

endmodule

