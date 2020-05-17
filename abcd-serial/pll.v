/**
 * PLL configuration
 *
 * This Verilog module was generated automatically
 * using the icepll tool from the IceStorm project.
 * Use at your own risk.
 *
 * Given input frequency:        12.000 MHz
 * Requested output frequency:   50.000 MHz
 * Achieved output frequency:    50.250 MHz
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
		.DIVF(7'b1000010),	// DIVF = 66
		.DIVQ(3'b100),		// DIVQ =  4
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