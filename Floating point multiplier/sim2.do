quit -sim
vlog -work work -stats=none {D:/CMP/third_Year/first_Semester/VLSI/project2/Multipliers-Mania/Floating point multiplier/FloatingPointMultiplier.v}
vlog -work work -stats=none {D:/CMP/third_Year/first_Semester/VLSI/project2/Multipliers-Mania/Floating point multiplier/FPM_tb.v}
vsim work.FPM_tb

add wave -position insertpoint  \
sim:/FPM_tb/a \
sim:/FPM_tb/b \
sim:/FPM_tb/expected \
sim:/FPM_tb/overflow \
sim:/FPM_tb/product \
sim:/FPM_tb/test_no
add wave -position insertpoint  \
sim:/FPM_tb/FPM/inf
add wave -position insertpoint  \
sim:/FPM_tb/FPM/zf
add wave -position insertpoint  \
sim:/FPM_tb/FPM/nan

run
run