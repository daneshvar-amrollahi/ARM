`include "defines.v"

module IF_Stage_Reg (
	input clk, rst, freeze, flush,
	input[`ADDRESS_LEN - 1:0] PC_in, instruction_in,
	output reg[`INSTRUCTION_LEN - 1:0] PC, Instruction
);
	always @(posedge clk, posedge rst) begin
		if (rst)
		begin
			PC <= `INSTRUCTION_LEN'b0;
			Instruction <= `INSTRUCTION_LEN'b0;
		end
		else begin
			if (freeze) begin
			  	PC <= PC;
				Instruction <= Instruction;
			end
			else if (flush)
			begin
			  	PC <= `INSTRUCTION_LEN'b0;
				Instruction <= `INSTRUCTION_LEN'b0;
			end
			else
			begin
			  	PC <= PC_in;
				Instruction <= instruction_in;
			end
		end
		
	end

endmodule