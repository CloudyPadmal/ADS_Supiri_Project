module TopLevel(
    input CLK,
    input RST,

    input BUS_REQ_1,
    input BUS_REQ_2,
    input [31:0] M1_IN,
    input [31:0] M2_IN,
    output GRANTED_1,
    output GRANTED_2,
    output SEL_MASTER,
    output [31:0] S1_OUT,
    output [31:0] S2_OUT,
    output [31:0] S3_OUT,
    output [11:0] ADDRESS_OUT
    );
    
    
    
    Arbiter SupiriArbiter(
        .HBUSREQx1(BUS_REQ_1),
        .HBUSREQx2(BUS_REQ_2),
        .HSPLITx(),
        //HTRANS,
        //HBURST,
        //HRESP,
        .HREADY(),
        .HRESETn(RST),
        .HCLK(CLK),
        .HGRANT1(GRANTED_1),
        .HGRANT2(GRANTED_2),
        .HMASTER(SEL_MASTER)//,
        //output reg HMASTLOCK
        );
        
    Decoder SupiriDecoder(
        .HADDR(HADDR),
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        .HSELx1(HSELx1),
        .HSELx2(HSELx2),
        .HSELx3(HSELx3)
    );
    
    SlaveA Slave_AINTERFACE(
        .HSELx(HSELx),
        .HWRITE(HWRITE),
        .HTRANS(HTRANS),
        .HSIZE(HSIZE),
        .HBURST(HBURST),
        .HRESETn(HRESETn),
        .HCLK(HCLK),
        .HMASTER(HMASTER),
        .HMASTLOCK(HMASTLOCK),
        .HSPLITx(HSPLITx),
        .HREADY(HREADY),
        .HRESP(HRESP),
        // Data from inside ports
        .HRDATA(HRDATA),
        .HADDR(HADDR),
        .HWDATA(HWDATA),
        // Data from outside ports
        .OUTHRDATA(OUTHRDATA),
        .OUTHADDR(OUTHADDR),
        .OUTHWDATA(OUTHWDATA)
    );
    
    SlaveA Slave_BINTERFACE(
        .HSELx(HSELx),
        .HWRITE(HWRITE),
        .HTRANS(HTRANS),
        .HSIZE(HSIZE),
        .HBURST(HBURST),
        .HRESETn(HRESETn),
        .HCLK(HCLK),
        .HMASTER(HMASTER),
        .HMASTLOCK(HMASTLOCK),
        .HSPLITx(HSPLITx),
        .HREADY(HREADY),
        .HRESP(HRESP),
        // Data from inside ports
        .HRDATA(HRDATA),
        .HADDR(HADDR),
        .HWDATA(HWDATA),
        // Data from outside ports
        .OUTHRDATA(OUTHRDATA),
        .OUTHADDR(OUTHADDR),
        .OUTHWDATA(OUTHWDATA)
    );
        
    SlaveA Slave_CINTERFACE(
        .HSELx(HSELx),
        .HWRITE(HWRITE),
        .HTRANS(HTRANS),
        .HSIZE(HSIZE),
        .HBURST(HBURST),
        .HRESETn(HRESETn),
        .HCLK(HCLK),
        .HMASTER(HMASTER),
        .HMASTLOCK(HMASTLOCK),
        .HSPLITx(HSPLITx),
        .HREADY(HREADY),
        .HRESP(HRESP),
        // Data from inside ports
        .HRDATA(HRDATA),
        .HADDR(HADDR),
        .HWDATA(HWDATA),
        // Data from outside ports
        .OUTHRDATA(OUTHRDATA),
        .OUTHADDR(OUTHADDR),
        .OUTHWDATA(OUTHWDATA)
    );
    
    
    MasterA Master_AINTERFACE(
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
        .HRDATA(HRDATA),
        .HWDATA(HWDATA),
        .HADDR(HADDR),
        // Data from inside ports
        .INHRDATA(INHRDATA),
        .INHWDATA(INHWDATA),
        .INHADDR(INHADDR)
    );
    
     MasterA Master_BINTERFACE(
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
        .HRDATA(HRDATA),
        .HWDATA(HWDATA),
        .HADDR(HADDR),
        // Data from inside ports
        .INHRDATA(INHRDATA),
        .INHWDATA(INHWDATA),
        .INHADDR(INHADDR)
    );
    
    
endmodule
