`default_nettype none

//----------------------------------------------------------------------------
//                         Top Level Board Declaration                      --
//----------------------------------------------------------------------------
module Upduino (
    // The LED pins are on dedicated pins and cannot be modified!
    // Note that they are negative logic (write a 0 to turn on).
    // These are also brought out to the left side of the board.
    // Cut the board trace on jumper R28 to disable the onboard 3 color LED.
    output led_green,
    output led_red,
    output led_blue,

    // FTDI chip interface
    output serial_txd, // FPGA transmit to USB
    input  serial_rxd, // FPGA receive from USB
    output spi_cs,     // Connected to SPI flash, drive high unless using SPI flash!

    // Normal GPIO pins, left side
    inout gpio_23,
    inout gpio_25,
    inout gpio_26,
    inout gpio_27,
    inout gpio_32,
    inout gpio_35,
    inout gpio_31,
    inout gpio_37,
    inout gpio_34,
    inout gpio_43,
    inout gpio_36,
    inout gpio_42,
    inout gpio_38,
    inout gpio_28,

    // Normal GPIO pins, right side
    // Following pins are added on the v3.0 of the board.
    // SPI pins are brought out to the right side of the board
    // Note: On board 12MHz clock can be brought to IOB_25B_G3 (pin 20) which is a global
    // clock input. Short across R16 (labelled OSC on the board) to enable 12MHz clock to
    // pin 20.
    inout gpio_20,
    inout gpio_10,

    // Following are also found on v2.x of the UPduino
    inout gpio_12,
    inout gpio_21,
    inout gpio_13,
    inout gpio_19,
    inout gpio_18,
    inout gpio_11,
    inout gpio_9,
    inout gpio_6,
    inout gpio_44,
    inout gpio_4,
    inout gpio_3,
    inout gpio_48,
    inout gpio_45,
    inout gpio_47,
    inout gpio_46,
    inout gpio_2
);

    assign spi_cs = 1'b1;
    assign serial_txd = 1'b1; // idle

    parameter F_CLK = 48_000_000; // Hz
    wire clk;
    SB_HFOSC int_osc_48m (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

    wire pwm_red;
    wire pwm_blue;
    wire pwm_green;

    rgb_blink #(
        .PRESCALER(16)
    ) blinker (
        clk,
        pwm_red,
        pwm_blue,
        pwm_green
    );

    assign gpio_2  = pwm_red;
    assign gpio_46 = pwm_green;
    assign gpio_47 = pwm_blue;

    // Instantiate RGB primitive
    SB_RGBA_DRV RGB_DRIVER (
      .RGBLEDEN(1'b1),

      // Outputs are open drain
      .RGB0PWM (pwm_green),
      .RGB1PWM (pwm_blue),
      .RGB2PWM (pwm_red),

      .CURREN  (1'b1),

      //Actual Hardware connection
      .RGB0    (led_green),
      .RGB1    (led_blue),
      .RGB2    (led_red)
    );

    defparam RGB_DRIVER.RGB0_CURRENT = "0b000001";
    defparam RGB_DRIVER.RGB1_CURRENT = "0b000001";
    defparam RGB_DRIVER.RGB2_CURRENT = "0b000001";

endmodule
