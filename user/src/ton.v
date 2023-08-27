module ton(
    input clk,
    input rst_n,
    input set,
    output reg reset_pwm
);

parameter ton_time = 40;
parameter conuter_width = 21;
reg [conuter_width-1:0] counter;

localparam IDLE = 3'd0;
localparam UP =   3'd1;

reg [2:0] state,state_next;

wire counter_ton = (counter == ton_time);
reg set_dly;
wire set_pos = (~set_dly) & set;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        set_dly <= 0;
    end
    else
    begin
        set_dly <= set;
    end
end

// 三段式状态机，状态转换
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        state <= IDLE;
    end
    else
    begin
        state <= state_next;
    end
end

// 三段式状态机，下一状态赋值
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        state_next <= IDLE;
    end
    else
    begin
    case(state)
        3'd0:state_next <= set_pos?UP:IDLE;
        3'd1:state_next <= counter_ton?IDLE:UP;
        default: state_next <= IDLE;
    endcase
    end
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        counter <= 0;
    end
    else
    begin
        case(state)
            IDLE:   counter <= 0;
            UP:     counter <= counter+1;
            default:counter <= 0;
        endcase
    end
end

// 输出reset赋值
always @(posedge clk or negedge rst_n)
begin
    if(rst_n)
    begin
        reset_pwm <= 0;
    end
    else
    begin
        if(counter_ton)
        begin
            reset_pwm <= 1;
        end
        else
        begin
            reset_pwm <= 0;
        end
    end
end


endmodule