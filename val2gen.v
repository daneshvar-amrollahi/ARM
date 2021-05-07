`include "defines.v"

module val2gen(
		input [`REGISTER_LEN - 1:0] val_rm,
        input [11:0] shift_operand,
        input immediate, is_mem_command,

        output reg [`REGISTER_LEN - 1:0] val2_out
		);


    reg [2 * (`REGISTER_LEN) - 1 : 0] tmp;
    integer i;
    always @(val_rm, shift_operand, immediate, is_mem_command) begin
        val2_out = `REGISTER_LEN'b0;
        tmp = 0;
        if (is_mem_command == 1'b0) begin

            if (immediate == 1'b1) begin
                val2_out = {24'b0 ,shift_operand[7 : 0]};
                

                tmp = {val2_out, val2_out} >> (({{2'b0},shift_operand[11 : 8]}) << 1);
                val2_out = tmp[`REGISTER_LEN - 1 : 0];

            end 
            else 
            if(immediate == 1'b0 && shift_operand[4] == 0) begin
                case(shift_operand[6:5])
                    `LSL_SHIFT : begin
                        val2_out = val_rm << shift_operand[11 : 7];
                    end
                    `LSR_SHIFT : begin
                        val2_out = val_rm >> shift_operand[11 : 7];
                    end
                    `ASR_SHIFT : begin
                        val2_out = val_rm >>> shift_operand[11 : 7];
                    end
                    `ROR_SHIFT : begin
                        tmp = {val_rm, val_rm} >> (shift_operand[11 : 7]);
                        val2_out = tmp[`REGISTER_LEN - 1 : 0];
                    end
                endcase
            end
        end 
        else //is mem_command
        begin
            val2_out = { {20{shift_operand[11]}} , shift_operand[11 : 0]}; 
        end

    end
endmodule 