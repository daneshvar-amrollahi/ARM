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
	pc_out,

	alu_res_out_MEM,
	freeze_MEM
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
	output freeze_MEM;
	assign pc_out = pc_in;

	//forwarding:
	output [`REGISTER_LEN - 1 : 0] alu_res_out_MEM;
	assign alu_res_out_MEM = alu_res_in;

	/*
	memory data_mem(
		.clk(clk), 
		.rst(rst), 
		.addr(alu_res_in), 
        .write_data(val_rm_in), 
		.mem_read(mem_read_in), 
        .mem_write(mem_write_in),
		.read_data(data_mem_out)
	);
	*/

	wire sram_ready;
	wire [31 : 0] SRAM_DQ;
	wire [16 : 0] SRAM_ADDR;
	wire SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N;
	SRAM_Controller SRAM_CONTROLLER(
		.clk(clk),
		.rst(rst),
		.write_en(mem_write_in),
		.read_en(mem_read_in),
		.addr(alu_res_in), 
		.st_val(val_rm_in),
		.read_data(data_mem_out),
		.ready(sram_ready),
		
		.SRAM_DQ(SRAM_DQ),
		.SRAM_ADDR(SRAM_ADDR),
		.SRAM_UB_N(SRAM_UB_N),
		.SRAM_LB_N(SRAM_LB_N),
		.SRAM_WE_N(SRAM_WE_N),
		.SRAM_CE_N(SRAM_CE_N),
		.SRAM_OE_N(SRAM_OE_N)
	);

	SRAM SRAM (
		.clk(clk),
		.rst(rst),
		.SRAM_WE_N(SRAM_WE_N),
		.SRAM_ADDR(SRAM_ADDR),
		.SRAM_DQ(SRAM_DQ)
	);

	assign freeze_MEM = ~sram_ready;
endmodule 