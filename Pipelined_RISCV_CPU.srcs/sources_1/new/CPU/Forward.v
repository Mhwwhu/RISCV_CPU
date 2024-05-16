`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/26 14:26:02
// Design Name: 
// Module Name: Forward
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


module Forward(
    input [4:0] IFID_rs1,
    input [4:0] IFID_rs2,
    input [4:0] IDEX_rs1,
    input [4:0] IDEX_rs2,
    input [4:0] IDEX_rd,
    input [4:0] EXMEM_rs2,
    input [4:0] EXMEM_rd,
    input [4:0] MEMWB_rd,
    input IDEX_RegWrite,
    input EXMEM_RegWrite,
    input MEMWB_RegWrite,
    input MEMWB_MemRead,
    output [4:0] forwardA,
    output [4:0] forwardB,
    output WBMEM_Forward
    );
    
    wire MEMEX_ForwardA = EXMEM_RegWrite & (EXMEM_rd != 0) & (EXMEM_rd == IDEX_rs1);
    wire MEMEX_ForwardB = EXMEM_RegWrite & (EXMEM_rd != 0) & (EXMEM_rd == IDEX_rs2);
    wire WBEX_ForwardA = MEMWB_RegWrite & (MEMWB_rd != 0) & (MEMWB_rd == IDEX_rs1);
    wire WBEX_ForwardB = MEMWB_RegWrite & (MEMWB_rd != 0) & (MEMWB_rd == IDEX_rs2);
    wire MEMID_ForwardA = EXMEM_RegWrite & (EXMEM_rd != 0) & (EXMEM_rd == IFID_rs1);
    wire MEMID_ForwardB = EXMEM_RegWrite & (EXMEM_rd != 0) & (EXMEM_rd == IFID_rs2);
    wire WBID_ForwardA = MEMWB_RegWrite & (MEMWB_rd != 0) & (MEMWB_rd == IFID_rs1);
    wire WBID_ForwardB = MEMWB_RegWrite & (MEMWB_rd != 0) & (MEMWB_rd == IFID_rs2);
    wire EXID_ForwardA = IDEX_RegWrite & (IDEX_rd != 0) & (IFID_rs1 == IDEX_rd);
    wire EXID_ForwardB = IDEX_RegWrite & (IDEX_rd != 0) & (IFID_rs2 == IDEX_rd);
    
    assign WBMEM_Forward = (MEMWB_rd != 0) & (EXMEM_rs2 == MEMWB_rd);
    
    assign forwardA[0] = MEMID_ForwardA | WBID_ForwardA | EXID_ForwardA;
    assign forwardA[1] = WBID_ForwardA & ~MEMID_ForwardA;
    assign forwardA[2] = EXID_ForwardA;
    assign forwardA[3] = MEMEX_ForwardA | WBEX_ForwardA;
    assign forwardA[4] = WBEX_ForwardA & ~MEMEX_ForwardA;
    
    assign forwardB[0] = MEMID_ForwardB | WBID_ForwardB | EXID_ForwardB;
    assign forwardB[1] = WBID_ForwardB & ~MEMID_ForwardB;
    assign forwardB[2] = EXID_ForwardB;
    assign forwardB[3] = MEMEX_ForwardB | WBEX_ForwardB;
    assign forwardB[4] = WBEX_ForwardB & ~MEMEX_ForwardB;
    
endmodule
