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


module IFID_RF(
    input clk,
    input reset,
    input flush,
    input we,
    input [31:0] instr,
    input [31:0] PC,
    output reg [31:0] PC_reg,
    output reg [31:0] instr_reg
    );
    
    
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            instr_reg <= 32'b0;
            PC_reg <= 32'b0;
        end
        else if(we) begin
            if(flush) instr_reg <= 32'b0;
            else begin
                PC_reg <= PC;
                instr_reg <= instr;
            end
        end
    end
    
endmodule
