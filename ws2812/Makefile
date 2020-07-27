SOURCES = top.v pll.v bitcontroller.v
PCF = icestick.pcf
DEV = 1k # HX-1k
ICETIME_DEV = hx1k # HX-1k also, just takes a different string...

MAIN = top

# Hardware
.PHONY: upload
upload: $(MAIN).bin
	iceprog $^

%.bin: %.asc
	$(MAKE) time
	icepack $^ $@

%.asc: %.blif
	arachne-pnr -d $(DEV) -p $(PCF) $^ -o $@

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

.PHONY: time
time: $(MAIN).asc
	icetime -d $(ICETIME_DEV) $^

.PHONY: clean
clean:
	rm -f top.asc
	rm -f top.txt
	rm -f *.blif
	rm -f *.bin
	rm -f design
	rm -f *.vcd

