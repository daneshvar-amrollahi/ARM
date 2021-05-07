`include "defines.v"
`include "inst_defs.v"

module Condition_Check (
    cond,
    stat_reg,
    cond_state
);

    input [`CONDITION_LEN - 1:0] cond;
    input [`STATUS_REG_LEN - 1:0] stat_reg;
    output cond_state;

    wire z, c, n, v;
    assign {z, c, n, v} = stat_reg;

    reg cond_state_reg;

    always @(cond, z, c, n, v) begin
        cond_state_reg = 1'b0;
        case(cond)
            4'b0000 : begin
                cond_state_reg = z;
            end

            4'b0001 : begin
                cond_state_reg = ~z;
            end

            4'b0010 : begin
                cond_state_reg = c;
            end

            4'b0011 : begin
                cond_state_reg = ~c;
            end

            4'b0100 : begin
                cond_state_reg = n;
            end

            4'b0101 : begin
                cond_state_reg = ~n;
            end

            4'b0110 : begin
                cond_state_reg = v;
            end

            4'b0111 : begin
                cond_state_reg = ~v;
            end

            4'b1000 : begin
                cond_state_reg = c & ~z;
            end

            4'b1001 : begin
                cond_state_reg = ~c | z;
            end

            4'b1010 : begin
                cond_state_reg = (n & v) | (~n & ~v);
            end

            4'b1011 : begin
                cond_state_reg = (n & ~v) | (~n & v);
            end

            4'b1100 : begin
                cond_state_reg = ~z & ((n & v) | (~n & ~v));
            end

            4'b1101 : begin
                cond_state_reg = z | (n & ~v) | (~n & ~v);
            end

            4'b1110 : begin
                cond_state_reg = 1'b1;
            end
        endcase
    end
    
    assign cond_state = cond_state_reg;
endmodule