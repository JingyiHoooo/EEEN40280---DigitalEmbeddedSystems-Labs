#include <ADUC841.H>
#include "switch.h"
#include "display_8d.h"
#include "adc.h"

void main() {
	uint16 j;
	init_8display();
	setup_adc();

	while(1) {
		for(j = 0; j < 10000; j++);
		get_mode();
	}
}