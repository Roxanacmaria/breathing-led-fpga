# Simulation with Icarus Verilog (iverilog >= 11). View waveforms with GTKWave.
RTL   := $(wildcard rtl/*.sv)
BUILD := build

.PHONY: all sim_fsm sim_top sim_fast clean
all: sim_fsm sim_top sim_fast

$(BUILD):
	mkdir -p $(BUILD)

sim_fsm: | $(BUILD)
	iverilog -g2012 -o $(BUILD)/tb_SignalToggleFsm $(RTL) tb/tb_SignalToggleFsm.sv
	cd $(BUILD) && vvp -n tb_SignalToggleFsm | grep -v "\$$stop"

sim_top: | $(BUILD)
	iverilog -g2012 -o $(BUILD)/tb_Top $(RTL) tb/tb_Top.sv
	cd $(BUILD) && vvp -n tb_Top | grep -v "\$$stop"

sim_fast: | $(BUILD)
	iverilog -g2012 -o $(BUILD)/tb_Top_fast $(RTL) tb/tb_Top_fast.sv
	cd $(BUILD) && vvp -n tb_Top_fast | grep -v "\$$stop"

clean:
	rm -rf $(BUILD)
