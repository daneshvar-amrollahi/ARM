`include "defines.v"

module memory(clk, rst, addr, write_data, mem_read, mem_write, read_data);
    input [`INSTRUCTION_LEN - 1 : 0] addr, write_data;
    input clk, rst, mem_read, mem_write;
    output [`INSTRUCTION_LEN - 1 : 0] read_data; 

    reg[`INSTRUCTION_LEN - 1 : 0] data[0:`INSTRUCTION_MEM_SIZE - 1];


    assign read_data = mem_read ? data[addr] : `INSTRUCTION_LEN'b0;


    always @(posedge clk, posedge rst) begin
        if (rst) 
        begin
            data[0] <= `INSTRUCTION_LEN'b000000_00001_00010_00000_00000000000;
            data[1] <= `INSTRUCTION_LEN'b000000_00011_00100_00000_00000000000; 
            data[2] <= `INSTRUCTION_LEN'b000000_00101_00110_00000_00000000000;
            data[3] <= `INSTRUCTION_LEN'b000000_00111_01000_00010_00000000000;
            data[4] <= `INSTRUCTION_LEN'b000000_01001_01010_00011_00000000000;
            data[5] <= `INSTRUCTION_LEN'b000000_01011_01100_00000_00000000000;
            data[6] <= `INSTRUCTION_LEN'b000000_01101_01110_00000_00000000000;

            data[7] <= `INSTRUCTION_LEN'b0; //For haj Mahyar!
        end
        
        else if (mem_write)
            data[addr] = write_data;
    end

endmodule