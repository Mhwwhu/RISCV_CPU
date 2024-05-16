`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/08 18:11:08
// Design Name: 
// Module Name: Enter_interface
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


module Enter_interface(
    input clk,
    input rst,
    input [31:0] addr,
    inout [31:0] data,
    input [4:0] btn_i,
    input [15:0] sw_i,
    input rea,
    input wea
    );
    
    reg [1:0] enter_en; // 0x408
    reg [20:0] status;  // 0x40c
    wire [20:0] enter_status;
    reg [31:0] OutData;
    
    wire en = (rea | wea) & ((addr == 32'h408) | (addr == 32'h40c));
    assign data = en & rea ? OutData : 32'bz;
    
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            enter_en <= 2'b0;
            status <= 21'b0;
            OutData <= 32'b0;
        end
        else if(en) begin
            if(enter_en[1]) status[20:16] <= enter_status[20:16];
            else status[20:16] <= 5'b0;
            if(enter_en[0]) status[15:0] <= enter_status[15:0];
            else status[15:0] <= 16'b0;
            if(rea) begin
                if(addr[2]) begin
                    OutData <= {11'b0, status};
                end
                else begin
                    OutData <= {30'b0, enter_en};
                end
            end
            else if(wea) begin
                if(addr[2] == 1'b0) enter_en <= data[1:0];
            end
        end
    end
    
    Enter U_Enter_core(
    .clk(clk),
    .BTN(btn_i),
    .SW(sw_i),
    .BTN_out(enter_status[20:16]),
    .SW_out(enter_status[15:0])
    );
    
endmodule
