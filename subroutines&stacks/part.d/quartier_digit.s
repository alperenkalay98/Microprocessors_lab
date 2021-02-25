				AREA		routines,CODE,READONLY
				THUMB
				EXPORT		quartier_digit
				
quartier_digit	PROC
				LDR			R6,[R0]
				CMP			R6,#0
				BEQ			not_do
				LDR			R7,=0x64
				CMP			R6,R7
				BMI			not_do
				LDR			R7,=0x3E7
				CMP			R7,R6
				BMI			not_do
				LDR			R7,=0x05
				UDIV		R8,R6,R7
				MUL			R9,R8,R7
				SUBS		R9,R6,R9
				BNE			not_do
				
				MOV			R11,R6
				LDR			R3,=0x200007FD			
				LDR			R7,=0x0A
lp				UDIV		R8,R11,R7
				MUL			R9,R8,R7
				SUB			R12,R11,R9
				STRB		R12,[R3],#1
				UDIV		R11,R7
				CMP			R8,#0
				BNE			lp
				LDR			R3,=0x200007FD
				LDR			R7,[R3]
				
				CMP			R6,R7
				BMI			not_do
				SUB			R6,R7
				STR			R6,[R1],#4

not_do			nop				
				BX			LR
				