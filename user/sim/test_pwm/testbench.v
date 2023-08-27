`include "../../src/pwm_bridge.v"

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

//Instance 
// outports wire
wire   	reset_pwm;

reg protection = 0;

// outports wire
wire                 	pwm1A;
wire                 	pwm1B;
wire                 	pwm2A;
wire                 	pwm2B;

pwm_bridge #(.half_period(21'd500),.phase(0))
    u_pwm_bridge1(
	.pwmA       	( pwm1A        ),
	.pwmB       	( pwm1B        ),
	.clk        	( clk         ),
	.rst_n      	( rst_n       ),
	.protection 	( protection  ),
	.duty       	( 21'd100        )
);

pwm_bridge #(.half_period(21'd500),.phase(500))
    u_pwm_bridge2(
	.pwmA       	( pwm2A        ),
	.pwmB       	( pwm2B        ),
	.clk        	( clk         ),
	.rst_n      	( rst_n       ),
	.protection 	( protection  ),
	.duty       	( 21'd100        )
);

initial begin            
    $dumpfile("wave.vcd");        
    $dumpvars(0, testbench);    
    #500000 $finish;
end

endmodule  //TOP


