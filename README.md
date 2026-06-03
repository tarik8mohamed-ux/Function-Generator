# Introduction
This project implements a Direct Digital Synthesis (DDS) sine wave generator in VHDL, designed to run on a Xilinx FPGA. DDS generates precise analog waveforms digitally. Instead of analog oscillator circuits, it uses a clock, a phase accumulator, and a lookup table to produce a sine wave at any desired frequency. On every clock tick the phase accumulator advances by a programmable tuning word, and the larger the tuning word the higher the output frequency. The output is an 8-bit digital value intended to drive a DAC.

<img width="2003" height="545" alt="DDS_Block_Diagram pdf and 1 more page - Personal 4 - Microsoft​ Edge 6_3_2026 3_39_56 AM" src="https://github.com/user-attachments/assets/80fffc9f-10bf-48a6-bbe2-1580c8e2b5f2" />

# Blocks
## Phase Accumulator
The phase accumulator is the heart of the DDS system and controls the output frequency. On every clock edge it adds the tuning word to a 16-bit register that wraps naturally from 65535 back to 0, creating a continuously incrementing phase ramp. The upper bits address the sine table and bit 15 flags which half of the sine cycle the system is in. The tuning word is 14 bits wide, limiting the maximum output to approximately 25 MHz on a 100 MHz clock to prevent aliasing.

## Sine Table
The sine table is a 128 entry read only lookup table storing a quarter period of a sine wave scaled to 7-bit values from 0 to 127. It takes a 7-bit address from the phase accumulator and instantly outputs the corresponding amplitude value as combinational logic with no clock. Only a quarter wave is stored — the phase accumulator handles mirroring to reconstruct the full waveform — which keeps the memory footprint small.

## Full Wave
The full wave module reconstructs a complete sine wave from the quarter-wave output and the half-cycle flag from the phase accumulator. During the positive half it produces values from 128 to 255, and during the negative half it subtracts the sine value from 128 to produce values from 128 down to 1. The result is an 8-bit offset binary sine wave centred around 128 which represents the zero crossing.

## Test Bench
The testbench is a simulation only file that drives the design with a synthetic clock, reset, enable, and tuning word. It instantiates all three modules wired together in the same chain as the final hardware. Multiple tuning word values can be sequenced in a single simulation run to observe the output frequency changing.

# Simulation
1. Create a new RTL project in Vivado
2. Add phase_accumulator, sine_table, and full_wave as Design Sources
3. Add testbench as a Simulation Source
4. Right-click testbench and select Set as Top
5. Click Run Simulation then Run Behavioral Simulation
6. Right-click dac_out in the waveform window, set Waveform Style to Analog and Radix to Unsigned Decimal

# Frequency Formula
tuning_word = (desired_frequency_Hz × 65536) / f_clk
