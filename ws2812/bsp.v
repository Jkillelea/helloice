// A module for top level clock generation, input/output mapping.
// Designed to be replaced by tb.v when run in simulation
`default_nettype none
`timescale 1ns/1ps
module BSP (
    input ICE_CLK,
    output OUT106
);
    // wire pll_50m_clk;
    // wire pll_locked;
    // pll pll_50m (ICE_CLK, pll_50m_clk, pll_locked);

    wire clk;
    wire ws2812_dat;
    assign clk = ICE_CLK;
    assign ws2812_dat = OUT106;

    Top #(.F_CLK(12_000_000)) top(clk, ws2812_dat);

endmodule
