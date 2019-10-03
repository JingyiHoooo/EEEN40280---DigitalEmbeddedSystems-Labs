#include "frequency.h"
#include <ADUC841.h>

// output of the interrupt vector
	uint32 measured_frequency;
	bit measurement_ready;
	bit low_freq_measurement;

	// set up the values for low frequency measurements
	void set_up_lowfreq() {
		low_freq_measurement = 1;
				
		// set up for 128 total cycles
		measured_frequency = (TIMER_UPPER_LIMIT - LOWER_EDGE_LIMIT + measured_frequency);
		TH1 = measured_frequency >> 8;
		TL1 = measured_frequency;
		
		measured_frequency = 1;
		
		// let timers run again
		TCON =
			(0 << TF1_P) |
			(1 << TR1_P) |
			(0 << TF0_P) |
			(1 << TR0_P);
	}
	
	// make the measurement if time limit runs out
	void timeout_measurement() {
		TCON = 0;
				
		measured_frequency = LOWER_EDGE_LIMIT - (TIMER_UPPER_LIMIT - ((TH1 << 8) | TL1));
		measured_frequency >>= 2; // divide by 4 to get the actual frequency
		
		measurement_ready = 1;
	}
	
	// calculates the frequency given both timer values (f_counter<f_timer)
	void calculate_frequency() interrupt 1 { // Timer 0 (0x000B)interrupt occurs when overflow
		if(!low_freq_measurement) { // if a high frequency measurement
			TCON = 0;
			
			measured_frequency = (TH1 << 8) | TL1;
			
			// calculate frequency
			if(measured_frequency >= LOWER_EDGE_LIMIT) {
				measured_frequency = (measured_frequency << 16) / CLOCK_FREQ_DIVISOR;
				measurement_ready = 1;
			}
			else // otherwise start low frequency measurement
				set_up_lowfreq();
		}
		else { // if a low frequency measurement
			measured_frequency++;
			
			if(measured_frequency == TIME_LIMIT_MULT) {
				timeout_measurement();
			}
		}
	}
	
	// calculates the frequency in case of a counter overflow (LOWER_EDGE_LIMIT reached)
	void overflow_frequency() interrupt 3 { // Timer 1 (0x001B)interrupt occours when overflow
		TCON = 0;   // Turn off Timer 0&1
		
		measured_frequency *= TIMER_UPPER_LIMIT;
		measured_frequency += (TH0 << 8) | TL0; // Timing value of Timer 0
		measured_frequency = (CLOCK_FREQUENCY * LOWER_EDGE_LIMIT) / measured_frequency;
		
		measurement_ready = 1;
	}
	
	// get the frequency of the input signal
	uint32 get_frequency() {
		// set timer modes
		TMOD =
			(0 << T1GATE_P) |  // Gate control, enable timer 1 when TR1 bit is set
			(1 << T1CT_P) |    // select counter operation
			(1 << T1MODE_P) |  // 16-bit counter
			(0 << T0GATE_P) |  //
			(0 << T0CT_P) |    // select Ti r operation
			(1 << T0MODE_P);   // 16-bit Timer
		
		// enable all interrupts (IE SFR Bit)
		EA = 1;
		ET0 = 1;
		ET1 = 1;
		
		// reset all timers
		
		// High byte of Timer 0&1
		TH0 = 0;
		TH1 = 0;
		// Low byte of Timer 0&1
		TL0 = 0;
		TL1 = 0;
		
		measurement_ready = 0;
		low_freq_measurement = 0;
		
		// let timers run
		TCON =
			(0 << TF1_P) | // Counter 1 overflow flag is 0 in the beginning
			(1 << TR1_P) | // Time 1 starts counting
			(0 << TF0_P) | // Timer 0 overflow flag is 0 in the beginning
			(1 << TR0_P);  // Timer 0 starts Timing
		
		while(!measurement_ready);
		
		return measured_frequency;
	}
	