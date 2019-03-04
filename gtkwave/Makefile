gtkwave: test.vcd
	gtkwave $<

test.vcd: design
	vvp $<

design: test.v counter.v pwm.v uart_rx.v
	iverilog -o $@ $^
