`ifndef defines_v
`define defines_v

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

`define SHIFT_OPERAND_INDEX     11
`define SHIFT_OPERAND_LEN       12
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

`define S_LDR 1'b1
`define S_STR 1'b0

`endif