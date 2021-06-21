`include "defines.v"
`timescale 1ns/1ns

module test_cache();
    reg clk, rst;
    reg [31:0] addr;
    reg [31:0] write_data;
    reg mem_read, mem_write;

    wire [31:0] read_data;
    wire ready;

    // inputs and outputs related to the SRAM
    wire [31:0] sram_addr;
    wire [31:0] sram_write_data;
    wire sram_write_en;
    wire sram_read_en;
    wire [63:0] sram_read_data; 
    wire sram_ready;

    cache_controller cache_ctrl(
        .clk(clk),
        .rst(rst),
        .addr(addr), 
        .write_data(write_data),
        .MEM_R_EN(mem_read), 
        .MEM_W_EN(mem_write),
        .read_data(read_data),
        .ready(ready),
        .sram_addr(sram_addr),
        .sram_write_data(sram_write_data),
        .sram_write_en(sram_write_en),
        .sram_read_en(sram_read_en),
        .sram_read_data(sram_read_data), 
        .sram_ready(sram_ready)
    );

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

    initial clk = 1'b0;
    always #10 clk = ~clk;

    initial begin
        rst = 1'b1;
        #50 rst = 1'b0;
        addr = 32'd1024;
        write_data = 32'd97690;
        {mem_read, mem_write} = 2'b01;
        #140 mem_write = 1'b0;
        write_data = 32'd31415;
        mem_read = 1'b1;
        #200 {mem_read, mem_write} = 2'b01;
        addr = 32'd1036;
        #500 $stop;

    end
endmodule