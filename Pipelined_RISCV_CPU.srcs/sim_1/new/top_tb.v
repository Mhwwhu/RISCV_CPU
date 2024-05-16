`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/10 16:10:07
// Design Name: 
// Module Name: top_tb
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


module top_tb;

reg rstn;
reg [4:0] btn_i;
reg [15:0] sw_i;
reg clk;
wire [7:0] disp_an_o;
wire [7:0] disp_seg_o;
wire [15:0] led_o;

top U_TOP(.rstn(rstn), .btn_i(btn_i), .sw_i(sw_i), .clk(clk),
         .disp_an_o(disp_an_o), .disp_seg_o(disp_seg_o), .led_o(led_o));

initial begin
    sw_i = 16'b0;
    btn_i = 5'b0;
    clk = 1;
    rstn = 1;
    #5
    clk = 0;
    rstn = 0;
    #20
    rstn = 1;
    btn_i[0] = 1;
    #2e6
    sw_i[8] = 1;
end

always begin
    #1 clk = ~clk;
end

endmodule
