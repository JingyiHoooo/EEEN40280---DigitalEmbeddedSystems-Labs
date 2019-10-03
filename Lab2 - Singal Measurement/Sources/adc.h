#ifndef ADC_HEADER_DEFINITION

	#define ADC_HEADER_DEFINITION
  //ADCCON1
	#define MD1_P (7)
	#define REF_P (6)
	#define DIV_P (4)
	#define ACQ_P (2)
	#define T2C_P	(1)
	#define EXC_P	(0)
  //ADCCON2
	#define ADCI_P 	(7)
	#define DMA_P 	(6)
	#define CCONV_P	(5)
	#define SCONV_P	(4)
	#define CHAN_P	(0)
	//T2CON
	#define TF2_P		(7)
	#define TR2_P		(2)
	#define CNT2_P	(1)
	#define CAP2_P	(0)
	
	#define ADC_FREQ_LIM 81317 // ~= 81.317kHz *****
	#define ADC_LFREQ_LIM 43 // ~= 169/4
	#define COUNTER_16_MAX 65536
	#define ADUC_CLOCK 11059200
	
	#define HIGH_BYTE_MASK 0x0F // mask for the ADC high byte (00001111)
	
	#define SAMPLE_SHIFT	7 // 64 samples
	#define LEVEL_SHIFT_SCALE 1 
	#define ROOT_2 1

	#define MEASURE_DC 0x2
	#define MEASURE_RMS 0x1
	
	#include "types.h"
	#include "frequency.h"
	
	// interrupt routine
	void adc();

	// get square root of uin32 value
	uint16 sqrt(uint32 value);
	
	// set up the SFRs for the ADC
	void setup_adc();
	
	// set up timer2 to interrupt at particular frequency
	void setup_timer2(uint32 frequency);
	
	// start timer2
	void start_timer2();
	
	// wait for all measurements to complete
	void await_measurement();
	
	// measures an ac signal
	uint32 measure_rms();
	
	// measures an ac signal
	uint32 measure_peak();
	
	// measures an ac signal at a particular frequency
	void measure_at_frequency(uint32 frequency);
	
	// measures a dc voltage at a high frequency
	uint32 measure_dc();

#endif