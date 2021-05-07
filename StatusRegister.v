module StatusRegister(
    clk,
    rst,
    ld,
    in,
    out
);
    input clk;
    input rst;
    input ld;
    input [3:0] in;
    output reg [3:0] out;
    always@(negedge clk, posedge rst) 
	begin
		if (rst) 
            out <= 0;
		else 
        if (ld) 
            out <= in;
	end
endmodule