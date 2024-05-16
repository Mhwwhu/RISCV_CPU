`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/27 17:38:20
// Design Name: 
// Module Name: RegFile
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


module RegFile(
	input clk,
	input reset,
    input write_en,
    input [31:0] data_in,
    input [4:0] rs1_addr,
    input [4:0] rs2_addr,
    input [4:0] rd_addr,
    output [31:0] rs1_out,
    output [31:0] rs2_out
    );
    
    integer i;
    reg [31:0] regfile[31:1];
    
    always @(posedge clk, posedge reset) begin
        if(reset) for(i = 1; i < 32; i = i + 1) regfile[i] <= 32'b0;
		else if(write_en & rd_addr != 0) regfile[rd_addr] <= data_in;
	end
	

	assign rs1_out = rs1_addr == 0 ? 32'b0 : ((rs1_addr == rd_addr) && write_en) ? data_in : regfile[rs1_addr];
	assign rs2_out = rs2_addr == 0 ? 32'b0 : ((rs2_addr == rd_addr) && write_en) ? data_in : regfile[rs2_addr];
	
endmodule
