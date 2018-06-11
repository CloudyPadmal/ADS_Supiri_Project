`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2018 03:07:19 PM
// Design Name: 
// Module Name: Slave
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


module Slave(
    input HSELx,
    input [11:0] HADDR,
    input HWRITE,
    input [1:0] HTRANS,
    input [2:0] HSIZE,
    input [2:0] HBURST,
    input [31:0] HWDATA,
    input HRESETn,
    input HCLK,
    input [1:0] HMASTER,
    input HMASTLOCK,
    output HREADY,
    output [1:0] HRESP,
    output [31:0] HRDATA,
    output [15:0] HSPLITx
    );
endmodule
