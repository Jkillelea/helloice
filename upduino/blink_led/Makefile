# On Linux, copy the included upduinov3.rules to /etc/udev/rules.d/ so that we don't have
# to use sudo to flash the bit file.

MAIN := rgb_blink
CORE_SOURCE := $(MAIN).v sawtooth.v pwm.v
BSP_SOURCE  := upduino.v
SIM_SOURCE  := gtkwave.v
PCF := ../upduino.pcf


$(MAIN).bin: $(MAIN).asc
	icepack $(MAIN).asc $(MAIN).bin

$(MAIN).asc: $(MAIN).blif $(PCF)
	arachne-pnr -d 5k --package sg48 -p $(PCF) $(MAIN).blif -o $(MAIN).asc   # run place and route

$(MAIN).blif: $(CORE_SOURCE) $(BSP_SOURCE)
	yosys -q -p "synth_ice40 -blif $(MAIN).blif" $^

gtkwave: test.fst
	gtkwave $<

test.vcd: design
	vvp $<

test.fst: design
	vcd2fst -v $@ -f $^

design: $(SIM_SOURCE) $(CORE_SOURCE)
	iverilog -o $@ $^

.PHONY: time
time: $(MAIN).asc
	icetime -P sg48 -d up5k $^

.PHONY: flash
flash: $(MAIN).bin
	iceprog -d i:0x0403:0x6014 $(MAIN).bin

.PHONY: clean
clean:
	$(RM) -f $(MAIN).blif $(MAIN).asc $(MAIN).bin
	$(RM) -f design
	$(RM) -f test.vcd
	$(RM) -f test.fst

