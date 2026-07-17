# FPGA UART TX/RX

UART built with VHDL and tested via loopback with a USB-UART adapter and PuTTY

## Overview
Two buttons increase/decrease LED brightness via PWM duty cycle control. Built from five modules, clock division, debouncing, duty cycle, PWM generation, and the top level wiring.

## Architecture
'uart_rx.vhdl' - Synchronizes the incoming rx line, samples at mid bit, and shifts in a byte.
'uart_tx.vhdl' - Takes a byte and a start tick and shifts it out LSB first.
'uart_echo_top.vhdl' - Wires the RX output into the TX input so every recieved byte is immediately transmitted.


## Other notes
CLKS_PER_BIT defaults at 1085 which at a clk of 125MHz roughly gives a baud of 115200. 

## Tools
Vivado, Zybo Z7-10, PuTTY, CP2102 USB-to-UART
