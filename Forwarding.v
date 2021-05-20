`include "defines.v"

module Forwarding 
(
    en_forwarding,
	WB_wb_en, 
    MEM_wb_en,
    MEM_dst, 
    WB_dst, 
    src1_in, 
    src2_in,

    sel_src1, 
    sel_src2,
    ignore_hazard

);
    input en_forwarding;
	input WB_wb_en, MEM_wb_en;
    input [`REGFILE_ADDRESS_LEN - 1:0] MEM_dst, WB_dst, src1_in, src2_in;
	
    output reg [1:0] sel_src1, sel_src2;
    output reg ignore_hazard;

	always@(*) begin
		sel_src1 = 2'b0;
		sel_src2 = 2'b0;
        ignore_hazard = 1'b0;
        
        if (en_forwarding && WB_wb_en) begin
            if (WB_dst == src1_in) begin
                sel_src1 = `FORW_SEL_FROM_WB; //2'b10
                ignore_hazard = 1'b1;
            end
            
            if (WB_dst == src2_in) begin
                sel_src2 = `FORW_SEL_FROM_WB; //2/b10
                ignore_hazard = 1'b1;
            end
        end

        if (en_forwarding && MEM_wb_en) begin
            if (MEM_dst == src1_in) begin
                sel_src1 = `FORW_SEL_FROM_MEM;
                ignore_hazard = 1'b1;
            end
            
            if (MEM_dst == src2_in) begin
                sel_src2 = `FORW_SEL_FROM_MEM;
                ignore_hazard = 1'b1;
            end
        end
	end
endmodule