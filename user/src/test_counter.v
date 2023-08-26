`timescale 1ns/1ps
module test_counter ();

    localparam TEST_WIDTH = 6;
    localparam TEST_MAX   = 9;
    localparam CLK_PERIOD = 10;

    reg clk = 1'b1; // 时钟

    wire [TEST_WIDTH-1:0] cnt;

    counter #( // 参数例化
        .CNT_WIDTH (TEST_WIDTH),
        .CNT_INIT  (3),
        .CNT_MAX   (TEST_MAX)
    ) uut ( // 端口例化
        .clk       (clk),
        .cnt       (cnt)
    );

    always #(CLK_PERIOD/2) clk = ~clk; // 50MHz

    always @ (posedge clk) begin
        $display("time : %8t , counter = %d", $time, cnt);
        if (cnt == TEST_MAX)
            $display("time : %8t , counter overflow", $time);
        else if (cnt == 0)
            $display("hello world");
    end
    initial begin
        $dumpfile("test_counter.vcd");
        $dumpvars(0, test_counter); // dump所有信号波形
    end 

    initial begin // 第3次计数值为2后退出仿真
        repeat(3) begin
            wait (cnt == 2);
            #(CLK_PERIOD);
        end

        $finish;
    end

endmodule

module counter #( // 参数
    parameter CNT_WIDTH = 8,
    parameter CNT_INIT = 0,
    parameter CNT_MAX = 11
) ( // 端口
    input clk,
    output reg [CNT_WIDTH-1:0] cnt
);

    initial cnt = CNT_INIT;

    always @ (posedge clk)
        if(cnt < CNT_MAX)
            cnt <= cnt + 1;
        else
            cnt <= 0;

endmodule
