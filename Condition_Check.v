`include "defines.v"

module Condition_Check (
    input [`CONDITION_LEN - 1:0] cond,
    input [`STATUS_REG_LEN - 1:0] stat_reg,
    output cond_state
    );

    wire z, c, n, v;
    // TODO: order of status registers must be checked.
    assign {z, c, n, v} = status_register;

    reg cond_state_reg;

    always @(cond, z, c, n, v) begin
        cond_state_reg = 1'b0;
        case(cond)
        `EQ : begin
            cond_state_reg = z;
        end

        `NE : begin
            cond_state_reg = ~z;
        end

        `CS_HS : begin
            cond_state_reg = c;
        end

        `CC_LO : begin
            cond_state_reg = ~c;
        end

        `MI : begin
            cond_state_reg = n;
        end

        `PL : begin
            cond_state_reg = ~n;
        end

        `VS : begin
            cond_state_reg = v;
        end

        `VC : begin
            cond_state_reg = ~v;
        end

        `HI : begin
            cond_state_reg = c & ~z;
        end

        `LS : begin
            cond_state_reg = ~c | z;
        end

        `GE : begin
            cond_state_reg = (n & v) | (~n & ~v);
        end

        `LT : begin
            cond_state_reg = (n & ~v) | (~n & v);
        end

        `GT : begin
            cond_state_reg = ~z & ((n & v) | (~n & ~v));
        end

        `LE : begin
            cond_state_reg = z | (n & ~v) | (~n & ~v);
        end

        `AL : begin
            cond_state_reg = 1'b1;
        end
    end

    assign cond_state = cond_state_reg;
endmodule