`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/15 20:05:48
// Design Name: 
// Module Name: CPU_databus_interface
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


module CPU_databus_interface(
    input [31:0] raw_data,
    input [3:0] dm_ctrl,
    input mem_w,
    input mem_r,
    inout [31:0] data_bus,
    output [31:0] processed_data
    );
    
    wire en = mem_w | mem_r;
    wire [31:0] write_data;
    
    assign data_bus = mem_w ? write_data : 32'bz;
    assign write_data = dm_ctrl[0] ? raw_data :
                        dm_ctrl[1] ? {16'b0, raw_data[15:0]} :
                        dm_ctrl[2] ? {24'b0, raw_data[7:0]} :
                        32'b0;
    assign processed_data = ~mem_r ? 32'b0 :
                            dm_ctrl[0] ? data_bus :
                            dm_ctrl[1] & dm_ctrl[3] ? {16'b0, data_bus[15:0]} :
                            dm_ctrl[1] & ~dm_ctrl[3] ? {{16{data_bus[15]}}, data_bus[15:0]} :
                            dm_ctrl[2] & dm_ctrl[3] ? {24'b0, data_bus[7:0]} :
                            dm_ctrl[2] & ~dm_ctrl[3] ? {{24{data_bus[7]}}, data_bus[7:0]} :
                            32'b0; // Should throw Exception
endmodule
