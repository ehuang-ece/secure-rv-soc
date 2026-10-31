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
