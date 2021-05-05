`include "defines.v"

module MEM_Stage(
	clk,
	rst,
	pc_in,
	mem_write_in,
	mem_read_in,
	alu_res_in,
	val_rm_in,

	data_mem_out,
	pc_out
);
	input clk;
	input rst;
	input [`ADDRESS_LEN - 1 : 0] pc_in;
	input mem_write_in;
	input mem_read_in;
	input [`REGISTER_LEN - 1 : 0] alu_res_in;
	input [`REGISTER_LEN - 1 : 0] val_rm_in;

	output [`REGISTER_LEN - 1 : 0] data_mem_out;
	output [`ADDRESS_LEN - 1 : 0] pc_out;
	assign pc_out = pc_in;


	memory data_mem(
		.clk(clk), 
		.rst(rst), 
		.addr(alu_res_in), 
        .write_data(val_rm_in), 
		.mem_read(mem_read_in), 
        .mem_write(mem_write_in),
		.read_data(data_mem_out)
	);

endmodule 