`timescale 1ns / 1ps

module Top_Test();

    reg HCLK;
    reg HRESETn;
    reg RW1,RW2;
    //reg BUS_REQ_1, BUS_REQ_2;
    reg [31:0] OUTHRDATA_A, OUTHRDATA_B, OUTHRDATA_C;
    wire [13:0] ADDRESS_FROM_SLAVE_TO_US_A, ADDRESS_FROM_SLAVE_TO_US_B, ADDRESS_FROM_SLAVE_TO_US_C;
    wire [31:0] DATA_FROM_SLAVE_TO_US_A, DATA_FROM_SLAVE_TO_US_B, DATA_FROM_SLAVE_TO_US_C;
    wire [31:0] DATA_FROM_SLAVE_TO_MASTER1, DATA_FROM_SLAVE_TO_MASTER2;
    reg [31:0] DATA_FROM_MASTER_TO_SLAVE1, DATA_FROM_MASTER_TO_SLAVE2;
    reg [13:0] ADDRESS_FROM_US_TO_MASTER_TO_SLAVE1, ADDRESS_FROM_US_TO_MASTER_TO_SLAVE2;
    

    initial begin
      HCLK = 1'b0;
      forever begin
          #1 HCLK = ~HCLK;
      end
    end

    TopLevel UUT(
        .CLK(HCLK),
        .RST(HRESETn),
        .RW1(RW1),
        .RW2(RW2),
        //.BUS_REQ_1(BUS_REQ_1),
        //.BUS_REQ_2(BUS_REQ_2),
        .OUTHRDATA_A(OUTHRDATA_A),
        .OUTHRDATA_B(OUTHRDATA_B),
        .OUTHRDATA_C(OUTHRDATA_C),
        .ADDRESS_FROM_SLAVE_TO_US_A(ADDRESS_FROM_SLAVE_TO_US_A),
        .ADDRESS_FROM_SLAVE_TO_US_B(ADDRESS_FROM_SLAVE_TO_US_B),
        .ADDRESS_FROM_SLAVE_TO_US_C(ADDRESS_FROM_SLAVE_TO_US_C),
        .DATA_FROM_SLAVE_TO_US_A(DATA_FROM_SLAVE_TO_US_A),
        .DATA_FROM_SLAVE_TO_US_B(DATA_FROM_SLAVE_TO_US_B),
        .DATA_FROM_SLAVE_TO_US_C(DATA_FROM_SLAVE_TO_US_C),
        .DATA_FROM_SLAVE_TO_MASTER1(DATA_FROM_SLAVE_TO_MASTER1),
        .DATA_FROM_MASTER_TO_SLAVE1(DATA_FROM_MASTER_TO_SLAVE1),
        .ADDRESS_FROM_US_TO_MASTER_TO_SLAVE1(ADDRESS_FROM_US_TO_MASTER_TO_SLAVE1), // What we feed to master from test bench
        .DATA_FROM_SLAVE_TO_MASTER2(DATA_FROM_SLAVE_TO_MASTER2), // What we read from master, master got from slave
        .DATA_FROM_MASTER_TO_SLAVE2(DATA_FROM_MASTER_TO_SLAVE2), // What we feed to master from test bench
        .ADDRESS_FROM_US_TO_MASTER_TO_SLAVE2(ADDRESS_FROM_US_TO_MASTER_TO_SLAVE2)
        
     );
     
     initial begin
        #2
        HRESETn = 1'b0;
        #2
        HRESETn = 1'b1;
        #2
        //RW = 1;
        RW1 = 1;
        RW2 = 0;
        DATA_FROM_MASTER_TO_SLAVE1 = 32'd25;
        ADDRESS_FROM_US_TO_MASTER_TO_SLAVE1 = 14'b01_0011_0100_0111;
        #40 $finish;
       end
    
    

endmodule
