set target_library /u/dboss/Documents/ECE583/project_2/P2/osu05_stdcells.db
set link_library /u/dboss/Documents/ECE583/project_2/P2/osu05_stdcells.db
read_sverilog p2.sv
current_design p2
link
check_design
compile
report_power
report_cell
report_area
write -format verilog -hierarchy -output p2_netlist.sv
