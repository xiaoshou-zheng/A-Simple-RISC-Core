`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: tb
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////


module tb();
    parameter   ISA_WIDTH  = 16;
    parameter   REG_DATA_WIDTH = 16;
    parameter   REG_ADDR_WIDTH = 4;
    parameter MEM_ADDR_WIDTH = 5;   //地址宽度5位，一共32个数据
    parameter MEM_DATA_WIDTH = 16;

    reg clk;
    reg rst;
    reg  inst_wen;                //写入指令的使能------用于测试
    reg  [ISA_WIDTH - 1 : 0]   input_inst;  //写入指令------用于测试

    top top(
        .clk(clk),
        .rst(rst),
        .inst_wen(inst_wen),
        .input_inst(input_inst)
    );

    initial clk = 1;
    always #5 clk = ~clk;
    
    
    initial begin
        #1 rst <= 1'b1;
        #30 rst <= 1;
        #30 rst <= 0;
        #10 rst <= 1;
        // 烧录测试指令
        #5;
        inst_wen <= 1;

        input_inst <= 16'b010_0001_000000001;   //move r1 $1
        #10;
        input_inst <= 16'b011_0110_0001_0000_1;  //mac r6 r1 / $1    /把r1里的1放到偏置单元中
        #10;
        input_inst <= 16'b010_0010_000001111;   //move r2 $15
        #10;
        input_inst <= 16'b010_0011_000011111;   //move r3 $31
        #10;
        input_inst <= 16'b001_0000_0001_0010_0;   //store / r1 r2  //把$15存到RAM的1地址
        #10;
        input_inst <= 16'b000_0100_0001_00000;      //load r4 r1 $0   //把ram的1+0地址的数存到r4
        #10;
        input_inst <= 16'b001_0000_0010_0011_0;   //store / r2 r3  //把$31存到RAM的15地址
        #10;
        input_inst <= 16'b000_0101_0001_01110;      //load r5 r1 $14   //把ram的1+14地址的数存到r5
        #10;
        input_inst <= 16'b011_0110_0010_0011_0;  //mac r6 r2 r3 $0    /把15*31+1=466,放到r6中
        #10;
        input_inst <= 16'b011_0110_0010_0010_0;  //mac r6 r2 r4 $0    /把15*15+466=691,放到r6中
        #10;
        input_inst <= 16'b010_0111_000000010;   //move r7 $2
        #10;
        input_inst <= 16'b010_1000_000000011;   //move r8 $3
        #10;
        input_inst <= 16'b011_0110_0111_1000_0;  //mac r6 r7 r8 $0    /把2*3+691=697,放到r6中
        #10;
        input_inst <= 16'b001_0000_0000_0110_0;   //store / r0 r6  //把mac计算结果存到RAM的0地址

        
        // 烧录结束
        #10;
        inst_wen <= 0;
        rst <= 0;       // pc置0
        #10 rst <= 1;

        // 程序开始运行




    end



endmodule
