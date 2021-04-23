`include "defines.v"

module IF_Stage(
    input clk, reset, freeze, Branch_taken,
    input [`ADDR_LEN - 1:0] BranchAddr,
    output [`ADDR_LEN - 1:0] PC, Instruction
);

    wire[`ADDR_LEN - 1 : 0] pc_in, pc_reg_out, pc_inc_out;

    register #(.WORD_LEN(`ADDR_LEN)) pc_reg(.clk(clk), .rst(reset),
               .ld(~freeze), .in(pc_in), .out(pc_reg_out));

    incrementer #(.WORD_LEN(`ADDR_LEN)) pc_inc(.in(pc_reg_out), .out(pc_inc_out));

    mux2to1 #(.WORD_LEN(`ADDR_LEN)) pc_mux(.a(pc_inc_out), .b(BranchAddr), 
                .sel_a(~Branch_taken), .sel_b(Branch_taken), .out(pc_in));

    reg[`INSTRUCTION_LEN - 1:0] instruction_write_data;
	wire[`INSTRUCTION_LEN - 1:0] read_data;
	reg mem_read = 1'b1;
	reg mem_write = 1'b0;
	reg[`INSTRUCTION_LEN - 1:0] instruction;

    memory inst_mem(.clk(clk), .reset(reset), .addr(pc_reg_out), 
                    .write_data(instruction_write_data), .mem_read(mem_read), 
                    .mem_write(mem_write), .read_data(read_data));
    
    assign Instruction = read_data;
    assign PC = pc_inc_out;
endmodule