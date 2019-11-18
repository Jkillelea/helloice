`default_nettype none
module ram (
    input  wire                  CLK,
    input  wire [addr_width-1:0] WR_ADDR,
    input  wire [data_width-1:0] DIN,
    input  wire                  WR_EN,
    input  wire [addr_width-1:0] RD_ADDR,
    output wire [data_width-1:0] DOUT
);
    // 512x8 RAM, taken directly from Lattice ice40 memory programming guide
    parameter addr_width = 9;
    parameter data_width = 8;

    // The actual RAM hardware block is inferred here by the very large register
    // rather than being explicityly stated
    // reg [data_width-1:0] DOUT; // Register for output.
    reg [data_width-1:0] mem[(1 << addr_width) - 1:0];

    always @(posedge CLK) begin
        if (WR_EN)
            mem[WR_ADDR] <= DIN;
        // DOUT <= mem[RD_ADDR]; // Output register controlled by clock.
    end
    assign DOUT = mem[RD_ADDR];

endmodule
