module #(parameter WORD_LEN=32) mux2to1(a, b, sel_a, sel_b, out);
    input [WORD_LEN - 1:0] a, b;
    input sel_a, sel_b;
    output [WORD_LEN - 1:0] out;

    assign out = (sel_a == 1'b1) ? a : ( (sel_b == 1'b1) ? b : out);
endmodule