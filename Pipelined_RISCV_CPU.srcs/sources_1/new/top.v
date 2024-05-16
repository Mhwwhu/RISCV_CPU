`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/20 16:49:16
// Design Name: 
// Module Name: top
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

module top(
input rstn,
input [4:0]btn_i,
input [15:0]sw_i,
input clk,

output[7:0] disp_an_o,
output[7:0] disp_seg_o,

output [15:0]led_o
);

wire [31:0] data_bus, addr_bus;
wire rst, CPU_MIO, mem_w, mem_r;
wire Clk_CPU;
wire [31:0] inst_in, PC;
wire [3:0] byte_en;
wire interrupt = 0;
wire [31:0] div;

assign rst = ~rstn;

SCPU U1_SCPU(.clk(Clk_CPU),			
                .reset(rst),	
                .inst_in(inst_in),
                .MIO_ready(CPU_MIO),
                .CPU_MIO(CPU_MIO),
                .mem_w(mem_w),
                .mem_r(mem_r),
                .PC_out(PC),
                .Addr_out(addr_bus),
                .Data_Bus(data_bus), 
                .byte_en(byte_en),
                .INT(interrupt)
                );

ROM U2_ROM(.a(PC[11:2]),
                .spo(inst_in)
                );

RAM U3_RAM(
.clk(clk),
.addr(addr_bus),
.data(data_bus),
.mem_w(mem_w),
.mem_r(mem_r),
.byte_en(byte_en)
);

LED_interface U4_LED(
.clk(clk),
.rst(rst),
.addr_bus(addr_bus),
.data_bus(data_bus),
.wea(mem_w),
.rea(mem_r),
.LED(led_o)
);

Enter_interface U5_Enter(
.clk(div[2]),
.rst(rst),
.addr(addr_bus),
.data(data_bus),
.wea(mem_w),
.rea(mem_r),
.btn_i(btn_i),
.sw_i(sw_i)
);

SSeg_interface U6_SSeg7(
.clk(clk),
.sys_clk(clk),
.rst(rst),
.addr(addr_bus),
.data(data_bus),
.wea(mem_w),
.rea(mem_r),
.flash(div[10]),
.seg_an(disp_an_o),
.seg_sout(disp_seg_o)
);

reg ClkSlowMode = 0;
//always@(negedge BTN_OK) begin
//    ClkSlowMode = ~ClkSlowMode;
//end

clk_div U8_clk_div(.clk(clk),
    .rst(rst),
    .SlowMode(ClkSlowMode),
    .clkdiv(div),
    .Clk_CPU(Clk_CPU));
endmodule
