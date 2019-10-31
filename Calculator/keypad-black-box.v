//////////////////////////////////////////////////////////////////////////////////
// Engineer: 	   Brian Mulkeen 
// Module Name:    keypad 
// Project Name:   Calculator Design Exercise
// Description:    Keypad interface for matrix keypad with 24 keys.
// Keypad layout:  4 x 4 hexadecimal keys on left, 4 x 2 unmarked keys on right
//  column -->  5   4   3   2            1       0
//      row[0]  7   8   9   F           5'h9    5'h1   
//      row[1]  4   5   6   E           5'ha    5'h2   
//      row[2]  1   2   3   D           5'hb    5'h3   
//      row[3]  0   A   B   C           5'hc    5'h4   
//
// Operation:
//    Scans 4 rows of keypad, checking 6 columns for input.
//    Handles debounce, wait for release and key encoding.
//    Outputs newkey signal for 1 clock cycle for each key pressed.
//    Outputs 5-bit code for key:  abcde
//       a = 1 for digit key, with bcde = 4-bit digit value,
//       a = 0 for other key, then b = 1 for column 1, 0 for column 0, 
//										and cde = row number + 1.
//			If no key or invalid key pressed, output is 00000.
//
// Create Date:  29 November 2010 
// Revision 1 - 13 Nov 2011 - modified for 5 MHz clock and reversed column order
// Revision 2 - Oct 2012 - modified for 24-key keypad
// Revision 3 - Oct 2013 - changed comments and key codes
//////////////////////////////////////////////////////////////////////////////////
module keypad(
    input clk,					// clock signal at 5 MHz
    input rst,					// active-high asynchronous reset
    input [5:0] kpcol,			// inputs from keypad columns, 0 on right
    output reg [3:0] kprow, 	// outputs to drive keyad rows, 0 on top
    output newkey,				// high for one cycle for each new keypress
    output reg [4:0] keycode);	// code to represent key - valid during newkey	 

// The hardware of this module is already synthesised, in keypad.ngc
// Include this file and keypad.ngc in your project.

endmodule
