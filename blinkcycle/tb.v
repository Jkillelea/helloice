`default_nettype none
`timescale 10ps / 1ps

module tb();

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, top_inst);
        #1_000_000_000;
        $finish;
    end

    reg clk = 0;
    always #1 clk <= !clk;

    wire rled1;
    wire rled2;
    wire rled3;
    wire rled4;
    wire gled5;
    top top_inst(clk, rled1, rled2, rled3, rled4, gled5);

endmodule
