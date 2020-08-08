`default_nettype none
`timescale 1ns / 1ps

module tb();
    reg clk = 0;
    // always #42 clk <= !clk; // 12 MHz
    always #10 clk <= !clk; // 50MHz

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, top);

        // reset <= 1;
        // #100
        // reset <= 0;

        #1_000_000; // 1 ms
        $finish;
    end

    wire ws2812_dat;
    wire ws2812_done;
    wire ws2812_reset;
    Top #(.F_CLK(50_000_000)) top(clk, ws2812_dat, ws2812_done, ws2812_reset);

endmodule
