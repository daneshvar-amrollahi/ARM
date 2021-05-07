`include "defines.v"

module IF_Stage(
    clk, 
    rst, 
    freeze, 
    branch_taken,
    branch_addr,
    instruction,
    PC
);

    input clk, rst, freeze, branch_taken;
    input [`ADDRESS_LEN - 1:0] branch_addr;
    output [`INSTRUCTION_LEN - 1:0] instruction;
    output [`ADDRESS_LEN - 1 : 0] PC;

    wire[`ADDRESS_LEN - 1 : 0] pc_in, pc_reg_out, pc_inc_out;

    register #(.WORD_LEN(`ADDRESS_LEN)) pc_reg(
        .clk(clk), 
        .rst(rst),
        .ld(~freeze), 
        .in(pc_in), 
        .out(pc_reg_out)
    );

    incrementer #(.WORD_LEN(`ADDRESS_LEN)) pc_inc(
        .in(pc_reg_out), 
        .out(pc_inc_out)
    );

    mux2to1 #(.WORD_LEN(`ADDRESS_LEN)) pc_mux(
        .a(pc_inc_out), 
        .b(branch_addr), 
        .sel_a(~branch_taken), 
        .sel_b(branch_taken), 
        .out(pc_in)
    );

    reg [`INSTRUCTION_LEN - 1:0] instruction_write_data;
	wire [`INSTRUCTION_LEN - 1:0] read_data;
	reg mem_read = 1'b1;
	reg mem_write = 1'b0;

    memory inst_mem(
        .clk(clk), 
        .rst(rst), 
        .addr(pc_reg_out), 
        .write_data(instruction_write_data), 
        .mem_read(mem_read), 
        .mem_write(mem_write), 
        .read_data(read_data)
    );
    
    assign instruction = read_data;
    assign PC = pc_inc_out;
endmodule