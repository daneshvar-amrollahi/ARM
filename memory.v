`include "defines.v"

module memory(clk, rst, addr, write_data, mem_read, mem_write, read_data);
    input [`INSTRUCTION_LEN - 1 : 0] addr, write_data;
    input clk, rst, mem_read, mem_write;
    output [`INSTRUCTION_LEN - 1 : 0] read_data; 

    // reg[`INSTRUCTION_LEN - 1 : 0] data[0:`INSTRUCTION_MEM_SIZE - 1];
    reg[7 : 0] data[0:`INSTRUCTION_MEM_SIZE - 1];

    //wire [`INSTRUCTION_LEN - 3 : 0] modified_addr = addr[`INSTRUCTION_LEN - 1 : 2];
    assign read_data = mem_read ? 
        {data[addr], data[addr + 1], data[addr + 2], data[addr + 3]}
        : `INSTRUCTION_LEN'b0;

    always @(posedge clk, posedge rst) begin
        if (rst) 
        begin
            {data[0], data[1], data[2], data[3]} <= `INSTRUCTION_LEN'b1110_00_1_1101_0_0000_0000_000000010100; //MOV R0 = 20
            {data[4], data[5], data[6], data[7]} <= `INSTRUCTION_LEN'b1110_00_0_0100_1_0010_0011_000000000010; //ADDS R3, R2, R2
            {data[8], data[9], data[10], data[11]} <= `INSTRUCTION_LEN'b1110_00_0_0010_0_0100_0101_000100000100; //SUB R5,R4,R4,LSL #2 //R5 = -123
            {data[12], data[13], data[14], data[15]} <= `INSTRUCTION_LEN'b1110_00_0_0110_0_0000_0110_000010100000; //SBC R6,R0,R0,LSR #1 //R6 = 10
            {data[16], data[17], data[18], data[19]} <= `INSTRUCTION_LEN'b1110_01_0_0100_1_0000_1011_000000000000; //LDR R11,[R0],#0 //R11 = 8192
            {data[20], data[21], data[22], data[23]} <= `INSTRUCTION_LEN'b1110_01_0_0100_0_0000_0010_000000000100; //STR R2 ,[R0],#4 //MEM[1028] = -1073741824; 
            {data[24], data[25], data[26], data[27]} <= `INSTRUCTION_LEN'b0; //For haj Mahyar!
        end
        
        else if (mem_write)
            {data[addr], data[addr + 1], data[addr + 2], data[addr + 3]} = write_data;
    end

endmodule