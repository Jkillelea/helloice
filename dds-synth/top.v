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
    pll pllclock(.clock_in(ICE_CLK), .clock_out(pll_clk), .locked(pll_locked));

    // UART RX wires
    wire       rx_dv;   // data valid (conversion done)
    wire [7:0] rx_byte; // rx data

    uart_rx #(.UART_BAUD(115200), .F_CLK(12_000_000)) rx (
        ICE_CLK,
        UART_RX,
        rx_dv,
        rx_byte
    );

    parameter DATA_SZ = 6;
    parameter ADDR_SZ = 8;
    reg  [DATA_SZ-1:0] ram_din     = 0;
    reg  [ADDR_SZ-1:0] ram_wr_addr = 0;
    reg                ram_wr_en   = 1;
    reg  [ADDR_SZ-1:0] ram_rd_addr = 0;
    wire [DATA_SZ-1:0] ram_dout;

    ram #(
        .ADDR_WIDTH(ADDR_SZ), .DATA_WIDTH(DATA_SZ)
    ) signal_data(
        pll_clk, ram_wr_addr, ram_din, ram_wr_en, ram_rd_addr, ram_dout
    );

    wire [5:0] dds_bits = {DDSBIT5, DDSBIT4, DDSBIT3, DDSBIT2, DDSBIT1, DDSBIT0};
    wire [4:0] leds     = {GLED5, RLED4, RLED3, RLED2, RLED1};

    // Data input to RAM
    always @(posedge rx_dv) begin
        ram_din     <= rx_byte[7:2];
        ram_wr_addr <= ram_wr_addr + 1;
    end

    // Data output from RAM
    assign dds_bits = ram_dout;
    assign leds = ram_wr_addr[4:0];
    always @(posedge pll_clk) begin
        ram_rd_addr <= ram_rd_addr + 1;
    end

endmodule
