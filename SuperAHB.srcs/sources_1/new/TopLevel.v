`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2018 04:53:58 PM
// Design Name: 
// Module Name: TopLevel
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


module TopLevel(
    input [31:0] M1_IN,
    input [31:0] M2_IN,
    output [31:0] S1_OUT,
    output [31:0] S2_OUT,
    output [31:0] S3_OUT,
    output [11:0] ADDRESS_OUT
    );
    
    
    
    Arbiter SupiriArbiter(
        .HBUSREQx1(),
        .HBUSREQx2(),
        .HSPLITx(),
        //input [1:0] HTRANS,
        //input [2:0] HBURST,
        //input [1:0] HRESP,
        input [2:0] HREADY,
        input HRESETn,
        input HCLK,
        output reg HGRANT1,
        output reg HGRANT2,
        output reg [1:0] HMASTER//,
        //output reg HMASTLOCK
        );
endmodule
