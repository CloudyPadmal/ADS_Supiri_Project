module SlaveA(
    input HSELx,
    input HWRITE,
    input [1:0] HTRANS,
    input [2:0] HSIZE,
    input [2:0] HBURST,
    input HRESETn,
    input HCLK,
    input [1:0] HMASTER,
    input HMASTLOCK,
    output reg [1:0] HSPLITx,
    output reg HREADY,
    output reg [1:0] HRESP,
    // Data from inside ports
    output reg [31:0] HRDATA,
    input [13:0] HADDR,
    input [31:0] HWDATA,
    // Data from outside ports
    input [31:0] OUTHRDATA,
    output reg [11:0] OUTHADDR,
    output reg [31:0] OUTHWDATA
);

    reg [3:0] SLAVE_STATE;
    reg WRITE_COMPLETE;
    reg READ_COMPLETE;

    localparam  OKAY    = 2'b00,
                ERROR   = 2'b01,
                RETRY   = 2'b10,
                SPLIT   = 2'b11; // Response
                
    localparam  IDLE    = 2'b00,
                BUSY    = 2'b01,
                NONSEQ  = 2'b10,
                SEQ     = 2'b11; // Transfer
                
    localparam [3:0] LEAVE_ONE_CLOCK        = 0;
    localparam [3:0] INITIATE_SLAVE         = 1;
    localparam [3:0] INITIATE_WRITE_SLAVE   = 2;
    localparam [3:0] INITIATE_READ_SLAVE    = 3;
    localparam [3:0] WRITE_SLAVE            = 4;
    localparam [3:0] READ_SLAVE             = 5;
    localparam [3:0] SPLIT_WRITE_SLAVE      = 6;
    localparam [3:0] SPLIT_READ_SLAVE       = 7;
    localparam [3:0] WAIT_ANOTHER_WCLOCK    = 8;
    localparam [3:0] WAIT_ANOTHER_RCLOCK    = 9;
    
    always @ (posedge HCLK) begin
        if (!HRESETn) begin
            // Reset all the pins
            SLAVE_STATE <= LEAVE_ONE_CLOCK;
            WRITE_COMPLETE <= 0;
            READ_COMPLETE <= 0;
        end
        else begin
            if (HSELx) begin
                HREADY <= 1;
                case (SLAVE_STATE)
                    LEAVE_ONE_CLOCK: begin
                        SLAVE_STATE <= INITIATE_SLAVE;
                    end
                    INITIATE_SLAVE: begin
                        OUTHADDR <= HADDR[11:0];
                        if (HWRITE) begin
                            SLAVE_STATE <= INITIATE_WRITE_SLAVE;
                        end
                        else begin
                            SLAVE_STATE <= INITIATE_READ_SLAVE;
                        end
                    end
                    INITIATE_WRITE_SLAVE: begin
                        if (HSIZE == 0) begin
                            SLAVE_STATE <= WRITE_SLAVE;
                        end
                        else begin
                            SLAVE_STATE <= SPLIT_WRITE_SLAVE;
                            HRESP <= SPLIT;
                        end
                    end
                    SPLIT_WRITE_SLAVE: begin
                        if (HMASTER == 1 && HTRANS == SEQ) begin
                            HSPLITx <= 1;
                            SLAVE_STATE <= WAIT_ANOTHER_WCLOCK;    
                        end
                        else if (HMASTER == 2 && HTRANS == SEQ) begin
                            HSPLITx = 2;
                            SLAVE_STATE <= WAIT_ANOTHER_WCLOCK;
                        end
                    end
                    INITIATE_READ_SLAVE: begin
                        if (HSIZE == 0) begin
                            SLAVE_STATE <= READ_SLAVE;
                        end
                        else begin
                            SLAVE_STATE <= SPLIT_READ_SLAVE;
                        end
                    end
                    WRITE_SLAVE: begin
                        OUTHWDATA <= HWDATA;
                        HRESP <= OKAY;
                        SLAVE_STATE <= INITIATE_SLAVE;
                    end
                    READ_SLAVE: begin
                        HRDATA <= OUTHRDATA;
                        HRESP = OKAY;
                        SLAVE_STATE <= INITIATE_SLAVE;
                    end
                    SPLIT_READ_SLAVE: begin
                        if (HMASTER == 1 && HTRANS == SEQ) begin
                            HSPLITx <= 1;
                            SLAVE_STATE <= WAIT_ANOTHER_RCLOCK;    
                        end
                        else if(HMASTER == 2 && HTRANS == SEQ) begin
                            HSPLITx = 2;
                            SLAVE_STATE <= WAIT_ANOTHER_RCLOCK;
                        end
                    end
                    WAIT_ANOTHER_WCLOCK: begin
                        SLAVE_STATE <= SPLIT_WRITE_SLAVE;
                    end
                    WAIT_ANOTHER_RCLOCK: begin
                        SLAVE_STATE <= SPLIT_READ_SLAVE;
                    end
                endcase
            end
            else begin
                // Slave is not selected
                HREADY <= 0;
            end
        end
    end

endmodule
