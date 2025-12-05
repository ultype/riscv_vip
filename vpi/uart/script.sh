iverilog-vpi uart_vpi.c -o uart.vpi
iverilog -o uart_sim uart_tb.v
vvp -M. -muart_vpi uart_sim
