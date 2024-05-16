`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/24 13:05:00
// Design Name: 
// Module Name: IFID_RF
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

module EXMEM_RF(
    input clk,
    input reset,
    input RegWrite,
    input MemWrite,
    input MemRead,
    input [1:0] WDSel,
    input [3:0] DMType,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] ALUResult,
    input [31:0] MemWriteData,
    input [31:0] PC,
    output reg RegWrite_reg,
    output reg MemWrite_reg,
    output reg MemRead_reg,
    output reg [1:0] WDSel_reg,
    output reg [3:0] DMType_reg,
    output reg [4:0] rs2_reg,
    output reg [4:0] rd_reg,
    output reg [31:0] ALUResult_reg,
    output reg [31:0] MemWriteData_reg,
    output reg [31:0] PC_reg
);

    always@(posedge clk or posedge reset) begin
        if(reset) begin
            RegWrite_reg <= 0;
            MemWrite_reg <= 0;
            MemRead_reg <= 0;
            WDSel_reg <= 2'b0;
            DMType_reg <= 3'b0;
            rs2_reg <= 5'b0;
            rd_reg <= 5'b0;
            ALUResult_reg <= 32'b0;
            MemWriteData_reg <= 32'b0;
            PC_reg <= 32'b0;
        end
        else begin
            RegWrite_reg <= RegWrite;
            MemWrite_reg <= MemWrite;
            MemRead_reg <= MemRead;
            WDSel_reg <= WDSel;
            DMType_reg <= DMType;
            rs2_reg <= rs2;
            rd_reg <= rd;
            ALUResult_reg <= ALUResult;
            MemWriteData_reg <= MemWriteData;
            PC_reg <= PC;
        end
    end

endmodule