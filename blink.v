`default_nettype none

// Blinks LEDs and ramps a PWM signal
module Blink(
    input ICE_CLK,
    output GLED5,
    output RLED1,
    output RLED2,
    output RLED3,
    output RLED4,
    output J3_10,
    output J3_9,
);

    // define a 24-bit counter to divide the clock down from 12MHz
    localparam WIDTH = 24;
    reg [WIDTH-1:0] counter;

    // 8 bit PWM level
    reg [7:0] pwm_level;
    wire pwm_out;

    localparam UP   = 1'b0;
    localparam DOWN = 1'b1;
    reg state = UP;

    // run counter from 12MHz clock
    always @(posedge ICE_CLK) begin
        counter <= counter + 1;

        if (counter[15:0] == 0) begin // when the first 16 bits of the counter max out
            if (state == UP) begin            // counting up
                if (pwm_level == 8'hFF) begin // max val
                    state <= DOWN;            // change direction
                    pwm_level <= pwm_level - 1;
                end else                      // not max yet
                    pwm_level <= pwm_level + 1;
            end else begin                    // counting down
                if (pwm_level == 8'h00) begin // min val
                    state <= UP;              // change direction
                    pwm_level <= pwm_level + 1;
                end else                      // not min yet
                    pwm_level <= pwm_level - 1;
            end
        end
    end

    PWM pwm(ICE_CLK, pwm_level, pwm_out);

    assign RLED1 = pwm_out;
    assign RLED2 = pwm_out;
    assign RLED3 = pwm_out;
    assign RLED4 = pwm_out;
    assign GLED5 = ~pwm_out;

    assign J3_10 = pwm_out;
    assign J3_9  = ~pwm_out;

    // wire up the red LEDs to the counter MSB
    // assign RLED1 = counter[WIDTH-1];
    // assign RLED2 = counter[WIDTH-2];
    // assign RLED3 = counter[WIDTH-3];
    // assign RLED4 = counter[WIDTH-4];
endmodule
