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

    wire [`INSTRUCTION_LEN - 1 : 0] new_addr;
    assign new_addr = { {addr[`INSTRUCTION_LEN - 1 : 2]}, {2'b00} };

    always @(posedge clk, posedge rst) begin
        if (rst) 
        begin
            {data[0], data[1], data[2], data[3]} <= `INSTRUCTION_LEN'b1110_00_1_1101_0_0000_0000_000000010100;      //  MOV R0 = 20           R0 = 20
            {data[4], data[5], data[6], data[7]} <= `INSTRUCTION_LEN'b1110_00_1_1101_0_0000_0001_101000000001;      //  MOV R1 ,#4096         R1 = 4096
            {data[8], data[9], data[10], data[11]} <= `INSTRUCTION_LEN'b1110_00_1_1101_0_0000_0010_000100000011;   //   MOV R2 ,#0xC0000000    R2 = -1073741824
            {data[12], data[13], data[14], data[15]} <= `INSTRUCTION_LEN'b1110_00_0_0100_1_0010_0011_000000000010; //   ADDS R3 ,R2,R2         R3 = -2147483648 
            {data[16], data[17], data[18], data[19]} <=  `INSTRUCTION_LEN'b1110_00_0_0101_0_0000_0100_000000000000; //ADC R4 ,R0,R0 //R4 = 41
            {data[20], data[21], data[22], data[23]} <= `INSTRUCTION_LEN'b1110_00_0_0010_0_0100_0101_000100000100; //SUB R5 ,R4,R4,LSL #2 //R5 = -123 
            {data[24], data[25], data[26], data[27]} <= `INSTRUCTION_LEN'b1110_00_0_0110_0_0000_0110_000010100000; //SBC R6 ,R0,R0,LSR #1//R6 = 10
            {data[28], data[29], data[30], data[31]} <= `INSTRUCTION_LEN'b1110_00_0_1100_0_0101_0111_000101000010; //ORR    R7 ,R5,R2,ASR #2//R7 = -123
            {data[32], data[33], data[34], data[35]} <= `INSTRUCTION_LEN'b1110_00_0_0000_0_0111_1000_000000000011; //AND R8 ,R7,R3   R8 = -2147483648
            {data[36], data[37], data[38], data[39]} <= `INSTRUCTION_LEN'b1110_00_0_1111_0_0000_1001_000000000110; //MVNR9 ,R6//R9 = -11
            {data[40], data[41], data[42], data[43]} <= `INSTRUCTION_LEN'b1110_00_0_0001_0_0100_1010_000000000101; //EORR10,R4,R5//R10 = -84
            {data[44], data[45], data[46], data[47]} <= `INSTRUCTION_LEN'b1110_00_0_1010_1_1000_0000_000000000110; //CMPR8 ,R6
            {data[48], data[49], data[50], data[51]} <= `INSTRUCTION_LEN'b0001_00_0_0100_0_0001_0001_000000000001; //ADDNER1 ,R1,R1//R1 = 8192
            {data[52], data[53], data[54], data[55]} <= `INSTRUCTION_LEN'b1110_00_0_1000_1_1001_0000_000000001000; //TSTR9 ,R8
            {data[56], data[57], data[58], data[59]} <= `INSTRUCTION_LEN'b0000_00_0_0100_0_0010_0010_000000000010; //ADDEQ R2 ,R2,R2   //R2 = -1073741824
            {data[60], data[61], data[62], data[63]} <= `INSTRUCTION_LEN'b1110_00_1_1101_0_0000_0000_101100000001; //MOVR0 ,#1024//R0 = 1024
            {data[64], data[65], data[66], data[67]} <= `INSTRUCTION_LEN'b1110_01_0_0100_0_0000_0001_000000000000; //STRR1 ,[R0],#0//MEM[1024] = 8192
            {data[68], data[69], data[70], data[71]} <= `INSTRUCTION_LEN'b1110_01_0_0100_1_0000_1011_000000000000; //LDRR11,[R0],#0//R11 = 8192
            {data[72], data[73], data[74], data[75]} <= `INSTRUCTION_LEN'b1110_01_0_0100_0_0000_0010_000000000100; //STRR2 ,[R0],#4//MEM[1028] = -1073741824
            {data[76], data[77], data[78], data[79]} <= `INSTRUCTION_LEN'b1110_01_0_0100_0_0000_0011_000000001000; //STR    R3 ,[R0],#8//MEM[1032] = -2147483648
            {data[80], data[81], data[82], data[83]} <= `INSTRUCTION_LEN'b1110_01_0_0100_0_0000_0100_000000001101; //STR    R4 ,[R0],#13    //MEM[1036] = 41
            {data[84], data[85], data[86], data[87]} <= `INSTRUCTION_LEN'b1110_01_0_0100_0_0000_0101_000000010000; //STRR5 ,[R0],#16//MEM[1040] = -123
            {data[88], data[89], data[90], data[91]} <= `INSTRUCTION_LEN'b1110_01_0_0100_0_0000_0110_000000010100; //STRR6,[R0],#20 //MEM[1044] = 10
            {data[92], data[93], data[94], data[95]} <= `INSTRUCTION_LEN'b1110_01_0_0100_1_0000_1010_000000000100; //LDRR10,[R0],#4 //R10 = -1073741824
            {data[96], data[97], data[98], data[99]} <= `INSTRUCTION_LEN'b1110_01_0_0100_0_0000_0111_000000011000; //STRR7 ,[R0],#24    //MEM[1048] = -123
            {data[100], data[101], data[102], data[103]} <= `INSTRUCTION_LEN'b1110_00_1_1101_0_0000_0001_000000000100; //MOVR1 ,#4//R1 = 4
            {data[104], data[105], data[106], data[107]} <= `INSTRUCTION_LEN'b1110_00_1_1101_0_0000_0010_000000000000; //MOVR2 ,#0//R2 = 0
            {data[108], data[109], data[110], data[111]} <= `INSTRUCTION_LEN'b1110_00_1_1101_0_0000_0011_000000000000; //MOVR3 ,#0//R3 = 0
            {data[112], data[113], data[114], data[115]} <= `INSTRUCTION_LEN'b1110_00_0_0100_0_0000_0100_000100000011; //ADDR4 ,R0,R3,LSL #2
            {data[116], data[117], data[118], data[119]} <= `INSTRUCTION_LEN'b1110_01_0_0100_1_0100_0101_000000000000; //LDRR5 ,[R4],#0
            {data[120], data[121], data[122], data[123]} <= `INSTRUCTION_LEN'b1110_01_0_0100_1_0100_0110_000000000100; //LDRR6 ,[R4],#4
            {data[124], data[125], data[126], data[127]} <= `INSTRUCTION_LEN'b1110_00_0_1010_1_0101_0000_000000000110; //CMPR5 ,R6
            {data[128], data[129], data[130], data[131]} <= `INSTRUCTION_LEN'b1100_01_0_0100_0_0100_0110_000000000000; //STRGTR6 ,[R4],#0
            {data[132], data[133], data[134], data[135]} <= `INSTRUCTION_LEN'b1100_01_0_0100_0_0100_0101_000000000100; //STRGTR5 ,[R4],#4
            {data[136], data[137], data[138], data[139]} <= `INSTRUCTION_LEN'b1110_00_1_0100_0_0011_0011_000000000001; //ADDR3 ,R3,#1
            {data[140], data[141], data[142], data[143]} <= `INSTRUCTION_LEN'b1110_00_1_1010_1_0011_0000_000000000011; //CMPR3 ,#3
            {data[144], data[145], data[146], data[147]} <= `INSTRUCTION_LEN'b1011_10_1_0_111111111111111111110111  ; //BLT#-9
            {data[148], data[149], data[150], data[151]} <= `INSTRUCTION_LEN'b1110_00_1_0100_0_0010_0010_000000000001; //ADDR2 ,R2,#1
            {data[152], data[153], data[154], data[155]} <= `INSTRUCTION_LEN'b1110_00_0_1010_1_0010_0000_000000000001;//CMPR2 ,R1
            {data[156], data[157], data[158], data[159]} <= `INSTRUCTION_LEN'b1011_10_1_0_111111111111111111110011  ;//BLT#-13
            {data[160], data[161], data[162], data[163]} <= `INSTRUCTION_LEN'b1110_01_0_0100_1_0000_0001_000000000000;//LDR R1 ,[R0],#0//    R1 = -2147483648
            {data[164], data[165], data[166], data[167]} <= `INSTRUCTION_LEN'b1110_01_0_0100_1_0000_0010_000000000100;//LDR R2 ,[R0],#4//    R2 = -1073741824
            {data[168], data[169], data[170], data[171]} <= `INSTRUCTION_LEN'b1110_01_0_0100_1_0000_0011_000000001000;//STR R3 ,[R0],#8//    R3 = 41
            {data[172], data[173], data[174], data[175]} <= `INSTRUCTION_LEN'b1110_01_0_0100_1_0000_0100_000000001100;//STR R4 ,[R0],#12//   R4 = 8192
            {data[176], data[177], data[178], data[179]} <= `INSTRUCTION_LEN'b1110_01_0_0100_1_0000_0101_000000010000;//STR R5 ,[R0],#16//   R5= -123
            {data[180], data[181], data[182], data[183]} <= `INSTRUCTION_LEN'b1110_01_0_0100_1_0000_0110_000000010100;//STR R6 ,[R0],#20//   R6 = 10
            {data[184], data[185], data[186], data[187]} <= `INSTRUCTION_LEN'b1110_10_1_0_111111111111111111111111;//B#-1
            {data[188], data[189], data[190], data[191]} <= `INSTRUCTION_LEN'b0;
        end
        
        else if (mem_write)
        begin
            {data[new_addr], data[new_addr + 1], data[new_addr + 2], data[new_addr + 3]} = write_data;
        end
    end

endmodule