`default_nettype none
`timescale 1ns / 10ps

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

    assign pwm = (counter < level);
    // assign pwm = 0;

endmodule
