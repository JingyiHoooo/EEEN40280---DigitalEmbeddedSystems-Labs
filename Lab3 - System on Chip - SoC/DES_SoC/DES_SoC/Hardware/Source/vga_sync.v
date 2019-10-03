`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCD School of Electrical and Electronic Engineering
// Engineer: Anton Shmatov
// 
// Create Date:   02/04/2019
// Design Name: 	VGA
// Module Name:   vga_sync
// Description: 	Provides VGA hsync and vsync signals
//
// Revision: 
// Revision 0.01 - File Created
//
//////////////////////////////////////////////////////////////////////////////////
 module vga_sync
    #(
        parameter HSYNC = 1688,
        parameter HPULSE = 112,
        parameter HFRONT = 48,
        parameter HBACK = 248,
        parameter VSYNC = 1066,
        parameter VPULSE = 3,
        parameter VBACK = 38,
        parameter VFRONT = 1
    )
    (
        input CLK,		// clock, 108 MHz
        input RESET,	// reset, active high
        // outputs
        output hsync_out,	// horizontal sync
        output vsync_out,	// vertical sync
        
        // pixel control
        output hdisp_out,
        output vdisp_out,    // vertical refresh
        output [10:0] hpix,  // horizontal pixel counter
        output [10:0] vpix   // vertical pixel counter
    );

    wire hsyncon, vsyncon, hsyncoff, vsyncoff;
    wire hdispon, hdispoff, vdispon, vdispoff;
    reg [10:0] hcount, vcount; // 11 bit counters for 1688 and 1066 respectively
    reg hsync, vsync, hdisp, vdisp;
    
    // sync signal controls
    assign hsyncoff = (hcount == (HSYNC - 11'd1));
    assign vsyncoff = (vcount == (VSYNC - 11'd1));
    assign hsyncon = (hcount == (HPULSE - 11'd1));
    assign vsyncon = (vcount == (VPULSE - 11'd1));
    
    // horizontal display controls
    assign hdispon = (hcount == (HPULSE + HBACK - 11'd1));
    assign hdispoff = (hcount == (HSYNC - HFRONT - 11'd1));
    
    // vertical display controls
    assign vdispon = (vcount == (VPULSE + VBACK - 11'd1));
    assign vdispoff = (vcount == (VSYNC - VFRONT - 11'd1));
    
    // sync wires
    assign hsync_out = hsync;
    assign vsync_out = vsync;
    
    // display wires
    assign hdisp_out = hdisp;
    assign vdisp_out = vdisp;
    
    // pixel counters
    assign hpix = (hdisp_out ? hcount - (HPULSE + HBACK) : 11'd0);
    assign vpix = (vdisp_out ? vcount - (VPULSE + VBACK) : 11'd0);
    
    always @(posedge CLK)
    begin
        if(RESET)
        begin
            // resets
            hcount <= 11'd0;
            vcount <= 11'd0;
            
            hsync <= 1'd0;
            vsync <= 1'd0;
            hdisp <= 1'd0;
            vdisp <= 1'd0;
        end
        else
        begin
            // hcount and vcount increments
            hcount <= (hcount == (HSYNC - 11'd1)) ? 11'd0 : hcount + 11'd1;
            
            // only reset vcount if both are at max
            vcount <= (hcount == (HSYNC - 11'd1)) ? (vcount == (VSYNC - 11'd1) ? 11'd0 : vcount + 11'd1) : vcount;

            // sync activates on edges of counters
            hsync <= hsyncoff ? 1'd0 : (hsyncon ? 1'd1 : hsync);
            vsync <= (vsyncoff & hsyncoff) ? 1'd0 : ((vsyncon & hsyncoff) ? 1'd1 : vsync);
            
            // display activates between porches
            hdisp <= hdispoff ? 1'd0 : (hdispon ? 1'd1 : hdisp);
            vdisp <= (vdispoff & hsyncoff) ? 1'd0 : ((vdispon & hsyncoff) ? 1'd1 : vdisp);
        end
    end
endmodule
