module PID(
    input clk,rst_n,
    input adc_complete,
    input [INPUT_BIT_WIDTH-1:0] sample,
	input wire signed[PARAMETER_BIT_WIDTH-1:0] target,
    output reg signed[PARAMETER_BIT_WIDTH-1:0] pi_out
);

// 字宽参数
parameter PARAMETER_BIT_WIDTH = 26;
parameter INPUT_BIT_WIDTH = 12;
parameter PERIOD_BIT_WIDTH = 21;

// 控制参数
parameter signed[PARAMETER_BIT_WIDTH-1:0] kp = 10;
parameter signed[PARAMETER_BIT_WIDTH-1:0] ki = 1;
parameter signed[PARAMETER_BIT_WIDTH-1:0] maximum_out = 1000;
parameter signed[PARAMETER_BIT_WIDTH-1:0]  minimum_out = 0;
parameter signed[PARAMETER_BIT_WIDTH-1:0]  maximum_add = 100;
parameter signed[PARAMETER_BIT_WIDTH-1:0]  minimum_add = 0;


wire signed [PARAMETER_BIT_WIDTH-1:0] sample_signed = sample;

reg signed[PARAMETER_BIT_WIDTH-1:0]pi_add;
reg signed[PARAMETER_BIT_WIDTH-1:0] pi_out_temp;

reg signed [PARAMETER_BIT_WIDTH-1:0]e0;
reg signed [PARAMETER_BIT_WIDTH-1:0]e1;
reg signed [PARAMETER_BIT_WIDTH-1:0]e2;

reg signed [PARAMETER_BIT_WIDTH-1:0] kp_comp;
reg signed [PARAMETER_BIT_WIDTH-1:0] ki_comp;
reg signed [PARAMETER_BIT_WIDTH-1:0] kp_comp_error;

reg[4:0] pi_state;

reg[PERIOD_BIT_WIDTH-1:0] adc_read_cnt = 0;

// 同步信号
reg adc_complete_dly1;
reg adc_complete_dly2;

wire adc_read_flag = adc_complete_dly1&(~adc_complete_dly2);

// adc_complete 同步化并提取上升沿
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        adc_complete_dly1 <= 0;
        adc_complete_dly2 <= 0;
    end
    else begin
        adc_complete_dly1 <= adc_complete;
        adc_complete_dly2 <= adc_complete_dly1;
    end
end

// pid计算状态机
always @(posedge clk or negedge rst_n) begin
    if(~rst_n)begin
        pi_state <= 0;
        e0  <= 0;
        pi_add    <=  0;
        pi_out_temp <= 0;
        kp_comp_error <= 0;
        ki_comp <= 0;
        kp_comp <= 0;
		  e1  <=  0;
        e2  <=  0; 
    end
    else
    case(pi_state)
            //前一个状态为0，后一个状态为1
            0: pi_state <= (adc_read_flag)?1:0;
            1: begin
                //计算本次error
                e0  <=  target - sample_signed;
                pi_state <= 2;
            end
            2:begin
                //计算增量
                kp_comp_error <= e0-e1;
                pi_state <= 3;
            end
            3:begin
                kp_comp <= kp*kp_comp_error;
					 e2  <=  e1;
					 e1  <=  e0;
                pi_state <= 4;
            end
            4:begin
                ki_comp <= ki*e0;
                pi_state <= 5;
            end
            5: begin
                pi_add <= kp_comp + ki_comp;
                pi_state <= 6;
            end
            6:begin
                //增量限幅
                //50*2048*2
                if(pi_add>maximum_add)begin
                    pi_add <= maximum_add;
                end
                else if(pi_add<minimum_add)begin
                    pi_add <= minimum_add;
                end
                pi_state <= 7;
            end
            7:begin
                pi_out_temp <= pi_out_temp+pi_add;
                pi_state <= 8;
            end
            8:begin
                //输出限幅
                if(pi_out_temp>maximum_out)begin
                    pi_out_temp <= maximum_out;
                end
					 
                //50*2048*2
                else if(pi_out_temp<minimum_out)begin
                    pi_out_temp <= minimum_out;
                end
                pi_state <= 9;
            end
				9: begin
					pi_state <= 0;
				end
            default: pi_state <= 0;
    endcase
end

// 最终输出值
always @(posedge clk or negedge rst_n) begin
    if(~rst_n)begin
        pi_out<=0;
    end
    else begin
		if(pi_state == 9) begin
        pi_out <= pi_out_temp;
		end
    end
end

endmodule