module ToStr (
    input  [3:0] i_number,
    output [7:0] asciiout
);

    assign asciiout = (0 <= i_number && i_number <= 9) ? i_number + 48 : 0;

endmodule
