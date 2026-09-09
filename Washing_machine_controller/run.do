```tcl
# Create work library
vlib work

# Compile RTL
vlog washer.v

# Compile Testbench
vlog washer_tb.v

# Start simulation
vsim work.washer_tb

# Add signals to waveform
add wave -divider "Inputs"
add wave sim:/washer_tb/clk
add wave sim:/washer_tb/rst
add wave sim:/washer_tb/coin
add wave sim:/washer_tb/wet
add wave sim:/washer_tb/soap

add wave -divider "FSM"
add wave sim:/washer_tb/m1/cst
add wave sim:/washer_tb/m1/nst

add wave -divider "Outputs"
add wave sim:/washer_tb/Timerbegin
add wave sim:/washer_tb/Fillwater
add wave sim:/washer_tb/Refill
add wave sim:/washer_tb/Drain
add wave sim:/washer_tb/timer_counter

# Run simulation
run 1000ns
```

