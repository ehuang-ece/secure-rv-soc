SIM ?= verilator
TOPLEVEL_LANG ?= verilog
VERILOG_SOURCES += $(PWD)/counter.sv
# cocotb 2.x names (1.x used TOPLEVEL and MODULE)
COCOTB_TOPLEVEL = counter
COCOTB_TEST_MODULES = test_counter
# Waveforms: run `make WAVES=1` to get dump.fst
ifeq ($(WAVES),1)
EXTRA_ARGS += --trace-fst --trace-structs
endif
include $(shell cocotb-config --makefiles)/Makefile.sim
