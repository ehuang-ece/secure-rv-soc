# Secure RISC-V SoC

An RV32IM SoC on the Arty A7 that communicates securely: an AES-256-GCM
accelerator encrypts and authenticates every message at a target of
≤ 20 cycles per 16-byte block (v1.0), and an ML-KEM (FIPS 203) NTT
accelerator establishes the key (v1.5). The RTL is written to build for
both the Artix-7 FPGA and SkyWater 130 nm (open-source LibreLane flow).

**Status:** Week 1 — repo, flow and paper design. No core RTL yet.

## Where to look, by role

D = FPGA/digital design · V = design verification · B = validation/bring-up

| Folder | Role | Contents |
|---|---|---|
| `rtl/` | D | Synthesizable SystemVerilog: core, bus, memory wrappers, peripherals, AES-GCM |
| `fpga/` | D | Constraints and Vivado build script |
| `asic/` | D | LibreLane configs for the Sky130 flow |
| `reports/` | D | Timing, utilization, CDC and ASIC reports |
| `sw/` | D B | Startup code, linker script, drivers, self-test |
| `verif/` | V | Testplan, cocotb tests, arch tests, formal |
| `validation/` | B | Host regression and on-board measurements |
| `docs/` | D V B | Architecture, memory map, bring-up log, conventions, decisions |
| `scripts/` | all | Tool setup and helper scripts |

Design decisions and the tradeoffs behind them: [`docs/decisions.md`](docs/decisions.md)
