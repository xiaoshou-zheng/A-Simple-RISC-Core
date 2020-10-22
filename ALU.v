`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Create Date: 2020/10/19 17:23:33
// Module Name: ALU
// Description: 
// 主要用于计算MAC
//////////////////////////////////////////////////////////////////////////////////

module ALU #(
    parameter    REG_DATA_WIDTH  = 16
)   (
    input                           clk,
    input                           funct,
    input                           MacEn,
    input  [REG_DATA_WIDTH - 1 : 0] rs1, rs2,
    output [REG_DATA_WIDTH - 1 : 0] rd
);

//可能要一个控制信号...叫做mac_en
    wire [REG_DATA_WIDTH-1:0] product;
    wire [REG_DATA_WIDTH-1:0] addend1, addend2;
    reg  [REG_DATA_WIDTH-1:0] psum;

    assign product = $signed(rs1)*$signed(rs2); //乘号
    assign addend1 = funct?0:product;
    assign addend2 = funct?rs1:psum;
    assign rd      = addend1 + addend2;

    always @(posedge clk) begin
        if (MacEn) begin
            if(funct)
                psum <= rd;
            else
                psum <= rd;
        end 
        else begin
            psum <= psum;
        end
        
    end 

endmodule  //ALU

