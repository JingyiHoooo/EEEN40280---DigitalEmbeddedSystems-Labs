#ifndef SWITCH_HEADER
	#define SWITCH_HEADER
	
	#include "types.h"
	#include "adc.h"
	#include "frequency.h"
	#include "display_8d.h"
	
  #define SWITCH_PORT  P2			// switches are connected to Port 2
  #define SWITCH_PORT_MASK 0x1	// 0000 0011, only consider switch 1&2

// Switch mode 	parameter setup
	#define DC_MODE 0x0
	#define RMS_MODE 0x1
	#define PEAK_MODE 0x2
	#define FREQUENCY_MODE 0x3
	
// scan the swiches
void get_mode();

#endif