module key_debounce(
	input wire clk,
	input wire rst_n,
	input wire key_in,
	output reg key_out
);

	parameter TIME_DELAY = 22'd2000_000;
	
	reg [21:0] cnt_delay;//计数器
	wire 	add_cnt;			//是否计数
	wire 	end_cnt;			//是否完成一次计数
	
	reg 	key_before;		//前一个按键状态
	reg 	key_now;			//当前按键状态
	wire 	flag_fall;		//按下标志
	reg 	flag_timing;	//在计数标志
	
	always @(posedge clk or negedge rst_n)begin
		//按键做同步化处理
		if(!rst_n)begin
			key_now <= 1'b1;
		end
		else
			key_now <= key_in;
	end
	
	always @(posedge clk or negedge rst_n)begin
	//记录上一次按键状态
		if(!rst_n)begin
			key_before <= 1'b1;
		end
		else
			key_before <= key_now;
	end
	
	//定义按下的状态
	assign flag_fall = key_before & (~key_now);
	
	always @(posedge clk or negedge rst_n)begin
		//标记开始计数
		if(!rst_n)begin
			flag_timing <= 1'b0;
		end
		else if(flag_fall)
			flag_timing <=	1'b1;
		else if(end_cnt)
			flag_timing <= 1'b0;
	end
	
	assign add_cnt = flag_timing;
	assign end_cnt = ((cnt_delay == TIME_DELAY) && add_cnt);
	
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt_delay <= 22'd0;
		else if(add_cnt) begin
			if(end_cnt)
				cnt_delay <= 22'd0;
			else
				cnt_delay <= cnt_delay + 1'd1;
		end
	end
	
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			key_out <= 1'b0;
		else if(end_cnt & (!key_now))
			key_out <= ~key_out;
		else
			key_out <= 1'b0;
	end
endmodule