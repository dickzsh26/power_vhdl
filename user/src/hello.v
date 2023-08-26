module hello(input clk,input rst_n);
// outports wire
wire   	clk;
wire   	rst_n;

hello u_hello(
	.clk   	( clk    ),
	.rst_n 	( rst_n  )
);

endmodule