module reference(
    input clk,rst_n,
    output reg[BIT_WIDTH-1:0] out
);

parameter BIT_WIDTH = 21;
parameter OUTPUT_VALUE = 0;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        out <= 0;
    end
    else
    begin
        out <= OUTPUT_VALUE;
    end
end
endmodule