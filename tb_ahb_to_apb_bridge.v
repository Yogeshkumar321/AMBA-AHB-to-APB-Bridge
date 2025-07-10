`timescale 1ns / 1ps

module tb_ahb_to_apb_bridge;

    // Clock and Reset
    reg         HCLK;
    reg         HRESETn;

    // AHB Signals
    reg  [31:0] HADDR;
    reg  [1:0]  HTRANS;
    reg         HWRITE;
    reg  [2:0]  HSIZE;
    reg  [31:0] HWDATA;
    reg         HSEL;
    reg         HREADYIN;
    wire        HREADYOUT;
    wire [31:0] HRDATA;
    wire [1:0]  HRESP;

    // APB Signals
    wire        PCLK;
    wire        PRESETn;
    wire [31:0] PADDR;
    wire        PWRITE;
    wire        PSEL;
    wire        PENABLE;
    wire [31:0] PWDATA;
    reg  [31:0] PRDATA;
    reg         PREADY;

    // Instantiate DUT
    ahb_to_apb_bridge DUT (
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        .HADDR(HADDR),
        .HTRANS(HTRANS),
        .HWRITE(HWRITE),
        .HSIZE(HSIZE),
        .HWDATA(HWDATA),
        .HSEL(HSEL),
        .HREADYIN(HREADYIN),
        .HREADYOUT(HREADYOUT),
        .HRDATA(HRDATA),
        .HRESP(HRESP),
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PADDR(PADDR),
        .PWRITE(PWRITE),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PWDATA(PWDATA),
        .PRDATA(PRDATA),
        .PREADY(PREADY)
    );

    // Clock generation
    initial HCLK = 0;
    always #5 HCLK = ~HCLK; // 100MHz clock

    // Test sequence
    initial begin
        $display("Start of simulation");
        HRESETn = 0;
        HADDR   = 0;
        HTRANS  = 2'b00;
        HWRITE  = 0;
        HSIZE   = 3'b010;
        HWDATA  = 0;
        HSEL    = 0;
        HREADYIN= 1;
        PRDATA  = 32'hDEADBEEF;
        PREADY  = 1;

        // Reset pulse
        #20 HRESETn = 1;

        // -------------------------
        // 1. SINGLE WRITE TRANSFER
        // -------------------------
        @(negedge HCLK);
        HADDR   = 32'h0000_0010;
        HWDATA  = 32'hA5A5_A5A5;
        HWRITE  = 1;
        HTRANS  = 2'b10; // NONSEQ
        HSEL    = 1;
        #10 HSEL = 0;

        // Wait until bridge ready
        wait(HREADYOUT);

        // -------------------------
        // 2. SINGLE READ TRANSFER
        // -------------------------
        @(negedge HCLK);
        HADDR   = 32'h0000_0010;
        HWRITE  = 0;
        HTRANS  = 2'b10; // NONSEQ
        HSEL    = 1;
        #10 HSEL = 0;

        // Wait until bridge ready
        wait(HREADYOUT);
        $display("Read data: %h", HRDATA);

        // -------------------------
        // 3. BURST WRITE TRANSFERS
        // -------------------------
        repeat (4) begin
            @(negedge HCLK);
            HADDR   = HADDR + 4;
            HWDATA  = HWDATA + 1;
            HWRITE  = 1;
            HTRANS  = 2'b11; // SEQ
            HSEL    = 1;
            #10 HSEL = 0;
            wait(HREADYOUT);
        end

        // -------------------------
        // 4. BURST READ TRANSFERS
        // -------------------------
        repeat (4) begin
            @(negedge HCLK);
            HADDR   = HADDR + 4;
            HWRITE  = 0;
            HTRANS  = 2'b11; // SEQ
            HSEL    = 1;
            PRDATA  = PRDATA + 1;
            #10 HSEL = 0;
            wait(HREADYOUT);
            $display("Burst Read Data: %h", HRDATA);
        end

        $display("Test completed.");
        $stop;
    end

endmodule
