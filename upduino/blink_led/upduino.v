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
        .COUNTER_BITS(16),
        .PRESCALER(10)
    ) blinker (
        clk,
        pwm_red,
        pwm_blue,
        pwm_green
    );


    SB_IO #(
        // See Input and Output Pin Function Tables.
        // Default value of PIN_TYPE = 6’000000 i.e. // an input pad, with the input signal
        // registered.
        .PIN_TYPE(6'b0110_01), // simple input-output pin

        // By default, the IO will have NO pull up.
        // This parameter is used only on bank 0, 1,
        // and 2. Ignored when it is placed at bank 3
        .PULLUP(1'b0) 

        // Specify the polarity of all FFs in the IO to
        // be falling edge when NEG_TRIGGER = 1.
        // Default is rising edge.
        // .NEG_TRIGGER(1'b0),

        // Other IO standards are supported in bank 3
        // only: SB_SSTL2_CLASS_2, SB_SSTL2_CLASS_1,
        // SB_SSTL18_FULL, SB_SSTL18_HALF, SB_MDDR10,
        // SB_MDDR8, SB_MDDR4, SB_MDDR2 etc.
        // .IO_STANDARD("SB_LVCMOS"),
    ) led_pins [2:0] (
        .PACKAGE_PIN ({gpio_2, gpio_46, gpio_47}),  // User’s Pin signal name
        // .LATCH_INPUT_VALUE (latch_input_value),  // Latches holds the Input value
        // .CLOCK_ENABLE (clock_enable),            // Clock Enable common to input and output clock
        // .INPUT_CLK (input_clk),                  // Clock for the input registers
        .OUTPUT_CLK (clk),                          // Clock for the output registers
        .OUTPUT_ENABLE (1'b1),                      // Output Pin Tristate Enable control
        .D_OUT_0 ({pwm_red, pwm_green, pwm_blue}),  // Data 0 – out to Pin Rising clk edge
        .D_OUT_1 ({pwm_red, pwm_green, pwm_blue})   // Data 1 - out to Pin Falling clk edge
        // .D_IN_0 (),                              // Data 0 - Pin input Rising clk edge
        // .D_IN_1 ()                               // Data 1 – Pin input Falling clk edge
    ) /* synthesis DRIVE_STRENGTH= x2 */;


    // assign gpio_2  = pwm_red;
    // assign gpio_46 = pwm_green;
    // assign gpio_47 = pwm_blue;

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
