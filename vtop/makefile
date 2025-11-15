# Set a variable for your RTL source files
export CORE_DIR=../core/riscv
export AXI_DIR=../ip/axi
export CACHE_DIR=../top_cache_axi/src_v
export WRAPPER_DIR=../top_tcm_wrapper
export TB_DIR=./

all: build

build:
	@echo "Building the project..."
	iverilog -g2012 -s soc_tb -o my_sim -f project.f
run:
	@echo "Running the simulation..."
	vvp my_sim 
