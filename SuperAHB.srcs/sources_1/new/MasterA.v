module MasterA(
    input HGRANTx,
    input HREADY,
    input RW,
    input [1:0] HRESP,
    input HRESETn,
    input HCLK,
    output reg HLOCKx,
    output reg HWRITE,
    output reg [1:0] HTRANS,
    output reg HBUSREQx,
    // Data from outside ports
    input [31:0] HRDATA,
    output reg [31:0] HWDATA,
    output reg [13:0] HADDR,
    // Data from inside ports
    output reg [31:0] INHRDATA,
    input [31:0] INHWDATA,
    input [13:0] INHADDR
);

    reg [2:0] MASTER_STATE;
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
    
    localparam [2:0] INITIATE_BUS_REQUEST   = 0;
    localparam [2:0] INITIATE_WRITE         = 1;
    localparam [2:0] INITIATE_READ          = 2;
    localparam [2:0] WRITE_SPLIT            = 3;
    localparam [2:0] READ_SPLIT             = 4;
    localparam [2:0] READ_DATA              = 5;
    localparam [2:0] WRITE_FINISH           = 6;
    localparam [2:0] READ_FINISH            = 7;

    always @ (posedge HCLK) begin
        if (!HRESETn) begin
            // Reset all the pins
            MASTER_STATE <= INITIATE_BUS_REQUEST;
            WRITE_COMPLETE <= 0;
            READ_COMPLETE <= 0;
            HLOCKx <= 0;
            HWRITE <= 0;
            HTRANS = IDLE;
            HBUSREQx = 0;
            HWDATA = 32'd0;
            HADDR = 14'd0;
            INHRDATA = 32'd0;            
        end
        else begin
            case (MASTER_STATE)
                INITIATE_BUS_REQUEST: begin
                    HBUSREQx <= 1;
                    if (HGRANTx) begin
                        HLOCKx = 1;
                        if (RW == 1) begin //Test Bench Input
                            MASTER_STATE <= INITIATE_WRITE;
                        end
                        else begin
                            MASTER_STATE <= INITIATE_READ;
                        end
                    end
                    else begin
                        MASTER_STATE <= INITIATE_BUS_REQUEST;
                    end
                end
                INITIATE_WRITE: begin
                    if (HREADY) begin
                        HWRITE <= 1;
                        if (!WRITE_COMPLETE) begin
                            HADDR <= INHADDR; //Test Bench input Address
                            HWDATA <= INHWDATA; //Test Bench input Data
                            MASTER_STATE <= INITIATE_BUS_REQUEST;
                            WRITE_COMPLETE = 1;
                        end
                        else begin
                            if (HRESP == OKAY) begin
                                MASTER_STATE <= WRITE_FINISH;
                            end
                            else begin
                                MASTER_STATE <= INITIATE_WRITE;
                                WRITE_COMPLETE = 0;
                            end
                        end
                    end
                    else begin //If Slave is not ready
                        if (HRESP == SPLIT) begin //HRESP- Slave Status
                            MASTER_STATE <= WRITE_SPLIT;
                        end
                        else begin //If slave not issued Split
                            MASTER_STATE <= INITIATE_BUS_REQUEST;
                        end
                    end
                end
                INITIATE_READ: begin
                    if (HREADY) begin
                        HWRITE <= 0;
                        HADDR <= INHADDR; //Test bench address
                        MASTER_STATE <= READ_DATA;
                    end
                    else begin
                        MASTER_STATE <= INITIATE_READ;
                    end
                end
                WRITE_SPLIT: begin
                    HTRANS <= IDLE;     //HTRANS- Master Status
                    if (HGRANTx && HREADY) begin
                        MASTER_STATE <= INITIATE_WRITE;
                    end
                    else begin
                        MASTER_STATE <= WRITE_SPLIT;
                    end
                end
                READ_SPLIT: begin
                    HTRANS <= IDLE;
                    if (HGRANTx && HREADY) begin
                        MASTER_STATE <= INITIATE_READ;
                    end
                    else begin
                        MASTER_STATE <= READ_SPLIT;
                    end
                end
                READ_DATA: begin
                    if (HREADY) begin
                        HWRITE <= 0;
                        if (!READ_COMPLETE) begin
                            INHRDATA <= HRDATA; //TestBench Output
                            READ_COMPLETE = 1;
                            MASTER_STATE <= INITIATE_BUS_REQUEST;
                        end
                        else begin // If read complete
                            if (HRESP == OKAY) begin
                                MASTER_STATE <= READ_FINISH;
                            end
                            else begin
                                MASTER_STATE <= INITIATE_READ;
                                READ_COMPLETE = 0;
                            end
                        end
                    end
                    else begin
                        if (HRESP == SPLIT) begin
                            MASTER_STATE <= READ_SPLIT;
                        end
                        else begin
                            MASTER_STATE <= INITIATE_BUS_REQUEST;
                        end
                    end
                end
                WRITE_FINISH: begin
                    MASTER_STATE <= INITIATE_BUS_REQUEST;
                    HTRANS <= IDLE;
                    HBUSREQx <= 0;
                    HLOCKx <= 0;
                end
                READ_FINISH: begin
                    MASTER_STATE <= INITIATE_BUS_REQUEST;
                    HTRANS <= IDLE;
                    HBUSREQx <= 0;
                    HLOCKx <= 0;
                end
            endcase
        end
    end
endmodule
