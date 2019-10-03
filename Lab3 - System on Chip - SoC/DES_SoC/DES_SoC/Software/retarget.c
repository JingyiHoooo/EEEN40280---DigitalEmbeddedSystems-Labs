
#include <stdio.h>
#include "DES_M0_SoC.h"

#pragma import(__use_no_semihosting)

struct __FILE { 
	unsigned char * ptr;
	};

FILE __stdout = 	{(unsigned char *)&pt2UART->TxData};
FILE __stdin = 		{(unsigned char *)&pt2UART->RxData};
/* Suggested solution
struct __FILE { int handle;} ;

FILE __stdout;
FILE __stdin;
FILE __stderr;
*/

int uart_out(int ch)
{
	while((pt2UART->Status & (1<<UART_TX_FIFO_FULL_BIT_POS)))	{
		;	// Wait until uart ready
	}
	pt2UART->TxData = (char)ch;
	return(ch);
}


int fputc(int ch, FILE *f)
{
  return(uart_out(ch)); 
}

int fgetc(FILE *f)
{ 
	return 0;
}

int ferror(FILE *f)
{
  return 0; 
}

void _sys_exit(void) {
	printf("\nTEST DONE\n");
	while(1); 
}

