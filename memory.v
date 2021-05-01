`include "defines.v"

module memory(clk, rst, addr, write_data, mem_read, mem_write, read_data);
    input [`INSTRUCTION_LEN - 1 : 0] addr, write_data;
    input clk, rst, mem_read, mem_write;
    output [`INSTRUCTION_LEN - 1 : 0] read_data; 

    // reg[`INSTRUCTION_LEN - 1 : 0] data[0:`INSTRUCTION_MEM_SIZE - 1];
    reg[7 : 0] data[0:`INSTRUCTION_MEM_SIZE - 1];

    wire [`INSTRUCTION_LEN - 3 : 0] modified_addr = addr[`INSTRUCTION_LEN - 1 : 2];
    assign read_data = mem_read ? 
        {data[addr], data[addr + 1], data[addr + 2], data[addr + 3]}
        : `INSTRUCTION_LEN'b0;

    always @(posedge clk, posedge rst) begin
        if (rst) 
        begin
            {data[0], data[1], data[2], data[3]} <= `INSTRUCTION_LEN'b000000_00001_00010_00000_00000000000;
            {data[4], data[5], data[6], data[7]} <= `INSTRUCTION_LEN'b000000_00011_00100_00000_00000000000; 
            {data[8], data[9], data[10], data[11]} <= `INSTRUCTION_LEN'b000000_00101_00110_00000_00000000000;
            {data[12], data[13], data[14], data[15]} <= `INSTRUCTION_LEN'b000000_00111_01000_00010_00000000000;
            {data[16], data[17], data[18], data[19]} <= `INSTRUCTION_LEN'b000000_01001_01010_00011_00000000000;
            {data[20], data[21], data[22], data[23]} <= `INSTRUCTION_LEN'b000000_01011_01100_00000_00000000000;
            {data[24], data[25], data[26], data[27]} <= `INSTRUCTION_LEN'b000000_01101_01110_00000_00000000000;

            {data[28], data[29], data[30], data[31]} <= `INSTRUCTION_LEN'b0; //For haj Mahyar!
        end
        
        else if (mem_write)
            {data[addr], data[addr + 1], data[addr + 2], data[addr + 3]} = write_data;
    end

endmodule