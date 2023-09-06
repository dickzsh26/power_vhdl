module step_val(
    input clk,rst_n,
    output reg[BIT_WIDTH-1:0] out
);

parameter BIT_WIDTH = 21;
parameter CNT_WIDTH = 31;
parameter [BIT_WIDTH-1:0] INITIAL_VAL = 20;
parameter [BIT_WIDTH-1:0] FINAL_VAL = 100;
parameter [CNT_WIDTH-1:0] STEP_TIME = 100;

reg [CNT_WIDTH-1:0]step_cnt;
reg [2:0] state;
reg [2:0] state_next;
wire counter_done = (step_cnt == STEP_TIME);

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        step_cnt <= 0;
    end
    else
        step_cnt <= counter_done?step_cnt:(step_cnt+1);
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        out <= INITIAL_VAL;
    end
    else begin
        if(counter_done)
            out <= FINAL_VAL;
        else
            out <= out;
    end
end
endmodule