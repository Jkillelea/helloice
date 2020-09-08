`default_nettype none

module uart_tx2 #(
    parameter UART_BAUD = 9600;
) (
    input       CLK,
    input       TX_DV,
    input [7:0] TX_BYTE,
    output      TX_DATA,
    output      DONE // done sending, ready for new data
);

    // parameter UART_BAUD = 9600;
    // parameter UART_BAUD = 115200;
    // parameter UART_BAUD = 921600;
    parameter CLKS_PER_BIT = (12_000_000 / UART_BAUD);

    parameter IDLE    = 3'b000;
    parameter START   = 3'b001;
    parameter DATA    = 3'b010;
    parameter STOP    = 3'b011;
    parameter CLEANUP = 3'b100;

    // If new data available and done sending copy it in
    always @(posedge CLK) begin
        if (TX_DV && Done) begin
            Tx_Byte <= TX_BYTE;
        end
    end

    reg [7:0]  Tx_Byte     = 0;
    reg        Tx_Data     = 0;
    reg        Done        = 0;
    reg [2:0]  Bit_Idx     = 0;
    reg [31:0] Clock_Count = 0;
    reg [2:0]  State       = IDLE;

    always @(posedge CLK) begin
        case (State)
            IDLE: begin
                Tx_Data     <= 1; // idle high
                Done        <= 1;
                Bit_Idx     <= 0;
                Clock_Count <= 0;

                if (TX_DV == 1) begin
                    State <= START;
                    Done <= 0;
                end
            end

            START: begin // send the start bit
                Tx_Data <= 0; // start bit
                Done <= 0;

                if (Clock_Count < CLKS_PER_BIT - 1 ) begin
                    Clock_Count <= Clock_Count + 1;
                end
                else begin
                    Clock_Count <= 0;
                    State <= DATA;
                end
            end

            DATA: begin
                Tx_Data <= Tx_Byte[Bit_Idx];

                if (Clock_Count < CLKS_PER_BIT - 1) begin
                    Clock_Count <= Clock_Count + 1;
                end
                else begin
                    Clock_Count <= 0;

                    if (Bit_Idx < 7) begin
                        Bit_Idx <= Bit_Idx + 1;
                    end
                    else begin
                        Bit_Idx <= 0;
                        State <= STOP;
                    end
                end
            end

            STOP: begin
                Tx_Data <= 1;

                if (Clock_Count < CLKS_PER_BIT - 1) begin
                    Clock_Count <= Clock_Count + 1;
                end
                else begin
                    State <= IDLE;
                end
            end

            default: begin
                State <= IDLE;
            end
        endcase
    end

    assign DONE    = Done;
    assign TX_DATA = Tx_Data;
endmodule
