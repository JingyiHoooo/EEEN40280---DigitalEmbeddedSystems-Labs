`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/05 00:54:31
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench;
        // Inputs to module being verified
        reg clock, new_key, reset;
        reg [4:0] keycode;
        // Outputs from module being verified
        wire [15:0] x;
        // Instantiate module
        calculator uut (
            .clock(clock),
            .new_key(new_key),
            .keycode(keycode),
            .reset(reset),
            .x(x)
            );
        // Generate clock signal
        initial
            begin
                clock  = 1'b1;
                forever
                    #100 clock  = ~clock ;
            end
        initial
            begin
            reset = 1'b0;
            #180 reset = 1'b1;
            @ (negedge clock) reset = 1'b0;
            end
        // Generate other input signals
     initial // process to apply inputs
               begin
               #200
               new_key = 1'b0;
               keycode = 5'b0;
               #200
               keycode = 5'b10001;//input 1 to X register
               #200
               new_key = 1'b1;//0001 are in the display
               #200
               new_key = 1'b0;// newkey goes down after 1 clock cycle
               #200;
               keycode = 5'b10010;//input 2 to X register
               #200;
               new_key = 1'b1;//0012 are in the display
               #200;
               new_key = 1'b0;
               #200
               keycode = 5'b10011;//input 3 to X register
               #200;
               new_key = 1'b1;//0123 are in the display
               #200;
               new_key = 1'b0;
               #200
               keycode = 5'b10100;//input 4 to X register
               #200;
               new_key = 1'b1;//1234 are in the display
               #200;
               new_key = 1'b0;
               #200
               keycode = 5'b01011;// + key was pressed
               #200;
               new_key = 1'b1;//0000 are in the display
               #200;
               new_key = 1'b0;
               #200
               keycode = 5'b10101;//input 5 to X register
               #200;
               new_key = 1'b1;//0005 are in the display
               #200;
               new_key = 1'b0;
               #200
               keycode = 5'b10110; //input 5 to X register
               #200;
               new_key = 1'b1;//0056 are in the display
               #200;
               new_key = 1'b0;
               #200
               keycode = 5'b10111;//input 7 to X register
               #200
               new_key = 1'b1;//0567 are in the display
               #200;
               new_key = 1'b0;
               #200
               keycode = 5'b11000;//input 8 to X register
               #200
               new_key = 1'b1;//5678 are in the display
               #200;
               new_key = 1'b0;
               #200
               keycode = 5'b00100;//press =,
               #200 new_key = 1'b1;// 68ac are in the display
               #200 new_key = 1'b0;
               #200  keycode = 5'b01010;// do subtraction
               #200  new_key = 1'b1;// 0000 are in the display
               #200  new_key = 1'b0;//
               #200 keycode = 5'b10101;
               #200;
               new_key = 1'b1;//0005
               #200;
               new_key = 1'b0;
               #200
               keycode = 5'b10110;
               #200;
               new_key = 1'b1;//0056
               #200;
                new_key = 1'b0;
               #200
               keycode = 5'b10111;
               #200
               new_key = 1'b1;//0567
               #200;
               new_key = 1'b0;
               #200
               keycode = 5'b11000;
               #200
               new_key = 1'b1;//5678
               #200;
               new_key = 1'b0;
               #200 keycode = 5'b00100;//press = key
               #200 new_key = 1'b1;//1234 are in the display
               #200 new_key = 1'b0;
               #200 keycode = 5'b01001;//test multiplication
               #200 new_key = 1'b1;// 0000 are in the display
               #200 new_key = 1'b0;
               #200 keycode = 5'b10011;////input 3 to X register
               #200 new_key = 1'b1;//0003 are in the display
               #200 new_key = 1'b0;
               #200 keycode = 5'b00011;//press CE
               #200 new_key = 1'b1;// X register is cleared,0000 are in the display
               #200 new_key = 1'b0;
               #200 keycode = 5'b10010;//input 2 to X register
               #200 new_key = 1'b1;//0002 are in the display
               #200 new_key = 1'b0;
               #200 keycode = 5'b00100;//press =
               #200 new_key = 1'b1;//2468 are in the display
               #200 new_key = 1'b0;
               #200 keycode = 5'b00001;//press store
               #200 new_key = 1'b1;//store 2468 to memory register, 0000 are in the display
               #200 new_key = 1'b0;
               #200 keycode = 5'b01100;//press recall
               #200 new_key = 1'b1;//2468 is copied from memory register to X register, 2468 are in the display
               #200 new_key = 1'b0;
               #200 keycode = 5'b00010;//press CA
               #200 new_key = 1'b1;//clear all register except memory register, 0000 are in the display
               #200 new_key = 1'b0;
               #400
       ////////////////////////////////////////////////////////////////////////////////////////
               $stop;//stop verification
            end
endmodule
