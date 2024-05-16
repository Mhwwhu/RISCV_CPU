`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/09 15:53:28
// Design Name: 
// Module Name: SSeg_interface
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


module SSeg_interface(
    input clk,
    input sys_clk,
    input rst,
    input [31:0] addr,
    inout [31:0] data,
    input wea,
    input rea,
    input flash,
    output [7:0] seg_an,
    output [7:0] seg_sout
    );
    
    reg [31:0] OutData;
    reg [31:0] data_buf[7:0];
    reg [31:0] control;
    reg [31:0] counter_val;
    reg [7:0] point;
    
    wire [31:0] offset = addr - 32'h500;
    wire en = (wea | rea) & (offset < 32'h30); //todo
    wire SSeg_en = control[31];
    wire counter_en = control[30];
    wire counter_out;
    wire graph_mode = control[29];
    wire reverse = control[28];
    wire [2:0] disp_data_sel = control[10:8];
    wire [7:0] LES = SSeg_en ? control[7:0] : 8'b0;
    wire [31:0] disp_data = data_buf[disp_data_sel];
    
    integer i;
    
    assign data = en & rea ? OutData : 32'bz;
    
    task write_data;
        input [31:0] off;
        input [31:0] WD;
        case(off)
            32'h0: control <= WD;
            32'h1: counter_val <= WD;
            32'h2: data_buf[0] <= WD;
            32'h3: data_buf[1] <= WD;
            32'h4: data_buf[2] <= WD;
            32'h5: data_buf[3] <= WD;
            32'h6: data_buf[4] <= WD;
            32'h7: data_buf[5] <= WD;
            32'h8: data_buf[6] <= WD;
            32'h9: data_buf[7] <= WD;
            32'ha: point <= WD[7:0];
        endcase
    endtask
    
    task read_data;
        input [31:0] off;
        case(off)
            32'h0: OutData <= control;
            32'h1: OutData <= counter_val;
            32'h2: OutData <= data_buf[0];
            32'h3: OutData <= data_buf[1];
            32'h4: OutData <= data_buf[2];
            32'h5: OutData <= data_buf[3];
            32'h6: OutData <= data_buf[4];
            32'h7: OutData <= data_buf[5];
            32'h8: OutData <= data_buf[6];
            32'h9: OutData <= data_buf[7];
            32'ha: OutData <= {24'b0, point};
        endcase
    endtask
    
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            for(i = 0; i < 8; i = i + 1) data_buf[i] <= 32'b0;
            control <= 32'b0;
            counter_val <= 32'b0;
            point <= 8'b0;
            OutData <= 32'b0;
        end
        else if(counter_out) begin 
            if(reverse) control[10:8] <= control[10:8] - 1'b1;
            else control[10:8] <= control[10:8] + 1'b1;
        end
        else if(en & wea) write_data(offset >> 2, data);
        else if(en & rea) read_data(offset >> 2);
    end
    
    SSeg7 U_SSeg7(
    .Hexs(disp_data),
    .LES(LES),
    .SW0(graph_mode),
    .clk(sys_clk),
    .rst(rst),
    .flash(flash),
    .point(point),
    .seg_an(seg_an),
    .seg_sout(seg_sout)
    );
    
    sseg7_counter U_sseg7_counter(
        .clk(clk),
        .rst(rst),
        .en(counter_en),
        .counter_val(counter_val),
        .out(counter_out)
    );
    
endmodule
