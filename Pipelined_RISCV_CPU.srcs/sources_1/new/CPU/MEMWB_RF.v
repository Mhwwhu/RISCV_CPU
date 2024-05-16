`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/24 19:15:20
// Design Name: 
// Module Name: MEMWB_RF
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


module MEMWB_RF(
    input clk,
    input reset,
    input RegWrite,
    input MemRead,
    input [1:0] WDSel,
    input [4:0] rd,
    input [31:0] ALUResult,
    input [31:0] MemReadData,
    input [31:0] PC,
    output reg RegWrite_reg,
    output reg [1:0] WDSel_reg,
    output reg [4:0] rd_reg,
    output reg [31:0] ALUResult_reg,
    output reg [31:0] MemReadData_reg,
    output reg [31:0] PC_reg,
    output reg MemRead_reg
    );
    
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            RegWrite_reg <= 0;
            WDSel_reg <= 1'b0;
            rd_reg <= 5'b0;
            ALUResult_reg <= 32'b0;
            MemReadData_reg <= 32'b0;
            PC_reg <= 32'b0;
            MemRead_reg <= 1'b0;
        end
        else begin
            RegWrite_reg <= RegWrite;
            WDSel_reg <= WDSel;
            rd_reg <= rd;
            ALUResult_reg <= ALUResult;
            MemReadData_reg <= MemReadData;
            PC_reg <= PC;
            MemRead_reg <= MemRead;
        end
    end
    
endmodule
