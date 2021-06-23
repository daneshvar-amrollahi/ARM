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

	wire [31:0] sram_addr;
    wire [31:0] sram_write_data;
    wire sram_write_en;
    wire sram_read_en;
    wire [63:0] sram_read_data; 
    wire sram_ready;

    SRAM_Controller64 sram_ctrl(
        .clk(clk),
        .rst(rst),
        .write_en(sram_write_en),
        .read_en(sram_read_en),
        .addr(sram_addr), 
        .st_val(sram_write_data),
        .read_data(sram_read_data),
        .ready(sram_ready)
    );

	wire cache_ready;
    cache_controller cache_ctrl(
        .clk(clk),
        .rst(rst),
        .addr(alu_res_in), 
        .write_data(val_rm_in),
        .MEM_R_EN(mem_read_in), 
        .MEM_W_EN(mem_write_in),
        .read_data(data_mem_out),
        .ready(cache_ready),
        .sram_addr(sram_addr),
        .sram_write_data(sram_write_data),
        .sram_write_en(sram_write_en),
        .sram_read_en(sram_read_en),
        .sram_read_data(sram_read_data), 
        .sram_ready(sram_ready)
    );

	assign freeze_MEM = ~cache_ready;
endmodule 