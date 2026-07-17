## uart_echo_top.xdc
## Zybo Z7-10
## UART_RX/UART_TX are wired to Pmod JE pins 1 and 2 for an external
## USB-to-serial adapter.

## Clock signal (125 MHz onboard oscillator)
set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L12P_T1_MRCC_35 Sch=sysclk
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { clk }];

## Reset button (BTN0, active high)
set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports { btn_rst }]; #IO_L12N_T1_MRCC_35 Sch=btn[0]

## Pmod JE - pin 1 (UART_RX, from adapter TXD) and pin 2 (UART_TX, to adapter RXD)
## Adapter GND -> Pmod JE pin 5 (GND). Do not connect adapter VCC.
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { UART_RX }]; #IO_L4P_T0_34 Sch=je[1]
set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports { UART_TX }]; #IO_L18N_T2_34 Sch=je[2]
