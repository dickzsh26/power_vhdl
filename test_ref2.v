module test_ref2(
    output reg[bit_width-1:0]   duty
);
parameter bit_width = 21;

initial begin
    duty <= 100;
end
endmodule