#include "adc.h"
#include <ADUC841.h>

uint32 const ADC_UNIT_LEVEL = 610; // one level of ADC is 0.61035 mV = 2.5/2^12

uint8 MEASUREMENT_MODE;
bit sum_ready;
uint8 sum_pointer;

uint32 dc_average;
uint32 rms_average;

// interrupt routine
void adc() interrupt 6 {
	uint16 adc_value = ((ADCDATAH & HIGH_BYTE_MASK) << 8) | ADCDATAL; //0X00| 00XX = 0XXX
	
	dc_average += adc_value;
	
	if(MEASUREMENT_MODE == MEASURE_RMS) //0x01
		rms_average += (uint32) adc_value * adc_value;
	
	sum_pointer++;
	
	if((sum_pointer - 1) == ((1 << SAMPLE_SHIFT)) - 1) //1000 0000
		sum_ready = 1;
}

// get square root of uin32 value
uint16 sqrt(uint32 value) {
	uint32 temp;
	uint16 square_root = 0x8000; //middle point value
	uint8 counter;
	
	// go through all 16 possible bisection method
	

	for(counter = 16; counter > 0; counter--) {
		temp = (uint32) square_root * square_root;
		                                         
		if(temp > value) // if too big, go down     
			square_root ^= (1 << counter);        
		else if(temp == value) // early exit
			return square_root;
		
		// add next bit
		square_root |= (1 << (counter - 1)); // for example 1000 0000 0000 0000 > value, sqr = 0100 0000 0000 0000;
		                                     // but if it is smaller, sqr = 1100 0000 0000 0000
	}
	// sqr by last loop round will not be examinated, therefore,
	// check whether the last bit makes it closer or not (precision determination)
	temp = (uint32) square_root * square_root;
	if(temp > value) {
			if((temp - value) > ((uint32) (square_root - 1) * (square_root - 1) - value))
				square_root ^= 1;     //if yes, sqr-1 got more closer value
			                        // otherwise, temp is more precise
	}
	
	return square_root;
}

// set up the SFRs for the ADC
void setup_adc() {
	EADC = 1;  // enable ADC interrupts
	EA = 1;    // enable all interrupt sources
	
	// 17 cycles minimum for acquisition
	ADCCON1 = 
		(1 << MD1_P) | // power up
		(0 << REF_P) | // internal reference
		(3 << DIV_P) | // division by 2, 32 - 2
		(2 << ACQ_P) | // 1 clock to acquire, 1 - 4
		(1 << T2C_P) | // enable Timer2 overflow bit
		(0 << EXC_P);  // disable external interrupt
}

// set up timer2 to interrupt at particular frequency
void setup_timer2(uint32 frequency) {
	if(frequency > ADC_FREQ_LIM)      //81.317kHz
		frequency = ADC_FREQ_LIM;
	
	if(frequency < ADC_LFREQ_LIM)
		frequency = ADC_LFREQ_LIM;
		
	frequency <<= 2;
	
	T2CON = 0; //POWER ON default
	
	frequency = ADUC_CLOCK / frequency;
	frequency = COUNTER_16_MAX - frequency;
	
	RCAP2H = frequency >> 8;
	RCAP2L = frequency;//
}

// start timer2
void start_timer2() {
	// reset all values for the adc
	sum_ready = 0;
	sum_pointer = 0;
	dc_average = 0;
	rms_average = 0;
	
	EADC = 1;
	T2CON =
			(0 << TF2_P) |  // overflow flag
			(1 << TR2_P) |  // start timer2
			(0 << CNT2_P) | // timer function
			(0 << CAP2_P);   // enable reloads after overflow
}

// wait for all measurements to complete
void await_measurement() {
	while(!sum_ready);  //sum_ready = 0 do the loop
	
	EADC = 0;
	T2CON = 0;
}

// measures an ac signal
uint32 measure_rms() {
	uint32 freq = get_frequency();
	measure_at_frequency(freq);
	
	dc_average >>= SAMPLE_SHIFT;
	rms_average >>= SAMPLE_SHIFT;
	
	rms_average -= ((uint32) dc_average * dc_average); //**********
	rms_average = sqrt(rms_average) << LEVEL_SHIFT_SCALE;
	
	return rms_average * ADC_UNIT_LEVEL;
}

// measures an ac signal
uint32 measure_peak() {
	uint32 freq = get_frequency();
	measure_at_frequency(freq);
	
	dc_average >>= SAMPLE_SHIFT;
	rms_average >>= SAMPLE_SHIFT;
	
	rms_average -= ((uint32) dc_average * dc_average);
	rms_average = sqrt(rms_average << ROOT_2) << LEVEL_SHIFT_SCALE;
	
	return rms_average * ADC_UNIT_LEVEL;
}

// measures an ac signal at given frequency
void measure_at_frequency(uint32 frequency) {
	setup_timer2(frequency);
	
	MEASUREMENT_MODE = MEASURE_RMS;
	
	ADCCON2 =
		(0 << ADCI_P) | // interrupt
		(0 << DMA_P) |
		(0 << CCONV_P) |
		(0 << SCONV_P) |
		(1 << CHAN_P); // channel select, 0-7, temp, dac0,1, agnd, vref, dmastop
	
	start_timer2();

	await_measurement();
}

// measures a dc voltage at a high frequency
uint32 measure_dc() {
	setup_timer2(ADC_FREQ_LIM >> 5); // go at maxfreq / 32 (arbitrary)
	
	MEASUREMENT_MODE = MEASURE_DC;
	
	ADCCON2 =
		(0 << ADCI_P) | // interrupt
		(0 << DMA_P) |
		(0 << CCONV_P) |
		(0 << SCONV_P) |
		(0 << CHAN_P); // channel select, 0-7, temp, dac0,1, agnd, vref, dmastop
	
	start_timer2();
	
	await_measurement();

	return ((dc_average >> SAMPLE_SHIFT) * ADC_UNIT_LEVEL);
}
