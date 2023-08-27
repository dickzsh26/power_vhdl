module reference(
    input clk,rst_n,
    output reg[20:0] out);

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        out <= 0;
    end
    else
    begin
        out <= 21'd10;
    end
end
endmodule