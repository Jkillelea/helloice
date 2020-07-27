`default_nettype none
`timescale 1ns / 1ps

module tb();
    // 12 MHz
    reg clk = 0;
    // always #42 clk <= !clk;
    always #10 clk <= !clk; // 50MHz

    reg  [23:0] indata = 0;
    reg         reset = 0;
    wire        led_out;
    wire        done;

    BitController #(.F_CLK(50_000_000))
    bitcontroller (
        clk, indata, reset, led_out, done
    );

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, bitcontroller);

        // reset <= 1;
        // #100
        // reset <= 0;

        #10_000_000; // 1 ms
        $finish;
    end

    always @(posedge clk) begin
        reset <= 0;
        indata <= indata;
        if (done) begin
            reset <= 1;
            indata <= indata + 1;
        end
    end

endmodule
