`include "defines.v"
`timescale 1ns/1ns

module SRAM64(
    clk,
    rst,
    SRAM_WE_N,
    SRAM_ADDR,  
    SRAM_DQ 
);
    input clk;
    input rst;
    input SRAM_WE_N;
    input [16 : 0] SRAM_ADDR; 
    inout [63 : 0] SRAM_DQ;  


    reg [31 : 0] memory [0 : 511]; // 65535

    assign #30 SRAM_DQ = SRAM_WE_N ? {memory[{SRAM_ADDR[16:1], 1'b1}], memory[{SRAM_ADDR[16:1], 1'b0}]}: 64'bz;

    always @(posedge clk) begin
        if(~SRAM_WE_N) begin
            // $display("SRAM WRITE mem[%d] = %d", SRAM_ADDR, SRAM_DQ);
            memory[SRAM_ADDR] <= SRAM_DQ[31 : 0];
        end
    end

    integer i;
    initial for (i = 0; i < 512; i = i + 1)
        memory[i] = 32'b0;
endmodule