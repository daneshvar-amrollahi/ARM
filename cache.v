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

    // should be checked
    // always @(posedge rst) begin
    //     tag_0 <= 640'b0;
    //     tag_1 <= 640'b0;
    //     valid_0 <= 64'b0;
    //     valid_1 <= 64'b0;
    //     lru <= 64'b0;
    // end

    wire set_0_hit, set_1_hit;
    assign set_0_hit = (tag_0[row] == tag) & valid_0[row];
    assign set_1_hit = (tag_1[row] == tag) & valid_1[row];

    mux2to1 #(.WORD_LEN(32)) read_data_mux(
        .a(data_0[col][row]), 
        .b(data_1[col][row])
        .sel_a(set_0_hit), 
        .sel_b(set_1_hit),
        .out(read_data)
    );

    assign hit = set_1_hit | set_2_hit;

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

    always @(posedge rst) begin
        tag_0[0] <= 10'b00000_00000;
        tag_0[1] <= 10'b00000_00000;
        tag_0[2] <= 10'b00000_00000;
        tag_0[3] <= 10'b00000_00000;
        tag_0[4] <= 10'b00000_00000;
        tag_0[5] <= 10'b00000_00000;
        tag_0[6] <= 10'b00000_00000;
        tag_0[7] <= 10'b00000_00000;
        tag_0[8] <= 10'b00000_00000;
        tag_0[9] <= 10'b00000_00000;
        tag_0[10] <= 10'b00000_00000;
        tag_0[11] <= 10'b00000_00000;
        tag_0[12] <= 10'b00000_00000;
        tag_0[13] <= 10'b00000_00000;
        tag_0[14] <= 10'b00000_00000;
        tag_0[15] <= 10'b00000_00000;
        tag_0[16] <= 10'b00000_00000;
        tag_0[17] <= 10'b00000_00000;
        tag_0[18] <= 10'b00000_00000;
        tag_0[19] <= 10'b00000_00000;
        tag_0[20] <= 10'b00000_00000;
        tag_0[21] <= 10'b00000_00000;
        tag_0[22] <= 10'b00000_00000;
        tag_0[23] <= 10'b00000_00000;
        tag_0[24] <= 10'b00000_00000;
        tag_0[25] <= 10'b00000_00000;
        tag_0[26] <= 10'b00000_00000;
        tag_0[27] <= 10'b00000_00000;
        tag_0[28] <= 10'b00000_00000;
        tag_0[29] <= 10'b00000_00000;
        tag_0[30] <= 10'b00000_00000;
        tag_0[31] <= 10'b00000_00000;
        tag_0[32] <= 10'b00000_00000;
        tag_0[33] <= 10'b00000_00000;
        tag_0[34] <= 10'b00000_00000;
        tag_0[35] <= 10'b00000_00000;
        tag_0[36] <= 10'b00000_00000;
        tag_0[37] <= 10'b00000_00000;
        tag_0[38] <= 10'b00000_00000;
        tag_0[39] <= 10'b00000_00000;
        tag_0[40] <= 10'b00000_00000;
        tag_0[41] <= 10'b00000_00000;
        tag_0[42] <= 10'b00000_00000;
        tag_0[43] <= 10'b00000_00000;
        tag_0[44] <= 10'b00000_00000;
        tag_0[45] <= 10'b00000_00000;
        tag_0[46] <= 10'b00000_00000;
        tag_0[47] <= 10'b00000_00000;
        tag_0[48] <= 10'b00000_00000;
        tag_0[49] <= 10'b00000_00000;
        tag_0[50] <= 10'b00000_00000;
        tag_0[51] <= 10'b00000_00000;
        tag_0[52] <= 10'b00000_00000;
        tag_0[53] <= 10'b00000_00000;
        tag_0[54] <= 10'b00000_00000;
        tag_0[55] <= 10'b00000_00000;
        tag_0[56] <= 10'b00000_00000;
        tag_0[57] <= 10'b00000_00000;
        tag_0[58] <= 10'b00000_00000;
        tag_0[59] <= 10'b00000_00000;
        tag_0[60] <= 10'b00000_00000;
        tag_0[61] <= 10'b00000_00000;
        tag_0[62] <= 10'b00000_00000;
        tag_0[63] <= 10'b00000_00000;

        tag_1[0] <= 10'b00000_00000;
        tag_1[1] <= 10'b00000_00000;
        tag_1[2] <= 10'b00000_00000;
        tag_1[3] <= 10'b00000_00000;
        tag_1[4] <= 10'b00000_00000;
        tag_1[5] <= 10'b00000_00000;
        tag_1[6] <= 10'b00000_00000;
        tag_1[7] <= 10'b00000_00000;
        tag_1[8] <= 10'b00000_00000;
        tag_1[9] <= 10'b00000_00000;
        tag_1[10] <= 10'b00000_00000;
        tag_1[11] <= 10'b00000_00000;
        tag_1[12] <= 10'b00000_00000;
        tag_1[13] <= 10'b00000_00000;
        tag_1[14] <= 10'b00000_00000;
        tag_1[15] <= 10'b00000_00000;
        tag_1[16] <= 10'b00000_00000;
        tag_1[17] <= 10'b00000_00000;
        tag_1[18] <= 10'b00000_00000;
        tag_1[19] <= 10'b00000_00000;
        tag_1[20] <= 10'b00000_00000;
        tag_1[21] <= 10'b00000_00000;
        tag_1[22] <= 10'b00000_00000;
        tag_1[23] <= 10'b00000_00000;
        tag_1[24] <= 10'b00000_00000;
        tag_1[25] <= 10'b00000_00000;
        tag_1[26] <= 10'b00000_00000;
        tag_1[27] <= 10'b00000_00000;
        tag_1[28] <= 10'b00000_00000;
        tag_1[29] <= 10'b00000_00000;
        tag_1[30] <= 10'b00000_00000;
        tag_1[31] <= 10'b00000_00000;
        tag_1[32] <= 10'b00000_00000;
        tag_1[33] <= 10'b00000_00000;
        tag_1[34] <= 10'b00000_00000;
        tag_1[35] <= 10'b00000_00000;
        tag_1[36] <= 10'b00000_00000;
        tag_1[37] <= 10'b00000_00000;
        tag_1[38] <= 10'b00000_00000;
        tag_1[39] <= 10'b00000_00000;
        tag_1[40] <= 10'b00000_00000;
        tag_1[41] <= 10'b00000_00000;
        tag_1[42] <= 10'b00000_00000;
        tag_1[43] <= 10'b00000_00000;
        tag_1[44] <= 10'b00000_00000;
        tag_1[45] <= 10'b00000_00000;
        tag_1[46] <= 10'b00000_00000;
        tag_1[47] <= 10'b00000_00000;
        tag_1[48] <= 10'b00000_00000;
        tag_1[49] <= 10'b00000_00000;
        tag_1[50] <= 10'b00000_00000;
        tag_1[51] <= 10'b00000_00000;
        tag_1[52] <= 10'b00000_00000;
        tag_1[53] <= 10'b00000_00000;
        tag_1[54] <= 10'b00000_00000;
        tag_1[55] <= 10'b00000_00000;
        tag_1[56] <= 10'b00000_00000;
        tag_1[57] <= 10'b00000_00000;
        tag_1[58] <= 10'b00000_00000;
        tag_1[59] <= 10'b00000_00000;
        tag_1[60] <= 10'b00000_00000;
        tag_1[61] <= 10'b00000_00000;
        tag_1[62] <= 10'b00000_00000;
        tag_1[63] <= 10'b00000_00000;
        
        valid_0 <= 64'b0;
        valid_1 <= 64'b0;
        lru <= 64'b0;
    end

endmodule