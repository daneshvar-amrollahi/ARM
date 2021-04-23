module MEM_Stage_Reg(
	input clk,
	input rst,
	input[`ADDRESS_LEN - 1: 0] PC_in,
	output reg[`ADDRESS_LEN - 1: 0] PC
);
	always @(posedge clk, posedge rst) 
        if (rst)
            PC <= `ADDRESS_LEN'b0;
        else
            PC <= PC_in;
endmodule