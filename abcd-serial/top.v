`default_nettype none
`timescale 1ns / 1ps

module top (
    input  ICE_CLK,
    input  UART_RX,
    output UART_TX
);

    // UART TX wires
    reg        tx_dv;   // data valid (send this data out)
    reg  [7:0] tx_byte = 64;  // data to send
    wire       tx_done;       // done sending

    assign tx_dv = tx_done;

    uart_tx2 #(.UART_BAUD(9600)) tx (
        .CLK(ICE_CLK),
        .TX_DV(tx_dv),
        .TX_BYTE(tx_byte),
        .TX_DATA(UART_TX),
        .DONE(tx_done)
    );

    reg [5:0] posoff = 0;
    parameter START = "0";

    always @(posedge ICE_CLK) begin
        if (tx_done) begin
            if (START + posoff < tx_byte) begin
                tx_byte <= 10;
                if (posoff == 61)
                    posoff <= 0;
                else
                    posoff <= posoff + 1;

            end
            else if (tx_byte == 10) begin
                // tx_byte <= 65;
                tx_byte <= START;
            end
            else begin
                tx_byte <= tx_byte + 1;
            end
        end
    end

    // print out 0 thru 9
    // reg [3:0] n = 0;
    // wire [7:0] asciidata;
    // ToStr num2string(.i_number(n), .asciiout(asciidata));
    // always @(posedge ICE_CLK) begin
    //     if (tx_done) begin
    //         if (n <= 9) begin
    //             tx_byte <= asciidata;
    //             n <= n + 1;
    //         end else begin
    //             tx_byte <= 10;
    //             n <= 0;
    //         end
    //     end
    // end

endmodule
