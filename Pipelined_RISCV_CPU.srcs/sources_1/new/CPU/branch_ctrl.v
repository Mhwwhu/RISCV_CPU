`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/27 21:39:10
// Design Name: 
// Module Name: branch_ctrl
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


module branch_ctrl(
	input [31:0] pc,
	input [31:0] imm,
	input [31:0] base_reg,
	input [2:0] branch_op,
	input [2:0] funct3,
	input [2:0] cmp,
	output [31:0] next_pc,
	output jmp
    );
    
    // cmp[0]: equal, cmp[1]: less, cmp[2]: uless
    // conditional branch signal
    wire branch = (~funct3[2] & ~funct3[1] & (funct3[0] ^ cmp[0])) |
    			  (funct3[2]  & ~funct3[1] & (funct3[0] ^ cmp[1])) |
    			  (funct3[2]  &  funct3[1] & (funct3[0] ^ cmp[2]));
    
    // branch_op: 100 jal, 010 jalr, 001 sb, 000 nop
    assign next_pc = branch_op[2] ? pc + imm :
    				 branch_op[1] ? imm + base_reg :
    				 branch_op[0] && branch ? pc + imm :
    				 32'b0;
    assign jmp = branch_op[1] | branch_op[2] | (branch & branch_op[0]);
    
endmodule
