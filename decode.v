`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/10/19 17:23:33
// Module Name: decode
// Description: 
// 译码模块
// 
//////////////////////////////////////////////////////////////////////////////////

module decode #(
    parameter    ISA_WIDTH  = 16,
    parameter    REG_ADDR_WIDTH = 4
)   (
    input  [ISA_WIDTH - 1 : 0]    inst,

    //-------------------
    output [REG_ADDR_WIDTH - 1 : 0]   rd_addr,
    output [REG_ADDR_WIDTH - 1 : 0]   rs1_addr,
    output [REG_ADDR_WIDTH - 1 : 0]   rs2_addr,
    output [4:0] imm5,
    output [8:0] imm9,
    output funct,
    output [2:0] opcode,
    output RegWEn,
    output MemWEn,
    output MacEn
);


assign opcode = inst[15:13];    //开头三位是操作码

parameter LOAD = 3'b000;
parameter STORE = 3'b001;
parameter MOVE = 3'b010;
parameter MAC = 3'b011;

assign rd_addr = opcode==STORE ? 0:inst[12:9];    //是0，需不需要另外的控制信号？
assign rs1_addr = opcode==MOVE ? 0:inst[8:5];        //MOV没有源寄存器
assign rs2_addr = opcode==STORE ? inst[4:1]:(opcode==MAC ? inst[4:1]:0);
assign imm5 = opcode==LOAD ? inst[4:0]:0;
assign imm9 = opcode==MOVE ? inst[8:0]:0;
assign funct = opcode==MAC ? inst[0]:0;         //需不需要控制信号？？？

assign RegWEn = opcode==STORE ? 0:1;
assign MemWEn = ~RegWEn;
assign MacEn = opcode==MAC ? 1:0;


endmodule  //decode