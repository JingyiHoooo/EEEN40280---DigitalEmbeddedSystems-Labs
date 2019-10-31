`timescale 1ns / 1ps


module Display_interface(
    //declare inputs and outputs
    input [15:0] Value ,
    input [3:0] Point,
    input clk,
    output [7:0] Segment,
    output reg [7:0] digit,
    input rst
    );
    // declare internal wires and reg's
    reg [3:0] number;
    reg [9:0] currdig;
    reg Dot;
    wire [3:0] inv_point;
    
    //create an inverse of input point
    assign inv_point = (~Point);
    
    
    // create a process which is a counter
    always @ (posedge clk,posedge rst)
        begin
        
        if (rst == 1'b1) currdig <= 10'b0;
        else 
            begin
            //add 1 to currdig on each clock edge
            currdig <= currdig + 1'b1;
            
            end
        end
        // process which reevaluates when value, point or currdig's 
        //9th or 10th digit changes
        // we use the 9th and 10th digit of currdig as we need to 
        //slow the clock down to around 5000 Hz
    always @ (currdig[9:8], Value, inv_point)
        begin
        
        case(currdig[9:8])
        //for each value of the 2 bits off currdig we change the 
        //value of digit to cycle through the digits on the display
        //we change the value of number to a different part of 
        //value because we are now displaying a different digit
        //we assign dot which is the hexidecimal point to one bit 
        //of the inverse of point
            2'b00:      begin
                        digit = 8'b11111110;
                        number = Value[3:0];
                        Dot = inv_point[0];
                        end
            
            2'b01:      begin
                        digit = 8'b11111101;
                        number = Value[7:4];
                        Dot = inv_point[1];
                        end
            
            2'b10:      begin
                        digit = 8'b11111011;
                        number = Value[11:8];
                        Dot = inv_point[2];
                        end
            
            2'b11:      begin
                        digit = 8'b11110111;
                        number = Value[15:12];
                        Dot = inv_point[3];
                        end
        endcase
        
       
        
        end
        // we use hex2seg module to change the 4 bit number into a 
        //8 bit to use for our segment output
        hex2seg h(.number(number), .pattern(Segment[7:1]));
        // we assign the least significant bit of segmant equal to 
        //our Dot wire
        assign Segment[0] = Dot;
 
 endmodule
    
    
    
  
        
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    

