// 时钟模块，默认工作在1GHz的频率

`timescale 1ps/1fs

module master_clock(output reg clk,output reg rst_n);

    parameter half_period = 500;
    parameter delay = 10;
    integer first;

    initial begin
	// Start the clock output to be logic 0 at t=0
	clk = 0;
	first = 1;
	rst_n = 1;
//	$simplis_vpi_probe( clk );
    end

    always begin
	if ( first == 1 ) begin
	    // Change the clock output to be logic 1 at t=delay
	    #(delay) clk = ~clk;
	    first = 0;
		#(delay)rst_n = 0;
	end
	else begin
	    // After t=delay, toggle the clock output once for
	    //   every half period
		#(delay)rst_n = 1;
	    #(half_period) clk=~clk;
	end
    end

endmodule
