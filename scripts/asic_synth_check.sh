#!/usr/bin/env bash
# Portability alarm: can Yosys (the ASIC flow's front end) build our RTL
# with no Xilinx parts and no register starting values?
# Usage: scripts/asic_synth_check.sh [file.sv ...]   (default: rtl/files.f)
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

if [ "$#" -gt 0 ]; then
  FILES=("$@")
else
  FILES=()
  if [ -f rtl/files.f ]; then
    mapfile -t FILES < <(grep -Ev '^[[:space:]]*(#|$)' rtl/files.f || true)
  fi
fi
if [ "${#FILES[@]}" -eq 0 ]; then
  echo "rtl/files.f lists no RTL yet: checking the smoke counter so the tool itself is proven."
  FILES=(verif/cocotb/smoke/counter.sv)
fi

OUT=asic/runs/asic_synth_check
mkdir -p "$OUT"
yosys -q -l "$OUT/yosys.log" -p "
  read_verilog -sv ${FILES[*]};
  synth -auto-top;
  check -assert;
  select -assert-none a:init;
  tee -o $OUT/stat.txt stat"
echo "asic-synth-check: PASS (${#FILES[@]} file(s); cell counts in $OUT/stat.txt)"
