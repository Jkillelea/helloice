`default_nettype none
`timescale 1ns / 10ps

module rgb_blink #(
    parameter PRESCALER = 0
) (
    input  clk,
    output pwm_red,   // Red
    output pwm_blue,  // Blue
    output pwm_green  // Green
);

    localparam COUNTER_BITS = 8 + PRESCALER;

    wire [COUNTER_BITS-1:0] pwm_level;
    wire direction;

    SAWTOOTH #(
        .PRESCALER(1),
        .WIDTH(COUNTER_BITS)
    ) sawtooth (
        clk,
        pwm_level,
        direction
    );

    wire pwm_signal;
    PWM #(
        .BITS(8)
    ) led_pwm (
        clk,
        pwm_level[(COUNTER_BITS - 1):(COUNTER_BITS - 8)],
        pwm_signal
    );

    reg [1:0] color_select = 2'b0;
    always @(posedge direction) begin
        if (color_select == 2)
            color_select <= 0;
        else
            color_select <= color_select + 1;
    end

    wire [3:0] outputs;
    Mux4Out1In mux (
        outputs,
        color_select,
        pwm_signal
    );
    assign pwm_red   = outputs[0];
    assign pwm_green = outputs[1];
    assign pwm_blue  = outputs[2];

endmodule

module Mux4In1Out
(
    output reg out,
    input [1:0] input_select,
    input [3:0] inputs
);
    always @(*) begin
        out = inputs[input_select];
    end
endmodule

module Mux4Out1In
(
    output reg [3:0] outputs,
    input      [1:0] output_select,
    input            in
);

    always @(*) begin
        outputs                = {1'b1, 1'b1, 1'b1, 1'b1};
        outputs[output_select] = in;
        
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

    always @(posedge clk) begin
        counter <= counter + 1;
    end

    assign pwm = (counter > level);
    // assign pwm = 0;

endmodule
