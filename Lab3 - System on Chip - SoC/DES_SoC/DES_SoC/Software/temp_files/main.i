#line 1 "main.c"






#line 1 "C:\\Keil_v4\\ARM\\ARMCC\\bin\\..\\include\\stdio.h"
 
 
 





 






 













#line 38 "C:\\Keil_v4\\ARM\\ARMCC\\bin\\..\\include\\stdio.h"


  
  typedef unsigned int size_t;    








 
 

 
  typedef struct __va_list __va_list;





   




 




typedef struct __fpos_t_struct {
    unsigned __int64 __pos;
    



 
    struct {
        unsigned int __state1, __state2;
    } __mbstate;
} fpos_t;
   


 


   

 

typedef struct __FILE FILE;
   






 

extern FILE __stdin, __stdout, __stderr;
extern FILE *__aeabi_stdin, *__aeabi_stdout, *__aeabi_stderr;

#line 129 "C:\\Keil_v4\\ARM\\ARMCC\\bin\\..\\include\\stdio.h"
    

    

    





     



   


 


   


 

   



 

   


 




   


 





    


 






extern __declspec(__nothrow) int remove(const char *  ) __attribute__((__nonnull__(1)));
   





 
extern __declspec(__nothrow) int rename(const char *  , const char *  ) __attribute__((__nonnull__(1,2)));
   








 
extern __declspec(__nothrow) FILE *tmpfile(void);
   




 
extern __declspec(__nothrow) char *tmpnam(char *  );
   











 

extern __declspec(__nothrow) int fclose(FILE *  ) __attribute__((__nonnull__(1)));
   







 
extern __declspec(__nothrow) int fflush(FILE *  );
   







 
extern __declspec(__nothrow) FILE *fopen(const char * __restrict  ,
                           const char * __restrict  ) __attribute__((__nonnull__(1,2)));
   








































 
extern __declspec(__nothrow) FILE *freopen(const char * __restrict  ,
                    const char * __restrict  ,
                    FILE * __restrict  ) __attribute__((__nonnull__(2,3)));
   








 
extern __declspec(__nothrow) void setbuf(FILE * __restrict  ,
                    char * __restrict  ) __attribute__((__nonnull__(1)));
   




 
extern __declspec(__nothrow) int setvbuf(FILE * __restrict  ,
                   char * __restrict  ,
                   int  , size_t  ) __attribute__((__nonnull__(1)));
   















 
#pragma __printf_args
extern __declspec(__nothrow) int fprintf(FILE * __restrict  ,
                    const char * __restrict  , ...) __attribute__((__nonnull__(1,2)));
   


















 
#pragma __printf_args
extern __declspec(__nothrow) int _fprintf(FILE * __restrict  ,
                     const char * __restrict  , ...) __attribute__((__nonnull__(1,2)));
   



 
#pragma __printf_args
extern __declspec(__nothrow) int printf(const char * __restrict  , ...) __attribute__((__nonnull__(1)));
   




 
#pragma __printf_args
extern __declspec(__nothrow) int _printf(const char * __restrict  , ...) __attribute__((__nonnull__(1)));
   



 
#pragma __printf_args
extern __declspec(__nothrow) int sprintf(char * __restrict  , const char * __restrict  , ...) __attribute__((__nonnull__(1,2)));
   






 
#pragma __printf_args
extern __declspec(__nothrow) int _sprintf(char * __restrict  , const char * __restrict  , ...) __attribute__((__nonnull__(1,2)));
   



 

#pragma __printf_args
extern __declspec(__nothrow) int snprintf(char * __restrict  , size_t  ,
                     const char * __restrict  , ...) __attribute__((__nonnull__(3)));
   















 

#pragma __printf_args
extern __declspec(__nothrow) int _snprintf(char * __restrict  , size_t  ,
                      const char * __restrict  , ...) __attribute__((__nonnull__(3)));
   



 
#pragma __scanf_args
extern __declspec(__nothrow) int fscanf(FILE * __restrict  ,
                    const char * __restrict  , ...) __attribute__((__nonnull__(1,2)));
   






























 
#pragma __scanf_args
extern __declspec(__nothrow) int _fscanf(FILE * __restrict  ,
                     const char * __restrict  , ...) __attribute__((__nonnull__(1,2)));
   



 
#pragma __scanf_args
extern __declspec(__nothrow) int scanf(const char * __restrict  , ...) __attribute__((__nonnull__(1)));
   






 
#pragma __scanf_args
extern __declspec(__nothrow) int _scanf(const char * __restrict  , ...) __attribute__((__nonnull__(1)));
   



 
#pragma __scanf_args
extern __declspec(__nothrow) int sscanf(const char * __restrict  ,
                    const char * __restrict  , ...) __attribute__((__nonnull__(1,2)));
   








 
#pragma __scanf_args
extern __declspec(__nothrow) int _sscanf(const char * __restrict  ,
                     const char * __restrict  , ...) __attribute__((__nonnull__(1,2)));
   



 

 
extern __declspec(__nothrow) int vfscanf(FILE * __restrict  , const char * __restrict  , __va_list) __attribute__((__nonnull__(1,2)));
extern __declspec(__nothrow) int vscanf(const char * __restrict  , __va_list) __attribute__((__nonnull__(1)));
extern __declspec(__nothrow) int vsscanf(const char * __restrict  , const char * __restrict  , __va_list) __attribute__((__nonnull__(1,2)));

extern __declspec(__nothrow) int _vfscanf(FILE * __restrict  , const char * __restrict  , __va_list) __attribute__((__nonnull__(1,2)));
extern __declspec(__nothrow) int _vscanf(const char * __restrict  , __va_list) __attribute__((__nonnull__(1)));
extern __declspec(__nothrow) int _vsscanf(const char * __restrict  , const char * __restrict  , __va_list) __attribute__((__nonnull__(1,2)));

extern __declspec(__nothrow) int vprintf(const char * __restrict  , __va_list  ) __attribute__((__nonnull__(1)));
   





 
extern __declspec(__nothrow) int _vprintf(const char * __restrict  , __va_list  ) __attribute__((__nonnull__(1)));
   



 
extern __declspec(__nothrow) int vfprintf(FILE * __restrict  ,
                    const char * __restrict  , __va_list  ) __attribute__((__nonnull__(1,2)));
   






 
extern __declspec(__nothrow) int vsprintf(char * __restrict  ,
                     const char * __restrict  , __va_list  ) __attribute__((__nonnull__(1,2)));
   






 

extern __declspec(__nothrow) int vsnprintf(char * __restrict  , size_t  ,
                     const char * __restrict  , __va_list  ) __attribute__((__nonnull__(3)));
   







 

extern __declspec(__nothrow) int _vsprintf(char * __restrict  ,
                      const char * __restrict  , __va_list  ) __attribute__((__nonnull__(1,2)));
   



 
extern __declspec(__nothrow) int _vfprintf(FILE * __restrict  ,
                     const char * __restrict  , __va_list  ) __attribute__((__nonnull__(1,2)));
   



 
extern __declspec(__nothrow) int _vsnprintf(char * __restrict  , size_t  ,
                      const char * __restrict  , __va_list  ) __attribute__((__nonnull__(3)));
   



 
extern __declspec(__nothrow) int fgetc(FILE *  ) __attribute__((__nonnull__(1)));
   







 
extern __declspec(__nothrow) char *fgets(char * __restrict  , int  ,
                    FILE * __restrict  ) __attribute__((__nonnull__(1,3)));
   










 
extern __declspec(__nothrow) int fputc(int  , FILE *  ) __attribute__((__nonnull__(2)));
   







 
extern __declspec(__nothrow) int fputs(const char * __restrict  , FILE * __restrict  ) __attribute__((__nonnull__(1,2)));
   




 
extern __declspec(__nothrow) int getc(FILE *  ) __attribute__((__nonnull__(1)));
   







 




    extern __declspec(__nothrow) int (getchar)(void);

   





 
extern __declspec(__nothrow) char *gets(char *  ) __attribute__((__nonnull__(1)));
   









 
extern __declspec(__nothrow) int putc(int  , FILE *  ) __attribute__((__nonnull__(2)));
   





 




    extern __declspec(__nothrow) int (putchar)(int  );

   



 
extern __declspec(__nothrow) int puts(const char *  ) __attribute__((__nonnull__(1)));
   





 
extern __declspec(__nothrow) int ungetc(int  , FILE *  ) __attribute__((__nonnull__(2)));
   






















 

extern __declspec(__nothrow) size_t fread(void * __restrict  ,
                    size_t  , size_t  , FILE * __restrict  ) __attribute__((__nonnull__(1,4)));
   











 

extern __declspec(__nothrow) size_t __fread_bytes_avail(void * __restrict  ,
                    size_t  , FILE * __restrict  ) __attribute__((__nonnull__(1,3)));
   











 

extern __declspec(__nothrow) size_t fwrite(const void * __restrict  ,
                    size_t  , size_t  , FILE * __restrict  ) __attribute__((__nonnull__(1,4)));
   







 

extern __declspec(__nothrow) int fgetpos(FILE * __restrict  , fpos_t * __restrict  ) __attribute__((__nonnull__(1,2)));
   








 
extern __declspec(__nothrow) int fseek(FILE *  , long int  , int  ) __attribute__((__nonnull__(1)));
   














 
extern __declspec(__nothrow) int fsetpos(FILE * __restrict  , const fpos_t * __restrict  ) __attribute__((__nonnull__(1,2)));
   










 
extern __declspec(__nothrow) long int ftell(FILE *  ) __attribute__((__nonnull__(1)));
   











 
extern __declspec(__nothrow) void rewind(FILE *  ) __attribute__((__nonnull__(1)));
   





 

extern __declspec(__nothrow) void clearerr(FILE *  ) __attribute__((__nonnull__(1)));
   




 

extern __declspec(__nothrow) int feof(FILE *  ) __attribute__((__nonnull__(1)));
   


 
extern __declspec(__nothrow) int ferror(FILE *  ) __attribute__((__nonnull__(1)));
   


 
extern __declspec(__nothrow) void perror(const char *  );
   









 

extern __declspec(__nothrow) int _fisatty(FILE *   ) __attribute__((__nonnull__(1)));
    
 

extern __declspec(__nothrow) void __use_no_semihosting_swi(void);
extern __declspec(__nothrow) void __use_no_semihosting(void);
    





 











#line 948 "C:\\Keil_v4\\ARM\\ARMCC\\bin\\..\\include\\stdio.h"



 

#line 8 "main.c"
#line 1 "DES_M0_SoC.h"




typedef unsigned       char uint8;
typedef   signed       char  int8;
typedef unsigned short int  uint16;
typedef   signed short int   int16;
typedef unsigned       int  uint32;
typedef   signed       int   int32;

#pragma anon_unions
typedef struct {
	union {
		volatile uint8   RxData;
		volatile uint32  reserved0;
	};
	union {
		volatile uint8   TxData;
		volatile uint32  reserved1;
	};
	union {
		volatile uint8   Status;
		volatile uint32  reserved2;
	};
	union {
		volatile uint8   Control;
		volatile uint32  reserved3;
	};
} UART_t;












typedef struct {
	union {
		volatile uint32	Enable;
		volatile uint32	reserved0;
	};
	volatile uint32		reserved1[0x20-1];  
	union {
		volatile uint32	Disable;
		volatile uint32	reserved2;
	};
} NVIC_t;




typedef struct {
	union {
		volatile uint16  LED;
		volatile uint32  reserved0;
	};
	union {
		volatile uint16  NotConnected;
		volatile uint32  reserved1;
	};
	union {
		volatile uint16  Switches;
		volatile uint32  reserved2;
	};
	union {
		volatile uint16  Buttons;
		volatile uint32  reserved3;
	};
} GPIO_t;

typedef struct {
	union {
		volatile uint16  xpos;
		volatile uint32  reserved0;
	};
	union {
		volatile uint16  ypos;
		volatile uint32  reserved1;
	};
	union {
		volatile uint16  zpos;
		volatile uint32  reserved2;
	};
	union {
		volatile uint16  background;
		volatile uint32  reserved3;
	};
	union {
		volatile uint16  point;
		volatile uint32  reserved4;
	};
	union {
		volatile uint8   sw_ctrl;
		volatile uint32  reserved5;
	};
} VGA_t;

typedef struct {
	union {
		volatile uint8  write;
		volatile uint32  reserved0;
	};
	union {
		volatile uint8 CS; 
		volatile uint32  reserved1;
	};
	union {
		volatile uint8  read;
		volatile uint32  reserved2;
	};
	union {
		volatile uint8 ready; 
		volatile uint32  reserved3;
	};
} SPI_t;

typedef struct{
	volatile uint32  number;

	union {
		volatile uint8 decimal; 
		volatile uint32  reserved3;
	};
} SEG_t;


#line 141 "DES_M0_SoC.h"


#line 9 "main.c"

#line 19 "main.c"








typedef struct{
		int16 x;
		int16 y;
		int16 z;
} Vector_int;

typedef struct{
		float x;
		float y;
		float z;
} Vector_float;



volatile uint8  counter  = 0; 
volatile uint8  BufReady = 0; 
volatile uint8  RxBuf[100];




void UART_ISR()
{
	char c;
	c = ((UART_t *)0x51000000)->RxData;	 
	RxBuf[counter]  = c;   
	counter++;             
	((UART_t *)0x51000000)->TxData = c;   
	
	
	
	
	if (counter == 100-1 || c == '\r')  {
		counter--;							
		RxBuf[counter] = 0;  
		BufReady       = 1;	    
	}
}








void wait_n_loops(uint32 n) {
	volatile uint32 i;
		for(i=0;i<n;i++);
}




void writeSPI(uint8 data) {
	((SPI_t *)0x53000000)->write = data;
	while(!(((SPI_t *)0x53000000)->ready));
}

uint8 readSPI() {
	uint8 val = ((SPI_t *)0x53000000)->read;
	
	return val;
}





void writeAccelerometer(uint8 address, uint8 d_byte) {
	(((SPI_t *)0x53000000)->CS) = 1;
	(((SPI_t *)0x53000000)->CS) = 0;
	writeSPI(0x0A);
	writeSPI(address);
	writeSPI(d_byte);
	(((SPI_t *)0x53000000)->CS) = 1;
}

uint8 readAccelerometer(uint8 address) {
	(((SPI_t *)0x53000000)->CS) = 1;
	(((SPI_t *)0x53000000)->CS) = 0;
	writeSPI(0x0B);
	writeSPI(address);
	writeSPI(0xFF);
	(((SPI_t *)0x53000000)->CS) = 1;

	return readSPI();
}





void update_from_switches(uint16 switches, uint16* range,
													uint16* sensitivity, uint16* pause_sw){
	uint16 bg_r = (switches & 0xE000) >> 4; 
	uint16 bg_g = (switches & 0x1C00) >> 5; 
	uint16 bg_b = (switches & 0x0380) >> 6; 
	
	uint16 cube_r = (switches & 0x0040) ? 0x0F00 : 0x0000; 
  uint16 cube_g = (switches & 0x0020) ? 0x00F0 : 0x0000; 
	uint16 cube_b = (switches & 0x0010) ? 0x000F : 0x0000; 
	
	((VGA_t *)0x52000000)->background = 0x0000 | bg_r | bg_g | bg_b; 
	((VGA_t *)0x52000000)->point = 0x0000 | cube_r | cube_g | cube_b; 

	switch(switches&0x000E){ 
		
		
		case 0x0000:	*range=0x0003; *sensitivity = 1; break;
		
		case 0x0002:	*range=0x0003; *sensitivity = 2; break;

		
		case 0x0004:	*range=0x0001; *sensitivity = 1; break;
		
		case 0x0006:	*range=0x0001; *sensitivity = 2; break;

		
		case 0x0008:	*range=0x0000; *sensitivity = 1; break;
		
		default:		  *range=0x0000; *sensitivity = 1; break;
	}

	*pause_sw = switches&0x0001; 
}




void configureAccelerometer(Vector_int* offset){
	writeAccelerometer(0x2C, 0x12); 
	writeAccelerometer(0x2D, 0x02); 
	
	
	
	offset->x = (readAccelerometer(0x11)<<8)+readAccelerometer(0x10);
	offset->y = (readAccelerometer(0x0F)<<8)+readAccelerometer(0x0E);
	offset->z = (readAccelerometer(0x13)<<8)+readAccelerometer(0x12);
}




int main(void) {
	uint16 sensitivity = 1, range, pause_sw; 
  	uint16 i = 0;
	uint16 cube_width = 5;
	uint16 temperature;
	uint32 hextemp;
	uint8 hexcount;
	
	Vector_int offset;

	Vector_int ACC;
	Vector_int ACC_new;
	Vector_float VEL;
	Vector_float POS;

  
	ACC.x=0;
	ACC.y=0;
	ACC.z=0;

  
  VEL.x=0;
	VEL.y=0;
	VEL.z=0;

  
  POS.x=0.5*1280;
	POS.y=0.5*1024;
	POS.z=5;
	
	((VGA_t *)0x52000000)->sw_ctrl = 0; 
	
	wait_n_loops(20);						
	printf("\r\nWelcome to BALANCE\r\n");			

	configureAccelerometer(&offset);
	
	while(1){			

		update_from_switches(((GPIO_t *)0x50000000)->Switches, &range, &sensitivity, &pause_sw);
		
    
    writeAccelerometer(0x2C,((uint8)range>>6)|0x12);

		
		wait_n_loops(20);

		if(pause_sw == 0){ 
			
			ACC_new.x = -((readAccelerometer(0x11)<<8)+readAccelerometer(0x10)-offset.x)*sensitivity;
			ACC_new.y = ((readAccelerometer(0x0F)<<8)+readAccelerometer(0x0E)-offset.y)*sensitivity;
			ACC_new.z = ((readAccelerometer(0x13)<<8)+readAccelerometer(0x12)-offset.z)*sensitivity;
			
			
		  
			
			
			ACC.x = ACC.x*(1-0.025) + 0.025*(ACC_new.x);
			ACC.y = ACC.y*(1-0.025) + 0.025*(ACC_new.y);
			ACC.z = ACC.z*(1-0.025) + 0.025*(ACC_new.z);
			
			POS.x = ACC.x + 1280 / 2;
			POS.y = ACC.y + 1024 / 2;
			POS.z = ACC.z + 500 / 2;
		
			cube_width = POS.z/2;

	    
			
	    if (POS.x+cube_width > 1280){ 
	      POS.x=1280-cube_width;
	    }
	    if (POS.x+cube_width < 0){ 
	      POS.x=0+cube_width;
	    }
	    if (POS.y+cube_width > 1024){ 
	      POS.y=1024-cube_width;
	    }
	    if (POS.y+cube_width < 0){ 
	      POS.y=0+cube_width;
	    }

			if (POS.z > 500){ 
				POS.z=500;
			}
			if (POS.z < 5){ 
				POS.z=5;
			}

	    if(i>=(2000/1)){
	       printf("Acceleration, ACC.x: %d, \tACC.y: %d, \tACC.z: %d, \r\n",ACC.x, ACC.y, ACC.z);
	       printf("Velocity, VEL.x: %f, \tVEL.y: %f, \tVEL.z: %f, \r\n",VEL.x, VEL.y, VEL.z);
	       printf("Position, POS.x: %f, \tPOS.y: %f, \tPOS.z: %f, \r\n",POS.x, POS.y, POS.z);
				i=0;
				
				 temperature = (readAccelerometer(0x15)<<8)+readAccelerometer(0x14);
				
				 hextemp = 0;
				 hexcount = 0;
				 while(temperature != 0) {
					 hextemp += (temperature % 10) << (hexcount * 4);
					 hexcount++;
					 temperature /= 10;
				 }
				 
				 while(hexcount < 8) {
					 hextemp += (0xF << (hexcount * 4));
					 hexcount++;
				 }
				
				 ((SEG_t *)0x54000000)->number = (0xFFFFFFFF & hextemp);
				 
				 printf("Temperature, %x\r\n",	hextemp);
			}
			else{
				i++;
			}
			
			((VGA_t *)0x52000000)->xpos = (uint16)POS.x;
			((VGA_t *)0x52000000)->ypos = (uint16)POS.y;
			((VGA_t *)0x52000000)->zpos = (uint16)POS.z;
    }
  }
}
