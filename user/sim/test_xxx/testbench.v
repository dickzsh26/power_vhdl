`include "../../src/ton.v"

module testbench();

parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 32;
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
always begin
    #100 set = 1;
    #110 set = 0;
    #200 set = 1;
    #210 set = 0;
    #2000 set = 1;
end

//Instance 
// outports wire
wire   	reset_pwm;

ton u_ton(
	.clk       	( clk        ),
	.rst_n     	( rst_n      ),
	.set       	( set        ),
    .ton_time   ( 21'd400    ),
	.reset_pwm 	( reset_pwm  )
);



initial begin            
    $dumpfile("wave.vcd");        
    $dumpvars(0, testbench);    
    #50000 $finish;
end

endmodule  //TOP


