`include "defines.v"

module ARM(input clk, rst);

	wire freeze, branch_taken, flush;
	wire[`ADDRESS_LEN - 1:0] 	PC_IF, PC_IF_Reg,
								PC_ID, PC_ID_Reg,
								PC_EXE, PC_EXE_Reg,
								PC_MEM, PC_MEM_Reg,
								PC_WB;

	wire [3:0] actual_status_register_out; 

	wire[`INSTRUCTION_LEN - 1:0] 	Instruction_IF, Instruction_IF_Reg;

	
	wire hazard;
	assign freeze = hazard;
	
	wire branch_taken_ID_Reg;
	assign flush = branch_taken_ID_Reg;

	wire branch_taken_EXE;
	
	assign branch_taken_EXE = branch_taken_ID_Reg;

	wire [`ADDRESS_LEN - 1 : 0] branch_address_EXE;
	IF_Stage IF_Stage(
		.clk(clk), 
		.rst(rst),
		.freeze(freeze), 
		.branch_taken(branch_taken_EXE),
		.branch_addr(branch_address_EXE),
		.PC(PC_IF),
		.instruction(Instruction_IF)
	);

	IF_Stage_Reg IF_Stage_Reg(
		.clk(clk), 
		.rst(rst),
		.freeze(freeze), 
		.flush(flush),
		.PC_in(PC_IF), 
		.instruction_in(Instruction_IF),
        .PC(PC_IF_Reg), 
		.instruction(Instruction_IF_Reg)
	);

	wire mem_read_ID, mem_read_ID_Reg;
	wire mem_write_ID, mem_write_ID_Reg;
	wire wb_enable_ID, wb_enable_ID_Reg;
	wire [`EXECUTE_COMMAND_LEN - 1:0] execute_command_ID, execute_command_ID_Reg;
	wire branch_taken_ID; 
	wire status_write_enable_ID, status_write_enable_ID_Reg;
	wire [`REGISTER_LEN - 1:0] reg_file_1_ID, reg_file_1_ID_Reg;
	wire [`REGISTER_LEN - 1:0] reg_file_2_ID, reg_file_2_ID_Reg;
	wire immediate_ID, immediate_ID_Reg;
	wire [23:0] signed_immediate_ID, signed_immediate_ID_Reg;
	wire [`SHIFT_OPERAND_LEN - 1:0] shift_operand_ID, shift_operand_ID_Reg;
	wire [`REGFILE_ADDRESS_LEN - 1:0] dest_reg_ID, dest_reg_ID_Reg;
	wire [3:0] status_register_ID_Reg, status_register_ID;
	

	wire two_src_ID;
	wire [`REGFILE_ADDRESS_LEN - 1 : 0] src1_ID, src2_ID;
	wire [`REGFILE_ADDRESS_LEN - 1 : 0] dest_reg_EXE_Reg;
	wire wb_enable_MEM_Reg;
	wire [`REGISTER_LEN - 1 : 0] wb_value_WB;
	wire [`REGFILE_ADDRESS_LEN - 1 : 0] dest_reg_MEM_Reg;
	ID_Stage ID_Stage(
		.clk(clk), 
		.rst(rst), 
		.PC_in(PC_IF_Reg), 
		.hazard(hazard),
		.instruction_in(Instruction_IF_Reg), 
		.PC(PC_ID), 
		.status_register_in(actual_status_register_out),
		.wb_dest(dest_reg_MEM_Reg),
		.wb_value(wb_value_WB),
		.wb_enable_WB(wb_enable_MEM_Reg),
		.mem_read_out(mem_read_ID), 
		.mem_write_out(mem_write_ID), 
		.wb_enable_out(wb_enable_ID),
		.execute_command_out(execute_command_ID),
		.branch_taken_out(branch_taken_ID), 
		.status_write_enable_out(status_write_enable_ID),
		.reg_file_out1(reg_file_1_ID), 
		.reg_file_out2(reg_file_2_ID), 
		.two_src(two_src_ID),
		.src1_out(src1_ID),
		.src2_out(src2_ID),
		.immediate_out(immediate_ID),
		.signed_immediate(signed_immediate_ID), 
		.shift_operand(shift_operand_ID),
		.dest_reg_out(dest_reg_ID)
	);

	wire wb_enable_EXE_Reg;
	HazardDetector HazardDetector(
		.src1(src1_ID), 
		.src2(src2_ID),
		.exe_wb_dest(dest_reg_ID_Reg), 
		.mem_wb_dest(dest_reg_EXE_Reg),
		.two_src(two_src_ID), 
		.exe_wb_enable(wb_enable_ID_Reg), 
		.mem_wb_enable(wb_enable_EXE_Reg),

		.hazard(hazard)
	);


	
	assign status_register_ID = actual_status_register_out;
	ID_Stage_Reg ID_Stage_Reg(
		.clk(clk), 
		.rst(rst), 
		.flush(flush), 
		.pc_in(PC_ID), 
		.mem_read_in(mem_read_ID),
		.mem_write_in(mem_write_ID), 
		.wb_enable_in(wb_enable_ID),
		.branch_taken_in(branch_taken_ID), 
		.status_write_enable_in(status_write_enable_ID), 
		.execute_command_in(execute_command_ID), 
		.val_rn_in(reg_file_1_ID), 
		.val_rm_in(reg_file_2_ID),
		.immediate_in(immediate_ID), 
		.signed_immediate_in(signed_immediate_ID),
		.shift_operand_in(shift_operand_ID), 
		.dest_reg_in(dest_reg_ID),
		.status_register_in(status_register_ID), 
		.pc_out(PC_ID_Reg), 
		.mem_read_out(mem_read_ID_Reg),
		.mem_write_out(mem_write_ID_Reg), 
		.wb_enable_out(wb_enable_ID_Reg),
		.branch_taken_out(branch_taken_ID_Reg), 
		.status_write_enable_out(status_write_enable_ID_Reg), 
		.execute_command_out(execute_command_ID_Reg), 
		.val_rn_out(reg_file_1_ID_Reg), 
		.val_rm_out(reg_file_2_ID_Reg),
		.immediate_out(immediate_ID_Reg), 
		.signed_immediate_out(signed_immediate_ID_Reg),
		.shift_operand_out(shift_operand_ID_Reg), 
		.dest_reg_out(dest_reg_ID_Reg),
		.status_register_out(status_register_ID_Reg)
	);

	wire [`REGISTER_LEN - 1 : 0] alu_res_EXE;
	
	wire [3:0] alu_status_bits;
	
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
		.status_bits(alu_status_bits), 
		.alu_res(alu_res_EXE),
		.branch_address(branch_address_EXE)
	);

	
	wire mem_read_EXE_Reg;
	wire mem_write_EXE_Reg;
	wire [`REGISTER_LEN - 1 : 0] alu_res_EXE_Reg;
	wire [`REGISTER_LEN - 1 : 0] val_rm_EXE_Reg;
	
	EXE_Stage_Reg EXE_Stage_Reg(
		.clk(clk),
		.rst(rst),
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

	StatusRegister StatusRegister(
		.clk(clk),
		.rst(rst),
		.ld(status_write_enable_ID_Reg),

		.in(alu_status_bits),
		.out(actual_status_register_out)
	);

	wire [`REGISTER_LEN - 1 : 0] data_mem_MEM;

	MEM_Stage MEM_Stage(
		.clk(clk),
		.rst(rst),
		.pc_in(PC_EXE_Reg),
		.mem_write_in(mem_write_EXE_Reg),
		.mem_read_in(mem_read_EXE_Reg),
		.alu_res_in(alu_res_EXE_Reg),
		.val_rm_in(val_rm_EXE_Reg),

		.data_mem_out(data_mem_MEM),
		.pc_out(PC_MEM)
	);


	
	wire mem_read_MEM_Reg;
	wire [`REGISTER_LEN - 1 : 0] alu_res_MEM_Reg;
	wire [`REGISTER_LEN - 1 : 0] data_mem_MEM_Reg;
	MEM_Stage_Reg MEM_Stage_Reg(
		.clk(clk),
		.rst(rst),
		.pc_in(PC_MEM),
		.wb_enable_in(wb_enable_EXE_Reg),
		.mem_read_in(mem_read_EXE_Reg),
		.alu_res_in(alu_res_EXE_Reg),
		.data_mem_in(data_mem_MEM),
		.dest_reg_in(dest_reg_EXE_Reg),

		.wb_enable_out(wb_enable_MEM_Reg),
		.mem_read_out(mem_read_MEM_Reg),
		.alu_res_out(alu_res_MEM_Reg),
		.data_mem_out(data_mem_MEM_Reg),
		.dest_reg_out(dest_reg_MEM_Reg),
		.pc_out(PC_MEM_Reg)
	);


	
	WB_Stage WB_Stage(
		.clk(clk),
		.rst(rst),
		.pc_in(PC_MEM_Reg),
		.mem_read(mem_read_MEM_Reg),
		.alu_res_in(alu_res_MEM_Reg),
		.data_mem_in(data_mem_MEM_Reg),

		.wb_value(wb_value_WB),
		.pc_out(PC_WB)
	);

endmodule 