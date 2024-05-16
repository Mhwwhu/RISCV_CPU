`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/23 09:56:46
// Design Name: 
// Module Name: SCPU
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
`include "../define.v"

module SCPU(
    input clk,
    input reset,
    input MIO_ready,
    input INT,
    input [31:0]inst_in,
    inout [31:0]Data_Bus,
    output mem_w,
    output mem_r,
    output [31:0]PC_out,
    output [31:0]Addr_out,
    output [3:0]byte_en,
    output CPU_MIO
    );
    
    // pipelining RF
    wire IFID_flush;
    wire IFID_we;
    wire IDEX_flush;
    
    // IF stage
    wire PC_we;
    wire [31:0] validNPC = jmp ? NPC : PC + 4;
    wire [31:0] PC;
    
    // ID stage
    wire jmp;
    wire sbtype;
    wire jalr;
    wire ID_ALUSrc1;
    wire ID_ALUSrc2;
    wire ID_RegWrite;
    wire ID_MemWrite;
    wire ID_MemRead;
    wire ID_rs1_en;
    wire ID_rs2_en;
    wire [10:0] ID_ALUOp;
    wire [31:0] ID_PC;
    wire [31:0] ID_instr;
    wire [31:0] ID_RD1;
    wire [31:0] ID_RD2;
    wire [31:0] ID_Data1;
    wire [31:0] ID_Data2;
    wire [2:0] branchOp;
    wire [31:0] NPC;
    wire [2:0] cmp;
    wire [31:0] ID_immediate;
    wire [4:0] ID_rs1 = ID_instr[19:15];
    wire [4:0] ID_rs2 = ID_instr[24:20];
    wire [4:0] ID_rd = ID_instr[11:7];
    wire [6:0] opcode = ID_instr[6:0];
    wire [6:0] funct7 = ID_instr[31:25];
    wire [2:0] funct3 = ID_instr[14:12];
    wire [1:0] ID_WDSel;
    wire [3:0] ID_DMType;
    
    // EX stage
    wire EX_ALUSrc1;
    wire EX_ALUSrc2;
    wire EX_RegWrite;
    wire EX_MemWrite;
    wire EX_MemRead;
    wire [1:0] EX_WDSel;
    wire [3:0] EX_DMType;
    wire [10:0] EX_ALUOp;
    wire [31:0] EX_immediate;
    wire [31:0] EX_RD1;
    wire [31:0] EX_RD2;
    wire [31:0] EX_PC;
    wire [31:0] EX_ALUResult;
    wire [4:0] EX_rs1;
    wire [4:0] EX_rs2;
    wire [4:0] EX_rd;
    wire ALUOverflow;
    wire [31:0] ALU_B;
    wire [31:0] ALU_A;
    wire [31:0] DataB;
    
    // MEM stage
    wire MEM_MemWrite;
    wire MEM_RegWrite;
    wire MEM_MemRead;
    wire [1:0] MEM_WDSel;
    wire [3:0] MEM_DMType;
    wire [31:0] MEM_ALUResult;
    wire [31:0] MEM_MemWriteData;
    wire [31:0] MEM_MemReadData;
    wire [4:0] MEM_rs2;
    wire [4:0] MEM_rd;
    wire [31:0] MEM_PC;
    
    
    
    // WB stage
    wire WB_RegWrite;
    wire [1:0] WB_WDSel;
    wire [4:0] WB_rd;
    wire [31:0] WB_ALUResult;
    wire [31:0] WB_MemReadData;
    wire [31:0] WB_PC;
    wire [31:0] WD = WB_WDSel == `WDSel_FromALU ? WB_ALUResult :
                WB_WDSel == `WDSel_FromPC  ? WB_PC + 4 :
                WB_WDSel == `WDSel_FromMEM ? WB_MemReadData :
                `zero_word;
    
    // forward
    wire [4:0] forwardA;
    wire [4:0] forwardB;
    wire WBMEM_Forward;
    
    // port
    assign MIO_ready = CPU_MIO;
    assign PC_out = PC;
    assign Addr_out = MEM_ALUResult;
    assign mem_w = MEM_MemWrite;
    assign mem_r = MEM_MemRead;
    assign byte_en = MEM_DMType[0] ? 4'b1111 :
                     MEM_DMType[1] ? 4'b0011 :
                     MEM_DMType[2] ? 4'b0001 :
                     4'b0000;
    
    control U_control(
    .Op(opcode), .Funct3(funct3), .Funct7(funct7), 
    .RegWrite(ID_RegWrite), .ALUSrc1(ID_ALUSrc1), .ALUSrc2(ID_ALUSrc2), .MemWrite(ID_MemWrite), .WDSel(ID_WDSel),
    .branchOp(branchOp), .DMType(ID_DMType), .ALUOp(ID_ALUOp), .MemRead(ID_MemRead),
    .rs1_en(ID_rs1_en), .rs2_en(ID_rs2_en), .sbtype(sbtype), .jalr(jalr)
    );
    
    ALU U_ALU(
    .data1(ALU_A), .data2(ALU_B), .ALUctrl(EX_ALUOp), .result(EX_ALUResult), .overflow(ALUOverflow)
    );
    
    // write enable is temporarily set to be 1. It will be replaced by real signal
    PC_reg U_PC(
    .clk(clk), .reset(reset), .we(PC_we), .next_pc(validNPC), .pc(PC)
    );
    
    RegFile U_RF(
     .clk(clk), .reset(reset), .write_en(WB_RegWrite), .data_in(WD), 
     .rs1_addr(ID_rs1), .rs2_addr(ID_rs2), .rd_addr(WB_rd),
     .rs1_out(ID_RD1), .rs2_out(ID_RD2)
     );
    
    ImmGen U_ImmGen(
    .instr(ID_instr), .imm(ID_immediate)
    );
    
    comparator U_comp(
    .data1(ID_Data1), .data2(ID_Data2), .cmp(cmp)
     );
    
    branch_ctrl U_branch(
    .pc(ID_PC), .imm(ID_immediate), .base_reg(ID_Data1), .branch_op(branchOp), .funct3(funct3), .cmp(cmp),
    .next_pc(NPC), .jmp(jmp)
    );
    
    IFID_RF U_IFID(
    .clk(clk), .reset(reset), .flush(IFID_flush), .we(IFID_we), .instr(inst_in), .PC(PC),
    .PC_reg(ID_PC), .instr_reg(ID_instr)               
    );
    
    IDEX_RF U_IDEX(
    .clk(clk), .reset(reset), .flush(IDEX_flush),
    .RegWrite(ID_RegWrite), .ALUSrc1(ID_ALUSrc1), .ALUSrc2(ID_ALUSrc2),
    .MemWrite(ID_MemWrite), .MemRead(ID_MemRead), .WDSel(ID_WDSel), .DMType(ID_DMType),
    .ALUOp(ID_ALUOp),.RD1(ID_RD1), .RD2(ID_RD2), .rs1(ID_rs1), .rs2(ID_rs2), .rd(ID_rd),
    .imm(ID_immediate), .PC(ID_PC),
    .RegWrite_reg(EX_RegWrite), .ALUSrc1_reg(EX_ALUSrc1), .ALUSrc2_reg(EX_ALUSrc2),
    .MemWrite_reg(EX_MemWrite), .MemRead_reg(EX_MemRead), .WDSel_reg(EX_WDSel), .DMType_reg(EX_DMType),
    .ALUOp_reg(EX_ALUOp), .RD1_reg(EX_RD1), .RD2_reg(EX_RD2), .rs1_reg(EX_rs1), .rs2_reg(EX_rs2), 
    .rd_reg(EX_rd), .imm_reg(EX_immediate), .PC_reg(EX_PC)
    );
    
    EXMEM_RF U_EXMEM(
    .clk(clk), .reset(reset), .RegWrite(EX_RegWrite), .MemWrite(EX_MemWrite), .MemRead(EX_MemRead),
    .WDSel(EX_WDSel), .DMType(EX_DMType), .rs2(EX_rs2), .rd(EX_rd), .ALUResult(EX_ALUResult), .MemWriteData(DataB),
    .PC(EX_PC), .RegWrite_reg(MEM_RegWrite), .MemWrite_reg(MEM_MemWrite), .MemRead_reg(MEM_MemRead), 
    .WDSel_reg(MEM_WDSel), .DMType_reg(MEM_DMType), .rs2_reg(MEM_rs2), .rd_reg(MEM_rd), 
    .ALUResult_reg(MEM_ALUResult), .MemWriteData_reg(MEM_MemWriteData), .PC_reg(MEM_PC)
    );
    
    MEMWB_RF U_MEMWB(
    .clk(clk), .reset(reset), .RegWrite(MEM_RegWrite), .WDSel(MEM_WDSel), .rd(MEM_rd), .ALUResult(MEM_ALUResult),
    .MemReadData(MEM_MemReadData), .PC(MEM_PC), .RegWrite_reg(WB_RegWrite), .WDSel_reg(WB_WDSel), 
    .rd_reg(WB_rd), .ALUResult_reg(WB_ALUResult), .MemReadData_reg(WB_MemReadData), .PC_reg(WB_PC)
    );
    
    HazardDetection U_Hazard(
    .jmp(jmp), .IDEX_MemRead(EX_MemRead), .EXMEM_MemRead(MEM_MemRead), .IDEX_RegWrite(EX_RegWrite),
    .IFID_MemWrite(ID_MemWrite), .IDEX_rd(EX_rd), .EXMEM_rd(MEM_rd), .IFID_rs1(ID_rs1), .IFID_rs2(ID_rs2), 
    .IFID_rs1_en(ID_rs1_en), .IFID_rs2_en(ID_rs2_en), .sbtype(sbtype), .jalr(jalr),
    .PC_we(PC_we), .IFID_we(IFID_we), .IFID_flush(IFID_flush), .IDEX_flush(IDEX_flush)
    );
    
    Forward U_Forward(
    .IFID_rs1(ID_rs1), .IFID_rs2(ID_rs2), .IDEX_rs1(EX_rs1), .IDEX_rs2(EX_rs2), .IDEX_rd(EX_rd),
    .EXMEM_rs2(MEM_rs2), .EXMEM_rd(MEM_rd), .MEMWB_rd(WB_rd), .IDEX_RegWrite(EX_RegWrite), 
    .EXMEM_RegWrite(MEM_RegWrite), .MEMWB_RegWrite(WB_RegWrite),
    .forwardA(forwardA), .forwardB(forwardB), .WBMEM_Forward(WBMEM_Forward)
    );
    
    ALUDataSel U_ALUDataSel(
    .RD1(EX_RD1), .RD2(EX_RD2), .immediate(EX_immediate), .IDEX_PC(EX_PC), .EXMEM_ALUResult(MEM_ALUResult),
    .EXMEM_PC(MEM_PC), .WB_WD(WD), .forwardA(forwardA[4:3]), .forwardB(forwardB[4:3]),
    .ALUSrc1(EX_ALUSrc1), .ALUSrc2(EX_ALUSrc2), .fromEXMEM_PC(MEM_WDSel[1]),
    .ALU_A(ALU_A), .ALU_B(ALU_B), .DataB(DataB)
    );
    
    CmpDataSel U_CmpDataSel(
    .RD1(ID_RD1), .RD2(ID_RD2), .forwardA(forwardA[2:0]), .forwardB(forwardB[2:0]),
    .EXMEM_ALUResult(MEM_ALUResult), .IDEX_PC(EX_PC), .EXMEM_PC(MEM_PC), .WB_WD(WD), .fromEXMEM_PC(MEM_WDSel[1]),
    .Data1(ID_Data1), .Data2(ID_Data2)
    );
    
    CPU_databus_interface U_CPU_databus_i(
    .raw_data(WBMEM_Forward ? WD : MEM_MemWriteData), .dm_ctrl(MEM_DMType), .data_bus(Data_Bus), 
    .mem_w(MEM_MemWrite), .mem_r(MEM_MemRead), .processed_data(MEM_MemReadData)
    );
    
endmodule
