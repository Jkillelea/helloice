`default_nettype none
`timescale 1ns / 10ps

//----------------------------------------------------------------------------
//                         Top Level Board Declaration                      --
//----------------------------------------------------------------------------
module GtkWave ();

    parameter CLOCK_FREQ      = 10_000_000;
    parameter CLOCK_PERIOD_NS = 1_000_000_000 / CLOCK_FREQ;
    parameter CLOCKS_PER_BIT  = CLOCK_FREQ / 115200;

    reg clk = 0;
    always
        #(1) clk <= !clk;

    // The LED pins are on dedicated pins and cannot be modified!
    // Note that they are negative logic (write a 0 to turn on).
    // These are also brought out to the left side of the board.
    // Cut the board trace on jumper R28 to disable the onboard 3 color LED.
    wire led_green;
    wire led_red;
    wire led_blue;

    // FTDI chip interface
    wire serial_txd; // FPGA transmit to USB
    wire serial_rxd; // FPGA receive from USB
    wire spi_cs; // Connected to SPI flash, drive high unless using SPI flash!

    // Normal GPIO pins, left side
    wire gpio_23;
    wire gpio_25;
    wire gpio_26;
    wire gpio_27;
    wire gpio_32;
    wire gpio_35;
    wire gpio_31;
    wire gpio_37;
    wire gpio_34;
    wire gpio_43;
    wire gpio_36;
    wire gpio_42;
    wire gpio_38;
    wire gpio_28;

    // Normal GPIO pins, right side
    // Following pins are added on the v3.0 of the board.
    // SPI pins are brought out to the right side of the board
    // Note: On board 12MHz clock can be brought to IOB_25B_G3 (pin 20) which is a global
    // clock input. Short across R16 (labelled OSC on the board) to enable 12MHz clock to
    // pin 20.
    wire gpio_20;
    wire gpio_10;

    // Following are also found on v2.x of the UPduino
    wire gpio_12;
    wire gpio_21;
    wire gpio_13;
    wire gpio_19;
    wire gpio_18;
    wire gpio_11;
    wire gpio_9;
    wire gpio_6;
    wire gpio_44;
    wire gpio_4;
    wire gpio_3;
    wire gpio_48;
    wire gpio_45;
    wire gpio_47;
    wire gpio_46;
    wire gpio_2;

    wire pwm_red;
    wire pwm_blue;
    wire pwm_green;

    rgb_blink #(
        .COUNTER_BITS(16),
        .PRESCALER(3)
    ) blinker (
        clk,
        pwm_red,
        pwm_blue,
        pwm_green
    );


    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, GtkWave);
        $display("starting...");

        #50000000
        $display("done.");
        $finish;
    end

endmodule
