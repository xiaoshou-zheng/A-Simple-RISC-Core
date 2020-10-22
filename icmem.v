`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Create Date: 2020/10/19 17:23:33
// Module Name: icmem
// Description: 
// 放指令的内存，可以放32条16b的指令。
// 可以根据pc读出指令，也可以将指令依次写入规定pc
//////////////////////////////////////////////////////////////////////////////////
module icmem #(
    parameter    PC_WIDTH  = 16,
    parameter    ISA_WIDTH = 16     //我们在dcmem的基础上，其实只用到5位
)   (
    input  clk,
    input  rst,
    input  inst_wen,                //写入指令的使能------用于测试
    input  [ISA_WIDTH - 1 : 0]   input_inst,  //写入指令------用于测试
    output [ISA_WIDTH - 1 : 0]   current_inst
);

    reg [PC_WIDTH-1:0] pc;

    always @(posedge clk or negedge rst) begin
        if(!rst)
            pc <= 0;
        else
            pc<=pc+1;
    end

//-------------烧录程序，每一条需要一个clk---------------//
    dcmem inst_mem(
        .addr(pc),
        .data_w(input_inst),
        .MemWEn(inst_wen),
        .clk(clk),
        .data_r(current_inst)
    );

endmodule  //icmem
