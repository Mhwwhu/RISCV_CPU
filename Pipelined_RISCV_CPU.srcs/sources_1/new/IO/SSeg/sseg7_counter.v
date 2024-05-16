`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/09 19:55:30
// Design Name: 
// Module Name: sseg7_counter
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


module sseg7_counter(
    input clk,
    input rst,
    input en,
    input [31:0] counter_val,
    output reg out
    );
    
    reg [31:0] val = 32'b0;
    
    always@(posedge clk or posedge rst) begin
        if(rst) out <= 1'b0;
        else if(clk) begin
            if(en & ~out) begin
                val <= val - 1'b1;
                out <= ~(|val);
            end
            else begin
                val <= counter_val;
                out <= 1'b0;
            end
        end
    end
    
endmodule
