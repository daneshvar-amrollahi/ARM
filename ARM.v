`include "defines.v"

module ARM(input clk, rst);

	wire freeze, Branch_taken, flush;
	wire[`ADDRESS_LEN - 1:0] BranchAddr;
	wire[`ADDRESS_LEN - 1:0] 	PC_IF, PC_IF_Reg,
								PC_ID, PC_ID_Reg,
								PC_EXE, PC_EXE_Reg,
								PC_MEM, PC_MEM_Reg,
								PC_WB
								;

	wire[`INSTRUCTION_LEN - 1:0] 	Instruction_IF, Instruction_IF_Reg;

	assign Branch_taken = 1'b0;
	assign freeze = 1'b0;
	assign BranchAddr = `ADDRESS_LEN'b0;
    assign flush = 1'b0;

	IF_Stage IF_Stage(
		.clk(clk), .rst(rst),
		.freeze(freeze), .Branch_taken(Branch_taken),
		.BranchAddr(BranchAddr),
		.PC(PC_IF),
		.Instruction(Instruction_IF)
		);

	IF_Stage_Reg IF_Stage_Reg(.clk(clk), .rst(rst),
			.freeze(freeze), .flush(flush),
			.PC_in(PC_IF), .instruction_in(Instruction_IF),
            .PC(PC_IF_Reg), .Instruction(Instruction_IF_Reg));

	wire mem_read_ID, mem_read_ID_Reg;
	wire mem_write_ID, mem_write_ID_Reg;
	wire wb_enable_ID, wb_enable_ID_Reg;
	wire [`EXECUTE_COMMAND_LEN - 1:0] execute_command_ID, execute_command_ID_Reg;
	wire branch_taken_ID, branch_taken_ID_Reg; 
	wire status_write_enable_ID, status_write_enable_ID_Reg;
	wire [`REGISTER_LEN - 1:0] reg_file_1_ID, reg_file_1_ID_Reg;
	wire [`REGISTER_LEN - 1:0] reg_file_2_ID, reg_file_2_ID_Reg;
	wire immediate_ID, immediate_ID_Reg;
	wire [23:0] signed_immediate_ID, signed_immediate_ID_Reg;
	wire [`SHIFT_OPERAND_LEN - 1:0] shift_operand_ID, shift_operand_ID_Reg;
	wire [`REGFILE_ADDRESS_LEN - 1:0] dest_reg_ID, dest_reg_ID_Reg;
	wire [3:0] status_register_ID_Reg, status_register_ID;
	wire hazard;

	assign hazard = 1'b0;
	//assign actual_status_register_out = 4'b0011; //should be commented?
	ID_Stage ID_Stage(.clk(clk), .rst(rst), .PC_in(PC_IF_Reg), .hazard(hazard),
			.instruction_in(Instruction_IF_Reg), .PC(PC_ID), .status_register_in(actual_status_register_out),
			.mem_read_out(mem_read_ID), .mem_write_out(mem_write_ID), .wb_enable_out(wb_enable_ID),
			.execute_command_out(execute_command_ID),
			.branch_taken_out(branch_taken_ID), .status_write_enable_out(status_write_enable_ID),
			.reg_file_out1(reg_file_1_ID), .reg_file_out2(reg_file_2_ID), .immediate_out(immediate_ID),
			.signed_immediate(signed_immediate_ID), 
			.shift_operand(shift_operand_ID),
			.dest_reg_out(dest_reg_ID)
			);


	
	assign status_register_ID = actual_status_register_out;
	ID_Stage_Reg ID_Stage_Reg(.clk(clk), .rst(rst), .flush(flush), .pc_in(PC_ID), .mem_read_in(mem_read_ID),
		.mem_write_in(mem_write_ID), .wb_enable_in(wb_enable_ID),
		.branch_taken_in(branch_taken_ID), .status_write_enable_in(status_write_enable_ID), 
		.execute_command_in(execute_command_ID), .val_rn_in(reg_file_1_ID), .val_rm_in(reg_file_2_ID),
		.immediate_in(immediate_ID), .signed_immediate_in(signed_immediate_ID),
		.shift_operand_in(shift_operand_ID), .dest_reg_in(dest_reg_ID),
		.status_register_in(status_register_ID), //output of status register
		
		.pc_out(PC_ID_Reg), .mem_read_out(mem_read_ID_Reg),
		.mem_write_out(mem_write_ID_Reg), .wb_enable_out(wb_enable_ID_Reg),
		.branch_taken_out(branch_taken_ID_Reg), .status_write_enable_out(status_write_enable_ID_Reg), 
		.execute_command_out(execute_command_ID_Reg), .val_rn_out(reg_file_1_ID_Reg), .val_rm_out(reg_file_2_ID_Reg),
		.immediate_out(immediate_ID_Reg), .signed_immediate_out(signed_immediate_ID_Reg),
		.shift_operand_out(shift_operand_ID_Reg), .dest_reg_out(dest_reg_ID_Reg),
		.status_register_out(status_register_ID_Reg));

	wire [`REGISTER_LEN - 1 : 0] alu_res_EXE;
	wire [`ADDRESS_LEN - 1 : 0] branch_address_EXE;
	wire [3:0] status_bits;
	EXE_Stage EXE_Stage(
		.clk(clk), 
		.rst(rst),
		.pc_in(PC_ID_Reg), 
		.wb_enable_in(wb_enable_ID_Reg), 
		.mem_read_in(mem_read_ID_Reg), 
		.mem_write_in(mem_write_ID_Reg), 
		.status_register_write_enable(status_write_enable_ID_Reg), 
		.branch_taken_in(branch_taken_ID_Reg), 
		.execute_command_in(execute_command_ID_Reg),
		.immediate_in(immediate_ID_Reg), 
		.signed_immediate_24_in(signed_immediate_ID_Reg), 
		.shift_operand_in(shift_operand_ID_Reg), 
		.val_rn_in(reg_file_1_ID_Reg), 
		.val_rm_in(reg_file_2_ID_Reg), 
		.status_register_in(status_register_ID_Reg),

		.pc_out(PC_EXE),
		.status_bits(status_bits), 
		.alu_res(alu_res_EXE),
		.branch_address(branch_address_EXE)
	);

	wire wb_enable_EXE_Reg;
	wire mem_read_EXE_Reg;
	wire mem_write_EXE_Reg;
	wire [`REGISTER_LEN - 1 : 0] alu_res_EXE_Reg;
	wire [`REGISTER_LEN - 1 : 0] val_rm_EXE_Reg;
	wire [`REGISTER_LEN - 1 : 0] dest_reg_EXE_Reg;
	EXE_Stage_Reg EXE_Stage_Reg(
		.clk(clk),
		.rst(clk),
		.pc_in(PC_EXE),
		.wb_enable_in(wb_enable_ID_Reg),
		.mem_read_in(mem_read_ID_Reg),
		.mem_write_in(mem_write_ID_Reg),
		.alu_res_in(alu_res_EXE),
		.val_rm_in(reg_file_2_ID_Reg),
		.dest_in(dest_reg_ID_Reg),
		
		.pc_out(PC_EXE_Reg),
		.wb_enable_out(wb_enable_EXE_Reg),
		.mem_read_out(mem_read_EXE_Reg),
		.mem_write_out(mem_write_EXE_Reg),
		.alu_res_out(alu_res_EXE_Reg),
		.val_rm_out(val_rm_EXE_Reg),
		.dest_out(dest_reg_EXE_Reg)
	);

	wire [3:0] actual_status_register_out; //output of the actual register
	register #(.WORD_LEN(4)) STATUS_REGISTER(
		.clk(clk), 
		.rst(rst),
        .ld(status_write_enable_ID_Reg), 
		.in(status_bits), 
		.out(actual_status_register_out)
	);

	MEM_Stage MEM_Stage(.clk(clk), .rst(rst), .PC_in(PC_EX_Reg), .PC(PC_MEM));

	MEM_Stage_Reg MEM_Stage_Reg(.clk(clk), .rst(rst),
		.PC_in(PC_MEM), .PC(PC_MEM_Reg));

	WB_Stage WB_Stage(.clk(clk), .rst(rst), .PC_in(PC_MEM_Reg), .PC(PC_WB));

endmodule 