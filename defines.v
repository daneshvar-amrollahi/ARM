`ifndef defines_v
`define defines_v

`define ADDRESS_LEN             32
`define INSTRUCTION_LEN         32
`define INSTRUCTION_MEM_SIZE    2048

`define REGFILE_ADDRESS_LEN     4
`define REGISTER_LEN            32
`define REGISTER_MEM_SIZE       16

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


`define S_LDR 1'b1
`define S_STR 1'b0

`define CIN_INDEX 1

`define LSL_SHIFT 2'b00
`define LSR_SHIFT 2'b01
`define ASR_SHIFT 2'b10
`define ROR_SHIFT 2'b11 

`endif