`timescale 1ns / 1ps


module Arbiter_Sim();
    reg HBUSREQx1;
    reg HBUSREQx2;
    reg [1:0] HSPLITx;
    reg [2:0] HREADY;
    reg HRESETn;
    reg HCLK;
    reg HLOCKx;
    wire HGRANT1;
    wire HGRANT2;
    wire [1:0] HMASTER;
    wire HMASTLOCK;
    initial begin
      HCLK = 1'b0;
      forever begin
          #1 HCLK = ~HCLK;
      end
    end
    Arbiter a(
    .HBUSREQx1(HBUSREQx1),
    .HBUSREQx2(HBUSREQx2),
    .HSPLITx(HSPLITx),
    .HREADY(HREADY),
    .HRESETn(HRESETn),
    .HCLK(HCLK),
    .HLOCKx(HLOCKx),
    .HGRANT1(HGRANT1),
    .HGRANT2(HGRANT2),
    .HMASTER(HMASTER),
    .HMASTLOCK(HMASTLOCK)
  );
  initial begin 
    #2
    HRESETn = 1'b0;
    #2
    HRESETn = 1'b1;
    #2
    HLOCKx=1'b0;
    HBUSREQx1=1'b1;
    HBUSREQx2=1'b0;
    HREADY=3'd7;
    #12
    HLOCKx=1'b0;
    HBUSREQx1=1'b1;
    HBUSREQx2=1'b1;
    HREADY=3'd7;
    #12    
    
    $finish;
  end
    
 
endmodule
