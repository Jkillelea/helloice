SOURCES = uart_mirror.v uart_tx2.v uart_rx.v ram.v
PCF = icestick.pcf
DEV = 1k # HX-1k

MAIN = top

# Hardware
.PHONY: upload
upload: $(MAIN).bin
	iceprog $^

%.bin: %.txt
	icepack $^ $@

%.txt: %.blif
	arachne-pnr -d $(DEV) -p $(PCF) $^ -o $@

%.blif: $(SOURCES)
	yosys -p "synth_ice40 -blif $@" $^

# Simulation
.PHONY: sim
sim: test.vcd

.PHONY: gtkwave
gtkwave: test.vcd
	gtkwave $<

test.vcd: design
	vvp $<

design: tb.v $(SOURCES)
	iverilog -o $@ $^

.PHONY: clean
clean:
	rm -f *.txt
	rm -f *.blif
	rm -f *.bin
	rm -f design
	rm -f *.vcd

