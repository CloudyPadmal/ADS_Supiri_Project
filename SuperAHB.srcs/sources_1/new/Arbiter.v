`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2018 03:07:19 PM
// Design Name: 
// Module Name: Arbiter
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


module Arbiter(
    input HBUSREQx1,
    input HLOCKx1,
    input HBUSREQx2,
    input HLOCKx2,
    input [11:0] HADDR,
    input [15:0] HSPLITx,
    input [1:0] HTRANS,
    input [2:0] HBURST,
    input [1:0] HRESP,
    input HREADY,
    input HRESETn,
    input HCLK,
    output HGRANT1,
    output HGRANT2,
    output [1:0] HMASTER,
    output HMASTLOCK
    );
endmodule
