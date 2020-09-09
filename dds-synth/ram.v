// 512x8 RAM, taken from Lattice ice40 memory programming guide
`default_nettype none
module ram #(
    parameter ADDR_WIDTH = 9,
    parameter DATA_WIDTH = 8
) (
    input                       clk,
    input      [ADDR_WIDTH-1:0] wr_addr,
    input      [DATA_WIDTH-1:0] din,
    input                       wr_en,
    input      [ADDR_WIDTH-1:0] rd_addr,
    output reg [DATA_WIDTH-1:0] dout
);

    // The actual RAM hardware block is inferred here by the very large register
    // rather than being explicityly stated
    reg [DATA_WIDTH-1:0] bram_memory[(1<<ADDR_WIDTH)-1:0];

    always @(posedge clk) begin
        if (wr_en)
            bram_memory[wr_addr] <= din;
        dout <= bram_memory[rd_addr]; // Output register controlled by clock.
    end

endmodule
