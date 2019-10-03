`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCD School of Electrical and Electronic Engineering
// Engineer: Anton Shmatov
// 
// Create Date:   7/4/2019
// Design Name: 	Cortex-M0 DesignStart system
// Module Name:   AHBpixpos 
// Description: 	Provides three addresses to write to 0-8, outputting a pixel position at each
//
// Revision: 
// Revision 0.01 - File Created
// Revision 1 - modified for synchronous reset, October 2015
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
			
			output [11:0] background,    // background colour
			output [11:0] point,         // point colour
			output sw_ctrl              // use switches for colour or not
    );
	
	// Registers to hold signals from address phase
	reg [2:0] rHADDR;			// only need 3 bits of address
	reg rWrite;                // store one bit to indicate write transaction 
	
	// Registers for input and output ports
	// reg [15:0] in0A, in0B, in1A, in1B, in2A, in2B;		// double registers for sync.
	reg [10:0] posx_out, posy_out, posz_out;	// byte registers - two per port
	reg [11:0] background_out, point_out;
	reg switches_out;
	
	assign posx = posx_out;
	assign posy = posy_out;
	assign posz = posz_out;
	assign background = background_out;
	assign point = point_out;
	assign sw_ctrl = switches_out;

	// Internal control signals
	reg [1:0] byteWrite;	// individual byte write enable signals
	wire  nextWrite = HSEL & HWRITE & HTRANS[1];	// slave selected for write transfer
	//reg [15:0]	readData;		// 16-bit data from read multiplexer

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
			begin
				posx_out <= 11'b0;
				posy_out <= 11'b0;
				posz_out <= 11'b0;
				background_out = 12'h0c3;
				point_out = 12'hfff;
				switches_out = 1'b1;
			end
		else
		 begin
				if (rWrite & rHADDR == 3'h0) posx_out <= HWDATA[10:0];
				if (rWrite & rHADDR == 3'h1) posy_out <= HWDATA[10:0];
				if (rWrite & rHADDR == 3'h2) posz_out <= HWDATA[10:0];
				if (rWrite & rHADDR == 3'h3) background_out <= HWDATA[11:0];
				if (rWrite & rHADDR == 3'h4) point_out <= HWDATA[11:0];
				if (rWrite & rHADDR == 3'h5) switches_out <= HWDATA[0];
		 end
	/*
	//	Input port registers
	always @(posedge HCLK)
		if(!HRESETn)
			begin
				in0A <= 16'b0;
				in0B <= 16'b0;
				in1A <= 16'b0;
				in1B <= 16'b0;
				in2A <= 16'b0;
				in2B <= 16'b0;
			end
		else 
		 begin		
				in0A <= posx;  	// A registers take data from ports, not synchronised
				in1A <= posy;
				in2A <= posz;
				in0B <= in0A;	// B registers copy from A registers - should be safe
				in1B <= in1A;
				in2B <= in2A;
		 end
		
	// Bus output signals
	always @(posx, posy, posz, rHADDR)
		case (rHADDR[3:2])		// select on word address
			2'h0:		readData = posx;		// address ends in 0x0
			2'h1:		readData = posy;		// address ends in 0x4
			2'h2:		readData = posz;		// address ends in 0x8
		endcase
	*/	
	assign HRDATA = {32'b0};    // , readData};	// extend with 0 bits for bus read
	assign HREADYOUT = 1'b1;	// always ready
       
endmodule
