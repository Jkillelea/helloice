`default_nettype none

module Top(
    input ICE_CLK,
    output GLED5
);

    reg [18:0] counter = 0;

    always @(posedge ICE_CLK) begin
        counter <= counter + 1;
    end

    wire servo_clk;
    assign servo_clk = counter[18]; // 50ish Hz servo clock



endmodule;
