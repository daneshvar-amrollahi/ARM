module incrementer #(parameter WORD_LEN=32)(
    in, 
    out
    );
    input [WORD_LEN - 1:0] in;
    output [WORD_LEN - 1:0] out;

    assign out = in + 4;
endmodule