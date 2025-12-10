iverilog-vpi vpi_console.c -o vpi_console.vpi
iverilog -o console_sim console_tb.sv vpi_console.sv
vvp -M. -mvpi_console console_sim 
# scan available terminal
# socat -d -d pty,raw,echo=0 pty,raw,echo=0
