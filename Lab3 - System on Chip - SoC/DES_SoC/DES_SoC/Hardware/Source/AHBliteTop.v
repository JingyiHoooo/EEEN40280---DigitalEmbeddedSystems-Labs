`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCD School of Electrical and Electronic Engineering
// Engineer: Brian Mulkeen
// 
// Create Date:   18:24:44 15Oct2014 
// Design Name: 	Cortex-M0 DesignStart system for Digilent Nexys4 board
// Module Name:   AHBliteTop 
// Description: 	Top-level module.  Defines AHB Lite bus structure,
//			instantiates and connects all other modules in system.
//
// Revision: 1 - Initial distribution for assignment
// Revision 0.01 - File Created
//
//////////////////////////////////////////////////////////////////////////////////
module AHBliteTop (
    input clk,          // input clock from 100 MHz oscillator on Nexys4 board
    input btnCpuReset,  // reset pushbutton, active low (CPU RESET)
    input btnU,         // up button - if pressed after reset, ROM loader activated
    input btnD,         // down button
    input btnL,         // left button
    input btnC,         // centre button
    input btnR,         // right button
    input RsRx,         // serial port receive line
    input [15:0] sw,    // 16 slide switches on Nexys 4 board
    output [15:0] led,   // 16 individual LEDs above slide switches   
    output [5:0] rgbLED,   // multi-colour LEDs - {blu2, grn2, red2, blu1, grn1, red1} 
    output [7:0] JA,    // monitoring connector on FPGA board - use with oscilloscope
    output RsTx,     // serial port transmit line
    
    // VGA
    output Hsync,       // vga hsync output
    output Vsync,       // vga vsync output
    output [3:0] vgaRed,    // red signal of vga
    output [3:0] vgaGreen,  // green signal of vga
    output [3:0] vgaBlue,   // blue signal of vga
    
    // SPI
    input  aclMISO,         // Master in slave out
    output aclMOSI,         // Master out slave in
    output aclSCK,          // Slave Clock
    output aclSS,            // Chip Select
	
	// LED segment
	output [7:0] an,    // digits output 
	output [6:0] seg,   // segment output for one digit
	output  dp			// decimal point for one digit
    );
 
  localparam  BAD_DATA = 32'hdeadbeef;

// ========================= Signals for monitoring on oscilloscope == 
    assign JA = {Hsync, Vsync, vgaRed[3], vgaGreen[3], aclMISO, aclMOSI, aclSCK, aclSS};   // monitor serial communication
    
// ========================= Bus =====================================
// Define AHB Lite bus signals
// Note that signals HMASTLOCK and HBURST are omitted - not used by processor
    wire        HCLK;       // 50 MHz clock
    wire        VGACLK;     // 108 MHz clock
    wire        HRESETn;    // active low reset
// Signals from processor
    wire [31:0]	HWDATA;     // write data
    wire [31:0]	HADDR;      // address
    wire 		HWRITE;     // write signal
    wire [1:0] 	HTRANS;     // transaction type
    wire [3:0] 	HPROT;      // protection
    wire [2:0] 	HSIZE;      // transaction width
// Signals to processor    
    wire [31:0] HRDATA;     // read data
    wire		HREADY;     // ready signal from active slave
    wire 		HRESP;      // error response
    
// ========================= Signals to-from individual slaves ==================
// Slave select signals (one per slave)
    wire        HSEL_rom, HSEL_ram, HSEL_gpio, HSEL_uart, HSEL_pixpos, HSEL_spi,HSEL_led;
// Slave output signals (one per slave)
    wire [31:0] HRDATA_rom, HRDATA_ram, HRDATA_gpio, HRDATA_uart, HRDATA_pixpos, HRDATA_spi,HRDATA_led;
    wire        HREADYOUT_rom, HREADYOUT_ram, HREADYOUT_gpio, HREADYOUT_uart, HREADYOUT_pixpos, HREADYOUT_spi,HREADYOUT_led;

// ======================== Other Interconnecting Signals =======================
    wire        PLL_locked;     // from clock generator, indicates clock is running
    wire        resetHW;        // reset signal for hardware, not on bus
    wire        HIGH_PLL_locked;// lock of high clock pll
    wire        CPUreset, CPUlockup, CPUsleep;       // status signals 
    wire        ROMload;        // rom loader active
    wire [3:0]  muxSel;         // from address decoder to control multiplexer
    wire [4:0]  buttons = {btnU, btnD, btnL, btnC, btnR};   // concatenate 5 pushbuttons

// Wires and multiplexer to drive LEDs from two different sources - needed for ROM loader
    wire [11:0] led_rom;        // status output from ROM loader
    wire [15:0] led_gpio;       // led output from GPIO block
    assign led = ROMload ? {4'b0,led_rom} : led_gpio;    // choose which to display

// Define Cortex-M0 DesignStart processor signals (not part of AHB Lite)
    wire 		RXEV, TXEV;  // event signals
    wire        NMI;        // non-maskable interrupt
    wire [15:0]	IRQ;        // interrupt signals
    wire        SYSRESETREQ;    // processor reset request output
 
// ======================== Clock Generator ======================================
// Generates 50 MHz bus clock from 100 MHz input clock
// Instantiate clock management module
    clock_gen clockGen (
        .clk_in1(clk),        // 100 MHz input clock
        .clk_out1(HCLK),      // 50 MHz output clock for AHB and other hardware
        .clk_out2(VGACLK),    // 108 MHz output clock for VGA sync
        .locked(PLL_locked),   // locked indicator
        .locked_high(HIGH_PLL_locked) // high clock locked indicator
        );

// ======================== Reset Generator ======================================
// Asserts hardware reset until PLL locked, also if reset button pressed.
// Asserts CPU and bus reset to meet Cortex-M0 requirements, also if ROM loader active
// Instantiate reset generator module    
    reset_gen resetGen (
        .clk            (HCLK),         // works on system bus clock
        .resetPBn       (btnCpuReset),  // signal from CPU reset pushbutton
        .pll_lock       (PLL_locked),   // from clock management PLL
        .loader_active  (ROMload),      // from ROM loader hardware
        .cpu_request    (SYSRESETREQ),  // from CPU, requesting reset
        .resetHW        (resetHW),      // hardware reset output, active high
        .resetCPUn      (HRESETn),      // CPU and bus reset, active low
        .resetLED       (CPUreset)      // status signal for indicator LED
        );
        
// ======================== Status Indicator ======================================
// Drives multi-colour LEDs to indicate status of processor and ROM loader.
// Instantiate status indicator module    
    status_ind statusInd (
        .clk            (HCLK),         // works on system bus clock
        .reset          (resetHW),       // hardware reset signal
        .statusIn       ({CPUreset, CPUlockup, CPUsleep, ROMload}),      // status inputs
        .rgbLED         (rgbLED)      // output signals for colour LEDs
        );

// ======================== Processor ========================================
    
// Set processor inputs to safe values
    assign RXEV = 1'b0;
    assign NMI = 1'b0;
    assign HRESP = 1'b0;    // no slaves use this signal yet

// Connect appropriate bits of IRQ to any interrupt signals used, others 0
    assign IRQ[0] = 1'b0;     // no interrupts in use yet, so all 0
    assign IRQ[15:2] = 14'b0;

// Instantiate Cortex-M0 DesignStart processor and connect signals 
    CORTEXM0DS cpu (
        .HCLK       (HCLK),
        .HRESETn    (HRESETn), 
        // Outputs to bus
        .HWDATA      (HWDATA), 
        .HADDR       (HADDR), 
        .HWRITE      (HWRITE), 
        .HTRANS      (HTRANS), 
        .HPROT       (HPROT),
        .HSIZE       (HSIZE),
        .HMASTLOCK   (),        // not used, not connected
        .HBURST      (),        // not used, not connected
        // Inputs from bus	
        .HRDATA      (HRDATA),			
        .HREADY      (HREADY),					
        .HRESP       (HRESP),					
        // Other signals
        .NMI         (NMI),
        .IRQ         (IRQ),
        .TXEV        (TXEV),
        .RXEV        (RXEV),
        .SYSRESETREQ (SYSRESETREQ),
        .LOCKUP      (CPUlockup),   // CPU is in lockup state
        .SLEEPING    (CPUsleep)     // CPU sleeping, waiting for interrupt
        );

// ======================== Address Decoder ======================================
// Implements address map, generates slave select signals and controls mux      
    AHBDCD decode (
        .HADDR      (HADDR),        // address in
        .HSEL_S0    (HSEL_rom),     // ten slave select lines out
        .HSEL_S1    (HSEL_ram),
        .HSEL_S2    (HSEL_gpio),
        .HSEL_S3    (HSEL_uart),
        .HSEL_S4    (HSEL_pixpos),
        .HSEL_S5    (HSEL_spi),
        .HSEL_S6    (HSEL_led),
        .HSEL_S7    (),
        .HSEL_S8    (),
        .HSEL_S9    (),
        .HSEL_NOMAP (),             // indicates invalid address selected
        .MUX_SEL    (muxSel)        // multiplexer control signal out
        );

// ======================== Multiplexer ======================================
// Selects appropriate slave output signals to pass to master      
    AHBMUX mux (
        .HCLK           (HCLK),             // bus clock and reset
        .HRESETn        (HRESETn),
        .MUX_SEL        (muxSel[3:0]),     // control from address decoder

        .HRDATA_S0      (HRDATA_rom),       // ten read data inputs from slaves
        .HRDATA_S1      (HRDATA_ram),
        .HRDATA_S2      (HRDATA_gpio),
        .HRDATA_S3      (HRDATA_uart),
        .HRDATA_S4      (HRDATA_pixpos),
        .HRDATA_S5      (HRDATA_spi),
        .HRDATA_S6      (HRDATA_led),
        .HRDATA_S7      (BAD_DATA),
        .HRDATA_S8      (BAD_DATA),
        .HRDATA_S9      (BAD_DATA),
        .HRDATA_NOMAP   (BAD_DATA),
        .HRDATA         (HRDATA),           // read data output to master
         
        .HREADYOUT_S0   (HREADYOUT_rom),    // ten ready signals from slaves
        .HREADYOUT_S1   (HREADYOUT_ram),
        .HREADYOUT_S2   (HREADYOUT_gpio),
        .HREADYOUT_S3   (HREADYOUT_uart),             
        .HREADYOUT_S4   (HREADYOUT_pixpos),
        .HREADYOUT_S5   (HREADYOUT_spi),
        .HREADYOUT_S6   (HREADYOUT_led),    
        .HREADYOUT_S7   (1'b1),              // unused inputs tied to 1
        .HREADYOUT_S8   (1'b1),
        .HREADYOUT_S9   (1'b1),
        .HREADYOUT_NOMAP(1'b1),
        .HREADY         (HREADY)            // ready output to master and all slaves
        );


// ======================== Slaves on AHB Lite Bus ======================================

// ======================== Program store - block RAM with loader interface ==============
    AHBprom ROM (
        // bus interface
        .HCLK           (HCLK),             // bus clock
        .HRESETn        (HRESETn),          // bus reset, active low
        .HSEL           (HSEL_rom),         // selects this slave
        .HREADY         (HREADY),           // indicates previous transaction completing
        .HADDR          (HADDR),            // address
        .HTRANS         (HTRANS),           // transaction type (only bit 1 used)
        .HRDATA         (HRDATA_rom),       // read data 
        .HREADYOUT      (HREADYOUT_rom),    // ready output
        // Loader connections
        .resetHW        (resetHW),			// hardware reset
        .loadButton     (btnU),		   // pushbutton to activate loader
        .serialRx	    (RsRx),         // serial input
        .status         (led_rom),      // 12-bit word count for display on LEDs
        .ROMload        (ROMload)			// loader active
        );

// ======================== Block RAM ======================================

    AHBbram RAM (
			.HCLK           (HCLK),				// bus clock
			.HRESETn        (HRESETn),          // bus reset, active low
            .HSEL           (HSEL_ram), 		// selects this slave
			.HREADY         (HREADY),           // indicates previous transaction completing
            .HADDR          (HADDR),            // address
            .HTRANS         (HTRANS), 
			.HWRITE         (HWRITE),			// write transaction
			.HSIZE          (HSIZE),		    // transaction width (max 32-bit supported)
			.HWDATA         (HWDATA),	        // write data
			.HRDATA         (HRDATA_ram),	    // read data from slave
			.HREADYOUT      (HREADYOUT_ram) 	// ready output from slave
    );

// ======================== Block GPIO ======================================

    AHBgpio GPIO (
			// Bus signals
			.HCLK            (HCLK),            // bus clock
			.HRESETn         (HRESETn),		    // bus reset, active low
			.HSEL            (HSEL_gpio),	    // selects this slave
			.HREADY          (HREADY),		    // indicates previous transaction completing
			.HADDR           (HADDR),	        // address
			.HTRANS          (HTRANS),	        // transaction type (only bit 1 used)
			.HWRITE          (HWRITE),	        // write transaction
			.HSIZE           (HSIZE),		    // transaction width (max 32-bit supported)
			.HWDATA          (HWDATA),	        // write data
			.HRDATA          (HRDATA_gpio),	    // read data from slave
			.HREADYOUT       (HREADYOUT_gpio),	// ready output from slave
			// GPIO signals
			.gpio_out0       (led_gpio),	    // read-write address 0
			.gpio_out1       (),	            // read-write address 4 NC
			.gpio_in0        (sw),		        // read only address 8
			.gpio_in1        ({11'b0, buttons})	// read only address C
    );
    
// ======================== Block UART ======================================

    AHBuart2 UART (
                // Bus signals
                .HCLK        (HCLK),            // bus clock
                .HRESETn     (HRESETn),         // bus reset, active low
                .HSEL        (HSEL_uart),       // selects this slave
                .HREADY      (HREADY),          // indicates previous transaction completing
                .HADDR       (HADDR),           // address
                .HTRANS      (HTRANS),          // transaction type (only bit 1 used)
                .HWRITE      (HWRITE),          // write transaction
                .HWDATA      (HWDATA),          // write data
                .HRDATA      (HRDATA_uart),     // read data from slave
                .HREADYOUT   (HREADYOUT_uart),  // ready output from slave
                // UART signals
                .serialRx    (RsRx),            // serial receive, idles at 1
                .serialTx    (RsTx),            // serial transmit, idles at 1
                .uart_IRQ    (IRQ[1])           // interrupt request
    );
    
// =========================== BLOCK VGA =====================================
    
    wire vga_async_reset, hdisp, vdisp, sw_ctrl;
    wire [10:0] hpix, vpix, posx, posy, posz;
    wire [11:0] background_c, point_c;
    assign vga_async_reset = ~btnCpuReset | ~HIGH_PLL_locked;
    
    vga_sync vga_sync(
            .CLK(VGACLK),                
            .RESET(vga_async_reset),
            .hsync_out(Hsync),
            .vsync_out(Vsync),
            .hdisp_out(hdisp),    // horizontal display out
            .vdisp_out(vdisp),    // vertical display out
            .hpix(hpix),  // horizontal pixel counter
            .vpix(vpix)  // vertical pixel counter
            );

    vga_pixels vga_pixels(
            .CLK(VGACLK),            // clock, 108 MHz
            .RESET(vga_async_reset), // reset, active high
            .hdisp(hdisp),    // horizontal display out
            .vdisp(vdisp),    // vertical display out
            .xpos(posx),    // x position of square
            .ypos(posy),    // y position of square
            .zpos(posz),    // z position of square
            .sw_ctrl(sw_ctrl),  // switch control for colour
            .background(background_c),  // background colour
            .point(point_c),    // point colour
            .hpix(hpix),  // horizontal pixel counter
            .vpix(vpix),  // vertical pixel counter
            .vgaRed(vgaRed),    // red signal
            .vgaGreen(vgaGreen),  // green signal
            .vgaBlue(vgaBlue),    // blue signal
            .sw(sw[11:0])
        );
    
    AHBpixpos pixpos (
            // Bus signals
            .HCLK            (HCLK),             // bus clock
            .HRESETn         (HRESETn),          // bus reset, active low
            .HSEL            (HSEL_pixpos),      // selects this slave
            .HREADY          (HREADY),           // indicates previous transaction completing
            .HADDR           (HADDR),            // address
            .HTRANS          (HTRANS),           // transaction type (only bit 1 used)
            .HWRITE          (HWRITE),           // write transaction
            .HWDATA          (HWDATA),           // write data
            .HRDATA          (HRDATA_pixpos),    // read data from slave
            .HREADYOUT       (HREADYOUT_pixpos), // ready output from slave
            // pixpos signals
            .posx(posx),                        // x position for point
            .posy(posy),                        // y position for point
            .posz(posz),                        // z position for point
            .background(background_c),          // background colour
            .point(point_c),                    // point colour
            .sw_ctrl(sw_ctrl)                   // switch control for colour
    );
    
    //================ SPI ====================================
    AHBSpi spi (
            // Bus signals
            .HCLK(HCLK),            // bus clock
            .HRESETn(HRESETn),      // bus reset, active low
            .HSEL(HSEL_spi),        // selects this slave
            .HREADY(HREADY),        // indicates previous transaction completing
            .HADDR(HADDR),          // address
            .HTRANS(HTRANS),        // transaction type (only bit 1 used)
            .HWRITE(HWRITE),        // write transaction
            .HWDATA(HWDATA),        // write data
            .HRDATA(HRDATA_spi),    // read data from slave
            .HREADYOUT(HREADYOUT_spi),// ready output from slave

            // ====== SPI STUFF ======
            .MISO(aclMISO),
            .MOSI(aclMOSI),
            .CS(aclSS),
            .SCLK(aclSCK)
    );
			
 //================ LED ====================================
     AHBLed2  LEDSEG (
            // Bus signals
            .HCLK(HCLK),            // bus clock
            .HRESETn(HRESETn),      // bus reset, active low
            .HSEL(HSEL_led),        // selects this slave
            .HREADY(HREADY),        // indicates previous transaction completing
            .HADDR(HADDR),    		// address
            .HTRANS(HTRANS),    	// transaction type (only bit 1 used)
            .HWRITE(HWRITE),        // write transaction
            .HWDATA(HWDATA),   	    // write data
            .HRDATA(HRDATA_led),    // read data from slave
            .HREADYOUT(HREADYOUT_led),  // ready output from slave

            // ====== LED   STUFF ======
            .Seg_display({seg,dp}),  // bits for seg and decimal point of each digit
            .digit(an)				 // digit switches
    );
endmodule
