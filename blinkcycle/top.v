module top(
    input  ICE_CLK,
    output RLED1,
    output RLED2,
    output RLED3,
    output RLED4,
    output GLED5
);

    // slow down the clock
    reg [23:0] clock_div = 0;
    always @(posedge ICE_CLK)
        clock_div <= clock_div + 1;

    parameter COUNT_UP   = 1'b0;
    parameter COUNT_DOWN = 1'b1;
    reg count_state = COUNT_UP;

    reg [7:0] level = 0;
    wire pwm_out;

    PWM pwm(ICE_CLK, level, pwm_out);

    always @(posedge clock_div[15]) begin
        case (count_state)
            COUNT_UP : begin
                level <= level + 1;
                if (level == 'hFE)
                    count_state <= COUNT_DOWN;
            end
            COUNT_DOWN : begin
                level <= level - 1;
                if (level == 'h01) begin
                    count_state <= COUNT_UP;
                    if (channel > 4)
                        channel <= 0;
                    else
                        channel <= channel + 1;
                end
            end
        endcase
    end


endmodule

