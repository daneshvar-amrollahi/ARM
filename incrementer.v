module #(parameter WORD_LEN=32) incrementer(in, out);
    input [WORD_LEN - 1:0] in;
    output [WORD_LEN - 1:0] out;

    assign out = in + 4;
endmodule