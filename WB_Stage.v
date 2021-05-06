`include "defines.v"

module WB_Stage(
	clk,
	rst,
	pc_in,
	mem_read,
	alu_res_in,
	data_mem_in,

	wb_value,
	pc_out
);
	input clk;
	input rst;
	input [`ADDRESS_LEN - 1 : 0] pc_in;
	input mem_read;
	input [`REGISTER_LEN - 1 : 0] alu_res_in;
	input [`REGISTER_LEN - 1 : 0] data_mem_in;

	output [`REGISTER_LEN - 1 : 0] wb_value;
	output [`ADDRESS_LEN - 1 : 0] pc_out;
	assign pc_out = pc_in;

	mux2to1  #(.WORD_LEN(`REGISTER_LEN)) wb_stage_mux(
		.a(data_mem_in), .sel_a(mem_read),
		.b(alu_res_in), .sel_b(~mem_read),
		.out(wb_value)
	);
endmodule 