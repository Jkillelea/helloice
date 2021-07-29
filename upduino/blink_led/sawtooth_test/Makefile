# On Linux, copy the included upduinov3.rules to /etc/udev/rules.d/ so that we don't have
# to use sudo to flash the bit file.

MAIN := sawtooth
CORE_SOURCE := $(MAIN).v
SIM_SOURCE  := gtkwave.v

.PHONY: all
all: gtkwave

gtkwave: test.vcd
	gtkwave $<

test.vcd: design
	vvp $<

design: $(SIM_SOURCE) $(CORE_SOURCE)
	iverilog -o $@ $^

.PHONY: clean
clean:
	$(RM) -f design
	$(RM) -f test.vcd

