// `timescale 1ns/100ps

module test;

    reg reset = 0;
    reg [7:0] level = 0;

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test);

        #0 reset = 1;
        #1 reset = 0;
        #1 level = 100;
        #22 reset = 1;
        #15 reset = 0;
        #10000 $finish;
    end

    // oscillating clock
    reg clk = 0;
    always #1 clk = !clk;

    wire [7:0] value;
    wire pwm_out;
    counter c (clk, value, reset);
    PWM pwm(clk, level, pwm_out);

    UART_RX #(.CLKS_PER_BIT(213)) uart();

    initial begin
        $monitor("Time %t value = %d", $time, value);
    end

endmodule
