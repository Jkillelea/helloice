`default_nettype none
`timescale 1ns / 1ps

module top (
    input  ICE_CLK,
    input  UART_RX,
    output UART_TX,
    output RLED1,
    output RLED2,
    output RLED3,
    output RLED4,
    output GLED5,
    output OUT106
);

    wire pll_clk_50m;
    wire pll_locked;
    pll PLL_50MHz(
        .clock_in(ICE_CLK),
        .clock_out(pll_clk_50m),
        .locked(pll_locked)
    );

    // UART TX wires
    wire       tx_dv;   // data valid (send this data out)
    reg  [7:0] tx_byte; // data to send
    wire       tx_done; // done sending

    assign tx_dv = tx_done;

    uart_tx2 #(
        .F_CLK(50_000_000),
        .UART_BAUD(921600)
    )
    tx (
        .CLK(pll_clk_50m),
        .TX_DV(tx_dv),
        .TX_BYTE(tx_byte),
        .TX_DATA(UART_TX),
        .DONE(tx_done)
    );

    wire [3:0] leds = {RLED1, RLED2, RLED3, RLED4};
    assign leds = tx_byte[6:3];
    // assign GLED5 = !UART_TX;
    assign GLED5 = pll_locked;
    assign OUT106 = !UART_TX;


    reg [6:0] posoff = 0;
    parameter START = "0";

    // generate ascii sawtooth
    always @(posedge tx_done) begin
        // end of line
        if (tx_byte > START + posoff) begin
            tx_byte <= "\n";

            // last sawtooth
            if (posoff == "z" - "1") // reset position offset
                posoff <= 0;
            else
                posoff <= posoff + 1;
        end
        else if (tx_byte == "\n") begin // restart at START char
            tx_byte <= START;
        end
        else begin // print next in sequence
            tx_byte <= tx_byte + 1;
        end
    end

    // reg [31:0] counter = 0;
    // reg [4:0] bitpos = 4'hF;
    // always @(posedge tx_done) begin
    //     bitpos <= bitpos - 1;
    //     counter <= counter;
    //     if (bitpos == 0) begin
    //         tx_byte <= "\n";
    //         counter <= counter + 1;
    //     end else begin
    //         tx_byte <= counter[bitpos] ? "1" : "0";
    //     end
    // end

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
