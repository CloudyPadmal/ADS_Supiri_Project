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
    input HBUSREQx2,
    input [1:0] HSPLITx,
    input [2:0] HREADY,
    input HRESETn,
    input HCLK,
    input HLOCKx,
    output reg HGRANT1,
    output reg HGRANT2,
    output reg [1:0] HMASTER//,
    //input [1:0] HTRANS,
    //input [2:0] HBURST,
    //input [1:0] HRESP,
    //input [13:0] HADDR,
    //output reg HMASTLOCK
    );
    
    localparam NORMAL_STATE = 0;
    localparam LOCKED_STATE = 1;
    
    wire [1:0] BUSREQUEST;
    assign BUSREQUEST = {HBUSREQx1, HBUSREQx2};
    
    reg CURRENT_STATE;
    
    always @ (negedge HCLK) begin
        if (HLOCKx == 1'b0) begin
            CURRENT_STATE <= NORMAL_STATE;
        end
    end
    
    always @ (posedge HCLK or negedge HRESETn) begin
        if (HRESETn == 1'b0)
            begin
                HGRANT1 <= 1'b0;
                HGRANT2 <= 1'b0;
                HMASTER <= 2'b0;
                //HMASTLOCK <= 1'b0;
            end
        else
            begin
            case (CURRENT_STATE) begin
                NORMAL_STATE:
                    begin
                        if (HREADY == 3'b111) begin
                                        case (BUSREQUEST)
                                            2'b01:
                                                begin
                                                    if (HSPLITx == 2'b10) begin
                                                        HGRANT1 <= 1'b1;
                                                        HGRANT2 <= 1'b0;
                                                        HMASTER <= 2'b10;
                                                    end
                                                    else begin
                                                        HGRANT1 <= 1'b0;
                                                        HGRANT2 <= 1'b1;
                                                        HMASTER <= 2'b01;
                                                    end
                                                end
                                            2'b10:
                                                begin
                                                    if (HSPLITx == 2'b01) begin
                                                          HGRANT1 <= 1'b0;
                                                          HGRANT2 <= 1'b1;
                                                          HMASTER <= 2'b01;
                                                    end
                                                    else begin
                                                        HGRANT1 <= 1'b1;
                                                        HGRANT2 <= 1'b0;
                                                        HMASTER <= 2'b10;
                                                    end
                                                end
                                            default:
                                                begin
                                                    HGRANT1 <= 1'b0;
                                                    HGRANT2 <= 1'b0;
                                                    HMASTER <= 2'b00; // Master request naththam HMASTER binduwai
                                                end
                                          endcase  
                                        end
                                    else
                                        begin
                                            HGRANT1 <= HGRANT1;
                                            HGRANT2 <= HGRANT2;
                                            HMASTER <= HMASTER;
                                        end
                    end
            endcase
            
                
            end  
        end
endmodule
