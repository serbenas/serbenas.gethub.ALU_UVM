vlib work 
vlog  -f list.list -mfcu
vsim -voptargs=+acc work.ALU_top -classdebug -uvmcontrol=all
add wave /ALU_top/ALU_if/*
coverage save ALU_top.ucdb -onexit
vcover report ALU_top.ucdb -details -all -annotate -output report.txt
run -all


