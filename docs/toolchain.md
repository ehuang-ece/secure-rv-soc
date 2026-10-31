# Toolchain

Everything here is pinned. CI must use the same versions.

| Tool | Version / tag | Install | Verified by |
|---|---|---|---|
| OS | Ubuntu 26.04 LTS | WSL 2 (wsl.exe -l -v) | lsb_release -a |
| Host GCC | 15.2.0 | apt (Ubuntu default) | gcc --version |
| Verilator | v5.052 (2026-09-05) | scripts/build_verilator.sh | --version; lint clean |
| Python | pending (Step 4) | uv venv at .venv | python --version |
| cocotb | pending (Step 4) | requirements.txt | smoke pass + fail test |
| cocotbext-axi | pending (Step 4) | requirements.txt | import check |
| cocotb-coverage | pending (Step 4) | requirements.txt | import check |
| RISC-V GCC | pending (Step 6) | ~/opt/riscv symlink | t.S + t.c checks |
| rv32im multilib | pending (Step 6) | — | -print-libgcc-file-name |
| Vivado | 2026.1 (exact) | Windows / WSL | vivado -version |

## Notes

- Smoke test fails on a deliberately broken counter: pending (Step 5)
- apt Verilator on 26.04 is 5.032 (< 5.036 needed by cocotb 2.x): built from source
- Verilator v5.052 builds cleanly with GCC 15.2.0; about 6 min on 24 cores
- System Python 3.14.4 is not used; project venv is 3.12
- Host: 24 cores, 31 GB RAM available to WSL
