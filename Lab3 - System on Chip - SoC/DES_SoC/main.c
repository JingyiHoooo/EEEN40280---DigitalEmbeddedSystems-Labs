// program for SOC design lab

//---------------------------------------------------------------------------//
//	PREAMBLE
//---------------------------------------------------------------------------//

#include <stdio.h>
#include "DES_M0_SoC.h"

#define SCREEN_W            1280 // screen height
#define SCREEN_H            1024 // screen width
#define Z_MAX								500 // maximum z value
#define Z_MIN								5 	// minimum z value
#define REPORT_HZ           1 // cube attribute updates per second
#define UPDATE_HZ           2000 // frames per second approx
#define UPDATE_INTERVAL     (UPDATE_HZ/REPORT_HZ) // number of loops per output
#define SCALING 						1000
#define TAU  								0.025 //coefficient  for IIR
#define nLOOPS_per_DELAY		20

#define BUF_SIZE						100
#define ASCII_CR						'\r'
#define CASE_BIT						('A' ^ 'a')

//Struct to represent a 3 dimensional vector (int16)
typedef struct{
		int16 x;
		int16 y;
		int16 z;
} Vector_int;

//Struct to represent a 3 dimensional vector (float)
typedef struct{
		float x;
		float y;
		float z;
} Vector_float;

#define ARRAY_SIZE(__x__)       (sizeof(__x__)/sizeof(__x__[0]))

volatile uint8  counter  = 0; // current number of char received on UART currently in RxBuf[]
volatile uint8  BufReady = 0; // Flag to indicate if there is a sentence worth of data in RxBuf
volatile uint8  RxBuf[BUF_SIZE];

//////////////////////////////////////////////////////////////////
// Interrupt service routine, runs when UART interrupt occurs - see cm0dsasm.s
//////////////////////////////////////////////////////////////////
void UART_ISR()
{
	char c;
	c = pt2UART->RxData;	 // read a character from UART - interrupt only occurs when character waiting
	RxBuf[counter]  = c;   // Store in buffer
	counter++;             // Increment counter to indicate that there is now 1 more character in buffer
	pt2UART->TxData = c;   // write (echo) the character to UART (assuming transmit queue not full!)

	if (counter == BUF_SIZE-1 || c == ASCII_CR)  {
		counter--;							// decrement counter (CR will be over-written)
		RxBuf[counter] = NULL;  // Null terminate
		BufReady       = 1;	    // Indicate to rest of code that a full "sentence" has being received (and is in RxBuf)
	}
}

//---------------------------------------------------------------------------//
//	FUNCTION DEFINITIONS
//---------------------------------------------------------------------------//

//////////////////////////////////////////////////////////////////
// Software delay
//////////////////////////////////////////////////////////////////
void wait_n_loops(uint32 n) {
	volatile uint32 i;
		for(i=0;i<n;i++);
}

// //////////////////////////////////////////////////////////////////
// // SPI Input Output
// //////////////////////////////////////////////////////////////////
void writeSPI(uint8 data) {
	pt2SPI->write = data;
	while(!ISPI);
}

uint8 readSPI() {
	uint8 val = pt2SPI->read;
	return val;
}


// //////////////////////////////////////////////////////////////////
// // Accelerometer SPI wrappers
// //////////////////////////////////////////////////////////////////
void writeAccelerometer(uint8 address, uint8 d_byte) {
	AC_CS = 1; 					//ensure chip select is released
	AC_CS = 0; 					//accelerometer chip select
	writeSPI(0x0A); 		//tell acclerometer we want to write to it
	writeSPI(address); 	//tell acclerometer the register we want to write to
	writeSPI(d_byte); 	//write the data to the accelerometer
	AC_CS = 1; 					//release chip select
}

uint8 readAccelerometer(uint8 address) {
	AC_CS = 1; 					//ensure chip select is released
	AC_CS = 0; 					//accelerometer chip select
	writeSPI(0x0B); 		//tell acclerometer we want to read from it
	writeSPI(address); 	//tell acclerometer the register we want to read
	writeSPI(0xFF);
	AC_CS = 1; 					//release chip select

	return readSPI(); 	//return value read from SPI
}

// //////////////////////////////////////////////////////////////////
// // Interpret Input from Switches
// //////////////////////////////////////////////////////////////////

void update_from_switches(uint16 switches, uint16* range,
													uint16* sensitivity, uint16* pause_sw){
	//bits are shifted to their relevant final positions then OR'd together
	uint16 bg_r = (switches & 0xE000) >> 4; //Switches[15:13]
	uint16 bg_g = (switches & 0x1C00) >> 5; //Switches[12:10]
	uint16 bg_b = (switches & 0x0380) >> 6; //Switches[9:7]

	uint16 cube_r = (switches & 0x0040) ? 0x0F00 : 0x0000; //Switches[6]
  uint16 cube_g = (switches & 0x0020) ? 0x00F0 : 0x0000; //Switches[5]
	uint16 cube_b = (switches & 0x0010) ? 0x000F : 0x0000; //Switches[4]

	pt2VGA->background = 0x0000 | bg_r | bg_g | bg_b; //bg_rgb
	pt2VGA->point = 0x0000 | cube_r | cube_g | cube_b; //cube_rgb

	switch(switches&0x000E){ //Switches[3:1]
		// SET ACCEL SENSITIVITY, 8gx1 low,
		//LV1 +-8g, sensitivity = 1x
		case 0x0000:	*range=0x0003; *sensitivity = 1; break;
		//LV2 +-8g, sensitivity = 2x
		case 0x0002:	*range=0x0003; *sensitivity = 2; break;

		//LV3 +-4g, sensitivity = 1x
		case 0x0004:	*range=0x0001; *sensitivity = 1; break;
		//LV4 +-4g, sensitivity = 2x
		case 0x0006:	*range=0x0001; *sensitivity = 2; break;

		//LV5 +-2g, sensitivity = 1x
		case 0x0008:	*range=0x0000; *sensitivity = 1; break;
		//LV6 +-2g, sensitivity = 2x
		default:		  *range=0x0000; *sensitivity = 1; break;
	}

	*pause_sw = switches&0x0001; //Switches[0]
}

//////////////////////////////////////////////////////////////////
// Accelerometer Setup
//////////////////////////////////////////////////////////////////
void configureAccelerometer(Vector_int* offset){
	writeAccelerometer(0x2C, 0x12); // set to 50hz ODR and +-2g RANGE
	writeAccelerometer(0x2D, 0x02); //set to measurement mode
	//other registers remain default

	//offset zeros the final Accelerometer output, assumes board is flat on desk
	offset->x = (readAccelerometer(0x11)<<8)+readAccelerometer(0x10);
	offset->y = (readAccelerometer(0x0F)<<8)+readAccelerometer(0x0E);
	offset->z = (readAccelerometer(0x13)<<8)+readAccelerometer(0x12);
}
//---------------------------------------------------------------------------//
//	MAIN
//---------------------------------------------------------------------------//
int main(void) {
	uint16 sensitivity = 1, range, pause_sw; //scales the accel value from accelerometer
  uint16 i = 0; //loop counter
	uint16 cube_width = 3; //
	uint16 temperature; //temperature of accelerometer
	uint32 hextemp; //value written out to 7 Segment Displays
	uint8 hexcount; //counter to increment through digits of the display

	Vector_int offset;
	Vector_int ACC;
	Vector_int ACC_new;
	Vector_float POS;

  // initialise acceleration values from sensor to zero
	ACC.x=0;
	ACC.y=0;
	ACC.z=0;

  // initialise cube position to centre of screen and size to 5 pixels
  POS.x=0.5*SCREEN_W;
	POS.y=0.5*SCREEN_H;
	POS.z=5;

	pt2VGA->sw_ctrl = 0; // let software control the colours

	wait_n_loops(nLOOPS_per_DELAY);						// wait a little
	printf("\r\nWelcome to BALANCE\r\n");			// output welcome message

	configureAccelerometer(&offset);

	while(1){			// loop forever

		//read from switches, interpret and write appropriate values to registers
		update_from_switches(pt2GPIO->Switches, &range, &sensitivity, &pause_sw);

    // set measurement range, RANGE | ODR
    writeAccelerometer(0x2C,((uint8)range>>6)|0x12);

		// delay while new measurements are taken
		wait_n_loops(nLOOPS_per_DELAY);

		if(pause_sw == 0){ //make sure we're not in a pause state
			// get sensor readings, upper 8 bits (*DATacc_H) bitshifted 8 places + lower 4 bits (*DATacc_L)
			ACC_new.x = -((readAccelerometer(0x11)<<8)+readAccelerometer(0x10)-offset.x)*sensitivity;
			ACC_new.y = ((readAccelerometer(0x0F)<<8)+readAccelerometer(0x0E)-offset.y)*sensitivity;
			ACC_new.z = ((readAccelerometer(0x13)<<8)+readAccelerometer(0x12)-offset.z)*sensitivity;


			// IIR Filter
			ACC.x = ACC.x*(1-TAU) + TAU*(ACC_new.x);
			ACC.y = ACC.y*(1-TAU) + TAU*(ACC_new.y);
			ACC.z = ACC.z*(1-TAU) + TAU*(ACC_new.z);

			// Position denotes acceleration in direction. Due to gravity or movement of board
			POS.x = ACC.x + SCREEN_W / 2;
			POS.y = ACC.y + SCREEN_H / 2;
			POS.z = ACC.z + Z_MAX / 2; // represeneted as size of cube on output

			cube_width = POS.z/2;

			// Limit position
	    if (POS.x+cube_width > SCREEN_W){ //stop cube going off right of screen
	      POS.x=SCREEN_W-cube_width;
	    }
	    if (POS.x+cube_width < 0){ //stop cube going off left of screen
	      POS.x=0+cube_width;
	    }
	    if (POS.y+cube_width > SCREEN_H){ //stop cube going off top of screen
	      POS.y=SCREEN_H-cube_width;
	    }
	    if (POS.y+cube_width < 0){ //stop cube going off bottom of screen
	      POS.y=0+cube_width;
	    }

			// Limit cube size
			if (POS.z > Z_MAX){ // max_size = 500
				POS.z=Z_MAX;
			}
			if (POS.z < Z_MIN){ // min_size = 5
				POS.z=Z_MIN;
			}

			//update user output every "UPDATE_INTERVAL" Loops, not neccessary to run as fast as possible
	    if(i>=UPDATE_INTERVAL){
	       printf("Acceleration, ACC.x: %d, \tACC.y: %d, \tACC.z: %d, \r\n",ACC.x, ACC.y, ACC.z
	       printf("Position, POS.x: %f, \tPOS.y: %f, \tPOS.z: %f, \r\n",POS.x, POS.y, POS.z);
				i=0;

				//read temperature from VGA
				 temperature = (readAccelerometer(0x15)<<8)+readAccelerometer(0x14);

				//determine digit values
				 hextemp = 0;
				 hexcount = 0;
				 while(temperature != 0) {
					 hextemp += (temperature % 10) << (hexcount * 4);
					 hexcount++;
					 temperature /= 10;
				 }

				 //create single hexadecimal output
				 while(hexcount < 8) {
					 hextemp += (0xF << (hexcount * 4));
					 hexcount++;
				 }

				//push hexadecimal output to 7 Segment Display
				 pt2SEG->number = hextemp;

				 //print to screen
				 printf("Temperature, %x\r\n",	hextemp);
			}
			else{
				i++;
			}

			// cast positions to discrete pixel values (ints) and write to VGA registers
			pt2VGA->xpos = (uint16)POS.x;
			pt2VGA->ypos = (uint16)POS.y;
			pt2VGA->zpos = (uint16)POS.z;
    }
  }
}
