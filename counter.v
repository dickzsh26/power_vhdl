module counter(clk,rst_n,cnt);
    input wire clk,rst_n;
    output reg[bit_width-1:0] cnt;

    parameter bit_width = 10;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)begin
            cnt <= 0;
        end
        else begin
            cnt <= cnt+1;
        end
    end
endmodule