`include "defines.v"

module cache_controller(
    clk, 
    rst, 
    // inputs and outputs related to the memory stage
    addr, 
    write_data,

    MEM_R_EN, 
    MEM_W_EN,

    read_data,
    ready,

    // inputs and outputs related to the SRAM
    sram_addr,
    sram_write_data,
    sram_write_en,
    sram_read_en,
    sram_read_data, 
    sram_ready
);

    input clk, rst;
    input [31 : 0] addr, write_data;
    input MEM_R_EN, MEM_W_EN;
    output [31 : 0] read_data;
    output ready;

    output [31 : 0] sram_addr;
    output [31 : 0] sram_write_data;

    output sram_write_en, sram_read_en;

    input [63 : 0] sram_read_data;
    input sram_ready;

    wire [16:0] cache_addr;
  
    wire [31:0] addr_1024;
    assign addr_1024 = addr - 1024;
    assign cache_addr = addr_1024[17:2];

    assign cache_addr = addr[17 : 2]; 
  
  
    wire [31 : 0] cache_read_data;
    wire cache_write_en, cache_read_en, cache_invalidate;
    wire cache_hit;

  

    cache cache(
        .clk(clk),
        .rst(rst),
        .address(cache_addr),
        .write_data(sram_read_data),
        .cache_read_en(cache_read_en),
        .cache_write_en(cache_write_en),
        .invalidate(cach_invoke),
        .read_data(cache_read_data),
        .hit(cache_hit)
    );
  
    wire [2 : 0] ps, ns;
    
    parameter   S_IDLE = 3'b000, 
                S_SRAM_READ_CACHE_WRITE = 3'b001, 
                S_SRAM_WRITE = 3'b010, 
                S_INVALIDATE_CACHE = 3'b011;


    always @(posedge clk, posedge rst) begin
        if (rst)
            ps <= S_IDLE;
        else
            ps <= ns;
    end

  
    
    always @(*)
    begin
        if (ps == S_IDLE && MEM_R_EN && ~cache_hit)
            ns = S_SRAM_READ_CACHE_WRITE;
        else
        if (ps == S_IDLE && MEM_W_EN)
            ns = S_SRAM_WRITE;
        else
        if (ps == S_SRAM_READ_CACHE_WRITE && sram_ready)
            ns = S_IDLE;
        else
        if (ps == S_SRAM_WRITE && sram_ready)
            ns = S_IDLE;
        else
            ns = ps;
    end


    
    always @(*)
    begin
        read_data = 32'bz;

        if (ps == S_IDLE && cache_hit)
            read_data = cache_read_data;
        else
        if (ps == S_SRAM_READ_CACHE_WRITE && sram_ready)
        begin
            if (cache_addr[0])
                read_data = sram_read_data[62 : 32]
            else
                read_data = sram_read_data[31 : 0];
        end

    end

             
    assign ready = (ns == S_IDLE);
    
    always @(*)
    begin
        sram_addr = 64'bz;

        if (ps == S_SRAM_READ_CACHE_WRITE || ps == S_SRAM_WRITE)
            sram_addr = addr;
    end

    
    always @(*)
    begin
        sram_write_data = 64'bz;

        if (ps == S_SRAM_WRITE)
            sram_write_data = write_data; 
    end


    assign sram_write_en = (ps == S_SRAM_WRITE);
                            
    assign sram_read_en = (ps == S_SRAM_READ_CACHE_WRITE);
    
    assign cache_read_en = (ps == S_IDLE);
    assign cache_write_en = (ps == S_SRAM_READ_CACHE_WRITE && sram_ready);
    assign cache_invalidate = (ps == S_IDLE && ns == S_SRAM_WRITE);
             
endmodule