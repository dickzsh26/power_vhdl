`include "../../src/pid.v"

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
wire [25:0] 	pi_out;
wire [25:0] 	target = 26'd300;
reg [11:0]		sample = 26'd290;
reg adc_complete = 0;

always begin
	#10 	adc_complete = 0;
	#100 	adc_complete = 1;
	#10 	adc_complete = 0;
	#100	adc_complete = 1;
end
PID #(
	.kp(26'd100),
	.ki(26'd100),
	.maximum_out(26'd1000),
	.minimum_out(26'd0),
	.maximum_add(26'd100),
	.minimum_add(26'd10)
)
u_pid(
	.clk          	( clk           ),
	.rst_n        	( rst_n         ),
	.adc_complete 	( adc_complete  ),
	.sample       	( sample        ),
	.target       	( target        ),
	.pi_out       	( pi_out        )
);

initial begin            
    $dumpfile("wave.vcd");        
    $dumpvars(0, testbench);    
    #5000 $finish;
end

endmodule  //TOP


