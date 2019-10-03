`timescale 1ns / 1ps
module AHBSpi(
			// Bus signals
			input wire HCLK,			// bus clock
			input wire HRESETn,			// bus reset, active low
			input wire HSEL,			// selects this slave
			input wire HREADY,			// indicates previous transaction completing
			input wire [31:0] HADDR,	// address
			input wire [1:0] HTRANS,	// transaction type (only bit 1 used)
			input wire HWRITE,			// write transaction
			input wire [31:0] HWDATA,	// write data
			output wire [31:0] HRDATA,	// read data from slave
			output wire HREADYOUT,		// ready output from slave

			// ====== SPI STUFF ======
			input MISO,
			output MOSI,
			output CS,
			output SCLK
    );
	
	// Registers to hold signals from address phase
	reg [1:0] rHADDR;	 // only need two bits of address
	reg rWrite, rRead;	 // write enable signals
	
	// Internal signals
	reg [7:0]	readData;		// 8-bit data from read multiplexer


	//================ SPI STUFF ==========================
	
	reg [7:0] nwriteData, nreadData, nMOSI;
	reg SCLK_i, chip_select, start_count, spi_ready;
	reg [6:0] clock_count;
	
	//================ END SPI ============================

 	// Capture bus signals in address phase
	always @(posedge HCLK)
		if(!HRESETn)
			begin
				rHADDR <= 2'b0;
				rWrite <= 1'b0;
				rRead  <= 1'b0;
			end
		else if(HREADY)
		 begin
			rHADDR <= HADDR[3:2];         // capture address bits for for use in data phase
			rWrite <= HSEL & HWRITE & HTRANS[1];	// slave selected for write transfer       
			rRead <= HSEL & ~HWRITE & HTRANS[1];	// slave selected for read transfer 
		 end
	
	// Bus output signals
	always @(posedge HCLK)
	begin
		if(!HRESETn)
		begin
			chip_select <= 1'b1; // active low
			nwriteData  <= 8'b0;
		end
		else if(rWrite)
			case (rHADDR)	// select on word address (stored from address phase)
				2'h0:		nwriteData <= HWDATA[7:0];	
				2'h1:		chip_select <= HWDATA[0];
			endcase
    end
		
	always @(rHADDR, nwriteData, chip_select, nreadData, spi_ready)
	   case (rHADDR)		// select on word address (stored from address phase)
            2'h0:        readData = nwriteData;
            2'h1:        readData = {7'b0, chip_select};
            2'h2:        readData = nreadData;
            2'h3:        readData = {7'b0, spi_ready};
        endcase
		
	assign HRDATA = {24'b0, readData};	// extend with 0 bits for bus read

	assign HREADYOUT = 1'b1;	// always ready - transaction never delayed

	//=============== SPI STUFF =================================
	//assign start_count = rWrite & (rHADDR == 2'b0);
	//assign spi_ready = clock_count == 6'd0;

	assign SCLK = SCLK_i;     // SPI clock signal
	assign CS = chip_select;  // SPI slave select signal, active low

	assign MOSI = nMOSI[7];   

	always @(posedge HCLK)
	begin
		if(!HRESETn)
		begin
			clock_count <= 7'd0;
			SCLK_i <= 1'd0;
			nMOSI <= 8'b0;
			nreadData <= 8'b0;
			start_count <= 1'd0;
			spi_ready <= 1'd0;
		end
		else if(start_count | (clock_count != 7'd0)) 
                begin
                    if(clock_count == 7'd0)  // where start_count = 1, clock_count = 0; a new round data transaction start
                    begin
                        nMOSI <= nwriteData; // uplode new transaction data
                    end
        
                    start_count <= 1'd0;     // pull start_count low, and start counting 
        
                    clock_count <= clock_count + 7'd1; // counting up
        
                    if(clock_count[2:0] == 3'd0) // SCLK flip over every 8 rising edge of HCLK have been detected
                    begin
                        SCLK_i <= ~SCLK_i;
        
                        if(SCLK) nMOSI <= {nMOSI[6:0], nMOSI[7]}; // transmit 1 bit at falling edge of SCLK
                        else nreadData <= {nreadData[6:0], MISO}; // receive 1 bit at rising edge of SCLK
                    end
                end
            else  // start_count = 0, clock_count = 0
            begin
                SCLK_i <= 1'd0;  
                clock_count <= 7'd0;
                
                if(rWrite & (rHADDR == 2'h0))
                begin
                    start_count <= 1'd1; // new data need to transmit, tell counter need to counting-up
                    spi_ready <= 1'd0;   // spi_ready pull back to low for indicate that SPI is busy now
                end
                else
                    spi_ready <= 1'd1;   // no data need to transcation, spi_ready stay high for indicate that SPI currently is idel
            end
	end
endmodule
