module uart_rxd
(
    input                       clk               , // 系统50MHz时钟
    input                       rst_n             , // 系统全局复位
    input                       I_rx_start          , // 接收使能信号
    input                       I_bps_rx_clk        , // 接收波特率时钟
    input                       I_rs232_rxd         , // 接收的串行数据，在硬件上与串口相连  
    output    reg               O_bps_rx_clk_en     , // 波特率时钟使能信号
    output    reg               O_rx_done           , // 接收完成标志
    output    reg   [7:0]       O_para_data           // 接收到的8-bit并行数据
);

reg         R_rs232_rx_reg0 ;
reg         R_rs232_rx_reg1 ;
reg         R_rs232_rx_reg2 ;
reg         R_rs232_rx_reg3 ;

reg         R_receiving     ;

reg [3:0]   R_state         ;
reg [7:0]   R_para_data_reg ;

wire        W_rs232_rxd_neg ;

////////////////////////////////////////////////////////////////////////////////
// 功能：把 I_rs232_rxd 打的前两拍，是为了消除亚稳态
//          把 I_rs232_rxd 打的后两拍，是为了产生下降沿标志位
////////////////////////////////////////////////////////////////////////////////
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        begin
            R_rs232_rx_reg0 <= 1'b0 ;
            R_rs232_rx_reg1 <= 1'b0 ;
            R_rs232_rx_reg2 <= 1'b0 ;
            R_rs232_rx_reg3 <= 1'b0 ;
        end 
    else
        begin  
            R_rs232_rx_reg0 <= I_rs232_rxd      ;
            R_rs232_rx_reg1 <= R_rs232_rx_reg0  ; 
            R_rs232_rx_reg2 <= R_rs232_rx_reg1  ; 
            R_rs232_rx_reg3 <= R_rs232_rx_reg2  ; 
        end   
end
// 产生I_rs232_rxd信号的下降沿标志位
assign W_rs232_rxd_neg    =    (~R_rs232_rx_reg2) & R_rs232_rx_reg3 ;

////////////////////////////////////////////////////////////////////////////////
// 功能：产生发送信号R_receiving
////////////////////////////////////////////////////////////////////////////////
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        R_receiving <= 1'b0 ;
    else if(O_rx_done)
        R_receiving <= 1'b0 ;
    else if(I_rx_start && W_rs232_rxd_neg)
        R_receiving <= 1'b1 ;          
end

////////////////////////////////////////////////////////////////////////////////
// 功能：用状态机把串行的输入数据接收，并转化为并行数据输出
////////////////////////////////////////////////////////////////////////////////
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        begin
            O_rx_done       <= 1'b0 ; 
            R_state         <= 4'd0 ;
            R_para_data_reg <= 8'd0 ;
            O_bps_rx_clk_en <= 1'b0 ;
        end 
    else if(R_receiving)
        begin
            O_bps_rx_clk_en <= 1'b1 ; // 打开波特率时钟使能信号
        end
    else
        begin
            O_rx_done           <= 1'b0 ;
            R_state             <= 4'd0 ;
            R_para_data_reg     <= 8'd0 ;
            O_bps_rx_clk_en     <= 1'b0 ; // 接收完毕以后关闭波特率时钟使能信号
        end          
end

always @(posedge I_bps_rx_clk)begin
    R_para_data_reg <= {I_rs232_rxd,R_para_data_reg[7:1]};
    R_state  <= R_state+1;
    if(R_state == 9)begin
        O_para_data  <=  R_para_data_reg;
        O_rx_done <= 1;
        R_state  <= 0;
    end
end


endmodule