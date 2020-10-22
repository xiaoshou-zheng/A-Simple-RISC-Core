`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: top
// Description: 
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module top #(
    parameter   ISA_WIDTH  = 16,
    parameter   REG_DATA_WIDTH = 16,
    parameter   REG_ADDR_WIDTH = 4,
    parameter MEM_ADDR_WIDTH = 5,   //地址宽度5位，一共32个数据
    parameter MEM_DATA_WIDTH = 16
)   (
    input clk,
    input rst,
    input  inst_wen,                //写入指令的使能------用于测试
    input  [ISA_WIDTH - 1 : 0]   input_inst  //写入指令------用于测试


    );
    parameter LOAD = 3'b000;
    parameter STORE = 3'b001;
    parameter MOVE = 3'b010;
    parameter MAC = 3'b011;


    wire [ISA_WIDTH - 1 : 0] current_inst;

    icmem icmem1(
        .clk(clk),
        .rst(rst),
        .inst_wen(inst_wen),
        .input_inst(input_inst),
        .current_inst(current_inst)
    );

    wire [REG_ADDR_WIDTH - 1 : 0]   rd_addr;
    wire [REG_ADDR_WIDTH - 1 : 0]   rs1_addr;
    wire [REG_ADDR_WIDTH - 1 : 0]   rs2_addr;
    wire [4:0] imm5;
    wire [8:0] imm9;
    wire funct;
    wire [2:0] opcode;
    wire RegWEn;
    wire MemWEn;
    wire MacEn;

    decode decode1(
        .inst(current_inst),
        .rd_addr(rd_addr),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .imm5(imm5),
        .imm9(imm9),
        .funct(funct),
        .opcode(opcode),
        .RegWEn(RegWEn),
        .MemWEn(MemWEn),
        .MacEn(MacEn)
    );

    wire [REG_DATA_WIDTH-1:0] rd_data;  //寄存器写回    //------------//
    wire [REG_DATA_WIDTH-1:0] rs1_data; //读出的数据
    wire [REG_DATA_WIDTH-1:0] rs2_data; //读出的数据

    regfile regfile1(
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .rd_data(rd_data),
        .RegWEn(RegWEn),
        .clk(clk),
        .rst(rst),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    wire [REG_DATA_WIDTH - 1 : 0] alu_output;

    ALU ALU1(
        .clk(clk),
        .funct(funct),
        .MacEn(MacEn),
        .rs1(rs1_data),
        .rs2(rs2_data),
        .rd(alu_output)
    );

    wire [REG_DATA_WIDTH - 1 : 0] dcmem_addr;
    assign dcmem_addr = opcode==LOAD ? (imm5+rs1_data):rs1_data;

    wire [MEM_DATA_WIDTH - 1 : 0] dcmem_output;

    dcmem dcmem1(
        .addr(dcmem_addr),
        .data_w(rs2_data),
        .MemWEn(MemWEn),
        .clk(clk),
        .data_r(dcmem_output)
    );

    assign rd_data = opcode==LOAD ? dcmem_output:(
                     opcode==MOVE ? imm9:alu_output);
    

endmodule
