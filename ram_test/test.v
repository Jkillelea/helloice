`timescale 1ns / 10ps
// `include "uart_tx2.v"
// `include "uart_rx.v"
// `include "ram.v"

module test();
    // Testbench uses a 10 MHz clock
    // Want to interface to 115200 baud UART
    // 10000000 / 115200 = 87 Clocks Per Bit.
    parameter CLOCK_FREQ      = 10_000_000;
    parameter CLOCK_PERIOD_NS = 1_000_000_000 / CLOCK_FREQ;
    parameter CLOCKS_PER_BIT  = CLOCK_FREQ / 115200;

    reg clk = 0;
    always
        #(CLOCK_PERIOD_NS/2) clk <= !clk;

    reg        input_tx_dv = 0;
    reg [7:0]  input_tx_byte = 0;
    wire       input_tx_data;
    wire       input_tx_done;
    uart_tx2#(.CLKS_PER_BIT(CLOCKS_PER_BIT)) uart_input(clk,
                                                        input_tx_dv,
                                                        input_tx_byte,
                                                        input_tx_data,
                                                        input_tx_done);

    wire       rx_data;
    wire       rx_dv;
    wire [7:0] rx_byte;

    assign rx_data = input_tx_data;

    uart_rx #(.CLKS_PER_BIT(CLOCKS_PER_BIT)) rx(clk, rx_data, rx_dv, rx_byte);

    wire [7:0] ram_din;
    reg  [8:0] ram_wr_addr = 0;
    wire       ram_wr_en;
    reg  [8:0] ram_rd_addr = 0;
    wire [7:0] ram_dout;

    assign ram_din   = rx_byte;
    assign ram_wr_en = rx_dv;
    ram ram_inst(ram_din, ram_wr_addr, ram_wr_en, clk, ram_rd_addr, ram_dout);

    wire       tx_dv;
    wire [7:0] tx_byte;
    wire       tx_data;
    wire       tx_done;

    wire data_available = (ram_rd_addr <= ram_wr_addr);
    assign tx_dv   = (tx_done && data_available);
    assign tx_byte = ram_dout;

    uart_tx2#(.CLKS_PER_BIT(CLOCKS_PER_BIT)) uart_tx(clk,
                                                     tx_dv,
                                                     tx_byte,
                                                     tx_data,
                                                     tx_done);

    always @(posedge rx_dv) begin
        ram_wr_addr <= ram_wr_addr + 1;
    end

    always @(posedge tx_done) begin
        if (data_available)
            ram_rd_addr <= ram_rd_addr + 1;
    end

    reg [7:0] ii;
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test);
        @(posedge clk);
        @(posedge clk);

        input_tx_byte <= 8'h0F;
        input_tx_dv <= 1;
        @(posedge clk);
        input_tx_dv <= 0;
        @(posedge input_tx_done);

        input_tx_byte <= 8'hAA;
        input_tx_dv <= 1;
        @(posedge clk);
        input_tx_dv <= 0;
        @(posedge input_tx_done);

        input_tx_byte <= 8'h80;
        input_tx_dv <= 1;
        @(posedge clk);
        input_tx_dv <= 0;

        // for (ii = 0; ii < 100; ii++) begin
        //     $display(ii);
        //     input_tx_byte <= ii;
        //     input_tx_dv <= 1;
        //     @(posedge clk);
        //     input_tx_dv <= 0;
        //     @(posedge input_tx_done);
        // end

        @(posedge tx_done);
        #1000000
        $finish;
    end
endmodule
