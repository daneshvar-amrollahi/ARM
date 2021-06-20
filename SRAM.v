`include "defines.v"

`timescale 1ns/1ns

module SRAM_Controller(
    clk,
    rst,
    write_en,
    read_en,
    addr, 
    st_val,
    read_data,
    ready,
    
    SRAM_DQ,
    SRAM_ADDR,
    SRAM_UB_N,
    SRAM_LB_N,
    SRAM_WE_N,
    SRAM_CE_N,
    SRAM_OE_N
);
    input clk, rst;
    input write_en, read_en;
    input [31 : 0] addr;
    input [31 : 0] st_val;
    output [63 : 0] read_data;
    output ready;

    inout [63 : 0] SRAM_DQ;
    output [16 : 0] SRAM_ADDR;
    output SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N;

    assign SRAM_UB_N = 1'b0;
    assign SRAM_LB_N = 1'b0;
    assign SRAM_CE_N = 1'b0;
    assign SRAM_OE_N = 1'b0;

    assign SRAM_WE_N = write_en ? 1'b0 : 1'b1;
    assign SRAM_ADDR = addr[18 : 2];
    assign SRAM_DQ = write_en ? st_val : 64'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz;

    assign read_data = SRAM_DQ;

    reg [2 : 0] cnt;
	reg [1 : 0] ps, ns;
    reg cnt_enable;

    parameter [1 : 0] IDLE = 2'b0;
    parameter [1 : 0] READ_WAIT = 2'b01;
    parameter [1 : 0] WRITE_WAIT = 2'b10;

    always @(posedge clk, posedge rst) begin
        if (rst)
            ps <= 3'b0;
        else
            ps <= ns;
    end

    always @(*) begin
        case (ps)
            IDLE: begin
                if (read_en)
                    ns = READ_WAIT;
                else if (write_en)
                    ns = WRITE_WAIT;
                else
                    ns = IDLE;
            end

            READ_WAIT: begin
                if (cnt != `SRAM_CNT)
                    ns = READ_WAIT;
                else
                    ns = IDLE;
            end

            WRITE_WAIT: begin
                if (cnt != `SRAM_CNT)
                        ns = WRITE_WAIT;
                    else
                        ns = IDLE;
            end
        endcase
    end

    always @(ps) begin
        cnt_enable = 1'b0;
        case (ps)
            IDLE: begin end
            READ_WAIT: cnt_enable = 1'b1;
            WRITE_WAIT: cnt_enable = 1'b1;
        endcase
    end

    assign ready = ~(read_en || write_en) ? 1'b1 : (cnt == `SRAM_CNT);

    always @(posedge clk, posedge rst) begin
        if (rst)
            cnt <= 3'b0;
        else if (cnt_enable) begin
            if (cnt == `SRAM_CNT + 1)
                cnt <= 3'b0;
            else
                cnt <= cnt + 1;
        end
    end

endmodule

module SRAM (
	clk,
	rst,
	SRAM_WE_N,
	SRAM_ADDR,
	SRAM_DQ
);

    input clk, rst;
    input SRAM_WE_N;
    input [16 : 0] SRAM_ADDR;
    inout [31 : 0] SRAM_DQ;

	reg [31 : 0] memory[0 : 511];

	assign #30 SRAM_DQ = SRAM_WE_N ? memory[SRAM_ADDR] : 32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz;
	
    always @(posedge clk) begin
		if (~SRAM_WE_N)
			memory[SRAM_ADDR] <= SRAM_DQ;
	end

endmodule

module test_sram();
    
    reg clk = 0;
    reg rst;
    reg write_en = 0;
    reg read_en = 0;
    reg [31 : 0] addr; 
    reg [31 : 0] st_val;
    wire [31 : 0] read_data;
    wire ready;
    
    wire [31 : 0] SRAM_DQ;
    wire [16 : 0] SRAM_ADDR;
    wire SRAM_UB_N;
    wire SRAM_LB_N;
    wire SRAM_WE_N;
    wire SRAM_CE_N;
    wire SRAM_OE_N;

    SRAM_Controller sram_ctrl(
        .clk(clk),
        .rst(rst),
        .write_en(write_en),
        .read_en(read_en),
        .addr(addr), 
        .st_val(st_val),
        .read_data(read_data),
        .ready(ready),
        .SRAM_DQ(SRAM_DQ),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_UB_N(SRAM_UB_N),
        .SRAM_LB_N(SRAM_LB_N),
        .SRAM_WE_N(SRAM_WE_N),
        .SRAM_CE_N(SRAM_CE_N),
        .SRAM_OE_N(SRAM_OE_N)
    );

    SRAM sram(
        .clk(clk),
        .rst(rst),
        .SRAM_WE_N(SRAM_WE_N),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_DQ(SRAM_DQ)
    );

    always #(10) clk = ~clk;

    initial begin
        rst = 1'b1;
        addr = 0;
        st_val = 0;
        #50 rst = 1'b0;

        #50 addr = 32'd1024;
        st_val = 32'd50;
        {read_en, write_en} = 2'b01;
        
        #200 {read_en, write_en} = 2'b10;

        #400 $stop;

    end

endmodule