transcript on

# Create work library
if {[file exists work]} {
    vdel -lib work -all
}

vlib work
vmap work work

# Compile DUT
vlog ../Washer.v

# Compile interface
vlog Interface.sv

# Compile assertions
vlog Assertion.sv

# Compile UVM package
vlog washer_pkg.sv

# Compile top
vlog Top.sv

# Start simulation
vsim -voptargs=+acc Top

# Add useful signals
add wave -divider "DUT / Interface"

add wave sim:/Top/clk
add wave sim:/Top/vif/rst
add wave sim:/Top/vif/coin
add wave sim:/Top/vif/wet
add wave sim:/Top/vif/soap

add wave sim:/Top/vif/timerbegin
add wave sim:/Top/vif/fillwater
add wave sim:/Top/vif/refill
add wave sim:/Top/vif/drain
add wave sim:/Top/vif/timercounter

# Run simulation
run -all
