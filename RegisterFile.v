`include "defines.v"

module RegisterFile (
	input clk, rst, 
    input [`REGFILE_ADDRESS_LEN - 1 : 0] src1, src2, Dest_wb, //Dest_wb: register to be written back
	input[`REGISTER_LEN - 1:0] Result_wb, //value to be written back
    input writeBackEn,
	output [`REGISTER_LEN - 1:0] reg1, reg2
);
    
    reg[`REGISTER_LEN - 1:0] data[0:`REGISTER_MEM_SIZE - 1];

    //  integer i = 0;
    always @(negedge clk, posedge rst) begin
		if (rst) begin
            data[0] <= `REGISTER_LEN'd0;
            data[1] <= `REGISTER_LEN'd1;
            data[2] <= `REGISTER_LEN'd2;
            data[3] <= `REGISTER_LEN'd3;
            data[4] <= `REGISTER_LEN'd4;
            data[5] <= `REGISTER_LEN'd5;
            data[6] <= `REGISTER_LEN'd6;
            data[7] <= `REGISTER_LEN'd7;
            data[8] <= `REGISTER_LEN'd8;
            data[9] <= `REGISTER_LEN'd9;
            data[10] <= `REGISTER_LEN'd10;
            data[11] <= `REGISTER_LEN'd11;
            data[12] <= `REGISTER_LEN'd12;
            data[13] <= `REGISTER_LEN'd13;
            data[14] <= `REGISTER_LEN'd14;
            data[15] <= `REGISTER_LEN'd15;
            /*for (i = 0 ; i < `REGISTER_MEM_SIZE ; i = i + 1)
                data[i] <= i;
            */
        end
        else if (writeBackEn) data[Dest_wb] <= Result_wb;
	end

    assign reg1 = data[src1];
    assign reg2 = data[src2];
endmodule 