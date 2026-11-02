# Toolchain

Everything here is pinned. CI must use the same versions.

| Tool | Version / tag | Install | Verified by |
|---|---|---|---|
| OS | Ubuntu 26.04 LTS | WSL 2 (wsl.exe -l -v) | lsb_release -a |
| Host GCC | 15.2.0 | apt (Ubuntu default) | gcc --version |
| Verilator | v5.052 (2026-09-05) | scripts/build_verilator.sh | --version; lint clean |
| Yosys / SBY | OSS CAD Suite 2026-11-02 (Yosys 0.70+290) | ~/opt/oss-cad-suite (end of PATH) | asic-synth-check |
| CI runner | GitHub ubuntu-26.04 | .github/workflows/ci.yml | "Show tool versions" |
| Python | 3.12.16 (uv 0.13.6) | uv venv at .venv | python --version |
| cocotb | 2.1.0 | requirements.txt | smoke pass + fail test |
| cocotbext-axi | 0.1.28 | requirements.txt | import check |
| cocotb-coverage | 2.0 | requirements.txt | import check |
| RISC-V GCC | xPack 15.2.0-1 (GCC 15.2.0) | ~/opt/riscv symlink | t.S + t.c checks |
| rv32im multilib | present (rv32im/ilp32/libgcc.a) | — | -print-libgcc-file-name |
| Vivado | 2026.1 (exact) | Windows / WSL | vivado -version |

## Notes

- Smoke test fails on a deliberately broken counter: yes (count + 4'd2 failed at cycle 0: got 2, expected 1)
- apt Verilator on 26.04 is 5.032 (< 5.036 needed by cocotb 2.x): built from source
- Verilator v5.052 builds cleanly with GCC 15.2.0; about 6 min on 24 cores
- System Python 3.14.4 is not used; project venv is 3.12
- Host: 24 cores, 31 GB RAM available to WSL
- xPack 15.2.0-1 download verified: sha256sum -c printed OK
- t.S at -march=rv32im_zicsr: mul and csrr present; every instruction 4 bytes (addresses 0, 4, 8, c)
- Same t.S at rv32imc_zicsr shrinks li and j to 2 bytes: shows what the wrong -march would do
- t.c (a/b) at -O2 compiles to a real div instruction; no call __divsi3

## Notes (Day 2)
- CI pins VERILATOR_TAG and OSS_CAD_DATE in ci.yml env; they must match this file
- asic-synth-check fails on a BUFG and on an initial value: yes (Day 2, local)
- CI fails on a deliberately broken counter: pending (Step 6, branch ci-red-test)
- Verilator cache in CI: first build 4m 37s (Verilator itself 4m 3s), cached run 39s; cache re-run caught a missing ccache dependency (fixed in d826a55)
