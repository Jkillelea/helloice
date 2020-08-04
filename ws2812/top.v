`default_nettype none
`timescale 1ns/1ps
module Top (
    input CLK_IN,
    output WS2812_DAT
);
    
    parameter F_CLK = 12_000_000;

    reg [23:0] indata = 0;
    reg        reset  = 0;
    wire       done;

    BitController #(
        .F_CLK(F_CLK)
    ) ws2812_bitcontroller (
        CLK_IN,
        indata,
        reset,
        WS2812_DAT,
        done
    );

    always @(posedge CLK_IN) begin
        reset <= 0;
        indata <= indata;
        if (done) begin
            reset <= 1;
            indata <= indata + 1;
        end
    end

endmodule
