`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/27 23:27:05
// Design Name: 
// Module Name: ImmGen
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

`include "../define.v"

module ImmGen(
	input [31:0] instr,
	output [31:0] imm
    );
    
    // op[0]: i_type, op[1]: shift, op[2]: s_type, op[3]: sb_type, op[4]: j_type, op[5]: u_type
    wire [5:0] op;
    wire [6:0] opcode = instr[6:0];
    assign op[0] = ((opcode == `i_type) | (opcode == `i_typel) | (opcode == `jalr)) & (instr[13] | ~instr[12]);
    assign op[1] = (opcode == `i_type) & ~instr[13] & instr[12];
    assign op[2] = opcode == `s_type;
    assign op[3] = opcode == `sb_type;
    assign op[4] = opcode == `jal;
    assign op[5] = (opcode == `lui) | (opcode == `auipc);
    
    assign imm = op[0] ? {{20{instr[31]}}, instr[31:20]} :
    			 op[1] ? {27'b0, instr[24:20]} :
    			 op[2] ? {{20{instr[31]}}, instr[31:25], instr[11:7]} :
    			 op[3] ? {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0} :
    			 op[4] ? {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0} :
    			 op[5] ? {instr[31:12], 12'b0} :
    			 `zero_word;
    
endmodule
