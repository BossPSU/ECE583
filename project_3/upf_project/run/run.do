# =====================================================================
# run.do  –  QuestaSim / ModelSim Power-Aware simulation script
# Usage:  vsim -c -do sim/run.do
# =====================================================================

# -- Create and map the work library ----------------------------------
vlib work
vmap work work

# -- Compile RTL and testbench ----------------------------------------
vlog -sv -work work \
    ../rtl/block.sv  \
    ../rtl/top.sv    \
    ../tb/tb_top.sv

# -- Optimise with Power-Aware (PA) support ---------------------------
#    -pa_upf     : points to the UPF file
#    -pa_top     : full hierarchical path to the DUT inside the TB
#    +acc        : full visibility for waveform capture
#    -pa_enable  : enable highlight+debug for PA annotation
vopt -work work \
     +acc \
     -pa_enable=highlight+debug \
     tb_top \
     -pa_upf  ../upf/design.upf \
     -pa_top  "/tb_top/dut"    \
     -pa_lib  work             \
     -o       testO

# -- Launch simulation ------------------------------------------------
vsim -pa_debugdir padebug \
     -pa work.testO \
     -c \
     -do "
         # Save waveforms to VCD for reference
         vcd file sim_out.vcd
         vcd add -r /tb_top/*

         # Add all signals to wave window (GUI run)
         add wave -divider {TB Controls}
         add wave /tb_top/clk
         add wave /tb_top/rst_n
         add wave /tb_top/pwr_en
         add wave /tb_top/iso_ctrl
         add wave /tb_top/save_ctrl
         add wave /tb_top/restore_ctrl
         add wave -divider {DUT Output}
         add wave /tb_top/out
         add wave -divider {Internal}
         add wave /tb_top/dut/d_block
         add wave /tb_top/dut/u_block/d

         run -all

         vcd flush
         
     "

