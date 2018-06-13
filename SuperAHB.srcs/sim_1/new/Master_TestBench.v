`timescale 1ns / 1ps

module Master_TestBench();

    // Inputs
    reg HGRANTx, HREADY, RW, HRESETn, HCLK;
    reg [1:0] HRESP;
    reg [31:0] DATA_FROM_SLAVE_TO_MASTER, DATA_BY_US_FOR_MASTER_TO_SLAVE;
    reg [13:0] ADDRESS_BY_US_FOR_MASTER_TO_SLAVE;
    // Outputs
    wire HLOCKx, HWRITE, HBUSREQx;
    wire [1:0] HTRANS;
    wire [31:0] DATA_FROM_MASTER_TO_SLAVE, DATA_FOR_US_FROM_SLAVE_TO_MASTER;
    wire [13:0] ADDRESS_FROM_MASTER_TO_SLAVE;
    // Internal connections
    
    MasterA MasterUnderTest (
        .HGRANTx(HGRANTx),
        .HREADY(HREADY),
        .RW(RW),
        .HRESP(HRESP),
        .HRESETn(HRESETn),
        .HCLK(HCLK),
        .HLOCKx(HLOCKx),
        .HWRITE(HWRITE),
        .HTRANS(HTRANS),
        .HBUSREQx(HBUSREQx),
        // Data from outside ports
        .HRDATA(DATA_FROM_SLAVE_TO_MASTER),
        .HWDATA(DATA_FROM_MASTER_TO_SLAVE),
        .HADDR(ADDRESS_FROM_MASTER_TO_SLAVE),
        // Data from inside ports
        .INHRDATA(DATA_FOR_US_FROM_SLAVE_TO_MASTER),
        .INHWDATA(DATA_BY_US_FOR_MASTER_TO_SLAVE),
        .INHADDR(ADDRESS_BY_US_FOR_MASTER_TO_SLAVE)
    );
    
    initial begin
        HCLK = 1'b0;
        forever begin
            #1 HCLK = ~HCLK;
        end
    end
    
    initial begin
        DATA_BY_US_FOR_MASTER_TO_SLAVE = 32'd125;
        DATA_FROM_SLAVE_TO_MASTER = 32'd211;
        ADDRESS_BY_US_FOR_MASTER_TO_SLAVE = 14'b01_1100_1001_0100;
        HRESETn = 0;
        #2
        HRESETn = 1;
        HGRANTx = 1;
        RW = 1;
        HREADY = 1;
        #3
        HRESP = 2'b00;
        #6
        HRESETn = 0;
        #2
        HRESETn = 1;
        HGRANTx = 1;
        RW = 0;
        HREADY = 1;
        #12
        HRESETn = 0;
        #2
        HRESETn = 1;
        HRESP = 2'b11;
        HGRANTx = 0;
        #4
        HGRANTx = 1;
        #4
        HRESP = 2'b00;
        #8
        HRESETn = 0;
        HRESP = 2'b00;
        HGRANTx = 0;
        HREADY = 0;
        #30
        $finish;
    end
    
    

endmodule
