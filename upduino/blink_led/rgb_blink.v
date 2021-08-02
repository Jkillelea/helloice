`default_nettype none
`timescale 1ns / 10ps

module rgb_blink #(
    parameter COUNTER_BITS = 8,
    parameter PRESCALER    = 0
) (
    input  clk,
    output pwm_red,   // Red
    output pwm_blue,  // Blue
    output pwm_green  // Green
);


    wire [COUNTER_BITS-1:0] pwm_level;
    wire direction;

    SAWTOOTH #(
        .PRESCALER(PRESCALER),
        .WIDTH(COUNTER_BITS)
    ) sawtooth (
        clk,
        pwm_level,
        direction
    );

    wire pwm_signal;
    PWM #(
        .BITS(COUNTER_BITS)
    ) LED_PWM (
        clk,
        pwm_level,
        pwm_signal
    );

    // Cycle through colors
    reg [1:0] color_select = 2'b0;
    always @(posedge direction) begin
        color_select <= color_select + 1;
    end

    // Mux the pwm signal to LED outputs
    wire [3:0] outputs;
    Mux4Out1In mux (
        outputs,
        color_select,
        pwm_signal
    );
    assign pwm_red   = outputs[0] | outputs[3];
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
        outputs                = {1'b0, 1'b0, 1'b0, 1'b0};
        outputs[output_select] = in;
        
    end

endmodule
