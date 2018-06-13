`timescale 1ns / 1ps

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
    output reg [1:0] HMASTER,
    output reg HMASTLOCK
    //input [1:0] HTRANS,
    //input [2:0] HBURST,
    //input [1:0] HRESP,
    //input [13:0] HADDR,
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
        else begin
            CURRENT_STATE <= LOCKED_STATE;
        end
    end
    
    always @ (posedge HCLK or negedge HRESETn) begin
        if (!HRESETn)
            begin
                HGRANT1 <= 1'b0;
                HGRANT2 <= 1'b0;
                HMASTER <= 2'b0;
                //HMASTLOCK <= 1'b0;
            end
        else
            begin
                case (CURRENT_STATE)
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
                                    2'b11:
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
                    LOCKED_STATE:
                        begin
                           HGRANT1 <= HGRANT1;
                           HGRANT2 <= HGRANT2;
                           HMASTER <= HMASTER;
                        end                 
                endcase 
            end  
        end
endmodule
