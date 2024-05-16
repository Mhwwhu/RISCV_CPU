`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:22:10 11/03/2014 
// Design Name: 
// Module Name:    Input_2_32bit 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module   Enter(input clk,
                input[4:0] BTN,	 // äº”ä¸ªæŒ‰é”®
                input[15:0] SW, // ï¿??ï¿??
                output reg [4:0] BTN_out,
                output reg [15:0] SW_out // ï¿??ï¿??
            );
    
    parameter stable_period = 0001; //20ms
	reg [31:0] counter1 = 0;
	reg [31:0] counter2 = 0;
	reg [4:0] last_BTN;
	reg [15:0] last_SW;
	
	initial begin
	   BTN_out <= 5'b0;
	   SW_out <= 16'b0;
	end

     always @(clk, BTN, SW) begin
         if(clk) begin
            if(BTN == last_BTN) begin
                if(counter1 < stable_period) counter1 <= counter1 + 1;
                else begin 
                    counter1 <= 0;
                    BTN_out <= BTN;
                end
            end
            else begin
                counter1 <= 0;
                last_BTN <= BTN;
            end
            if(SW == last_SW) begin
                if(counter2 < stable_period) counter2 <= counter2 + 1;
                else begin
                    counter2 <= 0;
                    SW_out <= SW;
                end
            end
            else begin
                counter2 <= 0;
                last_SW <= SW;
            end
         end
     end

endmodule
