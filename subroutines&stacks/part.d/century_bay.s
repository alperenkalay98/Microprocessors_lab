				AREA		routines,CODE,READONLY
				THUMB
				EXPORT		century_bay
				
century_bay		PROC
				LDR			R6,[R0]
				CMP			R6,#0
				BEQ			not_do
				MOV			R7,R6
				BFI			R9,R7,#0,#1
				CMP			R9,#0
				BNE			not_do
				LDR			R7,=0x064
				CMP			R6,R7
				BMI			not_do
				LDR			R7,=0x02F
				SUB			R6,R6,R7
				STR			R6,[R1],#4


not_do			nop
				BX			LR
				
