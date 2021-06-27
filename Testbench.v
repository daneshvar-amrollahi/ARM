`timescale 1ns/1ns
module TB();

	reg clk = 1'b0, rst = 1'b0, frwrd_mode = 1'b1;

	ARM ARM(.clk(clk), .rst(rst), .frwrd_mode(frwrd_mode));

	initial begin
	  	#200
		clk = 1'b0;
		repeat(5000) begin
		  	clk = ~clk;
			#10;
		end
	end

	reg [31:0] instr_cnt;
	initial instr_cnt = 0;
	always @(ARM.IF_Stage.pc_reg_out)
		instr_cnt = instr_cnt + 1;
	
	initial begin
		#10
		rst = 1'b1;
		#140
		rst = 1'b0;
	end

endmodule