#ifndef FREQUENCY_HEADER

	#define FREQUENCY_HEADER
	
	// Timer 0&1 Settings
	#define T1GATE_P 	(7)
	#define T1CT_P		(6)
	#define T1MODE_P	(4)
	#define T0GATE_P	(3)
	#define T0CT_P		(2)
	#define T0MODE_P	(0)
	
	// TCON settings
	#define TF1_P		(7)
	#define TR1_P		(6)
	#define TF0_P		(5)
	#define TR0_P		(4)
	
	#define CLOCK_FREQ_DIVISOR 0x00000184 // 592 * 1.31072 = 776 (or 388 [0x184] if 0.65536)
	#define OVERFLOW_FREQ_DIVISOR 0x8F0AC000 // 2,399,846,400 (11.0592e6 * 217)
	#define OVERFLOW_FREQ_MULT 302 // 32767/217 = 151 (302 [0x12E] for 65535)
	#define CLOCK_FREQUENCY 11059200
	#define LOWER_EDGE_LIMIT 128
	#define TIMER_UPPER_LIMIT 65535
	#define TIME_LIMIT_MULT 675 // roughly 4 seconds
	
	#include "types.h"

	// set up the values for low frequency measurements
	void set_up_lowfreq();
	
	// make the measurement if time limit runs out
	void timeout_measurement();
		
	// calculates the frequency given both timer values
	void calculate_frequency();
	
	// calculates the frequency in case of a counter overflow
	void overflow_frequency();
	
	// get the frequency of the input signal
	uint32 get_frequency();
	
#endif