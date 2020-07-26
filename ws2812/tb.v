`default_nettype none
`timescale 1ns / 1ps

module tb();
    // 12 MHz
    reg clk = 0;
    always #42 clk <= !clk;

    reg  [23:0] indata = 0;
    reg         reset = 0;
    wire        led_out;
    wire        done;

    BitController #(.F_CLK(12_000_000))
    bitcontroller (
        clk, indata, reset, led_out, done
    );

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, bitcontroller);

        #1_000_000; // 1 ms

        reset = 1;
        #1;
        indata <= 24'hFF00;
        reset = 0;

        #1_000_000; // 1 ms
        $finish;
    end

endmodule
