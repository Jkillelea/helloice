`default_nettype none
`timescale 1ns / 1ps

module tb();

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, top_inst);
        #1_000_000; // 1 ms
        $finish;
    end

    reg clk = 0;
    always #1 clk <= !clk;

    wire shift_latch;
    wire shift_clock;
    wire shift_data;
    wire gled5;
    wire rled1;
    wire rled2;
    wire rled3;
    wire rled4;
    top top_inst(clk, shift_latch, shift_clock, shift_data,
                    gled5, rled1, rled2, rled3, rled4);

endmodule
