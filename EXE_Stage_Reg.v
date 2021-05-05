`include "defines.v"	

module EXE_Stage_Reg(
	clk,
	rst,
	pc_in,
	wb_enable_in,
	mem_read_in,
	mem_write_in,
	alu_res_in,
	val_rm_in,
	dest_in,
	
	pc_out,
	wb_enable_out,
	mem_read_out,
	mem_write_out,
	alu_res_out,
	val_rm_out,
	dest_out
);

	input clk, rst;
	input [`ADDRESS_LEN - 1 : 0] pc_in;
	input wb_enable_in, mem_read_in, mem_write_in;
	input [`REGISTER_LEN - 1 : 0] alu_res_in, val_rm_in;
	input [`REGFILE_ADDRESS_LEN - 1 : 0] dest_in;
	
	output reg[`ADDRESS_LEN - 1 : 0] pc_out;
	output reg wb_enable_out, mem_read_out, mem_write_out;
	output reg [`REGISTER_LEN - 1 : 0] alu_res_out, val_rm_out;
	output reg [`REGFILE_ADDRESS_LEN - 1 : 0] dest_out;

	always @(posedge clk, posedge rst) 
        if (rst)
		begin
            pc_out <= `ADDRESS_LEN'b0;
			{wb_enable_out, mem_read_out, mem_write_out} <= {3'b0};
			{alu_res_out, val_rm_out} <= {`REGISTER_LEN'b0, `REGISTER_LEN'b0};
			dest_out <= `REGFILE_ADDRESS_LEN'b0;
		end
        else
		begin
            pc_out <= pc_in;
			{wb_enable_out, mem_read_out, mem_write_out} <= {wb_enable_in, mem_read_in, mem_write_in};
			{alu_res_out, val_rm_out} <= {alu_res_in, val_rm_in};
			dest_out <= dest_in;
		end
endmodule