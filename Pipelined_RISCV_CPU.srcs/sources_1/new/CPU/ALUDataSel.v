`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/06 21:59:29
// Design Name: 
// Module Name: ALUDataSel
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


module ALUDataSel(
    input [31:0] RD1,
    input [31:0] RD2,
    input [31:0] immediate,
    input [31:0] IDEX_PC,
    input [31:0] EXMEM_ALUResult,
    input [31:0] EXMEM_PC,
    input [31:0] WB_WD,
    input [1:0] forwardA,
    input [1:0] forwardB,
    input ALUSrc1,
    input ALUSrc2,
    input fromEXMEM_PC,
    output [31:0] ALU_A,
    output [31:0] ALU_B,
    output [31:0] DataB
    );
    
    wire [31:0] forwardDataA = forwardA[1] ? WB_WD :
                               fromEXMEM_PC ? EXMEM_PC + 4 :
                               EXMEM_ALUResult;
    wire [31:0] forwardDataB = forwardB[1] ? WB_WD :
                               fromEXMEM_PC ? EXMEM_PC + 4 :
                               EXMEM_ALUResult;
    
    assign DataB = forwardB[0] ? forwardDataB : RD2;
    assign ALU_A = ALUSrc1 ? IDEX_PC :
                   forwardA[0] ? forwardDataA :
                   RD1;
    assign ALU_B = ALUSrc2 ? immediate :
                   forwardB[0] ? forwardDataB :
                   RD2;
                   
    
endmodule
