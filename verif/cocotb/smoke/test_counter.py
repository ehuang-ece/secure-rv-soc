import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, FallingEdge


@cocotb.test()
async def test_count_and_wrap(dut):
    """Reset holds 0; then count increments every cycle and wraps 15 -> 0."""
    Clock(dut.clk, 10, unit="ns").start()     # 100 MHz, matches the board
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 2)
    await FallingEdge(dut.clk)
    assert dut.count.value.to_unsigned() == 0, "count not 0 during reset"
    dut.rst_n.value = 1
    expected = 0
    for cycle in range(20):
        await FallingEdge(dut.clk)            # sample mid-cycle, values settled
        expected = (expected + 1) % 16
        got = dut.count.value.to_unsigned()
        assert got == expected, f"cycle {cycle}: got {got}, expected {expected}"
