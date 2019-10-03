; Demo Program - using timer interrupts.
; Written for ADuC841 evaluation board, with UCD extras.
; Brian Mulkeen, September 2016

; Include the ADuC841 SFR definitions
$NOMOD51
$INCLUDE (MOD841)

LED     EQU     P3.4      ; P3.4 is red LED on eval board
SSTATE  EQU 	5eh		  ; switch swtate is now 5e memory address byte
	
CSEG
		ORG		0000h		; set origin at start of code segment
		JMP		MAIN		; jump to main program

		ORG		002Bh		; timer 2 interrupt address
		JMP		T2ISR		; jump to interrupt handler
 
		ORG		0060h		; set origin above interrupt addresses	

MYTABLE: 	DW 		10240, 37888, 51712, 58624, 62080, 62771, 63023, 63324, 63561, 63693, 63910, 64081, 64219, 64279, 64384, 64430
; Define frequency LUT

MAIN:	
; ------ Setup part - happens once only ----------------------------
		MOV 	T2CON, #04h	; timer 2 in timer mode only
		MOV		IE, #0b0h	; enable timer 2 interrupt

; ------ Loop forever (in this example, doing nothing) -------------
LOOP:	CPL   LED     	; change state of red LED
		CALL  DELAY   	; call software delay routine
		JMP		LOOP	; check switches and delay
		
		
; ------ Interrupt service routine ---------------------------------	
T2ISR:		; timer 0 overflow interrupt service routine
		CPL		P3.6  		; flip bit to generate output
		CLR 	TF2			; clear interrupt flag
		RETI				; return from interrupt
;____________________________________________________________________
                                                        ; SUBROUTINES
DELAY:    ; delay for time A x 10 ms.  A is not changed. 
			MOV	  R5, #50		; repeat for 500ms
DLY2:   	MOV   R7, #55		; middle loop repeats 55 times
DLY1:   	MOV   R6, #251   	; inner loop repeats 251 times
DLY3:		MOV	  A,  P2		; read ports : 1 cycle
			CJNE  A, SSTATE, UDFRQ 	; jump if inputs have changed : 4 cycles
DDLY3:     	DJNZ  R6, DLY3		; 3 cycles : 8 total x 251 cycles = 2008 cycles
        	DJNZ  R7, DLY1		; + 2 to reload, x 55 = 110550 cycles
			DJNZ  R5, DLY2		; + 2 to reload = 110552 cycles = 9.9964 ms
        	RET

UDFRQ:
		MOV   SSTATE, A ; copy port to memory
		
		; set the frequency
		ANL   A, #0fh	; only lower four bits
		RL 	  A			; multiply by 2
		MOV   DPTR, #0060h; move the FREQ memory address to DPTR
		MOV   R0, A		; copy offset to R0
		MOVC  A, @A+DPTR; get higher byte
		MOV   RCAP2H, A ; move higher byte to timer high reload
		MOV   A, R0		; reload the offset
		INC   A			; get the lower byte offset
		MOVC  A, @A+DPTR; get lower byte
		MOV   RCAP2L, A ; move lower byte to timer low reload
		
		; set interrupt enable
		MOV   C, P2.4	; load interrupt enable switch
		MOV	  IE.7, C	; switch the interrupt

		JMP   DDLY3		; jump back to decrement
END