`default_nettype none
`timescale 1 ns / 1 ps

module shiftout(
    input                   CLK,
    input  [DATA_WIDTH-1:0] IN_DATA,
    input                   DATA_VALID,
    output                  SHIFT_LATCH,
    output                  SHIFT_CLOCK,
    output                  SHIFT_DATA,
    output                  BUSY
);

    parameter DATA_WIDTH   = 32;
    parameter FREQUENCY    = 1_000;
    parameter CLKS_PER_BIT = (12_000_000 / FREQUENCY);

    // just debugging.
    initial begin
        $display("shiftout: DATA_WIDTH = %d", DATA_WIDTH);
        $display("shiftout: FREQUENCY = %d", FREQUENCY);
        $display("shiftout: CLKS_PER_BIT = %d", CLKS_PER_BIT);
    end

    parameter IDLE    = 3'b000;
    parameter START   = 3'b001;
    parameter DATA    = 3'b010;
    parameter STOP    = 3'b011;
    parameter CLEANUP = 3'b100;

    reg                  shift_latch  = 1;
    reg                  shift_clock  = 0;
    reg                  shift_data   = 0;
    reg                  busy         = 0;
    reg [31:0]           clock_count  = 0;
    reg [DATA_WIDTH-1:0] data         = 0;
    reg [DATA_WIDTH-1:0] bit_idx      = 0; // this register could be a lot smaller
    reg  [2:0]           state        = IDLE;


    // latch in new data
    always @(posedge CLK) begin
        if (DATA_VALID && !BUSY) begin
            data <= IN_DATA;
        end
    end

    // state machine
    always @(posedge CLK) begin
        case (state)
            IDLE: begin // idle with latch high, all others zero
                busy        <= 0;
                shift_latch <= 1;
                shift_clock <= 0;
                shift_data  <= 0;

                if (DATA_VALID) begin // new data
                    state <= START;
                    busy  <= 1;
                end
            end

            START: begin // no start bit here, set busy bit and move on
                busy        <= 1;
                shift_latch <= 0;
                shift_clock <= 0;
                shift_data  <= 0;
                state       <= DATA;
            end

            DATA: begin
                busy        <= 1;
                shift_latch <= 0;
                shift_clock <= 0;
                shift_data  <= data[bit_idx];
                clock_count <= clock_count + 1;
                state       <= DATA;

                // wait until halfway through the bit period
                if (clock_count >= CLKS_PER_BIT/2 - 1) begin
                    shift_clock <= 1;

                    // at the end of the clock period
                    if (clock_count >= CLKS_PER_BIT - 1) begin
                        clock_count <= 0;

                        // if there's more bits to shift out, do so
                        if (bit_idx < DATA_WIDTH-1) begin
                            bit_idx <= bit_idx + 1;
                            // state   <= DATA;
                        end
                        else begin // else, we're done here
                            state <= STOP;
                        end
                    end
                end
            end

            STOP: begin
                busy        <= 1;
                shift_latch <= 0;
                shift_clock <= 0;
                shift_data  <= 0;
                clock_count <= clock_count + 1;

                if (clock_count >= CLKS_PER_BIT/2 - 1) begin
                    shift_latch <= 1;
                end

                if (clock_count >= CLKS_PER_BIT - 1) begin
                    state <= CLEANUP;
                end
                else begin
                    state <= STOP;
                end

            end

            CLEANUP: begin // housekeeping
                busy        <= 0;
                shift_latch <= 1;
                shift_clock <= 0;
                shift_data  <= 0;
                clock_count <= 0;
                bit_idx     <= 0;
                state       <= IDLE;
            end

            default: begin
                state <= IDLE;
            end
        endcase
    end

    assign SHIFT_LATCH = shift_latch;
    assign SHIFT_CLOCK = shift_clock;
    assign SHIFT_DATA  = shift_data;
    assign BUSY        = busy;
endmodule
