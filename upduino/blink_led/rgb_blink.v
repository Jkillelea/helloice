`default_nettype none
`timescale 1ns / 10ps

module rgb_blink #(parameter PRESCALER = 0)
(
    input  clk,
    output pwm_red,   // Red
    output pwm_blue,  // Blue
    output pwm_green  // Green
);

    localparam COUNTER_BITS = 7 + PRESCALER;
    localparam DIR_UP = 1'b0;
    localparam DIR_DN = 1'b1;

    reg [COUNTER_BITS:0] pwm_level = 0;

    reg direction = DIR_UP;

    reg [1:0] color_select = 0;

    // Counter
    always @(posedge clk) begin
        case (direction)
            DIR_UP: begin
                if (pwm_level == ((2 << COUNTER_BITS) - 2)) begin // overflow, go down
                    direction <= DIR_DN;
                end else begin
                    pwm_level <= pwm_level + 1;
                end
            end

            DIR_DN: begin
                if (pwm_level == 1) begin // underflow, go up and switch to the next color
                    direction <= DIR_UP;

                    if (color_select == 2) begin
                        color_select <= 0;
                    end else begin
                        color_select <= color_select + 1;
                    end

                end else begin
                    pwm_level <= pwm_level - 1;
                end
            end

            default: begin
                pwm_level <= pwm_level + 1;
            end
        endcase
    end

    wire pwm_signal;
    PWM #(.BITS(8)) led_pwm(clk, pwm_level[(7 + PRESCALER):(0 + PRESCALER)], pwm_signal);

    wire [3:0] outputs;
    assign pwm_red   = outputs[0];
    assign pwm_green = outputs[1];
    assign pwm_blue  = outputs[2];
    Mux4Out1In mux(outputs, color_select, pwm_signal);

endmodule

module Mux4In1Out
(
    output reg out,
    input [1:0] input_select,
    input [3:0] inputs
);
    always @(*) begin
        out <= inputs[input_select];
    end
endmodule

module Mux4Out1In
(
    output reg [3:0] outputs,
    input  [1:0] output_select,
    input        in
);
    always @(*) begin
        outputs <= {1'b1, 1'b1, 1'b1, 1'b1};
        outputs[output_select] <= in;
    end
endmodule

// Simple PWM module
//     /|    /|    /| Counter
//    / |   / |   / |
//-------------------- level
//  /   | /   | /   |
// /    |/    |/    |
//
//   |--|  |--|  |--| pwm
//   |  |  |  |  |  |
//   |  |  |  |  |  |
//---|  |--|  |--|  |
//
// PWM Frequency is F_CLK / (2^BITS)
module PWM #(parameter BITS = 8)
(
    input            clk,
    input [BITS-1:0] level,
    output           pwm
);
    reg [BITS-1:0] counter = 0;

    always @(posedge clk)
        counter <= counter + 1;

    assign pwm = (counter > level);
endmodule
