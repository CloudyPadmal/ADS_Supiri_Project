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
    input [1:0] HSPLITx,
    input [1:0] HTRANS,
    input [2:0] HBURST,
    input [1:0] HRESP,
    input HREADY,
    input HRESETn,
    input HCLK,
    output reg HGRANT1,
    output reg HGRANT2,
    output reg [1:0] HMASTER,
    output reg HMASTLOCK
    );
    
    wire [1:0] BUSREQUEST;
    assign BUSREQUEST = {HBUSREQx1, HBUSREQx2};
    
    always @ (posedge HCLK or negedge HRESETn) begin
        if (HRESETn == 1'b0)
            begin
                HGRANT1 <= 1'b0;
                HGRANT2 <= 1'b0;
                HMASTER <= 2'b0;
                HMASTLOCK <= 1'b0;
            end
        else
            begin
                case (BUSREQUEST)
                    2'b01:
                        begin
                            case (HSPLITx)
                                2'b10:
                                    begin
                                        HGRANT1 <= 1'b1;
                                        HGRANT2 <= 1'b0;
                                        HMASTER <= 2'b10;
                                    end
                                default:
                                    begin
                                        HGRANT1 <= 1'b0;
                                        HGRANT2 <= 1'b1;
                                        HMASTER <= 2'b01;
                                    end
                            endcase
                        end
                    2'b10:
                        begin
                            case (HSPLITx)
                                2'b01:
                                    begin
                                      HGRANT1 <= 1'b0;
                                      HGRANT2 <= 1'b1;
                                      HMASTER <= 2'b01;
                                    end
                                default:
                                    begin
                                        HGRANT1 <= 1'b1;
                                        HGRANT2 <= 1'b0;
                                        HMASTER <= 2'b10;
                                    end
                            endcase
                        end
                    default:
                        begin
                            HGRANT1 <= 1'b0;
                            HGRANT2 <= 1'b0;
                            HMASTER <= 2'b00; // Master request naththam HMASTER binduwai
                        end
                  endcase  
            end  
       end
endmodule
