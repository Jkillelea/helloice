`default_nettype none
`timescale 1ns / 1ps

module UART_Blink(
    input  ICE_CLK,
    input  UART_RX,
    output UART_TX,
    output J3_10,
    output J3_9,
    output J3_8,
    output GLED5,
    output RLED1,
    output RLED2,
    output RLED3,
    output RLED4
);

    wire       rx_dv;
    wire [7:0] rx_byte;

    uart_rx #(.UART_BAUD(9600)) rx(
        ICE_CLK,
        UART_RX,
        rx_dv,
        rx_byte
    );

    wire [7:0] ram_din;
    reg  [8:0] ram_write_addr = 0;
    wire       ram_write_en;
    reg  [8:0] ram_read_addr  = 0;
    wire [7:0] ram_dout;

    assign ram_din      = rx_byte;
    assign ram_write_en = rx_dv;

    ram ram_inst (
        ram_din,
        ram_write_addr,
        ram_write_en,
        ICE_CLK,
        ram_read_addr,
        ram_dout
    );

    reg        tx_dv;
    wire [7:0] tx_byte;
    wire       tx_data;
    wire       tx_done;

    assign tx_byte = ram_dout;

    uart_tx2 #(.UART_BAUD(9600)) tx(
        ICE_CLK,
        tx_dv,
        tx_byte,
        tx_data,
        tx_done
    );

    // store uart to ram in sequential locations
    always @(posedge rx_dv) begin
        ram_write_addr <= ram_write_addr + 1;
    end

    // write ram back out to uart
    always @(posedge ICE_CLK) begin
        if ((ram_write_addr > ram_read_addr) && tx_done) begin // write > read -> read++, tx action
            ram_read_addr <= ram_read_addr + 1;
            tx_dv <= 1;
        end else begin // write < read -> nothing
            tx_dv <= 0;
        end

        // write pointer overflow
        if (ram_write_addr == 0) begin
            ram_read_addr <= 0;
        end
    end

    assign UART_TX = tx_data;
    assign J3_10   = tx_dv;
    assign J3_9    = UART_TX;
    assign J3_8    = UART_RX;

    assign GLED5 = ~UART_TX;
    assign RLED1 = ram_write_addr[8];
    assign RLED2 = ram_write_addr[7];
    assign RLED3 = ram_write_addr[6];
    assign RLED4 = ram_write_addr[5];
endmodule
