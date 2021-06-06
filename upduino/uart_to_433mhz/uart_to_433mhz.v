`default_nettype none

module UART_TO_433MHZ (
    input  uart_rx,
    output rf_tx,
);

    assign rf_tx = !uart_rx;

endmodule
