# run.do — hw2 glitch demonstration
# Compatible with ModelSim / QuestaSim
# White background, all inputs + outputs + real (ideal) versions

# ── Compile ──────────────────────────────────────────────────────────────────
vlog hw2.sv
vlog hw2_tb.sv

# ── Optimize & elaborate ─────────────────────────────────────────────────────
vopt work.hw2_tb -o hw2_tb_opt +acc
vsim hw2_tb_opt

# ── White background ─────────────────────────────────────────────────────────
view wave
configure wave -background        white
configure wave -foreground        black
configure wave -gridcolor         #cccccc
configure wave -cursorcolor       red
configure wave -signalnamewidth   120
configure wave -timelineunits     ns
configure wave -namecolwidth      150
configure wave -valuecolwidth     80
configure wave -waveselectenable  1

# ── Divider: Inputs ──────────────────────────────────────────────────────────
add wave -divider "── INPUTS ──────────────────────────────"
add wave -color blue  -logic -label "a"  sim:/hw2_tb/a
add wave -color blue  -logic -label "b"  sim:/hw2_tb/b
add wave -color blue  -logic -label "c"  sim:/hw2_tb/c
add wave -color blue  -logic -label "d"  sim:/hw2_tb/d

# ── Divider: DUT outputs (with propagation delay) ────────────────────────────
add wave -divider "── DUT OUTPUTS (with #1 gate delay) ────"
add wave -color red         -logic -label "o1  (delayed)"  sim:/hw2_tb/o1
add wave -color darkorange  -logic -label "o2  (delayed)"  sim:/hw2_tb/o2
add wave -color darkred     -logic -label "f   (delayed)"  sim:/hw2_tb/f

# ── Divider: Ideal / real outputs (zero delay) ───────────────────────────────
add wave -divider "── IDEAL OUTPUTS (zero delay, no glitch)"
add wave -color darkgreen   -logic -label "o1_real"  sim:/hw2_tb/o1_real
add wave -color green       -logic -label "o2_real"  sim:/hw2_tb/o2_real
add wave -color limegreen   -logic -label "f_real"   sim:/hw2_tb/f_real

# ── Run ──────────────────────────────────────────────────────────────────────
run -all

# ── Fit waveforms to window ───────────────────────────────────────────────────
wave zoom full

