`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/24 13:05:38
// Design Name: 
// Module Name: IDEX_RF
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


module IDEX_RF(
    input clk,
    input reset,
    input flush,
    input RegWrite,
    input ALUSrc1,
    input ALUSrc2,
    input MemWrite,
    input MemRead,
    input [1:0] WDSel,
    input [3:0] DMType,
    input [10:0] ALUOp,
    input [31:0] RD1,
    input [31:0] RD2,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] imm,
    input [31:0] PC,
    output reg RegWrite_reg,
    output reg ALUSrc1_reg,
    output reg ALUSrc2_reg,
    output reg MemWrite_reg,
    output reg MemRead_reg,
    output reg [1:0] WDSel_reg,
    output reg [3:0] DMType_reg,
    output reg [10:0] ALUOp_reg,
    output reg [31:0] RD1_reg,
    output reg [31:0] RD2_reg,
    output reg [4:0] rs1_reg,
    output reg [4:0] rs2_reg,
    output reg [4:0] rd_reg,
    output reg [31:0] imm_reg,
    output reg [31:0] PC_reg
    );
    
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            RegWrite_reg <= 0;
            MemWrite_reg <= 0;
            MemRead_reg <= 0;
            ALUSrc1_reg <= 0;
            ALUSrc2_reg <= 0;
            WDSel_reg <= 2'b0;
            DMType_reg <= 3'b0;
            ALUOp_reg <= 11'b0;
            RD1_reg <= 32'b0;
            RD2_reg <= 32'b0;
            rs1_reg <= 5'b0;
            rs2_reg <= 5'b0;
            rd_reg <= 5'b0;
            imm_reg <= 32'b0;
            PC_reg <= 32'b0;
        end
        else begin
            if(flush) begin
                RegWrite_reg <= 0;
                MemWrite_reg <= 0;
                MemRead_reg <= 0;
            end
            else begin
                RegWrite_reg <= RegWrite;
                MemWrite_reg <= MemWrite;
                MemRead_reg <= MemRead;
            end
            ALUSrc1_reg <= ALUSrc1;
            ALUSrc2_reg <= ALUSrc2;
            WDSel_reg <= WDSel;
            DMType_reg <= DMType;
            ALUOp_reg <= ALUOp;
            RD1_reg <= RD1;
            RD2_reg <= RD2;
            rs1_reg <= rs1;
            rs2_reg <= rs2;
            rd_reg <= rd;
            imm_reg <= imm;
            PC_reg <= PC;
        end
    end
    
    
endmodule
