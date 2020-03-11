`default_nettype none
`timescale 1ns / 1ps

module tb();

    parameter BITPER = 104_000; // 104 us = 9600 bps

    reg clk = 0;
    always #42 clk <= !clk;

    reg  uart_rx = 1;
    wire uart_tx;
    wire j3_10;
    wire j3_9;
    wire j3_8;
    wire gled5;
    wire rled1;
    wire rled2;
    wire rled3;
    wire rled4;

    top top_inst (
        clk, uart_rx, uart_tx, rled1, rled2, rled3, rled4, gled5
    );

    // task uart_signal (input [7:0] byte);
    //     integer i;
    //     begin
    //         // Start bit
    //         uart_rx = 0;
    //         #BITPER;
    //         for (i = 0; i < 8; i = i + 1) begin
    //             uart_rx = byte[i];
    //             #BITPER;
    //         end
    //         // Stop bit
    //         uart_rx = 1;
    //         #BITPER;
    //     end
    // endtask

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, top_inst);
        uart_rx = 1;
        #10_000; // 0.01 ms
        uart_rx = 0;
        #10_000; // 0.01 ms
        uart_rx = 1;

        // uart_signal(8'h01);
        // uart_signal(8'h02);
        // uart_signal(8'h03);
        // uart_signal(8'h04);
        // uart_signal(8'h05);
        // uart_signal(8'h06);
        // uart_signal("h");

        #50_000_000; // 50 ms
        $finish;
    end

endmodule
