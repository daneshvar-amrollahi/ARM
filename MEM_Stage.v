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

	wire sram_ready;
	wire [63 : 0] SRAM_DQ;
	wire [16 : 0] SRAM_ADDR;
	wire SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N;

	SRAM64 SRAM64(
		.clk(clk),
		.rst(rst),
		.SRAM_WE_N(SRAM_WE_N),
		.SRAM_ADDR(SRAM_ADDR),  
		.SRAM_DQ(SRAM_DQ)
	);
	
	wire sram_write_en, sram_read_en;
	wire [31 : 0] sram_read_data;
	wire [63 : 0] sram_read_data64; 

	wire[3:0] SRAM_ignored_signals;
	wire [31:0] sram_address;
	wire [31:0] sram_write_data;
	SRAM_Controller SRAM_CONTROLLER(
		.clk(clk),
		.rst(rst),
		.write_en(sram_write_en),
		.read_en(sram_read_en),
		.addr(sram_address), 
		.st_val(sram_write_data),
		.read_data(sram_read_data64),
		.ready(sram_ready),
		
		.SRAM_DQ(SRAM_DQ),
		.SRAM_ADDR(SRAM_ADDR),
		.SRAM_UB_N(SRAM_UB_N),
		.SRAM_LB_N(SRAM_LB_N),
		.SRAM_WE_N(SRAM_WE_N),
		.SRAM_CE_N(SRAM_CE_N),
		.SRAM_OE_N(SRAM_OE_N)
	);

	wire cache_ready;
	cache_controller cache_controller(
		.clk(clk), 
		.rst(rst), 
		// inputs and outputs related to the memory stage
		.addr(alu_res_in), 
		.write_data(val_rm_in),

		.MEM_R_EN(mem_read_in), 
		.MEM_W_EN(mem_write_in),

		.read_data(data_mem_out),
		.ready(cache_ready),

		// inputs and outputs related to the SRAM
		.sram_addr(sram_address),
		.sram_write_data(sram_write_data),
		.sram_write_en(sram_write_en),
		.sram_read_en(sram_read_en),
		.sram_read_data(sram_read_data64), 
		.sram_ready(sram_ready)
	);


	assign freeze_MEM = ~cache_ready;
endmodule 