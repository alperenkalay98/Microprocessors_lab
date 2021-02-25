				AREA		routines,CODE,READONLY
				THUMB
				EXPORT		humble_ville
				
humble_ville	PROC
				LDR			R6,[R0]
				CMP			R6,#0
				BEQ			not_do
				
				LDR			R7,=0x0A
				CMP			R6,R7
				BMI			not_do
				LDR			R7,=0x03
				UDIV		R8,R6,R7
				MUL			R9,R8,R7
				SUBS		R9,R6,R9
				BNE			not_do
				
				MOV			R11,R6
				LDR			R7,=0x2E
				PUSH		{R7}
				LDR			R7,=0x0A
lp				UDIV		R8,R11,R7
				MUL			R9,R8,R7
				SUB			R12,R11,R9
				PUSH		{R12}
				UDIV		R11,R7
				CMP			R8,#0
				BNE			lp
				
				LDR			R7,=0x200007FE
lp2				POP			{R8}
				STRB		R8,[R7],#1
				CMP			R8,#0x2E
				BEQ			done
				B			lp2	
				
done			LDR			R7,=0x01
				LDR			R8,=0x01
				LDR			R9,=0x200007FE
mul_digit		MUL			R7,R7,R8
				LDRB		R8,[R9],#1
				CMP			R8,#0
				BEQ			not_do
				CMP			R8,#0x2E
				BNE			mul_digit
				
				CMP			R7,#0x04
				BEQ			not_do
				SUB			R6,R7
				STR			R6,[R1],#4


not_do			nop
				BX			LR
				