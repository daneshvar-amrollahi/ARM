module mux2to1 #(parameter WORD_LEN=32) (
    a, 
    b, 
    sel_a, 
    sel_b, 
    out
    );
    input [WORD_LEN - 1:0] a, b;
    input sel_a, sel_b;
    output reg [WORD_LEN - 1:0] out;

    always @(a or b or sel_a or sel_b)
    begin
        out = 0;
        if (sel_a)
            out = a;
        else if (sel_b)
            out = b; 
    end
endmodule