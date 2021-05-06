`include "defines.v"

module HazardDetector (
    input [`REGFILE_ADDRESS_LEN - 1:0] src1, src2,
    input [`REGFILE_ADDRESS_LEN - 1:0] exe_wb_dest, mem_wb_dest,
    input two_src, 
    input exe_wb_enable, mem_wb_enable,

    output reg hazard
);
  
    always @(*)
    begin
        hazard = 1'b0;
        if ((src1 == exe_wb_dest) && (exe_wb_enable == 1'b1))
            hazard = 1'b1;
        else
        if ((src1 == mem_wb_dest) && (mem_wb_enable == 1'b1))
            hazard = 1'b1;
        else
        if ((src2 == exe_wb_dest) && (exe_wb_enable == 1'b1) && (two_src == 1'b1))
            hazard = 1'b1;
        else
        if ((src2 == mem_wb_dest) && (mem_wb_enable == 1'b1) && (two_src == 1'b1))
            hazard = 1'b1;
        else
            hazard = 1'b0;
    end

endmodule