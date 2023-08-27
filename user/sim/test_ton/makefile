##
# test_counter
#
# @file
# @version 0.1

TARGET = wave
SRC_FILES = testbench.v
OBJ = $(TARGET).vvp
all: comp run wave
vcd: comp run
comp : $(SRC_FILES)
	@echo Compiling $(SRC_FILES)
	iverilog -o $(TARGET).vvp $(SRC_FILES)

run : $(TARGET).vvp
	@echo Running simulation
	vvp $(TARGET).vvp

wave: $(TARGET).vcd
	@echo Open waveform
	gtkwave $(TARGET).vcd

wave2: $(TARGET).vcd
	@echo Open an exist waveform
	gtkwave $(TARGET).gtkw

clean:
	del -f *.vcd *.vvp
# end
