#include "switch.h"
#include <ADUC841.h>

  void get_mode(){
	  uint8 mode;
		uint32 measurement;
		//SWITCH_PORT = SWITCH_PORT_MASK;
		SWITCH_PORT = 3;
		mode = SWITCH_PORT & SWITCH_PORT_MASK;
		
		//setup hardware based on new mode
		switch(mode){	
			case DC_MODE:
				// measure DC voltage
				measurement = measure_dc();
				write_8display(measurement, 6);
				break;
				
			case RMS_MODE:
				// measure RMS
				measurement = measure_rms();
				write_8display(measurement, 6);
				break;
				
			case PEAK_MODE: 
				// measure Peak Value
				measurement = measure_peak();
				write_8display(measurement, 6);
				break;
				
			case FREQUENCY_MODE:
				measurement = get_frequency(); // measure signal frequency
				write_8display(measurement, NO_DECIMAL);
				break;
		}
	}