`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/27 22:49:31
// Design Name: 
// Module Name: comparator
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


module comparator(
	input [31:0] data1,
	input [31:0] data2,
	output [2:0] cmp
    );
    
    assign cmp[0] = data1 == data2;
    assign cmp[1] = data1 < data2;
    assign cmp[2] = $unsigned(data1) < $unsigned(data2);
    
endmodule
