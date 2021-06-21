`include "defines.v"

module cache(
    clk,
    rst,
    address,
    write_data,
    cache_read_en,
    cache_write_en,
    invalidate,
    read_data,
    hit
);
    input clk, rst;
    input [16:0] address;
    input [63:0] write_data;

    input cache_read_en, cache_write_en, invalidate;
    output [31:0] read_data;
    output hit;

    wire [9:0] tag;
    wire col;
    wire [5:0] row;

    assign {tag, row, col} = address;

    reg [31:0] data_0 [0:1][0:63];
    reg [31:0] data_1 [0:1][0:63];

    reg [9:0] tag_0 [0:63];
    reg [9:0] tag_1 [0:63];

    reg valid_0 [0:63];
    reg valid_1 [0:63];

    reg lru [0:63];

    wire set_0_hit, set_1_hit;
    assign set_0_hit = (tag_0[row] == tag) & valid_0[row];
    assign set_1_hit = (tag_1[row] == tag) & valid_1[row];

    mux2to1 #(.WORD_LEN(32)) read_data_mux(
        .a(data_0[col][row]),
        .b(data_1[col][row]),
        .sel_a(set_0_hit),
        .sel_b(set_1_hit),
        .out(read_data)
    );

    assign hit = set_0_hit | set_1_hit;

    always @(posedge clk)
    if (cache_read_en & hit)
        lru[row] <= set_0_hit ? 1'b0: 1'b1;

    always @(posedge clk) begin
        if (invalidate & hit) begin
            if (set_0_hit) begin
                valid_0[row] <= 1'b0;
                lru[row] <= 1'b1;
            end
            
            else if (set_1_hit) begin
                valid_1[row] <= 1'b0;
                lru[row] <= 1'b0;
            end
        end
    end


    always @(posedge clk) begin
        if (cache_write_en) begin
            if (~lru[row]) begin
                data_1[1][row] <= write_data[63:32];
                data_1[0][row] <= write_data[31:0];
                tag_1[row] <= tag;
                valid_1[row] <= 1'b1;
            end
      
            else if (lru[row]) begin
                data_0[1][row] <= write_data[63:32];
                data_0[0][row] <= write_data[31:0];
                tag_0[row] <= tag;
                valid_0[row] <= 1'b1;
            end
        end
    end

    integer i;
    initial for (i = 0; i < 64; i = i + 1) begin
        {tag_0[i], tag_1[i]} = 20'b0;
        {valid_0[i], valid_1[i]} = 2'b0;
        lru[i] = 1'b0;
    end
endmodule