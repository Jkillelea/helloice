// based on https://www.nandland.com/vhdl/modules/module-uart-serial-port-rs232.html

`default_nettype none
`timescale 1ns / 1ps

module uart_rx 
(
    input        SER_CLK,
    input        RX_SERIAL,
    output       RX_DV,
    output [7:0] RX_BYTE
);

    parameter UART_BAUD    = 9600;
    // parameter UART_BAUD    = 115200;
    // parameter UART_BAUD    = 921600;
    parameter CLKS_PER_BIT = (12_000_000 / UART_BAUD);

    parameter IDLE    = 3'b000;
    parameter START   = 3'b001;
    parameter DATA    = 3'b010;
    parameter STOP    = 3'b011;
    parameter CLEANUP = 3'b100;

    // NOTE: if clock counter doesn't have enough bits it can overflow
    // quite easily
    reg [31:0] Clock_Count = 0; 
    reg [2:0]  Bit_Idx     = 0;
    reg [7:0]  Rx_Byte     = 0;
    reg        Rx_Dv       = 0;
    reg [2:0]  State       = 0;
    reg        Rx_Data     = 1;

    always @(posedge SER_CLK) begin
        Rx_Data <= RX_SERIAL;
    end

    always @(posedge SER_CLK) begin
        case (State)
            IDLE: begin // no data on line
                Rx_Dv       <= 1'b0;
                Clock_Count <= 0;
                Bit_Idx     <= 0;

                // check for start bit
                if (Rx_Data == 0)
                    State <= START;
                else
                    State <= IDLE;
            end // IDLE

            START: begin // start bit detected
                if (Clock_Count == (CLKS_PER_BIT-1)/2) begin // wait to halfway through
                    if (Rx_Data == 0) begin                  // clock period, check
                        Clock_Count <= 0;                    // that start bit is still
                        State       <= DATA;                 // valid. If so, recieve
                        Rx_Byte     <= 0;                    // the data
                    end
                end
                else begin                           // clock up to halfway through
                    Clock_Count <= Clock_Count + 1;  // the start bit
                    State       <= START;
                end
            end // START

            DATA: begin
                if (Clock_Count < CLKS_PER_BIT - 1) begin
                    Clock_Count <= Clock_Count + 1;
                    State       <= DATA;
                end
                else begin
                    Clock_Count      <= 0;
                    Rx_Byte[Bit_Idx] <= Rx_Data;
                    // more bits to recieve?
                    if (Bit_Idx < 7) begin
                        Bit_Idx <= Bit_Idx + 1;
                        State   <= DATA;
                    end
                    else begin
                        Bit_Idx <= 0;
                        State   <= STOP;
                    end
                end
            end // DATA

            STOP: begin
                if (Clock_Count < CLKS_PER_BIT - 1) begin // wait for stop bit to finish
                    Clock_Count <= Clock_Count + 1;
                    State       <= STOP;
                end
                else begin
                    Rx_Dv       <= 1'b1;
                    Clock_Count <= 0;
                    State       <= CLEANUP;
                end
            end // STOP

            CLEANUP: begin // pretty optional I think
                State <= IDLE;
                Rx_Dv <= 1'b0;
            end // CLEANUP

            default:
                State <= IDLE;
        endcase
    end
 
    assign RX_DV   = Rx_Dv;
    assign RX_BYTE = Rx_Byte;

endmodule
