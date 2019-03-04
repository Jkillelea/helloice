`default_nettype none

module PWM (
    input       clk,
    input [7:0] level,
    output      out
);
    localparam WIDTH = 24; // counter register width
    reg [WIDTH-1:0] counter = 0;

    // generate a triangle wave
    always @(posedge clk) begin
        counter <= counter + 1;
    end

    // comparitor
    assign out = (counter[7:0] > level);
endmodule
