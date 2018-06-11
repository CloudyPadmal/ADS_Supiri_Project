`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Moratuwa
// Engineer: 
// 
// Create Date: 06/11/2018 03:07:19 PM
// Design Name: 
// Module Name: Decoder
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
// Reference: https://www.researchgate.net/figure/An-example-AHB-system-with-one-master-and-one-slave_fig5_221004353
//////////////////////////////////////////////////////////////////////////////////


module Decoder(
    input [11:0] HADDR,
    input HCLK,
    input HRESETn,
    output reg HSELx1,
    output reg HSELx2,
    output reg HSELx3
    );    
    
    always @ (posedge HCLK) 
        case (HADDR)
            12'b1111_0000_0000:
                begin
                    HSELx1 = 1'b1;
                    HSELx2 = 1'b0;
                    HSELx3 = 1'b0;
                end
            12'b0000_1111_0000:
                begin
                    HSELx1 = 1'b0;
                    HSELx2 = 1'b1;
                    HSELx3 = 1'b0;
                end
            12'b0000_0000_1111:
                begin
                    HSELx1 = 1'b0;
                    HSELx2 = 1'b0;
                    HSELx3 = 1'b1;
                end
            default:
                begin
                    HSELx1 = 1'b0;
                    HSELx2 = 1'b0;
                    HSELx3 = 1'b0;
                end
        endcase 
    
endmodule
