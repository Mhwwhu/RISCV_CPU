`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/08 12:39:37
// Design Name: 
// Module Name: RAM
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


module RAM(
    input clk,
    input [31:0] addr,
    inout [31:0] data,
    input mem_w,
    input mem_r,
    input [3:0] byte_en
    );
    
    wire [31:0] dina_dm, data_read;
    wire [31:0] addra, douta;
    wire [3:0] wea;
    wire en;
    
    assign en = (mem_w | mem_r) & ~(|addr[31:10]);
    assign data = mem_r & en ? data_read : 32'bz;
    
    dm_controller U_dm_controller(.mem_w(mem_w),
                                    .Addr_in(addr),
                                    .Data_write(data),
                                    .byte_en(byte_en),
                                    .Data_read_from_dm(douta),
                                    .Data_read(data_read),
                                    .Data_write_to_dm(dina_dm),
                                    .wea_mem(wea));
    
    DRAM U_DRAM(.addra(addr[11:2]),
                    .wea(wea),
                    .dina(dina_dm),
                    .clka(~clk),
                    .douta(douta));
    
endmodule
