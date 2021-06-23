`include "defines.v"

module cache_controller(
    clk, 
    rst, 
    addr, 
    write_data,
    mem_read_enable, 
    mem_write_enable,
    sram_ready,
    read_data,
    sram_read_data,
    sram_addr,
    sram_write_data,
    sram_write_en,
    sram_read_en,
    ready
);

    input clk, rst;
    input [`ADDRESS_LEN - 1 : 0] addr;
    input [`REGISTER_LEN - 1 : 0] write_data;
    input mem_read_enable, mem_write_enable;
    input [2 * `REGISTER_LEN - 1 : 0] sram_read_data;
    input sram_ready;

    output reg [`ADDRESS_LEN - 1 : 0] sram_addr;
    output reg [`REGISTER_LEN - 1 : 0] sram_write_data;
    output reg [`REGISTER_LEN - 1 : 0] read_data;
    output ready;
    output sram_write_en, sram_read_en;


    wire [16 : 0] cache_addr;
    assign cache_addr = addr[17 : 2];

    wire [`REGISTER_LEN - 1 : 0] cache_read_data;
    wire cache_write_en, cache_read_en, cache_invalidate;
    wire cache_hit;

    cache cache(
        .clk(clk),
        .rst(rst),
        .address(cache_addr),
        .write_data(sram_read_data),
        .cache_read_en(cache_read_en),
        .cache_write_en(cache_write_en),
        .invalidate(cache_invalidate),
        .read_data(cache_read_data),
        .hit(cache_hit)
    );
  
    reg [2 : 0] ps, ns;
    
    parameter   IDLE = 3'b000, 
                MISS = 3'b001, 
                WRITE = 3'b010;

    assign sram_write_en = (ps == WRITE);
    assign sram_read_en = (ps == MISS);
    assign ready = (ns == IDLE);
    assign cache_read_en = (ps == IDLE);
    assign cache_write_en = (ps == MISS && sram_ready);
    assign cache_invalidate = (ps == IDLE && ns == WRITE);


    always @(posedge clk, posedge rst) begin
        if (rst)
            ps <= IDLE;
        else
            ps <= ns;
    end
    
    always @(*)
    begin
        case (ps)
            IDLE: begin
            if (mem_read_enable && ~cache_hit)
                ns = MISS;
            else if (mem_write_enable)
                ns = WRITE;
            else
                ns = IDLE; 
            end

            MISS: begin
                if (sram_ready)
                    ns = IDLE;
                else
                    ns = MISS;
            end

            WRITE: begin
                if (sram_ready)
                    ns = IDLE;
                else
                    ns = WRITE;
            end
        endcase
    end


    always @(*) begin
        read_data = `REGISTER_LEN'b0;
        if (ps == IDLE && cache_hit)
            read_data = cache_read_data;
        else 
        if (ps == MISS && sram_ready) begin
            //$display("@%t: addr[2] = %d, sram[63:32]: %d, sram[31:0]: %d", $time, addr[2], 
            //sram_read_data[63:32], sram_read_data[31:0]);
            read_data = addr[2] ? sram_read_data[63:32] : sram_read_data[31:0];
        end
    end

    always @(*)
    begin
        sram_write_data = `REGISTER_LEN'b0;
        if (ps == WRITE)
            sram_write_data = write_data;
    end


    always @(*)
    begin
        sram_addr = `ADDRESS_LEN'b0;
        if (ps == MISS || ps == WRITE)
            sram_addr = addr;
    end



             
endmodule