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

    UART_Mirror top_inst (
        clk, uart_rx, uart_tx,
        j3_10, j3_9, j3_8,
        gled5, rled1, rled2, rled3, rled4
    );

    task uart_signal (input [7:0] byte);
        integer i;
        begin
            // Start bit
            uart_rx = 0;
            #BITPER;
            for (i = 0; i < 8; i++) begin
                uart_rx = byte[i];
                #BITPER;
            end
            // Stop bit
            uart_rx = 1;
            #BITPER;
        end
    endtask

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, top_inst);
        uart_rx = 1;
        #10_000; // 0.01 ms

        uart_signal(8'h01);
        uart_signal(8'h02);
        uart_signal(8'h03);
        uart_signal(8'h04);

        uart_signal(8'h0D);
        // // clock out 0x0D
        // uart_rx = 0; // start bit
        // #BITPER;
        // uart_rx = 1;
        // #BITPER;
        // uart_rx = 0;
        // #BITPER;
        // uart_rx = 1;
        // #BITPER;
        // #BITPER;
        // uart_rx = 0;
        // #BITPER;
        // #BITPER;
        // #BITPER;
        // #BITPER;
        // uart_rx = 1; // stop bit
        // #BITPER;

        uart_signal(8'h0A);
        // // send 0x0A
        // uart_rx = 0; // start bit
        // #BITPER; // 105 us
        // uart_rx = 0;
        // #BITPER; // 105 us
        // uart_rx = 1;
        // #BITPER; // 105 us
        // uart_rx = 0;
        // #BITPER; // 105 us
        // uart_rx = 1;
        // #BITPER; // 105 us
        // uart_rx = 0;
        // #BITPER; // 105 us
        // #BITPER; // 105 us
        // #BITPER; // 105 us
        // #BITPER; // 105 us
        // uart_rx = 1; // stop bit
        // #BITPER; // 105 us


        #5_000_000; // 5 ms
        $finish;
    end

endmodule
