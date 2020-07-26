`default_nettype none
`timescale 1ns / 1ps

/*  A high bit:             A low bit:
 * -----------              --------
 *           |                     |
 *   T1H     |  T1L         T0H    |  T0L
 *  (0.7us)  | (0.6us)     (0.35us)| (0.8us)
 * ^         ---------^     ^      -----------^
 *
 * Reset with a low voltage for longer than 50us
 **/


// WS2812 timing controller. Feed it a bit array and it will pulse DONE when it
// needs a new bit
module BitController (
    input                     Clk,
    input      [BITWIDTH-1:0] Indata,
    input                     Reset,
    output reg                Ws2812Out,
    output reg                Done
);

    parameter F_CLK = 12_000_000;
    parameter BITWIDTH = 24;

    // CLK cycles for one pulse, +/- one CLK (which is 83ns at 12MHz).
    parameter T0H = 350 * F_CLK / 10**9; // 4.2 -> 4 clks
    parameter T0L = 800 * F_CLK / 10**9; // 9.6 -> 9 clks
    parameter T1H = 700 * F_CLK / 10**9; // 8.4 -> 8 clks
    parameter T1L = 600 * F_CLK / 10**9; // 7.2 -> 7 clks

    parameter SEND_HIGH = 1'b0;
    parameter SEND_LOW  = 1'b1;

    initial begin
        $display("T0H %d", T0H);
        $display("T0L %d", T0L);
        $display("T1H %d", T1H);
        $display("T1L %d", T1L);
    end

    reg        HighLow     = SEND_HIGH;
    reg [31:0] Clk_Counter = 0;
    reg [ 7:0] Bit_Counter = 0;
    reg [31:0] Clk_Max     = 0;

    always @(posedge Clk) begin
        if (Reset) begin
            Ws2812Out   <= 0;
            Clk_Counter <= 0;
            Bit_Counter <= 0;
            HighLow     <= SEND_HIGH;
            Done        <= 0;
        end else begin

            if (Indata[Bit_Counter])
                Clk_Max <= HighLow == SEND_HIGH ? T1H : T1L;
            else
                Clk_Max <= HighLow == SEND_LOW ? T0H : T0L;

            // Send the high part of the pulse
            if (HighLow == SEND_HIGH) begin
                Clk_Counter <= Clk_Counter + 1;
                Ws2812Out   <= 1;

                if (Clk_Counter >= Clk_Max) begin
                    HighLow     <= SEND_LOW;
                    Clk_Counter <= 0;
                end

            // Send the low part of the pulse
            end else begin
                Clk_Counter <= Clk_Counter + 1;
                Ws2812Out   <= 0;

                if (Clk_Counter >= Clk_Max) begin
                    HighLow     <= SEND_HIGH;
                    Clk_Counter <= 0;
                    Bit_Counter <= Bit_Counter + 1;
                end
            end

        end
    end

endmodule

