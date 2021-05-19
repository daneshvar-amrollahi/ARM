module mux_3_to_1 
    #(parameter WIDTH=32)
(
    in1,
    in2,
    in3,
    sel,
    out
);

    input [WIDTH - 1 : 0] in1;
    input [WIDTH - 1 : 0] in2;
    input [WIDTH - 1 : 0] in3;
    input [1:0] sel;
    output reg [WIDTH - 1 : 0] out;

    always @(*) begin
        out = {WIDTH{1'b0}};
        if (sel == 2'b00)
            out = in1;
        else if (sel == 2'b01)
            out = in2;
        else if (sel == 2'b10)
            out = in3;
    end

endmodule