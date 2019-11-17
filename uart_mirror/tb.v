`default_nettype none
`timescale 1ns / 1ps

module tb();

    parameter BITPER = 104_000; // 104 us

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, top_inst);
        uart_rx = 1;
        #10_000; // 0.01 ms

        // clock out 0x0D
        uart_rx = 0;
        #BITPER; // 105 us
        uart_rx = 1;
        #BITPER; // 105 us
        uart_rx = 0;
        #BITPER; // 105 us
        uart_rx = 1;
        #BITPER; // 105 us
        #BITPER; // 105 us
        uart_rx = 0;
        #BITPER; // 105 us
        #BITPER; // 105 us
        #BITPER; // 105 us
        #BITPER; // 105 us
        uart_rx = 1; // stop bit
        #BITPER; // 105 us

        // send 0x0A
        uart_rx = 0; // start bit
        #BITPER; // 105 us
        uart_rx = 0;
        #BITPER; // 105 us
        uart_rx = 1;
        #BITPER; // 105 us
        uart_rx = 0;
        #BITPER; // 105 us
        uart_rx = 1;
        #BITPER; // 105 us
        uart_rx = 0;
        #BITPER; // 105 us
        #BITPER; // 105 us
        #BITPER; // 105 us
        #BITPER; // 105 us
        uart_rx = 1; // stop bit
        #BITPER; // 105 us

        #10_000_000; // 10 ms
        $finish;
    end

    reg clk = 0;
    always #42 clk <= !clk;

    reg uart_rx = 1;
    wire uart_tx;
    wire j3_10;
    wire j3_9;
    wire j3_8;
    wire gled5;
    wire rled1;
    wire rled2;
    wire rled3;
    wire rled4;

    UART_Blink top_inst(
        clk, uart_rx, uart_tx,
        j3_10, j3_9, j3_8,
        gled5, rled1, rled2, rled3, rled4
    );

endmodule
