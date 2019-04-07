gtkwave: test.vcd
	gtkwave $<

test.vcd: design
	vvp $<

design: test.v uart_tx.v uart_rx.v uart_tx2.v
	iverilog -o $@ $^
