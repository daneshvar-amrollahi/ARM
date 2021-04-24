`define ADDRESS_LEN             32
`define INSTRUCTION_LEN         32
`define INSTRUCTION_MEM_SIZE    256

`define REGFILE_ADDRESS_LEN     4
`define REGISTER_LEN            32
`define REGISTER_MEM_SIZE       15

`define OPCODE_LEN              4
`define EXECUTE_COMMAND_LEN     4

`define MODE_LEN                2
`define ARITHMETHIC_TYPE        2'b00
`define MEMORY_TYPE             2'b01
`define BRANCH_TYPE             2'b10

`define OPCODE_LEN              4
`define CONDITION_LEN           4
`define STATUS_REG_LEN          4

`define MOV 4'b1101
`define MVN 4'b1111
`define ADD 4'b0100
`define ADC 4'b0101
`define SUB 4'b0010
`define SBC 4'b0110
`define AND 4'b0000
`define ORR 4'b1100
`define EOR 4'b0001
`define CMP 4'b1010
`define TST 4'b1000
`define LDR 4'b0100
`define STR 4'b0100 

`define EQ    4`b0000
`define NE    4`b0001
`define CS_HS 4`b0010
`define CC_LO 4`b0011
`define MI    4`b0100
`define PL    4`b0101
`define VS    4`b0110
`define VC    4`b0111
`define HI    4`b1000
`define LS    4`b1001
`define GE    4`b1010
`define LT    4`b1011
`define GT    4`b1100
`define LE    4`b1101
`define AL    4`b1110

`define MOV_EXE  4'b0001
`define MOVN_EXE 4'b1001
`define ADD_EXE  4'b0010
`define ADC_EXE  4'b0011
`define SUB_EXE  4'b0100
`define SBC_EXE  4'b0101
`define AND_EXE  4'b0110
`define ORR_EXE  4'b0111
`define EOR_EXE  4'b1000
`define CMP_EXE  4'b0100
`define TST_EXE  4'b0110
`define LDR_EXE  4'b0010
`define STR_EXE  4'b0010