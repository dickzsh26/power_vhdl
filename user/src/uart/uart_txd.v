module uart_txd
(
    input          I_clk           , // 系统50MHz时钟
    input          I_rst_n         , // 系统全局复位
    input          I_tx_start      , // 发送使能信号
    input          I_bps_tx_clk    , // 发送波特率时钟
    input   [7:0]  I_para_data     , // 要发送的并行数据
    output  reg    O_rs232_txd     , // 发送的串行数据，在硬件上与串口相连
    output  reg    O_bps_tx_clk_en , // 波特率时钟使能信号
    output  reg    O_tx_done         // 发送完成的标志
);

reg  [3:0]  R_state ;

reg R_transmiting ; // 数据正在发送标志

/////////////////////////////////////////////////////////////////////////////
// 产生发送 R_transmiting 标志位
/////////////////////////////////////////////////////////////////////////////
always @(posedge I_clk or negedge I_rst_n)
begin
    if(!I_rst_n)
        R_transmiting <= 1'b0 ;
    else if(O_tx_done)
        R_transmiting <= 1'b0 ;
    else if(I_tx_start)
        R_transmiting <= 1'b1 ;          
end

/////////////////////////////////////////////////////////////////////////////
// 发送数据状态机
/////////////////////////////////////////////////////////////////////////////
always @(posedge I_clk or negedge I_rst_n)
begin
    if(!I_rst_n)
        begin
            R_state      <= 4'd0 ;
            O_rs232_txd  <= 1'b1 ; 
            O_tx_done    <= 1'b0 ;
            O_bps_tx_clk_en <= 1'b0 ;  // 关掉波特率时钟使能信号
        end 
    else if(R_transmiting) // 检测发送标志被拉高，准备发送数据
        begin
            O_bps_tx_clk_en <= 1'b1 ;  // 发送数据前的第一件事就是打开波特率时钟使能信号
            if(I_bps_tx_clk) // 在波特率时钟的控制下把数据通过一个状态机发送出去，并产生发送完成信号
                begin
                    case(R_state)
                        4'd0  : // 发送起始位
                            begin
                                O_rs232_txd  <= 1'b0            ;
                                O_tx_done    <= 1'b0            ; 
                                R_state      <= R_state + 1'b1  ;
                            end
                        4'd1  : // 发送 I_para_data[0]
                            begin
                                O_rs232_txd  <= I_para_data[0]  ;
                                O_tx_done    <= 1'b0            ; 
                                R_state      <= R_state + 1'b1  ;
                            end 
                        4'd2  : // 发送 I_para_data[1]
                            begin
                                O_rs232_txd  <= I_para_data[1]   ;
                                O_tx_done    <= 1'b0             ; 
                                R_state      <= R_state + 1'b1   ;
                            end
                        4'd3  : // 发送 I_para_data[2]
                            begin
                                O_rs232_txd  <= I_para_data[2]   ;
                                O_tx_done    <= 1'b0             ; 
                                R_state      <= R_state + 1'b1   ;
                            end
                        4'd4  : // 发送 I_para_data[3]
                            begin
                                O_rs232_txd  <= I_para_data[3]   ;
                                O_tx_done    <= 1'b0             ; 
                                R_state      <= R_state + 1'b1   ;
                            end 
                        4'd5  : // 发送 I_para_data[4]
                            begin
                                O_rs232_txd  <= I_para_data[4]   ;
                                O_tx_done    <= 1'b0             ; 
                                R_state      <= R_state + 1'b1   ;
                            end
                        4'd6  : // 发送 I_para_data[5]
                            begin
                                O_rs232_txd  <= I_para_data[5]   ;
                                O_tx_done    <= 1'b0             ; 
                                R_state      <= R_state + 1'b1   ;
                            end
                        4'd7  : // 发送 I_para_data[6]
                            begin
                                O_rs232_txd  <= I_para_data[6]   ;
                                O_tx_done    <= 1'b0             ; 
                                R_state      <= R_state + 1'b1   ;
                            end
                        4'd8  : // 发送 I_para_data[7]
                            begin
                                O_rs232_txd  <= I_para_data[7]   ;
                                O_tx_done    <= 1'b0             ; 
                                R_state      <= R_state + 1'b1   ;
                            end 
                        4'd9  : // 发送 停止位
                            begin
                                O_rs232_txd  <= 1'b1             ;
                                O_tx_done    <= 1'b1             ; 
                                R_state      <= 4'd0               ;
                            end
                        default :R_state      <= 4'd0            ;
                        endcase 
            end 
        end 
        else 
        begin 
            O_bps_tx_clk_en   <= 1'b0  ; // 一帧数据发送完毕以后就关掉波特率时钟使能信号
            R_state   <= 4'd0  ; 
            O_tx_done   <= 1'b0  ; 
            O_rs232_txd<= 1'b1  ;  
        end
    end
endmodule