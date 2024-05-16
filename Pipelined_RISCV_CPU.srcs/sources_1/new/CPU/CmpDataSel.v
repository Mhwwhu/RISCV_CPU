`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/06 22:33:25
// Design Name: 
// Module Name: CmpDataSel
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


module CmpDataSel(
    input [31:0] RD1,
    input [31:0] RD2,
    input [2:0] forwardA,
    input [2:0] forwardB,
    input [31:0] EXMEM_ALUResult,
    input [31:0] EXMEM_PC,
    input [31:0] IDEX_PC,
    input [31:0] WB_WD,
    input fromEXMEM_PC,
    output [31:0] Data1,
    output [31:0] Data2
    );
    
    wire [31:0] forwardDataA = forwardA[2] ? IDEX_PC + 4 :
                               forwardA[1] ? WB_WD :
                               fromEXMEM_PC ? EXMEM_PC + 4 :
                               EXMEM_ALUResult;
                               
    wire [31:0] forwardDataB = forwardB[2] ? IDEX_PC + 4 :
                               forwardB[1] ? WB_WD :
                               fromEXMEM_PC ? EXMEM_PC + 4 :
                               EXMEM_ALUResult;
    
    assign Data1 = forwardA[0] ? forwardDataA : RD1;
    assign Data2 = forwardB[0] ? forwardDataB : RD2;
    
endmodule
