#ifndef DISPLAY_8DIGIT_HEADER
	#define DISPLAY_8DIGIT_HEADER
	
	#include "types.h"
	
	#define ISPI_P 	(7)
	#define WCOL_P 	(6)
	#define SPE_P 	(5)
	#define SPIM_P	(4)
	#define CPOL_P	(3)
	#define CPHA_P	(2)
	#define SPR_P		(0)
	#define ESI_POS (0)      //********
	
	#define NUM_DIGITS 8
	
	#define SHUTDOWN_REG 12 	  // 0 (off, DIGITS are Blank) or 1 (on)
	#define SCAN_LIMIT_REG 11   // 0 - 7 (rightmost - leftmost)
	#define INTENSITY_REG 10 	  // 0 - 15(brightness: min - max)
	#define DECODE_REG 9			  // 0 direct, 1 translate
	#define DISP_TEST_REG 15 		// 0 for normal operation, 1 for all on
	#define LOAD_PIN P3
	#define LOAD_PIN_ON 0x80 	  // P3.7
	#define	LOAD_PIN_OFF 0x7F   // and LOAD goes high for accepting new data
	
	#define ON	1
	#define OFF 0
	
	#define DIG8_MAX 0x5F5E0FF // maximum value that 8 digits can have
	
	#define NO_DECIMAL -1  //********
	#define DASH 10
	#define DECIMAL_POINT 0x80
	#define BLANK 15
	
	// delay for spi purposes
	void delay_spi();
	
	// write to the spi bus for the display
	void write_dispi(uint8 reg, uint8 mdata);
	
	// initialise the display
	void init_8display();
	
	// write 32 bit value and decimal point to display
	void write_8display(uint32 mdata, int8 decimal);

#endif