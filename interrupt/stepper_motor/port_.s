PB_IN				EQU		0x4000503C
PB_OUT				EQU		0x400053C0
GPIO_PORTB_DIR		EQU		0x40005400
GPIO_PORTB_AFSEL	EQU		0x40005420
GPIO_PORTB_DEN		EQU		0x4000551C
SYSCTL_RCGCGPIO		EQU		0x400FE608
GPIO_PORTB_PDR		EQU		0x40005514
GPIO_PORTB_GPIODR8R EQU     0x40005508


					AREA	ports,READONLY,CODE,ALIGN=2
					THUMB
						
					EXPORT  ports_init

ports_init			PROC
					LDR		R1,=SYSCTL_RCGCGPIO
					LDR		R0,[R1]
					ORR		R0,R0,#0x02
					STR		R0,[R1]
					nop
					nop
					nop
										
					LDR		R1,=GPIO_PORTB_DIR
					LDR		R0,[R1]
					ORR		R0,R0,#0xF0
					BIC		R0,R0,#0x0F
					STR		R0,[R1]
					
					LDR		R1,=GPIO_PORTB_AFSEL
					LDR		R0,[R1]
					BIC		R0,#0xFF
					STR		R0,[R1]
					
					LDR		R1,=GPIO_PORTB_DEN
					LDR		R0,[R1]
					ORR		R0,#0xFF
					STR		R0,[R1]
					
					LDR		R1,=GPIO_PORTB_PDR
					LDR		R0,=0x0F
					STR		R0,[R1]
					
					LDR		R1,=GPIO_PORTB_GPIODR8R
					LDR		R0,=0xF0
					STR		R0,[R1]				
										
					LDR		R6,=0x10					
					LDR		R7,=PB_OUT
					STR		R6,[R7]					
	
					
					BX		LR
					ENDP