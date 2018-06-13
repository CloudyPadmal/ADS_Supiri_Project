`timescale 1ns / 1ps



module slave_tb();
   reg HSELx;
   reg HWRITE;
   reg  [1:0] HTRANS;
   reg [2:0] HSIZE;
   reg HRESETn;
   reg HCLK;
   reg [1:0] HMASTER;
   reg HMASTLOCK;
   reg [13:0] HADDR;
   reg [31:0] HWDATA;
   reg [31:0] OUTHRDATA;
   wire [1:0] HSPLITx;
   //reg [31:0] OUTHRDATA,
   wire HREADY;
   wire [1:0] HRESP;
   // Data from inside ports
   wire [31:0] HRDATA;
   //reg [13:0] HADDR,
   //reg [31:0] HWDATA,
   // Data from outside ports
   //reg [31:0] OUTHRDATA,
   wire [13:0] OUTHADDR;
   wire [31:0] OUTHWDATA;
   
   initial begin
     HCLK = 1'b0;
     forever begin
         #1 HCLK = ~HCLK;
     end
   end
    


 SlaveA(
    .HSELx(HSELx),
    .HWRITE(HWRITE),
    .HTRANS(HTRANS),
    .HSIZE(HSIZE),
    .HRESETn(HRESETn),
    .HCLK(HCLK),
    .HMASTER(HMASTER),
    .HMASTLOCK(HMASTLOCK),
    .HADDR(HADDR),
    .HWDATA(HWDATA),
    .OUTHRDATA(OUTHRDATA),
    .HSPLITx(HSPLITx),
    //reg [31:0] OUTHRDATA,
    .HREADY(HREADY),
    .HRESP(HRESP),
    // Data from inside ports
    .HRDATA(HRDATA),
    //reg [13:0] HADDR,
    //reg [31:0] HWDATA,
    // Data from outside ports
    //reg [31:0] OUTHRDATA,
    .OUTHADDR(OUTHADDR),
    .OUTHWDATA(OUTHWDATA)


    );
    initial begin
        #2
        
        $finish;
    end
endmodule
