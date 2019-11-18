`default_nettype none
`timescale 1ns / 1ps

module UART_Mirror (
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

    // UART RX wires
    wire       rx_dv;   // data valid (conversion done)
    wire [7:0] rx_byte; // rx data

    uart_rx #(.UART_BAUD(9600)) rx (
        ICE_CLK,
        UART_RX,
        rx_dv,
        rx_byte
    );

    // RAM wires
    wire [7:0] ram_din;            // data input
    reg  [8:0] ram_write_addr = 0; // addr to write to
    wire       ram_write_en;       // write enable
    reg  [8:0] ram_read_addr  = 0; // addr to read from
    wire [7:0] ram_dout;           // data outptut (data at read location)

    assign ram_din      = rx_byte;
    assign ram_write_en = rx_dv;

    ram ram_inst (
        ICE_CLK,
        ram_write_addr,
        ram_din,
        ram_write_en,
        ram_read_addr,
        ram_dout
    );

    // UART TX wires
    reg        tx_dv;   // data valid (send this data out)
    wire [7:0] tx_byte; // data to send
    wire       tx_data; // UART TX line
    wire       tx_done; // done sending

    assign tx_byte = ram_dout;

    uart_tx2 #(.UART_BAUD(9600)) tx (
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
    // assign RLED1 = tx_byte[1];
    // assign RLED2 = tx_byte[2];
    // assign RLED3 = tx_byte[3];
    // assign RLED4 = tx_byte[4];
endmodule
