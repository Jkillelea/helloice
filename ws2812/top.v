`default_nettype none
`timescale 1ns/1ps
module Top (
    input CLK_IN,
    output Ws2812_Dat,
    output Ws2812_Done,
    output reg Ws2812_Reset
);

    parameter F_CLK = 12_000_000;

    reg [23:0] indata = 0;
    wire       done;

    BitController #(
        .F_CLK(F_CLK)
    ) ws2812_bitcontroller (
        CLK_IN,
        indata,
        Ws2812_Reset,
        Ws2812_Dat,
        Ws2812_Done
    );

    // assign Ws2812_Done = done;

    always @(posedge CLK_IN) begin
        if (Ws2812_Done) begin
            Ws2812_Reset  <= 1;
            indata <= indata + 1;
        end
        else begin
            Ws2812_Reset  <= 0;
            indata <= indata;
        end
    end

endmodule
