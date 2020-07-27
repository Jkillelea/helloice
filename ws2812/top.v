module Top (
    input ICE_CLK,
    output WS2812_DAT
);

    wire pll_50m_clk;
    wire pll_locked;

    pll pll_50m (ICE_CLK, pll_50m_clk, pll_locked);

    reg [23:0] indata = 0;
    reg        reset  = 0;
    wire       done;

    BitController #(
        .F_CLK(50_000_000)
    ) ws2812_bitcontroller (
        pll_50m_clk,
        indata,
        reset,
        WS2812_DAT,
        done
    );

    always @(posedge pll_50m_clk) begin
        reset <= 0;
        indata <= indata;
        if (done) begin
            reset <= 1;
            indata <= indata + 1;
        end
    end

endmodule
