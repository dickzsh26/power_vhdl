module hello(input clk,input rst_n);
// outports wire
wire   	clk;
wire   	rst_n;

// outports wire
wire   	reset_pwm;

ton u_ton(
	.clk       	( clk        ),
	.rst_n     	( rst_n      ),
	.set       	( set        ),
	.reset_pwm 	( reset_pwm  )
);

endmodule