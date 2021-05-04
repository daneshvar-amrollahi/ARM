`include "defines.v"

module val2gen(
		input [`REGISTER_LEN - 1:0] val_rm,
        input [11:0] shift_operand,
        input immediate, is_mem_command,

        output reg [`REGISTER_LEN - 1:0] val2_out,
		);


    reg [2 * (`REGISTER_LEN) - 1 : 0] tmp;
    always @(val_rm, shift_operand, immediate, is_mem_command) begin
        integer i;
        val2_out = {20'b0, shift_operand};
        tmp = 0;
        if (is_mem_command == 1'b0) begin

            if (immediate == 1'b1) begin
                /*
                for (i = 0; i < shift_operand[11:8] ; i = i + 1) begin
                    val2_out = {val2_out[1], val2_out[0], val2_out[31:2]}; 
                end 
                */

                tmp = {val2_out, val2_out} >> (shift_operand[11 : 8] << 1);
                val2_out = tmp[`REGISTER_LEN - 1 : 0];

            end 
            else 
            if(immediate == 1'b0 && shift_operand[4] == 0) begin
                case(shift_operand[6:5])
                    `LSL_SHIFT_STATE : begin
                        val2_out = val2_out << shift_operand[11 : 7];
                    end
                    `LSR_SHIFT_STATE : begin
                        val2_out = val2_out >> shift_operand[11 : 7];
                    end
                    `ASR_SHIFT_STATE : begin
                        val2_out = val2_out >>> shift_operand[11 : 7];
                    end
                    `ROR_SHIFT_STATE : begin
                        tmp = {val2_out, val2_out} >> (shift_operand[11 : 7]);
                        val2_out = tmp[`REGISTER_LEN - 1 : 0];
                    end
                endcase
            end
        end 


    end
endmodule 