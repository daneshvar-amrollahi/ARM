`include "defines.v"

module ID_Stage_Reg(
	clk, 
	rst, 
	flush, 
	pc_in, 
	mem_read_in, 
	mem_write_in, 
	wb_enable_in,
	branch_taken_in, 
	status_write_enable_in, 
	execute_command_in, 
	val_rn_in, 
	val_rm_in,
	immediate_in, 
	signed_immediate_in, 
	shift_operand_in, 
	dest_reg_in,
	status_register_in, 
	pc_out, 
	mem_read_out, 
	mem_write_out, 
	wb_enable_out,
	branch_taken_out, 
	status_write_enable_out, 
	execute_command_out, 
	val_rn_out,
	val_rm_out,
	immediate_out, 
	signed_immediate_out, 
	shift_operand_out, 
	dest_reg_out,
	status_register_out
);
	input clk, rst, flush;
	input[`ADDRESS_LEN - 1: 0] pc_in;
	input mem_read_in, mem_write_in, wb_enable_in;
	input branch_taken_in, status_write_enable_in;
	input [`EXECUTE_COMMAND_LEN - 1:0] execute_command_in;
	input [`REGISTER_LEN - 1:0] val_rn_in, val_rm_in;
	input immediate_in;
	input [23:0] signed_immediate_in;
	input [`SHIFT_OPERAND_LEN - 1:0] shift_operand_in;
	input [`REGFILE_ADDRESS_LEN - 1:0] dest_reg_in;
	input [3:0] status_register_in;

	output reg[`ADDRESS_LEN - 1: 0] pc_out;
	output reg mem_read_out, mem_write_out, wb_enable_out;
	output reg branch_taken_out, status_write_enable_out;
	output reg [`EXECUTE_COMMAND_LEN - 1:0] execute_command_out;
	output reg [`REGISTER_LEN - 1:0] val_rn_out, val_rm_out;
	output reg immediate_out;
	output reg [23:0] signed_immediate_out;
	output reg [`SHIFT_OPERAND_LEN - 1:0] shift_operand_out;
	output reg [`REGFILE_ADDRESS_LEN - 1:0] dest_reg_out;
	output reg [3:0] status_register_out;


	always @(posedge clk, posedge rst) 
        if (rst) begin
			pc_out <= `ADDRESS_LEN'b0;
			{mem_read_out, mem_write_out, wb_enable_out} <= {3'b0};
			{branch_taken_out, status_write_enable_out} <= {2'b0};
			execute_command_out <= `EXECUTE_COMMAND_LEN'b0;
			{val_rn_out, val_rm_out} <= {`REGISTER_LEN'b0, `REGISTER_LEN'b0};
			immediate_out <= 1'b0;
			signed_immediate_out <= 24'b0;
			shift_operand_out <= `SHIFT_OPERAND_LEN'b0;
			dest_reg_out <= `REGFILE_ADDRESS_LEN'b0;
			status_register_out <= 4'b0;
		end
        else
		begin
			if (flush)
			begin
				pc_out <= `ADDRESS_LEN'b0;
				{mem_read_out, mem_write_out, wb_enable_out} <= {3'b0};
				{branch_taken_out, status_write_enable_out} <= {2'b0};
				execute_command_out <= `EXECUTE_COMMAND_LEN'b0;
				{val_rn_out, val_rm_out} <= {`REGISTER_LEN'b0, `REGISTER_LEN'b0};
				immediate_out <= 1'b0;
				signed_immediate_out <= 24'b0;
				shift_operand_out <= `SHIFT_OPERAND_LEN'b0;
				dest_reg_out <= `REGFILE_ADDRESS_LEN'b0;
				status_register_out <= 4'b0;
			end
			else
			begin
			  	pc_out <= pc_in;
				{mem_read_out, mem_write_out, wb_enable_out} <= {mem_read_in, mem_write_in, wb_enable_in};
				{branch_taken_out, status_write_enable_out} <= {branch_taken_in, status_write_enable_in};
				execute_command_out <= execute_command_in;
				{val_rn_out, val_rm_out} <= {val_rn_in, val_rm_in};
				immediate_out <= immediate_in;
				signed_immediate_out <= signed_immediate_in;
				shift_operand_out <= shift_operand_in;
				dest_reg_out <= dest_reg_in;
				status_register_out <= status_register_in;
            	
			end
		end
endmodule