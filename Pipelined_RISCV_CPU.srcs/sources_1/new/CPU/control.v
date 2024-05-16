`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/28 17:59:15
// Design Name: 
// Module Name: control
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


module control(
	input [6:0] Op,
	input [2:0] Funct3,
	input [6:0] Funct7,
	output RegWrite,
	output ALUSrc2,
	output ALUSrc1,
	output MemWrite,
	output MemRead,
	output [1:0] WDSel,
	output [2:0] branchOp,
	output [3:0] DMType,
	output [10:0] ALUOp,
	output rs1_en,
	output rs2_en,
	output sbtype,
	output jalr
    );
    
    // lui
   	wire i_lui = ~Op[6]&Op[5]&Op[4]&~Op[3]&Op[2]&Op[1]&Op[0]; //0110111
   
   	// auipc
   	wire i_auipc = ~Op[6]&~Op[5]&Op[4]&~Op[3]&Op[2]&Op[1]&Op[0]; //0010111
   
  	// r format
    wire rtype = ~Op[6]&Op[5]&Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; //0110011
    wire i_add = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]&~Funct3[0]; // add 0000000 000
    wire i_sub = rtype& ~Funct7[6]& Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]&~Funct3[0]; // sub 0100000 000
    wire i_or  = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]& Funct3[1]&~Funct3[0]; // or 0000000 110
    wire i_and = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]& Funct3[1]& Funct3[0]; // and 0000000 111
    wire i_xor = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]&~Funct3[1]&~Funct3[0]; // xor 0000000 100
    wire i_sll = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]& Funct3[0]; // sll 0000000 001
    wire i_srl = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]&~Funct3[1]& Funct3[0]; // srl 0000000 101
    wire i_sra = rtype& ~Funct7[6]& Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]&~Funct3[1]& Funct3[0]; // sra 0100000 101
    wire i_slt = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]& Funct3[1]&~Funct3[0]; // slt 0000000 010
    wire i_sltu= rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]& Funct3[1]& Funct3[0]; // sltu 0000000 011
    
 	// i format
    wire itype_l  = ~Op[6]&~Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; //0000011
    wire i_lb = itype_l&~Funct3[2]&~Funct3[1]&~Funct3[0]; // lb 000
    wire i_lh = itype_l&~Funct3[2]&~Funct3[1]& Funct3[0]; // lh 001
    wire i_lw = itype_l&~Funct3[2]& Funct3[1]&~Funct3[0]; // lw 010
    wire i_lbu= itype_l& Funct3[2]&~Funct3[1]&~Funct3[0]; // lbu 100
    wire i_lhu= itype_l& Funct3[2]&~Funct3[1]& Funct3[0]; // lhu 101
    
	// i format
    wire itype_r  = ~Op[6]&~Op[5]&Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; //0010011
    wire i_addi = itype_r&~Funct3[2]&~Funct3[1]&~Funct3[0]; // addi 000
    wire i_andi = itype_r& Funct3[2]& Funct3[1]& Funct3[0]; // andi 111
    wire i_ori  = itype_r& Funct3[2]& Funct3[1]&~Funct3[0]; // ori 110
    wire i_xori = itype_r& Funct3[2]&~Funct3[1]&~Funct3[0]; // xori 100
    wire i_slti = itype_r&~Funct3[2]& Funct3[1]&~Funct3[0]; // slti 010
    wire i_sltiu= itype_r&~Funct3[2]& Funct3[1]& Funct3[0]; // sltiu 011
    wire i_slli = itype_r&~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]& Funct3[0]; // slli 0000000 001
    wire i_srli = itype_r&~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]&~Funct3[1]& Funct3[0]; // srli 0000000 101
	wire i_srai = itype_r&~Funct7[6]& Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]&~Funct3[1]& Funct3[0]; // srai 0100000 101
	
 	//jalr
	wire i_jalr =Op[6]&Op[5]&~Op[4]&~Op[3]&Op[2]&Op[1]&Op[0];//jalr 1100111
	assign jalr = i_jalr;

  	// s format
   	wire stype  = ~Op[6]&Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0];//0100011
   	wire i_sw   =  stype& ~Funct3[2]& Funct3[1]&~Funct3[0]; // sw 010
   	wire i_sh   =  stype& ~Funct3[2]&~Funct3[1]& Funct3[0]; // sh 001
   	wire i_sb   =  stype& ~Funct3[2]&~Funct3[1]&~Funct3[0]; // sb 000

  	// sb format
   	assign sbtype  = Op[6]&Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0];//1100011
   	wire i_beq  = sbtype& ~Funct3[2]& ~Funct3[1]& ~Funct3[0]; // beq 000
   	wire i_bne  = sbtype& ~Funct3[2]& ~Funct3[1]&  Funct3[0]; // bne 001
   	wire i_blt  = sbtype&  Funct3[2]& ~Funct3[1]& ~Funct3[0]; // blt 100
   	wire i_bge  = sbtype&  Funct3[2]& ~Funct3[1]&  Funct3[0]; // bge 101
   	wire i_bltu = sbtype&  Funct3[2]&  Funct3[1]& ~Funct3[0]; // bltu 110
   	wire i_bgeu = sbtype&  Funct3[2]&  Funct3[1]&  Funct3[0]; // bgeu 111
	
 	// j format
   	wire i_jal  = Op[6]& Op[5]&~Op[4]& Op[3]& Op[2]& Op[1]& Op[0];  // jal 1101111

  	// generate control signals
  	assign RegWrite   = rtype | itype_r | i_jalr | i_jal | itype_l | i_lui | i_auipc; // register write
  	assign MemWrite   = stype;                           // memory write
	assign MemRead = itype_l;  
  
  
  	// WDSel_FromALU 2'b00
  	// WDSel_FromMEM 2'b01
  	// WDSel_FromPC  2'b10 
  	assign WDSel[0] = itype_l;
  	assign WDSel[1] = i_jal | i_jalr;
  	
  	// branch_op: 100 jal, 010 jalr, 001 sb, 000 nop
  	assign branchOp[0] = sbtype;
  	assign branchOp[1] = i_jalr;
  	assign branchOp[2] = i_jal;
  	
  	assign ALUOp[0] = i_add | i_addi | stype | itype_l | i_auipc;
  	assign ALUOp[1] = i_sub;
  	assign ALUOp[2] = i_and | i_andi;
  	assign ALUOp[3] = i_or | i_ori;
  	assign ALUOp[4] = i_xor | i_xori;
  	assign ALUOp[5] = i_slt | i_slti;
  	assign ALUOp[6] = i_sltu | i_sltiu;
  	assign ALUOp[7] = i_sll | i_slli;
  	assign ALUOp[8] = i_srl | i_srli;
  	assign ALUOp[9] = i_sra | i_srai;
  	assign ALUOp[10] = i_lui;
  	
  	assign ALUSrc2 = itype_r | itype_l | stype | i_lui | i_auipc;
  	assign ALUSrc1 = i_auipc;
  
	// dm_word 4'b0001
   	// dm_halfword 4'b0010
   	// dm_halfword_unsigned 4'b1010
   	// dm_byte 4'b0100
   	// dm_byte_unsigned 4'b1100
   	assign DMType[0] = i_lw | i_sw;
   	assign DMType[1] = i_lh | i_lhu | i_sh;
   	assign DMType[2] = i_lb | i_lbu | i_sb;
   	assign DMType[3] = i_lbu | i_lhu;
   	
   	assign rs1_en = rtype | itype_l | itype_r | i_jalr | stype | sbtype;
   	assign rs2_en = rtype | stype | sbtype;
    
endmodule
