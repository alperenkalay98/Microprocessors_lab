;This was my convrt subroutine but i created new .s file
;and changed it so that it produces 'x.yz' type output 
			AREA			routines,CODE,READONLY
			THUMB
			EXPORT 			convrt_to_volt_range
				
convrt_to_volt_range	PROC
			PUSH			{R0-R4}			
			LDR				R5,=0x20000400
			LDR				R1,=0x04			;pushed end char to stop
			PUSH			{R1}	
			
			mov				r0,#10			
			udiv			r1,r4,r0
			mul				r1,r1,r0
			sub				r1,r4,r1
			add				r1,r1,'0'
			push			{r1}				;push last digit
			
			mov				r0,#100
			udiv			r1,r4,r0
			mul				r1,r1,r0
			sub				r1,r4,r1
			mov				r0,#10
			udiv			r1,r1,r0
			add				r1,r1,'0'
			push			{r1}			    ;push middle digit
			
			ldr				r1,=0x2E
			push			{r1}				;push '.'
			
			mov				r0,#100
			udiv			r1,r4,r0
			add				r1,r1,'0'
			push			{r1}				;push first digit 
			
			
			LDR				R1,=0x20000400		;pop until reach 0x04
lp2			POP				{R2}
			STRB			R2,[R1],#1
			CMP				R2,#0x04
			BEQ				done
			B				lp2
			

done		nop
			POP			{R0-R4}
			BX 				LR