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


// WS2812 timing controller. Feed it a bit array and hit reset.
// It will pulse DONE when it needs a new bit
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
    parameter T0H    = 350 * F_CLK / 10**9; // 4.2 -> 4 clks
    parameter T0L    = 800 * F_CLK / 10**9; // 9.6 -> 9 clks
    parameter T1H    = 700 * F_CLK / 10**9; // 8.4 -> 8 clks
    parameter T1L    = 600 * F_CLK / 10**9; // 7.2 -> 7 clks
    parameter TRESET =  60 * F_CLK / 10**6; // 60 microseconds

    parameter STATE_IDLE  = 2'b00;
    parameter STATE_DATA  = 2'b01;
    parameter STATE_LATCH = 2'b10;
    parameter STATE_DONE  = 2'b11;

    initial begin
        $display("F_CLK %d", F_CLK);
        $display("T0H   %d", T0H);
        $display("T0L   %d", T0L);
        $display("T1H   %d", T1H);
        $display("T1L   %d", T1L);
    end

    reg [ 1:0] State       = STATE_DATA;
    reg [31:0] Clk_Counter = 0;
    reg [ 7:0] Bit_Counter = 0;

    always @(posedge Clk) begin
        if (Reset) begin
            Ws2812Out   <= 0;
            Clk_Counter <= 0;
            Bit_Counter <= 0;
            Done        <= 0;
            State       <= STATE_DATA;
        end else begin
            case (State)
                STATE_IDLE: begin
                    Ws2812Out   <= 0;
                    Clk_Counter <= 0;
                    Done  <= 0;
                end

                STATE_DATA: begin
                    Clk_Counter <= Clk_Counter + 1;

                    if (Indata[Bit_Counter])
                        Ws2812Out <= (Clk_Counter < T1H) ? 1 : 0;
                    else
                        Ws2812Out <= (Clk_Counter < T0H) ? 1 : 0;

                    if (Clk_Counter > (T1H + T1L)) begin
                        Clk_Counter <= 0;
                        Bit_Counter <= Bit_Counter + 1;
                    end else if (Bit_Counter >= BITWIDTH) begin
                        State       <= STATE_LATCH;
                        Ws2812Out   <= 0;
                        Bit_Counter <= 0;
                    end
                end

                STATE_LATCH: begin
                    Ws2812Out <= 0;
                    Clk_Counter <= Clk_Counter + 1;
                    if (Clk_Counter > TRESET) begin
                        Clk_Counter <= 0;
                        State <= STATE_DONE;
                    end
                end

                STATE_DONE: begin
                    State <= STATE_IDLE;
                    Done  <= 1;
                    Clk_Counter <= 0;
                    Bit_Counter <= 0;
                end
                default: begin
                    State <= STATE_IDLE;
                    Done  <= 1;
                    Clk_Counter <= 0;
                    Bit_Counter <= 0;
                end
            endcase
        end
    end
endmodule

