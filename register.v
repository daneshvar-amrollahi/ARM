module register #(parameter WORD_LEN=32)(
    clk, 
    rst, 
    ld, 
    in, 
    out
    );
    input clk, rst, ld;
    input [WORD_LEN - 1: 0] in;
    output reg [WORD_LEN - 1: 0] out;

    always @(posedge clk or posedge rst) begin
        if (rst)
            out <= 0;
        else if (ld)
            out <= in;
    end
endmodule