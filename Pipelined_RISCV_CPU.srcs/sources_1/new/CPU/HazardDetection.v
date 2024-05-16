`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/26 14:25:38
// Design Name: 
// Module Name: HazardDetection
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


module HazardDetection(
    input jmp,
    input IDEX_MemRead,
    input EXMEM_MemRead,
    input IDEX_RegWrite,
    input IFID_MemWrite,
    input [4:0] IDEX_rd,
    input [4:0] EXMEM_rd,
    input [4:0] IFID_rs1,
    input [4:0] IFID_rs2,
    input IFID_rs1_en,
    input IFID_rs2_en,
    input sbtype,
    input jalr,
    
    output PC_we,
    output IFID_we,
    output IFID_flush,
    output IDEX_flush
    );
    
    // bug
    assign IFID_flush = jmp;
    assign PC_we = ~IDEX_flush;
    assign IFID_we = ~IDEX_flush;
    assign IDEX_flush = 
        IDEX_RegWrite & sbtype & (IDEX_rd != 0) & ((IDEX_rd == IFID_rs1) & IFID_rs1_en | (IDEX_rd == IFID_rs2) & IFID_rs2_en) |
        IDEX_MemRead & (~IFID_MemWrite) & (IDEX_rd != 0) & ((IDEX_rd == IFID_rs1) & IFID_rs1_en | (IDEX_rd == IFID_rs2) & IFID_rs2_en) |
        EXMEM_MemRead & sbtype & (EXMEM_rd != 0) & ((EXMEM_rd == IFID_rs1) & IFID_rs1_en | (EXMEM_rd == IFID_rs2) & IFID_rs2_en) |
        IDEX_RegWrite & jalr & (IDEX_rd != 0) & (IDEX_rd == IFID_rs1) |
        EXMEM_MemRead & jalr & (IDEX_rd != 0) & (EXMEM_rd == IFID_rs1) |
        IDEX_MemRead & IFID_MemWrite & (IDEX_rd != 0) & (IDEX_rd == IFID_rs1)
    ;
    
endmodule
