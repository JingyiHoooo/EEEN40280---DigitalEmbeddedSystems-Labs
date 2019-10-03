`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCD School of Electrical and Electronic Engineering
// Engineer: Anton Shmatov
// 
// Create Date:   03/04/2019
// Design Name:   VGA
// Module Name:   vga_pixels
// Description: 	Provides VGA pixels from input coordinate positions
//
// Revision: 
// Revision 0.01 - File Created
//
//////////////////////////////////////////////////////////////////////////////////
module vga_pixels
        #( 
            WIDTH = 1280,
            HEIGHT = 1024
            )
        (
    		input CLK,			// clock, 108 MHz
    		input RESET,			// reset, active high

    		// pixel control
    		input hdisp,  // horizontal display
    		input vdisp,    // vertical display
    		input [10:0] hpix,  // horizontal pixel counter
    		input [10:0] vpix,  // vertical pixel counter
    		
            input [10:0] xpos, // x position of the square to display
            input [10:0] ypos, // y position
            input [10:0] zpos, // z position
            
            input [11:0] background,    // background colour
            input [11:0] point,         // point colour
            input sw_ctrl,              // control colours with switches
            //---- temp inputs
            input [11:0] sw,
            //---- temp inputs

            output [3:0] vgaRed,    // red signal
            output [3:0] vgaGreen,  // green signal
            output [3:0] vgaBlue    // blue signal
    );
    
    wire within_area, display;
    reg sw_ctrl_in, sw_ctrl_r;
    reg [11:0] background_in, background_r, point_in, point_r;
    reg [3:0] red, green, blue;
    reg [10:0] xpos_r, ypos_r, zpos_r, xpos_in, ypos_in, zpos_in;
    wire [10:0] sqsize, top, bot, left, right;
    
    assign vgaRed = red;
    assign vgaGreen = green;
    assign vgaBlue = blue;

    assign display = hdisp & vdisp;
    
    assign sqsize = (zpos_r < 11'd10 ? 11'd5 : (zpos_r / 11'd2));

    assign top = ypos_r < sqsize ? 0 : ypos_r - sqsize;
    assign bot = (ypos_r + sqsize) > HEIGHT ? HEIGHT : ypos_r + sqsize;
    assign left = xpos_r < sqsize ? 0 : xpos_r - sqsize;
    assign right = (xpos_r + sqsize) > WIDTH ? WIDTH : xpos_r + sqsize;
    
    assign within_area = (vpix < bot & vpix >= top)
        & (hpix < right & hpix >= left); 
    
    always @(posedge CLK)
    begin
        if(RESET)
        begin
            red <= 4'd0;
            green <= 4'd0;
            blue <= 4'd0;
            
            xpos_in <= 11'd0;
            ypos_in <= 11'd0;
            zpos_in <= 11'd0;
            
            sw_ctrl_in <= 1'd0;
            
            background_in <= 12'd0;
            point_in <= 12'd0;
        end
        else
        begin
            if(display)
            begin
                if(sw_ctrl_r)
                begin
                    red <= within_area      ? 4'hf : sw[11:8];
                    green <= within_area    ? 4'hf : sw[7:4];
                    blue <= within_area     ? 4'hf : sw[3:0];
                end
                else
                begin
                    red <= within_area      ? point_r[11:8] : background_r[11:8];
                    green <= within_area    ? point_r[7:4]  : background_r[7:4];
                    blue <= within_area     ? point_r[3:0]  : background_r[3:0];
                end
            end
            else
            begin
                red <= 4'd0;
                green <= 4'd0;
                blue <= 4'd0;
            end
            
            xpos_in <= xpos;
            ypos_in <= ypos;
            zpos_in <= zpos;
            
            sw_ctrl_in <= sw_ctrl;
            background_in <= background;
            point_in <= point;
        end
    end
    
    always @(posedge vdisp)
    begin
        xpos_r <= xpos_in;
        ypos_r <= ypos_in;
        zpos_r <= zpos_in;
        
        sw_ctrl_r <= sw_ctrl_in;
        background_r <= background_in;
        point_r <= point_in;
    end

endmodule
