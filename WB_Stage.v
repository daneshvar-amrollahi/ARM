`include "defines.v"

module WB_Stage(
	input clk,
	input rst,
	input[`ADDRESS_LEN - 1: 0] PC_in,
	output[`ADDRESS_LEN - 1: 0] PC
);
	assign PC = PC_in;
endmodule 