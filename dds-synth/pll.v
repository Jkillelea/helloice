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
    // F_PLLIN:    12.000 MHz (given)
    // F_PLLOUT:   60.000 MHz (requested)
    // F_PLLOUT:   60.000 MHz (achieved)
    // 
    // FEEDBACK: SIMPLE
    // F_PFD:   12.000 MHz
    // F_VCO:  960.000 MHz
    // 
    // DIVR:  0 (4'b0000)
    // DIVF: 79 (7'b1001111)
    // DIVQ:  4 (3'b100)
    // 
    // FILTER_RANGE: 1 (3'b001)

    // F_PLLIN:    12.000 MHz (given)
    // F_PLLOUT:  200.000 MHz (requested)
    // F_PLLOUT:  201.000 MHz (achieved)
    // 
    // FEEDBACK: SIMPLE
    // F_PFD:   12.000 MHz
    // F_VCO:  804.000 MHz
    // 
    // DIVR:  0 (4'b0000)
    // DIVF: 66 (7'b1000010)
    // DIVQ:  2 (3'b010)
    // 
    // FILTER_RANGE: 1 (3'b001)


    // F_PLLIN:    12.000 MHz (given)
    // F_PLLOUT:  275.000 MHz (requested)
    // F_PLLOUT:  276.000 MHz (achieved)
    // 
    // FEEDBACK: SIMPLE
    // F_PFD:   12.000 MHz
    // F_VCO:  552.000 MHz
    // 
    // DIVR:  0 (4'b0000)
    // DIVF: 45 (7'b0101101)
    // DIVQ:  1 (3'b001)
    // 
    // FILTER_RANGE: 1 (3'b001)


    // DIVR:  0 (4'b0000)
    // DIVF: 79 (7'b1001111)
    // DIVQ:  4 (3'b100)
    // 
    // FILTER_RANGE: 1 (3'b001)
    SB_PLL40_CORE #(
       .FEEDBACK_PATH("SIMPLE"),
       .DIVR(4'b0000),
       .DIVF(7'b1001111),
       .DIVQ(3'b100),
       .FILTER_RANGE(3'b001)
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

