
			AREA			routines,CODE,READONLY
			THUMB
			EXPORT 			convrt
				
convrt		PROC
			PUSH			{R0-R4}
			LDR				R5,=0x20000400
			LDR				R0,=0x0A
			LDR				R1,=0x04
			PUSH			{R1}
			
;Firstly i pointed a memory location to store my result.
;Later i used stack and firstly pushed my ending character into it.

loop		UDIV			R2,R4,R0
			MUL				R3,R2,R0
			SUB				R1,R4,R3
			ADD 			R1,#'0'
			PUSH			{R1}
			UDIV			R4,R0
			CMP				R2,#0
			BNE				loop
			
;I divided R4 value to 10 and stored the remainder with ascii value of it.
;Then i pushed this value until there is no remainder left.
			
			LDR				R1,=0x20000400
lp2			POP				{R2}
			STRB			R2,[R1],#1
			CMP				R2,#0x04
			BEQ				done
			B				lp2
			
;I red stack values one by one and stored it to memory location i pointed 
;I incremented this value byte by byte not 4 bytes each time 
;And when reached the ending character i stopped storing and finished loop
			
done		nop
			POP			{R0-R4}
			BX 				LR
			