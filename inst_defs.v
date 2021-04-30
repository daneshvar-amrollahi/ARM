`ifndef inst_defs_v
`define inst_defs_v

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

`endif