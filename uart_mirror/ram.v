`default_nettype none
module ram (
    input  wire                  CLK,
    input  wire [addr_width-1:0] WR_ADDR,
    input  wire [data_width-1:0] DIN,
    input  wire                  WR_EN,
    input  wire [addr_width-1:0] RD_ADDR,
    output reg  [data_width-1:0] DOUT
);
    // 512x8 RAM, taken directly from Lattice ice40 memory programming guide
    parameter addr_width = 9;
    parameter data_width = 8;

    // The actual RAM hardware block is inferred here by the very large register
    // rather than being explicityly stated
    // reg [data_width-1:0] DOUT; // Register for output.
    reg [data_width-1:0] mem[(1 << addr_width) - 1:0];
    initial begin
        mem[0] = 0;
    end

    // The line below causes synthesis to fail on newer version of 
    // yosys for some reason
    // assign DOUT = mem[RD_ADDR];

    always @(posedge CLK) begin
        if (WR_EN)
            mem[WR_ADDR] <= DIN;
    end

    // This is just a huge hack but it makes the timing work
    always @(negedge CLK) begin
        DOUT <= mem[RD_ADDR];
    end

endmodule
