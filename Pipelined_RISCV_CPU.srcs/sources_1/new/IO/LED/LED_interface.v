`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/08 17:27:11
// Design Name: 
// Module Name: LED_interface
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


module LED_interface(
    input clk,
    input rst,
    input [31:0] addr_bus,
    input wea,
    input rea,
    inout [31:0] data_bus,
    output [15:0] LED
    );
    
    reg LED_EN;
    reg [15:0] control;
    reg [31:0] OutData;
    wire en = ((addr_bus == 32'h400) | (addr_bus == 32'h404)) & (wea | rea);
    assign data_bus = rea & en ? OutData : 32'bz;
    
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            LED_EN <= 0;
            control <= 16'b0;
            OutData <= 32'b0;
        end
        else if(wea & en) begin
            if(addr_bus[2]) control <= data_bus[15:0];
            else LED_EN <= data_bus[0];
        end
        else if(rea & en) begin
            if(addr_bus[2]) OutData <= {16'b0, control};
            else OutData <= {31'b0, LED_EN};
        end
    end
    
    assign LED = LED_EN ? control : 16'b0;
    
endmodule
