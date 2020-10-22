`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Create Date: 2020/10/19 17:23:33
// Module Name: dcmem
// Description: 
// 放数据的内存，可以放32个16b的数据。
// 可以根据地址读出数据，也可以将数据写入规定地址
//////////////////////////////////////////////////////////////////////////////////


module dcmem #(
    parameter MEM_ADDR_WIDTH = 5,   //地址宽度5位，一共32个数据
    parameter MEM_DATA_WIDTH = 16,
    parameter MEM_NUMBER = 32
)   (
    input [MEM_ADDR_WIDTH-1:0] addr,    //写入和读出用同一个地址线
    input [MEM_DATA_WIDTH-1:0] data_w,
    input MemWEn,
    input clk,
    output [MEM_DATA_WIDTH-1:0] data_r
);
    reg [MEM_DATA_WIDTH-1:0] RAM [MEM_NUMBER-1:0];

    assign data_r = RAM[addr];  //读数据

//-----------写回数据需要一个clk-----------------//
    always @(posedge clk) begin
        if (MemWEn) begin
            RAM[addr] <= data_w;    //写数据
        end
    end

endmodule