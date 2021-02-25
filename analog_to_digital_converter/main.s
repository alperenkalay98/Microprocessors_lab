ADC0_RIS		EQU		0x40038004
ADC0_SSFIFO3	EQU		0x400380A8
ADC0_PSSI		EQU		0x40038028
ADC0_ISC		EQU		0x4003800C
	
	
				AREA	sdata,CODE,READONLY
				THUMB
inp_info		DCB		"Please insert reference angle with '.' at the end --> ex. insert 120. instead of 120"
				DCB		0x0D
				DCB		0x04
			
MSG				DCB		0x0D
				DCB		"Error Voltage:"
				DCB		0x04
	
				
				AREA	main,CODE,READONLY
				THUMB
				EXTERN	convrt_to_volt_range
				EXTERN	OutStr
				EXTERN	InChar
				EXTERN	inits
				EXTERN  neg_conv
				EXPORT	__main
__main		
				
				LDR		R5,=inp_info
				BL 		OutStr
				LDR		R0,=0x2E
				PUSH	{R0}
get_input		BL		InChar
				CMP		R5,R0
				BEQ		to_hex
				SUB		R5,#'0'
				PUSH	{R5}
				B		get_input

;after i got input, i convert it to hex						
to_hex			POP		{R2}
				LDR		R1,=0x0A
				MOV		R6,R1
hex_done		POP		{R3}
				CMP		R3,R0
				BEQ		go
				MUL		R3,R1
				ADD		R2,R3		;R2 has the hex value of reference angle
				MUL		R1,R6
				B		hex_done


go			
				MOV		R0,#0x14A			;ex. r2=120  --> 110  --> (1.10v). (from angle to voltage value)
				MUL		R2,R2,R0			
				MOV		R0,#0x168			;360 in hex
				UDIV	R2,R2,R0			;ex. R2=210 --> (2.10v)

				BL		inits	
				LDR		R6,=ADC0_RIS		;interrupt status
				LDR		R7,=ADC0_SSFIFO3	;fifo result
				LDR		R8,=ADC0_PSSI		;sequence address to initiate
				LDR		R9,=ADC0_ISC		;for interrupt clear	
			


loop			
				LDR		R0,=0x003D08A0		;slightly less than 4000000 in hex (4000000x4=16MHz)
delay1s			nop							;(i know its not good solution to 1Hz, i will change it to systick if i can)	
				SUBS	R0,#1				;it is slightly less than 4000000 because rest of the procedure also
				BNE		delay1s				;takes a little time to print. It is nearly 1 second to print every time.
				
				LDR		R0,[R8]				
				ORR		R0,R0,#0x08
				STR		R0,[R8]				;initiated sampling
check			LDR		R0,[R6]
				ANDS	R0,#0x08
				BEQ		check				;check interrupt status
				LDR		R3,[R7]				;;if data can be read,store it in R3
				MOV		R0,#8
				STR		R0,[R9]				;clear interrupt 
						
				
				MOV		R0,#0x14A			;ex. r3=240  (2.40 v)
				MUL		R3,R3,R0			
				MOV		R0,#0x0FFF
				UDIV	R3,R3,R0
				
				SUBS	R4,R2,R3		
				BPL		pos_print			;ref > Vo							
				SUBS	R4,R3,R2			
				BPL		neg_print			;Vo > ref
				
				
neg_print		LDR		R5,=MSG				;negative error
				BL		OutStr
				BL		neg_conv	
				BL		OutStr
				B		loop				;for continuous loop


pos_print		LDR		R5,=MSG				;positive error
				BL		OutStr
				BL		convrt_to_volt_range	
				BL		OutStr
				B		loop				;for continuous loop
				
				END