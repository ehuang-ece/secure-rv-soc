# Conventions

Applies to every file from Day 2 on. Changes need a commit that says why.

## Files and names

- One module per file; file name = module name (`uart_tx.sv` holds `uart_tx`).
- Module prefixes: core_, axil_, uart_, gpio_, tmr_, aes_, gcm_ (top-level: soc_).
- Signals: lower_snake_case. Parameters/localparams: UPPER_SNAKE_CASE.
- Active-low signals end in `_n`. Registered copies end in `_q`, next-state in `_d`.
- Every RTL file starts with `` `default_nettype none `` and ends with
  `` `default_nettype wire `` (typos become errors, not implicit wires).
- Every RTL file is listed in rtl/files.f; nothing is compiled from a glob.

## Clock and reset

- Clock: `clk`. One domain in v1.0 (see docs/architecture.md).
- Reset: `rst_n`, active-low, asserted asynchronously at the synchronizer,
  released synchronously, held until MMCM `locked`.
- All flops except the reset synchronizer use synchronous reset:
  `always_ff @(posedge clk) if (!rst_n) ... else ...`
- Control and state registers are reset. Wide datapath registers may skip
  reset; each one is listed below with the reason.

### Datapath registers without reset

| Module | Register | Why it is safe |
|---|---|---|
| (none yet) | | |

## Coding rules

- `always_ff`: non-blocking (`<=`) only. `always_comb`: blocking (`=`) only.
- No `always @*`, no `reg`/`wire`; use `logic`.
- Every `case` has a `default`. FSM states are an `enum logic [N:0]`.
- No latches: every `always_comb` output is assigned on every path
  (assign a default at the top of the block).
- Widths explicit on constants used in arithmetic (`4'd1`, not `1`).

## SystemVerilog subset (provisional until the Day 4 Yosys parse check)

Allowed: logic, enum, localparam, packed arrays, always_ff/always_comb,
functions, generate.
Not allowed in ports: interfaces, structs, unpacked arrays.
Confirmed by: verif/formal/uart (Day 4) — update this line with the result.

## Verification

- Every random test logs its seed; failures must reproduce from the seed.
- Golden references come from NIST vectors or external libraries, never
  from a model derived from our own RTL.

## Decisions

- Significant decisions (hard to undo, or trading one design rule against
  another) go in docs/decisions.md with the tradeoff and the reason.

## Commits (Conventional Commits)

- Types: feat, fix, test, docs, ci, build, chore, refactor.
- One logical change per commit. Subject at most 72 characters, imperative mood.

## FPGA/ASIC portability

The same RTL must build for the Artix-7 FPGA and for SkyWater 130 nm.

1. FPGA-only parts (MMCM, clock buffers, ILA probes, pin setup) live only in `fpga/`, never in `rtl/`.
2. Every memory sits behind our own wrapper in `rtl/mem/` (e.g. `sp_ram.sv`), with an FPGA version (BRAM) and an ASIC version (flip-flops for now).
3. No register starting values: no `initial`, no `logic x = 0`. Reset is the only way a register gets a known value.
4. Reset asserts immediately and deasserts synchronously to the clock.
5. One clock. Pause a block with an enable, never with a clock made from logic. Real clock gating waits for v2.0.
6. The AES S-box is a plain `case` lookup table.
7. Yosys must read every file in `rtl/`; if it can't, convert the file with sv2v first.
8. CI job `asic-synth-check` runs Yosys on `rtl/` (no Xilinx files) on every push.
