module TopLevel(
    input CLK,
    input RST,
    input RW1,
    input RW2,
    //input BUS_REQ_1,
    //input BUS_REQ_2,
    input [31:0] OUTHRDATA_A, OUTHRDATA_B, OUTHRDATA_C,
    output [13:0] ADDRESS_FROM_SLAVE_TO_US_A,
    output [13:0] ADDRESS_FROM_SLAVE_TO_US_B,
    output [13:0] ADDRESS_FROM_SLAVE_TO_US_C,
    output [31:0] DATA_FROM_SLAVE_TO_US_A,
    output [31:0] DATA_FROM_SLAVE_TO_US_B,
    output [31:0] DATA_FROM_SLAVE_TO_US_C,
    output [31:0] DATA_FROM_SLAVE_TO_MASTER1,
    input [31:0] DATA_FROM_MASTER_TO_SLAVE1,
    input [13:0] ADDRESS_FROM_US_TO_MASTER_TO_SLAVE1, // What we feed to master from test bench
    output [31:0] DATA_FROM_SLAVE_TO_MASTER2, // What we read from master, master got from slave
    input [31:0] DATA_FROM_MASTER_TO_SLAVE2, // What we feed to master from test bench
    input [13:0] ADDRESS_FROM_US_TO_MASTER_TO_SLAVE2
    
);
    
    wire GRANTED_1,GRANTED_2,HWRITE,HMASTLOCK,HLOCK_A,HLOCK_B,BUS_REQ_1,BUS_REQ_2;
    wire [1:0] HSPLIT,HMASTER,HTRANS,HRESP;
    wire [2:0] HSEL,HREADY,HSIZE;
    reg [13:0] HADDR_MUX_OUT;
    wire [13:0] HADDR, HADDR_A, HADDR_B;
    wire [31:0] HWDATA_A,HWDATA_B,HRDATA_A,HRDATA_B,HRDATA_C;
    reg [31:0] HWDATA,HRDATA;
    reg [31:0] HWDATA_MUX_OUT;
    reg HLOCKx;
  
    
    always @(*)begin
        case(HMASTER)
            2'b10:begin
                HWDATA_MUX_OUT <= HWDATA_A;
                HADDR_MUX_OUT <= HADDR_A;
            end
            2'b01:begin
                HWDATA_MUX_OUT <= HWDATA_B;
                HADDR_MUX_OUT <= HADDR_B;
            end
        endcase
    end
    
    always @(*)begin
    case(HADDR_MUX_OUT[13:12])
        2'b01: HRDATA <= HRDATA_A;
        2'b10: HRDATA <= HRDATA_B;
        2'b11: HRDATA <= HRDATA_C;
    endcase
    end
    always @(*)begin
        HLOCKx <= HLOCK_A & HLOCK_B;
    end
    
    Arbiter SupiriArbiter(
        .HBUSREQx1(BUS_REQ_1),
        .HBUSREQx2(BUS_REQ_2),
        .HSPLITx(HSPLIT),
        //HTRANS,
        //HBURST,
        //HRESP,
        .HREADY(HREADY),
        .HRESETn(RST),
        .HCLK(CLK),
        .HLOCKx(HLOCKx),
        .HGRANT1(GRANTED_1),
        .HGRANT2(GRANTED_2),
        .HMASTER(HMASTER)//,
        //output reg HMASTLOCK
        );
        
    Decoder SupiriDecoder(
        .HADDR(HADDR_MUX_OUT),
        .HCLK(CLK),
        .HRESETn(RST),
        .HSELx1(HSEL[0]),
        .HSELx2(HSEL[1]),
        .HSELx3(HSEL[2])
    );
    
    SlaveA Slave_AINTERFACE(
        .HSELx(HSEL[0]),
        .HWRITE(HWRITE),
        .HTRANS(HTRANS),
        .HSIZE(HSIZE),
        .HRESETn(RST),
        .HCLK(CLK),
        .HMASTER(HMASTER),
        .HMASTLOCK(HMASTLOCK),
        .HSPLITx(HSPLIT),
        .HREADY(HREADY[0]),
        .HRESP(HRESP),
        // Data from inside ports
        .HRDATA(HRDATA_A),
        .HADDR(HADDR_MUX_OUT),
        .HWDATA(HWDATA_MUX_OUT),
        // Data from outside ports
        .OUTHRDATA(OUTHRDATA_A),
        .OUTHADDR(ADDRESS_FROM_SLAVE_TO_US_A),
        .OUTHWDATA(DATA_FROM_SLAVE_TO_US_A)
    );
    
    SlaveA Slave_BINTERFACE(
        .HSELx(HSEL[1]),
        .HWRITE(HWRITE),
        .HTRANS(HTRANS),
        .HSIZE(HSIZE),
        .HRESETn(RST),
        .HCLK(CLK),
        .HMASTER(HMASTER),
        .HMASTLOCK(HMASTLOCK),
        .HSPLITx(HSPLIT),
        .HREADY(HREADY[1]),
        .HRESP(HRESP),
        // Data from inside ports
        .HRDATA(HRDATA_B),
        .HADDR(HADDR_MUX_OUT),
        .HWDATA(HWDATA_MUX_OUT),
        // Data from outside ports
        .OUTHRDATA(OUTHRDATA_B),
        .OUTHADDR(ADDRESS_FROM_SLAVE_TO_US_B),
        .OUTHWDATA(DATA_FROM_SLAVE_TO_US_B)
    );
        
    SlaveA Slave_CINTERFACE(
        .HSELx(HSEL[2]),
        .HWRITE(HWRITE),
        .HTRANS(HTRANS),
        .HSIZE(HSIZE),
        .HRESETn(RST),
        .HCLK(CLK),
        .HMASTER(HMASTER),
        .HMASTLOCK(HMASTLOCK),
        .HSPLITx(HSPLIT),
        .HREADY(HREADY[2]),
        .HRESP(HRESP),
        // Data from inside ports
        .HRDATA(HRDATA_C),
        .HADDR(HADDR_MUX_OUT),
        .HWDATA(HWDATA_MUX_OUT),
        // Data from outside ports
        .OUTHRDATA(OUTHRDATA_C),
        .OUTHADDR(ADDRESS_FROM_SLAVE_TO_US_C),
        .OUTHWDATA(DATA_FROM_SLAVE_TO_US_C)
    );
    
    
    MasterA Master_AINTERFACE(
        .HGRANTx(GRANTED_1),
        .HREADY(HREADY),
        .RW(RW1),
        .HRESP(HRESP),
        .HRESETn(RST),
        .HCLK(CLK),
        .HLOCKx(HLOCK_A),
        .HWRITE(HWRITE),
        .HTRANS(HTRANS),
        .HBUSREQx(BUS_REQ_1),
        // Data from outside ports
        .HRDATA(HRDATA),
        .HWDATA(HWDATA_A),
        .HADDR(HADDR_A),
        // Data from inside ports
        .INHRDATA(DATA_FROM_SLAVE_TO_MASTER1),
        .INHWDATA(DATA_FROM_MASTER_TO_SLAVE1),
        .INHADDR(ADDRESS_FROM_US_TO_MASTER_TO_SLAVE1)
    );
    
     MasterA Master_BINTERFACE(
        .HGRANTx(GRANTED_2),
        .HREADY(HREADY),
        .RW(RW2),
        .HRESP(HRESP),
        .HRESETn(RST),
        .HCLK(CLK),
        .HLOCKx(HLOCK_B),
        .HWRITE(HWRITE),
        .HTRANS(HTRANS),
        .HBUSREQx(BUS_REQ_2),
        // Data from outside ports
        .HRDATA(HRDATA),
        .HWDATA(HWDATA_B),
        .HADDR(HADDR_B),
        // Data from inside ports
        .INHRDATA(DATA_FROM_SLAVE_TO_MASTER2),
        .INHWDATA(DATA_FROM_MASTER_TO_SLAVE2),
        .INHADDR(ADDRESS_FROM_US_TO_MASTER_TO_SLAVE2)
    );
    
    
endmodule
