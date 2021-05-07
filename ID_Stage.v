`include "defines.v"

module ID_Stage(
	clk,
	rst,
	PC_in,
	instruction_in,
	hazard,
	status_register_in,	
	wb_dest,
	wb_value,
	wb_enable_WB,
	PC,
	mem_read_out, 
	mem_write_out, 
	wb_enable_out,
	execute_command_out,
	branch_taken_out, 
	status_write_enable_out,
	reg_file_out1, 
	reg_file_out2,
	two_src,
	src1_out, 
	src2_out,
	immediate_out,
	signed_immediate,
	shift_operand,
	dest_reg_out /* = Rd */
);

	input clk;
	input rst;
	input[`ADDRESS_LEN - 1: 0] PC_in;
	input[`INSTRUCTION_LEN - 1:0] instruction_in;
	input hazard;
	input [3:0] status_register_in;
	
	input [`REGFILE_ADDRESS_LEN - 1 : 0] wb_dest;
	input [`REGISTER_LEN - 1 : 0] wb_value;
	input wb_enable_WB;

	output[`ADDRESS_LEN - 1: 0] PC;

	output mem_read_out, mem_write_out, wb_enable_out;
	output [`EXECUTE_COMMAND_LEN - 1:0] execute_command_out;
	output branch_taken_out, status_write_enable_out;
	
	output [`REGISTER_LEN - 1:0] reg_file_out1, reg_file_out2;
	
	
	output two_src;
	output [`REGFILE_ADDRESS_LEN - 1 : 0] src1_out, src2_out;
	
	output immediate_out;
	output [23:0] signed_immediate;
	output [`SHIFT_OPERAND_LEN - 1:0] shift_operand;
	output [`REGFILE_ADDRESS_LEN - 1:0] dest_reg_out; /* = Rd */




	assign PC = PC_in;
	assign src1_out = instruction_in[19:16];

	wire two_src_mem_write_en;
	wire control_unit_mux_enable;
	wire mem_write;
	assign two_src_mem_write_en = control_unit_mux_enable == 1'b0 ? mem_write : 1'b0;
	assign two_src = (~instruction_in[25]) | (two_src_mem_write_en);

	

	wire mem_read, wb_enable, branch_taken, status_write_enable;
	wire [`EXECUTE_COMMAND_LEN - 1:0] execute_command;

	ControlUnit control_unit(
		.mode(instruction_in[27:26]),
		.opcode(instruction_in[24:21]), 
		.s(instruction_in[20]),
		.exe_cmd(execute_command), 
		.mem_read(mem_read), 
		.mem_write(mem_write),
		.wb_enable(wb_enable), 
		.branch_taken(branch_taken),
		.status_write_enable(status_write_enable)
	);

	
	wire cond_state;
	assign control_unit_mux_enable = ~cond_state | hazard;

	
	assign mem_read_out = control_unit_mux_enable == 1'b0 ? mem_read : 1'b0;
	assign mem_write_out = control_unit_mux_enable == 1'b0 ? mem_write : 1'b0;
	assign wb_enable_out = control_unit_mux_enable == 1'b0 ? wb_enable : 1'b0;
	assign branch_taken_out = control_unit_mux_enable == 1'b0 ? branch_taken : 1'b0;
	assign status_write_enable_out = control_unit_mux_enable == 1'b0 ? status_write_enable : 1'b0;
	assign execute_command_out = control_unit_mux_enable == 1'b0 ? execute_command : `EXECUTE_COMMAND_LEN'b0;

	wire[`REGFILE_ADDRESS_LEN - 1:0] reg_file_src1, reg_file_src2;
	
	assign reg_file_src1 = instruction_in[19:16];

	
	assign reg_file_src2 = mem_write_out ? instruction_in[15:12] : instruction_in[3:0];
	assign src2_out = reg_file_src2; 


	RegisterFile register_file(
		.clk(clk), 
		.rst(rst),
    	.src1(reg_file_src1), 
		.src2(reg_file_src2),
		.dest_wb(wb_dest),
		.result_wb(wb_value),
    	.wb_enable(wb_enable_WB),
		.reg1(reg_file_out1), .reg2(reg_file_out2)
	);

	
	
	Condition_Check condition_check(
		.cond(instruction_in[31:28]),
		.stat_reg(status_register_in),
		.cond_state(cond_state)
    );

	assign shift_operand = instruction_in[`SHIFT_OPERAND_INDEX:0];
	assign signed_immediate = instruction_in[23:0];
	assign dest_reg_out = instruction_in[15:12];
	assign immediate_out = instruction_in[25];

endmodule