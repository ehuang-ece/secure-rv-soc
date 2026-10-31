# Architecture

## Target board

- Board: Digilent Arty A7-100T (silkscreen: "ARTY A7"; box: "ARTY A7")
- FPGA label as printed: "ARTIX-7 100T CSG324" (Digilent sticker covers the die marking)
- Vivado part: xc7a100tcsg324-1
- Speed grade: -1, from the Digilent Arty A7 reference manual (not read off the chip)
- Resources: 63,400 LUTs, 135 BRAM36, 240 DSPs
- Clock: 100 MHz on-board oscillator
- Consequence: plenty of room through v1.5 (NTT, pipeline, masking)
