;TRIG IS PB3
;ECHO IS PB4
;I USED TIMER1 FOR DETECTING EDGES

				
				
				AREA		sdata,DATA,READONLY
				THUMB				

MSG2			DCB			0x0D
				DCB			"distance (mm):"
				DCB			0x04

				
TIMER1_RIS		EQU 		0x4003101C
GPIO_PORTB_DATA EQU 		0x400053FC	
TIMER1_TAR		EQU			0x40031048
TIMER1_ICR		EQU		 	0x40031024		

				AREA		main,CODE,READONLY
				THUMB
				EXTERN		measurement_init		
				EXTERN		convrt					;converts hex to dec as in lab1
				EXTERN		OutStr
				EXTERN 		trig
				EXPORT		__main
__main
				BL			measurement_init		;PB4 pin starts work for measuring data
				
				LDR			R1,=TIMER1_RIS			;i will use r1 to detect edge
				LDR			R2,=TIMER1_ICR			;i will clear CAERIS bit using r2
				LDR			R3,=TIMER1_TAR			;i will read timer value from r3
				LDR			R8,=GPIO_PORTB_DATA	;i will read input value from r11
				
first_edge		
				BL			measurement_init
				LDR			R0,[R1]					
				ANDS		R0,R0,#0x04				;interrupt occurs?
				BEQ			first_edge				
				LDR			R0,[R8]					
				SUBS		R0,R0,#0x10				;input is high?
				BNE			first_edge				;								 _____
				LDR			R6,[R3]					;record first time			____|
				ORR			R0,#0x04				
				STR			R0,[R2]					;clear interrupt
				
second_edge		LDR			R0,[R1]
				ANDS		R0,R0,#0x04				;interrupt occurs?
				BEQ			second_edge				;								  _____
				LDR			R7,[R3]					;record second time			_____|	   |___
				ORR			R0,#0x04				
				STR			R0,[R2]					;clear interrupt
				


				MOV 		R0,#0x10      			;16 clock makes 1us
       				
				LDR			R5,=MSG2				
				BL			OutStr
				SUB 		R4,R6,R7  				;pulse width (2.edge - 1.edge)
				MOV		 	R9,#83
				MUL		 	R4,R4,R9
				MOV		 	R9,#100
				UDIV	 	R4,R4,R9				;0.83 is for error. I explained it in lab work
				UDIV 	 	R4,R4,R0
				MOV			R9,#10
				MUL			R4,R4,R9
				MOV		 	R9,#48					;for converting mm (question 3)
				UDIV		R4,R4,R9
		
				BL		 	convrt          
				BL   	 	OutStr  
				
			
				B			first_edge				;for continuos measurement
				END