# On Linux, copy the included upduinov3.rules to /etc/udev/rules.d/ so that we don't have
# to use sudo to flash the bit file.

CORE_SOURCE := rgb_blink.v
BSP_SOURCE  := upduino.v
SIM_SOURCE  := gtkwave.v

rgb_blink.bin: rgb_blink.asc
	icepack rgb_blink.asc rgb_blink.bin

rgb_blink.asc: rgb_blink.blif ../upduino.pcf
	arachne-pnr -d 5k --package sg48 -p ../upduino.pcf rgb_blink.blif -o rgb_blink.asc   # run place and route

rgb_blink.blif: $(CORE_SOURCE) $(BSP_SOURCE)
	yosys -q -p "synth_ice40 -blif rgb_blink.blif" $^

gtkwave: test.vcd
	gtkwave $<

test.vcd: design
	vvp $<

design: $(SIM_SOURCE) $(CORE_SOURCE)
	iverilog -o $@ $^

.PHONY: flash
flash: rgb_blink.bin
	iceprog -d i:0x0403:0x6014 rgb_blink.bin

.PHONY: clean
clean:
	$(RM) -f rgb_blink.blif rgb_blink.asc rgb_blink.bin
	$(RM) -f design
	$(RM) -f test.vcd

