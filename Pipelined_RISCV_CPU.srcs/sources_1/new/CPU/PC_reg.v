`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/27 21:22:34
// Design Name: 
// Module Name: PC_reg
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


module PC_reg(
	input [31:0] next_pc,
	input clk,
	input reset,
	input we,
	output reg [31:0] pc
    );
    
    initial begin
        pc <= 32'b0;
    end
    
    always @(posedge clk or posedge reset) begin
        if(reset) pc <= 32'b0;
        else if(we) pc <= next_pc;
	end
    
endmodule
