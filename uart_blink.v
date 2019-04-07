`default_nettype none
`timescale 1ns / 1ps

module UART_Blink(
    input  ICE_CLK,
    input  UART_RX,
    output UART_TX,
    output J3_10,
    output J3_9,
    output GLED5,
    output RLED1,
    output RLED2,
    output RLED3,
    output RLED4,
);

    wire       tx_dv;
    wire [7:0] tx_byte;
    wire       tx_data;
    wire       tx_done;

    wire       rx_dv;
    wire [7:0] rx_byte;
    wire       is_data;

    uart_tx2 #(.UART_BAUD(9600)) tx(
        ICE_CLK,
        tx_dv,
        tx_byte,
        tx_data,
        tx_done
    );

    uart_rx #(.UART_BAUD(9600)) uart(
        ICE_CLK,
        UART_RX,
        rx_dv,
        rx_byte
    );

    always @(rx_dv) begin
        tx_byte <= rx_byte;
        tx_dv   <= rx_dv;
    end

    assign tx_byte  = rx_byte;
    assign tx_dv    = rx_dv;

    assign UART_TX  = tx_data;
    // initial begin
    //     tx_byte <= 65;
    //     tx_dv   <= 1;
    // end
    // always begin
    //     #10000000
    //     tx_byte <= tx_byte + 1;
    // end

    // assign UART_TX = UART_RX;
    assign J3_9  = UART_TX;
    assign J3_10 = UART_RX;

    always RLED1 <= rx_byte[0];
    always RLED2 <= rx_byte[1];
    always RLED3 <= rx_byte[2];
    always RLED4 <= rx_byte[3];
    always GLED5 <= rx_byte[4];

endmodule
