`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCD School of Electrical and Electronic Engineering
// Engineer: Anton Shmatov
// 
// Create Date:   7/4/2019
// Module Name:     AHBpixpos 
// Description: 	Provides three addresses to write to 0-8, outputting a pixel position at each
//
// Revision: 
// Revision 0.01 - File Created
// Revision 0.1 - Read registers introduced
//
//////////////////////////////////////////////////////////////////////////////////
module AHBpixpos(
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
			// coordinate position signals
			output [10:0] posx,			// write address 0
			output [10:0] posy,			// write address 4
			output [10:0] posz,			// write address 8
			
			// colours and switch control
			output [11:0] background,    // background colour
			output [11:0] point,         // point colour
			output sw_ctrl              // use switches for colour or not
    );
	
	// Registers to hold signals from address phase
	reg [2:0] rHADDR;			// only need 3 bits of address
	reg rWrite;                // store one bit to indicate write transaction 
	
	// Registers for output ports
	reg [10:0] posx_out, posy_out, posz_out;	// byte registers - two per port
	reg [11:0] background_out, point_out, readData;
	reg switches_out;
	
	assign posx = posx_out;
	assign posy = posy_out;
	assign posz = posz_out;
	assign background = background_out;
	assign point = point_out;
	assign sw_ctrl = switches_out;

	// Internal control signals
	wire  nextWrite = HSEL & HWRITE & HTRANS[1];	// slave selected for write transfer

 	// Capture bus and internal signals in address phase
	always @(posedge HCLK)
		if(!HRESETn)
			begin
				rHADDR <= 3'b0;
				rWrite <= 1'b0;
			end
		else if(HREADY)       // only update if HREADY is 1 - previous transaction completing
             begin
                rHADDR <= HADDR[4:2];         // capture signals from address phase
                rWrite <= nextWrite;
             end
	
	//	Output port registers
	always @(posedge HCLK)
		if(!HRESETn)
			begin // default values
                posx_out <= 11'b0;
                posy_out <= 11'b0;
                posz_out <= 11'b0;
                background_out = 12'h0c3;
                point_out = 12'hfff;
                switches_out = 1'b1;
			end
        else if(rWrite)
            begin // various registers to be written to
                case(rHADDR)
                    3'h0:   posx_out <= HWDATA[10:0];
                    3'h1:   posy_out <= HWDATA[10:0];
                    3'h2:   posz_out <= HWDATA[10:0];
                    3'h3:   background_out <= HWDATA[11:0];
                    3'h4:   point_out <= HWDATA[11:0];
                    3'h5:   switches_out <= HWDATA[0];
                endcase
            end
    
    // reading from stored values
    always @(rHADDR, posx_out, posy_out, posz_out, background_out, point_out, switches_out)
	   case (rHADDR)
            3'h0:        readData = {1'b0, posx_out};
            3'h1:        readData = {1'b0, posy_out};
            3'h2:        readData = {1'b0, posz_out};
            3'h3:        readData = background_out;
            3'h4:        readData = point_out;
            3'h5:        readData = {11'b0, switches_out};
            default:     readData = 12'b0;
        endcase
        
	assign HRDATA = {20'b0, readData}; // extend with 0 bits for bus read
	assign HREADYOUT = 1'b1;	// always ready
       
endmodule
