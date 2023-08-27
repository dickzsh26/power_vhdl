///////////////////////////////
// PWM 互补信号发生模块
// 作者： Felix Qi
// 输入：
// protection：  当protection为1时，pwmA和pwmB输出同时拉低
// duty:         占空比
// 输出：
// pwmA pwmB： 输出PWM信号
// 其他配置，比如init_direction、deadtime、phase、half_period之类的通过parameter进行配置
///////////////////////////////

module pwm_bridge(
    output reg pwmA,
    output reg pwmB,
    input clk,rst_n,
    input protection,
    input [bit_width-1:0]duty
); 

reg[bit_width-1:0] counter;//actually 11�
reg counter_direction;//

parameter init_direction = 0;
parameter bit_width = 21;
parameter phase = 200;
parameter half_period = 200;
parameter deadtime = 10;


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)//
        begin
            pwmA<=1'b0;                    //
            pwmB<=1'b0;                    //
            counter <= phase;
            counter_direction <= init_direction;
        end
    else
    begin
        begin
            if(counter>=half_period-1'd1) counter_direction<=1'd1;//,
            if(counter<=1'd1) counter_direction<=1'd0;//,
            if(!counter_direction) counter<=counter+1'd1;//1 
            else counter<=counter-1'd1;//1
        end

        begin
            if(counter>duty-deadtime) pwmA<=1'b0;//A
            else pwmA<=protection?1'b0:1'b1;//A
            if(counter>=duty+deadtime) pwmB<=protection?1'b0:1'b1;//B
            else pwmB<=1'b0;//B
        end
        begin
            if(duty)
        end

    end
end
endmodule