
module Condition_Check (
    input [`CONDITION - 1:0] cond,
    input [3:0] status_register,
    output cond_state
    );

    wire z, c, n, v;
    // TODO: order of status registers must be checked.
    assign {z, c, n, v} = status_register;

    always @(cond) begin

        case(cond)
        `EQ : begin
            cond_state <= z;
        end

        `NE : begin
            cond_state <= ~z;
        end

        `CS_HS : begin
            cond_state <= c;
        end

        `CC_LO : begin
            cond_state <= ~c;
        end

        `MI : begin
            cond_state <= n;
        end

        `PL : begin
            cond_state <= ~n;
        end

        `VS : begin
            cond_state <= v;
        end

        `VC : begin
            cond_state <= ~v;
        end

        `HI : begin
            cond_state <= c & ~z;
        end

        `LS : begin
            cond_state <= ~c | z;
        end

        `GE : begin
            cond_state <= (n & v) | (~n & ~v);
        end

        `LT : begin
            cond_state <= (n & ~v) | (~n & v);
        end

        `GT : begin
            cond_state <= ~z & ((n & v) | (~n & ~v));
        end

        `LE : begin
            cond_state <= z | (n & ~v) | (~n & ~v);
        end

        /*`AL : begin
            TODO
        end */
    end
endmodule 