// `timescale 1ns/100ps

module counter(
    input        clk,
    output [7:0] out,
    input        reset);

    reg [7:0] out;

    always @(posedge clk) begin
        out = out + 1;
    end

    always @(reset) begin
        if (reset)
           assign out = 0;
        else
           deassign out;
    end

endmodule
