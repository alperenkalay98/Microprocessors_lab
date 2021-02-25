				AREA		routines,CODE,READONLY
				THUMB
				EXPORT		seventh_town
				
seventh_town	PROC
				LDR			R6,[R0]
				CMP			R6,#0
				BEQ			not_do
				
				LDR			R7,=0x0B
				UDIV		R8,R6,R7
				MUL			R9,R8,R7
				SUBS		R9,R6,R9
				BNE			not_do
				
				LDR			R7,=0x07
				UDIV		R8,R6,R7
				MUL			R9,R8,R7
				SUB			R6,R9
				STR			R6,[R1],#4
								
not_do			nop
				BX			LR
				