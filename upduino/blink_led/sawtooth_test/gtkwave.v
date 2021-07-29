`default_nettype none
`timescale 1ns / 10ps

//----------------------------------------------------------------------------
//                         Top Level Board Declaration                      --
//----------------------------------------------------------------------------
module GtkWave ();

    reg clk = 0;
    always
        #(1) clk <= !clk;

    wire [7:0] waveform = 0;
    SAWTOOTH #(.WIDTH(8)) sawtooth_inst (clk, waveform);

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, sawtooth_inst);
        $display("starting...");

        #1000000
        $display("done.");
        $finish;
    end

endmodule
