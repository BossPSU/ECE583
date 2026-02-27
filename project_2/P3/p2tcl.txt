set target_library /u/dboss/Documents/ECE583/project_2/P3/osu05_stdcells.db
set link_library /u/dboss/Documents/ECE583/project_2/P3/osu05_stdcells.db
read_sverilog p3.sv
current_design p3
link
check_design
compile
report_power
report_cell
report_area
write -format verilog -hierarchy -output p3_netlist.sv
