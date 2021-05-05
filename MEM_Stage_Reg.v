`include "defines.v"

module MEM_Stage_Reg(
	clk,
	rst,
	pc_in,
	wb_enable_in,
	mem_read_in,
	alu_res_in,
	data_mem_in,
	dest_reg_in,

	wb_enable_out,
	mem_read_out,
	alu_res_out,
	data_mem_out,
	dest_reg_out,
	pc_out
);

	input clk;
	input rst;
	input [`ADDRESS_LEN - 1 : 0] pc_in;
	input wb_enable_in;
	input mem_read_in;
	input [`REGISTER_LEN - 1 : 0] alu_res_in;
	input [`REGISTER_LEN - 1 : 0] data_mem_in;
	input [`REGFILE_ADDRESS_LEN - 1 : 0] dest_reg_in;
	
	output reg wb_enable_out;
	output reg mem_read_out;
	output reg [`REGISTER_LEN - 1 : 0] alu_res_out;
	output reg [`REGISTER_LEN - 1 : 0] data_mem_out;
	output reg [`REGFILE_ADDRESS_LEN - 1 : 0] dest_reg_out;
	output reg [`ADDRESS_LEN - 1 : 0] pc_out;

	always @(posedge clk, posedge rst) 
        if (rst)
		begin
			wb_enable_out <= 1'b0;
			mem_read_out <= 1'b0;
			alu_res_out <= `REGISTER_LEN'b0;
			data_mem_out <= `REGISTER_LEN'b0;
			dest_reg_out <= `REGFILE_ADDRESS_LEN'b0;
			pc_out <= `ADDRESS_LEN'b0;
		end
        else
		begin
            wb_enable_out <= wb_enable_in;
			mem_read_out <= mem_read_in;
			alu_res_out <= alu_res_in;
			data_mem_out <= data_mem_in;
			dest_reg_out <= dest_reg_in;
			pc_out <= pc_in;
		end
endmodule