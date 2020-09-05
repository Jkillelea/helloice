`default_nettype none
`timescale 1ns / 1ps

module Top (
    input  ICE_CLK,
    input  UART_RX,
    output DDSBIT5,
    output DDSBIT4,
    output DDSBIT3,
    output DDSBIT2,
    output DDSBIT1,
    output DDSBIT0,
    output GLED5,
    output RLED1,
    output RLED2,
    output RLED3,
    output RLED4
);

    wire pll_clk;
    wire pll_locked;
    pll pll75mhz(.clock_in(ICE_CLK), .clock_out(pll_clk), .locked(pll_locked));

    // UART RX wires
    wire       rx_dv;   // data valid (conversion done)
    wire [7:0] rx_byte; // rx data

    uart_rx #(.UART_BAUD(921600)) rx (
        ICE_CLK,
        UART_RX,
        rx_dv,
        rx_byte
    );

    wire [5:0] dds_bits = {DDSBIT5, DDSBIT4, DDSBIT3, DDSBIT2, DDSBIT1, DDSBIT0};
    wire [4:0] leds     = {GLED5, RLED4, RLED3, RLED2, RLED1};

    always @(posedge rx_dv) begin
        dds_bits <= rx_byte[7:2];
        leds     <= dds_bits[5:1];
    end

endmodule
