`timescale 1ns / 1ps

module AHBLed2(
			// Bus signals
			input wire HCLK,			// bus clock
			input wire HRESETn,			// bus reset, active low
			input wire HSEL,			// selects this slave
			input wire HREADY,			// indicates previous transaction completing
			input wire [31:0] HADDR,	// address
			input wire [1:0] HTRANS,	// transaction type (only bit 1 used)
			input wire HWRITE,			// write transaction
			input wire [31:0] HWDATA,	// write number
			output wire [31:0] HRDATA,	// read number from slave
			output wire HREADYOUT,		// ready output from slave

			// ====== LED ======
			output [7:0] Seg_display,    //Segment to display, active low
			output reg [7:0] digit	 
			
    );
	
	
	// Registers to hold signals from address phase
    reg rHADDR;			// only need 1 bit of address        
    reg rWrite;         // store one bit to indicate write transaction 
	
	// Internal control signals
    reg [31:0] readData;       
	reg [3:0]  number;
    reg [15:0] currdig;
	//================ LED STUFF ==========================
   
    reg [31:0] numberTodisplay;      
	reg [7:0]  decPoint;
    reg Dot;

	
    // Capture bus and internal signals in address phase
	always @(posedge HCLK)
		if(!HRESETn)
			begin
				rHADDR <= 1'b0;
				rWrite <= 1'b0;
			end
		else if(HREADY)       // only update if HREADY is 1 - previous transaction completing
             begin
                rHADDR <= HADDR[2];         // capture signals from address phase
                rWrite <=  HSEL & HWRITE & HTRANS[1]; 
             end

	// Bus output signals
	always @(posedge HCLK)
		begin
			if(!HRESETn)
				begin
					numberTodisplay <= 32'b0;
					decPoint  <= 8'b0;
				end
			else if(rWrite)
				case (rHADDR)		// select on word address (stored from address phase)
					1'h0:		numberTodisplay <= HWDATA[31:0];
					1'h1:		decPoint  <= HWDATA[7:0];
				endcase
		 end
		 
    always @(numberTodisplay,decPoint, rHADDR)
        case (rHADDR)       
            1'b0:        readData = numberTodisplay;       
            1'b1:        readData = {24'b0,decPoint}; 
        endcase
             
    assign HRDATA = readData; 
		 
    assign HREADYOUT = 1'b1;   

	//=============== LED STUFF =================================
	
        always @ (posedge HCLK) 
			begin
            
				if(!HRESETn) currdig <=16'b0;
				else 
					begin
					 //add 1 to currdig on each clock edge
					currdig <= currdig+1;
					end
			end
        // process which reevaluates when value, point or currdig's 
        //12th,13th,or 14th digit changes
        // Use the 12th,13th,14th digit of currdig as we need to 
        //slow the clock down to around 763 Hz, therefore, refresh period is 1.3ms

        always @(currdig[15:13],numberTodisplay,decPoint)
            begin
              case(currdig[15:13])    
              //for each value of the 3 bits off currdig we change the 
              //value of digit to cycle through the digits on the display
              //Change the value of number to a different part of 
              //value because we are now displaying a different digit
              //Assign dot which is the hexidecimal point to one bit 
              //of the inverse of point
              
                3'h00:    begin
							digit = 8'b11111110;
							number = numberTodisplay[3:0];
							Dot = ~decPoint[0]; 
						  end
				  
                3'h01: 	 begin
							digit = 8'b11111101;
							number = numberTodisplay[7:4];
							Dot = ~decPoint[1]; 
						  end
						  
                3'h02:   begin
							digit = 8'b11111011;
							number = numberTodisplay[11:8];
							Dot = ~decPoint[2]; 
						  end
				  
                3'h03: 	  begin
							digit = 8'b11110111;
							number = numberTodisplay[15:12];
							Dot = ~decPoint[3]; 
						  end
				  
                3'h04:    begin
							digit = 8'b11101111;
							number = numberTodisplay[19:16];
							Dot = ~decPoint[4]; 
						  end
						  
                3'h05:    begin
							digit = 8'b11011111;
							number = numberTodisplay[23:20];
							Dot = ~decPoint[5]; 
						  end
                3'h06: 	  begin
							digit = 8'b10111111;
							number = numberTodisplay[27:24];
							Dot = ~decPoint[6]; 
						  end
						  
                3'h07:    begin
						 	digit = 8'b01111111;
							number = numberTodisplay[31:28];
							Dot = ~decPoint[7];                     
						  end
                  
              endcase
            end
    
 //======================== HEX2SEG ================================
 hex2seg   led(
            .number     (number),
            .pattern    (Seg_display[7:1])
        );     
        assign Seg_display[0] = Dot;
// Use hex2seg module to changetranslate the each 4-bit number into a 
// 8-bit corresponse segment signals

// Assign the least significant bit of segmant equal to  Dot wire
endmodule
