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
    input CLK,
    input RST,

    input BUS_REQ_1,
    input BUS_REQ_2,
    input [31:0] M1_IN,
    input [31:0] M2_IN,
    output GRANTED_1,
    output GRANTED_2,
    output SEL_MASTER,
    output [31:0] S1_OUT,
    output [31:0] S2_OUT,
    output [31:0] S3_OUT,
    output [11:0] ADDRESS_OUT
    );
    
    
    
    Arbiter SupiriArbiter(
        .HBUSREQx1(BUS_REQ_1),
        .HBUSREQx2(BUS_REQ_2),
        .HSPLITx(),
        //HTRANS,
        //HBURST,
        //HRESP,
        .HREADY(),
        .HRESETn(RST),
        .HCLK(CLK),
        .HGRANT1(GRANTED_1),
        .HGRANT2(GRANTED_2),
        .HMASTER(SEL_MASTER)//,
        //output reg HMASTLOCK
        );
endmodule
