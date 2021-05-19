`include "defines.v"

module EXE_Stage(
	clk, 
	rst,
	pc_in, 
	wb_enable_in, 
	mem_read_in, 
	mem_write_in, 
	status_register_write_enable, 
	branch_taken_in, 
	execute_command_in,
	immediate_in, 
	signed_immediate_24_in, 
	shift_operand_in, 
	val_rn_in, 
	val_rm_in, 
	status_register_in,

	pc_out,
	status_bits, 
	alu_res,
	branch_address,
	
	alu_res_in_MEM,
	wb_value_WB,
	alu_mux_src_1_sel,
	alu_mux_src_2_sel,

	val_rm_mux_out
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

	// forwarding requirements
	input [`REGISTER_LEN - 1 : 0] alu_res_in_MEM;
	input [`REGISTER_LEN - 1 : 0] wb_value_WB;
	
	input [1:0] alu_mux_src_1_sel;
	input [1:0] alu_mux_src_2_sel;

	output [`ADDRESS_LEN - 1: 0] pc_out;
	output [3:0] status_bits;
	output [`REGISTER_LEN - 1 : 0] alu_res;
	output [`ADDRESS_LEN - 1 : 0] branch_address;
	
	// forwarding requirements
	output [`REGISTER_LEN - 1 : 0] val_rm_mux_out;
	
	assign pc_out = pc_in;

	wire [`REGISTER_LEN - 1 : 0] alu_out;
	wire [`REGISTER_LEN - 1 : 0] val2out;
	
	wire [`REGISTER_LEN - 1 : 0] alu_mux_rn_out;
	wire [`REGISTER_LEN - 1 : 0] alu_mux_rm_out;
	
	ALU alu(
    	.alu_in1(alu_mux_rn_out), 
		.alu_in2(val2out),
    	.alu_command(execute_command_in),
    	.status_register(status_register_in),

    	.alu_out(alu_out),
    	.alu_status_register_out(status_bits)
    );
	assign alu_res = alu_out;

	wire is_mem_command;
	assign is_mem_command = mem_read_in | mem_write_in;
	
	// wire alu_res_in_MEM;

	mux_3_to_1 #(REGISTER_LEN) alu_mux_src_1(
		.in1(val_rn_in)
		.in2(alu_res_in_MEM),
		.in3(wb_value_WB),
		.sel(alu_mux_src_1_sel),
		.out(alu_mux_rn_out)
	);

	mux_3_to_1 #(REGISTER_LEN) alu_mux_src_2(
		.in1(val_rm_in)
		.in2(alu_res_in_MEM),
		.in3(wb_value_WB),
		.sel(alu_mux_src_2_sel),
		.out(alu_mux_rm_out)
	);

	assign val_rm_mux_out = alu_mux_rm_out;

	val2gen v2g(
		.val_rm(alu_mux_rm_out),
        .shift_operand(shift_operand_in),
        .immediate(immediate_in), 
		.is_mem_command(is_mem_command),

        .val2_out(val2out)
		);

	wire [`REGISTER_LEN - 1 : 0] adder_out;
	wire [`REGISTER_LEN - 1 : 0] sign_immediate_extended = { {8{signed_immediate_24_in[23]}}, signed_immediate_24_in}; 
	assign adder_out = pc_in + (sign_immediate_extended << 2);	
	assign branch_address = adder_out;

endmodule 