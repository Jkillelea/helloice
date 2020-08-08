// A module for top level clock generation, input/output mapping.
// Designed to be replaced by tb.v when run in simulation
`default_nettype none
`timescale 1ns/1ps
module BSP (
    input ICE_CLK,
    output GLED5,
    output RLED1,
    output RLED2,
    output RLED3,
    output RLED4,
    output J3_10
);
    // wire pll_50m_clk;
    // wire pll_locked;
    // pll pll_50m (ICE_CLK, pll_50m_clk, pll_locked);


    wire clk;
    wire ws2812_dat;
    wire ws2812_done;
    wire ws2812_reset;
    assign clk = ICE_CLK;

    assign J3_10 = ws2812_dat;
    assign GLED5 = ws2812_dat;
    assign RLED1 = 0;
    assign RLED2 = ws2812_done;
    assign RLED3 = ws2812_reset;
    assign RLED4 = 0;

    Top #(.F_CLK(50_000_000)) top(clk, ws2812_dat, ws2812_done, ws2812_reset);

endmodule
