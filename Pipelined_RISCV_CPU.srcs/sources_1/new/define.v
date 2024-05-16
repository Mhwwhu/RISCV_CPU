
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/27 20:32:01
// Design Name: 
// Module Name: define
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define zero_word 32'b0

`define aluop_add   11'b00000000001
`define aluop_sub   11'b00000000010
`define aluop_and   11'b00000000100
`define aluop_or    11'b00000001000
`define aluop_xor   11'b00000010000
`define aluop_less  11'b00000100000
`define aluop_uless 11'b00001000000
`define aluop_sll   11'b00010000000
`define aluop_srl   11'b00100000000
`define aluop_sra   11'b01000000000
`define aluop_lui   11'b10000000000

`define r_type  7'b0110011
`define i_type  7'b0010011
`define i_typel 7'b0000011
`define s_type  7'b0100011
`define sb_type 7'b1100011
`define jalr    7'b1100111
`define jal     7'b1101111
`define auipc   7'b0010111
`define lui     7'b0110111

`define WDSel_FromALU 2'b00
`define WDSel_FromMEM 2'b01
`define WDSel_FromPC  2'b10 