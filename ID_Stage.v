`include "defines.v"

module ID_Stage(
	input clk,
	input rst,
	input[`ADDRESS_LEN - 1: 0] PC_in,
	input[`INSTRUCTION_LEN - 1:0] instruction_in,
	input hazard,
	
	output[`ADDRESS_LEN - 1: 0] PC,

	// ouput of control unit mux
	output mem_read_out, mem_write_out, wb_enable_out,
	output [`EXECUTE_COMMAND_LEN - 1:0] execute_command_out,
	output branch_taken_out, status_write_enable_out,
	
	// output of register file
	output [`REGISTER_LEN - 1:0] reg_file_out1, reg_file_out2,
	
	// output to hazard unit
	// We'll deal with this motherf* later
	// output two_src,
	
	output immediate_out,
	output [23:0] signed_immediate,
	output [`SHIFT_OPERAND_LEN - 1:0] shift_operand,
	output [`REGFILE_ADDRESS_LEN - 1:0] dest_reg_out /* = Rd */

);
	assign PC = PC_in;


	wire control_unit_mux_enable;

	wire mem_read, mem_write, wb_enable, branch_taken, status_write_enable;
	wire [`EXECUTE_COMMAND_LEN - 1:0] execute_command;

	ControlUnit control_unit(.mode(instruction_in[27:26]),
			.opcode(instruction_in[24:21]), .s(instruction_in[20]),
			.exe_cmd(execute_command), .mem_read(mem_read), .mem_write(mem_write),
			.wb_enable(wb_enable), .branch_taken(branch_taken),
			.status_write_enable(status_write_enable));

	//cond_state should be ORed with a hazard signal ---> select of mux
	wire cond_state;
	assign control_unit_mux_enable = ~cond_state | hazard;

	// Needs to be checked in the future
	assign mem_read_out = control_unit_mux_enable ? mem_read : 1'b0;
	assign mem_write_out = control_unit_mux_enable ? mem_write : 1'b0;
	assign wb_enable_out = control_unit_mux_enable ? wb_enable : 1'b0;
	assign branch_taken_out = control_unit_mux_enable ? branch_taken : 1'b0;
	assign status_write_enable_out = control_unit_mux_enable ? status_write_enable : 1'b0;
	assign execute_command_out = control_unit_mux_enable ? execute_command : `EXECUTE_COMMAND_LEN'b0;

	wire[`REGFILE_ADDRESS_LEN - 1:0] reg_file_src1, reg_file_src2;
	
	assign reg_file_src1 = instruction_in[19:16];

	// If fails, need to check mem_write_out
	assign reg_file_src2 = mem_write ? instruction_in[15:12] : instruction_in[3:0];
	
	//TODO: Assign these to wires coming from WB Stage
	wire[`REGISTER_LEN - 1:0] reg_file_wb_data;
	wire[`REGFILE_ADDRESS_LEN - 1:0] reg_file_wb_address;
	wire reg_file_wb_en;

	//???
	// No idea, still
	assign reg_file_wb_data = 13;
	assign reg_file_wb_address = 7;
	assign reg_file_wb_en = 1'b0;

	RegisterFile register_file(.clk(clk), .rst(rst),
    		.src1(reg_file_src1), .src2(reg_file_src2),
			.Dest_wb(reg_file_wb_address),
			.Result_wb(reg_file_wb_data),
    		.writeBackEn(reg_file_wb_en),
			.reg1(reg_file_out1), .reg2(reg_file_out2)
	);

	// Needs to change in the future
	// status_register comes from actual status_register
	wire [3:0] status_register;
	assign status_register = 4'b0011;
	
	
	Condition_Check condition_check(
		.cond(instruction_in[31:28]),
		.stat_reg(status_register),
		.cond_state(cond_state)
    );

	assign shift_operand = instruction_in[`SHIFT_OPERAND_INDEX:0];
	assign signed_immediate = instruction_in[23:0];
	assign dest_reg_out = instruction_in[15:12];
	assign immediate_out = instruction_in[25];
endmodule