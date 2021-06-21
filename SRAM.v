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
    assign SRAM_DQ = write_en ? {32'b0, st_val} : 64'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz;

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