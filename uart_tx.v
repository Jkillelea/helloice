module uart_tx (
    input       SER_CLK, // system clock
    input       TX_DV,   // ready to send
    input [7:0] TX_BYTE, // data to send
    output      TX_DATA, // serial data
    output      DONE     // done sending
);

    parameter UART_BAUD = 9600;
    parameter CLKS_PER_BIT = (12_000_000 / UART_BAUD);

    parameter IDLE    = 3'b000;
    parameter START   = 3'b001;
    parameter DATA    = 3'b010;
    parameter STOP    = 3'b011;
    parameter CLEANUP = 3'b100;

    reg [31:0] Clock_Count = 0;
    reg [2:0]  Bit_Idx     = 0;
    reg        Tx_Dv       = 0;
    reg [7:0]  Tx_Byte     = 0;
    reg        Tx_Data     = 0;
    reg        Done        = 0;
    reg [2:0]  State       = IDLE;

    always @(posedge SER_CLK) begin
        Tx_Dv   <= TX_DV;
    end

    always @(posedge SER_CLK) begin
        case (State)
            IDLE: begin
                Tx_Data <= 1; // idle high
                Done    <= 0; // done = 0

                if (Tx_Dv == 1) begin // read in byte
                    Tx_Byte <= TX_BYTE;
                    State   <= START;
                end
            end // IDLE

            START: begin
                Tx_Data <= 0; // drive low for start bit

                if (Clock_Count < CLKS_PER_BIT -1) begin
                    Clock_Count <= Clock_Count + 1;
                    State       <= START;
                end
                else begin
                    Clock_Count <= 0;
                    State       <= DATA;
                end
            end // START
                
            DATA: begin
                Tx_Data <= Tx_Byte[Bit_Idx]; // put bit on wire

                if (Clock_Count < CLKS_PER_BIT - 1) begin // hold bit there
                    Clock_Count <= Clock_Count + 1;
                end
                else begin
                    Clock_Count <= 0; // reset count

                    if (Bit_Idx < 7) begin // increment bit
                        Bit_Idx <= Bit_Idx + 1;
                    end
                    else begin
                        Bit_Idx <= 0;
                        State   <= STOP;
                    end
                end
            end // DATA
                
            STOP: begin
                Tx_Data <= 1;

                if (Clock_Count < CLKS_PER_BIT - 1) begin
                    Clock_Count <= Clock_Count + 1;
                end
                else begin
                    Done        <= 1; // pulse Done
                    Clock_Count <= 0;
                    State       <= CLEANUP;
                end
            end // STOP
                
            CLEANUP: begin
                Done    <= 0;
                State   <= IDLE;
                Bit_Idx <= 0;
            end // CLEANUP

            default: begin
                State <= IDLE;
            end // default
                
        endcase
    end

    assign TX_DATA = Tx_Data;
    assign DONE    = Done;
endmodule
