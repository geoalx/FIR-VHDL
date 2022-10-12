# Debayering Filter With VHDL

[![build with Vivado](https://img.shields.io/badge/built%20with-Vivado-green)](https://www.xilinx.com/products/design-tools/vivado.html) 

This project is a part of a course "VLSI Digital Systems" of National Technical University of Athens. The grade of this project was 10/10.

## Abstract

The concept of this project is to design different implementations of the same FIR filter (more about FIR filters [here](https://en.wikipedia.org/wiki/Finite_impulse_response)) using VHDL for the Xilinx [Zynq 7000](https://www.xilinx.com/products/silicon-devices/soc/zynq-7000.html) Soc and compatible with [Zybo Z7](https://digilent.com/reference/programmable-logic/zybo-z7/start) development board. The FIR filter is build with 8 bit numbers and with 8 coefficients. The system has an input of 8 bits and aoutput of 19 bits.

## Component Based Implementation

The goal of this implementation is to build the FIR filter according the below diagram

![Component FIR](/Component_FIR.png)

The above show modules are:

1. ***MAC - Multiplier Accumulator Unit (MAC): calculates the output***
The output of filter y, by performing the following operation:
a <- a + b x c
It takes as input the constant coefficients of the filter (rom_out), the values of the input signal
(ram_out), and an initialization signal (mac_init) indicating the initialization of
accumulation before calculating each new value of y.
Implement this module to be done in behavioral description and using the '+' and '*' operators
supported by the std_logic_unsigned library.
2. ***ROM***: have the fixed coefficients of the filter h stored.
It takes as input an address (rom_address) and gives as output the corresponding coefficient which is
stored in it (rom_out).
The implementation of this module (initialized with the coefficients) is provided to you ready-made and should
integrate it appropriately into the overall filter architecture.
3. ***RAM***: stores the present value of the input signal x, as well as the 7 previous ones, which are
necessary to calculate the output y according to equation (1).
It takes as input an address (ram_address) and gives as output the corresponding value of the signal
input signal stored in it (ram_out).
During the write operation, the new value of the input signal x is written to the first
position of the memory and the 8 values already stored are shifted by one position, resulting in the oldest one is temporally erased.
4. ***Control Unit***: is the unit that controls and determines the operation of the filter:
   - Generates the MAC initialization signal (mac_init).
   - Addresses simultaneously the ROM and RAM memories for the read operation of the respective
values via the rom_address and ram_address signals respectively. In each clock cycle it gives
the next address of the memories to be read.

This implementation takes a number x as input and produces y as output every 8 clock cycles.

The codes for this implementation are located in the ```Component_FIR``` folder.

## Direct Filter Implementation

The direct implementation of the FIR filter is shown below.

![Direct FIR](/Direct_FIR.png)

This implementation takes an input x and after some first setup clock cycles (8 in our case) it produces an output y every clock cycle.

The codes for this implementation are located in the ```Direct_FIR``` folder.

## Parallel FIR filter.

In this implementation we should use 2 FIR filters in parallel and after an initial number of clock cycles (9 in our case) it produces 2 output with 2 inputs every clock cycle.

A 2 parallel FIR visualisation can be shown below.

![Parallel FIR](/Parallel_FIR.png)

The codes for this implementation are located in the ```Parallel_FIR``` folder.

---
All testbenches were build for simulating these projects on Vivado simulator.