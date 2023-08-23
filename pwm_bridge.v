//PWM
`timescale 1ps/1fs
module pwm_bridge(
output reg pwmA,
output reg pwmB,
input clk,rst_n,
input protection,
input [20:0]duty,
input[20:0] phase,
input[20:0] deadtime,
input[20:0] half_period,
input init_dir
); 

//parameter max_td=11'd1101;
initial begin
    count = 0;
    countdown = 0;
end

reg[20:0] count;//actually 11�
reg countdown;//

always@(posedge clk or negedge rst_n)
begin
  if(!rst_n)//
    begin
    pwmA<=1'b0;          //
    pwmB<=1'b0;          //
    end
  else                   //clk
  begin
    begin
    if(count>=half_period-1'd1) countdown<=1'd1;//,
    if(count<=1'd1) countdown<=1'd0;//,
    if(!countdown) count<=count+1'd1;//1 
    else count<=count-1'd1;//1
    end

	 begin
	 if(count>duty-deadtime) pwmA<=1'b0;//A
	 else pwmA<=protection?1'b0:1'b1;//A
	 if(count>=duty+deadtime) pwmB<=protection?1'b0:1'b1;//B
	 else pwmB<=1'b0;//B
	 end

  end
end
endmodule