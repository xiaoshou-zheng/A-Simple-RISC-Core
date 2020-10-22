`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Create Date: 2020/10/19 17:23:33
// Module Name: regfile
// Description: 
// 寄存器表，管理了16个寄存器。
// 可以根据源操作数的地址读出数据，也可以将数据写入规定地址的目的寄存器
//////////////////////////////////////////////////////////////////////////////////


module regfile #(
    parameter REG_ADDR_WIDTH = 4,   //地址宽度4位，一共16个寄存器
    parameter REG_DATA_WIDTH = 16,
    parameter REG_NUMBER = 16
)   (
    input [REG_ADDR_WIDTH-1:0] rs1_addr,
    input [REG_ADDR_WIDTH-1:0] rs2_addr,
    input [REG_ADDR_WIDTH-1:0] rd_addr,
    input [REG_DATA_WIDTH-1:0] rd_data,
    input RegWEn,
    input clk,
    input rst,
    output [REG_DATA_WIDTH-1:0] rs1_data,
    output [REG_DATA_WIDTH-1:0] rs2_data
);

    // 管理了16个16位寄存器
    reg [REG_DATA_WIDTH-1:0] rf [REG_NUMBER-1:0];

    //根据地址直接读出数据，按照惯例，0地址为0
    assign rs1_data = rs1_addr==0 ? 0:rf[rs1_addr];
    assign rs2_data = rs2_addr==0 ? 0:rf[rs2_addr];

    integer i;
    //-------------写回数据需要一个clk-----------------//
    always @(posedge clk or negedge rst) begin
        if(!rst) begin      //复位，全部置0          
            for (i=0;i<REG_NUMBER;i=i+1) begin
                rf[i] <= 0;
            end
        end
        else begin
            if (RegWEn && rd_addr != 0)
                rf[rd_addr] <= rd_data; //写入对应地址
        end
    end

endmodule