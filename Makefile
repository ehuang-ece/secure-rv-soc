# Top-level shortcuts. CI runs these same targets, so the laptop and CI
# always run identical commands. Recipe lines start with ">" instead of a
# Tab, so copying this file can't break it.
.RECIPEPREFIX := >
.PHONY: help lint smoke asic-synth ci

help:
> @echo "make lint           Verilator lint (-Wall) on the smoke counter"
> @echo "make smoke          cocotb smoke test (pass/fail decided by cocotb)"
> @echo "make asic-synth     Yosys portability check on rtl/files.f"
> @echo "make ci             all three, in the order CI runs them"

lint:
> verilator --lint-only -Wall verif/cocotb/smoke/counter.sv

smoke:
> cd verif/cocotb/smoke && $(MAKE)

asic-synth:
> scripts/asic_synth_check.sh

ci: lint smoke asic-synth
