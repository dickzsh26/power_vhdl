////////////////////////////
// ramp模块
// 作者： Felix Qi
// 输入：
// clk:     时钟信号
// rst_n：  复位信号
// 输出：
// out：    输出信号
////////////////////////////
module ramp(clk,rst_n,out);
    input wire clk,rst_n;
    output reg[bit_width-1:0] out;

    parameter bit_width = 10;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)begin
            out <= 0;
        end
        else begin
            out <= out+1;
        end
    end
endmodule