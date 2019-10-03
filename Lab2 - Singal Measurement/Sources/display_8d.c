#include "display_8d.h"
#include <ADUC841.H>

//ISPI will indicate a byte has been transmitted (1) or not (0)
// delay for spi purposes
void delay_spi() {
	volatile uint8 wasted;
	while(ISPI == 0);
	      ISPI = 0;
	      wasted = 3;
	      wasted = 0;
	return;
}

// write to the spi bus for the display
void write_dispi(uint8 reg, uint8 mdata) {
	// load to on for accepting new data
	LOAD_PIN |= LOAD_PIN_ON;
	
	// send two sets of 8 bits
	SPIDAT = reg;
	delay_spi();
	
	SPIDAT = mdata;
	delay_spi();
	
	// load to off
	LOAD_PIN &= LOAD_PIN_OFF;
}

// initialise the display
void init_8display() {
	SPICON =
		(0 << ISPI_P) | // interrupt bit
		(0 << WCOL_P) | // Collision Error Bit
		(1 << SPE_P)  | // enable interface
		(1 << SPIM_P) | // master, SCLOCK is an output
		(0 << CPOL_P) | // SCLOCK idle low
		(0 << CPHA_P) | // leading clock edge transmits
		(3 << SPR_P);   // clock rate divisor, 2-16
	
	write_dispi(SCAN_LIMIT_REG, NUM_DIGITS - 1); // all digits allow to display
	write_dispi(INTENSITY_REG, NUM_DIGITS);      // set brightness 8
	write_dispi(DECODE_REG, 0xFF);	// decode ints to patterns on all digits, blank
	write_dispi(DISP_TEST_REG, OFF);// normal operation
	write_dispi(SHUTDOWN_REG, ON);  // ******* normal operation
}

// write 32 bit value and decimal point to display
/////////////////////////////////////////////////////
void write_8display(uint32 mdata, int8 decimal) {
	uint8 tempd = mdata / DIG8_MAX; // will always be less than 255
	
	// truncate the value to the number of digits currently being displayed and add the decimal point

	// stop until get int 0
	while(tempd != 0) {
		mdata /= 10;
		tempd /= 10;
	}
	
	decimal++;
	
	// assign digits to array
	for(tempd = 1; tempd <= NUM_DIGITS; tempd++) {
		if(tempd < decimal) // normal digit or before decimal point
			write_dispi(tempd, mdata % 10);
		else if(tempd == decimal) // decimal point
			write_dispi(tempd, (mdata % 10) | DECIMAL_POINT);
		else if(mdata != 0)
			write_dispi(tempd, mdata % 10);
		else // else blank
			write_dispi(tempd, BLANK);
		
		// next digit
		mdata /= 10;
	}
}