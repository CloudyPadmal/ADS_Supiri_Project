`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2018 03:07:19 PM
// Design Name: 
// Module Name: Master
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


module Master(
    input HGRANTx,
    input HREADY,
    input [1:0] HRESP,
    input HRESETn,
    input HCLK,
    input [31:0] HRDATA,
    output reg HBUSREQx,
    output reg HLOCKx,
    output reg [1:0] HTRANS,
    output [11:0] HADDR,
    output HWRITE,
    output [2:0] HSIZE,
    output [2:0] HBURST,
    output [3:0] HPROT,
    output [31:0] HWDATA
    );
    
    reg HBUSREQ,HLOCKx,HWRITE,hcount;
    reg [1:0]HTRANS,HSEL;
    reg [31:0]HADDR,HWDATA;
    reg [2:0]HSIZE,HBURST;
    
    wire HGRANTx,HREADY,HCLK,HRESETn,WRITE;
    wire [31:0]ADDR,WDATA;
    wire [2:0]SIZE,BURST;
    wire [1:0]HRESP,SEL,TRANS;
    wire [31:0]HRDATA;
    
    reg bus_reg,addr_reg,new_hready,old_hready;
    reg [31:0] RDATA;
    reg [31:0] h_addr;
    
    parameter OKAY = 2'b00,
              ERROR = 2'b01,
              RETRY =2'b10,
              SPLIT =2'b11;
              
    always @(posedge HCLK)
    begin
       if(!HRESETn)              //Master reset
       begin
          HBUSREQ = 0;
          HLOCKx = 0;
          HWRITE = 0;
          HTRANS = 2'b00;
          HSEL = 2'b00;
          HADDR = 32'h00000000;
          HWDATA = 32'h00000000;
          HSIZE = 2'b00;
          HBURST = 2'b00;
          bus_reg = 0;
          addr_reg = 0;
          new_hready = 0;
          old_hready = 0;
          hcount = 0;
       end
    end
    
    always @(posedge HCLK)       //Master sending the request signal to the arbiter
    begin
       if(!bus_reg)
       begin
          if(BUSREQ)
          begin
            HBUSREQ = 1'b1;
            bus_reg = 1;
          end
         else if(!BUSREQ)
            HLOCKx = 1'b0; 
       end
       
       else if(bus_reg)
          begin
          HBUSREQ = 1'b0;
          bus_reg = 0;
          if(HGRANTx)
            HLOCKx = 1'b1;
          end
       
    end
    
    always@(posedge HCLK)     
    begin 
      if(HRESETn)
      begin 
        if(HGRANTx)
        begin
          if(!addr_reg)
          begin
             if(ADDREQ)        //Master sending the address and the control signals once the bus is granted
             begin
              HADDR = ADDR;
              h_addr = ADDR;
              HWRITE = WRITE;
              HSIZE = SIZE;
              HBURST = BURST;
              HSEL = SEL;
              HTRANS = TRANS;
              addr_reg = 1'b1;
              HWDATA = 32'h00000000;
             end
          end
         else if(addr_reg)
          begin
              HADDR = 32'h00000000;
              HWRITE = 1'b0;
              HSIZE = 3'b000;
              HBURST = 3'b000;
              HTRANS = 2'b00;
              addr_reg = 1'b0;
          end
        
        
        if(!ADDREQ)              // DATA TRANSFER
        begin
          if(WRITE)
          begin
                hcount = 0;
            case ({TRANS})
            
                 2'b00 : begin  //NON SEQUENTIAL 
                         HWDATA = WDATA ;
                         if(HREADY && !new_hready && HRESP == OKAY)
                             new_hready = 1;
                         else if (new_hready != old_hready)
                             HWDATA = 32'h00000000;
                         end
                 2'b01 : begin  // SEQUENTIAL 
                         hcount = hcount + 1;
                         new_hready = 0;
                         HWDATA = WDATA ;
                         if(HREADY && !new_hready && HRESP == ERROR)
                             new_hready = 1;
                         else if (new_hready != old_hready)
                             HWDATA = 32'h00000000;
                         end                     
                 2'b10 : begin  // IDLE 
                         HWDATA = 32'h00000000;
                         end 
                 2'b11 : begin // BUSY
                         hcount = hcount + 1;
                         HWDATA = WDATA ;
                         if(HREADY && HRESP == OKAY)
                         begin
                             if(!new_hready)
                                new_hready = 1;                          
                         end    
                         else if (new_hready != old_hready)
                         begin 
                             HWDATA = WDATA;
                             new_hready = 0;
                         end
                         else if (HREADY && HRESP == ERROR)
                         begin
                            HWDATA = 32'h00000000;
                         end
                         end
          endcase                  
        end
          else if(!WRITE)
          begin
            case ({TRANS})
            
                 2'b00 : begin  //NON SEQUENTIAL 
                         if(!HREADY)
                           RDATA = HRDATA;
                         else if(HREADY)
                           RDATA = 32'h00000000;                         
                         end
                 2'b01 : begin  // SEQUENTIAL 
                         if(!HREADY)
                         begin
                            RDATA = HRDATA;
                            if(HBURST == 000)
                               h_addr = h_addr + 1;
                            else
                               h_addr = h_addr - 1; 
                         end
                         else if(HREADY)
                           RDATA = 32'h00000000;       
                         end                     
                 2'b10 : begin  // IDLE 
                         RDATA = 32'h00000000;  
                         end 
                 2'b11 : begin // BUSY
                         if(!HREADY)
                         begin
                            RDATA = HRDATA;
                            if(HBURST == 000)
                               h_addr = h_addr + 1;
                            else
                               h_addr = h_addr - 1; 
                         end      
                         else if(HREADY)
                             RDATA = HRDATA; 
                         end
          endcase                  
        end
       
       
       end       
       end 
        
      end
      end

    
    
endmodule

module Master_tb;

                // Inputs
                reg HRESETn;
                reg HCLK;
                reg HGRANTx;
                reg HREADY;
                reg [1:0] HRESP;
                reg [31:0] HRDATA;
                reg BUSREQ;
                reg ADDREQ;
                reg WRITE;
                reg [31:0] ADDR;
                reg [2:0] SIZE;
                reg [2:0] BURST;
                reg [1:0] SEL;
                reg [1:0] TRANS;
                reg [31:0] WDATA;

                // Outputs
                wire HBUSREQ;
                wire HLOCKx;
                wire [1:0] HTRANS;
                wire [31:0] HADDR;
                wire HWRITE;
                wire [2:0] HSIZE;
                wire [2:0] HBURST;
                wire [31:0] HWDATA;
                wire [1:0] HSEL;

                // Instantiate the Unit Under Test (UUT)
                ahb_master uut (
                                .HBUSREQ(HBUSREQ),
                                .HLOCKx(HLOCKx),
                                .HTRANS(HTRANS),
                                .HADDR(HADDR),
                                .HWRITE(HWRITE),
                                .HSIZE(HSIZE),
                                .HBURST(HBURST),
                                .HWDATA(HWDATA),
                                .HSEL(HSEL),
                                .HRESETn(HRESETn),
                                .HCLK(HCLK),
                                .HGRANTx(HGRANTx),
                                .HREADY(HREADY),
                                .HRESP(HRESP),
                                .HRDATA(HRDATA),
                                .BUSREQ(BUSREQ),
                                .ADDREQ(ADDREQ),
                                .WRITE(WRITE),
                                .ADDR(ADDR),
                                .SIZE(SIZE),
                                .BURST(BURST),
                                .SEL(SEL),
                                .TRANS(TRANS),
                                .WDATA(WDATA)
                );

                initial begin
                                // Initialize Inputs
                                HRESETn = 0;
                                HCLK = 0;
                                HGRANTx = 0;
                                HREADY = 0;
                                HRESP = 0;
                                HRDATA = 0;
                                BUSREQ = 0;
                                ADDREQ = 0;
                                WRITE = 0;
                                ADDR = 0;
                                SIZE = 0;
                                BURST = 0;
                                SEL = 0;
                                TRANS = 0;
                                WDATA = 0;

                                // Wait 100 ns for global reset to finish
                                #100;
                                HRESETn = 1;
                                HGRANTx = $rand;
                                HREADY = $rand;
                                HRESP = 0;
                                HRDATA = 0;
                                BUSREQ = 0;
                                ADDREQ = 0;
                                WRITE = 0;
                                ADDR = 0;
                                SIZE = 0;
                                BURST = 0;
                                SEL = 0;
                                TRANS = 0;
                                WDATA = 0;
                               
 #200;
                end
      always begin
                                #5 HCLK = ~HCLK;
                               
                               
                                end
endmodule
