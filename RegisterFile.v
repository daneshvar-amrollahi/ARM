`include "defines.v"

module RegisterFile (
	input clk, rst, 
    input [`REGFILE_ADDRESS_LEN - 1 : 0] src1, src2, Dest_wb,
	input[`REGISTER_LEN - 1:0] Result_wb,
    input writeBackEn,
	output [`REGISTER_LEN - 1:0] reg1, reg2
);
    
    reg[`REGISTER_LEN - 1:0] data[0:`REGISTER_MEM_SIZE - 1];

    integer i = 0;
    always @(negedge clk, posedge rst) begin
		if (rst) begin
            for (i = 0 ; i < `REGISTER_MEM_SIZE ; i = i + 1)
                data[i] <= i;
        end
        else if (writeBackEn) data[Dest_wb] <= Result_wb;
	end

    assign reg1 = data[src1];
    assign reg2 = data[src2];
endmodule 