/**
* PLL configuration
*
* This Verilog header file was generated automatically
* using the icepll tool from the IceStorm project.
* It is intended for use with FPGA primitives SB_PLL40_CORE,
* SB_PLL40_PAD, SB_PLL40_2_PAD, SB_PLL40_2F_CORE or SB_PLL40_2F_PAD.
* Use at your own risk.
*
* Given input frequency:        12.000 MHz
* Requested output frequency:   75.000 MHz
* Achieved output frequency:    75.000 MHz
*/

module pll (
   input  clock_in,
   output clock_out,
   output locked
);

    wire clk_to_buf;

    SB_PLL40_CORE #(
       .FEEDBACK_PATH("SIMPLE"),
       .DIVR(4'b0000),		// DIVR =  0
       .DIVF(7'b0110001),	// DIVF = 49
       .DIVQ(3'b011),		// DIVQ =  3
       .FILTER_RANGE(3'b001)	// FILTER_RANGE = 1
    ) uut (
       .LOCK(locked),
       .RESETB(1'b1),
       .BYPASS(1'b0),
       .REFERENCECLK(clock_in),
       .PLLOUTCORE(clk_to_buf)
    );

    // buffer the signal for reduced skew across the chip
    SB_GB PllBuffer(
       .USER_SIGNAL_TO_GLOBAL_BUFFER(clk_to_buf),
       .GLOBAL_BUFFER_OUTPUT(clock_out)
    );

endmodule

