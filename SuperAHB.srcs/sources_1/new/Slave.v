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
// Reference: https://github.com/RoaLogic/ahb3lite_apb_bridge/blob/master/rtl/verilog/ahb3lite_apb_bridge.sv
// Reference: http://vlsionnet.blogspot.com/2014/06/ahb-master-verilog-code-testbench.html
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
    
    always @ (posedge HCLK & HSELx)
        begin
            
        end
    
endmodule

module Slave_tb();

    reg HSELx;
    reg [11:0] HADDR;
    reg HWRITE;
    reg [1:0] HTRANS;
    reg [2:0] HSIZE;
    reg [2:0] HBURST;
    reg [31:0] HWDATA;
    reg HRESETn;
    reg HCLK;
    reg [1:0] HMASTER;
    reg HMASTLOCK;
    wire HREADY;
    wire [1:0] HRESP;
    wire [31:0] HRDATA;
    wire [15:0] HSPLITx;
  
    initial begin
      HCLK = 1'b0;
      forever begin
          #1 HCLK = ~HCLK;
      end
    end
   
    Slave DUT(
        .HSELx(HSELx),
        .HADDR(HADDR),
        .HWRITE(HWRITE),
        .HTRANS(HTRANS),
        .HSIZE(HSIZE),
        .HBURST(HBURST),
        .HWDATA(HWDATA),
        .HRESETn(HRESETn),
        .HCLK(HCLK),
        .HMASTER(HMASTER),
        .HMASTLOCK(HMASTLOCK),
        .HREADY(HREADY),
        .HRESP(HRESP),
        .HRDATA(HRDATA),
        .HSPLITx(HSPLITx)
    );
 
  initial begin
    HADDR = 12'b0000_0000_0000;
    HRESETn = 1'b1;
    #2
    HADDR = 12'b1111_0000_0000;
    #2
    HADDR = 12'b0000_1111_0000;
    #2
    HADDR = 12'b0000_0000_1111;
    #2
    HADDR = 12'b1111_0000_1111;
    #2
    HADDR = 12'b0000_1111_0000;
    #2
    HRESETn = 1'b0;
    HADDR = 12'b0000_1111_0000;
    #2
    HADDR = 12'b0000_0000_1111;
    #2
    HRESETn = 1'b1;
    HADDR = 12'b1111_0000_1111;
    #2
    HADDR = 12'b0000_1111_0000;
    #2
    HADDR = 12'b1111_0000_0000;
    #2
    $finish;
  end
 
endmodule

