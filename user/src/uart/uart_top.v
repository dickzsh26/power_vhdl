module uart_top
(
    input             I_clk           , // 系统50MHz时钟
    input             I_rst_n         , // 系统全局复位
    output    [3:0]   O_led_out       ,
    output            O_rs232_txd       // 发送的串行数据，在硬件上与串口相连
);

wire            W_bps_tx_clk                 ;
wire            W_bps_tx_clk_en              ;
wire            W_bps_rx_clk                 ;
wire            W_bps_rx_clk_en              ;
wire            W_tx_start                   ;
wire            W_tx_done                    ;
wire            W_rx_done                    ;
wire  [7:0]     W_para_data                  ;
wire  [7:0]     W_rx_para_data               ;
            
reg   [7:0]     R_data_reg                   ;
reg   [31:0]    R_cnt_1s                     ;
reg             R_tx_start_reg               ;
    
assign W_tx_start     =    R_tx_start_reg      ;
assign W_para_data    =    R_data_reg          ;
assign O_led_out      =    W_rx_para_data[3:0] ;

/////////////////////////////////////////////////////////////////////
// 产生要发送的数据
/////////////////////////////////////////////////////////////////////
always @(posedge I_clk or negedge I_rst_n)
begin
     if(!I_rst_n)
        begin
             R_cnt_1s         <= 31'd0     ;
             R_data_reg       <= 8'd0      ;
             R_tx_start_reg   <= 1'b0      ;
        end
     else if(R_cnt_1s == 31'd5000)
        begin
             R_cnt_1s         <= 31'd0                 ;
             R_data_reg       <= R_data_reg + 1'b1     ;
             R_tx_start_reg   <= 1'b1                  ;
        end
     else
        begin
          R_cnt_1s           <= R_cnt_1s + 1'b1     ;
          R_tx_start_reg     <= 1'b0                ;
        end
end

uart_txd U_uart_txd
(
    .I_clk               (I_clk                 ), // 系统50MHz时钟
    .I_rst_n             (I_rst_n               ), // 系统全局复位
    .I_tx_start          (W_tx_start            ), // 发送使能信号
    .I_bps_tx_clk        (W_bps_tx_clk          ), // 波特率时钟
    .I_para_data         (W_para_data           ), // 要发送的并行数据
    .O_rs232_txd         (O_rs232_txd           ), // 发送的串行数据，在硬件上与串口相连
    .O_bps_tx_clk_en     (W_bps_tx_clk_en       ), // 波特率时钟使能信号
    .O_tx_done           (W_tx_done             )  // 发送完成的标志
);

baudrate_gen U_baudrate_gen
(
    .I_clk              (I_clk              ), // 系统50MHz时钟
    .I_rst_n            (I_rst_n            ), // 系统全局复位
    .I_bps_tx_clk_en    (W_bps_tx_clk_en    ), // 串口发送模块波特率时钟使能信号
    .I_bps_rx_clk_en    (W_bps_rx_clk_en    ), // 串口接收模块波特率时钟使能信号
    .O_bps_tx_clk       (W_bps_tx_clk       ), // 发送模块波特率产生时钟
    .O_bps_rx_clk       (W_bps_rx_clk       )  // 接收模块波特率产生时钟
);

uart_rxd U_uart_rxd
(
    .I_clk              (I_clk              ), // 系统50MHz时钟
    .I_rst_n            (I_rst_n            ), // 系统全局复位
    .I_rx_start         (1'b1               ), // 接收使能信号
    .I_bps_rx_clk       (W_bps_rx_clk       ), // 接收波特率时钟
    .I_rs232_rxd        (O_rs232_txd        ), // 接收的串行数据，在硬件上与串口相连  
    .O_bps_rx_clk_en    (W_bps_rx_clk_en    ), // 波特率时钟使能信号
    .O_rx_done          (W_rx_done          ), // 接收完成标志
    .O_para_data        (W_rx_para_data     )  // 接收到的8-bit并行数据
);

endmodule