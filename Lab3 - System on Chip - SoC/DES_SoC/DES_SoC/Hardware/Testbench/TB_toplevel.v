`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: TB_toplevel
// Simple testbench for SoC - no program load, just clock and reset
/////////////////////////////////////////////////////////////////
module TB_toplevel(    );
     
    reg btnCpuReset, clk100, btnU; 
    wire [15:0] LED;
    wire  RsRx = 1'b1;		// serial receive at idle
    wire RsTx;        // serial transmit
     
    AHBliteTop dut(
        .clk(clk100), 
        .btnCpuReset(btnCpuReset),
        .btnU(btnU),
        .RsRx(RsRx),
        .led(LED), 
        .RsTx(RsTx)
         );
         
 
   initial
    begin
        clk100 = 0;
        forever	// generate 100 MHz clock
        begin
          #5 clk100 = ~clk100;  // invert clock every 5 ns
         end
    end

    initial
    begin
        btnCpuReset = 1'b1;		// start with reset inactive
        btnU = 1'b0;					// loader button not pressed
        #30 btnCpuReset = 1'b0;  // active low reset
        #70 btnCpuReset = 1'b1;  // release reset
        
        #20000;      // delay 20 us or 1000 clock cycles

	// should have no stop instruction - this could run indefinitely...
	// but Vivado 2015.2 cannot regain control?
		$stop;
        
      end
     
     
        
endmodule
