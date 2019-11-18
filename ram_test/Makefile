gtkwave: test.vcd
	gtkwave $<

test.vcd: design
	vvp $<

design: test.v ram.v uart_rx.v uart_tx2.v
	iverilog -o $@ $^

clean:
	rm -f design
	rm -f test.vcd
