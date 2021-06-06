//----------------------------------------------------------------------------
//                         Module Declaration                               --
//----------------------------------------------------------------------------
module rgb_blink #(parameter PRESCALER = 0)
(
    input  clk,
    output pwm_red,   // Red
    output pwm_blue,  // Blue
    output pwm_green  // Green
);

    reg [(8 + PRESCALER):0] counter = 0;

    // Counter
    always @(posedge clk) begin
        counter <= counter + 1;
    end

    PWM #(.BITS(8)) red_pwm(clk, counter[(8 + PRESCALER):(1 + PRESCALER)], pwm_red);
    PWM #(.BITS(8)) blu_pwm(clk, counter[(8 + PRESCALER):(1 + PRESCALER)], pwm_blue);
    PWM #(.BITS(8)) grn_pwm(clk, counter[(8 + PRESCALER):(1 + PRESCALER)], pwm_green);
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
