`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/27 20:27:40
// Design Name: 
// Module Name: ALU
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

module ALU(
	input [31:0] data1,
	input [31:0] data2,
	input [10:0] ALUctrl,
	output [31:0] result,
	output overflow
    );
    
    assign result = ALUctrl[0]  ? data1 + data2 :
    				ALUctrl[1]  ? data1 - data2 :
    				ALUctrl[2]  ? data1 & data2 :
    				ALUctrl[3]  ? data1 | data2 :
    				ALUctrl[4]  ? data1 ^ data2 :
    				ALUctrl[5]  ? {{31'b0}, data1 < data2} :
    				ALUctrl[6]  ? {{31'b0}, $unsigned(data1) < $unsigned(data2)} :
    				ALUctrl[7]  ? data1 << data2 :
    				ALUctrl[8]  ? data1 >> data2 :
    				ALUctrl[9]  ? $signed($signed(data1) >>> data2) :
    				ALUctrl[10] ? data2 :
    				`zero_word;
    				
    assign overflow = (ALUctrl[0] && ((data1[31] & data2[31] & ~result[31]) | (~data1[31] & ~data2[31] & result[31]))
    				 | ALUctrl[1] && ((data1[31] & ~data2[31] & ~result[31]) | (~data1[31] & data2[31] & result[31])));
    
endmodule
