`default_nettype none

module UART_Blink(
    input  ICE_CLK,
    input  UART_RX,
    output UART_TX,
    output J3_10,
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

    uart_tx tx(
        ICE_CLK,
        tx_dv,
        tx_byte,
        tx_data,
        tx_done
    );

    uart_rx uart(
        ICE_CLK, 
        UART_RX, 
        rx_dv, 
        rx_byte
    );

    // always @(rx_dv) begin
    //     RLED1 <= rx_byte[0];
    //     RLED2 <= rx_byte[1];
    //     RLED3 <= rx_byte[2];
    //     RLED4 <= rx_byte[3];
    // end
    // assign RLED1   = rx_dv;
    // assign RLED2   = rx_dv;
    // assign RLED3   = rx_byte[0];
    // assign RLED4   = rx_byte[1];

    always tx_byte <= rx_byte;
    always tx_dv   <= rx_dv;
    assign UART_TX  = tx_data;

    always RLED1 <= rx_byte[0];
    always RLED2 <= rx_byte[1];
    always RLED3 <= rx_byte[2];
    always RLED4 <= rx_byte[3];
    always GLED5 <= rx_byte[4];
    assign J3_10   = UART_RX;
    // assign UART_TX = UART_RX;
endmodule
