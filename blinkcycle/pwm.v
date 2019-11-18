`default_nettype none

module PWM (
    input       clk,
    input [7:0] level,
    output      out
);
    parameter COUNTER_BITS = 24; // counter register width
    reg [COUNTER_BITS-1:0] counter;

    // generate a triangle wave
    always @(posedge clk) begin
        counter <= counter + 1;
    end

    // comparitor
    assign out = (counter[7:0] > level);
endmodule
