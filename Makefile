ENTRY_MODULE	= entry
ENTRY_FILE		= src/entry.v
BUILD_DIR		= build
TOOLS_DIR		= tools

sources := $(wildcard src/*.v)

all: $(BUILD_DIR)/out.dfu $(BUILD_DIR)/out.bin

clean:
	rm -rf $(BUILD_DIR)

ifeq (, $(shell which yosys))
$(error Could not find tools, try running "source env.sh")
endif

$(BUILD_DIR)/out.dfu: $(BUILD_DIR)/out.bin
	cp $(BUILD_DIR)/out.asc $(BUILD_DIR)/out.dfu
	dfu-suffix -v 1209 -p 70b1 -a $(BUILD_DIR)/out.dfu

$(BUILD_DIR)/out.bin: $(BUILD_DIR)/out.asc
	icepack $(BUILD_DIR)/out.asc $(BUILD_DIR)/out.bin

$(BUILD_DIR)/out.asc: $(BUILD_DIR)/out.json
	nextpnr-ice40 --up5k --package uwg30 --json $(BUILD_DIR)/out.json --pcf fomu-pvt.pcf --asc $(BUILD_DIR)/out.asc

$(BUILD_DIR)/out.json: $(sources) $(BUILD_DIR)
	yosys -D PVT=1 -D PVT1=1 -p 'synth_ice40 -top $(ENTRY_MODULE) -json $(BUILD_DIR)/out.json' $(ENTRY_FILE)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)
