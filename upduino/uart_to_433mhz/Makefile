# On Linux, copy the included upduinov3.rules to /etc/udev/rules.d/ so that we don't have
# to use sudo to flash the bit file.

CORE_SOURCE := uart_to_433mhz.v
BSP_SOURCE  := upduino.v
SIM_SOURCE  := gtkwave.v

uart_to_433mhz.bin: uart_to_433mhz.asc
	icepack uart_to_433mhz.asc uart_to_433mhz.bin

uart_to_433mhz.asc: uart_to_433mhz.blif ../upduino.pcf
	arachne-pnr -d 5k --package sg48 -p ../upduino.pcf uart_to_433mhz.blif -o uart_to_433mhz.asc   # run place and route

uart_to_433mhz.blif: $(CORE_SOURCE) $(BSP_SOURCE)
	yosys -q -p "synth_ice40 -blif uart_to_433mhz.blif" $^

gtkwave: test.vcd
	gtkwave $<

test.vcd: design
	vvp $<

design: $(SIM_SOURCE) $(CORE_SOURCE)
	iverilog -o $@ $^

.PHONY: time
time: uart_to_433mhz.asc
	icetime -d up5k -c 12 -mtr $@.rpt $^


.PHONY: flash
flash: uart_to_433mhz.bin
	iceprog -d i:0x0403:0x6014 uart_to_433mhz.bin

.PHONY: clean
clean:
	$(RM) -f uart_to_433mhz.blif uart_to_433mhz.asc uart_to_433mhz.bin
	$(RM) -f design
	$(RM) -f test.vcd
	$(RM) -f time.rpt

