`timescale 1ns / 1ps

module master_Sim();
    wire [13:0] HADDR;
    wire [31:0] HRDATA,HWDATA;
    reg clk=0,rst,rw,HREADY,GRANTED;
    reg [1:0] HRESP;
    reg [13:0] HADDR_A;
    reg [31:0] HWDATA_A;
    localparam OKAY=2'b00;
    initial begin
        #2 rst=0;
        #2 rst=1;
        #2 HADDR_A=14'd25;
        #5 rw=1;
        #2 HWDATA_A=32'd55;
        
        #5 HREADY=1;
        #5 HRESP=OKAY;
        #5 GRANTED=1;
        #10 $finish;
    end
    always #1 clk=~clk;
    MasterA Master_AINTERFACE(
        .HGRANTx(GRANTED),
        .HREADY(HREADY),
        .RW(rw),
        .HRESP(HRESP),
        .HRESETn(rst),
        .HCLK(clk),
        .HLOCKx(HLOCK_A),
        .HWRITE(HWRITE),
        .HTRANS(HTRANS),
        .HBUSREQx(BUS_REQ_1),
        // Data from outside ports
        .HRDATA(HRDATA),
        .HWDATA(HWDATA),
        .HADDR(HADDR),
        // Data from inside ports
        .INHRDATA(DATA_FROM_SLAVE_TO_MASTER1),
        .INHWDATA(HWDATA_A),
        .INHADDR(HADDR_A)
    );
endmodule
