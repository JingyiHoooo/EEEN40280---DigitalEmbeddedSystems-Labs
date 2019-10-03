`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: TB_AHBuart2 - testbench for AHB uart block
/////////////////////////////////////////////////////////////////
module TB_AHBuart2(    );
     
	 reg HCLK;				// bus clock
    reg HRESETn;            // bus reset, active low
    reg HSELx = 1'b0;       // selects this slave
    reg [31:0] HADDR = 32'h0;    // address
    reg [1:0] HTRANS = 2'b0;    // transaction type (only bit 1 used)
    reg HWRITE = 1'b0;            // write transaction
    reg [2:0] HSIZE = 3'b0;        // transaction width (max 32-bit supported)
    reg [31:0] HWDATA = 32'h0;    // write data
    wire [31:0] HRDATA;    // read data from slave
    wire HREADY;            // ready signal - from slave, also to slave
	 
	wire serialRx, serialTx, uart_IRQ;
	assign serialRx = serialTx;  // loopback connection for testing
	
	integer i;
    localparam [2:0] BYTE = 3'b000, HALF = 3'b001, WORD = 3'b010;   // HSIZE values
    localparam [1:0] IDLE = 2'b00, NONSEQ = 2'b10;    // HTRANS values
    
    AHBuart2 dut(
        .HCLK(HCLK),				
        .HRESETn(HRESETn),
        .HSEL(HSELx),
        .HREADY(HREADY),
        .HADDR(HADDR),
        .HTRANS(HTRANS),
        .HWRITE(HWRITE),  
        .HWDATA(HWDATA),  
        .HRDATA(HRDATA),  
        .HREADYOUT(HREADY),
		.serialRx(serialRx),
		.serialTx(serialTx),
		.uart_IRQ(uart_IRQ)
         );
    
    initial
    begin
        HCLK = 1'b0;
        forever	// generate 50 MHz clock
        begin
          #10 HCLK = ~HCLK;
        end
    end

    initial
    begin
        HRESETn = 1'b1;
        #20 HRESETn = 1'b0;
        #20 HRESETn = 1'b1;
        #50;
        
        AHBwrite(WORD, 32'h0, 32'h1a2b3c4d);	// should do nothing
		AHBidle;
        AHBwrite(WORD, 32'h4, 32'h12345678);  // transmit data
        AHBread (WORD, 32'h4, 32'h78);		// read back data?
        AHBread (WORD, 32'h8, 32'h2);   // read status: tx empty, rx empty
        AHBwrite(WORD, 32'h4, 32'h56);  // send more data
        AHBwrite(WORD, 32'h4, 32'h34);  
        AHBread (WORD, 32'h8, 32'h0);  // read status: tx not empty, rx still empty
        AHBwrite(WORD, 32'hC, 32'hc);	// enable rx interrupts
        AHBread (WORD, 32'hC, 32'hC);	// readback of control register
		  for (i=0; i<20; i=i+1)
				AHBwrite(WORD, 32'h4, i+20);  // transmit data to fill fifo
        AHBread (WORD, 32'h8, 32'h1); // read status: tx full, rx ?
        AHBidle;
		  
		  wait (uart_IRQ == 1'b1); // wait for interrupt
        AHBread (WORD, 32'h8, 32'h8); // read status: rx not empty
        AHBread (WORD, 32'h0, 32'h78);	// read data - should be first byte sent
        AHBidle;
		  
		  @ (posedge uart_IRQ ); // wait for interrupt
        AHBread (WORD, 32'h8, 32'ha); // read status: rx not empty, tx probably empty by now
        AHBread (WORD, 32'h0, 32'h56);	// read data
        AHBidle;
		  
		  @ (posedge uart_IRQ ); // wait for interrupt
        AHBread (WORD, 32'h8, 32'ha); // read status: tx empty, rx not empty
        AHBread (WORD, 32'h0, 32'h34);	// read data - should be third byte
        AHBread (WORD, 32'h8, 32'h2); // read status: tx empty, rx not empty
        AHBwrite(WORD, 32'hC, 32'h2);			// enable tx empty interrupt
        AHBidle;
		  
		  @ (posedge uart_IRQ ); // wait for interrupt
		  for (i=20; i<30; i=i+1)
				AHBwrite(WORD, 32'h4, i+20);  // send more data to fill RX fifo
        AHBread (WORD, 32'h8, 32'hc); // read status: rx full
        AHBidle;
		  for (i=0; i<20; i=i+1)
				AHBread (WORD, 32'h0, i+20);  // check received data 
		#50;
		$stop;
		  
        
    end


// =========== AHB bus tasks - crude models of bus activity =========================
    // Read and Write tasks do not restore bus to idle, as another transaction might follow
    // Use Idle task immediately after read or write if no more transactions
    
        reg [31:0] nextWdata = 32'h0;   // delayed data for write transactions
        reg [31:0] expectRdata = 32'h0;   // expected read data for read transactions
         reg [31:0] rExpectRead;        // store expected read data
         reg checkRead;                    // remember that read in progress
        reg error = 1'b0;  // read error signal - asserted for one cycle AFTER read completes
    
        task AHBwrite;        // simulates write transaction on AHB Lite
            input [2:0] size;   // transaction width - BYTE, HALF or WORD
            input [31:0] addr;  // address
            input [31:0] data;  // data to be written
            begin
                wait (HREADY == 1'b1); // wait for ready signal - previous transaction completing
                @ (posedge HCLK);  // align with clock
                #2 HSIZE = size;    // set up signals for address phase, just after clock edge
                HTRANS = NONSEQ;
                HWRITE = 1'b1;
                HADDR = addr;
                HSELx = 1'b1;
                nextWdata = data;    // store data for use in data phase
    
            end
        endtask
    
        task AHBread;       // simulates read transaction on AHB Lite
            input [2:0] size;   // transaction width - BYTE, HALF or WORD
            input [31:0] addr;  // address
            input [31:0] data;  // expected data from slave
            begin  
                wait (HREADY == 1'b1); // wait for ready signal - previous transaction completing
                @ (posedge HCLK);  // align with clock
                #2 HSIZE = size;  // set up signals for address phase, just after clock edge
                HTRANS = NONSEQ;
                HWRITE = 1'b0;
                HADDR = addr;
                HSELx = 1'b1;
                expectRdata = data;  // store expected data for checking in data phase
            end
        endtask
    
        task AHBidle;       // use after read or write to put bus in idle state
            begin  
                wait (HREADY == 1'b1); // wait for ready signal - previous transaction completing
                @ (posedge HCLK);        // then wait for clock edge
                #2 HTRANS = IDLE;        // set transaction type to idle
                HSELx = 1'b0;           // deselect the slave
            end
        endtask

    // register holds write data until needed
    always @ (posedge HCLK or negedge HRESETn)
        if (~HRESETn) HWDATA <= 32'b0;
        else if (HWRITE && HTRANS && HREADY) // write transaction moving to data phase
                        #1 HWDATA <= nextWdata;

    // register holds read data until needed, another remembers that read in progress
    always @ (posedge HCLK or negedge HRESETn)
		if (~HRESETn) begin
								rExpectRead <= 32'b0;
								checkRead <= 1'b0;
							end
		else if (~HWRITE && HTRANS && HREADY)  // read transaction moving to data phase
						begin
							rExpectRead <= expectRdata;	// update register with expected data
							checkRead <=1'b1;
						end
		else if (HREADY) // some other transaction moving to data phase
							checkRead <= 1'b0;		//  no need to check

	// check read data as transaction completes
	always @ (posedge HCLK)
		if (checkRead & HREADY)	// read transaction completing
				error = (HRDATA != rExpectRead);	// read transaction completing
      else error = 1'b0;	// error will be asserted for one cycle AFTER problem detected
       
       
endmodule
