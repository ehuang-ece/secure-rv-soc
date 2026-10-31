# Decision log

Significant decisions only: hard to undo, or trading one design rule against
another. Each records the tension, the options, the choice and the reason.
Fill in Outcome later and compare it with what was expected.

## D-001: Synchronous reset on all flops except the synchronizer

- **When:** Week 1, Day 1
- **Tension:** robustness (async reset works without a clock) vs. fabric fit (Xilinx recommends synchronous reset)
- **Options:** (a) async reset everywhere; (b) sync everywhere except the reset synchronizer
- **Choice:** (b)
- **Driving constraint:** Xilinx UG949 guidance; Day 4 formal setup assumes it
- **Design rules:** #1 work with the fabric, #5 safe reset
- **Outcome:** ___

## D-002: Build Verilator from source, pinned to v5.052

- **When:** Week 1, Day 1
- **Tension:** setup time vs. a version that works and matches CI
- **Options:** (a) apt package (5.032); (b) build a pinned tag from source
- **Choice:** (b), v5.052
- **Driving constraint:** cocotb 2.x needs Verilator >= 5.036; CI runs a different Ubuntu, so only a shared build script keeps both identical
- **Cost:** one 19-line script; about 6 min build on 24 cores
- **Design rules:** #6 shared reference
- **Outcome:** ___

## D-003: Python 3.12 venv managed by uv, exact versions locked

- **When:** Week 1, Day 1
- **Tension:** using what the OS ships (3.14.4) vs. matching CI
- **Options:** (a) system Python; (b) uv-managed 3.12 venv with requirements.txt locked
- **Choice:** (b), Python 3.12.16, 14 packages pinned
- **Driving constraint:** CI uses 3.12; unpinned packages drift between machines
- **Design rules:** #6 shared reference, #13 prove it
- **Outcome:** ___

## D-004: RV32IM, no compressed instructions

- **When:** Week 1, Day 1
- **Tension:** smaller programs vs. a simpler decoder and no sim-passes-board-fails risk
- **Options:** (a) rv32imc; (b) rv32im
- **Choice:** (b), compiled as -march=rv32im_zicsr -mabi=ilp32
- **Evidence:** same t.S was 16 bytes at rv32im, 12 bytes at rv32imc (li and j shrank to 2 bytes); rv32im/ilp32 libgcc present, so linking adds no compressed code
- **Driving constraint:** expensive to change after the decoder exists
- **Design rules:** #1 work with the fabric, #4 match precision
- **Outcome:** ___

## D-005: Target board Arty A7-100T (xc7a100tcsg324-1)

- **When:** Week 1, Day 1
- **Tension:** none to resolve; recorded because every timing and utilization number depends on it
- **Facts:** 63,400 LUTs, 135 BRAM36, 240 DSPs; speed grade -1 from the Digilent reference manual (chip marking covered by a sticker)
- **Consequence:** room through v1.5; no 70% utilization risk as there would be on a 35T. The plan's "-1L" note applies only to the 35T.
- **Design rules:** #1 respect the fabric, #10 controlled density
- **Outcome:** ___

## D-006: Stay on Ubuntu 26.04 LTS; upgrade only to the next LTS

- **When:** Week 1, Day 1
- **Tension:** newest packages vs. a stable toolchain for the whole project
- **Options:** (a) follow interim releases (26.10, 9 months support); (b) LTS to LTS only
- **Choice:** (b); upgrade procedure in the Day 1 guide appendix
- **Design rules:** #5 robustness, #14 lifecycle
- **Outcome:** ___

## D-007: Dedicated portfolio GitHub account with a private commit email

- **When:** Week 1, Day 1 (setup)
- **Tension:** convenience vs. keeping a personal inbox out of public history
- **Choice:** account ehuang-ece; commits use the GitHub noreply address; pushes that would expose the email are blocked
- **Design rules:** #12 security from day one
- **Outcome:** ___

## D-008: SSH (ed25519) instead of HTTPS; one key per machine, no passphrase

- **When:** Week 1, Day 1 (setup)
- **Tension:** security vs. convenience on a home PC
- **Choice:** ed25519 key generated in WSL, never copied; no passphrase, acceptable on a home PC (revoke at github.com/settings/keys if the PC is lost)
- **Design rules:** #12 security
- **Outcome:** ___

## D-009: Repository public from day one

- **When:** Week 1, Day 1 (setup)
- **Tension:** visible progress for applications vs. showing unfinished work
- **Choice:** public; nothing secret is ever committed
- **Design rules:** #13 honest about what is proven
- **Outcome:** ___

## D-010: Keep cocotbext-axi and cocotb-coverage now rather than defer

- **When:** Week 1, Day 1
- **Tension:** build only what is needed (#9) vs. avoiding a version surprise in Week 4 and Week 7
- **Options:** (a) defer both until needed; (b) install and lock now
- **Choice:** (b), because both import cleanly under cocotb 2.1.0 today, so they cost nothing; had either failed, it would have been deferred with the reason here
- **Design rules:** #9 build what you need, #13 prove it
- **Outcome:** ___
