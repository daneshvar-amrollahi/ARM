module #(parameter WORD_LEN=32) register(clk, rst, ld, in, out);
    input clk, rst, ld;
    input [WORD_LEN - 1: 0] in;
    output reg [WORD_LEN - 1: 0] out;

    always @(posedge clk or posedge rst) begin
        if (rst)
            out <= WORD_LEN'b0;
        else if (ld)
            out <= in;
    end
endmodule