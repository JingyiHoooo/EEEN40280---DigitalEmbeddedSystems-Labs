`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/05 00:49:49
// Design Name: 
// Module Name: calculator
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


 module calculator(
    input new_key,
    input [4:0]keycode,
    input clock,
    input reset,
    output reg [15:0] x
    );
    // We define all wires and reg's
    reg [15:0] next_x,next_y,next_m;
    reg [15:0] y,m;
    reg [1:0] op;
    reg [1:0] next_op;
    reg [15:0] result;
    wire [5:0] select ;
    
    
    assign select = {new_key, keycode};
    ///////////////////////////////////////////////////////////////////
    // X REGISTER
    //////////////////////////////////////////////////////////////////
    always @(*) begin
       //case describes the x muliplexer which has five inputs
        casex(select)
                 
                 6'b11xxxx: next_x = {x[11:0],keycode[3:0]};
                 6'b100100: next_x = result;
                 6'b101100: next_x = m;
                 6'b10xxxx: next_x = 16'b0;
                 default: next_x = x;
                 endcase
                 end
      //process describing the X register
     always @(posedge clock)
                        begin
                        if(reset) x<=16'b0;
                        else x<=next_x;
                        end
     ///////////////////////////////////////////////////////////////////
     // Y REGISTER
     //////////////////////////////////////////////////////////////////
    
    always @(*) begin
         
          // case to describe the Y multiplexer which has three inputs
          casex(select)
                               
                   
                   6'b101xxx: next_y = x;
                   6'b100010: next_y = 16'b0;
                   6'b100100: next_y = 16'b0;
                   default: next_y = y;
                   endcase
         end
         // process to describe the Y Register          
    always @(posedge clock)
                         begin
                         if(reset) y<=16'b0;
                         else y<=next_y;
                         end
      ///////////////////////////////////////////////////////////////////
      // Op REGISTER
      //////////////////////////////////////////////////////////////////
      
      
       always @(*) begin
         
          
          
          // case to describe the operator multiplexer which has four inputs one is described in two lines                  
          casex(select)
                                                
                    
                    6'b101011: next_op = select[1:0];
                    6'b101010: next_op = select[1:0];
                    6'b101001: next_op = select[1:0];
                    6'b100010: next_op = 2'b0;
                    6'b100100: next_op = 2'b0;
                    
                    default: next_op = op;
                    endcase
           end    
           // process to describe the operator register                                                     
        always @(posedge clock)
                                   begin
                                   if(reset) op <=2'b0;
                                   else op <=next_op;
                                   end
     ///////////////////////////////////////////////////////////////////
     // Get Result
     //////////////////////////////////////////////////////////////////
                                                                       
                                              
    always @(*) begin
    //case to describe the result multiplexer which has four inputs
    case(op)
               2'b11: result = x+y;
               2'b01: result = x*y;
               2'b10: result = y-x;
               default: result=x;
               endcase
     end
    
    
   ///////////////////////////////////////////////////////////////////
          // Memory register
          //////////////////////////////////////////////////////////////////

        always @(*) begin
         
          //case to describe the memory multiplexer which has two inputs
          casex(select)
                               
                   
                   6'b100001: next_m = x;
                   default: next_m = m;
                   endcase
         end
     //process to describe the memory register
    always @(posedge clock)
                         begin
                         if(reset) m<=16'b0;
                         else m<=next_m;
                         end
     
endmodule
