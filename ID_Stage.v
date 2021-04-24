`include "defines.v"

module ID_Stage(
	input clk,
	input rst,
	input[`ADDRESS_LEN - 1: 0] PC_in,
	input[`INSTRUCTION_LEN - 1:0] Instruction_in,
	output[`ADDRESS_LEN - 1: 0] PC,

	output mem_read_out, mem_write_out, wb_enable_out, immediate_out
	output branch_taken_out, status_write_enable_out

	output [[`EXECUTE_COMMAND_LEN - 1:0]] execute_command_out,
	output[`REGISTER_LEN - 1:0] reg_file_out1, reg_file_out2,
	output two_src,
	output [`REGFILE_ADDRESS_LEN - 1:0] dest_reg_out,
	output [24 - 1:0] signed_immediate,
	output [`SHIFT_OPERAND_LEN - 1:0] shift_operand
);
	assign PC = PC_in;

	// TODO: instantiate ControlUnit
	// TODO: instantiate Condition_Check

	wire [`EXECUTE_COMMAND_LEN - 1:0] execute_command;
	wire[`REGFILE_ADDRESS_LEN - 1:0] reg_file_src1, reg_file_src2;

	wire mem_read, mem_write, wb_enable, branch_taken, status_write_enable;
	wire cond_state, control_unit_mux_enable;

	//TODO: Assign these to wires coming from WB Stage
	wire[`REGISTER_LEN - 1:0] reg_file_wb_data;
	wire[`REG_ADDRESS_LEN - 1:0] reg_file_wb_address;
	wire reg_file_wb_en;

	//???
	assign reg_file_wb_data = 13;
	assign reg_file_wb_address = 7;
	assign reg_file_wb_en = `DISABLE;

	ControlUnit control_unit(.mode(Instruction_in[27:26]),
			.opcode(Instruction_in[24:21]), .s(Instruction_in[20]),
			.exe_cmd(execute_command), .mem_read(mem_read), .mem_write(mem_write),
			.wb_enable(wb_enable), .branch_taken(branch_taken),
			.status_write_enable(status_write_enable));

	wire [3:0] status_register;
	assign status_register = 4'b0011;
	Condition_Check Condition_Check(
		.cond(Instruction_in[31:28]),
		.stat_reg(status_register),
		.cond_state(cond_state)
    );

	//cond_state should be ORed with a hazard signal ---> select of mux

	
endmodule