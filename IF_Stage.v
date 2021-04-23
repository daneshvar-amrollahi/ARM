`define ADDR_LEN 32

module IF_Stage(
    input clk, reset, freeze, Branch_taken,
    input [`ADDR_LEN - 1:0] BranchAddr,
    output [`ADDR_LEN - 1:0] PC, Instruction
);
    register #(.WORD_LEN(`ADDR_LEN)) pc_reg(.clk(clk), .rst(reset),
               .ld(~freeze), .in(pc_in), .out(pc_out));

    incrementer #(.WORD_LEN(`ADDR_LEN)) pc_inc(.in(pc_out), .out(pc_inc_out));
endmodule