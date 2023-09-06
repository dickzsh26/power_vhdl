`include "../../src/step.v"

module testbench();

parameter MAIN_FRE   = 100; //unit MHz
reg                   clk = 0;
reg                   rst_n = 0;

reg set = 0;

always begin
    #(500/MAIN_FRE) clk = ~clk;
end

always begin
    #50 rst_n = 1;
end

// outports wire
wire [20:0] 	out;

step_val u_step_val(
	.clk   	( clk    ),
	.rst_n 	( rst_n  ),
	.out   	( out    )
);

initial begin            
    $dumpfile("wave.vcd");        
    $dumpvars(0, testbench);    
    #5000 $finish;
end

endmodule  //TOP


