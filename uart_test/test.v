`timescale 1ns / 10ps
// `include "uart_tx.v"
// `include "uart_rx.v"

module test();

  // Testbench uses a 10 MHz clock
  // Want to interface to 115200 baud UART
  // 10000000 / 115200 = 87 Clocks Per Bit.
  parameter c_CLOCK_PERIOD_NS = 100;
  parameter c_CLKS_PER_BIT    = 87;
  parameter c_BIT_PERIOD      = 8600;

  reg r_Clock = 0;
  reg r_Tx_DV = 0;
  wire w_Tx_Done;
  reg [7:0] r_Tx_Byte = 0;
  reg r_Rx_Serial = 1;
  wire [7:0] w_Rx_Byte;


  // Takes in input byte and serializes it
  task UART_WRITE_BYTE;
    input [7:0] i_Data;
    integer     ii;
    begin

      // Send Start Bit
      r_Rx_Serial <= 1'b0;
      #(c_BIT_PERIOD);
      #1000;

      // Send Data Byte
      for (ii=0; ii<8; ii=ii+1)
        begin
          r_Rx_Serial <= i_Data[ii];
          #(c_BIT_PERIOD);
        end

      // Send Stop Bit
      r_Rx_Serial <= 1'b1;
      #(c_BIT_PERIOD);
     end
  endtask // UART_WRITE_BYTE


  uart_rx #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_RX_INST
    (.SER_CLK(r_Clock),
     .RX_SERIAL(r_Rx_Serial),
     .RX_DV(),
     .RX_BYTE(w_Rx_Byte)
     );

  // uart_tx #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_TX_INST
  //   (.SER_CLK(r_Clock),
  //    .TX_DV(r_Tx_DV),
  //    .TX_BYTE(r_Tx_Byte),
  //    .TX_DATA(),
  uart_tx2 #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_TX_INST
    (.CLK(r_Clock),
     .TX_DV(r_Tx_DV),
     .TX_BYTE(r_Tx_Byte),
     .TX_DATA(),
     .DONE(w_Tx_Done)
     );


  always
    #(c_CLOCK_PERIOD_NS/2) r_Clock <= !r_Clock;


  // Main Testing:
  initial begin
      $dumpfile("test.vcd");
      $dumpvars(0, test);
      // Tell UART to send a command (exercise Tx)
      @(posedge r_Clock);
      @(posedge r_Clock);
      r_Tx_DV <= 1'b1;
      r_Tx_Byte <= 8'b10101010;
      @(posedge r_Clock);
      r_Tx_DV <= 1'b0;
      @(posedge w_Tx_Done);

      // Send a command to the UART (exercise Rx)
      @(posedge r_Clock);
      UART_WRITE_BYTE(8'h3F);
      @(posedge r_Clock);

      // Check that the correct command was received
      if (w_Rx_Byte == 8'h3F) begin
        $display("Test Passed - Correct Byte Received");
      end
      else begin
        $display("Test Failed - Incorrect Byte Received");
      end

      #1000
      $finish;
    end

endmodule
