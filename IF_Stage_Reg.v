`include "defines.v"

module IF_Stage_Reg (
	input clk, rst, freeze, flush,
	input[`ADDRESS_LEN - 1:0] PC_in, Instruction_in,
	output reg[`INSTRUCTION_LEN - 1:0] PC, Instruction
);
	always @(posedge clk, posedge rst) begin
		if (rst)
			PC <= `INSTRUCTION_LEN'b0;
		else begin
			if (~freeze) begin
				PC <= PC_in;
				Instruction <= Instruction_in;
			end
				
		end
		
	end

endmodule