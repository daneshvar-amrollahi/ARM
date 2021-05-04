`include "defines.v"

module EXE_Stage(
	clk, rst,
	pc_in, pc_out,
	wb_enable_in, mem_read_in, mem_write_in, status_register_write_enable, branch_taken_in, execute_command_in,
	immediate_in, signed_immediate_24_in, shift_operand_in, val_rn_in, val_rm_in, status_register_in,

	pc_out,
	status_register_out, 
	alu_res,
	branch_address
);

	input clk, rst;
	input [`ADDRESS_LEN - 1: 0] pc_in;
	input wb_enable_in, mem_read_in, mem_write_in, status_register_write_enable, branch_taken_in;
	input [`EXECUTE_COMMAND_LEN - 1 : 0] execute_command_in;
	input immediate_in;
	input [23:0] signed_immediate_24_in;
	input [`SHIFT_OPERAND_LEN - 1 : 0] shift_operand_in;
	input [`REGISTER_LEN - 1: 0] val_rn_in, val_rm_in;
	input [3:0] status_register_in; 

	output [`ADDRESS_LEN - 1: 0] pc_out;
	output [3:0] status_register_out;
	output [`REGISTER_LEN - 1 : 0] alu_res;
	output [`ADDRESS_LEN - 1 : 0] branch_address;

	assign pc_out = pc_in;

	//TODO: Instantiate ALU

	//TODO: Instantiate VAL2GEN

	//TODO: Wiring


endmodule 