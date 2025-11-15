+incdir+$(CORE_DIR)
+incdir+$(AXI_DIR)
+incdir+$(CACHE_DIR)
+incdir+$(WRAPPER_DIR)
+incdir+$(TB_DIR)

#tb
soc_tb.sv

#top
soc_top.v

#cache
$(CACHE_DIR)/dcache_axi_axi.v
$(CACHE_DIR)/dcache_core.v
$(CACHE_DIR)/dcache.v
$(CACHE_DIR)/riscv_top.v
$(CACHE_DIR)/dcache_axi.v
$(CACHE_DIR)/dcache_if_pmem.v
$(CACHE_DIR)/icache_data_ram.v
$(CACHE_DIR)/dcache_core_data_ram.v
$(CACHE_DIR)/dcache_mux.v
$(CACHE_DIR)/icache_tag_ram.v
$(CACHE_DIR)/dcache_core_tag_ram.v
$(CACHE_DIR)/dcache_pmem_mux.v
$(CACHE_DIR)/icache.v

#wrapper
$(WRAPPER_DIR)/dport_axi.v  
$(WRAPPER_DIR)/riscv_tcm_wrapper.v  
$(WRAPPER_DIR)/tcm_mem_ram.v
$(WRAPPER_DIR)/dport_mux.v  
$(WRAPPER_DIR)/tcm_mem_pmem.v       
$(WRAPPER_DIR)/tcm_mem.v

#core
$(CORE_DIR)/riscv_alu.v
$(CORE_DIR)/riscv_decode.v
$(CORE_DIR)/riscv_issue.v
$(CORE_DIR)/riscv_regfile.v
$(CORE_DIR)/riscv_core.v         
$(CORE_DIR)/riscv_defs.v
$(CORE_DIR)/riscv_lsu.v
$(CORE_DIR)/riscv_trace_sim.v
$(CORE_DIR)/riscv_csr_regfile.v  
$(CORE_DIR)/riscv_divider.v  
$(CORE_DIR)/riscv_mmu.v         
$(CORE_DIR)/riscv_xilinx_2r1w.v
$(CORE_DIR)/riscv_csr.v          
$(CORE_DIR)/riscv_exec.v     
$(CORE_DIR)/riscv_multiplier.v
$(CORE_DIR)/riscv_decoder.v      
$(CORE_DIR)/riscv_fetch.v    
$(CORE_DIR)/riscv_pipe_ctrl.v

#axi
$(AXI_DIR)/axi_s2m2_interconnect.v 
$(AXI_DIR)/axi_interconnect.v
$(AXI_DIR)/arbiter.v
$(AXI_DIR)/axi_ram.v
$(AXI_DIR)/priority_encoder.v


