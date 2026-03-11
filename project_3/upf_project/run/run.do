
vlib work
vmap work work

vlog -sv \
    ../rtl/block.sv \
    ../rtl/top.sv \
    ../tb/tb_top.sv
	
vopt -work work  +acc -pa_enable=highlight+debug tb_top -pa_upf ../upf/design.upf -pa_top \"/tb_top/dut\"  -pa_lib work -o testO

vsim -pa_debugdir padebug -pa work.testO -c -do

add wave -r *
run -all
