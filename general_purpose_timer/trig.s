GPIO_PORTB_DATA 	EQU 	0x400053FC
					
					AREA		subrotine,CODE,READONLY
					THUMB
					EXPORT		trig
trig				
					PUSH {R0,R1,LR}
					LDR		R1,=GPIO_PORTB_DATA		;trigger pulse for HC-SR04
					MOV		R0,#0x00
					STR		R0,[R1]					
					LDR		R2,=0x140
delay				NOP								;low with delay
					SUBS	R2,#1
					BNE		delay
					MOV		R0,#0x08
					STR		R0,[R1]
					LDR		R2,=0x140
delay2				NOP								;high with delay
					SUBS	R2,#1
					BNE		delay2					
					MOV		R0,#0x00				;low for rest
					STR		R0,[R1]	
					PUSH {R0,R1,LR}
					BX		LR