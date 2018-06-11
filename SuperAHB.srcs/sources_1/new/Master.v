`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2018 03:07:19 PM
// Design Name: 
// Module Name: Master
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


module Master(
    input HGRANTx,
    input HREADY,
    input [1:0] HRESP,
    input HRESETn,
    input HCLK,
    input [31:0] HRDATA,
    output HBUSREQx,
    output HLOCKx,
    output [1:0] HTRANS,
    output [11:0] HADDR,
    output HWRITE,
    output [2:0] HSIZE,
    output [2:0] HBURST,
    output [3:0] HPROT,
    output [31:0] HWDATA
    );
endmodule
