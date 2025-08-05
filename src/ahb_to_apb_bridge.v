module ahb_to_apb_bridge (
    input  wire         HCLK,
    input  wire         HRESETn,
    input  wire [31:0]  HADDR,
    input  wire [1:0]   HTRANS,
    input  wire         HWRITE,
    input  wire [2:0]   HSIZE,
    input  wire [31:0]  HWDATA,
    input  wire         HSEL,
    input  wire         HREADYIN,
    output reg          HREADYOUT,
    output reg  [31:0]  HRDATA,
    output reg  [1:0]   HRESP,
    output wire         PCLK,
    output wire         PRESETn,
    output reg  [31:0]  PADDR,
    output reg          PWRITE,
    output reg          PSEL,
    output reg          PENABLE,
    output reg  [31:0]  PWDATA,
    input  wire [31:0]  PRDATA,
    input  wire         PREADY
);

    assign PCLK    = HCLK;
    assign PRESETn = HRESETn;

    localparam IDLE   = 2'b00,
               SETUP  = 2'b01,
               ACCESS = 2'b10;

    reg [1:0] state, next_state;
    reg [31:0] addr_reg;
    reg [31:0] wdata_reg;
    reg        write_reg;

    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            addr_reg  <= 32'b0;
            wdata_reg <= 32'b0;
            write_reg <= 1'b0;
        end else if (state == IDLE && HSEL && HTRANS[1] && HREADYIN) begin
            addr_reg  <= HADDR;
            wdata_reg <= HWDATA;
            write_reg <= HWRITE;
        end
    end

    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            PSEL      <= 1'b0;
            PENABLE   <= 1'b0;
            PADDR     <= 32'b0;
            PWRITE    <= 1'b0;
            PWDATA    <= 32'b0;
            HREADYOUT <= 1'b1;
            HRDATA    <= 32'b0;
            HRESP     <= 2'b00;
        end else begin
            PSEL      <= 1'b0;
            PENABLE   <= 1'b0;
            HREADYOUT <= 1'b1;
            HRESP     <= 2'b00;

            case (state)
                IDLE: begin
                    if (HSEL && HTRANS[1] && HREADYIN) begin
                        next_state <= SETUP;
                        HREADYOUT <= 1'b0;
                    end else begin
                        next_state <= IDLE;
                    end
                end

                SETUP: begin
                    PADDR   <= addr_reg;
                    PWRITE  <= write_reg;
                    PWDATA  <= wdata_reg;
                    PSEL    <= 1'b1;
                    PENABLE <= 1'b0;
                    next_state <= ACCESS;
                    HREADYOUT <= 1'b0;
                end

                ACCESS: begin
                    PADDR   <= addr_reg;
                    PWRITE  <= write_reg;
                    PWDATA  <= wdata_reg;
                    PSEL    <= 1'b1;
                    PENABLE <= 1'b1;
                    HREADYOUT <= 1'b0;

                    if (PREADY) begin
                        if (!write_reg)
                            HRDATA <= PRDATA;
                        HREADYOUT <= 1'b1;
                        next_state <= IDLE;
                    end else begin
                        next_state <= ACCESS;
                    end
                end

                default: begin
                    next_state <= IDLE;
                end
            endcase
        end
    end

endmodule
